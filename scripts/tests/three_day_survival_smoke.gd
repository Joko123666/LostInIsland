extends SceneTree

var failures: Array[String] = []
var game_state
var inventory_manager
var character_manager
var world_manager
var base_manager
var event_manager
var crafting_manager


func _initialize() -> void:
	randomize()
	_bind_autoloads()
	_reset_game()
	_choose_starting_item()
	_run_day_one_opening()
	_advance_to_day_three()
	_check_survival_state()
	if failures.is_empty():
		print("THREE_DAY_SURVIVAL_SMOKE_OK")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _bind_autoloads() -> void:
	var root := get_root()
	game_state = root.get_node("GameState")
	inventory_manager = root.get_node("InventoryManager")
	character_manager = root.get_node("CharacterManager")
	world_manager = root.get_node("WorldManager")
	base_manager = root.get_node("BaseManager")
	event_manager = root.get_node("EventManager")
	crafting_manager = root.get_node("CraftingManager")


func _reset_game() -> void:
	game_state.reset_state()
	inventory_manager.reset_state()
	character_manager.reset_state()
	world_manager.reset_state()
	base_manager.reset_state()
	event_manager.reset_state()
	crafting_manager.load_recipes()


func _choose_starting_item() -> void:
	var result: Dictionary = inventory_manager.apply_starting_item_choice("survival_axe")
	_expect(bool(result.get("ok", false)), "starting item choice should succeed")
	_expect(inventory_manager.get_count("survival_axe") == 1, "survival axe should be in player inventory")
	_expect(inventory_manager.get_count("survival_guide") == 1, "survival guide should be in player inventory")


func _run_day_one_opening() -> void:
	var start_tile_id: String = world_manager.current_tile_id
	_expect(start_tile_id == world_manager.get_tile_id(2, 7), "player should start on the opening beach tile")
	var investigate_result: Dictionary = world_manager.execute_tile_action("investigate", {})
	_expect(bool(investigate_result.get("ok", false)), "opening beach investigation should succeed")
	_expect(world_manager.is_tile_investigated(start_tile_id), "opening beach should be marked investigated")
	var objects: Array = world_manager.get_tile_resource_objects(start_tile_id, true)
	_expect(objects.size() >= 2, "opening beach should reveal at least two resource objects")
	var found_coconut := false
	for object in objects:
		if String(object.get("type", "")) == "coconut_palm":
			found_coconut = true
	var blocked_gather_result: Dictionary = world_manager.gather_resource_object(start_tile_id, String(Dictionary(objects[0]).get("id", "")), false)
	_expect(not bool(blocked_gather_result.get("ok", false)), "opening beach resource object should be blocked before base entry")
	_expect(found_coconut, "opening beach should expose coconut palm for early water and food")
	_expect(not world_manager.is_tile_revealed(world_manager.get_tile_id(3, 6)), "blocked cave tile should not reveal directly from start")
	_expect(_move_to(world_manager.get_tile_id(3, 7)), "player should be able to move along the only open beach route")
	var beach_investigate: Dictionary = world_manager.execute_tile_action("investigate", {})
	_expect(bool(beach_investigate.get("ok", false)), "second beach investigation should succeed")
	_expect(_move_to(world_manager.get_tile_id(4, 6)), "player should be able to find the meadow detour")
	_expect(_move_to(world_manager.get_tile_id(3, 7)), "player should be able to return from meadow to beach")
	_expect(_move_to(world_manager.get_tile_id(3, 6)), "player should be able to reach the cave base detour")
	var enter_result: Dictionary = world_manager.execute_tile_action("enter_base", {})
	_expect(bool(enter_result.get("ok", false)), "cave base entry should succeed")
	_expect(game_state.has_flag("entered_base"), "base entry flag should be set")
	_pick_up_base_starter_materials()
	_expect(inventory_manager.get_count("wood") >= 1, "base should provide enough wood for the first fire")
	_expect(inventory_manager.get_count("palm_frond") >= 1, "base should provide enough palm frond for the first fire")
	_expect(crafting_manager.is_recipe_unlocked("small_campfire"), "small campfire should be known from the start")
	var craft_result: Dictionary = crafting_manager.craft("small_campfire")
	_expect(bool(craft_result.get("ok", false)), "small campfire should be craftable from base starter materials")
	var place_result: Dictionary = base_manager.place_item("small_campfire")
	_expect(bool(place_result.get("ok", false)), "small campfire should be placeable at base")
	_expect(base_manager.has_placed_item("small_campfire"), "small campfire should be placed at base")


func _advance_to_day_three() -> void:
	for _index in range(2):
		var transition: Dictionary = game_state.resolve_day_transition()
		if Array(transition.get("messages", [])).is_empty():
			pass
	_expect(game_state.day == 3, "smoke check should reach day three")
	_expect(game_state.weather == "폭풍", "day three should introduce the first storm")


func _check_survival_state() -> void:
	var status = character_manager.player_status
	_expect(status.hp > 0, "player should remain alive by day three")
	_expect(status.hunger > 20, "day three hunger should not already be critical in the basic route")
	_expect(status.thirst > 20, "day three thirst should not already be critical in the basic route")
	_expect(status.stamina > 0, "player should retain some stamina by day three")


func _food_count() -> int:
	var total := 0
	for item_id in ["berry", "wild_potato", "fish", "cooked_fish", "cooked_meat"]:
		total += inventory_manager.get_count(item_id)
	return total


func _move_to(tile_id: String) -> bool:
	var result: Dictionary = world_manager.execute_tile_action("move", {"target_tile_id": tile_id})
	return bool(result.get("ok", false))


func _pick_up_base_starter_materials() -> void:
	var field_items: Dictionary = world_manager.get_tile_field_items(world_manager.current_tile_id)
	for item_id in ["wood", "palm_frond"]:
		var amount := int(field_items.get(item_id, 0))
		if amount <= 0:
			continue
		var result: Dictionary = world_manager.pick_up_field_item(world_manager.current_tile_id, item_id, amount)
		_expect(bool(result.get("ok", false)), "base starter field item should be pickupable: %s" % item_id)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
