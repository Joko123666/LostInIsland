class_name EventData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var event_type: String = ""
@export var trigger_conditions: Dictionary = {}
@export var weight: int = 1
@export var once: bool = false
@export var cooldown_days: int = 0
@export var dialogue_lines: Array[String] = []
@export var cutscene_autoplay: bool = true
@export var cutscene_steps: Array[Dictionary] = []
@export var choices: Array[Dictionary] = []
@export var results: Dictionary = {}
