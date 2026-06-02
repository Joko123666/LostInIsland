extends Button

const ITEM_DROP_ZONE_GROUP := "item_drop_zones"
const ITEM_DRAG_VISUAL_GROUP := "item_drag_visual_targets"

var drag_source := ""
var drag_item_id := ""
var drag_amount := 0
var drag_tile_id := ""
var drag_display_name := ""
var drag_icon_path := ""
var drag_owner_id := "player"


func setup_drag(source: String, item_id: String, amount: int, tile_id: String, display_name: String, icon_path: String, owner_id: String = "player") -> void:
	drag_source = source
	drag_item_id = item_id
	drag_amount = amount
	drag_tile_id = tile_id
	drag_display_name = display_name
	drag_icon_path = icon_path
	drag_owner_id = owner_id


func _get_drag_data(_at_position: Vector2):
	if disabled or drag_item_id == "" or drag_amount <= 0:
		return null
	var data := {
		"kind": "item_stack",
		"source": drag_source,
		"item_id": drag_item_id,
		"amount": drag_amount,
		"tile_id": drag_tile_id,
		"display_name": drag_display_name,
		"icon_path": drag_icon_path,
		"owner_id": drag_owner_id,
		"drag_global_position": get_global_rect().get_center()
	}
	get_tree().call_group(ITEM_DRAG_VISUAL_GROUP, "show_item_drag_visual", data)
	get_tree().call_group(ITEM_DROP_ZONE_GROUP, "show_drag_hint", data)
	set_drag_preview(_make_drag_preview())
	return data


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		get_tree().call_group(ITEM_DROP_ZONE_GROUP, "clear_drag_hint")
		get_tree().call_group(ITEM_DRAG_VISUAL_GROUP, "hide_item_drag_visual")


func _make_drag_preview() -> Control:
	var panel := PanelContainer.new()
	panel.z_as_relative = false
	panel.z_index = 4096
	panel.top_level = true
	panel.clip_contents = false
	panel.modulate = Color(1, 1, 1, 0.0)
	panel.custom_minimum_size = Vector2(58, 58)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.09, 0.94)
	style.border_color = Color(0.92, 0.76, 0.34, 0.96)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	panel.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(28, 28)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if drag_icon_path != "" and ResourceLoader.exists(drag_icon_path):
		icon.texture = load(drag_icon_path)
	row.add_child(icon)

	var label := Label.new()
	label.text = "%s x%d" % [drag_display_name, drag_amount]
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.custom_minimum_size = Vector2(78, 0)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.95, 0.91, 0.72))
	row.add_child(label)
	return panel
