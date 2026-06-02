extends Control

func _ready() -> void:
	var label := Label.new()
	label.text = "EventScene placeholder - main MVP UI is in Main.tscn"
	add_child(label)
