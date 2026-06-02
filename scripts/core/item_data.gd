class_name ItemData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var category: String = ""
@export var stackable: bool = true
@export var max_stack: int = 99
@export var weight: float = 0.0
@export var durability: int = -1
@export var tags: Array[String] = []
@export var effects: Dictionary = {}
@export var icon_path: String = ""
@export var placeable_scene: PackedScene
