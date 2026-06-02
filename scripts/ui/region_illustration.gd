extends Control

var region_type: String = "beach"
var display_name: String = "해변"
var weather: String = "맑음"


func set_region(new_region_type: String, new_display_name: String, new_weather: String) -> void:
	region_type = new_region_type
	display_name = new_display_name
	weather = new_weather
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, _sky_color(), true)
	_draw_weather_overlay()
	match region_type:
		"beach":
			_draw_beach()
		"meadow":
			_draw_meadow()
		"cave":
			_draw_cave()
		"forest":
			_draw_forest()
		"river":
			_draw_river()
		_:
			_draw_meadow()
	draw_rect(rect, Color(0.90, 0.86, 0.68, 0.40), false, 1.0)
	draw_string(ThemeDB.fallback_font, Vector2(14, size.y - 14), display_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.97, 0.93, 0.78))


func _draw_beach() -> void:
	draw_rect(Rect2(0, size.y * 0.58, size.x, size.y * 0.42), Color(0.74, 0.62, 0.38), true)
	draw_rect(Rect2(0, size.y * 0.48, size.x, size.y * 0.15), Color(0.76, 0.88, 0.82), true)
	draw_rect(Rect2(0, size.y * 0.39, size.x, size.y * 0.13), Color(0.20, 0.56, 0.68), true)
	draw_circle(Vector2(size.x * 0.78, size.y * 0.23), 18, Color(0.98, 0.78, 0.36))


func _draw_meadow() -> void:
	draw_rect(Rect2(0, size.y * 0.55, size.x, size.y * 0.45), Color(0.35, 0.56, 0.25), true)
	for index in range(9):
		var x := size.x * (0.08 + float(index) * 0.11)
		draw_line(Vector2(x, size.y * 0.88), Vector2(x + 12, size.y * 0.60), Color(0.62, 0.76, 0.39), 3.0)
	draw_circle(Vector2(size.x * 0.28, size.y * 0.50), 5, Color(0.95, 0.88, 0.36))
	draw_circle(Vector2(size.x * 0.64, size.y * 0.62), 5, Color(0.91, 0.76, 0.38))


func _draw_cave() -> void:
	draw_rect(Rect2(0, size.y * 0.48, size.x, size.y * 0.52), Color(0.22, 0.24, 0.27), true)
	var mouth := PackedVector2Array([
		Vector2(size.x * 0.22, size.y),
		Vector2(size.x * 0.33, size.y * 0.42),
		Vector2(size.x * 0.50, size.y * 0.25),
		Vector2(size.x * 0.70, size.y * 0.43),
		Vector2(size.x * 0.82, size.y)
	])
	draw_colored_polygon(mouth, Color(0.09, 0.10, 0.12))
	draw_polyline(mouth, Color(0.36, 0.39, 0.43), 5.0, true)
	draw_line(Vector2(size.x * 0.48, size.y * 0.42), Vector2(size.x * 0.55, size.y * 0.54), Color(0.35, 0.82, 0.78), 3.0)


func _draw_forest() -> void:
	draw_rect(Rect2(0, size.y * 0.52, size.x, size.y * 0.48), Color(0.18, 0.36, 0.22), true)
	for index in range(6):
		var x := size.x * (0.10 + float(index) * 0.16)
		var base_y := size.y * 0.88
		draw_line(Vector2(x, base_y), Vector2(x, size.y * 0.48), Color(0.34, 0.22, 0.14), 6.0)
		draw_circle(Vector2(x, size.y * 0.42), 26, Color(0.12, 0.34, 0.18))
		draw_circle(Vector2(x + 16, size.y * 0.50), 22, Color(0.16, 0.43, 0.22))


func _draw_river() -> void:
	draw_rect(Rect2(0, size.y * 0.55, size.x, size.y * 0.45), Color(0.31, 0.52, 0.28), true)
	var river := PackedVector2Array([
		Vector2(size.x * 0.38, size.y * 0.40),
		Vector2(size.x * 0.52, size.y * 0.55),
		Vector2(size.x * 0.45, size.y),
		Vector2(size.x * 0.66, size.y),
		Vector2(size.x * 0.72, size.y * 0.55),
		Vector2(size.x * 0.56, size.y * 0.34)
	])
	draw_colored_polygon(river, Color(0.23, 0.59, 0.71))
	draw_line(Vector2(size.x * 0.48, size.y * 0.48), Vector2(size.x * 0.58, size.y * 0.95), Color(0.75, 0.93, 0.94, 0.65), 3.0)


func _draw_weather_overlay() -> void:
	if weather == "비" or weather == "폭우":
		for index in range(14):
			var x := size.x * float(index) / 14.0 + 8.0
			draw_line(Vector2(x, 8), Vector2(x - 16, 42), Color(0.66, 0.82, 0.90, 0.45), 2.0)
	elif weather == "폭풍":
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.04, 0.05, 0.06, 0.35), true)


func _sky_color() -> Color:
	match weather:
		"비":
			return Color(0.38, 0.50, 0.55)
		"폭우":
			return Color(0.24, 0.32, 0.38)
		"폭풍":
			return Color(0.12, 0.16, 0.20)
		"흐림":
			return Color(0.46, 0.58, 0.60)
	return Color(0.48, 0.72, 0.76)
