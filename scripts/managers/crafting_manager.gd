extends Node

signal recipes_changed
signal recipe_unlocked(recipe_id: String, reason: String)
signal crafted(recipe_id: String, result_items: Dictionary)

const DEFAULT_UNLOCK_CONDITIONS := {
	"small_campfire": {"initial": true},
	"sharp_stone": {"initial": true},
	"rope": {"items": ["fiber", "vine"]},
	"stone_knife": {"items": ["sharp_stone", "wood", "fiber"]},
	"simple_fishing_rod": {"items": ["wood", "fiber"]},
	"wooden_spear": {"items": ["wood", "sharp_stone", "fiber"]},
	"stone_axe": {"items": ["stone", "wood", "fiber"], "min_crafts": 1},
	"campfire": {"items": ["stone", "wood"], "crafted": ["small_campfire"]},
	"stone_oven": {"items": ["stone", "clay", "wood"], "crafted": ["campfire"], "min_crafts": 3},
	"water_bucket": {"items": ["wood", "fiber"], "min_crafts": 1},
	"torch": {"items": ["wood", "fiber"], "crafted": ["small_campfire"]},
	"cooked_fish": {"items": ["fish"], "crafted": ["small_campfire"]},
	"cooked_meat": {"items": ["raw_meat"], "crafted": ["small_campfire"]},
	"leaf_shelter": {"items": ["palm_frond", "wood"], "crafted": ["rope"]},
	"storage_box": {"items": ["wood", "fiber"], "min_crafts": 3},
	"drying_rack": {"items": ["wood", "fiber"], "crafted": ["rope"], "min_crafts": 3},
	"fish_trap": {"items": ["vine", "fiber", "wood"], "min_crafts": 3},
	"reinforced_fishing_rod": {"items": ["wood", "vine", "rope", "sharp_stone"], "crafted": ["simple_fishing_rod"], "min_crafts": 3},
	"simple_bow": {"items": ["wood", "vine", "fiber", "sharp_stone"], "crafted": ["wooden_spear"], "min_crafts": 3},
	"snare_trap": {"items": ["rope", "wood", "fiber"], "min_crafts": 2},
	"rain_collector": {"items": ["palm_frond", "clay"], "crafted": ["rope"], "min_crafts": 4},
	"simple_bed": {"items": ["wood", "fiber"], "min_crafts": 5},
	"workbench": {"items": ["wood", "stone"], "crafted": ["rope"], "min_crafts": 5},
	"mud_wall": {"items": ["clay", "palm_frond", "wood"], "min_crafts": 6},
	"dried_fish": {"items": ["fish"], "crafted": ["drying_rack"]}
}

var recipes: Dictionary = {}
var unlocked_recipes: Dictionary = {}
var discovered_items: Dictionary = {}
var crafted_recipe_counts: Dictionary = {}
var total_crafts: int = 0
var crafting_xp: int = 0


func _ready() -> void:
	if not InventoryManager.item_added.is_connected(_on_item_added):
		InventoryManager.item_added.connect(_on_item_added)
	load_recipes()


func load_recipes(reset_unlocks: bool = true) -> void:
	recipes.clear()
	var dir := DirAccess.open("res://data/recipes")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var recipe = load("res://data/recipes/%s" % file_name)
			if recipe != null and recipe.id != "":
				recipes[recipe.id] = recipe
		file_name = dir.get_next()
	dir.list_dir_end()
	if reset_unlocks:
		reset_progress(false)
	else:
		evaluate_recipe_unlocks(false)
	emit_signal("recipes_changed")


func reset_progress(emit_change: bool = true) -> void:
	unlocked_recipes.clear()
	discovered_items.clear()
	crafted_recipe_counts.clear()
	total_crafts = 0
	crafting_xp = 0
	_seed_discovered_items_from_inventory()
	evaluate_recipe_unlocks(false)
	if emit_change:
		emit_signal("recipes_changed")


func get_recipe(recipe_id: String):
	return recipes.get(recipe_id, null)


func is_recipe_unlocked(recipe_id: String) -> bool:
	return bool(unlocked_recipes.get(recipe_id, false))


func get_unlocked_recipe_ids() -> Array[String]:
	var ids: Array[String] = []
	for raw_recipe_id in recipes.keys():
		var recipe_id := String(raw_recipe_id)
		if is_recipe_unlocked(recipe_id):
			ids.append(recipe_id)
	ids.sort()
	return ids


func get_known_recipe_count() -> int:
	return get_unlocked_recipe_ids().size()


func get_total_recipe_count() -> int:
	return recipes.size()


func get_crafting_level() -> int:
	return 1 + int(crafting_xp / 5)


func get_crafting_mastery_label() -> String:
	var level := get_crafting_level()
	if level >= 5:
		return "손에 익음"
	if level >= 3:
		return "요령 생김"
	if level >= 2:
		return "조금 익숙함"
	return "서툼"


func craft(recipe_id: String, partner_assist: bool = false) -> Dictionary:
	var recipe = get_recipe(recipe_id)
	if recipe == null:
		return _fail("알 수 없는 제작법이다.")
	if not is_recipe_unlocked(recipe_id):
		return _fail("아직 떠올리지 못한 제작법이다.")
	if partner_assist and not recipe.can_partner_assist:
		return _fail("이 제작은 함께 진행할 수 없다.")
	if partner_assist and not CharacterManager.is_partner_following():
		return _fail("함께 제작하려면 파트너와 동행 중이어야 한다.")
	if not GameState.can_perform_action_now("craft"):
		return _fail(GameState.get_action_restriction_text("craft"))
	if recipe.required_station != "" and not BaseManager.can_use_station(recipe.required_station):
		return _fail("%s가 있는 동굴 거점에서 제작할 수 있다." % BaseManager.get_station_name(recipe.required_station))
	if not InventoryManager.can_fit_items_accessible(recipe.result_items, recipe.required_items):
		return _fail("짐이 너무 무겁다. 재료를 내려놓거나 거점에 정리한 뒤 제작해야 한다.")
	if not InventoryManager.has_items(recipe.required_items):
		return _fail("재료가 부족하다.")
	var adjusted_cost := GameState.get_adjusted_action_cost("craft", {"time": recipe.time_cost, "stamina": recipe.stamina_cost})
	var time_cost := int(adjusted_cost.get("time", recipe.time_cost))
	var stamina_cost := int(adjusted_cost.get("stamina", recipe.stamina_cost))
	if not GameState.can_spend_action_points(time_cost):
		return _fail("제작할 시간이 부족하다.")
	if partner_assist:
		stamina_cost = max(1, int(ceil(float(stamina_cost) * 0.75)))
	if not CharacterManager.can_spend_stamina(stamina_cost, partner_assist):
		return _fail("제작할 기력이 부족하다.")
	GameState.spend_action_points(time_cost)
	CharacterManager.spend_stamina(stamina_cost, partner_assist)
	CharacterManager.apply_action_metabolism("craft", time_cost, stamina_cost, partner_assist)
	var status_messages := CharacterManager.consume_status_messages()
	InventoryManager.consume_items(recipe.required_items)
	var crafted_items: Dictionary = {}
	for item_id in recipe.result_items.keys():
		var added := InventoryManager.add_item_to_party(String(item_id), int(recipe.result_items[item_id]), true)
		if added > 0:
			crafted_items[String(item_id)] = added
	if partner_assist:
		CharacterManager.partner_status.apply_delta({"trust": 2, "mood": 2})
		CharacterManager.notify_status_changed()
		EventManager.notify_fact("first_joint_work")
	total_crafts += 1
	crafting_xp += _crafting_xp_for_recipe(recipe)
	crafted_recipe_counts[recipe_id] = int(crafted_recipe_counts.get(recipe_id, 0)) + 1
	for item_id in crafted_items.keys():
		discovered_items[String(item_id)] = true
	evaluate_recipe_unlocks(true)
	emit_signal("crafted", recipe_id, crafted_items)
	return {
		"ok": true,
		"text": "%s 제작 완료%s" % [recipe.display_name, "\n" + _join_strings(status_messages, "\n") if not status_messages.is_empty() else ""],
		"items": crafted_items,
		"action_id": "craft",
		"together": partner_assist
	}


func get_recipe_lines() -> Array[String]:
	var lines: Array[String] = []
	var keys := recipes.keys()
	keys.sort()
	for recipe_id in keys:
		if not is_recipe_unlocked(String(recipe_id)):
			continue
		var recipe = recipes[recipe_id]
		var requirements: Array[String] = []
		for item_id in recipe.required_items.keys():
			var item = InventoryManager.get_item_data(String(item_id))
			var display_name := String(item_id)
			if item != null:
				display_name = item.display_name
			requirements.append("%s %d" % [display_name, int(recipe.required_items[item_id])])
		lines.append("%s: %s" % [recipe.display_name, _join_strings(requirements, ", ")])
	return lines


func get_save_data() -> Dictionary:
	return {
		"unlocked_recipes": unlocked_recipes.duplicate(true),
		"discovered_items": discovered_items.duplicate(true),
		"crafted_recipe_counts": crafted_recipe_counts.duplicate(true),
		"total_crafts": total_crafts,
		"crafting_xp": crafting_xp
	}


func load_save_data(data: Dictionary) -> void:
	if recipes.is_empty():
		load_recipes(false)
	unlocked_recipes = data.get("unlocked_recipes", {}).duplicate(true)
	discovered_items = data.get("discovered_items", {}).duplicate(true)
	crafted_recipe_counts = data.get("crafted_recipe_counts", {}).duplicate(true)
	total_crafts = int(data.get("total_crafts", 0))
	crafting_xp = int(data.get("crafting_xp", 0))
	_seed_discovered_items_from_inventory()
	evaluate_recipe_unlocks(false)
	emit_signal("recipes_changed")


func evaluate_recipe_unlocks(announce: bool = true) -> Array[String]:
	var unlocked_now: Array[String] = []
	var changed := true
	while changed:
		changed = false
		var recipe_ids := recipes.keys()
		recipe_ids.sort()
		for raw_recipe_id in recipe_ids:
			var recipe_id := String(raw_recipe_id)
			if is_recipe_unlocked(recipe_id):
				continue
			var recipe = get_recipe(recipe_id)
			if recipe == null:
				continue
			if not _recipe_conditions_met(recipe):
				continue
			unlocked_recipes[recipe_id] = true
			unlocked_now.append(recipe_id)
			changed = true
			if announce:
				emit_signal("recipe_unlocked", recipe_id, _unlock_reason_text(recipe))
	if not unlocked_now.is_empty():
		emit_signal("recipes_changed")
	return unlocked_now


func _recipe_conditions_met(recipe) -> bool:
	var conditions := _unlock_conditions_for_recipe(recipe)
	if bool(conditions.get("initial", false)):
		return true
	for item_id in _condition_string_array(conditions, "items"):
		if not bool(discovered_items.get(item_id, false)):
			return false
	for item_id in _condition_string_array(conditions, "discovered_items"):
		if not bool(discovered_items.get(item_id, false)):
			return false
	for recipe_id in _condition_string_array(conditions, "crafted"):
		if int(crafted_recipe_counts.get(recipe_id, 0)) <= 0:
			return false
	for recipe_id in _condition_string_array(conditions, "crafted_recipes"):
		if int(crafted_recipe_counts.get(recipe_id, 0)) <= 0:
			return false
	var min_crafts := int(conditions.get("min_crafts", 0))
	if min_crafts > 0 and total_crafts < min_crafts:
		return false
	var min_level := int(conditions.get("crafting_level", 0))
	if min_level > 0 and get_crafting_level() < min_level:
		return false
	return true


func _unlock_conditions_for_recipe(recipe) -> Dictionary:
	var conditions: Dictionary = recipe.unlock_conditions
	if not conditions.is_empty():
		return conditions
	return DEFAULT_UNLOCK_CONDITIONS.get(String(recipe.id), {"items": recipe.required_items.keys()})


func _condition_string_array(conditions: Dictionary, key: String) -> Array[String]:
	var result: Array[String] = []
	if not conditions.has(key):
		return result
	var values = conditions.get(key, [])
	if typeof(values) == TYPE_STRING:
		result.append(String(values))
		return result
	if values is Array:
		for value in values:
			result.append(String(value))
	return result


func _seed_discovered_items_from_inventory() -> void:
	for item_id in InventoryManager.get_items("player").keys():
		discovered_items[String(item_id)] = true
	for item_id in InventoryManager.get_items("partner").keys():
		discovered_items[String(item_id)] = true


func _on_item_added(item_id: String, _amount: int) -> void:
	discovered_items[item_id] = true
	evaluate_recipe_unlocks(true)


func _crafting_xp_for_recipe(recipe) -> int:
	var effort := maxi(1, int(recipe.time_cost))
	if int(recipe.stamina_cost) >= 12:
		effort += 1
	if recipe.required_station != "":
		effort += 1
	return effort


func _unlock_reason_text(recipe) -> String:
	var conditions := _unlock_conditions_for_recipe(recipe)
	if bool(conditions.get("initial", false)):
		return "처음부터 알고 있던 손작업"
	if int(conditions.get("min_crafts", 0)) > 0 or int(conditions.get("crafting_level", 0)) > 0:
		return "제작이 손에 익었다"
	if not _condition_string_array(conditions, "crafted").is_empty() or not _condition_string_array(conditions, "crafted_recipes").is_empty():
		return "이전에 만든 물건에서 떠올렸다"
	return "새 재료를 보고 떠올렸다"


func _fail(text: String) -> Dictionary:
	return {
		"ok": false,
		"text": text
	}


func _join_strings(parts: Array[String], separator: String) -> String:
	var text := ""
	for index in range(parts.size()):
		if index > 0:
			text += separator
		text += parts[index]
	return text
