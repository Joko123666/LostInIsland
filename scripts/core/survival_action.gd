class_name SurvivalAction
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var stamina_cost: int = 0
@export var time_cost: int = 1
@export var tags: Array[String] = []


func to_dictionary() -> Dictionary:
	return {
		"id": id,
		"display_name": display_name,
		"stamina_cost": stamina_cost,
		"time_cost": time_cost,
		"tags": tags.duplicate()
	}
