extends Node

signal status_changed
signal partner_joined_changed(joined: bool)
signal partner_personality_changed(personality_id: String)

const CharacterStatusScript = preload("res://scripts/character/character_status.gd")
const PartnerPersonalityScript = preload("res://scripts/character/partner_personality.gd")

var player_status
var partner_status
var partner_personality
var partner_joined: bool = false
var partner_following: bool = false
var partner_tile_id: String = ""
var partner_task_id: String = ""
var partner_task_tile_id: String = ""
var pending_status_messages: Array[String] = []
var relationship_memories: Array[Dictionary] = []


func _ready() -> void:
	reset_state()


func reset_state() -> void:
	player_status = CharacterStatusScript.new()
	partner_status = CharacterStatusScript.new()
	partner_status.mood = 55
	partner_status.trust = 0
	partner_status.affection = 0
	partner_joined = false
	partner_following = false
	partner_tile_id = ""
	partner_task_id = ""
	partner_task_tile_id = ""
	relationship_memories.clear()
	choose_personality("cautious")
	emit_signal("status_changed")
	emit_signal("partner_joined_changed", partner_joined)


func choose_personality(personality_id: String) -> void:
	var personality = load("res://data/personalities/%s.tres" % personality_id)
	if personality == null:
		personality = PartnerPersonalityScript.new()
		personality.id = "cautious"
		personality.display_name = "신중함"
		personality.description = "위험을 피하려 하지만 탐험에는 불안을 느낀다."
	partner_personality = personality
	emit_signal("partner_personality_changed", partner_personality.id)


func mark_partner_joined() -> void:
	if partner_joined:
		return
	partner_joined = true
	partner_following = true
	partner_tile_id = ""
	partner_task_id = ""
	partner_task_tile_id = ""
	partner_status.mood += 8
	partner_status.trust += 5
	partner_status.affection += 5
	partner_status.clamp_values()
	GameState.set_flag("partner_joined", true)
	emit_signal("partner_joined_changed", partner_joined)
	emit_signal("status_changed")


func is_partner_following() -> bool:
	return partner_joined and partner_following


func get_partner_tile_id(current_tile_id: String = "") -> String:
	if not partner_joined:
		return ""
	if partner_following:
		return current_tile_id
	return partner_tile_id


func sync_partner_tile(current_tile_id: String) -> void:
	if partner_joined and partner_following:
		partner_tile_id = current_tile_id
		partner_task_id = ""
		partner_task_tile_id = ""


func get_partner_mode_id() -> String:
	if not partner_joined:
		return "missing"
	if partner_following:
		return "together"
	if partner_task_id != "" and partner_task_id != "wait":
		return "assigned"
	return "separate"


func get_partner_mode_label() -> String:
	match get_partner_mode_id():
		"together":
			return "동행"
		"assigned":
			return "맡김"
		"separate":
			return "따로"
	return "미합류"


func get_partner_task_label() -> String:
	var task := _partner_task_definition(partner_task_id)
	if task.is_empty():
		return "대기"
	return String(task.get("label", "대기"))


func get_partner_task_detail() -> String:
	var task := _partner_task_definition(partner_task_id)
	if task.is_empty():
		return "현재 위치에서 조용히 기다린다."
	return String(task.get("detail", "현재 위치에서 조용히 기다린다."))


func get_partner_mode_short_text() -> String:
	match get_partner_mode_id():
		"together":
			return "함께 이동"
		"assigned":
			return "맡김: %s" % get_partner_task_label()
		"separate":
			return "따로 대기"
	return "합류 전"


func get_partner_mode_summary(location_label: String = "") -> String:
	if not partner_joined:
		return "아직 파트너와 합류하지 않았다."
	var location_text := location_label if location_label != "" else "알 수 없음"
	match get_partner_mode_id():
		"together":
			return _join_strings([
				"함께 이동 중",
				"행동 보조와 위험 분산이 가능하지만 파트너 기력도 함께 줄어든다.",
				"위치: 현재 위치"
			], "\n")
		"assigned":
			return _join_strings([
				"맡긴 일: %s" % get_partner_task_label(),
				get_partner_task_detail(),
				"위치: %s" % location_text,
				"다시 지시하거나 동행하려면 같은 타일에서 말을 걸어야 한다."
			], "\n")
		"separate":
			return _join_strings([
				"따로 대기 중",
				"혼자 행동하므로 동행 보조는 없지만 파트너의 추가 소모도 적다.",
				"위치: %s" % location_text
			], "\n")
	return "파트너 상태를 확인할 수 없다."


func get_partner_map_tooltip(location_label: String = "") -> String:
	if not partner_joined:
		return "파트너 미합류"
	var lines: Array[String] = ["파트너 위치", get_partner_mode_short_text()]
	if location_label != "":
		lines.append("위치: %s" % location_label)
	if get_partner_mode_id() == "assigned":
		lines.append(get_partner_task_detail())
	return _join_strings(lines, "\n")


func get_partner_available_tasks() -> Array[Dictionary]:
	var tasks: Array[Dictionary] = []
	for task_id in ["wait", "watch", "scout", "recover"]:
		var task := _partner_task_definition(task_id)
		if task.is_empty():
			continue
		var item := task.duplicate(true)
		var stamina_cost := int(item.get("stamina_cost", 0))
		item["disabled_reason"] = ""
		if partner_status.stamina < stamina_cost:
			item["disabled_reason"] = "파트너 기력이 부족하다."
		tasks.append(item)
	return tasks


func assign_partner_task(task_id: String, tile_id: String) -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 파트너를 찾지 못했다.")
	if tile_id == "":
		return _action_fail("파트너에게 맡길 위치를 정할 수 없다.")
	if not partner_following and partner_tile_id != tile_id:
		return _action_fail("파트너가 있는 타일에서 말을 걸어야 일을 맡길 수 있다.")
	var task := _partner_task_definition(task_id)
	if task.is_empty():
		return _action_fail("맡길 수 없는 일이다.")
	var stamina_cost := int(task.get("stamina_cost", 0))
	if partner_status.stamina < stamina_cost:
		return _action_fail("파트너 기력이 부족해 그 일을 맡기기 어렵다.")
	partner_following = false
	partner_tile_id = tile_id
	partner_task_id = String(task.get("id", "wait"))
	partner_task_tile_id = tile_id
	if stamina_cost > 0:
		partner_status.apply_delta({"stamina": -stamina_cost})
	var delta: Dictionary = task.get("delta", {})
	if not delta.is_empty():
		partner_status.apply_delta(delta)
	partner_status.clamp_values()
	emit_signal("status_changed")
	return {
		"ok": true,
		"text": "파트너에게 '%s'을/를 맡겼다. 이제 파트너는 이 타일에 남아 그 역할을 우선한다." % String(task.get("label", "대기")),
		"action_id": "partner_assign",
		"partner_line": String(task.get("line", "알겠어. 여기서 할 수 있는 만큼 해볼게.")),
		"items": {}
	}


func _partner_task_definition(task_id: String) -> Dictionary:
	match task_id:
		"wait", "":
			return {
				"id": "wait",
				"label": "대기",
				"icon": "actions/rest",
				"detail": "현재 위치에서 움직이지 않고 기다린다.",
				"stamina_cost": 0,
				"delta": {},
				"line": "응. 여기서 기다리고 있을게."
			}
		"watch":
			return {
				"id": "watch",
				"label": "경계",
				"icon": "actions/investigate",
				"detail": "주변 소리와 길목을 살피며 위험한 기척을 먼저 알아차리려 한다.",
				"stamina_cost": 2,
				"delta": {"trust": 1},
				"line": "알겠어. 이상한 소리가 나면 바로 기억해둘게."
			}
		"scout":
			return {
				"id": "scout",
				"label": "살피기",
				"icon": "actions/gather",
				"detail": "무리하지 않는 범위에서 주변 자원과 쓸 만한 흔적을 살핀다.",
				"stamina_cost": 3,
				"delta": {"trust": 1, "mood": -1},
				"line": "멀리는 안 갈게. 눈에 띄는 것만 확인해볼게."
			}
		"recover":
			return {
				"id": "recover",
				"label": "몸 추스르기",
				"icon": "status/stamina",
				"detail": "현재 위치에서 체력을 아끼며 다음 동행을 준비한다.",
				"stamina_cost": 0,
				"delta": {"mood": 1},
				"line": "조금 쉬고 있을게. 다시 움직일 수 있게."
			}
	return {}


func separate_partner_at_tile(tile_id: String) -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 파트너를 찾지 못했다.")
	if tile_id == "":
		return _action_fail("파트너가 머물 타일을 정할 수 없다.")
	if not partner_following and partner_tile_id == tile_id and partner_task_id == "wait":
		return _action_fail("이미 이 타일에서 따로 움직이고 있다.")
	partner_following = false
	partner_tile_id = tile_id
	partner_task_id = "wait"
	partner_task_tile_id = tile_id
	partner_status.apply_delta({"trust": -1})
	emit_signal("status_changed")
	return {
		"ok": true,
		"text": "파트너에게 이곳에서 따로 움직이자고 말했다. 파트너가 현재 타일에 남았다.",
		"action_id": "partner_separate",
		"partner_line": "알겠어. 너무 멀어지지는 않을게.",
		"items": {}
	}


func ask_partner_to_follow(current_tile_id: String) -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 파트너를 찾지 못했다.")
	if partner_following:
		return _action_fail("이미 함께 움직이고 있다.")
	if partner_tile_id != "" and partner_tile_id != current_tile_id:
		return _action_fail("파트너가 있는 타일에서 말을 걸어야 한다.")
	partner_following = true
	partner_tile_id = current_tile_id
	partner_task_id = ""
	partner_task_tile_id = ""
	partner_status.apply_delta({"trust": 1, "mood": 1})
	emit_signal("status_changed")
	return {
		"ok": true,
		"text": "파트너에게 다시 함께 움직이자고 말했다.",
		"action_id": "partner_follow",
		"partner_line": "응. 다시 같이 가자.",
		"items": {}
	}


func can_spend_stamina(cost: int, include_partner: bool = false) -> bool:
	var player_cost := _effective_stamina_cost(player_status, cost)
	if player_status.stamina < player_cost:
		return false
	if include_partner and is_partner_following():
		var partner_cost := _effective_stamina_cost(partner_status, _partner_stamina_cost(cost))
		if partner_status.stamina < partner_cost:
			return false
	return true


func spend_stamina(cost: int, include_partner: bool = false) -> bool:
	if not can_spend_stamina(cost, include_partner):
		return false
	var player_cost := _effective_stamina_cost(player_status, cost)
	if player_cost > cost:
		pending_status_messages.append(_stamina_pressure_message("플레이어", player_status, player_cost - cost))
	player_status.stamina -= player_cost
	if include_partner and is_partner_following():
		var base_partner_cost := _partner_stamina_cost(cost)
		var partner_cost := _effective_stamina_cost(partner_status, base_partner_cost)
		if partner_cost > base_partner_cost:
			pending_status_messages.append(_stamina_pressure_message("파트너", partner_status, partner_cost - base_partner_cost))
		partner_status.stamina -= partner_cost
	player_status.clamp_values()
	partner_status.clamp_values()
	emit_signal("status_changed")
	return true


func get_effective_stamina_cost_preview(cost: int, target_id: String = "player") -> int:
	return _effective_stamina_cost(_status_for_target(target_id), cost)


func _effective_stamina_cost(status, base_cost: int) -> int:
	if status == null or base_cost <= 0:
		return maxi(0, base_cost)
	var multiplier := 1.0
	if status.thirst <= 20:
		multiplier += 0.28
	elif status.thirst <= 35:
		multiplier += 0.12
	if status.hunger <= 20:
		multiplier += 0.20
	elif status.hunger <= 35:
		multiplier += 0.08
	if status.has_state("fatigue"):
		multiplier += 0.18
	if status.has_state("wet"):
		multiplier += 0.10
	if status.has_state("wound"):
		multiplier += 0.16
	if status.has_state("infection_risk"):
		multiplier += 0.12
	return maxi(0, int(ceil(float(base_cost) * multiplier)))


func _stamina_pressure_message(label: String, status, extra_cost: int) -> String:
	var reasons: Array[String] = []
	if status.thirst <= 35:
		reasons.append("갈증")
	if status.hunger <= 35:
		reasons.append("허기")
	if status.has_state("fatigue"):
		reasons.append("피로")
	if status.has_state("wet"):
		reasons.append("젖은 몸")
	if status.has_state("wound"):
		reasons.append("상처")
	if status.has_state("infection_risk"):
		reasons.append("감염 위험")
	if reasons.is_empty():
		reasons.append("몸 상태")
	return "%s의 %s 때문에 기력이 추가로 %d 소모되었다." % [label, _join_strings(reasons, ", "), extra_cost]


func _modified_recovery_gain(status, base_gain: int, recovery_id: String, label: String, messages: Array[String]) -> int:
	if status == null or base_gain <= 0:
		return maxi(0, base_gain)
	var multiplier := 1.0
	var reasons: Array[String] = []
	if status.thirst <= 20:
		multiplier -= 0.35
		reasons.append("수분 부족")
	elif status.thirst <= 35:
		multiplier -= 0.15
		reasons.append("갈증")
	if status.hunger <= 20:
		multiplier -= 0.25
		reasons.append("허기")
	elif status.hunger <= 35:
		multiplier -= 0.10
		reasons.append("공복")
	if status.has_state("wet") and recovery_id == "rest":
		multiplier -= 0.15
		reasons.append("젖은 몸")
	if status.has_state("wound"):
		multiplier -= 0.10
		reasons.append("상처")
	if status.has_state("infection_risk"):
		multiplier -= 0.15
		reasons.append("감염 위험")
	var result := maxi(1, int(floor(float(base_gain) * clampf(multiplier, 0.35, 1.2))))
	if result < base_gain and not reasons.is_empty():
		messages.append("%s의 %s 때문에 회복량이 줄었다. (%d -> %d)" % [label, _join_strings(reasons, ", "), base_gain, result])
	return result


func recover_rest(together: bool = false, minutes: int = 30) -> String:
	var profile := BaseManager.get_rest_recovery_profile()
	var rest_minutes := clampi(minutes, 15, 120)
	rest_minutes = clampi(int(round(float(rest_minutes) / 15.0)) * 15, 15, 120)
	var recovery_scale := float(rest_minutes) / 30.0
	var mood_gain := maxi(0, int(round(float(int(profile.get("mood", 0))) * recovery_scale)))
	var hygiene_gain := maxi(0, int(round(float(int(profile.get("hygiene_recovery", 0))) * recovery_scale)))
	var duration_label := "%d분" % rest_minutes
	var hour_count := int(rest_minutes / 60)
	var minute_count := rest_minutes % 60
	if hour_count > 0 and minute_count > 0:
		duration_label = "%d시간 %d분" % [hour_count, minute_count]
	elif hour_count > 0:
		duration_label = "%d시간" % hour_count
	var messages: Array[String] = []
	var player_base_gain := maxi(1, int(round(float(int(profile.get("player_stamina", 9))) * recovery_scale)))
	var player_stamina_gain := _modified_recovery_gain(player_status, player_base_gain, "rest", "플레이어", messages)
	player_status.apply_delta({"stamina": player_stamina_gain, "mood": mood_gain, "hygiene": hygiene_gain})
	if hygiene_gain > 0:
		_update_hygiene_state(player_status, "플레이어", messages)
		_remove_state_if_present(player_status, "플레이어", "wet", messages)
	if mood_gain > 0 and player_status.has_state("anxiety"):
		_remove_state_if_present(player_status, "플레이어", "anxiety", messages)
	var message := "%s에서 %s 쉬며 기력을 회복했다." % [String(profile.get("label", "야외")), duration_label]
	if partner_joined:
		var partner_mood_gain := mood_gain
		if together and is_partner_following():
			partner_mood_gain += maxi(1, int(round(recovery_scale)))
			partner_status.trust += maxi(0, int(round(float(int(profile.get("trust", 0))) * recovery_scale)))
			message = "%s에서 %s 동안 둘이 함께 쉬며 긴장을 조금 풀었다." % [String(profile.get("label", "야외")), duration_label]
		var partner_base_gain := maxi(1, int(round(float(int(profile.get("partner_stamina", 8))) * recovery_scale)))
		var partner_stamina_gain := _modified_recovery_gain(partner_status, partner_base_gain, "rest", "파트너", messages)
		partner_status.apply_delta({"stamina": partner_stamina_gain, "mood": partner_mood_gain, "hygiene": hygiene_gain})
		if hygiene_gain > 0:
			_update_hygiene_state(partner_status, "파트너", messages)
			_remove_state_if_present(partner_status, "파트너", "wet", messages)
		if partner_mood_gain > 0 and partner_status.has_state("anxiety"):
			_remove_state_if_present(partner_status, "파트너", "anxiety", messages)
	if not messages.is_empty():
		message += "\n" + _join_strings(messages, "\n")
	emit_signal("status_changed")
	return message


func wash_up(together: bool = false, source_label: String = "물가", hygiene_gain: int = 18) -> String:
	var messages: Array[String] = []
	_apply_wash_to_status(player_status, "플레이어", source_label, hygiene_gain, messages)
	if together and partner_joined and is_partner_following():
		_apply_wash_to_status(partner_status, "파트너", source_label, maxi(10, int(ceil(float(hygiene_gain) * 0.8))), messages)
		partner_status.apply_delta({"trust": 1})
	_check_game_over()
	emit_signal("status_changed")
	return _join_strings(messages, "\n")


func recover_sleep(hours: int) -> Array[String]:
	var sleep_hours := clampi(hours, 1, 20)
	var messages: Array[String] = []
	_apply_sleep_to_status(player_status, "플레이어", sleep_hours, messages)
	if partner_joined:
		_apply_sleep_to_status(partner_status, "파트너", sleep_hours, messages)
	_check_game_over()
	emit_signal("status_changed")
	return messages


func talk() -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 파트너를 찾지 못했다.")
	var cost := GameState.get_adjusted_action_cost("talk", {"time": 1, "stamina": 2})
	var time_cost := int(cost.get("time", 1))
	var stamina_cost := int(cost.get("stamina", 2))
	if not GameState.can_spend_action_points(time_cost):
		return _action_fail("대화할 시간이 부족하다.")
	if not can_spend_stamina(stamina_cost):
		return _action_fail("대화할 기력이 부족하다.")
	GameState.spend_action_points(time_cost)
	spend_stamina(stamina_cost)
	apply_action_metabolism("talk", time_cost, stamina_cost, partner_joined)
	var metabolism_messages := consume_status_messages()
	var mood_gain := 4
	var trust_gain := 1
	if partner_personality != null and partner_personality.id == "optimistic":
		mood_gain += 1
	partner_status.apply_delta({"mood": mood_gain, "trust": trust_gain, "affection": 2})
	player_status.apply_delta({"mood": 1})
	var messages: Array[String] = []
	messages.append_array(metabolism_messages)
	_remove_state_if_present(player_status, "플레이어", "anxiety", messages)
	_remove_state_if_present(partner_status, "파트너", "anxiety", messages)
	emit_signal("status_changed")
	var text := "짧은 대화가 이어졌다. 파트너의 표정이 조금 누그러졌다."
	if not messages.is_empty():
		text += "\n" + _join_strings(messages, "\n")
	return {
		"ok": true,
		"text": text,
		"partner_line": _partner_reply_for_topic("daily"),
		"action_id": "talk",
		"items": {}
	}


func ask_partner_condition() -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 말을 걸 파트너가 없다.")
	var lines: Array[String] = []
	lines.append("상태를 물었다.")
	lines.append(_partner_condition_text())
	lines.append("필요: %s" % _partner_need_text())
	lines.append("반응: %s" % get_relationship_cue_text())
	return {
		"ok": true,
		"text": _join_strings(lines, "\n"),
		"partner_line": _partner_reply_for_topic("check"),
		"action_id": "partner_check",
		"items": {}
	}


func comfort_partner() -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 위로할 파트너가 없다.")
	var payment := _pay_partner_interaction_cost("talk", 1, 2, "안심시킬 시간이 부족하다.", "안심시킬 기력이 부족하다.")
	if not bool(payment.get("ok", false)):
		return payment
	var mood_gain := 3
	var trust_gain := 2
	if partner_status.mood <= 40:
		mood_gain += 3
	if partner_status.has_state("anxiety") or partner_status.has_state("fear") or partner_status.has_state("loneliness"):
		mood_gain += 2
		trust_gain += 1
	partner_status.apply_delta({"mood": mood_gain, "trust": trust_gain, "affection": 2})
	player_status.apply_delta({"mood": 1})
	var messages: Array[String] = []
	messages.append_array(payment.get("messages", []))
	if partner_status.mood >= 42:
		_remove_state_if_present(partner_status, "파트너", "anxiety", messages)
	if partner_status.trust >= 18:
		_remove_state_if_present(partner_status, "파트너", "loneliness", messages)
	emit_signal("status_changed")
	var text := "잠시 걸음을 멈추고 파트너를 안심시켰다. 숨소리가 조금 안정됐다."
	if not messages.is_empty():
		text += "\n" + _join_strings(messages, "\n")
	return {
		"ok": true,
		"text": text,
		"partner_line": _partner_reply_for_topic("comfort"),
		"action_id": "partner_comfort",
		"items": {}
	}


func discuss_plan() -> Dictionary:
	if not partner_joined:
		return _action_fail("아직 계획을 의논할 파트너가 없다.")
	var lines: Array[String] = []
	lines.append("둘이 오늘의 움직임을 짚어봤다.")
	lines.append(_partner_plan_text())
	lines.append("파트너 상태: %s" % _partner_condition_text())
	return {
		"ok": true,
		"text": _join_strings(lines, "\n"),
		"partner_line": _partner_reply_for_topic("plan"),
		"action_id": "partner_plan",
		"items": {}
	}


func care_for_partner(item_id: String) -> Dictionary:
	if not partner_joined:
		return _action_fail("돌볼 파트너가 아직 없다.")
	if InventoryManager.get_count(item_id) <= 0:
		return _action_fail("건넬 아이템이 부족하다.")
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		return _action_fail("알 수 없는 아이템이다.")
	var effects := _status_effects_from_item(item.effects)
	if effects.is_empty():
		return _action_fail("지금 돌봄에 쓸 수 있는 아이템이 아니다.")
	InventoryManager.remove_item(item_id, 1)
	if _item_is_food_or_drink(item):
		effects["mood"] = int(effects.get("mood", 0)) + 1
		effects["trust"] = int(effects.get("trust", 0)) + 1
	partner_status.apply_delta(effects)
	if _item_is_food_or_drink(item):
		partner_status.apply_delta({"affection": 1})
	var messages: Array[String] = []
	if effects.has("hygiene"):
		_update_hygiene_state(partner_status, "파트너", messages)
	if int(effects.get("hp", 0)) >= 8:
		_remove_state_if_present(partner_status, "파트너", "wound", messages)
	if int(effects.get("thirst", 0)) > 0 and partner_status.thirst >= 35:
		_remove_state_if_present(partner_status, "파트너", "fatigue", messages)
	emit_signal("status_changed")
	var text := "파트너에게 %s을/를 건넸다. %s" % [
		String(item.display_name),
		_format_effects(effects)
	]
	if not messages.is_empty():
		text += "\n" + _join_strings(messages, "\n")
	return {
		"ok": true,
		"text": text,
		"partner_line": _partner_reply_for_topic("care"),
		"action_id": "partner_care",
		"items": {}
	}


func get_partner_menu_summary(location_label: String = "") -> String:
	if not partner_joined:
		return "아직 말을 걸 파트너가 없다."
	return _join_strings([
		get_partner_mode_summary(location_label),
		"표정: %s" % _partner_condition_text(),
		"필요: %s" % _partner_need_text(),
		"반응: %s" % get_relationship_cue_text()
	], "\n")


func get_partner_care_candidates() -> Array[String]:
	var result: Array[String] = []
	for item_id in ["water", "berry", "cooked_fish", "dried_fish"]:
		if InventoryManager.get_count(item_id) <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		if item != null and not _status_effects_from_item(item.effects).is_empty():
			result.append(item_id)
	return result


func get_relationship_cue_text() -> String:
	if not partner_joined:
		return "아직 서로를 찾지 못했다."
	match get_relationship_state_id():
		"deep_bond":
			if partner_status.mood <= 35:
				return "지친 와중에도 네 상태를 먼저 확인한다."
			return "말하지 않아도 시선과 손짓이 먼저 맞는다."
		"reliable_distance":
			return "판단은 믿지만 필요한 말만 짧게 나눈다."
		"warm_anxiety":
			return "곁에 있고 싶어 하지만 위험한 판단 앞에서는 망설인다."
		"guarded":
			if partner_status.mood <= 35:
				return "필요한 말만 하고 표정이 굳어 있다."
			return "대답이 늦고 말끝을 고른다."
	if partner_status.trust >= 75 and partner_status.mood >= 55:
		return "먼저 주변을 살피며 호흡을 맞춘다."
	if partner_status.trust <= 25:
		return "대답이 늦고 말끝을 고른다."
	if partner_status.mood <= 35:
		return "필요한 말만 하고 표정이 굳어 있다."
	if partner_status.has_state("fear") or partner_status.has_state("anxiety"):
		return "소리에 예민하게 반응한다."
	return "부르면 바로 돌아보고 다음 행동을 기다린다."


func get_relationship_state_id() -> String:
	if not partner_joined:
		return "missing"
	var high_trust: bool = int(partner_status.trust) >= 45
	var high_affection: bool = int(partner_status.affection) >= 45
	if high_trust and high_affection:
		return "deep_bond"
	if high_trust:
		return "reliable_distance"
	if high_affection:
		return "warm_anxiety"
	return "guarded"


func get_relationship_state_label() -> String:
	match get_relationship_state_id():
		"deep_bond":
			return "깊은 유대"
		"reliable_distance":
			return "차가운 동료"
		"warm_anxiety":
			return "다정한 불안"
		"guarded":
			return "거리감"
	return "미합류"


func get_relationship_state_color() -> Color:
	match get_relationship_state_id():
		"deep_bond":
			return Color(0.82, 0.68, 0.32)
		"reliable_distance":
			return Color(0.58, 0.72, 0.72)
		"warm_anxiety":
			return Color(0.78, 0.56, 0.68)
		"guarded":
			return Color(0.62, 0.48, 0.38)
	return Color(0.46, 0.50, 0.48)


func record_relationship_memory(memory_id: String, text: String, icon_id: String = "actions/talk", importance: int = 1) -> void:
	if memory_id == "" or text == "":
		return
	for index in range(relationship_memories.size()):
		var existing: Dictionary = relationship_memories[index]
		if String(existing.get("id", "")) == memory_id:
			existing["text"] = text
			existing["icon"] = icon_id
			existing["day"] = GameState.day
			existing["relationship"] = get_relationship_state_label()
			existing["importance"] = importance
			relationship_memories[index] = existing
			emit_signal("status_changed")
			return
	relationship_memories.append({
		"id": memory_id,
		"text": text,
		"icon": icon_id,
		"day": GameState.day,
		"relationship": get_relationship_state_label(),
		"importance": importance
	})
	while relationship_memories.size() > 12:
		relationship_memories.remove_at(0)
	emit_signal("status_changed")


func get_relationship_memories(limit: int = 3) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var index := relationship_memories.size() - 1
	while index >= 0 and result.size() < limit:
		result.append(relationship_memories[index].duplicate(true))
		index -= 1
	return result


func get_latest_relationship_memory_text(default_text: String = "") -> String:
	if relationship_memories.is_empty():
		return default_text
	return String(relationship_memories[relationship_memories.size() - 1].get("text", default_text))


func gift_item(item_id: String) -> Dictionary:
	if not partner_joined:
		return _action_fail("선물을 건넬 상대가 아직 없다.")
	if InventoryManager.get_count(item_id) <= 0:
		return _action_fail("건넬 아이템이 부족하다.")
	var cost := GameState.get_adjusted_action_cost("gift", {"time": 1, "stamina": 0})
	var time_cost := int(cost.get("time", 1))
	var stamina_cost := int(cost.get("stamina", 0))
	if not GameState.can_spend_action_points(time_cost):
		return _action_fail("선물을 건넬 시간이 부족하다.")
	if not can_spend_stamina(stamina_cost):
		return _action_fail("선물을 건넬 기력이 부족하다.")
	GameState.spend_action_points(time_cost)
	spend_stamina(stamina_cost)
	apply_action_metabolism("gift", time_cost, stamina_cost, partner_joined)
	var metabolism_messages := consume_status_messages()
	InventoryManager.remove_item(item_id, 1)
	var mood_delta := 2
	var trust_delta := 1
	var affection_delta := 2
	if partner_personality != null:
		if partner_personality.preferred_gifts.has(item_id):
			mood_delta = 6
			trust_delta = 2
			affection_delta = 6
		elif partner_personality.disliked_gifts.has(item_id):
			mood_delta = -3
			trust_delta = 0
			affection_delta = -3
	partner_status.apply_delta({"mood": mood_delta, "trust": trust_delta, "affection": affection_delta})
	emit_signal("status_changed")
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var text := "%s을/를 건넸다. 관계가 조금 변했다." % display_name
	if not metabolism_messages.is_empty():
		text += "\n" + _join_strings(metabolism_messages, "\n")
	return {
		"ok": true,
		"text": text,
		"partner_line": _partner_reply_for_topic("gift"),
		"action_id": "gift",
		"items": {}
	}


func apply_item_effects(target_id: String, effects: Dictionary, item_display_name: String) -> Dictionary:
	var status = _status_for_target(target_id)
	if status == null:
		return {
			"ok": false,
			"text": "대상을 선택할 수 없다."
		}
	status.apply_delta(effects)
	var messages: Array[String] = []
	if effects.has("hunger") or effects.has("thirst"):
		_update_survival_need_states(status, _target_label(target_id), messages)
	if effects.has("hygiene"):
		_update_hygiene_state(status, _target_label(target_id), messages)
	if int(effects.get("hp", 0)) >= 8:
		_remove_state_if_present(status, _target_label(target_id), "wound", messages)
	if not status.has_state("wound") and status.hygiene >= 55:
		_remove_state_if_present(status, _target_label(target_id), "infection_risk", messages)
	emit_signal("status_changed")
	var text := "%s이/가 %s을/를 사용했다. %s" % [
		_target_label(target_id),
		item_display_name,
		_format_effects(effects)
	]
	if not messages.is_empty():
		text += "\n" + _join_strings(messages, "\n")
	return {
		"ok": true,
		"text": text
	}


func _pay_partner_interaction_cost(action_id: String, base_time: int, base_stamina: int, time_fail_text: String, stamina_fail_text: String) -> Dictionary:
	var cost := GameState.get_adjusted_action_cost(action_id, {"time": base_time, "stamina": base_stamina})
	var time_cost := int(cost.get("time", base_time))
	var stamina_cost := int(cost.get("stamina", base_stamina))
	if not GameState.can_spend_action_points(time_cost):
		return _action_fail(time_fail_text)
	if not can_spend_stamina(stamina_cost):
		return _action_fail(stamina_fail_text)
	GameState.spend_action_points(time_cost)
	spend_stamina(stamina_cost)
	apply_action_metabolism(action_id, time_cost, stamina_cost, partner_joined)
	return {
		"ok": true,
		"messages": consume_status_messages()
	}


func _partner_condition_text() -> String:
	if partner_status.hp <= 30:
		return "상처 때문에 얼굴빛이 좋지 않다."
	if partner_status.thirst <= 30:
		return "말수가 줄고 입술이 말라 있다."
	if partner_status.hunger <= 30:
		return "허기를 참고 있지만 집중이 흐트러져 보인다."
	if partner_status.stamina <= 25:
		return "눈꺼풀이 무겁고 걸음이 늦다."
	if partner_status.has_state("wound"):
		return "움직일 때마다 상처를 의식한다."
	if partner_status.has_state("fear"):
		return "작은 소리에도 어깨가 굳는다."
	if partner_status.has_state("anxiety"):
		return "계속 주변을 확인하며 불안해한다."
	if partner_status.hygiene <= 35:
		return "젖은 흙과 땀 때문에 불쾌해 보인다."
	if partner_status.mood <= 35:
		return "괜찮다고 말하지만 표정이 굳어 있다."
	if partner_status.mood >= 75 and partner_status.trust >= 45:
		return "조금은 웃을 여유가 생겼다."
	return "긴장은 남아 있지만 대화는 이어갈 수 있다."


func _partner_need_text() -> String:
	if partner_status.hp <= 35 or partner_status.has_state("wound"):
		return "상처를 살피고 무리한 행동을 줄여야 한다."
	if partner_status.thirst <= 40:
		return "마실 물을 먼저 챙겨야 한다."
	if partner_status.hunger <= 40:
		return "먹을 것을 나누는 편이 좋다."
	if partner_status.stamina <= 35:
		return "짧게 쉬거나 거점에서 회복하는 편이 좋다."
	if partner_status.hygiene <= 35:
		return "물가에서 씻거나 젖은 상태를 털어내야 한다."
	if partner_status.mood <= 40 or partner_status.has_state("anxiety"):
		return "잠깐 안심시키는 대화가 필요하다."
	return "당장 급한 요구는 없지만 날씨와 시간을 신경 쓴다."


func _partner_plan_text() -> String:
	if partner_status.thirst <= 40:
		return "파트너는 오늘 식수 확보를 가장 먼저 하자고 말한다."
	if partner_status.hunger <= 40:
		return "파트너는 멀리 가기 전에 먹을 것을 챙기자고 한다."
	if partner_status.stamina <= 35:
		return "파트너는 지금은 욕심내지 말고 휴식 후 움직이자고 한다."
	if not GameState.is_daylight_time():
		return "파트너는 밤에는 조사와 제작보다 귀환과 휴식을 우선하자고 한다."
	if ["비", "폭우", "폭풍"].has(GameState.weather):
		return "파트너는 비가 거세지기 전에 거점과 물자를 확인하자고 한다."
	if partner_personality != null and partner_personality.id == "curious":
		return "파트너는 아직 덜 살핀 인접 타일부터 확인해 보자고 한다."
	if partner_personality != null and partner_personality.id == "optimistic":
		return "파트너는 짧게 자원을 모은 뒤 따뜻한 음식을 만들자고 한다."
	return "파트너는 위험이 낮은 타일부터 조사하고 해가 기울면 돌아오자고 한다."


func _partner_reply_for_topic(topic: String) -> String:
	match topic:
		"check":
			if partner_status.thirst <= 40:
				return "“물만 조금 있으면 괜찮아질 것 같아.”"
			if partner_status.hunger <= 40:
				return "“배가 비니까 자꾸 손이 떨려.”"
			if partner_status.stamina <= 35:
				return "“조금만 쉬었다 가면 좋겠어.”"
			return "“아직은 괜찮아. 무리만 하지 말자.”"
		"comfort":
			if partner_status.has_state("fear") or partner_status.has_state("anxiety"):
				return "“응... 네 목소리 들으니까 좀 낫다.”"
			return "“고마워. 잠깐 숨 돌릴 수 있었어.”"
		"plan":
			return "“오늘은 너무 멀리 욕심내지 말자.”"
		"care":
			return "“나 챙겨준 거 알아. 고마워.”"
		"gift":
			if partner_personality != null and partner_personality.id == "curious":
				return "“이거, 나한테 주는 거야? 고마워.”"
			return "“고마워. 마음은 받았어.”"
		"daily":
			if partner_status.mood <= 35:
				return "“말 걸어줘서 조금 나아졌어.”"
			if partner_status.trust >= 65:
				return "“너랑 있으면 조금은 버틸 수 있을 것 같아.”"
			return "“응. 계속 이야기해 줘.”"
	return "“응.”"


func _status_effects_from_item(raw_effects: Dictionary) -> Dictionary:
	var effects: Dictionary = {}
	for key in raw_effects.keys():
		var stat_id := String(key)
		if ["hp", "stamina", "hunger", "thirst", "hygiene", "mood", "trust", "affection"].has(stat_id):
			effects[stat_id] = int(raw_effects[key])
	return effects


func _item_is_food_or_drink(item) -> bool:
	if item == null:
		return false
	return item.tags.has("food") or item.tags.has("drink") or item.category == "food" or item.category == "consumable"


func get_partner_action_bonus(action_id: String, together: bool) -> int:
	if not together or not is_partner_following() or partner_personality == null:
		return 0
	if partner_personality.id == "curious" and action_id == "investigate":
		return 4
	if partner_personality.id == "optimistic" and action_id == "rest":
		return 2
	return 0


func apply_action_aftereffects(action_id: String, region_name: String, danger_level: int, weather: String, together: bool) -> Array[String]:
	var messages: Array[String] = []
	if action_id == "rest":
		return messages
	var risk := danger_level
	if action_id == "gather" or action_id == "fish" or action_id == "develop":
		risk += 1
	if weather == "비":
		risk += 1
	elif weather == "폭우":
		risk += 2
	elif weather == "폭풍":
		risk += 3
	if together and is_partner_following():
		risk = max(0, risk - 1)
		partner_status.apply_delta({"trust": 1, "mood": 1})
		messages.append("함께 움직인 덕분에 위험을 나누어 감당했다.")
		if partner_personality != null and partner_personality.id == "cautious":
			risk = max(0, risk - 1)
	else:
		if partner_joined and danger_level >= 3:
			partner_status.apply_delta({"mood": -2})
			_add_state_if_missing(partner_status, "파트너", "anxiety", messages)
			messages.append("위험한 지역에 혼자 나선 탓에 파트너가 불안해했다.")

	if ["비", "폭우", "폭풍"].has(weather) and ["move", "investigate", "gather", "fish", "develop"].has(action_id):
		_apply_wet_exposure(together, messages)
	elif action_id == "fish" and randi_range(1, 100) <= 25:
		_apply_wet_exposure(together, messages)

	var chance := clampi(risk * 8, 0, 55)
	if chance > 0 and randi_range(1, 100) <= chance:
		if weather == "폭우" or weather == "폭풍":
			_apply_weather_strain(together, messages)
		elif danger_level >= 3:
			_apply_danger_strain(together, region_name, messages)
		else:
			_apply_minor_strain(together, messages)
	_check_game_over()
	emit_signal("status_changed")
	return messages


func apply_daily_decay(weather: String) -> Array[String]:
	var messages: Array[String] = []
	var base_modifiers := BaseManager.get_daily_status_modifiers()
	if not base_modifiers.is_empty():
		messages.append("동굴 거점의 정비 덕분에 밤을 조금 안정적으로 보냈다.")
	_apply_daily_decay_to_status(player_status, "플레이어", weather, messages, base_modifiers)
	if partner_joined:
		_apply_daily_decay_to_status(partner_status, "파트너", weather, messages, base_modifiers)
	if player_status.hp <= 0:
		GameState.trigger_game_over("플레이어가 쓰러졌다.")
	if partner_joined and partner_status.hp <= 0:
		GameState.trigger_game_over("파트너가 쓰러졌다.")
	emit_signal("status_changed")
	return messages


func get_save_data() -> Dictionary:
	return {
		"player_status": player_status.to_dictionary(),
		"partner_status": partner_status.to_dictionary(),
		"partner_joined": partner_joined,
		"partner_following": partner_following,
		"partner_tile_id": partner_tile_id,
		"partner_task_id": partner_task_id,
		"partner_task_tile_id": partner_task_tile_id,
		"partner_personality_id": partner_personality.id if partner_personality != null else "cautious",
		"relationship_memories": relationship_memories.duplicate(true)
	}


func load_save_data(data: Dictionary) -> void:
	player_status = CharacterStatusScript.from_dictionary(data.get("player_status", {}))
	partner_status = CharacterStatusScript.from_dictionary(data.get("partner_status", {}))
	partner_joined = bool(data.get("partner_joined", false))
	partner_following = bool(data.get("partner_following", partner_joined))
	partner_tile_id = String(data.get("partner_tile_id", ""))
	partner_task_id = String(data.get("partner_task_id", ""))
	partner_task_tile_id = String(data.get("partner_task_tile_id", ""))
	if partner_following:
		partner_task_id = ""
		partner_task_tile_id = ""
	elif partner_joined:
		if partner_task_id == "":
			partner_task_id = "wait"
		if partner_task_tile_id == "":
			partner_task_tile_id = partner_tile_id
	relationship_memories.clear()
	for memory in Array(data.get("relationship_memories", [])):
		if typeof(memory) == TYPE_DICTIONARY:
			relationship_memories.append(Dictionary(memory).duplicate(true))
	choose_personality(String(data.get("partner_personality_id", "cautious")))
	emit_signal("partner_joined_changed", partner_joined)
	emit_signal("status_changed")


func notify_status_changed() -> void:
	emit_signal("status_changed")


func consume_status_messages() -> Array[String]:
	var messages: Array[String] = []
	for message in pending_status_messages:
		messages.append(String(message))
	pending_status_messages.clear()
	return messages


func apply_action_metabolism(action_id: String, time_slots: int, stamina_cost: int, include_partner: bool = false) -> Array[String]:
	var messages: Array[String] = []
	var safe_time := maxi(0, time_slots)
	var safe_stamina := maxi(0, stamina_cost)
	if safe_time == 0 and safe_stamina == 0:
		return messages
	var active_bonus := 0
	if ["move", "investigate", "gather", "fish", "develop", "craft"].has(action_id):
		active_bonus = 1
	var hunger_loss := maxi(1, int(ceil(float(safe_time) * 0.7)) + int(floor(float(safe_stamina) / 18.0)) + active_bonus)
	var thirst_loss := maxi(1, int(ceil(float(safe_time) * 0.9)) + int(floor(float(safe_stamina) / 14.0)) + active_bonus)
	_apply_metabolism_to_status(player_status, "플레이어", hunger_loss, thirst_loss, messages)
	if include_partner and partner_joined:
		_apply_metabolism_to_status(partner_status, "파트너", maxi(1, int(ceil(float(hunger_loss) * 0.6))), maxi(1, int(ceil(float(thirst_loss) * 0.6))), messages)
	_queue_status_messages(messages)
	_check_game_over()
	emit_signal("status_changed")
	return messages


func _status_for_target(target_id: String):
	if target_id == "partner":
		if not partner_joined:
			return null
		return partner_status
	return player_status


func _target_label(target_id: String) -> String:
	if target_id == "partner":
		return "파트너"
	return "플레이어"


func _format_effects(effects: Dictionary) -> String:
	var parts: Array[String] = []
	for key in effects.keys():
		if ["trust", "affection"].has(String(key)):
			continue
		var value := int(effects[key])
		if value == 0:
			continue
		var sign := "+"
		if value < 0:
			sign = ""
		parts.append("%s %s%d" % [_stat_display_name(String(key)), sign, value])
	if parts.is_empty():
		return "눈에 띄는 변화는 없었다."
	return _join_strings(parts, " / ")


func _stat_display_name(stat_id: String) -> String:
	match stat_id:
		"hp":
			return "체력"
		"stamina":
			return "기력"
		"hunger":
			return "허기"
		"thirst":
			return "수분"
		"hygiene":
			return "위생"
		"mood":
			return "감정"
		"trust":
			return "신뢰"
		"affection":
			return "호감"
	return stat_id


func _apply_weather_strain(together: bool, messages: Array[String]) -> void:
	player_status.apply_delta({"stamina": -6, "mood": -2, "hygiene": -4})
	_add_state_if_missing(player_status, "플레이어", "fatigue", messages)
	_add_state_if_missing(player_status, "플레이어", "wet", messages)
	if together and is_partner_following():
		partner_status.apply_delta({"stamina": -4, "mood": -1, "hygiene": -3})
		_add_state_if_missing(partner_status, "파트너", "fatigue", messages)
		_add_state_if_missing(partner_status, "파트너", "wet", messages)
	messages.append("나쁜 날씨에 몸이 젖고 지쳐 피로가 쌓였다.")


func _apply_wet_exposure(together: bool, messages: Array[String]) -> void:
	player_status.apply_delta({"stamina": -2, "hygiene": -2})
	_add_state_if_missing(player_status, "플레이어", "wet", messages)
	if together and is_partner_following():
		partner_status.apply_delta({"stamina": -1, "hygiene": -2})
		_add_state_if_missing(partner_status, "파트너", "wet", messages)


func _apply_danger_strain(together: bool, region_name: String, messages: Array[String]) -> void:
	player_status.apply_delta({"hp": -4, "mood": -2, "hygiene": -2})
	_add_state_if_missing(player_status, "플레이어", "fear", messages)
	_add_state_if_missing(player_status, "플레이어", "wound", messages)
	if together and is_partner_following():
		partner_status.apply_delta({"hp": -2, "mood": -1, "hygiene": -1})
		_add_state_if_missing(partner_status, "파트너", "fear", messages)
		_add_state_if_missing(partner_status, "파트너", "wound", messages)
	messages.append("%s의 위험한 지형 때문에 공포가 남았다." % region_name)


func _apply_minor_strain(together: bool, messages: Array[String]) -> void:
	player_status.apply_delta({"stamina": -4, "hygiene": -1})
	if together and is_partner_following():
		partner_status.apply_delta({"stamina": -2, "hygiene": -1})
	messages.append("작은 사고가 있어 기력을 더 소모했다.")


func _apply_metabolism_to_status(status, label: String, hunger_loss: int, thirst_loss: int, messages: Array[String]) -> void:
	status.apply_delta({
		"hunger": -hunger_loss,
		"thirst": -thirst_loss,
		"hygiene": -maxi(0, int(floor(float(hunger_loss + thirst_loss) / 3.0)))
	})
	if status.hunger <= 0:
		status.hp -= 3
		messages.append("%s의 허기가 바닥나 체력이 조금 감소했다." % label)
	if status.thirst <= 0:
		status.hp -= 4
		messages.append("%s의 수분이 바닥나 체력이 조금 감소했다." % label)
	_update_survival_need_states(status, label, messages)
	_update_hygiene_state(status, label, messages)
	status.clamp_values()


func _add_state_if_missing(status, label: String, state_id: String, messages: Array[String]) -> void:
	if not status.has_state(state_id):
		status.add_state(state_id)
		messages.append("%s에게 %s 상태가 생겼다." % [label, _state_label(state_id)])


func _remove_state_if_present(status, label: String, state_id: String, messages: Array[String]) -> void:
	if status.has_state(state_id):
		status.remove_state(state_id)
		messages.append("%s의 %s 상태가 해소되었다." % [label, _state_label(state_id)])


func _update_hygiene_state(status, label: String, messages: Array[String]) -> void:
	if status.hygiene <= 25:
		_add_state_if_missing(status, label, "poor_hygiene", messages)
	elif status.hygiene >= 55:
		_remove_state_if_present(status, label, "poor_hygiene", messages)


func _update_survival_need_states(status, label: String, messages: Array[String]) -> void:
	if status.hunger <= 20:
		_add_state_if_missing(status, label, "hunger_risk", messages)
	elif status.hunger >= 45:
		_remove_state_if_present(status, label, "hunger_risk", messages)
	if status.thirst <= 20:
		_add_state_if_missing(status, label, "thirst_risk", messages)
	elif status.thirst >= 45:
		_remove_state_if_present(status, label, "thirst_risk", messages)


func _apply_wash_to_status(status, label: String, source_label: String, hygiene_gain: int, messages: Array[String]) -> void:
	var before_hygiene: int = int(status.hygiene)
	status.apply_delta({"hygiene": hygiene_gain, "mood": 1})
	messages.append("%s가 %s에서 몸을 씻었다. 위생 %d→%d" % [label, source_label, before_hygiene, status.hygiene])
	_update_hygiene_state(status, label, messages)
	_remove_state_if_present(status, label, "wet", messages)
	if not status.has_state("wound") and status.hygiene >= 55:
		_remove_state_if_present(status, label, "infection_risk", messages)
	if status.has_state("wound"):
		messages.append("%s의 상처 주변을 닦아 오염 위험을 낮췄다." % label)


func _apply_state_daily_effects(status, label: String, messages: Array[String], base_modifiers: Dictionary = {}) -> void:
	var sheltered := not base_modifiers.is_empty()
	if status.has_state("wet"):
		if sheltered:
			_remove_state_if_present(status, label, "wet", messages)
		else:
			status.apply_delta({"stamina": -5, "mood": -2})
			messages.append("%s가 젖은 몸으로 밤을 보내 기력과 감정이 떨어졌다." % label)
	if status.has_state("wound"):
		var wound_damage := 2
		if status.has_state("poor_hygiene"):
			wound_damage += 4
			_add_state_if_missing(status, label, "infection_risk", messages)
			messages.append("%s의 상처가 오염 때문에 악화되었다." % label)
		status.apply_delta({"hp": -wound_damage})
	if status.has_state("infection_risk"):
		status.apply_delta({"hp": -3, "stamina": -4, "mood": -2})
		messages.append("%s의 감염 위험 때문에 몸이 무겁다." % label)
		if not status.has_state("wound") and status.hygiene >= 55:
			_remove_state_if_present(status, label, "infection_risk", messages)
	if status.has_state("anxiety"):
		var mood_loss := 3
		if sheltered:
			mood_loss = 1
		status.apply_delta({"mood": -mood_loss})
	if status.has_state("fear") and sheltered and status.mood >= 45:
		_remove_state_if_present(status, label, "fear", messages)
	_update_hygiene_state(status, label, messages)
	status.clamp_values()


func _state_label(state_id: String) -> String:
	match state_id:
		"fatigue":
			return "피로"
		"fear":
			return "공포"
		"loneliness":
			return "외로움"
		"stable":
			return "안정"
		"wet":
			return "젖음"
		"wound":
			return "상처"
		"anxiety":
			return "불안"
		"poor_hygiene":
			return "위생불량"
		"hunger_risk":
			return "허기 위험"
		"thirst_risk":
			return "수분 위험"
		"infection_risk":
			return "감염 위험"
	return state_id


func _queue_status_messages(messages: Array[String]) -> void:
	for message in messages:
		if message != "":
			pending_status_messages.append(message)


func _check_game_over() -> void:
	if player_status.hp <= 0:
		GameState.trigger_game_over("플레이어가 쓰러졌다.")
	if partner_joined and partner_status.hp <= 0:
		GameState.trigger_game_over("파트너가 쓰러졌다.")


func _action_fail(text: String) -> Dictionary:
	return {
		"ok": false,
		"text": text,
		"items": {}
	}


func _apply_sleep_to_status(status, label: String, hours: int, messages: Array[String]) -> void:
	var profile := BaseManager.get_sleep_recovery_profile()
	var stamina_gain := hours * int(profile.get("stamina_per_hour", 6))
	var mood_gain := mini(int(profile.get("mood_cap", 4)), hours + int(profile.get("mood_bonus", 0)))
	var hunger_loss := maxi(1, int(ceil(float(hours) * 2.0)))
	var thirst_loss := maxi(1, int(ceil(float(hours) * 2.5)))
	var hygiene_gain := int(profile.get("hygiene_recovery", 0))
	hunger_loss = maxi(1, hunger_loss - int(profile.get("hunger_saving", 0)))
	thirst_loss = maxi(1, thirst_loss - int(profile.get("thirst_saving", 0)))
	stamina_gain = _modified_recovery_gain(status, stamina_gain, "sleep", label, messages)
	status.apply_delta({
		"stamina": stamina_gain,
		"mood": mood_gain,
		"hunger": -hunger_loss,
		"thirst": -thirst_loss,
		"hygiene": hygiene_gain
	})
	if hours >= 6 and status.has_state("fatigue"):
		_remove_state_if_present(status, label, "fatigue", messages)
	if hygiene_gain > 0:
		_update_hygiene_state(status, label, messages)
	if hygiene_gain > 0 or hours >= 4:
		_remove_state_if_present(status, label, "wet", messages)
	if mood_gain >= 4:
		_remove_state_if_present(status, label, "anxiety", messages)
	if status.hunger <= 0:
		status.hp -= 8
		messages.append("%s가 배고픈 채 잠들어 체력이 감소했다." % label)
	if status.thirst <= 0:
		status.hp -= 10
		messages.append("%s가 목마른 채 잠들어 체력이 감소했다." % label)
	_update_survival_need_states(status, label, messages)
	messages.append("%s 수면: %s 회복량이 적용되었다." % [String(profile.get("label", "야외")), label])
	status.clamp_values()


func _apply_daily_decay_to_status(status, label: String, daily_weather: String, messages: Array[String], base_modifiers: Dictionary = {}) -> void:
	var hunger_loss := 15
	var thirst_loss := 20
	var stamina_recovery := 35
	if daily_weather == "비":
		thirst_loss = 14
	elif daily_weather == "폭우":
		thirst_loss = 12
		stamina_recovery = 25
		status.mood -= 2
	elif daily_weather == "폭풍":
		stamina_recovery = 20
		status.mood -= 4
	hunger_loss = maxi(5, hunger_loss - int(base_modifiers.get("hunger_saving", 0)))
	thirst_loss = maxi(5, thirst_loss - int(base_modifiers.get("thirst_saving", 0)))
	stamina_recovery += int(base_modifiers.get("stamina_recovery", 0))
	status.mood += int(base_modifiers.get("mood", 0))
	if daily_weather == "폭우" or daily_weather == "폭풍":
		status.mood += int(base_modifiers.get("weather_strain_reduction", 0))
	status.hunger -= hunger_loss
	status.thirst -= thirst_loss
	status.stamina += stamina_recovery
	status.hygiene -= 4
	if status.hunger <= 0:
		status.hp -= 10
		messages.append("%s의 허기가 한계에 닿아 체력이 감소했다." % label)
	if status.thirst <= 0:
		status.hp -= 14
		messages.append("%s의 수분이 부족해 체력이 감소했다." % label)
	_update_survival_need_states(status, label, messages)
	_apply_state_daily_effects(status, label, messages, base_modifiers)
	if status.stamina < 25 and not status.has_state("fatigue"):
		status.add_state("fatigue")
		messages.append("%s에게 피로 상태가 생겼다." % label)
	elif status.stamina >= 55 and status.has_state("fatigue"):
		status.remove_state("fatigue")
		messages.append("%s의 피로가 풀렸다." % label)
	status.clamp_values()


func _partner_stamina_cost(cost: int) -> int:
	return max(1, int(ceil(float(cost) * 0.5)))


func _join_strings(parts: Array[String], separator: String) -> String:
	var text := ""
	for index in range(parts.size()):
		if index > 0:
			text += separator
		text += parts[index]
	return text
