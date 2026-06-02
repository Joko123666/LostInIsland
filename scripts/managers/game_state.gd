extends Node

signal day_changed(day: int, season: String, weather: String)
signal action_points_changed(action_points: int)
signal time_changed(current_minutes: int, is_daylight: bool)
signal location_changed(region_id: String)
signal flag_changed(flag_id: String, value: Variant)
signal game_over(reason: String)

const MINUTES_PER_ACTION_SLOT := 30
const MINUTES_PER_DAY := 1440
const MAX_ACTION_POINTS := 48

var day: int = 1
var season: String = "평온기"
var weather: String = "맑음"
var next_weather: String = "흐림"
var action_points: int = MAX_ACTION_POINTS
var current_minutes: int = 360
var current_region_id: String = "beach"
var flags: Dictionary = {}
var is_game_over: bool = false
var game_over_reason: String = ""

var _weather_cycle: Array[String] = ["맑음", "흐림", "비", "맑음", "흐림", "맑음", "비"]


func _ready() -> void:
	reset_state()


func reset_state() -> void:
	day = 1
	season = _season_for_day(day)
	weather = _weather_for_day(day)
	next_weather = _weather_for_day(day + 1)
	current_minutes = get_sunrise_minutes()
	current_region_id = "beach"
	flags = {}
	is_game_over = false
	game_over_reason = ""
	_refresh_action_slots()
	emit_signal("day_changed", day, season, weather)
	emit_signal("location_changed", current_region_id)


func can_spend_action_points(cost: int) -> bool:
	return not is_game_over and cost >= 0 and current_minutes + cost * MINUTES_PER_ACTION_SLOT < MINUTES_PER_DAY


func can_spend_minutes(minutes: int) -> bool:
	return not is_game_over and minutes >= 0 and current_minutes + minutes < MINUTES_PER_DAY


func spend_action_points(cost: int) -> bool:
	if not can_spend_action_points(cost):
		return false
	current_minutes = mini(MINUTES_PER_DAY - 1, current_minutes + cost * MINUTES_PER_ACTION_SLOT)
	_refresh_action_slots()
	return true


func spend_minutes(minutes: int) -> bool:
	if not can_spend_minutes(minutes):
		return false
	current_minutes = mini(MINUTES_PER_DAY - 1, current_minutes + minutes)
	_refresh_action_slots()
	return true


func restore_action_points() -> void:
	current_minutes = get_sunrise_minutes()
	_refresh_action_slots()


func get_max_action_points() -> int:
	return MAX_ACTION_POINTS


func get_time_label() -> String:
	var hour := int(current_minutes / 60)
	var minute := current_minutes % 60
	return "%02d:%02d" % [hour, minute]


func get_sunrise_minutes() -> int:
	match season:
		"우기":
			return 6 * 60 + 30
		"건기":
			return 5 * 60 + 30
		"폭풍기":
			return 7 * 60
	return 6 * 60


func get_sunset_minutes() -> int:
	match season:
		"우기":
			return 17 * 60 + 30
		"건기":
			return 19 * 60
		"폭풍기":
			return 17 * 60
	return 18 * 60 + 30


func is_daylight_time() -> bool:
	return current_minutes >= get_sunrise_minutes() and current_minutes < get_sunset_minutes()


func get_day_phase() -> String:
	var sunrise := get_sunrise_minutes()
	var sunset := get_sunset_minutes()
	if current_minutes < sunrise:
		return "새벽"
	if current_minutes < 10 * 60:
		return "아침"
	if current_minutes < 17 * 60:
		return "낮"
	if current_minutes < sunset:
		return "저녁"
	return "밤"


func can_perform_action_now(action_id: String) -> bool:
	if is_daylight_time():
		return true
	return not ["investigate", "craft"].has(action_id)


func get_action_restriction_text(action_id: String) -> String:
	if can_perform_action_now(action_id):
		if is_daylight_time():
			return ""
		return "야간 가중"
	if action_id == "investigate":
		return "야간 조사 불가"
	if action_id == "craft":
		return "야간 제작 불가"
	return "야간 불가"


func get_adjusted_action_cost(action_id: String, base_cost: Dictionary) -> Dictionary:
	var adjusted := {
		"time": int(base_cost.get("time", 0)),
		"stamina": int(base_cost.get("stamina", 0))
	}
	if is_daylight_time() or not can_perform_action_now(action_id):
		return adjusted
	if int(adjusted["time"]) > 0:
		adjusted["time"] = max(int(adjusted["time"]) + 1, int(ceil(float(adjusted["time"]) * 1.5)))
	if int(adjusted["stamina"]) > 0:
		adjusted["stamina"] = max(int(adjusted["stamina"]) + 2, int(ceil(float(adjusted["stamina"]) * 1.35)))
	return adjusted


func sleep_for_hours(hours: int) -> Dictionary:
	var sleep_minutes := clampi(hours, 1, 20) * 60
	var days_advanced := 0
	var messages: Array[String] = []
	var daily_yields: Dictionary = {}
	while sleep_minutes > 0:
		var minutes_until_midnight := MINUTES_PER_DAY - current_minutes
		if sleep_minutes < minutes_until_midnight:
			current_minutes += sleep_minutes
			sleep_minutes = 0
		else:
			sleep_minutes -= minutes_until_midnight
			var transition := resolve_day_transition(false)
			days_advanced += int(transition.get("days_advanced", 0))
			for message in Array(transition.get("messages", [])):
				messages.append(String(message))
			var transition_yields: Dictionary = transition.get("daily_yields", {})
			for item_id in transition_yields.keys():
				daily_yields[String(item_id)] = int(daily_yields.get(String(item_id), 0)) + int(transition_yields[item_id])
			if is_game_over:
				sleep_minutes = 0
	_refresh_action_slots()
	emit_signal("day_changed", day, season, weather)
	return {
		"days_advanced": days_advanced,
		"time": get_time_label(),
		"messages": messages,
		"daily_yields": daily_yields
	}


func set_current_region(region_id: String) -> void:
	if current_region_id == region_id:
		return
	current_region_id = region_id
	emit_signal("location_changed", current_region_id)


func advance_day() -> void:
	resolve_day_transition(true)


func resolve_day_transition(reset_time_to_sunrise: bool = true) -> Dictionary:
	if is_game_over:
		return {
			"days_advanced": 0,
			"weather": weather,
			"messages": [],
			"daily_yields": {}
	}
	var transition_weather := weather
	var incoming_weather := next_weather
	var messages: Array[String] = []
	for message in CharacterManager.apply_daily_decay(transition_weather):
		messages.append(String(message))
	if is_game_over:
		return {
			"days_advanced": 0,
			"weather": transition_weather,
			"messages": messages,
			"daily_yields": {}
		}
	WorldManager.recover_daily_resources(incoming_weather)
	for world_message in WorldManager.consume_world_messages():
		messages.append(String(world_message))
	var daily_yields: Dictionary = {}
	daily_yields = BaseManager.collect_daily_yields(incoming_weather)
	if not is_game_over:
		_advance_day_without_time_reset()
		if reset_time_to_sunrise:
			restore_action_points()
		else:
			current_minutes = 0
			_refresh_action_slots()
		emit_signal("day_changed", day, season, weather)
		EventManager.evaluate_daily_events()
	return {
		"days_advanced": 1 if not is_game_over else 0,
		"weather": incoming_weather,
		"messages": messages,
		"daily_yields": daily_yields
	}


func set_flag(flag_id: String, value: Variant = true) -> void:
	flags[flag_id] = value
	emit_signal("flag_changed", flag_id, value)


func has_flag(flag_id: String) -> bool:
	return bool(flags.get(flag_id, false))


func trigger_game_over(reason: String) -> void:
	if is_game_over:
		return
	is_game_over = true
	game_over_reason = reason
	emit_signal("game_over", reason)


func get_save_data() -> Dictionary:
	return {
		"day": day,
		"season": season,
		"weather": weather,
		"next_weather": next_weather,
		"action_points": action_points,
		"current_minutes": current_minutes,
		"current_region_id": current_region_id,
		"flags": flags.duplicate(true),
		"is_game_over": is_game_over,
		"game_over_reason": game_over_reason
	}


func load_save_data(data: Dictionary) -> void:
	day = int(data.get("day", 1))
	season = String(data.get("season", _season_for_day(day)))
	weather = String(data.get("weather", _weather_for_day(day)))
	next_weather = String(data.get("next_weather", _weather_for_day(day + 1)))
	current_minutes = int(data.get("current_minutes", get_sunrise_minutes()))
	current_region_id = String(data.get("current_region_id", "beach"))
	flags = data.get("flags", {}).duplicate(true)
	is_game_over = bool(data.get("is_game_over", false))
	game_over_reason = String(data.get("game_over_reason", ""))
	_refresh_action_slots()
	emit_signal("day_changed", day, season, weather)
	emit_signal("location_changed", current_region_id)


func _refresh_action_slots() -> void:
	action_points = max(0, int(floor(float(MINUTES_PER_DAY - 1 - current_minutes) / float(MINUTES_PER_ACTION_SLOT))))
	emit_signal("action_points_changed", action_points)
	emit_signal("time_changed", current_minutes, is_daylight_time())


func _advance_day_without_time_reset() -> void:
	if is_game_over:
		return
	day += 1
	season = _season_for_day(day)
	weather = next_weather
	next_weather = _weather_for_day(day + 1)


func _season_for_day(target_day: int) -> String:
	if target_day <= 7:
		return "평온기"
	if target_day <= 12:
		return "우기"
	if target_day <= 17:
		return "건기"
	return "폭풍기"


func _weather_for_day(target_day: int) -> String:
	if target_day == 3:
		return "폭풍"
	if target_day > 3 and (target_day - 3) % 7 == 0:
		var storm_index := int((target_day - 3) / 7)
		return "폭풍" if storm_index % 2 == 0 else "폭우"
	return _weather_cycle[(target_day - 1) % _weather_cycle.size()]
