extends Node

signal line_started(text: String)

var current_lines: Array[String] = []
var current_index: int = -1


func start_dialogue(lines: Array[String]) -> String:
	current_lines = lines.duplicate()
	current_index = -1
	return next_line()


func next_line() -> String:
	current_index += 1
	if current_index < 0 or current_index >= current_lines.size():
		return ""
	var text := current_lines[current_index]
	emit_signal("line_started", text)
	return text
