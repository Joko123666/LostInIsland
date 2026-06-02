extends PanelContainer

signal item_drop_requested(data: Dictionary, target_id: String, tile_id: String)

const ITEM_DROP_ZONE_GROUP := "item_drop_zones"

var drop_target_id := "base_direct"
var drop_tile_id := ""
var accepted_sources: Array[String] = ["inventory"]
var drop_enabled := true
var drag_hint_active := false


func setup_drop_surface(target_id: String, tile_id: String, sources: Array, enabled: bool = true) -> void:
	drop_target_id = target_id
	drop_tile_id = tile_id
	accepted_sources.clear()
	for source in sources:
		accepted_sources.append(String(source))
	drop_enabled = enabled
	if not drag_hint_active:
		visible = false


func _ready() -> void:
	add_to_group(ITEM_DROP_ZONE_GROUP)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	_apply_hint_style(false)


func show_drag_hint(data: Dictionary) -> void:
	drag_hint_active = _accepts_drag_data(data)
	visible = drag_hint_active
	if drag_hint_active:
		_apply_hint_style(false)


func clear_drag_hint() -> void:
	drag_hint_active = false
	visible = false


func _can_drop_data(_at_position: Vector2, data) -> bool:
	var can_drop := visible and _accepts_drag_data(data)
	if can_drop:
		_apply_hint_style(true)
	return can_drop


func _drop_data(at_position: Vector2, data) -> void:
	if not data is Dictionary:
		return
	get_tree().call_group(ITEM_DROP_ZONE_GROUP, "clear_drag_hint")
	var drop_data: Dictionary = data.duplicate(true)
	drop_data["drop_global_position"] = get_global_transform() * at_position
	emit_signal("item_drop_requested", drop_data, drop_target_id, drop_tile_id)


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT and drag_hint_active:
		_apply_hint_style(false)


func _accepts_drag_data(data) -> bool:
	if not drop_enabled:
		return false
	if not data is Dictionary:
		return false
	if String(data.get("kind", "")) != "item_stack":
		return false
	var source := String(data.get("source", ""))
	return accepted_sources.is_empty() or accepted_sources.has(source)


func _apply_hint_style(hovered: bool) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.12, 0.07, 0.28 if hovered else 0.18)
	style.border_color = Color(1.0, 0.82, 0.28, 0.92 if hovered else 0.64)
	style.set_border_width_all(2 if hovered else 1)
	style.set_corner_radius_all(5)
	add_theme_stylebox_override("panel", style)
