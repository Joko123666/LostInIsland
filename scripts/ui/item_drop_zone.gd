extends PanelContainer

signal item_drop_requested(data: Dictionary, target_id: String, tile_id: String)

const ITEM_DROP_ZONE_GROUP := "item_drop_zones"

var drop_target_id := ""
var drop_tile_id := ""
var accepted_sources: Array[String] = []
var drop_enabled := true
var drag_hint_active := false
var drag_hint_hovered := false
var hint_tween: Tween


func setup_drop_zone(target_id: String, tile_id: String, sources: Array[String], enabled: bool = true) -> void:
	drop_target_id = target_id
	drop_tile_id = tile_id
	accepted_sources = sources.duplicate()
	drop_enabled = enabled
	_apply_base_style()


func _ready() -> void:
	add_to_group(ITEM_DROP_ZONE_GROUP)
	_apply_base_style()


func show_drag_hint(data: Dictionary) -> void:
	drag_hint_active = _accepts_drag_data(data)
	drag_hint_hovered = false
	if drag_hint_active:
		_apply_hint_style(false)
	else:
		_apply_base_style()
	_animate_hint_scale()


func clear_drag_hint() -> void:
	drag_hint_active = false
	drag_hint_hovered = false
	_apply_base_style()
	_animate_hint_scale()


func _can_drop_data(_at_position: Vector2, data) -> bool:
	var can_drop := _accepts_drag_data(data)
	if drag_hint_active and can_drop:
		if not drag_hint_hovered:
			drag_hint_hovered = true
			_apply_hint_style(true)
			_animate_hint_scale()
	return can_drop


func _drop_data(_at_position: Vector2, data) -> void:
	if not data is Dictionary:
		return
	get_tree().call_group(ITEM_DROP_ZONE_GROUP, "clear_drag_hint")
	var drop_data: Dictionary = data.duplicate(true)
	drop_data["drop_global_position"] = get_global_rect().get_center()
	emit_signal("item_drop_requested", drop_data, drop_target_id, drop_tile_id)


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT and drag_hint_active:
		drag_hint_hovered = false
		_apply_hint_style(false)
		_animate_hint_scale()


func _accepts_drag_data(data) -> bool:
	if not drop_enabled:
		return false
	if not data is Dictionary:
		return false
	if String(data.get("kind", "")) != "item_stack":
		return false
	var source := String(data.get("source", ""))
	return accepted_sources.is_empty() or accepted_sources.has(source)


func _apply_base_style() -> void:
	var border := Color(0.34, 0.40, 0.34, 0.72) if drop_enabled else Color(0.18, 0.20, 0.18, 0.48)
	add_theme_stylebox_override("panel", _make_drop_style(Color(0.025, 0.034, 0.032, 0.72), border, 5, 1))


func _apply_hint_style(hovered: bool) -> void:
	var bg := Color(0.12, 0.14, 0.075, 0.86) if hovered else Color(0.085, 0.105, 0.065, 0.82)
	var border := Color(1.0, 0.84, 0.30, 1.0) if hovered else Color(0.92, 0.76, 0.34, 0.94)
	add_theme_stylebox_override("panel", _make_drop_style(bg, border, 5, 2 if hovered else 1))


func _animate_hint_scale() -> void:
	if hint_tween != null and hint_tween.is_valid():
		hint_tween.kill()
	pivot_offset = size * 0.5
	var target_scale := Vector2.ONE
	var target_modulate := Color.WHITE
	if drag_hint_hovered:
		target_scale = Vector2(1.025, 1.025)
		target_modulate = Color(1.08, 1.04, 0.82, 1.0)
	elif drag_hint_active:
		target_scale = Vector2(1.010, 1.010)
		target_modulate = Color(1.04, 1.02, 0.90, 1.0)
	hint_tween = create_tween()
	hint_tween.set_parallel(true)
	hint_tween.tween_property(self, "scale", target_scale, 0.12).set_trans(Tween.TRANS_BACK if drag_hint_hovered else Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	hint_tween.tween_property(self, "modulate", target_modulate, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _make_drop_style(bg_color: Color, border_color: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	return style
