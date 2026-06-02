extends Node

signal event_triggered(event_data)
signal event_resolved(event_id: String)

var events: Dictionary = {}
var triggered_events: Dictionary = {}
var fact_flags: Dictionary = {}
var current_event


func _ready() -> void:
	load_events()
	reset_state()


func reset_state() -> void:
	triggered_events = {}
	fact_flags = {}
	current_event = null


func load_events() -> void:
	events.clear()
	var dir := DirAccess.open("res://data/events")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var event = load("res://data/events/%s" % file_name)
			if event != null and event.id != "":
				events[event.id] = event
		file_name = dir.get_next()
	dir.list_dir_end()


func notify_fact(fact_id: String) -> void:
	fact_flags[fact_id] = true
	if fact_id == "first_joint_work":
		trigger_event("first_joint_work")


func evaluate_after_action(action_id: String, region_id: String, result: Dictionary = {}) -> void:
	if current_event != null:
		return
	if not GameState.has_flag("partner_joined") and GameState.current_region_id == "meadow":
		trigger_event("partner_reunion")
		return
	if CharacterManager.partner_joined \
			and bool(result.get("together", false)) \
			and ["investigate", "gather", "fish", "develop", "craft"].has(action_id) \
			and not triggered_events.has("first_joint_work"):
		trigger_event("first_joint_work")
		return
	if action_id == "investigate":
		if _investigated_mystery_tile(result):
			trigger_event("strange_marking")
			return
		var region = WorldManager.get_region(region_id)
		if region != null and region.id == "cave" and region.investigation >= 20:
			trigger_event("strange_marking")
			return
	if _try_personality_event(action_id, result):
		return
	if CharacterManager.partner_joined and CharacterManager.partner_status.mood < 30:
		trigger_event("first_conflict")


func _investigated_mystery_tile(result: Dictionary) -> bool:
	var tile_id := String(result.get("tile_id", ""))
	if tile_id == "":
		return false
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return false
	var terrain := String(tile.get("terrain", ""))
	if not ["cave", "ruins"].has(terrain):
		return false
	return int(tile.get("investigation", 0)) >= 20


func evaluate_daily_events() -> void:
	if current_event != null:
		return
	if (GameState.weather == "비" or GameState.weather == "폭우") and not triggered_events.has("first_rain"):
		trigger_event("first_rain")
		return
	if _try_personality_event("daily", {}, true):
		return
	if CharacterManager.partner_joined and CharacterManager.partner_status.mood < 30:
		trigger_event("first_conflict")


func _try_personality_event(action_id: String, result: Dictionary = {}, daily: bool = false) -> bool:
	if current_event != null:
		return false
	if not CharacterManager.partner_joined or CharacterManager.partner_personality == null:
		return false
	var candidates: Array = []
	for event in events.values():
		if event == null or String(event.event_type) != "personality":
			continue
		if _personality_event_matches(event, action_id, result, daily):
			candidates.append(event)
	if candidates.is_empty():
		return false
	candidates.sort_custom(Callable(self, "_sort_personality_events"))
	return trigger_event(String(candidates[0].id))


func _personality_event_matches(event, action_id: String, result: Dictionary, daily: bool) -> bool:
	if event.once and triggered_events.has(event.id):
		return false
	var conditions: Dictionary = event.trigger_conditions
	var personality_id := String(conditions.get("personality", ""))
	if personality_id != "" and CharacterManager.partner_personality.id != personality_id:
		return false
	var trigger_mode := String(conditions.get("trigger", "action"))
	if daily and trigger_mode != "daily":
		return false
	if not daily and trigger_mode == "daily":
		return false
	for raw_flag in Array(conditions.get("requires_flags", [])):
		if not GameState.has_flag(String(raw_flag)):
			return false
	for raw_flag in Array(conditions.get("not_flags", [])):
		if GameState.has_flag(String(raw_flag)):
			return false
	if conditions.has("trust_min") and CharacterManager.partner_status.trust < int(conditions["trust_min"]):
		return false
	if conditions.has("trust_max") and CharacterManager.partner_status.trust > int(conditions["trust_max"]):
		return false
	if conditions.has("mood_min") and CharacterManager.partner_status.mood < int(conditions["mood_min"]):
		return false
	if conditions.has("mood_max") and CharacterManager.partner_status.mood > int(conditions["mood_max"]):
		return false
	if conditions.has("day_min") and GameState.day < int(conditions["day_min"]):
		return false
	if conditions.has("together") and bool(result.get("together", false)) != bool(conditions["together"]):
		return false
	if conditions.has("at_base") and BaseManager.is_at_base() != bool(conditions["at_base"]):
		return false
	var actions: Array = Array(conditions.get("actions", []))
	if not actions.is_empty():
		var result_action := String(result.get("action_id", ""))
		if not actions.has(action_id) and not actions.has(result_action):
			return false
	return true


func _sort_personality_events(first, second) -> bool:
	var first_stage := int(first.trigger_conditions.get("stage", 999))
	var second_stage := int(second.trigger_conditions.get("stage", 999))
	if first_stage == second_stage:
		return String(first.id) < String(second.id)
	return first_stage < second_stage


func trigger_event(event_id: String) -> bool:
	var event = events.get(event_id, null)
	if event == null:
		return false
	if event.once and triggered_events.has(event_id):
		return false
	current_event = event
	if event.once:
		triggered_events[event_id] = GameState.day
	emit_signal("event_triggered", event)
	return true


func get_event_cutscene_steps(event_id: String) -> Array:
	var event = events.get(event_id, null)
	if event == null:
		return []
	return event.cutscene_steps.duplicate(true)


func get_choice_cutscene_steps(event_id: String, choice_index: int) -> Array:
	var event = events.get(event_id, null)
	if event == null:
		return []
	if choice_index < 0 or choice_index >= event.choices.size():
		return []
	var choice: Dictionary = event.choices[choice_index]
	return Array(choice.get("cutscene_steps", [])).duplicate(true)


func apply_event_choice(event_id: String, choice_index: int) -> String:
	var event = events.get(event_id, null)
	if event == null:
		return "이벤트 정보를 찾을 수 없다."
	if choice_index < 0 or choice_index >= event.choices.size():
		return "선택지를 처리하지 못했다."
	var choice = event.choices[choice_index]
	var result_text := String(choice.get("result_text", "선택의 결과가 남았다."))
	var results: Dictionary = choice.get("results", {})
	_apply_results(results)
	current_event = null
	emit_signal("event_resolved", event_id)
	return result_text


func get_save_data() -> Dictionary:
	return {
		"triggered_events": triggered_events.duplicate(true),
		"fact_flags": fact_flags.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	triggered_events = data.get("triggered_events", {}).duplicate(true)
	fact_flags = data.get("fact_flags", {}).duplicate(true)
	current_event = null


func _apply_results(results: Dictionary) -> void:
	if results.has("flags"):
		for flag_id in results["flags"]:
			GameState.set_flag(String(flag_id), true)
	if results.has("join_partner") and bool(results["join_partner"]):
		CharacterManager.mark_partner_joined()
	if results.has("player"):
		CharacterManager.player_status.apply_delta(results["player"])
	if results.has("partner"):
		CharacterManager.partner_status.apply_delta(results["partner"])
	if results.has("items"):
		for item_id in results["items"].keys():
			InventoryManager.add_item(String(item_id), int(results["items"][item_id]))
	if results.has("memories"):
		for raw_memory in Array(results["memories"]):
			if typeof(raw_memory) != TYPE_DICTIONARY:
				continue
			var memory: Dictionary = Dictionary(raw_memory)
			CharacterManager.record_relationship_memory(
				String(memory.get("id", "")),
				String(memory.get("text", "")),
				String(memory.get("icon", "actions/talk")),
				int(memory.get("importance", 1))
			)
	CharacterManager.notify_status_changed()
