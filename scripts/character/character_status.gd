class_name CharacterStatus
extends Resource

@export var hp: int = 100
@export var stamina: int = 100
@export var hunger: int = 100
@export var thirst: int = 100
@export var hygiene: int = 100
@export var mood: int = 60
@export var trust: int = 0
@export var affection: int = 0
@export var states: Array[String] = []


func clamp_values() -> void:
	hp = clampi(hp, 0, 100)
	stamina = clampi(stamina, 0, 100)
	hunger = clampi(hunger, 0, 100)
	thirst = clampi(thirst, 0, 100)
	hygiene = clampi(hygiene, 0, 100)
	mood = clampi(mood, 0, 100)
	trust = clampi(trust, 0, 100)
	affection = clampi(affection, 0, 100)


func apply_delta(delta: Dictionary) -> void:
	for key in delta.keys():
		match String(key):
			"hp":
				hp += int(delta[key])
			"stamina":
				stamina += int(delta[key])
			"hunger":
				hunger += int(delta[key])
			"thirst":
				thirst += int(delta[key])
			"hygiene":
				hygiene += int(delta[key])
			"mood":
				mood += int(delta[key])
			"trust":
				trust += int(delta[key])
			"affection":
				affection += int(delta[key])
	clamp_values()


func has_state(state_id: String) -> bool:
	return states.has(state_id)


func add_state(state_id: String) -> void:
	if not states.has(state_id):
		states.append(state_id)


func remove_state(state_id: String) -> void:
	states.erase(state_id)


func to_dictionary() -> Dictionary:
	return {
		"hp": hp,
		"stamina": stamina,
		"hunger": hunger,
		"thirst": thirst,
		"hygiene": hygiene,
		"mood": mood,
		"trust": trust,
		"affection": affection,
		"states": states.duplicate()
	}


static func from_dictionary(data: Dictionary):
	var status = load("res://scripts/character/character_status.gd").new()
	status.hp = int(data.get("hp", status.hp))
	status.stamina = int(data.get("stamina", status.stamina))
	status.hunger = int(data.get("hunger", status.hunger))
	status.thirst = int(data.get("thirst", status.thirst))
	status.hygiene = int(data.get("hygiene", status.hygiene))
	status.mood = int(data.get("mood", status.mood))
	status.trust = int(data.get("trust", status.trust))
	status.affection = int(data.get("affection", status.affection))
	status.states.clear()
	for state in data.get("states", []):
		status.states.append(String(state))
	status.clamp_values()
	return status
