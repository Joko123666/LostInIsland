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
	_check_investigation_respects_blocked_edges()
	if failures.is_empty():
		print("WALL_REVEAL_SMOKE_OK")
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


func _check_investigation_respects_blocked_edges() -> void:
	var start_tile_id: String = world_manager.current_tile_id
	var blocked_neighbor := "tile_3_6"
	_expect(start_tile_id == world_manager.get_tile_id(2, 7), "smoke should start on the opening beach tile")
	_expect(world_manager.get_neighbor_tile_ids(start_tile_id).has(blocked_neighbor), "blocked cave-side tile should be adjacent to start")
	_expect(world_manager.get_blocked_edge_note(start_tile_id, blocked_neighbor) != "", "start to cave-side tile should have a blocked edge")
	var reachable_neighbors: Array[String] = []
	for neighbor_id in world_manager.get_neighbor_tile_ids(start_tile_id):
		if world_manager.can_move_between_tiles(start_tile_id, String(neighbor_id)):
			reachable_neighbors.append(String(neighbor_id))
	_expect(not reachable_neighbors.is_empty(), "start tile should have at least one reachable adjacent tile")
	var result: Dictionary = world_manager.execute_tile_action("investigate", {})
	_expect(bool(result.get("ok", false)), "opening investigation should succeed")
	_expect(not world_manager.is_tile_revealed(blocked_neighbor), "investigation should not reveal a tile behind a blocked edge")
	for neighbor_id in reachable_neighbors:
		_expect(world_manager.is_tile_revealed(neighbor_id), "investigation should reveal reachable adjacent tile %s" % neighbor_id)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
