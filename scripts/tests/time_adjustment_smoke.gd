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
	_bind_autoloads()
	_reset_game()
	_check_rest_minutes()
	_check_sleep_twenty_hours()
	if failures.is_empty():
		print("TIME_ADJUSTMENT_SMOKE_OK")
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


func _check_rest_minutes() -> void:
	var blocked_rest: Dictionary = world_manager.execute_tile_action("rest", {"rest_minutes": 15})
	_expect(not bool(blocked_rest.get("ok", false)), "pre-base rest should be blocked by shelter-first opening")
	_reach_base()
	var start_minutes: int = game_state.current_minutes
	var short_rest: Dictionary = world_manager.execute_tile_action("rest", {"rest_minutes": 15})
	_expect(bool(short_rest.get("ok", false)), "15 minute rest should succeed")
	_expect(int(short_rest.get("rest_minutes", 0)) == 15, "rest result should keep selected 15 minutes")
	_expect(game_state.current_minutes == start_minutes + 15, "15 minute rest should advance exactly 15 minutes")
	var long_rest: Dictionary = world_manager.execute_tile_action("rest", {"rest_minutes": 120})
	_expect(bool(long_rest.get("ok", false)), "120 minute rest should succeed")
	_expect(int(long_rest.get("rest_minutes", 0)) == 120, "rest result should keep selected 120 minutes")
	_expect(game_state.current_minutes == start_minutes + 135, "120 minute rest should advance exactly 120 more minutes")


func _check_sleep_twenty_hours() -> void:
	var start_day: int = game_state.day
	var start_minutes: int = game_state.current_minutes
	character_manager.recover_sleep(20)
	game_state.sleep_for_hours(20)
	var expected_total: int = start_minutes + 20 * 60
	var expected_day_delta: int = int(floor(float(expected_total) / float(game_state.MINUTES_PER_DAY)))
	var expected_minutes: int = expected_total % game_state.MINUTES_PER_DAY
	_expect(game_state.day == start_day + expected_day_delta, "20 hour sleep should advance the expected day count")
	_expect(game_state.current_minutes == expected_minutes, "20 hour sleep should land on the expected clock time")


func _reach_base() -> void:
	world_manager.execute_tile_action("investigate", {})
	world_manager.execute_tile_action("move", {"target_tile_id": world_manager.get_tile_id(3, 7)})
	world_manager.execute_tile_action("investigate", {})
	world_manager.execute_tile_action("move", {"target_tile_id": world_manager.get_tile_id(4, 6)})
	world_manager.execute_tile_action("move", {"target_tile_id": world_manager.get_tile_id(3, 7)})
	world_manager.execute_tile_action("move", {"target_tile_id": world_manager.get_tile_id(3, 6)})
	var enter_result: Dictionary = world_manager.execute_tile_action("enter_base", {})
	_expect(bool(enter_result.get("ok", false)), "base entry should succeed before rest timing checks")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
