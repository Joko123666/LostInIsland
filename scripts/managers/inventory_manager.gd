extends Node

signal inventory_changed
signal item_added(item_id: String, amount: int)
signal item_removed(item_id: String, amount: int)
signal carry_weight_changed(current_weight: float, carry_capacity: float)
signal tool_condition_changed(item_id: String, remaining: int, maximum: int)

const BASE_CARRY_CAPACITY := 12.0
const PARTNER_CARRY_CAPACITY := 9.0
const DEFAULT_ITEM_WEIGHT := 0.05
const OWNER_PLAYER := "player"
const OWNER_PARTNER := "partner"
const STARTING_GUIDE_ITEM_ID := "survival_guide"
const STARTING_CHOICE_ITEM_IDS := [
	"survival_axe",
	"medkit",
	"handheld_game",
	"lighter"
]

var items: Dictionary = {}
var partner_items: Dictionary = {}
var item_definitions: Dictionary = {}
var tool_durability: Dictionary = {}
var partner_tool_durability: Dictionary = {}
var item_order: Array[String] = []
var partner_item_order: Array[String] = []
var pending_item_messages: Array[String] = []


func _ready() -> void:
	load_item_definitions()
	reset_state()


func reset_state() -> void:
	items = {
		"berry": 2,
		"water": 1,
		STARTING_GUIDE_ITEM_ID: 1
	}
	partner_items.clear()
	item_order = ["berry", "water", STARTING_GUIDE_ITEM_ID]
	partner_item_order.clear()
	tool_durability.clear()
	partner_tool_durability.clear()
	pending_item_messages.clear()
	emit_signal("inventory_changed")
	_emit_carry_weight_changed()


func load_item_definitions() -> void:
	item_definitions.clear()
	var dir := DirAccess.open("res://data/items")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var item = load("res://data/items/%s" % file_name)
			if item != null and item.id != "":
				item_definitions[item.id] = item
		file_name = dir.get_next()
	dir.list_dir_end()


func get_item_data(item_id: String):
	return item_definitions.get(item_id, null)


func add_item(item_id: String, amount: int = 1, owner_id: String = OWNER_PLAYER) -> int:
	if amount <= 0:
		return 0
	var addable := get_addable_amount(item_id, amount, owner_id)
	if addable <= 0:
		return 0
	var target_items := get_items(owner_id)
	target_items[item_id] = int(target_items.get(item_id, 0)) + addable
	_touch_item_order(item_id, owner_id)
	_ensure_tool_durability(item_id, owner_id)
	emit_signal("item_added", item_id, addable)
	emit_signal("inventory_changed")
	_emit_carry_weight_changed()
	return addable


func add_item_to_party(item_id: String, amount: int = 1, allow_partner: bool = true) -> int:
	var added := add_item(item_id, amount, OWNER_PLAYER)
	var remaining := amount - added
	if remaining > 0 and allow_partner and can_access_partner_inventory():
		added += add_item(item_id, remaining, OWNER_PARTNER)
	return added


func remove_item(item_id: String, amount: int = 1, owner_id: String = OWNER_PLAYER) -> bool:
	if amount <= 0:
		return true
	if get_count(item_id, owner_id) < amount:
		return false
	var target_items := get_items(owner_id)
	var target_durability := _tool_durability_for_owner(owner_id)
	target_items[item_id] = get_count(item_id, owner_id) - amount
	if int(target_items[item_id]) <= 0:
		target_items.erase(item_id)
		_remove_item_from_order(item_id, owner_id)
		target_durability.erase(item_id)
	else:
		_ensure_tool_durability(item_id, owner_id)
	emit_signal("item_removed", item_id, amount)
	emit_signal("inventory_changed")
	_emit_carry_weight_changed()
	return true


func transfer_item(item_id: String, amount: int, from_owner: String, to_owner: String) -> Dictionary:
	var source_owner := _normalize_owner(from_owner)
	var target_owner := _normalize_owner(to_owner)
	if source_owner == target_owner:
		return _fail("이미 같은 소지품 영역에 있다.")
	if item_id == "":
		return _fail("옮길 물건이 없다.")
	var owned_amount := get_count(item_id, source_owner)
	if owned_amount <= 0:
		return _fail("%s에게 옮길 물건이 없다." % get_owner_display_name(source_owner))
	var requested := clampi(amount, 1, owned_amount)
	var move_amount := get_addable_amount(item_id, requested, target_owner)
	if move_amount <= 0:
		return _fail("%s의 짐이 너무 무겁다." % get_owner_display_name(target_owner))
	var item = get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var source_durability := _tool_durability_for_owner(source_owner)
	var target_durability := _tool_durability_for_owner(target_owner)
	var carried_durability := int(source_durability.get(item_id, get_tool_max_durability(item_id)))
	if not remove_item(item_id, move_amount, source_owner):
		return _fail("옮길 물건이 부족하다.")
	var added := add_item(item_id, move_amount, target_owner)
	if added <= 0:
		add_item(item_id, move_amount, source_owner)
		return _fail("%s의 짐이 너무 무겁다." % get_owner_display_name(target_owner))
	if item != null and _is_durable_tool(item):
		target_durability[item_id] = carried_durability
		if get_count(item_id, source_owner) <= 0:
			source_durability.erase(item_id)
	return {
		"ok": true,
		"text": "%s x%d을/를 %s에게 옮겼다." % [display_name, added, get_owner_display_name(target_owner)],
		"item_id": item_id,
		"amount": added,
		"from_owner": source_owner,
		"to_owner": target_owner
	}


func get_count(item_id: String, owner_id: String = OWNER_PLAYER) -> int:
	return int(get_items(owner_id).get(item_id, 0))


func get_items(owner_id: String = OWNER_PLAYER) -> Dictionary:
	if _normalize_owner(owner_id) == OWNER_PARTNER:
		return partner_items
	return items


func get_ordered_item_ids(owner_id: String = OWNER_PLAYER, sort_mode: String = "order") -> Array[String]:
	var target_items := get_items(owner_id)
	_sync_item_order(owner_id)
	var ids: Array[String] = []
	if sort_mode == "order":
		for item_id in _item_order_for_owner(owner_id):
			if target_items.has(item_id):
				ids.append(item_id)
		return ids
	for raw_item_id in target_items.keys():
		ids.append(String(raw_item_id))
	match sort_mode:
		"name":
			ids.sort_custom(func(a: String, b: String) -> bool:
				var item_a = get_item_data(a)
				var item_b = get_item_data(b)
				var name_a: String = String(item_a.display_name) if item_a != null else a
				var name_b: String = String(item_b.display_name) if item_b != null else b
				return name_a < name_b
			)
		"amount":
			ids.sort_custom(func(a: String, b: String) -> bool:
				var amount_a := int(target_items.get(a, 0))
				var amount_b := int(target_items.get(b, 0))
				if amount_a == amount_b:
					return a < b
				return amount_a > amount_b
			)
		"category":
			ids.sort_custom(func(a: String, b: String) -> bool:
				var item_a = get_item_data(a)
				var item_b = get_item_data(b)
				var category_a := String(item_a.category) if item_a != null else ""
				var category_b := String(item_b.category) if item_b != null else ""
				if category_a == category_b:
					return a < b
				return category_a < category_b
			)
		_:
			ids.sort()
	return ids


func get_item_weight(item_id: String) -> float:
	var item = get_item_data(item_id)
	if item == null:
		return DEFAULT_ITEM_WEIGHT
	return maxf(float(item.weight), DEFAULT_ITEM_WEIGHT)


func get_stack_weight(item_id: String, amount: int) -> float:
	return get_item_weight(item_id) * float(maxi(amount, 0))


func get_total_weight(source_items: Dictionary = {}, owner_id: String = OWNER_PLAYER) -> float:
	var target_items: Dictionary = get_items(owner_id) if source_items.is_empty() else source_items
	var total := 0.0
	for raw_item_id in target_items.keys():
		var item_id := String(raw_item_id)
		total += get_stack_weight(item_id, int(target_items[raw_item_id]))
	return total


func get_current_weight(owner_id: String = OWNER_PLAYER) -> float:
	return get_total_weight(get_items(owner_id), owner_id)


func get_carry_capacity(owner_id: String = OWNER_PLAYER) -> float:
	var base := PARTNER_CARRY_CAPACITY if _normalize_owner(owner_id) == OWNER_PARTNER else BASE_CARRY_CAPACITY
	return base + float(get_item_effect_total("carry_capacity", owner_id))


func get_remaining_weight(owner_id: String = OWNER_PLAYER) -> float:
	return maxf(0.0, get_carry_capacity(owner_id) - get_current_weight(owner_id))


func get_weight_ratio(owner_id: String = OWNER_PLAYER) -> float:
	var capacity := get_carry_capacity(owner_id)
	if capacity <= 0.0:
		return 1.0
	return clampf(get_current_weight(owner_id) / capacity, 0.0, 1.5)


func get_carry_state_text(owner_id: String = OWNER_PLAYER) -> String:
	var ratio := get_weight_ratio(owner_id)
	if ratio >= 1.0:
		return "한계"
	if ratio >= 0.85:
		return "무거움"
	if ratio >= 0.65:
		return "묵직함"
	return "가벼움"


func get_addable_amount(item_id: String, requested_amount: int, owner_id: String = OWNER_PLAYER) -> int:
	if requested_amount <= 0:
		return 0
	var unit_weight := get_item_weight(item_id)
	if unit_weight <= 0.0:
		return requested_amount
	var free_weight := get_remaining_weight(owner_id) + 0.001
	return clampi(int(floor(free_weight / unit_weight)), 0, requested_amount)


func can_add_item(item_id: String, amount: int = 1, owner_id: String = OWNER_PLAYER) -> bool:
	return get_addable_amount(item_id, amount, owner_id) >= amount


func get_projected_weight(add_items: Dictionary = {}, remove_items: Dictionary = {}, owner_id: String = OWNER_PLAYER) -> float:
	var projected := get_current_weight(owner_id)
	for raw_item_id in remove_items.keys():
		var item_id := String(raw_item_id)
		projected -= get_stack_weight(item_id, int(remove_items[raw_item_id]))
	for raw_item_id in add_items.keys():
		var item_id := String(raw_item_id)
		projected += get_stack_weight(item_id, int(add_items[raw_item_id]))
	return maxf(0.0, projected)


func can_fit_items(add_items: Dictionary, remove_items: Dictionary = {}) -> bool:
	return get_projected_weight(add_items, remove_items) <= get_carry_capacity() + 0.001


func can_fit_items_accessible(add_items: Dictionary, remove_items: Dictionary = {}) -> bool:
	if not can_access_partner_inventory():
		return can_fit_items(add_items, remove_items)
	var current_total := get_current_weight(OWNER_PLAYER) + get_current_weight(OWNER_PARTNER)
	var capacity_total := get_carry_capacity(OWNER_PLAYER) + get_carry_capacity(OWNER_PARTNER)
	var removed_weight := 0.0
	for raw_item_id in remove_items.keys():
		removed_weight += get_stack_weight(String(raw_item_id), int(remove_items[raw_item_id]))
	var added_weight := 0.0
	for raw_item_id in add_items.keys():
		added_weight += get_stack_weight(String(raw_item_id), int(add_items[raw_item_id]))
	return current_total - removed_weight + added_weight <= capacity_total + 0.001


func format_weight(value: float) -> String:
	return "%.1f" % value


func has_item(item_id: String, owner_id: String = OWNER_PLAYER) -> bool:
	return get_count(item_id, owner_id) > 0


func has_item_with_tag(tag: String, owner_id: String = OWNER_PLAYER) -> bool:
	var target_items := get_items(owner_id)
	for item_id in target_items.keys():
		var item = get_item_data(String(item_id))
		if item != null and item.tags.has(tag) and get_count(String(item_id), owner_id) > 0:
			return true
	return false


func get_starting_choice_item_ids() -> Array[String]:
	var result: Array[String] = []
	for item_id in STARTING_CHOICE_ITEM_IDS:
		result.append(String(item_id))
	return result


func apply_starting_item_choice(item_id: String) -> Dictionary:
	if not STARTING_CHOICE_ITEM_IDS.has(item_id):
		return _fail("선택할 수 없는 초기 물품이다.")
	if get_count(item_id) > 0:
		return {
			"ok": true,
			"text": "이미 가지고 있는 물품이다.",
			"item_id": item_id
		}
	var added := add_item(item_id, 1)
	if added <= 0:
		return _fail("짐이 너무 무거워 초기 물품을 챙길 수 없다.")
	var item = get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	return {
		"ok": true,
		"text": "%s을/를 붙잡았다." % display_name,
		"item_id": item_id,
		"display_name": display_name
	}


func get_item_effect_total(effect_id: String, owner_id: String = OWNER_PLAYER) -> int:
	var total := 0
	var target_items := get_items(owner_id)
	for item_id in target_items.keys():
		var item = get_item_data(String(item_id))
		if item == null:
			continue
		if item.effects.has(effect_id):
			total += int(item.effects[effect_id]) * int(target_items[item_id])
	return total


func get_item_effect_max(effect_id: String, owner_id: String = OWNER_PLAYER) -> int:
	var best := 0
	for item_id in get_items(owner_id).keys():
		var item_id_string := String(item_id)
		var item = get_item_data(item_id_string)
		if item != null and item.effects.has(effect_id):
			if _is_durable_tool(item) and get_tool_durability(item_id_string, owner_id) <= 0:
				continue
			best = maxi(best, int(item.effects[effect_id]))
	return best


func get_best_tool_for_effect(effect_id: String, owner_id: String = OWNER_PLAYER) -> String:
	var best_id := ""
	var best_value := 0
	for raw_item_id in get_items(owner_id).keys():
		var item_id := String(raw_item_id)
		var item = get_item_data(item_id)
		if item == null or not item.effects.has(effect_id):
			continue
		if _is_durable_tool(item) and get_tool_durability(item_id, owner_id) <= 0:
			continue
		var value := int(item.effects[effect_id])
		if value > best_value:
			best_value = value
			best_id = item_id
	return best_id


func has_usable_tool(item_id: String, owner_id: String = OWNER_PLAYER) -> bool:
	if get_count(item_id, owner_id) <= 0:
		return false
	var item = get_item_data(item_id)
	if item == null:
		return false
	if not _is_tool_like(item):
		return false
	if int(item.durability) <= 0:
		return true
	return get_tool_durability(item_id, owner_id) > 0


func has_usable_tool_with_effect(effect_id: String, owner_id: String = OWNER_PLAYER) -> bool:
	return get_best_tool_for_effect(effect_id, owner_id) != ""


func get_tool_max_durability(item_id: String) -> int:
	var item = get_item_data(item_id)
	if item == null:
		return 0
	return maxi(0, int(item.durability))


func get_tool_durability(item_id: String, owner_id: String = OWNER_PLAYER) -> int:
	if get_count(item_id, owner_id) <= 0:
		return 0
	var max_durability := get_tool_max_durability(item_id)
	if max_durability <= 0:
		return 0
	_ensure_tool_durability(item_id, owner_id)
	var target_durability := _tool_durability_for_owner(owner_id)
	return clampi(int(target_durability.get(item_id, max_durability)), 0, max_durability * 2)


func get_tool_condition_ratio(item_id: String, owner_id: String = OWNER_PLAYER) -> float:
	var max_durability := get_tool_max_durability(item_id)
	if max_durability <= 0:
		return 1.0
	return clampf(float(get_tool_durability(item_id, owner_id)) / float(max_durability), 0.0, 1.5)


func get_tool_condition_text(item_id: String, owner_id: String = OWNER_PLAYER) -> String:
	var max_durability := get_tool_max_durability(item_id)
	if max_durability <= 0:
		return "내구 없음"
	var remaining := get_tool_durability(item_id, owner_id)
	var ratio := get_tool_condition_ratio(item_id, owner_id)
	if ratio >= 1.15:
		return "정교함 %d/%d" % [remaining, max_durability]
	if ratio >= 0.65:
		return "양호 %d/%d" % [remaining, max_durability]
	if ratio >= 0.35:
		return "마모 %d/%d" % [remaining, max_durability]
	if ratio > 0.0:
		return "위태 %d/%d" % [remaining, max_durability]
	return "망가짐"


func get_tool_effect_summary(item_id: String) -> String:
	var item = get_item_data(item_id)
	if item == null:
		return "효과 없음"
	var parts: Array[String] = []
	for key in item.effects.keys():
		var effect_id := String(key)
		var value := int(item.effects[key])
		match effect_id:
			"gather_wood_bonus":
				parts.append("나무 +%d" % value)
			"gather_fiber_bonus":
				parts.append("섬유/덩굴 +%d" % value)
			"gather_stone_bonus":
				parts.append("돌 +%d" % value)
			"gather_clay_bonus":
				parts.append("점토 +%d" % value)
			"gather_water_bonus":
				parts.append("물 +%d" % value)
			"night_investigate":
				parts.append("야간 조사")
			"fish_action":
				parts.append("낚시 +%d" % value)
			"hunt_action":
				parts.append("사냥 +%d" % value)
			"light":
				parts.append("불빛")
			_:
				if not ["hp", "stamina", "hunger", "thirst", "hygiene", "mood", "trust"].has(effect_id):
					parts.append("%s %+d" % [effect_id, value])
	if parts.is_empty():
		return "효과 없음"
	return _join_strings(parts, " / ")


func apply_best_tool_wear(effect_id: String, amount: int = 1, owner_id: String = OWNER_PLAYER) -> Dictionary:
	var item_id := get_best_tool_for_effect(effect_id, owner_id)
	if item_id == "":
		return _fail("사용할 도구가 없다.")
	return apply_tool_wear(item_id, amount, owner_id)


func apply_tool_wear(item_id: String, amount: int = 1, owner_id: String = OWNER_PLAYER) -> Dictionary:
	if amount <= 0:
		return {"ok": true, "text": ""}
	if not has_usable_tool(item_id, owner_id):
		return _fail("사용할 수 있는 도구가 없다.")
	var max_durability := get_tool_max_durability(item_id)
	if max_durability <= 0:
		return {"ok": true, "text": ""}
	_ensure_tool_durability(item_id, owner_id)
	var target_durability := _tool_durability_for_owner(owner_id)
	var item = get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var remaining := maxi(0, int(target_durability.get(item_id, max_durability)) - amount)
	target_durability[item_id] = remaining
	var message := ""
	if remaining <= 0:
		remove_item(item_id, 1, owner_id)
		if get_count(item_id, owner_id) > 0:
			target_durability[item_id] = max_durability
			message = "%s이/가 망가졌다. 예비 도구를 꺼냈다." % display_name
		else:
			message = "%s이/가 끝내 망가졌다." % display_name
	elif float(remaining) / float(max_durability) <= 0.25:
		message = "%s이/가 많이 닳았다." % display_name
	if message != "":
		pending_item_messages.append(message)
	emit_signal("tool_condition_changed", item_id, get_tool_durability(item_id, owner_id), max_durability)
	emit_signal("inventory_changed")
	return {
		"ok": true,
		"text": message,
		"remaining": get_tool_durability(item_id, owner_id),
		"maximum": max_durability
	}


func set_tool_durability(item_id: String, remaining: int, owner_id: String = OWNER_PLAYER) -> void:
	if get_count(item_id, owner_id) <= 0:
		return
	var max_durability := get_tool_max_durability(item_id)
	if max_durability <= 0:
		return
	var target_durability := _tool_durability_for_owner(owner_id)
	target_durability[item_id] = clampi(remaining, 1, max_durability * 2)
	emit_signal("tool_condition_changed", item_id, int(target_durability[item_id]), max_durability)
	emit_signal("inventory_changed")


func consume_item_messages() -> Array[String]:
	var messages: Array[String] = []
	for message in pending_item_messages:
		messages.append(String(message))
	pending_item_messages.clear()
	return messages


func has_items(required_items: Dictionary, include_partner: bool = true) -> bool:
	for item_id in required_items.keys():
		if get_accessible_count(String(item_id), include_partner) < int(required_items[item_id]):
			return false
	return true


func consume_items(required_items: Dictionary, include_partner: bool = true) -> bool:
	if not has_items(required_items, include_partner):
		return false
	for item_id in required_items.keys():
		var remaining := int(required_items[item_id])
		var from_player := mini(get_count(String(item_id), OWNER_PLAYER), remaining)
		if from_player > 0:
			remove_item(String(item_id), from_player, OWNER_PLAYER)
			remaining -= from_player
		if remaining > 0 and include_partner and can_access_partner_inventory():
			remove_item(String(item_id), remaining, OWNER_PARTNER)
	return true


func get_accessible_count(item_id: String, include_partner: bool = true) -> int:
	var total := get_count(item_id, OWNER_PLAYER)
	if include_partner and can_access_partner_inventory():
		total += get_count(item_id, OWNER_PARTNER)
	return total


func use_item(item_id: String, target_id: String = "player", owner_id: String = OWNER_PLAYER) -> Dictionary:
	var item = get_item_data(item_id)
	if item == null:
		return _fail("알 수 없는 아이템이다.")
	if get_count(item_id, owner_id) <= 0:
		return _fail("아이템이 부족하다.")
	if item.effects.is_empty() or not _has_status_effects(item.effects):
		return _fail("지금 바로 사용할 수 있는 아이템이 아니다.")
	var result = CharacterManager.apply_item_effects(target_id, item.effects, item.display_name)
	if not bool(result.get("ok", false)):
		return result
	if item.tags.has("reusable"):
		var wear_result := apply_tool_wear(item_id, 1, owner_id)
		if String(wear_result.get("text", "")) != "":
			result["text"] = "%s\n%s" % [String(result.get("text", "")), String(wear_result.get("text", ""))]
	else:
		remove_item(item_id, 1, owner_id)
	return result


func get_display_lines(owner_id: String = OWNER_PLAYER) -> Array[String]:
	var lines: Array[String] = []
	var target_items := get_items(owner_id)
	var keys := get_ordered_item_ids(owner_id, "order")
	for item_id in keys:
		var item = get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		lines.append("%s x%d" % [display_name, int(target_items[item_id])])
	if lines.is_empty():
		lines.append("비어 있음")
	return lines


func get_save_data() -> Dictionary:
	return {
		"items": items.duplicate(true),
		"partner_items": partner_items.duplicate(true),
		"item_order": item_order.duplicate(),
		"partner_item_order": partner_item_order.duplicate(),
		"tool_durability": tool_durability.duplicate(true),
		"partner_tool_durability": partner_tool_durability.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	items = data.get("items", {}).duplicate(true)
	partner_items = data.get("partner_items", {}).duplicate(true)
	item_order = _string_array_from_value(data.get("item_order", []))
	partner_item_order = _string_array_from_value(data.get("partner_item_order", []))
	_sync_item_order(OWNER_PLAYER)
	_sync_item_order(OWNER_PARTNER)
	tool_durability = data.get("tool_durability", {}).duplicate(true)
	partner_tool_durability = data.get("partner_tool_durability", {}).duplicate(true)
	for raw_item_id in items.keys():
		_ensure_tool_durability(String(raw_item_id), OWNER_PLAYER)
	for raw_item_id in partner_items.keys():
		_ensure_tool_durability(String(raw_item_id), OWNER_PARTNER)
	for raw_item_id in tool_durability.keys():
		if get_count(String(raw_item_id), OWNER_PLAYER) <= 0:
			tool_durability.erase(raw_item_id)
	for raw_item_id in partner_tool_durability.keys():
		if get_count(String(raw_item_id), OWNER_PARTNER) <= 0:
			partner_tool_durability.erase(raw_item_id)
	emit_signal("inventory_changed")
	_emit_carry_weight_changed()


func _fail(text: String) -> Dictionary:
	return {
		"ok": false,
		"text": text
	}


func _has_status_effects(effects: Dictionary) -> bool:
	for key in effects.keys():
		if ["hp", "stamina", "hunger", "thirst", "hygiene", "mood", "trust"].has(String(key)):
			return true
	return false


func _ensure_tool_durability(item_id: String, owner_id: String = OWNER_PLAYER) -> void:
	var target_durability := _tool_durability_for_owner(owner_id)
	if get_count(item_id, owner_id) <= 0:
		target_durability.erase(item_id)
		return
	var item = get_item_data(item_id)
	if item == null or not _is_durable_tool(item):
		return
	var max_durability := maxi(1, int(item.durability))
	if not target_durability.has(item_id) or int(target_durability[item_id]) <= 0:
		target_durability[item_id] = max_durability
	else:
		target_durability[item_id] = clampi(int(target_durability[item_id]), 1, max_durability * 2)


func _is_tool_like(item) -> bool:
	return item != null and (item.category == "tool" or item.tags.has("tool"))


func _is_durable_tool(item) -> bool:
	return _is_tool_like(item) and int(item.durability) > 0


func _join_strings(parts: Array[String], separator: String) -> String:
	var text := ""
	for index in range(parts.size()):
		if index > 0:
			text += separator
		text += parts[index]
	return text


func _emit_carry_weight_changed() -> void:
	emit_signal("carry_weight_changed", get_current_weight(), get_carry_capacity())


func get_owner_display_name(owner_id: String) -> String:
	if _normalize_owner(owner_id) == OWNER_PARTNER:
		return "파트너"
	return "플레이어"


func can_access_partner_inventory() -> bool:
	if not CharacterManager.partner_joined:
		return false
	if CharacterManager.is_partner_following():
		return true
	var partner_tile_id := String(CharacterManager.get_partner_tile_id(WorldManager.current_tile_id))
	return partner_tile_id == String(WorldManager.current_tile_id)


func _item_order_for_owner(owner_id: String) -> Array[String]:
	if _normalize_owner(owner_id) == OWNER_PARTNER:
		return partner_item_order
	return item_order


func _touch_item_order(item_id: String, owner_id: String = OWNER_PLAYER) -> void:
	var order := _item_order_for_owner(owner_id)
	if item_id != "" and not order.has(item_id):
		order.append(item_id)


func _remove_item_from_order(item_id: String, owner_id: String = OWNER_PLAYER) -> void:
	var order := _item_order_for_owner(owner_id)
	order.erase(item_id)


func _sync_item_order(owner_id: String = OWNER_PLAYER) -> void:
	var target_items := get_items(owner_id)
	var order := _item_order_for_owner(owner_id)
	var cleaned: Array[String] = []
	for raw_item_id in order:
		var item_id := String(raw_item_id)
		if target_items.has(item_id) and not cleaned.has(item_id):
			cleaned.append(item_id)
	for raw_item_id in target_items.keys():
		var item_id := String(raw_item_id)
		if not cleaned.has(item_id):
			cleaned.append(item_id)
	if _normalize_owner(owner_id) == OWNER_PARTNER:
		partner_item_order = cleaned
	else:
		item_order = cleaned


func _string_array_from_value(value) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for raw_item_id in value:
			var item_id := String(raw_item_id)
			if item_id != "" and not result.has(item_id):
				result.append(item_id)
	return result


func _normalize_owner(owner_id: String) -> String:
	if owner_id == OWNER_PARTNER:
		return OWNER_PARTNER
	return OWNER_PLAYER


func _tool_durability_for_owner(owner_id: String) -> Dictionary:
	if _normalize_owner(owner_id) == OWNER_PARTNER:
		return partner_tool_durability
	return tool_durability
