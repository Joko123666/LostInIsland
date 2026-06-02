class_name CraftRecipe
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var category: String = ""
@export var required_station: String = ""
@export var required_items: Dictionary = {}
@export var required_skills: Dictionary = {}
@export var result_items: Dictionary = {}
@export var stamina_cost: int = 10
@export var time_cost: int = 1
@export var base_success_rate: float = 1.0
@export var can_partner_assist: bool = false
@export var unlock_conditions: Dictionary = {}
