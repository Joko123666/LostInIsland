extends SceneTree

const STARTERS := ["survival_axe", "medkit", "handheld_game", "lighter"]
const ROUTE_START := "tile_2_7"
const ROUTE_BEACH := "tile_3_7"
const ROUTE_MEADOW := "tile_4_6"
const ROUTE_BASE := "tile_3_6"
const KEY_ITEM_IDS := [
	"berry",
	"water",
	"wood",
	"fiber",
	"palm_frond",
	"stone",
	"sharp_stone",
	"stone_knife",
	"small_campfire",
	"campfire",
	"stone_oven",
	"survival_axe",
	"medkit",
	"handheld_game",
	"lighter",
]
const CAMPFIRE_REQUIREMENTS := {"stone": 2, "wood": 3, "fiber": 1}
const SMALL_CAMPFIRE_REQUIREMENTS := {"wood": 1, "palm_frond": 1}

var failures: Array[String] = []
var observations: Array[String] = []
var game_state
var inventory_manager
var character_manager
var world_manager
var base_manager
var event_manager
var crafting_manager


func _initialize() -> void:
	seed(1337)
	_bind_autoloads()
	print("FLOW_AUDIT_START")
	_run_starter_comparison()
	_run_main_flow_route()
	_run_pressure_probe()
	_print_observations()
	if failures.is_empty():
		print("FLOW_AUDIT_OK")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("FLOW_AUDIT_FAIL count=%d" % failures.size())
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


func _reset_game(starter_id: String = "survival_axe") -> void:
	game_state.reset_state()
	inventory_manager.reset_state()
	character_manager.reset_state()
	world_manager.reset_state()
	base_manager.reset_state()
	if event_manager.events.is_empty():
		event_manager.load_events()
	event_manager.reset_state()
	crafting_manager.load_recipes()
	var result: Dictionary = inventory_manager.apply_starting_item_choice(starter_id)
	_expect(bool(result.get("ok", false)), "starting item should be selectable: %s" % starter_id)


func _run_starter_comparison() -> void:
	print("SCENARIO starter_comparison")
	for starter_id in STARTERS:
		_reset_game(starter_id)
		var start_tile_id: String = world_manager.current_tile_id
		_expect(start_tile_id == ROUTE_START, "starter route should begin at opening tile")
		var investigate_result: Dictionary = _do_tile_action("investigate")
		_expect(_try_first_object_gather_blocked(), "starter opening gather should be blocked before base entry")
		crafting_manager.evaluate_recipe_unlocks(false)
		print("STARTER %s ok=%s status=%s items=%s recipes=%s revealed=%s" % [
			starter_id,
			str(bool(investigate_result.get("ok", false))),
			_status_summary(),
			_items_summary(KEY_ITEM_IDS),
			_known_recipes_summary(),
			_revealed_tile_summary()
		])
		var useful_unlock_count: int = _useful_recipe_count()
		if starter_id != "survival_axe" and useful_unlock_count <= 1:
			observations.append("Starter %s does not create a distinct pre-base objective yet; starter-specific hooks should be added after the shelter-first loop settles." % starter_id)


func _run_main_flow_route() -> void:
	print("SCENARIO main_flow_route")
	_reset_game("survival_axe")
	_expect(world_manager.get_blocked_edge_note(ROUTE_START, ROUTE_BASE) != "", "opening base-side edge should be blocked")
	_do_tile_action("investigate")
	print("ROUTE after_start status=%s items=%s revealed=%s" % [_status_summary(), _items_summary(KEY_ITEM_IDS), _revealed_tile_summary()])
	_expect(not world_manager.is_tile_revealed(ROUTE_BASE), "blocked base tile should not be revealed from start")
	_move_to(ROUTE_BEACH)
	_do_tile_action("investigate")
	_move_to(ROUTE_MEADOW)
	_resolve_current_event("route_meadow")
	print("ROUTE after_meadow partner_joined=%s status=%s items=%s revealed=%s" % [
		str(character_manager.partner_joined),
		_status_summary(),
		_items_summary(KEY_ITEM_IDS),
		_revealed_tile_summary()
	])
	if not character_manager.partner_joined:
		observations.append("Partner reunion did not resolve automatically on the meadow route; the trigger may be less obvious than expected.")
	_move_to(ROUTE_BEACH)
	if world_manager.is_tile_revealed(ROUTE_BASE):
		_move_to(ROUTE_BASE)
	else:
		observations.append("Base tile remains unrevealed after the first beach/meadow leg; the route needs a stronger visible hook for the cave detour.")
		return
	var enter_result: Dictionary = _do_tile_action("enter_base")
	_pick_up_current_field_items(["wood", "palm_frond"])
	print("ROUTE base_enter ok=%s at_base=%s status=%s items=%s recipes=%s" % [
		str(bool(enter_result.get("ok", false))),
		str(base_manager.is_at_base()),
		_status_summary(),
		_items_summary(KEY_ITEM_IDS),
		_known_recipes_summary()
	])
	_do_tile_action("investigate", {"together": true})
	_gather_all_current_objects(true)
	_attempt_campfire_loop()
	_advance_days(2)
	print("ROUTE after_day3 day=%d status=%s base=%s items=%s" % [
		game_state.day,
		_status_summary(),
		_base_summary(),
		_items_summary(KEY_ITEM_IDS)
	])


func _attempt_campfire_loop() -> void:
	crafting_manager.evaluate_recipe_unlocks(false)
	var small_missing: Dictionary = _missing_items(SMALL_CAMPFIRE_REQUIREMENTS)
	print("CRAFT small_campfire_pre unlocked=%s missing=%s items=%s" % [
		str(crafting_manager.is_recipe_unlocked("small_campfire")),
		_dict_summary(small_missing),
		_items_summary(KEY_ITEM_IDS)
	])
	if crafting_manager.is_recipe_unlocked("small_campfire") and small_missing.is_empty():
		var small_result: Dictionary = crafting_manager.craft("small_campfire")
		_log_craft_result("small_campfire", small_result)
		if bool(small_result.get("ok", false)) and base_manager.is_at_base():
			var small_place_result: Dictionary = base_manager.place_item("small_campfire")
			print("BASE place_small_campfire ok=%s base=%s status=%s" % [
				str(bool(small_place_result.get("ok", false))),
				_base_summary(),
				_status_summary()
			])
	var missing_before: Dictionary = _missing_items(CAMPFIRE_REQUIREMENTS)
	print("CRAFT campfire_pre unlocked=%s missing=%s items=%s" % [
		str(crafting_manager.is_recipe_unlocked("campfire")),
		_dict_summary(missing_before),
		_items_summary(KEY_ITEM_IDS)
	])
	if inventory_manager.get_count("stone") > 0 and not inventory_manager.has_item("sharp_stone"):
		var sharp_result: Dictionary = crafting_manager.craft("sharp_stone")
		_log_craft_result("sharp_stone", sharp_result)
	if crafting_manager.is_recipe_unlocked("campfire") and _missing_items(CAMPFIRE_REQUIREMENTS).is_empty():
		var craft_result: Dictionary = crafting_manager.craft("campfire", character_manager.is_partner_following())
		_log_craft_result("campfire", craft_result)
		_resolve_current_event("craft_campfire")
		if bool(craft_result.get("ok", false)) and base_manager.is_at_base():
			var place_result: Dictionary = base_manager.place_item("campfire")
			print("BASE place_campfire ok=%s base=%s status=%s" % [
				str(bool(place_result.get("ok", false))),
				_base_summary(),
				_status_summary()
			])
	else:
		var missing_after: Dictionary = _missing_items(CAMPFIRE_REQUIREMENTS)
		observations.append("Campfire upgrade stalls with missing materials %s; this is acceptable if the material tokens point to stone-gathering as the next target." % _dict_summary(missing_after))


func _run_pressure_probe() -> void:
	print("SCENARIO pressure_probe")
	_reset_game("survival_axe")
	var actions_done: int = 0
	var low_pressure_step: int = -1
	while actions_done < 14 and not game_state.is_game_over:
		if not world_manager.is_tile_investigated(world_manager.current_tile_id):
			_do_tile_action("investigate")
		else:
			var objects: Array[Dictionary] = world_manager.get_tile_resource_objects(world_manager.current_tile_id, false)
			if not objects.is_empty():
				_gather_first_current_object()
			else:
				_do_tile_action("gather")
		actions_done += 1
		if _is_status_pressure_low() and low_pressure_step < 0:
			low_pressure_step = actions_done
		var moved: bool = false
		for tile_id in world_manager.get_reachable_adjacent_tile_ids(world_manager.current_tile_id):
			var next_id := String(tile_id)
			if world_manager.is_tile_revealed(next_id) and next_id != world_manager.current_tile_id:
				_move_to(next_id)
				moved = true
				break
		if moved:
			actions_done += 1
	print("PRESSURE actions=%d first_low_step=%d day=%d time=%s status=%s items=%s" % [
		actions_done,
		low_pressure_step,
		game_state.day,
		game_state.get_time_label(),
		_status_summary(),
		_items_summary(KEY_ITEM_IDS)
	])
	if low_pressure_step < 0:
		observations.append("Fourteen early actions did not create immediate hunger/thirst pressure; tension needs to come from forecast, scarcity, risk, or timed goals rather than raw stat decay.")


func _do_tile_action(action_id: String, args: Dictionary = {}) -> Dictionary:
	var result: Dictionary = world_manager.execute_tile_action(action_id, args)
	print("ACTION %s ok=%s tile=%s region=%s time=%s status=%s items=%s" % [
		action_id,
		str(bool(result.get("ok", false))),
		String(result.get("tile_id", world_manager.current_tile_id)),
		game_state.current_region_id,
		game_state.get_time_label(),
		_status_summary(),
		_items_summary(KEY_ITEM_IDS)
	])
	if bool(result.get("ok", false)):
		event_manager.evaluate_after_action(action_id, game_state.current_region_id, result)
		_resolve_current_event(action_id)
	return result


func _move_to(tile_id: String) -> Dictionary:
	return _do_tile_action("move", {"target_tile_id": tile_id})


func _gather_all_current_objects(together: bool = false) -> void:
	var safety: int = 12
	while safety > 0:
		safety -= 1
		var objects: Array[Dictionary] = world_manager.get_tile_resource_objects(world_manager.current_tile_id, false)
		if objects.is_empty():
			return
		var object_id := String(Dictionary(objects[0]).get("id", ""))
		var result: Dictionary = world_manager.gather_resource_object(world_manager.current_tile_id, object_id, together)
		print("OBJECT_GATHER %s ok=%s tile=%s status=%s items=%s" % [
			object_id,
			str(bool(result.get("ok", false))),
			world_manager.current_tile_id,
			_status_summary(),
			_items_summary(KEY_ITEM_IDS)
		])
		if bool(result.get("ok", false)):
			event_manager.evaluate_after_action("gather", game_state.current_region_id, result)
			_resolve_current_event("object_gather")
		else:
			return


func _gather_first_current_object() -> void:
	var objects: Array[Dictionary] = world_manager.get_tile_resource_objects(world_manager.current_tile_id, false)
	if objects.is_empty():
		return
	var object_id := String(Dictionary(objects[0]).get("id", ""))
	var result: Dictionary = world_manager.gather_resource_object(world_manager.current_tile_id, object_id, false)
	print("OBJECT_GATHER %s ok=%s tile=%s status=%s items=%s" % [
		object_id,
		str(bool(result.get("ok", false))),
		world_manager.current_tile_id,
		_status_summary(),
		_items_summary(KEY_ITEM_IDS)
	])


func _try_first_object_gather_blocked() -> bool:
	var objects: Array[Dictionary] = world_manager.get_tile_resource_objects(world_manager.current_tile_id, false)
	if objects.is_empty():
		return false
	var object_id := String(Dictionary(objects[0]).get("id", ""))
	var result: Dictionary = world_manager.gather_resource_object(world_manager.current_tile_id, object_id, false)
	print("OBJECT_GATHER_BLOCKED %s ok=%s text_chars=%d" % [
		object_id,
		str(bool(result.get("ok", false))),
		String(result.get("text", "")).length()
	])
	return not bool(result.get("ok", false))


func _pick_up_current_field_items(item_ids: Array) -> void:
	var field_items: Dictionary = world_manager.get_tile_field_items(world_manager.current_tile_id)
	for raw_item_id in item_ids:
		var item_id := String(raw_item_id)
		var amount := int(field_items.get(item_id, 0))
		if amount <= 0:
			continue
		var result: Dictionary = world_manager.pick_up_field_item(world_manager.current_tile_id, item_id, amount)
		print("FIELD_PICKUP %s amount=%d ok=%s items=%s" % [
			item_id,
			amount,
			str(bool(result.get("ok", false))),
			_items_summary(KEY_ITEM_IDS)
		])


func _resolve_current_event(context: String) -> void:
	if event_manager.current_event == null:
		return
	var event_id := String(event_manager.current_event.id)
	print("EVENT_TRIGGERED context=%s id=%s" % [context, event_id])
	var choices: Array = event_manager.current_event.choices
	if choices.is_empty():
		event_manager.current_event = null
		return
	var text: String = event_manager.apply_event_choice(event_id, 0)
	print("EVENT_RESOLVED id=%s choice=0 result_chars=%d partner_joined=%s" % [
		event_id,
		text.length(),
		str(character_manager.partner_joined)
	])


func _advance_days(count: int) -> void:
	for _index in range(count):
		var transition: Dictionary = game_state.resolve_day_transition()
		if event_manager.current_event != null:
			_resolve_current_event("day_transition")
		print("DAY_TRANSITION day=%d weather=%s messages=%d status=%s yields=%s" % [
			game_state.day,
			game_state.weather,
			Array(transition.get("messages", [])).size(),
			_status_summary(),
			_dict_summary(Dictionary(transition.get("daily_yields", {})))
		])


func _status_summary() -> String:
	var status = character_manager.player_status
	var partner := ""
	if character_manager.partner_joined:
		partner = ",partner=%d/%d/%d" % [
			character_manager.partner_status.stamina,
			character_manager.partner_status.mood,
			character_manager.partner_status.trust
		]
	return "hp=%d,hunger=%d,thirst=%d,stamina=%d,hygiene=%d%s" % [
		status.hp,
		status.hunger,
		status.thirst,
		status.stamina,
		status.hygiene,
		partner
	]


func _items_summary(item_ids: Array) -> String:
	var parts: Array[String] = []
	for item_id in item_ids:
		var count: int = _accessible_item_count(String(item_id))
		if count > 0:
			parts.append("%s:%d" % [String(item_id), count])
	return "none" if parts.is_empty() else ",".join(parts)


func _known_recipes_summary() -> String:
	var ids: Array[String] = crafting_manager.get_unlocked_recipe_ids()
	return "none" if ids.is_empty() else ",".join(ids)


func _revealed_tile_summary() -> String:
	var ids: Array[String] = []
	for raw_tile_id in world_manager.revealed_tiles.keys():
		ids.append(String(raw_tile_id))
	ids.sort()
	return ",".join(ids)


func _base_summary() -> String:
	var placed: Array[String] = []
	for object in base_manager.get_placed_objects():
		placed.append(String(Dictionary(object).get("id", "")))
	placed.sort()
	return "at=%s,placed=%s,stats=%s" % [
		str(base_manager.is_at_base()),
		"none" if placed.is_empty() else ",".join(placed),
		_dict_summary(base_manager.stats)
	]


func _dict_summary(data: Dictionary) -> String:
	if data.is_empty():
		return "none"
	var keys: Array = data.keys()
	keys.sort()
	var parts: Array[String] = []
	for raw_key in keys:
		parts.append("%s:%s" % [String(raw_key), str(data[raw_key])])
	return ",".join(parts)


func _missing_items(required_items: Dictionary) -> Dictionary:
	var missing: Dictionary = {}
	for raw_item_id in required_items.keys():
		var item_id := String(raw_item_id)
		var need := int(required_items[raw_item_id])
		var have: int = _accessible_item_count(item_id)
		if have < need:
			missing[item_id] = need - have
	return missing


func _useful_recipe_count() -> int:
	var count: int = 0
	for recipe_id in crafting_manager.get_unlocked_recipe_ids():
		if not ["sharp_stone"].has(String(recipe_id)):
			count += 1
	return count


func _accessible_item_count(item_id: String) -> int:
	var total: int = inventory_manager.get_count(item_id)
	if character_manager.partner_joined:
		total += inventory_manager.get_count(item_id, "partner")
	return total


func _is_status_pressure_low() -> bool:
	var status = character_manager.player_status
	return status.hunger <= 35 or status.thirst <= 35 or status.stamina <= 20


func _log_craft_result(recipe_id: String, result: Dictionary) -> void:
	print("CRAFT %s ok=%s status=%s items=%s recipes=%s" % [
		recipe_id,
		str(bool(result.get("ok", false))),
		_status_summary(),
		_items_summary(KEY_ITEM_IDS),
		_known_recipes_summary()
	])


func _print_observations() -> void:
	print("OBSERVATIONS_START")
	if observations.is_empty():
		print("OBS none")
	else:
		for observation in observations:
			print("OBS %s" % observation)
	print("OBSERVATIONS_END")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
