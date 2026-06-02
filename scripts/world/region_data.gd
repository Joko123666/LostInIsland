class_name RegionData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var region_type: String = ""
@export var development: int = 0
@export var investigation: int = 0
@export var resource_capacity: Dictionary = {}
@export var resource_maximums: Dictionary = {}
@export var connected_regions: Array[String] = []
@export var is_special: bool = false
@export var is_enterable: bool = false
@export var allowed_actions: Array[String] = []
@export var event_pool: Array[String] = []
@export var danger_level: int = 0
@export var icon_path: String = ""
@export var image_path: String = ""


func clamp_values() -> void:
	development = clampi(development, 0, 100)
	investigation = clampi(investigation, 0, 100)


func to_dictionary() -> Dictionary:
	return {
		"id": id,
		"development": development,
		"investigation": investigation,
		"resource_capacity": resource_capacity.duplicate(true)
	}


func apply_dictionary(data: Dictionary) -> void:
	development = int(data.get("development", development))
	investigation = int(data.get("investigation", investigation))
	var stored_resources: Dictionary = data.get("resource_capacity", {})
	for item_id in stored_resources.keys():
		resource_capacity[String(item_id)] = int(stored_resources[item_id])
	clamp_values()
