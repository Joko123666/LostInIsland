extends Control

var region_positions: Dictionary = {
	"beach": Vector2(0.20, 0.68),
	"meadow": Vector2(0.47, 0.47),
	"cave": Vector2(0.24, 0.28),
	"forest": Vector2(0.82, 0.34),
	"river": Vector2(0.73, 0.58)
}

var regions: Dictionary = {}
var current_region_id: String = ""
var connected_regions: Array[String] = []
var visited_regions: Dictionary = {}
var map_texture: Texture2D
var fog_texture: Texture2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists("res://assets/maps/island_world_map_large_tiles.png"):
		map_texture = load("res://assets/maps/island_world_map_large_tiles.png")
	if ResourceLoader.exists("res://assets/ui/fog_patch.png"):
		fog_texture = load("res://assets/ui/fog_patch.png")


func set_map_data(new_regions: Dictionary, new_current_region_id: String, new_connected_regions: Array[String], new_visited_regions: Dictionary = {}) -> void:
	regions = new_regions
	current_region_id = new_current_region_id
	connected_regions = new_connected_regions
	visited_regions = new_visited_regions
	queue_redraw()


func _draw() -> void:
	_draw_map_background()
	_draw_connections()
	_draw_region_terrain()
	_draw_fog()
	_draw_legend()


func _draw_map_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.18, 0.22))
	if map_texture != null:
		draw_texture_rect(map_texture, Rect2(Vector2.ZERO, size), false)
	else:
		_draw_ocean_lines()
		_draw_island()


func _draw_ocean_lines() -> void:
	var wave_color := Color(0.12, 0.38, 0.44, 0.55)
	for index in range(6):
		var y := size.y * (0.14 + index * 0.14)
		var points := PackedVector2Array()
		for step in range(9):
			var x := size.x * float(step) / 8.0
			var offset := sin(float(step) * 1.7 + float(index)) * 10.0
			points.append(Vector2(x, y + offset))
		draw_polyline(points, wave_color, 2.0, true)


func _draw_island() -> void:
	var island := PackedVector2Array([
		Vector2(size.x * 0.16, size.y * 0.77),
		Vector2(size.x * 0.12, size.y * 0.57),
		Vector2(size.x * 0.22, size.y * 0.27),
		Vector2(size.x * 0.42, size.y * 0.14),
		Vector2(size.x * 0.69, size.y * 0.18),
		Vector2(size.x * 0.86, size.y * 0.42),
		Vector2(size.x * 0.83, size.y * 0.70),
		Vector2(size.x * 0.60, size.y * 0.86),
		Vector2(size.x * 0.33, size.y * 0.86)
	])
	draw_colored_polygon(island, Color(0.42, 0.58, 0.35))
	draw_polyline(island, Color(0.77, 0.68, 0.45), 8.0, true)


func _draw_connections() -> void:
	var drawn: Dictionary = {}
	for region_id in regions.keys():
		var region = regions[region_id]
		for target_id in region.connected_regions:
			var key_a := String(region_id)
			var key_b := String(target_id)
			var pair_key := key_a + ":" + key_b
			var reverse_key := key_b + ":" + key_a
			if drawn.has(pair_key) or drawn.has(reverse_key):
				continue
			drawn[pair_key] = true
			var a := _region_pos(key_a)
			var b := _region_pos(key_b)
			var both_known := _is_visited(key_a) and _is_visited(key_b)
			var color := Color(0.78, 0.72, 0.55, 0.38)
			var width := 3.0
			if key_a == current_region_id or key_b == current_region_id:
				color = Color(0.96, 0.86, 0.46, 0.85)
				width = 4.0
			elif not both_known:
				color = Color(0.72, 0.78, 0.72, 0.22)
			draw_line(a, b, color, width, true)


func _draw_region_terrain() -> void:
	for raw_region_id in regions.keys():
		var region_id := String(raw_region_id)
		var region = regions[region_id]
		var pos := _region_pos(region_id)
		var radius := 44.0
		var known := _is_visited(region_id)
		var terrain_color := _terrain_color(String(region.region_type))
		var fill_alpha := 0.26 if known else 0.08
		draw_circle(pos, radius, Color(terrain_color.r, terrain_color.g, terrain_color.b, fill_alpha))
		draw_arc(pos, radius, 0.0, TAU, 48, Color(0.06, 0.09, 0.08, 0.35), 4.0, true)
		if region_id == current_region_id:
			draw_arc(pos, radius + 9.0, 0.0, TAU, 64, Color(1.0, 0.90, 0.38), 5.0, true)
		elif connected_regions.has(region_id):
			draw_arc(pos, radius + 6.0, 0.0, TAU, 64, Color(0.72, 0.86, 0.72), 3.0, true)


func _draw_fog() -> void:
	for raw_region_id in regions.keys():
		var region_id := String(raw_region_id)
		if _is_visited(region_id):
			continue
		var pos := _region_pos(region_id)
		var fog_size := Vector2(260, 190)
		var alpha := 0.90
		if connected_regions.has(region_id):
			alpha = 0.72
			fog_size = Vector2(230, 168)
		var rect := Rect2(pos - fog_size * 0.5, fog_size)
		if fog_texture != null:
			draw_texture_rect(fog_texture, rect, false, Color(1, 1, 1, alpha))
		else:
			draw_circle(pos, fog_size.x * 0.42, Color(0.78, 0.84, 0.82, alpha))
		draw_arc(pos, fog_size.x * 0.36, 0.0, TAU, 48, Color(0.90, 0.96, 0.94, 0.22), 2.0, true)
		if connected_regions.has(region_id):
			draw_string(ThemeDB.fallback_font, pos + Vector2(-28, 5), "탐색", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.16, 0.22, 0.22, 0.86))


func _draw_legend() -> void:
	var panel_rect := Rect2(Vector2(18, 18), Vector2(270, 64))
	draw_rect(panel_rect, Color(0.05, 0.08, 0.09, 0.70), true)
	draw_rect(panel_rect, Color(0.40, 0.52, 0.56, 0.65), false, 1.0)
	var font := ThemeDB.fallback_font
	var font_size := 14
	draw_string(font, Vector2(32, 43), "섬 지도", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.96, 0.91, 0.73))
	draw_string(font, Vector2(32, 66), "미방문 지역은 안개로 가려집니다.", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.82, 0.89, 0.88))


func _terrain_color(region_type: String) -> Color:
	match region_type:
		"beach":
			return Color(0.78, 0.66, 0.42)
		"meadow":
			return Color(0.47, 0.65, 0.32)
		"cave":
			return Color(0.38, 0.39, 0.43)
		"forest":
			return Color(0.22, 0.47, 0.25)
		"river":
			return Color(0.25, 0.60, 0.72)
	return Color(0.45, 0.55, 0.38)


func _region_pos(region_id: String) -> Vector2:
	var normalized: Vector2 = region_positions.get(region_id, Vector2(0.5, 0.5))
	return Vector2(size.x * normalized.x, size.y * normalized.y)


func _is_visited(region_id: String) -> bool:
	return bool(visited_regions.get(region_id, false)) or region_id == current_region_id
