extends Node

signal base_changed

var main_base_region_id: String = "cave"
var base_level: int = 2
var stats: Dictionary = {}
var placed_objects: Array[Dictionary] = []
var stored_items: Dictionary = {}
var placeable_effects: Dictionary = {
	"small_campfire": {"warmth": 1, "food_processing": 1},
	"campfire": {"warmth": 2, "comfort": 1, "work_efficiency": 1, "food_processing": 2},
	"stone_oven": {"warmth": 2, "comfort": 1, "work_efficiency": 2, "food_processing": 4},
	"simple_bed": {"comfort": 2, "stability": 1},
	"storage_box": {"storage": 12},
	"water_bucket": {"hygiene": 1, "work_efficiency": 1, "water_supply": 1},
	"leaf_shelter": {"stability": 1, "comfort": 1, "weather_cover": 1},
	"rain_collector": {"hygiene": 1, "water_supply": 2},
	"drying_rack": {"food_processing": 2, "work_efficiency": 1},
	"workbench": {"work_efficiency": 2, "stability": 1},
	"fish_trap": {"food_supply": 1},
	"mud_wall": {"stability": 2, "warmth": 1}
}
var placement_costs: Dictionary = {
	"small_campfire": {"time": 1, "stamina": 4},
	"campfire": {"time": 2, "stamina": 8},
	"stone_oven": {"time": 4, "stamina": 16},
	"water_bucket": {"time": 2, "stamina": 8},
	"simple_bed": {"time": 3, "stamina": 10},
	"storage_box": {"time": 3, "stamina": 12},
	"leaf_shelter": {"time": 2, "stamina": 8},
	"rain_collector": {"time": 3, "stamina": 10},
	"drying_rack": {"time": 2, "stamina": 8},
	"workbench": {"time": 4, "stamina": 14},
	"fish_trap": {"time": 2, "stamina": 8},
	"mud_wall": {"time": 4, "stamina": 16}
}

const BASE_LIFE_CUE_ORDER = [
	"rest",
	"warmth",
	"water",
	"work",
	"storage",
	"weather"
]


func _ready() -> void:
	reset_state()


func reset_state() -> void:
	base_level = 2
	stats = {
		"stability": 2,
		"comfort": 1,
		"storage": 8,
		"work_efficiency": 1,
		"hygiene": 1,
		"warmth": 1,
		"water_supply": 0,
		"food_processing": 0,
		"food_supply": 0,
		"weather_cover": 0
	}
	placed_objects = []
	stored_items = {}
	emit_signal("base_changed")


func get_placeable_item_ids() -> Array[String]:
	var ids: Array[String] = []
	for item_id in placeable_effects.keys():
		ids.append(String(item_id))
	ids.sort()
	return ids


func get_placed_objects() -> Array[Dictionary]:
	var copied: Array[Dictionary] = []
	for placed in placed_objects:
		copied.append(placed.duplicate(true))
	return copied


func get_stored_items() -> Dictionary:
	return stored_items.duplicate(true)


func get_placement_cost(item_id: String) -> Dictionary:
	var base_cost: Dictionary = placement_costs.get(item_id, {"time": 2, "stamina": 8})
	return GameState.get_adjusted_action_cost("develop", base_cost)


func can_place_item(item_id: String) -> bool:
	return placeable_effects.has(item_id)


func has_placed_item(item_id: String) -> bool:
	for placed in placed_objects:
		if String(placed.get("id", "")) == item_id:
			return true
	return false


func can_use_station(item_id: String) -> bool:
	if not is_at_base():
		return false
	if item_id == "fire" or item_id == "campfire":
		return has_any_placed_item(["small_campfire", "campfire", "stone_oven"])
	return has_placed_item(item_id)


func has_any_placed_item(item_ids: Array) -> bool:
	for item_id in item_ids:
		if has_placed_item(String(item_id)):
			return true
	return false


func get_fire_tier() -> int:
	if has_placed_item("stone_oven"):
		return 3
	if has_placed_item("campfire"):
		return 2
	if has_placed_item("small_campfire"):
		return 1
	return 0


func is_at_base() -> bool:
	var tile = WorldManager.get_current_tile()
	return tile != null and bool(tile.get("is_base", false))


func get_rest_recovery_profile() -> Dictionary:
	if not is_at_base():
		return {
			"label": "야외",
			"player_stamina": 9,
			"partner_stamina": 8,
			"mood": 0,
			"trust": 0,
			"hygiene_recovery": 0
		}
	var comfort := int(stats.get("comfort", 0))
	var warmth := int(stats.get("warmth", 0))
	var stability := int(stats.get("stability", 0))
	return {
		"label": "거점",
		"player_stamina": 16 + comfort * 2 + warmth,
		"partner_stamina": 14 + comfort * 2 + warmth,
		"mood": 1 + int(floor(float(comfort + stability) / 3.0)),
		"trust": 1 if comfort >= 3 else 0,
		"hygiene_recovery": int(stats.get("hygiene", 0)) + int(stats.get("water_supply", 0))
	}


func get_sleep_recovery_profile() -> Dictionary:
	if not is_at_base():
		return {
			"label": "야외",
			"stamina_per_hour": 6,
			"mood_cap": 4,
			"mood_bonus": -1,
			"hunger_saving": 0,
			"thirst_saving": 0,
			"hygiene_recovery": 0
		}
	var comfort := int(stats.get("comfort", 0))
	var warmth := int(stats.get("warmth", 0))
	var stability := int(stats.get("stability", 0))
	var hygiene := int(stats.get("hygiene", 0))
	return {
		"label": "거점",
		"stamina_per_hour": 9 + mini(5, comfort + int(floor(float(warmth) / 2.0))),
		"mood_cap": 8 + mini(5, comfort + int(floor(float(stability) / 2.0))),
		"mood_bonus": int(floor(float(comfort + warmth) / 2.0)),
		"hunger_saving": int(floor(float(stability) / 3.0)),
		"thirst_saving": hygiene,
		"hygiene_recovery": hygiene * 2 + int(stats.get("water_supply", 0))
	}


func get_station_name(item_id: String) -> String:
	if item_id == "fire":
		return "불자리"
	var item = InventoryManager.get_item_data(item_id)
	if item != null:
		return item.display_name
	return item_id


func place_item(item_id: String) -> Dictionary:
	if not is_at_base():
		return _fail("거점 정비는 동굴에서 할 수 있다.")
	if not can_place_item(item_id):
		return _fail("배치할 수 없는 아이템이다.")
	if InventoryManager.get_count(item_id) <= 0:
		return _fail("배치할 아이템이 부족하다.")
	var adjusted_cost := get_placement_cost(item_id)
	var time_cost := int(adjusted_cost.get("time", 2))
	var stamina_cost := int(adjusted_cost.get("stamina", 8))
	if not GameState.can_spend_action_points(time_cost):
		return _fail("배치할 시간이 부족하다.")
	if not CharacterManager.can_spend_stamina(stamina_cost):
		return _fail("배치할 기력이 부족하다.")
	GameState.spend_action_points(time_cost)
	CharacterManager.spend_stamina(stamina_cost)
	CharacterManager.apply_action_metabolism("develop", time_cost, stamina_cost, false)
	var status_messages := CharacterManager.consume_status_messages()
	InventoryManager.remove_item(item_id, 1)
	var slot_index := placed_objects.size()
	var placed := {
		"id": item_id,
		"x": slot_index % 4,
		"y": int(slot_index / 4),
		"day": GameState.day
	}
	placed_objects.append(placed)
	for stat_id in placeable_effects[item_id].keys():
		stats[stat_id] = int(stats.get(stat_id, 0)) + int(placeable_effects[item_id][stat_id])
	emit_signal("base_changed")
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	return {
		"ok": true,
		"text": "%s을/를 동굴 거점에 배치했다.%s" % [display_name, "\n" + _join_strings(status_messages, "\n") if not status_messages.is_empty() else ""]
	}


func store_item(item_id: String, amount: int = 1, owner_id: String = "player") -> Dictionary:
	if not is_at_base():
		return _fail("거점 안에서만 보관할 수 있다.")
	if item_id == "":
		return _fail("보관할 물건이 없다.")
	var owned_amount := InventoryManager.get_count(item_id, owner_id)
	if owned_amount <= 0:
		return _fail("보관할 물건이 부족하다.")
	var safe_amount := clampi(amount, 1, owned_amount)
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var storable_amount := get_storable_amount(item_id, safe_amount)
	if storable_amount <= 0:
		return _fail("거점 보관 공간이 부족하다.")
	if not InventoryManager.remove_item(item_id, storable_amount, owner_id):
		return _fail("보관할 물건이 부족하다.")
	stored_items[item_id] = int(stored_items.get(item_id, 0)) + storable_amount
	emit_signal("base_changed")
	var text := "%s x%d을/를 거점에 내려놓았다." % [display_name, storable_amount]
	if storable_amount < safe_amount:
		text += "\n보관 공간이 부족해 일부만 정리했다."
	return {
		"ok": true,
		"text": text,
		"item_id": item_id,
		"amount": storable_amount
	}


func take_stored_item(item_id: String, amount: int = 1, owner_id: String = "player") -> Dictionary:
	if not is_at_base():
		return _fail("거점 안에서만 꺼낼 수 있다.")
	if item_id == "":
		return _fail("꺼낼 물건이 없다.")
	var stored_amount := int(stored_items.get(item_id, 0))
	if stored_amount <= 0:
		return _fail("거점에 그 물건이 없다.")
	var requested := stored_amount if amount <= 0 else mini(amount, stored_amount)
	var addable := InventoryManager.get_addable_amount(item_id, requested, owner_id)
	if addable <= 0:
		return _fail("%s의 짐이 너무 무겁다." % InventoryManager.get_owner_display_name(owner_id))
	var added := InventoryManager.add_item(item_id, addable, owner_id)
	if added <= 0:
		return _fail("%s의 짐이 너무 무겁다." % InventoryManager.get_owner_display_name(owner_id))
	stored_items[item_id] = stored_amount - added
	if int(stored_items.get(item_id, 0)) <= 0:
		stored_items.erase(item_id)
	emit_signal("base_changed")
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	return {
		"ok": true,
		"text": "%s x%d을/를 거점에서 꺼냈다. (%s)" % [display_name, added, InventoryManager.get_owner_display_name(owner_id)],
		"item_id": item_id,
		"amount": added,
		"items": {item_id: added}
	}


func get_base_summary() -> String:
	var placed_parts: Array[String] = []
	for placed in placed_objects:
		var item = InventoryManager.get_item_data(String(placed.get("id", "")))
		var display_name := String(placed.get("id", ""))
		if item != null:
			display_name = item.display_name
		placed_parts.append("%s(%d,%d)" % [display_name, int(placed.get("x", 0)), int(placed.get("y", 0))])
	if placed_parts.is_empty():
		placed_parts.append("아직 배치된 물건 없음")
	return "동굴 거점 Lv.%d\n안정 %d / 쾌적 %d / 보관 %d / 작업 %d / 청결 %d / 온기 %d\n물공급 %d / 식량처리 %d / 식량공급 %d / 비바람 %d\n배치: %s" % [
		base_level,
		int(stats.get("stability", 0)),
		int(stats.get("comfort", 0)),
		int(stats.get("storage", 0)),
		int(stats.get("work_efficiency", 0)),
		int(stats.get("hygiene", 0)),
		int(stats.get("warmth", 0)),
		int(stats.get("water_supply", 0)),
		int(stats.get("food_processing", 0)),
		int(stats.get("food_supply", 0)),
		int(stats.get("weather_cover", 0)),
		_join_strings(placed_parts, ", ")
	]


func get_base_life_summary() -> String:
	var lines: Array[String] = []
	lines.append("동굴 거점 Lv.%d · %s · %s" % [
		base_level,
		_base_shelter_phrase(),
		_base_lived_in_phrase()
	])
	lines.append("%s / %s / %s" % [
		_base_stat_phrase("온기", int(stats.get("warmth", 0)), 1, 3),
		_base_stat_phrase("물", int(stats.get("water_supply", 0)), 1, 3),
		_base_stat_phrase("쉴 곳", int(stats.get("comfort", 0)), 2, 4)
	])
	if placed_objects.is_empty():
		lines.append("아직 동굴 한쪽에 젖은 짐만 모아둔 상태다.")
	else:
		lines.append("눈에 띄는 물건: %s" % _join_strings(_placed_object_names(4), ", "))
	return _join_strings(lines, "\n")


func get_base_life_cues() -> Array[Dictionary]:
	var cues: Array[Dictionary] = []
	for cue_id in BASE_LIFE_CUE_ORDER:
		match cue_id:
			"rest":
				cues.append(_base_life_cue(
					"items/simple_bed",
					"쉼",
					_base_band_text(int(stats.get("comfort", 0)), 2, 4),
					"잠자리와 앉을 곳의 여유"
				))
			"warmth":
				cues.append(_base_life_cue(
					"items/campfire",
					"온기",
					_base_band_text(int(stats.get("warmth", 0)), 1, 3),
					"밤과 비를 버티는 정도"
				))
			"water":
				cues.append(_base_life_cue(
					"items/water",
					"물",
					_base_band_text(int(stats.get("water_supply", 0)), 1, 3),
					"씻고 마실 물을 모으는 힘"
				))
			"work":
				cues.append(_base_life_cue(
					"actions/craft",
					"작업",
					_base_band_text(int(stats.get("work_efficiency", 0)), 2, 4),
					"도구를 손볼 수 있는 자리"
				))
			"storage":
				cues.append(_base_life_cue(
					"items/storage_box",
					"보관",
					_base_band_text(int(stats.get("storage", 0)), 10, 18),
					"현장에 흩어지지 않게 모아두는 공간"
				))
			"weather":
				cues.append(_base_life_cue(
					"items/fiber",
					"비바람",
					_base_band_text(int(stats.get("stability", 0)) + int(stats.get("weather_cover", 0)), 3, 5),
					"바람과 빗물에 버티는 정도"
				))
	return cues


func get_storage_capacity() -> float:
	return maxf(0.0, float(stats.get("storage", 0)))


func get_stored_weight() -> float:
	var total := 0.0
	for raw_item_id in stored_items.keys():
		total += InventoryManager.get_stack_weight(String(raw_item_id), int(stored_items[raw_item_id]))
	return total


func get_remaining_storage() -> float:
	return maxf(0.0, get_storage_capacity() - get_stored_weight())


func get_storable_amount(item_id: String, requested_amount: int) -> int:
	if requested_amount <= 0:
		return 0
	var unit_weight := InventoryManager.get_item_weight(item_id)
	if unit_weight <= 0.0:
		return requested_amount
	return clampi(int(floor((get_remaining_storage() + 0.001) / unit_weight)), 0, requested_amount)


func get_base_life_note() -> String:
	if placed_objects.is_empty():
		return "돌과 젖은 흙 냄새가 남아 있다. 오늘은 몸을 눕힐 자리부터 필요하다."
	if has_placed_item("stone_oven"):
		return "묵직한 화덕이 생겼다. 불이 오래 가고 요리와 작업을 안정적으로 이어갈 수 있다."
	if has_placed_item("campfire") and has_placed_item("simple_bed"):
		return "불빛과 잠자리가 생기며 동굴이 잠시 숨을 고를 곳처럼 느껴진다."
	if has_placed_item("campfire"):
		return "불빛이 동굴 벽을 흔든다. 간단한 조리와 밤의 온기가 안정되기 시작한다."
	if has_placed_item("small_campfire"):
		return "잔불이 겨우 붙었다. 오래 버티진 못해도 첫 밤을 넘길 온기는 된다."
	if has_placed_item("simple_bed"):
		return "마른 자리가 생겼다. 밤의 냉기는 아직 깊게 스민다."
	return "물건들이 자리를 잡기 시작했지만, 아직 생활의 리듬은 불안정하다."


func get_gather_bonus(item_id: String) -> int:
	if item_id == "water" and has_placed_item("rain_collector"):
		return 1
	if ["fiber", "vine", "palm_frond"].has(item_id) and has_placed_item("workbench"):
		return 1
	if ["stone", "clay"].has(item_id) and has_placed_item("mud_wall"):
		return 1
	return 0


func has_any_gather_bonus() -> bool:
	return has_placed_item("rain_collector") or has_placed_item("workbench") or has_placed_item("mud_wall")


func get_fishing_bonus() -> int:
	if has_placed_item("fish_trap"):
		return 12
	return 0


func collect_daily_yields(weather: String) -> Dictionary:
	var yields: Dictionary = {}
	if has_placed_item("rain_collector"):
		var water_gain := 1 + int(stats.get("water_supply", 0))
		if weather == "비":
			water_gain += 1
		elif weather == "폭우" or weather == "폭풍":
			water_gain += 2
		_add_yield(yields, "water", water_gain)
	if has_placed_item("fish_trap"):
		var fish_gain := int(stats.get("food_supply", 0))
		if weather == "폭풍":
			fish_gain = maxi(0, fish_gain - 1)
		if fish_gain > 0:
			_add_yield(yields, "fish", fish_gain)
	var collected: Dictionary = {}
	for item_id in yields.keys():
		var item_id_string := String(item_id)
		var remaining := int(yields[item_id])
		var stored := get_storable_amount(item_id_string, remaining)
		if stored > 0:
			stored_items[item_id_string] = int(stored_items.get(item_id_string, 0)) + stored
			collected[item_id_string] = int(collected.get(item_id_string, 0)) + stored
			remaining -= stored
		if remaining > 0:
			var added := InventoryManager.add_item(item_id_string, remaining)
			if added > 0:
				collected[item_id_string] = int(collected.get(item_id_string, 0)) + added
	if not collected.is_empty():
		emit_signal("base_changed")
	return collected


func get_daily_status_modifiers() -> Dictionary:
	if not is_at_base():
		return {}
	return {
		"stamina_recovery": int(stats.get("comfort", 0)) * 2 + int(stats.get("warmth", 0)),
		"mood": int(stats.get("comfort", 0)),
		"thirst_saving": int(stats.get("hygiene", 0)),
		"weather_strain_reduction": int(stats.get("stability", 0)) + int(stats.get("weather_cover", 0))
	}


func get_save_data() -> Dictionary:
	return {
		"main_base_region_id": main_base_region_id,
		"base_level": base_level,
		"stats": stats.duplicate(true),
		"placed_objects": placed_objects.duplicate(true),
		"stored_items": stored_items.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	main_base_region_id = String(data.get("main_base_region_id", "cave"))
	base_level = int(data.get("base_level", 2))
	stats = data.get("stats", {}).duplicate(true)
	placed_objects.clear()
	for placed in data.get("placed_objects", []):
		var placed_dict = placed
		if placed_dict != null:
			placed_objects.append(placed_dict.duplicate(true))
	stored_items = data.get("stored_items", {}).duplicate(true)
	emit_signal("base_changed")


func _fail(text: String) -> Dictionary:
	return {
		"ok": false,
		"text": text
	}


func _add_yield(yields: Dictionary, item_id: String, amount: int) -> void:
	if amount <= 0:
		return
	yields[item_id] = int(yields.get(item_id, 0)) + amount


func _base_life_cue(icon: String, label: String, value: String, detail: String) -> Dictionary:
	return {
		"icon": icon,
		"label": label,
		"value": value,
		"detail": detail
	}


func _base_band_text(value: int, modest: int, good: int) -> String:
	if value <= 0:
		return "부족"
	if value < modest:
		return "약함"
	if value < good:
		return "보통"
	return "든든"


func _base_stat_phrase(label: String, value: int, modest: int, good: int) -> String:
	return "%s %s" % [label, _base_band_text(value, modest, good)]


func _base_shelter_phrase() -> String:
	var stability := int(stats.get("stability", 0)) + int(stats.get("weather_cover", 0))
	if stability >= 5:
		return "비바람을 막는 쉼터"
	if stability >= 3:
		return "겨우 몸을 숨기는 쉼터"
	return "아직 거친 동굴"


func _base_lived_in_phrase() -> String:
	if placed_objects.size() >= 6:
		return "생활 흔적이 많음"
	if placed_objects.size() >= 3:
		return "자리가 잡혀감"
	if placed_objects.size() >= 1:
		return "물건을 들이기 시작함"
	return "비어 있음"


func _placed_object_names(max_count: int) -> Array[String]:
	var names: Array[String] = []
	for placed in placed_objects:
		if names.size() >= max_count:
			break
		var item_id := String(placed.get("id", ""))
		var item = InventoryManager.get_item_data(item_id)
		names.append(item.display_name if item != null else item_id)
	if placed_objects.size() > max_count:
		names.append("외 %d개" % (placed_objects.size() - max_count))
	return names


func _join_strings(parts: Array[String], separator: String) -> String:
	var text := ""
	for index in range(parts.size()):
		if index > 0:
			text += separator
		text += parts[index]
	return text
