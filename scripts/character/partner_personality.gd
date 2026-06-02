class_name PartnerPersonality
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var stat_modifiers: Dictionary = {}
@export var state_resistances: Dictionary = {}
@export var preferred_gifts: Array[String] = []
@export var disliked_gifts: Array[String] = []
@export var event_tags: Array[String] = []
