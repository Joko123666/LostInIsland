extends Control

const DRAGGABLE_ITEM_CARD_SCRIPT := preload("res://scripts/ui/draggable_item_card.gd")
const ITEM_DROP_ZONE_SCRIPT := preload("res://scripts/ui/item_drop_zone.gd")
const BASE_DROP_OVERLAY_SCRIPT := preload("res://scripts/ui/base_drop_overlay.gd")

var top_status_label: Label
var top_day_label: Label
var top_time_label: Label
var top_weather_label: Label
var top_weather_icon: TextureRect
var top_log_button: Button
var time_flow_panel: PanelContainer
var time_flow_track: Control
var time_flow_label: Label
var time_phase_icon: TextureRect
var time_weather_icon: TextureRect
var time_compact_panel: PanelContainer
var time_compact_icon_label: Label
var time_phase_marker: PanelContainer
var time_phase_marker_icon: Label
var time_phase_clock_label: Label
var time_transition_panel: PanelContainer
var time_transition_visual: TextureRect
var time_transition_title_label: Label
var time_transition_body_label: Label
var time_transition_tween: Tween
var time_flow_phase_labels: Dictionary = {}
var time_visual_tween: Tween
var time_hud_tween: Tween
var time_hud_hovered: bool = false
var last_time_flow_progress: float = -1.0
var last_time_phase_id: String = ""
var last_time_transition_key: String = ""
var map_grid: Control
var map_stack: Control
var map_camera: Control
var map_ocean_background: TextureRect
var map_light_overlay: ColorRect
var map_weather_layer: Control
var map_wind_layer: Control
var map_moving_fog_layer: Control
var map_pressure_overlay: ColorRect
var map_vignette_overlay: TextureRect
var map_sun_ray_overlay: TextureRect
var sensory_panel: PanelContainer
var sensory_icon: TextureRect
var sensory_label: Label
var map_info_title_label: Label
var map_info_body_label: Label
var map_info_panel: PanelContainer
var map_info_tile_preview: TextureRect
var map_info_chips_box: HBoxContainer
var map_cards_scroll: ScrollContainer
var map_cards_box: VBoxContainer
var map_cards_grid: GridContainer
var bottom_info_tab_button: Button
var bottom_cards_tab_button: Button
var bottom_base_tab_button: Button
var map_base_scroll: ScrollContainer
var map_base_box: VBoxContainer
var map_context_panel: PanelContainer
var map_context_signal_panel: Control
var map_context_signal_visual: TextureRect
var map_context_signal_label: Label
var map_context_actions_box: Control
var tool_icon_bar: Control
var tool_menu_panel: PanelContainer
var tool_menu_title_label: Label
var tool_menu_content: VBoxContainer
var base_view_panel: PanelContainer
var base_drop_overlay: PanelContainer
var base_time_label: Label
var base_life_visual: TextureRect
var base_summary_label: Label
var base_life_note_label: Label
var base_condition_grid: GridContainer
var base_facility_grid: GridContainer
var base_actions_box: VBoxContainer
var player_info_box: VBoxContainer
var partner_info_box: VBoxContainer
var player_image_frame: Control
var partner_image_frame: Control
var action_result_panel: PanelContainer
var action_result_icon: TextureRect
var action_result_title_label: Label
var action_result_body_label: Label
var action_result_delta_label: Label
var action_result_items_box: HBoxContainer
var item_toast_panel: PanelContainer
var item_toast_items_box: HBoxContainer
var item_toast_tween: Tween
var action_delta_panel: PanelContainer
var action_delta_items_box: HBoxContainer
var action_delta_tween: Tween
var action_cutin_layer: Control
var action_cutin_backdrop: TextureRect
var action_cutin_streaks: TextureRect
var action_cutin_icon: TextureRect
var action_cutin_title_label: Label
var action_cutin_body_label: Label
var action_cutin_tween: Tween
var screen_flash_overlay: ColorRect
var cutscene_layer: Control
var cutscene_background: TextureRect
var cutscene_scrim: ColorRect
var cutscene_left_image: TextureRect
var cutscene_right_image: TextureRect
var cutscene_text_panel: PanelContainer
var cutscene_speaker_label: Label
var cutscene_body_label: Label
var cutscene_step_label: Label
var cutscene_prompt_label: Label
var cutscene_tween: Tween
var event_intro_layer: Control
var event_intro_blackout: ColorRect
var event_intro_badge: PanelContainer
var event_intro_icon: TextureRect
var event_intro_tween: Tween
var tool_craft_layer: Control
var tool_craft_panel: PanelContainer
var tool_craft_icon: TextureRect
var tool_craft_visual_frame: Control
var tool_craft_workpiece_panel: PanelContainer
var tool_craft_workpiece_icon: TextureRect
var tool_craft_step_badge: PanelContainer
var tool_craft_step_icon: TextureRect
var tool_craft_step_text_label: Label
var tool_craft_materials_box: HBoxContainer
var tool_craft_visual_flash: ColorRect
var tool_craft_visual_tween: Tween
var fishing_visual_frame: Control
var fishing_line_visual: ColorRect
var fishing_target_zone: ColorRect
var fishing_ripple_ring: PanelContainer
var fishing_bobber: PanelContainer
var fishing_bobber_label: Label
var fishing_tension_bar: ProgressBar
var fishing_hook_bar: ProgressBar
var fishing_visual_flash: ColorRect
var fishing_visual_tween: Tween
var hunting_visual_frame: Control
var hunting_track_marker: PanelContainer
var hunting_track_label: Label
var hunting_target_zone: ColorRect
var hunting_noise_ring: PanelContainer
var hunting_wind_arrow: Label
var hunting_distance_bar: ProgressBar
var hunting_noise_bar: ProgressBar
var hunting_visual_flash: ColorRect
var hunting_visual_tween: Tween
var tool_craft_title_label: Label
var tool_craft_step_label: Label
var tool_craft_body_label: Label
var tool_craft_quality_label: Label
var tool_craft_hint_label: Label
var tool_craft_progress: ProgressBar
var tool_craft_actions_box: HBoxContainer
var tool_craft_footer_label: Label
var action_minigame_meter_box: VBoxContainer
var action_minigame_meter_label: Label
var action_minigame_meter_bar: ProgressBar
var action_minigame_state_label: Label
var event_panel: PanelContainer
var event_title_label: Label
var event_body_label: Label
var event_choices_box: VBoxContainer
var starting_item_panel: PanelContainer
var starting_item_choices_grid: GridContainer
var starting_item_hint_label: Label
var status_detail_panel: PanelContainer
var status_detail_title_label: Label
var status_detail_visual_panel: PanelContainer
var status_detail_visual: TextureRect
var status_detail_body_label: Label
var night_review_panel: PanelContainer
var night_review_title_label: Label
var night_review_body_label: Label
var night_review_buttons_box: HBoxContainer
var item_action_panel: PanelContainer
var item_action_title_label: Label
var item_action_body_label: Label
var item_action_buttons_box: VBoxContainer
var time_adjust_panel: PanelContainer
var time_adjust_title_label: Label
var time_adjust_value_label: Label
var time_adjust_detail_label: Label
var time_adjust_slider: HSlider
var time_adjust_confirm_button: Button
var item_drag_visual_layer: CanvasLayer
var item_drag_visual_card: Control

var action_together_enabled: bool = false
var active_tool_menu: String = ""
var active_craft_category: String = "all"
var inventory_sort_mode: String = "order"
var active_bottom_tab: String = "info"
var selected_tile_id: String = ""
var log_lines: Array[String] = []
var runtime_texture_cache: Dictionary = {}
var revealed_tile_memory: Dictionary = {}
var map_atmosphere_tween: Tween
var map_context_tween: Tween
var base_view_tween: Tween
var partner_banter_tween: Tween
var sensory_tween: Tween
var sensory_toggle_button: Button
var sensory_panel_enabled: bool = true
var last_sensory_text: String = ""
var partner_suggestion_cooldowns: Dictionary = {}
var last_partner_action_preview_key: String = ""
var last_partner_action_preview_msec: int = 0
var active_night_review_context: Dictionary = {}
var last_night_review_day: int = 0
var active_cutscene_steps: Array = []
var active_cutscene_index: int = -1
var active_cutscene_finished: Callable = Callable()
var cutscene_finishing: bool = false
var shown_game_over_reason: String = ""
var active_time_adjustment: Dictionary = {}
var tool_craft_minigame: Dictionary = {}
var action_minigame: Dictionary = {}
var map_pan_offset: Vector2 = Vector2.ZERO
var map_dragging: bool = false
var map_drag_last_screen_pos: Vector2 = Vector2.ZERO
var last_map_center_tile_id: String = ""
var map_center_retry_count: int = 0
var map_zoom: float = 1.20

const MAP_CONTEXT_WIDTH := 116.0
const MAP_CONTEXT_MAX_HEIGHT := 176.0
const MAP_CONTEXT_PADDING := 8.0
const MAP_CONTEXT_TILE_OFFSET := 8.0
const MAP_CONTEXT_BUTTON_HEIGHT := 24.0
const MAP_DEFAULT_ZOOM := 1.20
const MAP_MIN_ZOOM := 0.45
const MAP_MAX_ZOOM := 4.00
const MAP_ZOOM_STEP := 0.12
const MAP_PAN_OVERSCAN := 260.0
const SIDE_PANEL_WIDTH := 220.0
const TOP_INFO_CELL_GAP := 4.0
const TOP_INFO_CELL_WIDTH := (SIDE_PANEL_WIDTH - TOP_INFO_CELL_GAP * 2.0) / 3.0
const DEFAULT_BUTTON_ICON_SIZE := 18
const COMPACT_BUTTON_ICON_SIZE := 14
const TOOL_ICON_BUTTON_SIZE := 30
const TOOL_MENU_BUTTON_SIZE := Vector2(56, 52)
const TOOL_MENU_BUTTON_ICON_SIZE := 24
const HEX_TILE_WIDTH := 256.0
const HEX_TILE_HEIGHT := 224.0
const HEX_TILE_GAP := 6.0
const HEX_COLUMN_STEP := HEX_TILE_WIDTH + HEX_TILE_GAP
const HEX_ROW_STEP := 168.0 + HEX_TILE_GAP
const TILE_SIDE_ICON_SIZE := 24.0
const TILE_SIDE_ICON_GAP := 3.0
const TILE_ACTOR_ICON_SIZE := 40.0
const UI_SAFE_PADDING := 10.0
const BOTTOM_INFO_PANEL_HEIGHT := 172.0
const BOTTOM_CARD_GRID_COLUMNS := 6
const BOTTOM_FIELD_SECTION_COLUMNS := 3
const BOTTOM_CARD_VISIBLE_ROWS := 2
const BOTTOM_FIELD_SLOT_COUNT := BOTTOM_FIELD_SECTION_COLUMNS * BOTTOM_CARD_VISIBLE_ROWS
const BOTTOM_FIELD_SLOT_SIZE := Vector2(64, 44)
const TOOL_MENU_DESIRED_SIZE := Vector2(700, 500)
const ACTION_RESULT_DESIRED_SIZE := Vector2(720, 420)
const STATUS_DETAIL_DESIRED_SIZE := Vector2(520, 360)
const NIGHT_REVIEW_DESIRED_SIZE := Vector2(620, 380)
const EVENT_DESIRED_SIZE := Vector2(620, 360)
const STARTING_ITEM_DESIRED_SIZE := Vector2(780, 500)
const TOOL_CRAFT_MINIGAME_DESIRED_SIZE := Vector2(760, 540)
const ITEM_TOAST_DESIRED_SIZE := Vector2(340, 56)
const GENERATED_UI_SIGNAL_ROOT := "res://assets/generated/ui_signal_assets"
const GENERATED_UI_TRANSITION_ROOT := "res://assets/generated/ui_transition_effects"
const PARTNER_SUGGESTION_GLOBAL_MINUTES := 90
const PARTNER_SUGGESTION_TOPIC_MINUTES := 240
const PARTNER_ACTION_PREVIEW_GLOBAL_MSEC := 1200
const PARTNER_ACTION_PREVIEW_COOLDOWN_MSEC := 4200
const TIME_FLOW_SHOWN_TOP := 10.0
const TIME_FLOW_SHOWN_BOTTOM := 88.0
const TIME_FLOW_HIDDEN_TOP := -92.0
const TIME_FLOW_HIDDEN_BOTTOM := -14.0
const TIME_COMPACT_SHOWN_TOP := 8.0
const TIME_COMPACT_SHOWN_BOTTOM := 50.0
const TIME_COMPACT_HIDDEN_TOP := -52.0
const TIME_COMPACT_HIDDEN_BOTTOM := -10.0
const Z_LAYER_MAP := 0
const Z_LAYER_MAP_TILES := 8
const Z_LAYER_MAP_OVERLAY := 32
const Z_LAYER_EFFECT := 70
const Z_LAYER_INFO_POPUP := 130
const Z_LAYER_GLOBAL_MENU := 220
const Z_MAP_LEGEND := Z_LAYER_INFO_POPUP - 28
const Z_TIME_HUD := Z_LAYER_INFO_POPUP - 18
const Z_SENSORY_HUD := Z_LAYER_INFO_POPUP - 32
const Z_CONTEXT_MENU := Z_LAYER_INFO_POPUP
const Z_BASE_VIEW := Z_LAYER_INFO_POPUP + 10
const Z_TOOL_MENU := Z_LAYER_GLOBAL_MENU
const Z_ACTION_FEEDBACK := Z_LAYER_EFFECT
const Z_ROOT_CUTIN := Z_LAYER_EFFECT + 5
const Z_ROOT_TOAST := Z_LAYER_INFO_POPUP + 22
const Z_ROOT_MODAL := Z_LAYER_INFO_POPUP + 42
const Z_ROOT_EVENT := Z_LAYER_INFO_POPUP + 52
const ITEM_ACTION_DESIRED_SIZE := Vector2(420, 280)
const TILE_MARK_OPTIONS := [
	{"id": "camp", "label": "쉼터", "icon": "res://assets/icons/tile_mark/camp.png"},
	{"id": "storage", "label": "보관", "icon": "res://assets/icons/tile_mark/storage.png"},
	{"id": "water", "label": "물", "icon": "res://assets/icons/tile_mark/water.png"},
	{"id": "resource", "label": "채집", "icon": "res://assets/icons/tile_mark/resource.png"},
	{"id": "danger", "label": "위험", "icon": "res://assets/icons/tile_mark/danger.png"}
]
const ACTION_METHOD_OPTIONS := {
	"gather": [
		{"id": "careful", "label": "살피며", "icon": "actions/investigate", "summary": "적은 기력 / 긴 시간", "detail": "발밑과 손이 닿는 곳부터 확인해 실수를 줄인다."},
		{"id": "wide", "label": "넓게", "icon": "actions/gather", "summary": "더 많은 시도 / 추가 소모", "detail": "주변을 넓게 훑어 더 많은 자원 흔적을 찾는다."},
		{"id": "quick", "label": "빠르게", "icon": "actions/move", "summary": "짧은 시간 / 적은 성과", "detail": "눈에 띄는 것만 서둘러 챙긴다."}
	],
	"fish": [
		{"id": "patient", "label": "기다리기", "icon": "actions/rest", "summary": "성공률 증가 / 긴 시간", "detail": "물결과 그림자가 잦아들 때까지 기다린다."},
		{"id": "quick", "label": "짧게", "icon": "actions/fish", "summary": "짧은 시간 / 성공률 감소", "detail": "짧게 던지고 바로 거두어 시간을 아낀다."},
		{"id": "quiet", "label": "조용히", "icon": "actions/investigate", "summary": "적은 기력 / 약간 안정", "detail": "기척을 낮추고 얕은 물가를 살핀다."}
	],
	"hunt": [
		{"id": "track", "label": "추적", "icon": "actions/investigate", "summary": "성공률 증가 / 긴 시간", "detail": "발자국과 꺾인 풀을 따라가 거리를 좁힌다."},
		{"id": "drive", "label": "몰이", "icon": "actions/gather", "summary": "성과 증가 / 큰 소모", "detail": "위험을 감수하고 짐승을 몰아붙인다."},
		{"id": "cautious", "label": "조심히", "icon": "status/fear", "summary": "안정 우선 / 낮은 성공률", "detail": "빠질 길을 남기며 무리하지 않는다."}
	],
	"set_trap": [
		{"id": "hidden", "label": "숨기기", "icon": "actions/investigate", "summary": "포획률 증가 / 긴 시간", "detail": "흙과 잎으로 냄새와 흔적을 가린다."},
		{"id": "quick", "label": "빠르게", "icon": "actions/move", "summary": "짧은 설치 / 낮은 포획률", "detail": "오래 머물지 않고 덫을 놓는다."},
		{"id": "sturdy", "label": "단단히", "icon": "items/fiber", "summary": "중간 보너스 / 추가 소모", "detail": "고정점을 더 묶어 쉽게 풀리지 않게 한다."}
	]
}
const HUNT_TRACE_PROMPT_CHANCE := 35
const HUNT_TRACE_PROMPT_SLOT_MINUTES := 120
const Z_ROOT_CUTSCENE := Z_LAYER_INFO_POPUP + 62
const Z_ROOT_EVENT_INTRO := Z_ROOT_CUTSCENE + 4
const STARTING_ITEM_SELECTED_FLAG := "starting_item_selected"
const STARTING_ITEM_CHOICE_FLAG := "starting_item_choice"
const STARTING_ITEM_CHOICES := [
	{
		"id": "survival_axe",
		"title": "생존도끼",
		"icon": "res://assets/icons/items/survival_axe.png",
		"summary": "목재와 덩굴 확보가 빨라진다.",
		"detail": "무겁지만 초반 거점 재료를 안정적으로 모으기 좋다."
	},
	{
		"id": "medkit",
		"title": "구급키트",
		"icon": "res://assets/icons/items/medkit.png",
		"summary": "상처와 오염을 한 번 크게 회복한다.",
		"detail": "위험한 지형을 먼저 살필 때 실수를 버틸 여지가 생긴다."
	},
	{
		"id": "handheld_game",
		"title": "오락기",
		"icon": "res://assets/icons/items/handheld_game.png",
		"summary": "불안한 시간을 잠깐 잊게 한다.",
		"detail": "배터리가 닳을 때까지 여러 번 사용할 수 있는 위안용 물건이다."
	},
	{
		"id": "lighter",
		"title": "라이터",
		"icon": "res://assets/icons/items/lighter.png",
		"summary": "밤 조사와 불빛 준비가 쉬워진다.",
		"detail": "해가 진 뒤에도 주변을 더듬어 볼 수 있는 작은 불씨다."
	}
]


func _ready() -> void:
	randomize()
	add_to_group("item_drag_visual_targets")
	_build_ui()
	_connect_manager_signals()
	_append_log("난파 직전 붙잡을 물건을 골라야 한다.")
	call_deferred("_fit_all_overlays")
	_refresh_all()
	call_deferred("_show_starting_item_selection_if_needed")


func _process(delta: float) -> void:
	_update_item_drag_visual_position()
	if bool(tool_craft_minigame.get("active", false)):
		var craft_time_left := float(tool_craft_minigame.get("time_left", 0.0)) - delta
		tool_craft_minigame["time_left"] = craft_time_left
		_update_tool_craft_progress()
		if craft_time_left <= 0.0:
			_resolve_tool_craft_step("")
		return
	if bool(action_minigame.get("preparing", false)):
		var prepare_left := float(action_minigame.get("prepare_time", 0.0)) - delta
		action_minigame["prepare_time"] = prepare_left
		_update_action_minigame_prepare()
		if prepare_left <= 0.0:
			action_minigame["preparing"] = false
			action_minigame["active"] = true
			_set_action_minigame_meter_visible(true)
			_show_action_minigame_step()
		return
	if bool(action_minigame.get("active", false)):
		_tick_action_minigame(delta)
		var action_time_left := float(action_minigame.get("time_left", 0.0))
		_update_action_minigame_progress()
		if action_time_left <= 0.0:
			_resolve_action_minigame_step("")
		return


func _input(event: InputEvent) -> void:
	if event_intro_layer != null and event_intro_layer.visible:
		get_viewport().set_input_as_handled()
		return
	if _is_cutscene_active():
		if event is InputEventMouseButton:
			var cutscene_mouse := event as InputEventMouseButton
			if cutscene_mouse.button_index == MOUSE_BUTTON_LEFT and cutscene_mouse.pressed:
				_advance_cutscene()
				get_viewport().set_input_as_handled()
				return
		if event.is_action_pressed("ui_accept"):
			_advance_cutscene()
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_cancel"):
			_finish_cutscene()
			get_viewport().set_input_as_handled()
			return
	if bool(tool_craft_minigame.get("active", false)):
		if event.is_action_pressed("ui_cancel"):
			_cancel_tool_craft_minigame()
			get_viewport().set_input_as_handled()
		return
	if bool(action_minigame.get("active", false)) or bool(action_minigame.get("preparing", false)):
		if event.is_action_pressed("ui_cancel"):
			_cancel_action_minigame()
			get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and (mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP or mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			if _can_start_map_pan(mouse_event.position):
				var direction := 1 if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP else -1
				_zoom_map_at_screen_point(mouse_event.position, direction)
				get_viewport().set_input_as_handled()
				return
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT:
			if mouse_event.pressed and _can_start_map_pan(mouse_event.position):
				map_dragging = true
				map_drag_last_screen_pos = mouse_event.position
				_hide_map_context_menu()
				get_viewport().set_input_as_handled()
				return
			if not mouse_event.pressed and map_dragging:
				map_dragging = false
				get_viewport().set_input_as_handled()
				return
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if map_context_panel != null and map_context_panel.visible and not map_context_panel.get_global_rect().has_point(mouse_event.position):
				_hide_map_context_menu()
			if item_action_panel != null and item_action_panel.visible and not item_action_panel.get_global_rect().has_point(mouse_event.position):
				_hide_item_action_panel()
			if tool_menu_panel != null \
					and tool_menu_panel.visible \
					and not tool_menu_panel.get_global_rect().has_point(mouse_event.position) \
					and not _control_contains_screen_point(tool_icon_bar, mouse_event.position):
				_hide_tool_menu()
	if event is InputEventMouseMotion and map_dragging:
		var motion := event as InputEventMouseMotion
		_pan_map_by_screen_delta(motion.position - map_drag_last_screen_pos)
		map_drag_last_screen_pos = motion.position
		get_viewport().set_input_as_handled()
		return


func _control_contains_screen_point(control: Control, screen_point: Vector2) -> bool:
	if control == null or not control.visible:
		return false
	return control.get_global_rect().has_point(screen_point)


func _can_start_map_pan(screen_point: Vector2) -> bool:
	if map_stack == null or not map_stack.visible or not map_stack.get_global_rect().has_point(screen_point):
		return false
	for control in [tool_icon_bar, tool_menu_panel, map_context_panel, item_action_panel, base_view_panel, event_panel, starting_item_panel, status_detail_panel, night_review_panel, tool_craft_layer, cutscene_layer, event_intro_layer]:
		if _control_contains_screen_point(control, screen_point):
			return false
	return true


func _raise_root_overlay(control: Control, z_value: int) -> void:
	if control == null:
		return
	control.z_as_relative = false
	control.z_index = z_value
	control.move_to_front()


func _raise_effect_overlay(control: Control) -> void:
	_raise_root_overlay(control, Z_ACTION_FEEDBACK)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_fit_all_overlays()
		call_deferred("_center_map_on_current_tile")


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.035, 0.045, 0.045)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	var top_bar := PanelContainer.new()
	top_bar.custom_minimum_size = Vector2(0, 44)
	top_bar.add_theme_stylebox_override("panel", _make_panel_style(Color(0.07, 0.10, 0.10), Color(0.26, 0.35, 0.35), 4))
	root.add_child(top_bar)

	var top_margin := MarginContainer.new()
	top_margin.add_theme_constant_override("margin_left", 0)
	top_margin.add_theme_constant_override("margin_top", 6)
	top_margin.add_theme_constant_override("margin_right", 0)
	top_margin.add_theme_constant_override("margin_bottom", 6)
	top_bar.add_child(top_margin)

	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 8)
	top_margin.add_child(top_row)

	top_status_label = Label.new()
	top_status_label.visible = false
	top_row.add_child(top_status_label)
	var top_info_row := HBoxContainer.new()
	top_info_row.custom_minimum_size = Vector2(SIDE_PANEL_WIDTH, 0)
	top_info_row.add_theme_constant_override("separation", int(TOP_INFO_CELL_GAP))
	top_row.add_child(top_info_row)
	top_day_label = _make_top_info_cell(top_info_row, "date", "DAY 1")
	top_time_label = _make_top_info_cell(top_info_row, "time", "06:00")
	top_weather_label = _make_top_info_cell(top_info_row, "weather", "", _weather_icon_id(GameState.weather), true)
	var top_spacer := Control.new()
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(top_spacer)
	top_log_button = _make_compact_button("기록", Callable(self, "_toggle_tool_menu").bind("log"), "actions/investigate", Vector2(76, 28))
	top_log_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	top_log_button.tooltip_text = "최근 기록 열기"
	top_row.add_child(top_log_button)
	top_row.add_child(_make_compact_button("메뉴", Callable(self, "_toggle_tool_menu").bind("system"), "actions/save", Vector2(76, 28)))

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 8)
	root.add_child(body)

	body.add_child(_build_character_panel("플레이어", true))
	body.add_child(_build_map_panel())
	body.add_child(_build_character_panel("동행자", false))

	_build_action_result_panel()
	_build_item_toast_panel()
	_build_action_delta_panel()
	_build_item_action_panel()
	_build_action_cutin_layer()
	_build_event_intro_layer()
	_build_cutscene_layer()
	_build_tool_craft_minigame_panel()
	_build_starting_item_panel()
	_build_status_detail_panel()
	_build_night_review_panel()
	_build_time_adjust_panel()
	_build_event_panel()
	_build_item_drag_visual_layer()


func _build_item_drag_visual_layer() -> void:
	item_drag_visual_layer = CanvasLayer.new()
	item_drag_visual_layer.layer = 90
	add_child(item_drag_visual_layer)


func show_item_drag_visual(data: Dictionary) -> void:
	hide_item_drag_visual()
	if item_drag_visual_layer == null:
		return
	var item_id := String(data.get("item_id", ""))
	var amount := maxi(1, int(data.get("amount", 1)))
	if item_id == "":
		return
	item_drag_visual_card = _make_drag_item_visual_card(item_id, amount)
	item_drag_visual_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item_drag_visual_card.modulate = Color(1, 1, 1, 0.96)
	item_drag_visual_card.z_as_relative = false
	item_drag_visual_card.z_index = 4096
	item_drag_visual_layer.add_child(item_drag_visual_card)
	_update_item_drag_visual_position()


func hide_item_drag_visual() -> void:
	if item_drag_visual_card != null and is_instance_valid(item_drag_visual_card):
		item_drag_visual_card.queue_free()
	item_drag_visual_card = null


func _update_item_drag_visual_position() -> void:
	if item_drag_visual_card == null or not is_instance_valid(item_drag_visual_card):
		return
	var visual_size := item_drag_visual_card.size
	if visual_size.x <= 1.0 or visual_size.y <= 1.0:
		visual_size = item_drag_visual_card.custom_minimum_size
	item_drag_visual_card.position = get_viewport().get_mouse_position() - visual_size * 0.5


func _make_drag_item_visual_card(item_id: String, amount: int) -> PanelContainer:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(58, 58)
	panel.size = Vector2(58, 58)
	panel.clip_contents = true
	panel.tooltip_text = "%s x%d" % [display_name, amount]
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.065, 0.082, 0.074, 0.96), Color(0.96, 0.78, 0.34, 0.95), 6))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 1)
	margin.add_child(box)
	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(32, 32)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)
	var amount_label := Label.new()
	amount_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	amount_label.text = "x%d" % amount
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amount_label.add_theme_font_size_override("font_size", 10)
	amount_label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.70))
	box.add_child(amount_label)
	return panel


func _make_top_info_cell(parent: HBoxContainer, info_id: String, value_text: String, icon_id: String = "", icon_only: bool = false) -> Label:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(TOP_INFO_CELL_WIDTH, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	panel.tooltip_text = _top_info_tooltip(info_id)
	panel.add_theme_stylebox_override("panel", _top_info_cell_style(false))
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 0)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.visible = icon_id != ""
	if icon_id != "":
		var texture = _icon_texture(icon_id)
		if texture != null:
			icon.texture = texture
		row.add_child(icon)
	if info_id == "weather":
		top_weather_icon = icon

	var value_label := Label.new()
	value_label.visible = not icon_only
	value_label.text = value_text
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_font_size_override("font_size", 12)
	value_label.add_theme_color_override("font_color", Color(0.90, 0.95, 0.91))
	_prepare_single_line_label(value_label, 0)
	row.add_child(value_label)
	_bind_top_info_cell_reaction(panel, icon, value_label)
	panel.gui_input.connect(Callable(self, "_on_top_info_cell_gui_input").bind(panel, icon, value_label, info_id))
	return value_label


func _top_info_cell_style(hovered: bool) -> StyleBoxFlat:
	if hovered:
		return _make_panel_style(Color(0.070, 0.096, 0.084, 0.98), Color(0.84, 0.74, 0.36, 0.92), 4)
	return _make_panel_style(Color(0.045, 0.065, 0.062), Color(0.20, 0.28, 0.26), 4)


func _bind_top_info_cell_reaction(panel: PanelContainer, icon: Control, value_label: Label) -> void:
	panel.mouse_entered.connect(Callable(self, "_on_top_info_cell_hovered").bind(panel, icon, value_label, true))
	panel.mouse_exited.connect(Callable(self, "_on_top_info_cell_hovered").bind(panel, icon, value_label, false))


func _on_top_info_cell_hovered(panel: PanelContainer, icon: Control, value_label: Label, hovered: bool) -> void:
	if panel == null or not is_instance_valid(panel):
		return
	panel.add_theme_stylebox_override("panel", _top_info_cell_style(hovered))
	var existing = panel.get_meta("top_info_hover_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	var tween := create_tween()
	panel.set_meta("top_info_hover_tween", tween)
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate", Color(1.06, 1.04, 0.88, 1.0) if hovered else Color.WHITE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if icon != null and is_instance_valid(icon) and icon.get_parent() != null:
		icon.pivot_offset = icon.size * 0.5
		tween.tween_property(icon, "scale", Vector2(1.12, 1.12) if hovered else Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK if hovered else Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if value_label != null and is_instance_valid(value_label):
		tween.tween_property(value_label, "modulate", Color(1.0, 0.92, 0.58, 1.0) if hovered else Color.WHITE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_top_info_cell_gui_input(event: InputEvent, panel: PanelContainer, icon: Control, value_label: Label, info_id: String) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_play_top_info_cell_press(panel, icon, value_label)
			_show_top_info_detail(info_id)


func _play_top_info_cell_press(panel: PanelContainer, icon: Control, value_label: Label) -> void:
	if panel == null or not is_instance_valid(panel):
		return
	var existing = panel.get_meta("top_info_hover_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	panel.pivot_offset = panel.size * 0.5
	var tween := create_tween()
	panel.set_meta("top_info_hover_tween", tween)
	tween.set_parallel(true)
	tween.tween_property(panel, "scale", Vector2(0.975, 0.975), 0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.105).set_delay(0.055).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1.12, 1.08, 0.80, 1.0), 0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color.WHITE, 0.14).set_delay(0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if icon != null and is_instance_valid(icon) and icon.get_parent() != null:
		icon.pivot_offset = icon.size * 0.5
		tween.tween_property(icon, "scale", Vector2(0.92, 0.92), 0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(icon, "scale", Vector2.ONE, 0.12).set_delay(0.055).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if value_label != null and is_instance_valid(value_label):
		tween.tween_property(value_label, "modulate", Color(1.0, 0.92, 0.58, 1.0), 0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(value_label, "modulate", Color.WHITE, 0.14).set_delay(0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _build_character_panel(title: String, is_player: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(SIDE_PANEL_WIDTH, 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.clip_contents = true
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.08, 0.11, 0.11), Color(0.24, 0.32, 0.31), 5))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 7)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	var title_label := _small_title(title)
	title_label.name = "CharacterPanelTitle"
	title_label.add_theme_font_size_override("font_size", 15)
	box.add_child(title_label)

	var image_frame := _create_vertical_character_image(title, is_player)
	box.add_child(image_frame)

	var info_scroll := ScrollContainer.new()
	info_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(info_scroll)

	var info_box := VBoxContainer.new()
	info_box.add_theme_constant_override("separation", 4)
	info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_scroll.add_child(info_box)

	if is_player:
		player_image_frame = image_frame
		player_info_box = info_box
	else:
		partner_image_frame = image_frame
		partner_info_box = info_box
	return panel


func _build_map_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.08, 0.08), Color(0.31, 0.40, 0.37), 5))

	var map_box := VBoxContainer.new()
	map_box.add_theme_constant_override("separation", 6)
	panel.add_child(map_box)

	map_stack = Control.new()
	map_stack.clip_contents = true
	map_stack.z_index = Z_LAYER_MAP
	map_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_box.add_child(map_stack)

	var map_margin := MarginContainer.new()
	map_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_margin.add_theme_constant_override("margin_left", 20)
	map_margin.add_theme_constant_override("margin_top", 10)
	map_margin.add_theme_constant_override("margin_right", 20)
	map_margin.add_theme_constant_override("margin_bottom", 8)
	map_stack.add_child(map_margin)

	map_camera = Control.new()
	map_camera.clip_contents = true
	map_camera.z_index = Z_LAYER_MAP
	map_camera.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_camera.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_margin.add_child(map_camera)

	map_grid = Control.new()
	map_grid.name = "MapGrid"
	map_grid.clip_contents = false
	map_grid.z_as_relative = false
	map_grid.z_index = Z_LAYER_MAP_TILES
	map_camera.add_child(map_grid)

	map_light_overlay = ColorRect.new()
	map_light_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_light_overlay.z_as_relative = false
	map_light_overlay.z_index = Z_LAYER_MAP_OVERLAY
	map_light_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_light_overlay.color = _time_phase_map_light_color(_time_phase_id())
	map_camera.add_child(map_light_overlay)
	_build_map_atmosphere_layers()
	_build_pressure_overlay()
	_build_map_mood_overlays()

	_build_time_flow_hud()
	_build_time_transition_banner()
	_build_tool_icon_bar()
	_build_sensory_panel()
	_build_tool_menu_panel()
	_build_map_context_panel()
	_build_base_view_panel()
	_build_map_info_panel(map_box)
	return panel


func _build_tool_icon_bar() -> void:
	var icon_bar := GridContainer.new()
	tool_icon_bar = icon_bar
	icon_bar.columns = 4
	icon_bar.z_as_relative = false
	icon_bar.z_index = Z_SENSORY_HUD
	icon_bar.anchor_left = 0.0
	icon_bar.anchor_top = 0.0
	icon_bar.offset_left = 10
	icon_bar.offset_top = 10
	icon_bar.add_theme_constant_override("h_separation", 6)
	icon_bar.add_theme_constant_override("v_separation", 6)
	map_stack.add_child(icon_bar)

	icon_bar.add_child(_make_tool_menu_button("가방", "인벤토리", "items/berry", Callable(self, "_toggle_tool_menu").bind("inventory")))
	icon_bar.add_child(_make_tool_menu_button("도구", "도구", "items/stone_axe", Callable(self, "_toggle_tool_menu").bind("tools")))
	icon_bar.add_child(_make_tool_menu_button("제작", "제작", "actions/craft", Callable(self, "_toggle_tool_menu").bind("craft")))
	icon_bar.add_child(_make_tool_menu_button("지도", "지도", "actions/move", Callable(self, "_toggle_tool_menu").bind("map")))
	icon_bar.add_child(_make_tool_menu_button("거점", "거점", "actions/place", Callable(self, "_toggle_tool_menu").bind("base")))
	icon_bar.add_child(_make_tool_menu_button("기록", "로그", "actions/investigate", Callable(self, "_toggle_tool_menu").bind("log")))
	icon_bar.add_child(_make_tool_menu_button("설정", "설정", "actions/save", Callable(self, "_toggle_tool_menu").bind("settings")))


func _build_pressure_overlay() -> void:
	map_pressure_overlay = ColorRect.new()
	map_pressure_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_pressure_overlay.z_as_relative = false
	map_pressure_overlay.z_index = Z_LAYER_MAP_OVERLAY + 1
	map_pressure_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_pressure_overlay.color = Color(0, 0, 0, 0)
	map_camera.add_child(map_pressure_overlay)


func _build_map_mood_overlays() -> void:
	map_sun_ray_overlay = TextureRect.new()
	map_sun_ray_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_sun_ray_overlay.z_as_relative = false
	map_sun_ray_overlay.z_index = Z_LAYER_MAP_OVERLAY + 2
	map_sun_ray_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_sun_ray_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_sun_ray_overlay.stretch_mode = TextureRect.STRETCH_SCALE
	var ray_texture = _texture_from_path("res://assets/ui/map_sun_rays.png")
	if ray_texture != null:
		map_sun_ray_overlay.texture = ray_texture
	map_sun_ray_overlay.modulate = Color(1, 1, 1, 0)
	map_camera.add_child(map_sun_ray_overlay)

	map_vignette_overlay = TextureRect.new()
	map_vignette_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_vignette_overlay.z_as_relative = false
	map_vignette_overlay.z_index = Z_LAYER_MAP_OVERLAY + 3
	map_vignette_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_vignette_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_vignette_overlay.stretch_mode = TextureRect.STRETCH_SCALE
	var vignette_texture = _texture_from_path("res://assets/ui/map_vignette.png")
	if vignette_texture != null:
		map_vignette_overlay.texture = vignette_texture
	map_vignette_overlay.modulate = Color(1, 1, 1, 0.24)
	map_camera.add_child(map_vignette_overlay)


func _build_sensory_panel() -> void:
	sensory_panel = PanelContainer.new()
	sensory_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sensory_panel.z_as_relative = false
	sensory_panel.z_index = Z_SENSORY_HUD
	sensory_panel.anchor_left = 0.5
	sensory_panel.anchor_right = 0.5
	sensory_panel.anchor_top = 1.0
	sensory_panel.anchor_bottom = 1.0
	sensory_panel.offset_left = -210
	sensory_panel.offset_right = 210
	sensory_panel.offset_top = -64
	sensory_panel.offset_bottom = -18
	sensory_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.047, 0.90), Color(0.56, 0.64, 0.44, 0.62), 8))
	map_stack.add_child(sensory_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 7)
	sensory_panel.add_child(margin)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)

	sensory_icon = TextureRect.new()
	sensory_icon.custom_minimum_size = Vector2(22, 22)
	sensory_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sensory_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(sensory_icon)

	sensory_label = Label.new()
	sensory_label.clip_text = true
	sensory_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	sensory_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sensory_label.add_theme_font_size_override("font_size", 13)
	sensory_label.add_theme_color_override("font_color", Color(0.93, 0.92, 0.78))
	row.add_child(sensory_label)

	sensory_toggle_button = _make_icon_button("하단 안내 끄기", "status/stable", Callable(self, "_toggle_sensory_panel"))
	sensory_toggle_button.anchor_left = 0.5
	sensory_toggle_button.anchor_right = 0.5
	sensory_toggle_button.anchor_top = 1.0
	sensory_toggle_button.anchor_bottom = 1.0
	sensory_toggle_button.offset_left = 218
	sensory_toggle_button.offset_right = 248
	sensory_toggle_button.offset_top = -58
	sensory_toggle_button.offset_bottom = -28
	sensory_toggle_button.z_as_relative = false
	sensory_toggle_button.z_index = Z_SENSORY_HUD + 1
	map_stack.add_child(sensory_toggle_button)
	_sync_sensory_panel_visibility()


func _build_map_info_panel(parent: VBoxContainer) -> void:
	var panel := PanelContainer.new()
	map_info_panel = panel
	panel.name = "MapInfoPanel"
	panel.custom_minimum_size = Vector2(0, BOTTOM_INFO_PANEL_HEIGHT)
	panel.clip_contents = true
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.05, 0.048, 0.98), Color(0.30, 0.38, 0.34), 5))
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 5)
	margin.add_child(outer)

	var tab_row := HBoxContainer.new()
	tab_row.add_theme_constant_override("separation", 5)
	outer.add_child(tab_row)
	bottom_info_tab_button = _make_compact_button("정보", Callable(self, "_set_bottom_tab").bind("info"), "actions/investigate", Vector2(58, 22))
	bottom_info_tab_button.toggle_mode = true
	_set_button_reaction_mode(bottom_info_tab_button, "tab")
	tab_row.add_child(bottom_info_tab_button)
	bottom_cards_tab_button = _make_compact_button("필드", Callable(self, "_set_bottom_tab").bind("cards"), "items/berry", Vector2(58, 22))
	bottom_cards_tab_button.toggle_mode = true
	_set_button_reaction_mode(bottom_cards_tab_button, "tab")
	tab_row.add_child(bottom_cards_tab_button)
	bottom_base_tab_button = _make_compact_button("거점", Callable(self, "_set_bottom_tab").bind("base"), "actions/place", Vector2(58, 22))
	bottom_base_tab_button.toggle_mode = true
	bottom_base_tab_button.visible = false
	_set_button_reaction_mode(bottom_base_tab_button, "tab")
	tab_row.add_child(bottom_base_tab_button)

	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(box)

	map_info_tile_preview = TextureRect.new()
	map_info_tile_preview.custom_minimum_size = Vector2(52, 52)
	map_info_tile_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_info_tile_preview.stretch_mode = TextureRect.STRETCH_SCALE
	box.add_child(map_info_tile_preview)

	var info_box := VBoxContainer.new()
	info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_box.add_theme_constant_override("separation", 5)
	box.add_child(info_box)

	map_info_title_label = _small_title("정보")
	map_info_title_label.add_theme_font_size_override("font_size", 15)
	info_box.add_child(map_info_title_label)

	map_info_chips_box = HBoxContainer.new()
	map_info_chips_box.add_theme_constant_override("separation", 6)
	info_box.add_child(map_info_chips_box)

	map_info_body_label = _create_body_label()
	map_info_body_label.custom_minimum_size = Vector2(0, 44)
	map_info_body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_info_body_label.clip_text = true
	map_info_body_label.max_lines_visible = 3
	map_info_body_label.add_theme_font_size_override("font_size", 11)
	map_info_body_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	info_box.add_child(map_info_body_label)

	map_cards_scroll = ScrollContainer.new()
	map_cards_scroll.name = "MapFieldScroll"
	map_cards_scroll.visible = false
	map_cards_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_cards_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_cards_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	map_cards_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	map_cards_scroll.custom_minimum_size = Vector2(0, 0)
	info_box.add_child(map_cards_scroll)

	map_cards_box = VBoxContainer.new()
	map_cards_box.name = "MapFieldBox"
	map_cards_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_cards_box.add_theme_constant_override("separation", 4)
	map_cards_scroll.add_child(map_cards_box)

	map_base_scroll = ScrollContainer.new()
	map_base_scroll.name = "MapBaseScroll"
	map_base_scroll.visible = false
	map_base_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_base_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_base_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	map_base_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	map_base_scroll.custom_minimum_size = Vector2(0, 0)
	info_box.add_child(map_base_scroll)

	map_base_box = VBoxContainer.new()
	map_base_box.name = "MapBaseBox"
	map_base_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_base_box.add_theme_constant_override("separation", 4)
	map_base_scroll.add_child(map_base_box)

	map_cards_grid = _make_bottom_card_grid()


func _build_time_flow_hud() -> void:
	time_flow_panel = PanelContainer.new()
	time_flow_panel.anchor_left = 0.5
	time_flow_panel.anchor_right = 0.5
	time_flow_panel.anchor_top = 0.0
	time_flow_panel.offset_left = -330
	time_flow_panel.offset_right = 330
	time_flow_panel.offset_top = TIME_FLOW_HIDDEN_TOP
	time_flow_panel.offset_bottom = TIME_FLOW_HIDDEN_BOTTOM
	time_flow_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_flow_panel.z_as_relative = false
	time_flow_panel.z_index = Z_BASE_VIEW + 16
	time_flow_panel.modulate = Color(1, 1, 1, 0)
	time_flow_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.90, 0.86, 0.72, 0.92), Color(0.28, 0.30, 0.28, 0.72), 5))
	time_flow_panel.mouse_entered.connect(_on_time_flow_panel_mouse_entered)
	time_flow_panel.mouse_exited.connect(_on_time_flow_panel_mouse_exited)
	map_stack.add_child(time_flow_panel)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 6)
	time_flow_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)

	var top_row := HBoxContainer.new()
	top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	top_row.add_theme_constant_override("separation", 8)
	box.add_child(top_row)

	time_flow_label = Label.new()
	time_flow_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_flow_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_flow_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	time_flow_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	time_flow_label.add_theme_font_size_override("font_size", 13)
	time_flow_label.add_theme_color_override("font_color", Color(0.08, 0.10, 0.10))
	top_row.add_child(time_flow_label)

	time_phase_clock_label = Label.new()
	time_phase_clock_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_phase_clock_label.custom_minimum_size = Vector2(74, 0)
	time_phase_clock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	time_phase_clock_label.add_theme_font_size_override("font_size", 13)
	time_phase_clock_label.add_theme_color_override("font_color", Color(0.08, 0.10, 0.10))
	top_row.add_child(time_phase_clock_label)

	time_flow_track = Control.new()
	time_flow_track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_flow_track.custom_minimum_size = Vector2(0, 22)
	box.add_child(time_flow_track)

	time_flow_phase_labels.clear()
	var phase_order := _time_phase_order()
	for index in range(phase_order.size()):
		var phase_id := String(phase_order[index])
		var segment := ColorRect.new()
		segment.mouse_filter = Control.MOUSE_FILTER_IGNORE
		segment.anchor_left = float(index) / float(phase_order.size())
		segment.anchor_right = float(index + 1) / float(phase_order.size())
		segment.anchor_top = 0.20
		segment.anchor_bottom = 0.78
		segment.offset_left = 2
		segment.offset_right = -2
		segment.color = _time_phase_color(phase_id).darkened(0.15)
		time_flow_track.add_child(segment)

	time_phase_marker = PanelContainer.new()
	time_phase_marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_phase_marker.custom_minimum_size = Vector2(34, 26)
	time_phase_marker.add_theme_stylebox_override("panel", _make_panel_style(Color(1.0, 0.93, 0.55, 0.96), Color(0.14, 0.12, 0.06, 0.80), 10))
	time_flow_track.add_child(time_phase_marker)

	time_phase_marker_icon = Label.new()
	time_phase_marker_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_phase_marker_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_phase_marker_icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	time_phase_marker_icon.add_theme_font_size_override("font_size", 16)
	time_phase_marker_icon.add_theme_color_override("font_color", Color(0.08, 0.09, 0.08))
	time_phase_marker.add_child(time_phase_marker_icon)

	var label_row := HBoxContainer.new()
	label_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label_row.add_theme_constant_override("separation", 0)
	box.add_child(label_row)
	for phase_id in phase_order:
		var phase_label := Label.new()
		phase_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		phase_label.text = _time_phase_name(String(phase_id))
		phase_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		phase_label.add_theme_font_size_override("font_size", 10)
		phase_label.add_theme_color_override("font_color", Color(0.12, 0.14, 0.13))
		label_row.add_child(phase_label)
		time_flow_phase_labels[String(phase_id)] = phase_label

	_build_time_compact_hud()
	call_deferred("_apply_time_flow_visuals", false)


func _build_time_compact_hud() -> void:
	time_compact_panel = PanelContainer.new()
	time_compact_panel.anchor_left = 0.5
	time_compact_panel.anchor_right = 0.5
	time_compact_panel.anchor_top = 0.0
	time_compact_panel.offset_left = -22
	time_compact_panel.offset_right = 22
	time_compact_panel.offset_top = TIME_COMPACT_SHOWN_TOP
	time_compact_panel.offset_bottom = TIME_COMPACT_SHOWN_BOTTOM
	time_compact_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	time_compact_panel.z_as_relative = false
	time_compact_panel.z_index = Z_BASE_VIEW + 17
	time_compact_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.90, 0.86, 0.72, 0.94), Color(0.28, 0.30, 0.28, 0.72), 10))
	time_compact_panel.mouse_entered.connect(_on_time_compact_mouse_entered)
	time_compact_panel.mouse_exited.connect(_on_time_compact_mouse_exited)
	map_stack.add_child(time_compact_panel)

	time_compact_icon_label = Label.new()
	time_compact_icon_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_compact_icon_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	time_compact_icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_compact_icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	time_compact_icon_label.add_theme_font_size_override("font_size", 22)
	time_compact_icon_label.add_theme_color_override("font_color", Color(0.08, 0.09, 0.08))
	time_compact_panel.add_child(time_compact_icon_label)


func _build_time_transition_banner() -> void:
	time_transition_panel = PanelContainer.new()
	time_transition_panel.visible = false
	time_transition_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_transition_panel.clip_contents = true
	time_transition_panel.anchor_left = 0.5
	time_transition_panel.anchor_right = 0.5
	time_transition_panel.anchor_top = 0.0
	time_transition_panel.anchor_bottom = 0.0
	time_transition_panel.offset_left = -260
	time_transition_panel.offset_right = 260
	time_transition_panel.offset_top = 58
	time_transition_panel.offset_bottom = 144
	time_transition_panel.z_as_relative = false
	time_transition_panel.z_index = Z_BASE_VIEW + 15
	time_transition_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.045, 0.042, 0.88), Color(0.84, 0.74, 0.42, 0.62), 7))
	map_stack.add_child(time_transition_panel)

	time_transition_visual = TextureRect.new()
	time_transition_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_transition_visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	time_transition_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	time_transition_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	time_transition_visual.modulate = Color(1, 1, 1, 0.58)
	time_transition_panel.add_child(time_transition_visual)

	var scrim := ColorRect.new()
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scrim.color = Color(0.018, 0.022, 0.020, 0.48)
	time_transition_panel.add_child(scrim)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 9)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 9)
	time_transition_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 2)
	margin.add_child(box)

	time_transition_title_label = Label.new()
	time_transition_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_transition_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_transition_title_label.add_theme_font_size_override("font_size", 18)
	time_transition_title_label.add_theme_color_override("font_color", Color(1.0, 0.90, 0.58))
	time_transition_title_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.88))
	time_transition_title_label.add_theme_constant_override("shadow_offset_x", 1)
	time_transition_title_label.add_theme_constant_override("shadow_offset_y", 1)
	box.add_child(time_transition_title_label)

	time_transition_body_label = Label.new()
	time_transition_body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_transition_body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_transition_body_label.clip_text = true
	time_transition_body_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	time_transition_body_label.add_theme_font_size_override("font_size", 12)
	time_transition_body_label.add_theme_color_override("font_color", Color(0.90, 0.94, 0.86))
	time_transition_body_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.86))
	time_transition_body_label.add_theme_constant_override("shadow_offset_x", 1)
	time_transition_body_label.add_theme_constant_override("shadow_offset_y", 1)
	box.add_child(time_transition_body_label)


func _build_map_atmosphere_layers() -> void:
	map_wind_layer = Control.new()
	map_wind_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_wind_layer.z_as_relative = false
	map_wind_layer.z_index = Z_LAYER_MAP_OVERLAY + 4
	map_wind_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_camera.add_child(map_wind_layer)

	for index in range(7):
		var gust := ColorRect.new()
		gust.name = "Wind_%d" % index
		gust.mouse_filter = Control.MOUSE_FILTER_IGNORE
		gust.color = Color(0.92, 0.95, 0.86, 0.07)
		gust.custom_minimum_size = Vector2(70 + index * 12, 2)
		gust.rotation_degrees = -8
		gust.position = Vector2(-120 - index * 38, 64 + index * 48)
		map_wind_layer.add_child(gust)

	map_moving_fog_layer = Control.new()
	map_moving_fog_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_moving_fog_layer.z_as_relative = false
	map_moving_fog_layer.z_index = Z_LAYER_MAP_OVERLAY + 5
	map_moving_fog_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_camera.add_child(map_moving_fog_layer)

	var fog_texture = _texture_from_path("res://assets/ui/fog_patch.png")
	for index in range(4):
		var fog := TextureRect.new()
		fog.name = "DriftFog_%d" % index
		fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fog.custom_minimum_size = Vector2(260, 160)
		fog.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		fog.stretch_mode = TextureRect.STRETCH_SCALE
		fog.modulate = Color(0.78, 0.86, 0.86, 0.07)
		fog.position = Vector2(-260 + index * 210, 80 + (index % 2) * 190)
		if fog_texture != null:
			fog.texture = fog_texture
		map_moving_fog_layer.add_child(fog)

	map_weather_layer = Control.new()
	map_weather_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_weather_layer.z_as_relative = false
	map_weather_layer.z_index = Z_LAYER_MAP_OVERLAY + 6
	map_weather_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_camera.add_child(map_weather_layer)

	for index in range(18):
		var rain := ColorRect.new()
		rain.name = "Rain_%d" % index
		rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rain.color = Color(0.62, 0.78, 0.95, 0.0)
		rain.custom_minimum_size = Vector2(2, 34)
		rain.rotation_degrees = -13
		rain.position = Vector2(24 + index * 48, -60 - (index % 4) * 28)
		map_weather_layer.add_child(rain)

	call_deferred("_start_map_atmosphere_motion")


func _start_map_atmosphere_motion() -> void:
	if map_camera == null or map_camera.size.x <= 0.0:
		call_deferred("_start_map_atmosphere_motion")
		return
	if map_atmosphere_tween != null and map_atmosphere_tween.is_valid():
		map_atmosphere_tween.kill()
	map_atmosphere_tween = create_tween()
	map_atmosphere_tween.set_loops()
	map_atmosphere_tween.set_parallel(true)
	var bounds := map_camera.size
	if map_wind_layer != null:
		for child in map_wind_layer.get_children():
			var control := child as Control
			if control == null:
				continue
			var start_pos := control.position
			var end_pos := Vector2(bounds.x + 160.0, start_pos.y + 24.0)
			map_atmosphere_tween.tween_property(control, "position", end_pos, 5.0 + float(control.get_index()) * 0.45).from(start_pos)
	if map_moving_fog_layer != null:
		for child in map_moving_fog_layer.get_children():
			var control := child as Control
			if control == null:
				continue
			var start_pos := control.position
			var end_pos := start_pos + Vector2(120.0, -18.0)
			map_atmosphere_tween.tween_property(control, "position", end_pos, 8.0 + float(control.get_index()) * 1.4).from(start_pos)
	if map_weather_layer != null:
		for child in map_weather_layer.get_children():
			var control := child as Control
			if control == null:
				continue
			var start_pos := control.position
			var end_pos := Vector2(start_pos.x + 90.0, bounds.y + 70.0)
			map_atmosphere_tween.tween_property(control, "position", end_pos, 2.5 + float(control.get_index() % 5) * 0.18).from(start_pos)
	_refresh_map_atmosphere_visibility()


func _build_tool_menu_panel() -> void:
	tool_menu_panel = PanelContainer.new()
	tool_menu_panel.visible = false
	tool_menu_panel.z_as_relative = false
	tool_menu_panel.z_index = Z_TOOL_MENU
	tool_menu_panel.custom_minimum_size = Vector2(700, 500)
	tool_menu_panel.anchor_left = 0.0
	tool_menu_panel.anchor_top = 0.0
	tool_menu_panel.offset_left = 10
	tool_menu_panel.offset_top = 72
	tool_menu_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.04, 0.06, 0.06, 0.96), Color(0.77, 0.72, 0.46), 6))
	map_stack.add_child(tool_menu_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	tool_menu_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	box.add_child(header)
	tool_menu_title_label = _small_title("메뉴")
	tool_menu_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_menu_title_label.add_theme_font_size_override("font_size", 17)
	header.add_child(tool_menu_title_label)
	header.add_child(_make_button("닫기", Callable(self, "_hide_tool_menu")))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	tool_menu_content = VBoxContainer.new()
	tool_menu_content.custom_minimum_size = Vector2(660, 0)
	tool_menu_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_menu_content.add_theme_constant_override("separation", 6)
	scroll.add_child(tool_menu_content)


func _build_map_context_panel() -> void:
	map_context_panel = PanelContainer.new()
	map_context_panel.visible = false
	map_context_panel.custom_minimum_size = Vector2(MAP_CONTEXT_WIDTH, 0)
	map_context_panel.clip_contents = false
	map_context_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	map_context_panel.z_as_relative = false
	map_context_panel.z_index = Z_CONTEXT_MENU
	map_context_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.040, 0.056, 0.050, 0.98), Color(0.64, 0.56, 0.32, 0.82), 10))
	map_stack.add_child(map_context_panel)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 0)
	margin.add_theme_constant_override("margin_top", 0)
	margin.add_theme_constant_override("margin_right", 0)
	margin.add_theme_constant_override("margin_bottom", 0)
	map_context_panel.add_child(margin)

	map_context_signal_panel = Control.new()
	map_context_signal_panel.visible = false
	map_context_signal_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_context_signal_panel.clip_contents = true
	map_context_signal_panel.anchor_left = 0.5
	map_context_signal_panel.anchor_right = 0.5
	map_context_signal_panel.anchor_top = 0.5
	map_context_signal_panel.anchor_bottom = 0.5
	map_context_signal_panel.offset_left = -46
	map_context_signal_panel.offset_right = 46
	map_context_signal_panel.offset_top = -34
	map_context_signal_panel.offset_bottom = 34
	margin.add_child(map_context_signal_panel)

	map_context_signal_visual = TextureRect.new()
	map_context_signal_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_context_signal_visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_context_signal_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_context_signal_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	map_context_signal_visual.modulate = Color(1, 1, 1, 0.68)
	map_context_signal_panel.add_child(map_context_signal_visual)

	var context_signal_scrim := ColorRect.new()
	context_signal_scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	context_signal_scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	context_signal_scrim.color = Color(0.02, 0.025, 0.022, 0.34)
	map_context_signal_panel.add_child(context_signal_scrim)

	map_context_signal_label = Label.new()
	map_context_signal_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_context_signal_label.anchor_left = 0.0
	map_context_signal_label.anchor_right = 1.0
	map_context_signal_label.anchor_top = 1.0
	map_context_signal_label.anchor_bottom = 1.0
	map_context_signal_label.offset_top = -20
	map_context_signal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	map_context_signal_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	map_context_signal_label.clip_text = true
	map_context_signal_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	map_context_signal_label.add_theme_font_size_override("font_size", 10)
	map_context_signal_label.add_theme_color_override("font_color", Color(0.96, 0.90, 0.64))
	map_context_signal_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.84))
	map_context_signal_label.add_theme_constant_override("shadow_offset_x", 1)
	map_context_signal_label.add_theme_constant_override("shadow_offset_y", 1)
	map_context_signal_panel.add_child(map_context_signal_label)

	map_context_actions_box = Control.new()
	map_context_actions_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_context_actions_box.custom_minimum_size = Vector2(280, 220)
	map_context_actions_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_context_actions_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(map_context_actions_box)


func _build_base_view_panel() -> void:
	base_view_panel = PanelContainer.new()
	base_view_panel.visible = false
	base_view_panel.z_as_relative = false
	base_view_panel.z_index = Z_BASE_VIEW
	base_view_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	base_view_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.065, 0.06, 0.98), Color(0.60, 0.55, 0.38), 5))
	map_stack.add_child(base_view_panel)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 86)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	base_view_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)
	var title := _small_title("동굴 거점")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 24)
	header.add_child(title)
	header.add_child(_make_base_time_chip())
	header.add_child(_make_button("맵으로", Callable(self, "_hide_base_view"), "actions/move"))

	var content := HBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	box.add_child(content)

	var left_column := VBoxContainer.new()
	left_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_column.add_theme_constant_override("separation", 8)
	content.add_child(left_column)

	left_column.add_child(_make_base_life_scene())

	base_summary_label = _create_body_label()
	base_summary_label.add_theme_font_size_override("font_size", 13)
	base_summary_label.max_lines_visible = 3
	left_column.add_child(_make_overlay_content_panel(base_summary_label))

	var right_column := VBoxContainer.new()
	right_column.custom_minimum_size = Vector2(292, 0)
	right_column.size_flags_horizontal = Control.SIZE_SHRINK_END
	right_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_column.add_theme_constant_override("separation", 8)
	content.add_child(right_column)

	base_condition_grid = GridContainer.new()
	base_condition_grid.columns = 2
	base_condition_grid.add_theme_constant_override("h_separation", 6)
	base_condition_grid.add_theme_constant_override("v_separation", 6)
	right_column.add_child(_make_overlay_content_panel(base_condition_grid))

	base_actions_box = VBoxContainer.new()
	base_actions_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	base_actions_box.add_theme_constant_override("separation", 6)
	right_column.add_child(base_actions_box)

	base_drop_overlay = BASE_DROP_OVERLAY_SCRIPT.new()
	base_drop_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	base_drop_overlay.z_as_relative = false
	base_drop_overlay.z_index = Z_BASE_VIEW + 4
	base_drop_overlay.setup_drop_surface("base_direct", WorldManager.current_tile_id, ["inventory"], false)
	base_drop_overlay.item_drop_requested.connect(_on_item_drop_requested)
	map_stack.add_child(base_drop_overlay)


func _make_base_life_scene() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 220)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.042, 0.038, 0.98), Color(0.63, 0.55, 0.36, 0.72), 5))

	var stage := Control.new()
	stage.custom_minimum_size = Vector2(0, 220)
	panel.add_child(stage)

	var visual := TextureRect.new()
	base_life_visual = visual
	visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var base_visual_texture = _texture_from_path(_base_growth_visual_path())
	if base_visual_texture != null:
		visual.texture = base_visual_texture
	elif ResourceLoader.exists("res://assets/sprites/base/cave_floor.svg"):
		visual.texture = load("res://assets/sprites/base/cave_floor.svg")
	stage.add_child(visual)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.03, 0.035, 0.032, 0.18)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(shade)

	base_life_note_label = Label.new()
	base_life_note_label.anchor_left = 0.04
	base_life_note_label.anchor_top = 0.08
	base_life_note_label.anchor_right = 0.96
	base_life_note_label.anchor_bottom = 0.28
	base_life_note_label.offset_left = 0
	base_life_note_label.offset_top = 0
	base_life_note_label.offset_right = 0
	base_life_note_label.offset_bottom = 0
	base_life_note_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	base_life_note_label.add_theme_font_size_override("font_size", 14)
	base_life_note_label.add_theme_color_override("font_color", Color(0.94, 0.90, 0.74))
	base_life_note_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.75))
	base_life_note_label.add_theme_constant_override("shadow_offset_x", 1)
	base_life_note_label.add_theme_constant_override("shadow_offset_y", 1)
	stage.add_child(base_life_note_label)

	base_facility_grid = GridContainer.new()
	base_facility_grid.columns = 5
	base_facility_grid.anchor_left = 0.04
	base_facility_grid.anchor_top = 0.55
	base_facility_grid.anchor_right = 0.96
	base_facility_grid.anchor_bottom = 0.94
	base_facility_grid.add_theme_constant_override("h_separation", 6)
	base_facility_grid.add_theme_constant_override("v_separation", 6)
	stage.add_child(base_facility_grid)
	return panel


func _make_base_time_chip() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(210, 34)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.060, 0.055, 0.92), Color(0.72, 0.66, 0.42, 0.66), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/rest")
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	base_time_label = Label.new()
	base_time_label.name = "BaseTimeLabel"
	base_time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	base_time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	base_time_label.add_theme_font_size_override("font_size", 13)
	base_time_label.add_theme_color_override("font_color", Color(0.92, 0.91, 0.78))
	_prepare_single_line_label(base_time_label, 160)
	row.add_child(base_time_label)
	return panel


func _build_action_result_panel() -> void:
	action_result_panel = PanelContainer.new()
	action_result_panel.visible = false
	action_result_panel.z_as_relative = false
	action_result_panel.z_index = Z_ROOT_MODAL
	action_result_panel.anchor_left = 0.5
	action_result_panel.anchor_right = 0.5
	action_result_panel.anchor_top = 0.5
	action_result_panel.anchor_bottom = 0.5
	action_result_panel.offset_left = -360
	action_result_panel.offset_right = 360
	action_result_panel.offset_top = -210
	action_result_panel.offset_bottom = 210
	action_result_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	action_result_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.04, 0.06, 0.06, 0.98), Color(0.92, 0.82, 0.46), 8))
	add_child(action_result_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	action_result_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	box.add_child(header)
	action_result_icon = TextureRect.new()
	action_result_icon.custom_minimum_size = Vector2(42, 42)
	action_result_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	action_result_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	header.add_child(action_result_icon)
	action_result_title_label = Label.new()
	action_result_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_result_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	action_result_title_label.add_theme_font_size_override("font_size", 22)
	action_result_title_label.add_theme_color_override("font_color", Color(0.99, 0.93, 0.70))
	header.add_child(action_result_title_label)

	action_result_body_label = _create_body_label()
	action_result_body_label.custom_minimum_size = Vector2(0, 96)
	action_result_body_label.add_theme_font_size_override("font_size", 15)
	box.add_child(_make_overlay_content_panel(action_result_body_label))

	action_result_delta_label = _create_body_label()
	action_result_delta_label.custom_minimum_size = Vector2(0, 72)
	action_result_delta_label.add_theme_font_size_override("font_size", 13)
	box.add_child(_make_overlay_content_panel(action_result_delta_label))

	action_result_items_box = HBoxContainer.new()
	action_result_items_box.add_theme_constant_override("separation", 6)
	box.add_child(action_result_items_box)

	var button_row := HBoxContainer.new()
	button_row.alignment = BoxContainer.ALIGNMENT_END
	box.add_child(button_row)
	button_row.add_child(_make_button("확인", Callable(self, "_hide_action_result_panel")))


func _build_item_toast_panel() -> void:
	item_toast_panel = PanelContainer.new()
	item_toast_panel.visible = false
	item_toast_panel.z_as_relative = false
	item_toast_panel.z_index = Z_ROOT_TOAST
	item_toast_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item_toast_panel.anchor_left = 0.5
	item_toast_panel.anchor_right = 0.5
	item_toast_panel.anchor_top = 0.0
	item_toast_panel.offset_left = -170
	item_toast_panel.offset_right = 170
	item_toast_panel.offset_top = 86
	item_toast_panel.offset_bottom = 142
	item_toast_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.08, 0.07, 0.94), Color(0.92, 0.82, 0.46), 8))
	add_child(item_toast_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 7)
	item_toast_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)

	var label := _small_title("획득")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 13)
	box.add_child(label)

	item_toast_items_box = HBoxContainer.new()
	item_toast_items_box.alignment = BoxContainer.ALIGNMENT_CENTER
	item_toast_items_box.add_theme_constant_override("separation", 5)
	box.add_child(item_toast_items_box)


func _build_action_delta_panel() -> void:
	action_delta_panel = PanelContainer.new()
	action_delta_panel.visible = false
	action_delta_panel.z_as_relative = false
	action_delta_panel.z_index = Z_ROOT_TOAST - 1
	action_delta_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_delta_panel.anchor_left = 0.5
	action_delta_panel.anchor_right = 0.5
	action_delta_panel.anchor_top = 1.0
	action_delta_panel.anchor_bottom = 1.0
	action_delta_panel.offset_left = -360
	action_delta_panel.offset_right = 360
	action_delta_panel.offset_top = -92
	action_delta_panel.offset_bottom = -44
	action_delta_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.052, 0.048, 0.92), Color(0.62, 0.58, 0.36, 0.84), 8))
	add_child(action_delta_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 7)
	action_delta_panel.add_child(margin)

	action_delta_items_box = HBoxContainer.new()
	action_delta_items_box.alignment = BoxContainer.ALIGNMENT_CENTER
	action_delta_items_box.add_theme_constant_override("separation", 6)
	margin.add_child(action_delta_items_box)


func _build_item_action_panel() -> void:
	item_action_panel = PanelContainer.new()
	item_action_panel.visible = false
	item_action_panel.z_as_relative = false
	item_action_panel.z_index = Z_ROOT_MODAL + 1
	item_action_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.062, 0.056, 0.98), Color(0.86, 0.74, 0.42, 0.82), 7))
	add_child(item_action_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	item_action_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)
	item_action_title_label = _small_title("아이템 사용")
	item_action_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_action_title_label.add_theme_font_size_override("font_size", 17)
	header.add_child(item_action_title_label)
	header.add_child(_make_compact_button("닫기", Callable(self, "_hide_item_action_panel"), "actions/rest", Vector2(62, 24)))

	item_action_body_label = _create_body_label()
	item_action_body_label.add_theme_font_size_override("font_size", 12)
	item_action_body_label.custom_minimum_size = Vector2(0, 44)
	box.add_child(_make_overlay_content_panel(item_action_body_label))

	item_action_buttons_box = VBoxContainer.new()
	item_action_buttons_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_action_buttons_box.add_theme_constant_override("separation", 5)
	box.add_child(item_action_buttons_box)
	_fit_center_overlay(item_action_panel, ITEM_ACTION_DESIRED_SIZE)


func _build_action_cutin_layer() -> void:
	screen_flash_overlay = ColorRect.new()
	screen_flash_overlay.visible = false
	screen_flash_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	screen_flash_overlay.z_as_relative = false
	screen_flash_overlay.z_index = Z_ROOT_CUTIN - 1
	screen_flash_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_flash_overlay.color = Color(1.0, 0.92, 0.58, 0.0)
	add_child(screen_flash_overlay)

	action_cutin_layer = Control.new()
	action_cutin_layer.visible = false
	action_cutin_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_layer.z_as_relative = false
	action_cutin_layer.z_index = Z_ROOT_CUTIN
	action_cutin_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(action_cutin_layer)

	var top_bar := ColorRect.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.anchor_left = 0.0
	top_bar.anchor_right = 1.0
	top_bar.anchor_top = 0.0
	top_bar.anchor_bottom = 0.0
	top_bar.offset_bottom = 58.0
	top_bar.color = Color(0.0, 0.0, 0.0, 0.62)
	action_cutin_layer.add_child(top_bar)

	var bottom_bar := ColorRect.new()
	bottom_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom_bar.anchor_left = 0.0
	bottom_bar.anchor_right = 1.0
	bottom_bar.anchor_top = 1.0
	bottom_bar.anchor_bottom = 1.0
	bottom_bar.offset_top = -58.0
	bottom_bar.color = Color(0.0, 0.0, 0.0, 0.62)
	action_cutin_layer.add_child(bottom_bar)

	action_cutin_backdrop = TextureRect.new()
	action_cutin_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_backdrop.anchor_left = 0.0
	action_cutin_backdrop.anchor_right = 1.0
	action_cutin_backdrop.anchor_top = 0.5
	action_cutin_backdrop.anchor_bottom = 0.5
	action_cutin_backdrop.offset_top = -104.0
	action_cutin_backdrop.offset_bottom = 104.0
	action_cutin_backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	action_cutin_backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var backdrop_texture = _texture_from_path("res://assets/ui/action_cutin/action_cutin_panel.png")
	if backdrop_texture != null:
		action_cutin_backdrop.texture = backdrop_texture
	action_cutin_layer.add_child(action_cutin_backdrop)

	var backdrop_scrim := ColorRect.new()
	backdrop_scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop_scrim.anchor_left = 0.0
	backdrop_scrim.anchor_right = 1.0
	backdrop_scrim.anchor_top = 0.5
	backdrop_scrim.anchor_bottom = 0.5
	backdrop_scrim.offset_top = -104.0
	backdrop_scrim.offset_bottom = 104.0
	backdrop_scrim.color = Color(0.02, 0.025, 0.022, 0.42)
	action_cutin_layer.add_child(backdrop_scrim)

	action_cutin_streaks = TextureRect.new()
	action_cutin_streaks.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_streaks.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	action_cutin_streaks.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	action_cutin_streaks.stretch_mode = TextureRect.STRETCH_SCALE
	action_cutin_streaks.modulate = Color(1, 1, 1, 0.72)
	var streak_texture = _texture_from_path("res://assets/ui/action_cutin/action_streaks.png")
	if streak_texture != null:
		action_cutin_streaks.texture = streak_texture
	action_cutin_layer.add_child(action_cutin_streaks)

	var content := HBoxContainer.new()
	content.name = "Content"
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.anchor_left = 0.5
	content.anchor_right = 0.5
	content.anchor_top = 0.5
	content.anchor_bottom = 0.5
	content.offset_left = -270.0
	content.offset_right = 270.0
	content.offset_top = -42.0
	content.offset_bottom = 42.0
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 16)
	action_cutin_layer.add_child(content)

	action_cutin_icon = TextureRect.new()
	action_cutin_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_icon.custom_minimum_size = Vector2(58, 58)
	action_cutin_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	action_cutin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content.add_child(action_cutin_icon)

	var text_box := VBoxContainer.new()
	text_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.alignment = BoxContainer.ALIGNMENT_CENTER
	text_box.add_theme_constant_override("separation", 4)
	content.add_child(text_box)

	action_cutin_title_label = Label.new()
	action_cutin_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_title_label.add_theme_font_size_override("font_size", 24)
	action_cutin_title_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.66))
	action_cutin_title_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.88))
	action_cutin_title_label.add_theme_constant_override("shadow_offset_x", 1)
	action_cutin_title_label.add_theme_constant_override("shadow_offset_y", 1)
	action_cutin_title_label.text = ""
	text_box.add_child(action_cutin_title_label)

	action_cutin_body_label = Label.new()
	action_cutin_body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_cutin_body_label.clip_text = true
	action_cutin_body_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	action_cutin_body_label.add_theme_font_size_override("font_size", 13)
	action_cutin_body_label.add_theme_color_override("font_color", Color(0.90, 0.92, 0.82))
	action_cutin_body_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.015, 0.86))
	action_cutin_body_label.add_theme_constant_override("shadow_offset_x", 1)
	action_cutin_body_label.add_theme_constant_override("shadow_offset_y", 1)
	action_cutin_body_label.text = ""
	text_box.add_child(action_cutin_body_label)


func _build_event_intro_layer() -> void:
	event_intro_layer = Control.new()
	event_intro_layer.visible = false
	event_intro_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	event_intro_layer.z_as_relative = false
	event_intro_layer.z_index = Z_ROOT_EVENT_INTRO
	event_intro_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(event_intro_layer)

	event_intro_blackout = ColorRect.new()
	event_intro_blackout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	event_intro_blackout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	event_intro_blackout.color = Color(0.0, 0.0, 0.0, 0.0)
	event_intro_layer.add_child(event_intro_blackout)

	event_intro_badge = PanelContainer.new()
	event_intro_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	event_intro_badge.anchor_left = 0.5
	event_intro_badge.anchor_right = 0.5
	event_intro_badge.anchor_top = 0.5
	event_intro_badge.anchor_bottom = 0.5
	event_intro_badge.offset_left = -58.0
	event_intro_badge.offset_right = 58.0
	event_intro_badge.offset_top = -58.0
	event_intro_badge.offset_bottom = 58.0
	event_intro_badge.pivot_offset = Vector2(58, 58)
	event_intro_badge.add_theme_stylebox_override("panel", _make_panel_style(Color(0.070, 0.030, 0.018, 0.82), Color(1.0, 0.55, 0.22, 0.92), 14))
	event_intro_layer.add_child(event_intro_badge)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	event_intro_badge.add_child(margin)

	event_intro_icon = TextureRect.new()
	event_intro_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	event_intro_icon.custom_minimum_size = Vector2(92, 92)
	event_intro_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	event_intro_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var alert_texture = _icon_texture("actions/event_alert")
	if alert_texture != null:
		event_intro_icon.texture = alert_texture
	margin.add_child(event_intro_icon)


func _build_cutscene_layer() -> void:
	cutscene_layer = Control.new()
	cutscene_layer.visible = false
	cutscene_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	cutscene_layer.z_as_relative = false
	cutscene_layer.z_index = Z_ROOT_CUTSCENE
	cutscene_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(cutscene_layer)

	cutscene_background = TextureRect.new()
	cutscene_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cutscene_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	cutscene_background.stretch_mode = TextureRect.STRETCH_SCALE
	cutscene_layer.add_child(cutscene_background)

	cutscene_scrim = ColorRect.new()
	cutscene_scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_scrim.color = Color(0.015, 0.020, 0.022, 0.46)
	cutscene_scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cutscene_layer.add_child(cutscene_scrim)

	var top_bar := ColorRect.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.color = Color(0, 0, 0, 0.76)
	top_bar.anchor_right = 1.0
	top_bar.offset_bottom = 62.0
	cutscene_layer.add_child(top_bar)

	var bottom_bar := ColorRect.new()
	bottom_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom_bar.color = Color(0, 0, 0, 0.82)
	bottom_bar.anchor_top = 1.0
	bottom_bar.anchor_right = 1.0
	bottom_bar.anchor_bottom = 1.0
	bottom_bar.offset_top = -210.0
	cutscene_layer.add_child(bottom_bar)

	cutscene_left_image = _make_cutscene_portrait_rect()
	cutscene_left_image.anchor_left = 0.02
	cutscene_left_image.anchor_right = 0.38
	cutscene_left_image.anchor_top = 0.12
	cutscene_left_image.anchor_bottom = 0.88
	cutscene_layer.add_child(cutscene_left_image)

	cutscene_right_image = _make_cutscene_portrait_rect()
	cutscene_right_image.anchor_left = 0.62
	cutscene_right_image.anchor_right = 0.98
	cutscene_right_image.anchor_top = 0.12
	cutscene_right_image.anchor_bottom = 0.88
	cutscene_layer.add_child(cutscene_right_image)

	cutscene_text_panel = PanelContainer.new()
	cutscene_text_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_text_panel.anchor_left = 0.11
	cutscene_text_panel.anchor_right = 0.89
	cutscene_text_panel.anchor_top = 1.0
	cutscene_text_panel.anchor_bottom = 1.0
	cutscene_text_panel.offset_top = -174.0
	cutscene_text_panel.offset_bottom = -24.0
	cutscene_text_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.050, 0.94), Color(0.78, 0.70, 0.42), 6))
	cutscene_layer.add_child(cutscene_text_panel)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 10)
	cutscene_text_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(header)

	cutscene_speaker_label = Label.new()
	cutscene_speaker_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_speaker_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cutscene_speaker_label.add_theme_font_size_override("font_size", 18)
	cutscene_speaker_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.52))
	header.add_child(cutscene_speaker_label)

	cutscene_step_label = Label.new()
	cutscene_step_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_step_label.add_theme_font_size_override("font_size", 12)
	cutscene_step_label.add_theme_color_override("font_color", Color(0.70, 0.76, 0.72))
	header.add_child(cutscene_step_label)

	cutscene_body_label = _create_body_label()
	cutscene_body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_body_label.custom_minimum_size = Vector2(0, 62)
	cutscene_body_label.add_theme_font_size_override("font_size", 15)
	box.add_child(cutscene_body_label)

	cutscene_prompt_label = Label.new()
	cutscene_prompt_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cutscene_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cutscene_prompt_label.text = "클릭 / Enter"
	cutscene_prompt_label.add_theme_font_size_override("font_size", 12)
	cutscene_prompt_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.72))
	box.add_child(cutscene_prompt_label)


func _build_tool_craft_minigame_panel() -> void:
	tool_craft_layer = Control.new()
	tool_craft_layer.visible = false
	tool_craft_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	tool_craft_layer.z_as_relative = false
	tool_craft_layer.z_index = Z_ROOT_MODAL + 4
	tool_craft_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(tool_craft_layer)

	var dim := ColorRect.new()
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim.color = Color(0.01, 0.015, 0.014, 0.70)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tool_craft_layer.add_child(dim)

	tool_craft_panel = PanelContainer.new()
	tool_craft_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.040, 0.055, 0.050, 0.98), Color(0.82, 0.70, 0.38), 7))
	tool_craft_layer.add_child(tool_craft_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	tool_craft_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	box.add_child(header)

	tool_craft_icon = TextureRect.new()
	tool_craft_icon.custom_minimum_size = Vector2(42, 42)
	tool_craft_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tool_craft_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	header.add_child(tool_craft_icon)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title_box)

	tool_craft_title_label = _small_title("도구 손작업")
	tool_craft_title_label.add_theme_font_size_override("font_size", 18)
	title_box.add_child(tool_craft_title_label)

	tool_craft_step_label = Label.new()
	tool_craft_step_label.add_theme_font_size_override("font_size", 12)
	tool_craft_step_label.add_theme_color_override("font_color", Color(0.76, 0.82, 0.76))
	title_box.add_child(tool_craft_step_label)

	var cancel_button := _make_button("멈춤", Callable(self, "_cancel_active_minigame"), "actions/rest")
	cancel_button.custom_minimum_size = Vector2(82, 32)
	header.add_child(cancel_button)

	_build_tool_craft_visual_stage(box)
	_build_fishing_minigame_visual_stage(box)
	_build_hunting_minigame_visual_stage(box)

	tool_craft_body_label = _create_body_label()
	tool_craft_body_label.custom_minimum_size = Vector2(0, 48)
	tool_craft_body_label.add_theme_font_size_override("font_size", 13)
	box.add_child(_make_overlay_content_panel(tool_craft_body_label))

	var progress_box := VBoxContainer.new()
	progress_box.add_theme_constant_override("separation", 4)
	box.add_child(progress_box)

	var progress_header := HBoxContainer.new()
	progress_box.add_child(progress_header)

	tool_craft_quality_label = Label.new()
	tool_craft_quality_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_craft_quality_label.add_theme_font_size_override("font_size", 12)
	tool_craft_quality_label.add_theme_color_override("font_color", Color(0.94, 0.90, 0.72))
	progress_header.add_child(tool_craft_quality_label)

	tool_craft_hint_label = Label.new()
	tool_craft_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	tool_craft_hint_label.add_theme_font_size_override("font_size", 12)
	tool_craft_hint_label.add_theme_color_override("font_color", Color(0.70, 0.78, 0.72))
	progress_header.add_child(tool_craft_hint_label)

	tool_craft_progress = ProgressBar.new()
	tool_craft_progress.max_value = 100.0
	tool_craft_progress.value = 100.0
	tool_craft_progress.show_percentage = false
	tool_craft_progress.custom_minimum_size = Vector2(0, 18)
	progress_box.add_child(tool_craft_progress)

	action_minigame_meter_box = VBoxContainer.new()
	action_minigame_meter_box.visible = false
	action_minigame_meter_box.add_theme_constant_override("separation", 4)
	box.add_child(action_minigame_meter_box)

	var action_meter_header := HBoxContainer.new()
	action_minigame_meter_box.add_child(action_meter_header)

	action_minigame_meter_label = Label.new()
	action_minigame_meter_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_minigame_meter_label.add_theme_font_size_override("font_size", 12)
	action_minigame_meter_label.add_theme_color_override("font_color", Color(0.86, 0.90, 0.74))
	action_meter_header.add_child(action_minigame_meter_label)

	action_minigame_state_label = Label.new()
	action_minigame_state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	action_minigame_state_label.add_theme_font_size_override("font_size", 12)
	action_minigame_state_label.add_theme_color_override("font_color", Color(0.74, 0.84, 0.78))
	action_meter_header.add_child(action_minigame_state_label)

	action_minigame_meter_bar = ProgressBar.new()
	action_minigame_meter_bar.min_value = 0.0
	action_minigame_meter_bar.max_value = 100.0
	action_minigame_meter_bar.value = 50.0
	action_minigame_meter_bar.show_percentage = false
	action_minigame_meter_bar.custom_minimum_size = Vector2(0, 18)
	action_minigame_meter_box.add_child(action_minigame_meter_bar)

	tool_craft_actions_box = HBoxContainer.new()
	tool_craft_actions_box.alignment = BoxContainer.ALIGNMENT_CENTER
	tool_craft_actions_box.add_theme_constant_override("separation", 8)
	box.add_child(tool_craft_actions_box)

	tool_craft_footer_label = _create_body_label()
	tool_craft_footer_label.add_theme_font_size_override("font_size", 11)
	tool_craft_footer_label.add_theme_color_override("font_color", Color(0.70, 0.76, 0.70))
	tool_craft_footer_label.text = "도구 제작은 손작업 품질을 본다. 성공하면 기존 제작 비용이 소모되고, 실패하면 재료는 잃지 않지만 30분과 약간의 기력이 줄어든다."
	box.add_child(tool_craft_footer_label)


func _build_tool_craft_visual_stage(parent: VBoxContainer) -> void:
	tool_craft_visual_frame = Control.new()
	tool_craft_visual_frame.custom_minimum_size = Vector2(0, 232)
	tool_craft_visual_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_craft_visual_frame.clip_contents = true
	parent.add_child(tool_craft_visual_frame)

	var bg := TextureRect.new()
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	var bg_texture = _texture_from_path("res://assets/ui/tool_craft/island_workbench.png")
	if bg_texture != null:
		bg.texture = bg_texture
	tool_craft_visual_frame.add_child(bg)

	var vignette := ColorRect.new()
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vignette.color = Color(0.04, 0.035, 0.020, 0.08)
	tool_craft_visual_frame.add_child(vignette)

	tool_craft_workpiece_panel = PanelContainer.new()
	tool_craft_workpiece_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool_craft_workpiece_panel.anchor_left = 0.5
	tool_craft_workpiece_panel.anchor_right = 0.5
	tool_craft_workpiece_panel.anchor_top = 0.5
	tool_craft_workpiece_panel.anchor_bottom = 0.5
	tool_craft_workpiece_panel.offset_left = -78
	tool_craft_workpiece_panel.offset_right = 78
	tool_craft_workpiece_panel.offset_top = -72
	tool_craft_workpiece_panel.offset_bottom = 72
	tool_craft_workpiece_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(1.0, 0.86, 0.48, 0.15), Color(0.98, 0.82, 0.36, 0.72), 15))
	tool_craft_visual_frame.add_child(tool_craft_workpiece_panel)

	var workpiece_margin := MarginContainer.new()
	workpiece_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	workpiece_margin.add_theme_constant_override("margin_left", 18)
	workpiece_margin.add_theme_constant_override("margin_top", 18)
	workpiece_margin.add_theme_constant_override("margin_right", 18)
	workpiece_margin.add_theme_constant_override("margin_bottom", 18)
	tool_craft_workpiece_panel.add_child(workpiece_margin)

	tool_craft_workpiece_icon = TextureRect.new()
	tool_craft_workpiece_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool_craft_workpiece_icon.custom_minimum_size = Vector2(104, 104)
	tool_craft_workpiece_icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_craft_workpiece_icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tool_craft_workpiece_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tool_craft_workpiece_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	workpiece_margin.add_child(tool_craft_workpiece_icon)

	tool_craft_step_badge = PanelContainer.new()
	tool_craft_step_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool_craft_step_badge.anchor_left = 0.0
	tool_craft_step_badge.anchor_right = 0.0
	tool_craft_step_badge.anchor_top = 0.0
	tool_craft_step_badge.anchor_bottom = 0.0
	tool_craft_step_badge.offset_left = 14
	tool_craft_step_badge.offset_right = 260
	tool_craft_step_badge.offset_top = 14
	tool_craft_step_badge.offset_bottom = 62
	tool_craft_step_badge.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.055, 0.048, 0.76), Color(0.93, 0.75, 0.32, 0.58), 6))
	tool_craft_visual_frame.add_child(tool_craft_step_badge)

	var step_margin := MarginContainer.new()
	step_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	step_margin.add_theme_constant_override("margin_left", 8)
	step_margin.add_theme_constant_override("margin_top", 6)
	step_margin.add_theme_constant_override("margin_right", 8)
	step_margin.add_theme_constant_override("margin_bottom", 6)
	tool_craft_step_badge.add_child(step_margin)

	var step_row := HBoxContainer.new()
	step_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	step_row.add_theme_constant_override("separation", 7)
	step_margin.add_child(step_row)

	tool_craft_step_icon = TextureRect.new()
	tool_craft_step_icon.custom_minimum_size = Vector2(28, 28)
	tool_craft_step_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tool_craft_step_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	step_row.add_child(tool_craft_step_icon)

	tool_craft_step_text_label = Label.new()
	tool_craft_step_text_label.clip_text = true
	tool_craft_step_text_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	tool_craft_step_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tool_craft_step_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_craft_step_text_label.add_theme_font_size_override("font_size", 13)
	tool_craft_step_text_label.add_theme_color_override("font_color", Color(0.99, 0.92, 0.66))
	step_row.add_child(tool_craft_step_text_label)

	var materials_panel := PanelContainer.new()
	materials_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	materials_panel.anchor_left = 0.5
	materials_panel.anchor_right = 0.5
	materials_panel.anchor_top = 1.0
	materials_panel.anchor_bottom = 1.0
	materials_panel.offset_left = -230
	materials_panel.offset_right = 230
	materials_panel.offset_top = -64
	materials_panel.offset_bottom = -12
	materials_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.044, 0.038, 0.76), Color(0.84, 0.78, 0.46, 0.36), 8))
	tool_craft_visual_frame.add_child(materials_panel)

	var materials_margin := MarginContainer.new()
	materials_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	materials_margin.add_theme_constant_override("margin_left", 8)
	materials_margin.add_theme_constant_override("margin_top", 6)
	materials_margin.add_theme_constant_override("margin_right", 8)
	materials_margin.add_theme_constant_override("margin_bottom", 6)
	materials_panel.add_child(materials_margin)

	tool_craft_materials_box = HBoxContainer.new()
	tool_craft_materials_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool_craft_materials_box.alignment = BoxContainer.ALIGNMENT_CENTER
	tool_craft_materials_box.add_theme_constant_override("separation", 8)
	materials_margin.add_child(tool_craft_materials_box)

	tool_craft_visual_flash = ColorRect.new()
	tool_craft_visual_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool_craft_visual_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tool_craft_visual_flash.color = Color(1, 1, 1, 0)
	tool_craft_visual_frame.add_child(tool_craft_visual_flash)


func _build_fishing_minigame_visual_stage(parent: VBoxContainer) -> void:
	fishing_visual_frame = Control.new()
	fishing_visual_frame.visible = false
	fishing_visual_frame.custom_minimum_size = Vector2(0, 232)
	fishing_visual_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fishing_visual_frame.clip_contents = true
	parent.add_child(fishing_visual_frame)

	var bg := TextureRect.new()
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	var bg_texture = _texture_from_path("res://assets/ui/fishing_minigame/shore_water_stage.png")
	if bg_texture != null:
		bg.texture = bg_texture
	fishing_visual_frame.add_child(bg)

	var water_tint := ColorRect.new()
	water_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	water_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	water_tint.color = Color(0.00, 0.12, 0.14, 0.10)
	fishing_visual_frame.add_child(water_tint)

	fishing_line_visual = ColorRect.new()
	fishing_line_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_line_visual.color = Color(0.92, 0.78, 0.42, 0.82)
	fishing_visual_frame.add_child(fishing_line_visual)

	fishing_target_zone = ColorRect.new()
	fishing_target_zone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_target_zone.color = Color(0.95, 0.90, 0.40, 0.16)
	fishing_visual_frame.add_child(fishing_target_zone)

	fishing_ripple_ring = PanelContainer.new()
	fishing_ripple_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_ripple_ring.add_theme_stylebox_override("panel", _make_panel_style(Color(0.70, 0.96, 1.0, 0.05), Color(0.82, 0.96, 1.0, 0.56), 99))
	fishing_visual_frame.add_child(fishing_ripple_ring)

	fishing_bobber = PanelContainer.new()
	fishing_bobber.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_bobber.custom_minimum_size = Vector2(36, 36)
	fishing_bobber.add_theme_stylebox_override("panel", _make_panel_style(Color(0.96, 0.18, 0.12, 0.96), Color(1.0, 0.94, 0.78, 0.90), 99))
	fishing_visual_frame.add_child(fishing_bobber)

	fishing_bobber_label = Label.new()
	fishing_bobber_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_bobber_label.text = "•"
	fishing_bobber_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fishing_bobber_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fishing_bobber_label.add_theme_font_size_override("font_size", 26)
	fishing_bobber_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.78))
	fishing_bobber.add_child(fishing_bobber_label)

	var gauge_panel := PanelContainer.new()
	gauge_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_panel.anchor_left = 1.0
	gauge_panel.anchor_right = 1.0
	gauge_panel.anchor_top = 0.0
	gauge_panel.anchor_bottom = 0.0
	gauge_panel.offset_left = -192
	gauge_panel.offset_right = -14
	gauge_panel.offset_top = 14
	gauge_panel.offset_bottom = 78
	gauge_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.02, 0.06, 0.07, 0.68), Color(0.64, 0.90, 0.84, 0.34), 7))
	fishing_visual_frame.add_child(gauge_panel)

	var gauge_margin := MarginContainer.new()
	gauge_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_margin.add_theme_constant_override("margin_left", 8)
	gauge_margin.add_theme_constant_override("margin_top", 7)
	gauge_margin.add_theme_constant_override("margin_right", 8)
	gauge_margin.add_theme_constant_override("margin_bottom", 7)
	gauge_panel.add_child(gauge_margin)

	var gauge_box := VBoxContainer.new()
	gauge_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_box.add_theme_constant_override("separation", 6)
	gauge_margin.add_child(gauge_box)

	fishing_tension_bar = _make_fishing_visual_bar(Color(0.92, 0.56, 0.22))
	gauge_box.add_child(fishing_tension_bar)
	fishing_hook_bar = _make_fishing_visual_bar(Color(0.54, 0.90, 0.58))
	gauge_box.add_child(fishing_hook_bar)

	fishing_visual_flash = ColorRect.new()
	fishing_visual_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fishing_visual_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fishing_visual_flash.color = Color(1, 1, 1, 0)
	fishing_visual_frame.add_child(fishing_visual_flash)


func _make_fishing_visual_bar(fill_color: Color) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.value = 50.0
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 16)
	bar.add_theme_stylebox_override("background", _make_panel_style(Color(0.02, 0.035, 0.04, 0.74), fill_color.darkened(0.55), 5))
	bar.add_theme_stylebox_override("fill", _make_panel_style(fill_color, fill_color.lightened(0.25), 5))
	return bar


func _build_hunting_minigame_visual_stage(parent: VBoxContainer) -> void:
	hunting_visual_frame = Control.new()
	hunting_visual_frame.visible = false
	hunting_visual_frame.custom_minimum_size = Vector2(0, 232)
	hunting_visual_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hunting_visual_frame.clip_contents = true
	parent.add_child(hunting_visual_frame)

	var bg := TextureRect.new()
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	var bg_texture = _texture_from_path("res://assets/ui/hunting_minigame/jungle_tracks_stage.png")
	if bg_texture != null:
		bg.texture = bg_texture
	hunting_visual_frame.add_child(bg)

	var forest_tint := ColorRect.new()
	forest_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	forest_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forest_tint.color = Color(0.03, 0.06, 0.02, 0.10)
	hunting_visual_frame.add_child(forest_tint)

	hunting_target_zone = ColorRect.new()
	hunting_target_zone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_target_zone.color = Color(0.92, 0.78, 0.32, 0.15)
	hunting_visual_frame.add_child(hunting_target_zone)

	hunting_noise_ring = PanelContainer.new()
	hunting_noise_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_noise_ring.add_theme_stylebox_override("panel", _make_panel_style(Color(0.94, 0.76, 0.36, 0.04), Color(0.94, 0.76, 0.36, 0.48), 99))
	hunting_visual_frame.add_child(hunting_noise_ring)

	hunting_track_marker = PanelContainer.new()
	hunting_track_marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_track_marker.custom_minimum_size = Vector2(38, 38)
	hunting_track_marker.add_theme_stylebox_override("panel", _make_panel_style(Color(0.10, 0.16, 0.08, 0.92), Color(0.92, 0.78, 0.36, 0.88), 99))
	hunting_visual_frame.add_child(hunting_track_marker)

	hunting_track_label = Label.new()
	hunting_track_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_track_label.text = "⌾"
	hunting_track_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hunting_track_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hunting_track_label.add_theme_font_size_override("font_size", 22)
	hunting_track_label.add_theme_color_override("font_color", Color(0.98, 0.90, 0.56))
	hunting_track_marker.add_child(hunting_track_label)

	var wind_panel := PanelContainer.new()
	wind_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wind_panel.anchor_left = 0.0
	wind_panel.anchor_right = 0.0
	wind_panel.anchor_top = 0.0
	wind_panel.anchor_bottom = 0.0
	wind_panel.offset_left = 16
	wind_panel.offset_right = 62
	wind_panel.offset_top = 16
	wind_panel.offset_bottom = 62
	wind_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.02, 0.045, 0.035, 0.74), Color(0.58, 0.88, 0.62, 0.46), 99))
	hunting_visual_frame.add_child(wind_panel)

	hunting_wind_arrow = Label.new()
	hunting_wind_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_wind_arrow.text = "↗"
	hunting_wind_arrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hunting_wind_arrow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hunting_wind_arrow.add_theme_font_size_override("font_size", 24)
	hunting_wind_arrow.add_theme_color_override("font_color", Color(0.80, 0.96, 0.66))
	wind_panel.add_child(hunting_wind_arrow)

	var gauge_panel := PanelContainer.new()
	gauge_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_panel.anchor_left = 1.0
	gauge_panel.anchor_right = 1.0
	gauge_panel.anchor_top = 0.0
	gauge_panel.anchor_bottom = 0.0
	gauge_panel.offset_left = -192
	gauge_panel.offset_right = -14
	gauge_panel.offset_top = 14
	gauge_panel.offset_bottom = 78
	gauge_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.040, 0.025, 0.72), Color(0.70, 0.84, 0.42, 0.36), 7))
	hunting_visual_frame.add_child(gauge_panel)

	var gauge_margin := MarginContainer.new()
	gauge_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_margin.add_theme_constant_override("margin_left", 8)
	gauge_margin.add_theme_constant_override("margin_top", 7)
	gauge_margin.add_theme_constant_override("margin_right", 8)
	gauge_margin.add_theme_constant_override("margin_bottom", 7)
	gauge_panel.add_child(gauge_margin)

	var gauge_box := VBoxContainer.new()
	gauge_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gauge_box.add_theme_constant_override("separation", 6)
	gauge_margin.add_child(gauge_box)

	hunting_distance_bar = _make_fishing_visual_bar(Color(0.70, 0.84, 0.38))
	gauge_box.add_child(hunting_distance_bar)
	hunting_noise_bar = _make_fishing_visual_bar(Color(0.86, 0.46, 0.26))
	gauge_box.add_child(hunting_noise_bar)

	hunting_visual_flash = ColorRect.new()
	hunting_visual_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hunting_visual_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hunting_visual_flash.color = Color(1, 1, 1, 0)
	hunting_visual_frame.add_child(hunting_visual_flash)


func _make_cutscene_portrait_rect() -> TextureRect:
	var image := TextureRect.new()
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.modulate = Color(1, 1, 1, 0)
	return image


func _build_event_panel() -> void:
	event_panel = PanelContainer.new()
	event_panel.visible = false
	event_panel.z_as_relative = false
	event_panel.z_index = Z_ROOT_EVENT
	event_panel.anchor_left = 0.5
	event_panel.anchor_right = 0.5
	event_panel.anchor_top = 0.5
	event_panel.anchor_bottom = 0.5
	event_panel.offset_left = -310
	event_panel.offset_right = 310
	event_panel.offset_top = -180
	event_panel.offset_bottom = 180
	event_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.08, 0.12, 0.14, 0.98), Color(0.38, 0.55, 0.60), 8))
	add_child(event_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	event_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)
	event_title_label = Label.new()
	event_title_label.add_theme_font_size_override("font_size", 20)
	event_title_label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.73))
	box.add_child(event_title_label)
	event_body_label = _create_body_label()
	event_body_label.custom_minimum_size = Vector2(0, 120)
	box.add_child(event_body_label)
	event_choices_box = VBoxContainer.new()
	event_choices_box.add_theme_constant_override("separation", 6)
	box.add_child(event_choices_box)


func _build_starting_item_panel() -> void:
	starting_item_panel = PanelContainer.new()
	starting_item_panel.visible = false
	starting_item_panel.z_as_relative = false
	starting_item_panel.z_index = Z_ROOT_EVENT + 8
	starting_item_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	starting_item_panel.anchor_left = 0.5
	starting_item_panel.anchor_right = 0.5
	starting_item_panel.anchor_top = 0.5
	starting_item_panel.anchor_bottom = 0.5
	starting_item_panel.offset_left = -390
	starting_item_panel.offset_right = 390
	starting_item_panel.offset_top = -250
	starting_item_panel.offset_bottom = 250
	starting_item_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.062, 0.058, 0.98), Color(0.84, 0.74, 0.43), 8))
	add_child(starting_item_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	starting_item_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	box.add_child(header)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(38, 38)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var icon_texture = _icon_texture("actions/new_game")
	if icon_texture != null:
		icon.texture = icon_texture
	header.add_child(icon)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 2)
	header.add_child(title_box)

	var title := _small_title("난파 직전, 하나만 붙잡는다")
	title.add_theme_font_size_override("font_size", 21)
	title_box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "인트로를 건너뛴 빠른 시작용 선택이다. 선택한 물건과 생존 가이드를 들고 해변에서 시작한다."
	subtitle.clip_text = true
	subtitle.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", Color(0.76, 0.84, 0.76))
	title_box.add_child(subtitle)

	starting_item_choices_grid = GridContainer.new()
	starting_item_choices_grid.columns = 2
	starting_item_choices_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	starting_item_choices_grid.add_theme_constant_override("h_separation", 8)
	starting_item_choices_grid.add_theme_constant_override("v_separation", 8)
	box.add_child(starting_item_choices_grid)

	for choice in STARTING_ITEM_CHOICES:
		starting_item_choices_grid.add_child(_make_starting_item_choice_card(choice))

	starting_item_hint_label = _create_body_label()
	starting_item_hint_label.text = "생존 가이드는 항상 지급된다. 첫 흐름은 현재 위치 조사, 물과 먹을 것 확보, 해가 지기 전 쉴 곳 찾기다."
	starting_item_hint_label.add_theme_font_size_override("font_size", 12)
	box.add_child(_make_overlay_content_panel(starting_item_hint_label))


func _make_starting_item_choice_card(choice: Dictionary) -> Button:
	var item_id := String(choice.get("id", ""))
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(0, 112)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(Callable(self, "_on_starting_item_choice_pressed").bind(item_id))
	button.tooltip_text = "%s\n%s" % [String(choice.get("summary", "")), String(choice.get("detail", ""))]
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.060, 0.083, 0.074, 0.96), Color(0.26, 0.34, 0.28), 7))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.09, 0.13, 0.11, 0.98), Color(0.92, 0.78, 0.38), 7))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.88, 0.74, 0.36), Color(0.98, 0.88, 0.50), 7))

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	button.add_child(margin)

	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 10)
	margin.add_child(row)

	var icon_panel := PanelContainer.new()
	icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_panel.custom_minimum_size = Vector2(62, 62)
	icon_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.038, 0.036, 0.84), Color(0.48, 0.42, 0.24), 6))
	row.add_child(icon_panel)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(42, 42)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(choice.get("icon", "")))
	if texture != null:
		icon.texture = texture
	icon_panel.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.alignment = BoxContainer.ALIGNMENT_CENTER
	text_box.add_theme_constant_override("separation", 3)
	row.add_child(text_box)

	var title := Label.new()
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.text = String(choice.get("title", item_id))
	title.clip_text = true
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.98, 0.91, 0.66))
	text_box.add_child(title)

	var summary := Label.new()
	summary.mouse_filter = Control.MOUSE_FILTER_IGNORE
	summary.text = String(choice.get("summary", ""))
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.custom_minimum_size = Vector2(180, 34)
	summary.add_theme_font_size_override("font_size", 12)
	summary.add_theme_color_override("font_color", Color(0.86, 0.91, 0.84))
	text_box.add_child(summary)

	var detail := Label.new()
	detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail.text = String(choice.get("detail", ""))
	detail.clip_text = true
	detail.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	detail.add_theme_font_size_override("font_size", 10)
	detail.add_theme_color_override("font_color", Color(0.64, 0.74, 0.66))
	text_box.add_child(detail)
	_bind_button_reaction(button, "choice")
	return button


func _build_status_detail_panel() -> void:
	status_detail_panel = PanelContainer.new()
	status_detail_panel.visible = false
	status_detail_panel.z_as_relative = false
	status_detail_panel.z_index = Z_ROOT_EVENT
	status_detail_panel.anchor_left = 0.5
	status_detail_panel.anchor_right = 0.5
	status_detail_panel.anchor_top = 0.5
	status_detail_panel.anchor_bottom = 0.5
	status_detail_panel.offset_left = -260
	status_detail_panel.offset_right = 260
	status_detail_panel.offset_top = -180
	status_detail_panel.offset_bottom = 180
	status_detail_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.08, 0.08, 0.98), Color(0.82, 0.78, 0.50), 8))
	add_child(status_detail_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	status_detail_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)
	status_detail_title_label = _small_title("상태 상세")
	status_detail_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_detail_title_label.add_theme_font_size_override("font_size", 20)
	header.add_child(status_detail_title_label)
	header.add_child(_make_button("닫기", Callable(self, "_hide_status_detail_panel")))

	var detail_row := HBoxContainer.new()
	detail_row.add_theme_constant_override("separation", 10)
	detail_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(detail_row)

	status_detail_visual_panel = PanelContainer.new()
	status_detail_visual_panel.visible = false
	status_detail_visual_panel.custom_minimum_size = Vector2(150, 240)
	status_detail_visual_panel.clip_contents = true
	status_detail_visual_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.035, 0.034, 0.90), Color(0.62, 0.58, 0.36, 0.60), 6))
	detail_row.add_child(status_detail_visual_panel)

	status_detail_visual = TextureRect.new()
	status_detail_visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	status_detail_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	status_detail_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	status_detail_visual_panel.add_child(status_detail_visual)

	status_detail_body_label = _create_body_label()
	status_detail_body_label.add_theme_font_size_override("font_size", 14)
	status_detail_body_label.custom_minimum_size = Vector2(0, 240)
	detail_row.add_child(_make_overlay_content_panel(status_detail_body_label))


func _build_night_review_panel() -> void:
	night_review_panel = PanelContainer.new()
	night_review_panel.visible = false
	night_review_panel.z_as_relative = false
	night_review_panel.z_index = Z_ROOT_EVENT + 1
	night_review_panel.anchor_left = 0.5
	night_review_panel.anchor_right = 0.5
	night_review_panel.anchor_top = 0.5
	night_review_panel.anchor_bottom = 0.5
	night_review_panel.offset_left = -310
	night_review_panel.offset_right = 310
	night_review_panel.offset_top = -190
	night_review_panel.offset_bottom = 190
	night_review_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.060, 0.060, 0.985), Color(0.84, 0.74, 0.42), 8))
	add_child(night_review_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	night_review_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)
	night_review_title_label = _small_title("밤의 회고")
	night_review_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_review_title_label.add_theme_font_size_override("font_size", 20)
	header.add_child(night_review_title_label)
	header.add_child(_make_button("넘기기", Callable(self, "_hide_night_review_panel")))

	night_review_body_label = _create_body_label()
	night_review_body_label.add_theme_font_size_override("font_size", 14)
	night_review_body_label.custom_minimum_size = Vector2(0, 210)
	box.add_child(_make_overlay_content_panel(night_review_body_label))

	night_review_buttons_box = HBoxContainer.new()
	night_review_buttons_box.alignment = BoxContainer.ALIGNMENT_CENTER
	night_review_buttons_box.add_theme_constant_override("separation", 8)
	box.add_child(night_review_buttons_box)


func _build_time_adjust_panel() -> void:
	time_adjust_panel = PanelContainer.new()
	time_adjust_panel.visible = false
	time_adjust_panel.z_as_relative = false
	time_adjust_panel.z_index = Z_ROOT_MODAL + 2
	time_adjust_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	time_adjust_panel.anchor_left = 0.5
	time_adjust_panel.anchor_right = 0.5
	time_adjust_panel.anchor_top = 0.5
	time_adjust_panel.anchor_bottom = 0.5
	time_adjust_panel.offset_left = -240
	time_adjust_panel.offset_right = 240
	time_adjust_panel.offset_top = -140
	time_adjust_panel.offset_bottom = 140
	time_adjust_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.058, 0.054, 0.985), Color(0.78, 0.68, 0.38, 0.88), 8))
	add_child(time_adjust_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	time_adjust_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)

	time_adjust_title_label = _small_title("시간 조정")
	time_adjust_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	time_adjust_title_label.add_theme_font_size_override("font_size", 19)
	header.add_child(time_adjust_title_label)
	header.add_child(_make_compact_button("닫기", Callable(self, "_hide_time_adjust_panel"), "actions/rest", Vector2(62, 24)))

	time_adjust_value_label = Label.new()
	time_adjust_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_adjust_value_label.add_theme_font_size_override("font_size", 26)
	time_adjust_value_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.56))
	box.add_child(time_adjust_value_label)

	var slider_row := HBoxContainer.new()
	slider_row.add_theme_constant_override("separation", 8)
	box.add_child(slider_row)
	slider_row.add_child(_make_compact_button("-", Callable(self, "_step_time_adjustment").bind(-1), "", Vector2(34, 28)))
	time_adjust_slider = HSlider.new()
	time_adjust_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	time_adjust_slider.value_changed.connect(_on_time_adjust_slider_changed)
	slider_row.add_child(time_adjust_slider)
	slider_row.add_child(_make_compact_button("+", Callable(self, "_step_time_adjustment").bind(1), "", Vector2(34, 28)))

	time_adjust_detail_label = _create_body_label()
	time_adjust_detail_label.add_theme_font_size_override("font_size", 12)
	time_adjust_detail_label.custom_minimum_size = Vector2(0, 48)
	box.add_child(_make_overlay_content_panel(time_adjust_detail_label))

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 8)
	box.add_child(buttons)
	buttons.add_child(_make_button("취소", Callable(self, "_hide_time_adjust_panel"), "actions/rest"))
	time_adjust_confirm_button = _make_button("확인", Callable(self, "_confirm_time_adjustment"), "actions/rest")
	buttons.add_child(time_adjust_confirm_button)


func _connect_manager_signals() -> void:
	GameState.day_changed.connect(func(_day: int, _season: String, _weather: String) -> void:
		_refresh_all()
		call_deferred("_maybe_show_partner_suggestion", "day_start", "", {})
	)
	GameState.action_points_changed.connect(func(_points: int) -> void: _refresh_all())
	GameState.location_changed.connect(func(_region_id: String) -> void: _refresh_all())
	GameState.game_over.connect(_on_game_over)
	CharacterManager.status_changed.connect(_refresh_all)
	CharacterManager.partner_joined_changed.connect(func(_joined: bool) -> void: _refresh_all())
	InventoryManager.inventory_changed.connect(_refresh_all)
	WorldManager.regions_changed.connect(_refresh_all)
	BaseManager.base_changed.connect(_refresh_all)
	CraftingManager.recipes_changed.connect(_refresh_all)
	CraftingManager.recipe_unlocked.connect(_on_recipe_unlocked)
	EventManager.event_triggered.connect(_show_event)
	SaveManager.saved.connect(func(path: String) -> void: _append_log("저장 완료: %s" % path))
	SaveManager.loaded.connect(func(path: String) -> void: _append_log("불러오기 완료: %s" % path))
	SaveManager.save_failed.connect(func(reason: String) -> void: _append_log("저장/불러오기 실패: %s" % reason))


func _refresh_all() -> void:
	if top_status_label == null:
		return
	_check_zero_hp_game_over()
	if top_day_label != null:
		top_day_label.text = "DAY %d" % GameState.day
	if top_time_label != null:
		top_time_label.text = GameState.get_time_label()
	if top_weather_label != null:
		top_weather_label.text = ""
	if top_weather_icon != null:
		var weather_texture = _icon_texture(_weather_icon_id(GameState.weather))
		if weather_texture != null:
			top_weather_icon.texture = weather_texture
		top_weather_icon.tooltip_text = "날씨: %s" % GameState.weather
	_refresh_top_log_summary()
	_refresh_tile_grid()
	_refresh_time_flow_hud()
	_refresh_base_time_chip()
	_refresh_character_panels()
	_refresh_sensory_feedback()
	_refresh_base_view()
	_refresh_map_info_panel()
	if active_tool_menu != "":
		_refresh_tool_menu(active_tool_menu)
		_fit_tool_menu_panel()


func _refresh_sensory_feedback() -> void:
	if sensory_panel == null or CharacterManager.player_status == null:
		return
	if not sensory_panel_enabled:
		_sync_sensory_panel_visibility()
		return
	var cue := _current_sensory_cue()
	var text := String(cue.get("text", ""))
	var icon_id := String(cue.get("icon", "status/stable"))
	var color: Color = cue.get("color", Color(0.56, 0.64, 0.44))
	sensory_label.text = text
	sensory_label.add_theme_color_override("font_color", color.lightened(0.32))
	var texture = _icon_texture(icon_id)
	if texture != null:
		sensory_icon.texture = texture
	sensory_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.047, 0.90), color, 8))


func _show_sensory_toast(icon_id: String, text: String, color: Color) -> void:
	if sensory_panel == null or sensory_label == null:
		return
	if not sensory_panel_enabled:
		return
	sensory_label.text = text
	sensory_label.add_theme_color_override("font_color", color.lightened(0.32))
	var texture = _icon_texture(icon_id)
	if texture != null and sensory_icon != null:
		sensory_icon.texture = texture
	sensory_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.047, 0.94), color, 8))
	if sensory_tween != null and sensory_tween.is_valid():
		sensory_tween.kill()
	sensory_panel.modulate = Color(1, 1, 1, 1)
	sensory_tween = create_tween()
	sensory_tween.tween_interval(1.15)
	sensory_tween.tween_callback(func() -> void:
		_refresh_sensory_feedback()
	)
	if map_pressure_overlay != null:
		map_pressure_overlay.color = _sensory_pressure_color(CharacterManager.player_status)
	if text != last_sensory_text:
		last_sensory_text = text
		_pulse_sensory_panel(color)


func _toggle_sensory_panel() -> void:
	sensory_panel_enabled = not sensory_panel_enabled
	_sync_sensory_panel_visibility()


func _sync_sensory_panel_visibility() -> void:
	if sensory_panel != null:
		sensory_panel.visible = sensory_panel_enabled
	if sensory_toggle_button == null:
		return
	sensory_toggle_button.tooltip_text = "하단 안내 끄기" if sensory_panel_enabled else "하단 안내 켜기"
	sensory_toggle_button.modulate = Color(1, 1, 1, 1) if sensory_panel_enabled else Color(0.72, 0.76, 0.68, 0.82)


func _pulse_sensory_panel(color: Color) -> void:
	if sensory_panel == null:
		return
	if sensory_tween != null and sensory_tween.is_valid():
		sensory_tween.kill()
	sensory_panel.scale = Vector2(1.0, 1.0)
	sensory_panel.modulate = Color(1, 1, 1, 0.74)
	sensory_tween = create_tween()
	sensory_tween.tween_property(sensory_panel, "modulate", Color(1, 1, 1, 1), 0.18)
	sensory_tween.parallel().tween_property(sensory_panel, "scale", Vector2(1.018, 1.018), 0.18).from(Vector2(0.982, 0.982))
	sensory_tween.tween_property(sensory_panel, "scale", Vector2(1.0, 1.0), 0.22)


func _current_sensory_cue() -> Dictionary:
	var status = CharacterManager.player_status
	if status == null:
		return {"text": "섬의 기척이 멀게 느껴진다.", "icon": "status/stable", "color": Color(0.56, 0.64, 0.44)}
	if status.hp <= 20:
		return {"text": "시야 가장자리가 흐리고 몸이 말을 듣지 않는다.", "icon": "status/hp", "color": Color(0.90, 0.22, 0.18)}
	if status.has_state("wound"):
		return {"text": "상처가 움직일 때마다 뜨겁게 욱신거린다.", "icon": "status/hp", "color": Color(0.86, 0.28, 0.24)}
	if status.thirst <= 25:
		return {"text": "입안이 말라 붙고 물소리가 자꾸 떠오른다.", "icon": "status/thirst", "color": Color(0.36, 0.62, 0.86)}
	if status.hunger <= 25:
		return {"text": "속이 비어 손끝에 힘이 잘 들어가지 않는다.", "icon": "status/hunger", "color": Color(0.86, 0.54, 0.24)}
	if status.stamina <= 25:
		return {"text": "다리가 무겁고 숨이 짧게 끊긴다.", "icon": "status/stamina", "color": Color(0.86, 0.66, 0.28)}
	if status.has_state("fear"):
		return {"text": "숲 안쪽에서 난 작은 소리에도 어깨가 굳는다.", "icon": "status/fear", "color": Color(0.66, 0.42, 0.78)}
	if status.has_state("wet"):
		return {"text": "젖은 옷이 피부에 달라붙어 체온을 빼앗는다.", "icon": "status/thirst", "color": Color(0.44, 0.68, 0.82)}
	if status.hygiene <= 35:
		return {"text": "땀과 모래가 피부에 말라붙어 찝찝하다.", "icon": "status/fatigue", "color": Color(0.46, 0.60, 0.48)}
	if status.mood <= 35:
		return {"text": "말수는 줄고 파도 소리만 더 크게 들린다.", "icon": "status/mood", "color": Color(0.64, 0.46, 0.72)}
	var tile = WorldManager.get_current_tile()
	var terrain := ""
	if tile != null:
		terrain = String(tile.get("terrain", ""))
	var weather_text := String(GameState.weather)
	if weather_text.contains("비") or weather_text.contains("폭우") or weather_text.contains("폭풍"):
		return {"text": "축축한 바람이 불고 젖은 흙 냄새가 올라온다.", "icon": "status/thirst", "color": Color(0.44, 0.62, 0.74)}
	if _time_phase_id() == "night":
		return {"text": "어둠이 내려앉아 발밑 소리까지 크게 들린다.", "icon": "status/fear", "color": Color(0.48, 0.54, 0.72)}
	var flow_cue := _current_flow_cue()
	if not flow_cue.is_empty():
		return flow_cue
	return {"text": _terrain_sensory_text(terrain), "icon": _terrain_sensory_icon(terrain), "color": _terrain_sensory_color(terrain)}


func _current_flow_cue() -> Dictionary:
	var hint := _current_flow_hint_for_tile(WorldManager.current_tile_id)
	if hint == "":
		return {}
	return {"text": hint.replace("다음 흐름: ", ""), "icon": _current_flow_hint_icon(), "color": Color(0.76, 0.68, 0.38)}


func _current_flow_hint_for_tile(tile_id: String) -> String:
	var current_tile = WorldManager.get_current_tile()
	var selected_tile = WorldManager.get_tile(tile_id)
	if current_tile == null:
		return ""
	if bool(current_tile.get("is_base", false)) and not GameState.has_flag("entered_base"):
		return "다음 흐름: 동굴 안으로 들어가 오늘 밤 버틸 거점인지 확인하자."
	if not WorldManager.is_tile_investigated(WorldManager.current_tile_id):
		return "다음 흐름: 현재 위치를 조사하면 주변 안개가 걷히고 첫 이동지가 열린다."
	if not GameState.has_flag("partner_joined"):
		if GameState.current_region_id == "meadow":
			return "다음 흐름: 초원 쪽에서 사람의 흔적이 가까워진다."
		if _has_revealed_terrain("meadow"):
			return "다음 흐름: 초원 쪽을 살피면 혼자가 아닐지도 모른다."
	if _has_revealed_base_tile() and not GameState.has_flag("entered_base"):
		var route_hint := _flow_route_hint_to_base()
		if route_hint != "":
			return route_hint
		return "다음 흐름: 드러난 동굴 타일은 비를 피할 거점 후보처럼 보인다."
	if InventoryManager.get_weight_ratio() >= 0.85:
		return "다음 흐름: 짐이 무겁다. 현재 타일에 내려놓거나 거점에 정리하자."
	if InventoryManager.get_count("stone") >= 1 and InventoryManager.get_count("sharp_stone") <= 0 and InventoryManager.get_count("stone_knife") <= 0:
		return "다음 흐름: 돌 하나를 날카롭게 다듬으면 첫 도구 제작이 열린다."
	if InventoryManager.get_count("sharp_stone") >= 1 and InventoryManager.get_count("fiber") >= 1 and InventoryManager.get_count("wood") >= 1 and InventoryManager.get_count("stone_knife") <= 0:
		return "다음 흐름: 돌칼을 만들면 채집과 생활 준비가 조금 수월해진다."
	if selected_tile != null and tile_id != WorldManager.current_tile_id and WorldManager.is_tile_clickable(tile_id):
		return "다음 흐름: 이 타일로 이동해 새 자원과 위험을 확인할 수 있다."
	if selected_tile != null and WorldManager.is_tile_investigated(tile_id) and int(selected_tile.get("development", 0)) <= 0:
		return "다음 흐름: 조사한 타일은 개발로 조금씩 생활권에 가까워진다."
	return ""


func _current_flow_hint_icon() -> String:
	var current_tile = WorldManager.get_current_tile()
	if current_tile != null and bool(current_tile.get("is_base", false)) and not GameState.has_flag("entered_base"):
		return "actions/place"
	if not WorldManager.is_tile_investigated(WorldManager.current_tile_id):
		return "actions/investigate"
	if not GameState.has_flag("partner_joined") and _has_revealed_terrain("meadow"):
		return "actions/talk"
	if _has_revealed_base_tile() and not GameState.has_flag("entered_base"):
		return "actions/place"
	if InventoryManager.get_weight_ratio() >= 0.85:
		return "items/storage_box"
	if InventoryManager.get_count("stone") >= 1 and InventoryManager.get_count("sharp_stone") <= 0:
		return "actions/craft"
	return "actions/investigate"


func _recommended_flow_action_for_tile(tile_id: String) -> String:
	var current_tile = WorldManager.get_current_tile()
	var selected_tile = WorldManager.get_tile(tile_id)
	if current_tile == null or selected_tile == null:
		return ""
	var base_next_step := _base_next_step_tile_id()
	if tile_id != WorldManager.current_tile_id:
		if base_next_step != "":
			if tile_id == base_next_step and WorldManager.is_tile_clickable(tile_id):
				return "move"
			return ""
		if WorldManager.is_tile_clickable(tile_id):
			return "move"
		return ""
	var allowed := Array(current_tile.get("allowed_actions", []))
	if bool(current_tile.get("is_base", false)) and not GameState.has_flag("entered_base"):
		return "enter_base"
	if not WorldManager.is_tile_investigated(WorldManager.current_tile_id):
		return "investigate"
	if base_next_step != "":
		return ""
	if CharacterManager.player_status != null:
		if CharacterManager.player_status.hygiene <= 35 and allowed.has("wash"):
			return "wash"
		if CharacterManager.player_status.stamina <= 30 and allowed.has("rest"):
			return "rest"
	if _tile_has_gatherable_resource(current_tile) and allowed.has("gather"):
		return "gather"
	if _tile_has_fishable_resource(current_tile) and allowed.has("fish"):
		return "fish"
	if int(current_tile.get("development", 0)) <= 0 and allowed.has("develop") and InventoryManager.has_items(WorldManager.get_tile_development_requirements(tile_id)):
		return "develop"
	return ""


func _tile_has_gatherable_resource(tile: Dictionary) -> bool:
	var resources: Dictionary = tile.get("resources", {})
	for item_id in resources.keys():
		if String(item_id) == "fish":
			continue
		if int(resources[item_id]) > 0:
			return true
	return false


func _tile_has_fishable_resource(tile: Dictionary) -> bool:
	var resources: Dictionary = tile.get("resources", {})
	return int(resources.get("fish", 0)) > 0


func _is_recommended_flow_action(action_id: String, args: Dictionary) -> bool:
	if selected_tile_id == "":
		return false
	if action_id == "move" and String(args.get("target_tile_id", selected_tile_id)) != selected_tile_id:
		return false
	return _recommended_flow_action_for_tile(selected_tile_id) == action_id


func _flow_route_hint_to_base() -> String:
	var base_tile_id := _revealed_base_tile_id()
	if base_tile_id == "" or base_tile_id == WorldManager.current_tile_id:
		return ""
	if WorldManager.is_tile_clickable(base_tile_id):
		return "다음 흐름: 드러난 동굴 입구로 이동해 비를 피할 수 있는지 확인하자."
	var path := _revealed_path_to_tile(base_tile_id)
	if path.size() > 1:
		var next_tile = WorldManager.get_tile(String(path[1]))
		if next_tile != null:
			return "다음 흐름: 바위 때문에 곧장 갈 수 없다. %s 쪽으로 돌아가 동굴 입구를 찾자." % String(next_tile.get("display_name", "옆 타일"))
	return "다음 흐름: 동굴은 보이지만 길이 막혀 있다. 주변을 더 조사해 우회로를 찾자."


func _base_next_step_tile_id() -> String:
	if GameState.has_flag("entered_base"):
		return ""
	var base_tile_id := _revealed_base_tile_id()
	if base_tile_id == "" or base_tile_id == WorldManager.current_tile_id:
		return ""
	if WorldManager.is_tile_clickable(base_tile_id):
		return base_tile_id
	var path := _revealed_path_to_tile(base_tile_id)
	if path.size() > 1:
		return String(path[1])
	return ""


func _revealed_base_tile_id() -> String:
	for row in WorldManager.get_tile_rows():
		for tile in row:
			if tile == null:
				continue
			var tile_id := String(tile.get("id", ""))
			if bool(tile.get("is_base", false)) and WorldManager.is_tile_revealed(tile_id):
				return tile_id
	return ""


func _revealed_path_to_tile(target_tile_id: String) -> Array[String]:
	var start_id := WorldManager.current_tile_id
	var queue: Array[String] = [start_id]
	var came_from: Dictionary = {start_id: ""}
	var index := 0
	while index < queue.size():
		var current_id := queue[index]
		index += 1
		if current_id == target_tile_id:
			break
		for next_id in WorldManager.get_reachable_adjacent_tile_ids(current_id):
			if came_from.has(next_id):
				continue
			if not WorldManager.is_tile_revealed(next_id):
				continue
			came_from[next_id] = current_id
			queue.append(next_id)
	if not came_from.has(target_tile_id):
		return []
	var path: Array[String] = []
	var cursor := target_tile_id
	while cursor != "":
		path.push_front(cursor)
		cursor = String(came_from.get(cursor, ""))
	return path


func _apply_recommended_context_style(button: Button, hint: String) -> void:
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.105, 0.090, 0.045, 0.96), Color(0.98, 0.78, 0.30, 0.96), 16))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.14, 0.12, 0.06, 0.98), Color(1.0, 0.88, 0.42, 1.0), 16))
	var title_label = button.get_node_or_null("Content/TextBox/Title")
	if title_label != null:
		title_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.45))
	var clean_hint := hint.replace("다음 흐름: ", "")
	if clean_hint != "":
		button.tooltip_text = "추천 흐름\n%s\n%s" % [clean_hint, button.tooltip_text]
	else:
		button.tooltip_text = "추천 흐름\n%s" % button.tooltip_text


func _has_revealed_terrain(terrain_id: String) -> bool:
	for row in WorldManager.get_tile_rows():
		for tile in row:
			if tile == null:
				continue
			var tile_id := String(tile.get("id", ""))
			if String(tile.get("terrain", "")) == terrain_id and WorldManager.is_tile_revealed(tile_id):
				return true
	return false


func _has_revealed_base_tile() -> bool:
	for row in WorldManager.get_tile_rows():
		for tile in row:
			if tile == null:
				continue
			var tile_id := String(tile.get("id", ""))
			if bool(tile.get("is_base", false)) and WorldManager.is_tile_revealed(tile_id):
				return true
	return false


func _sensory_pressure_color(status) -> Color:
	if status == null:
		return Color(0, 0, 0, 0)
	if status.hp <= 20:
		return Color(0.55, 0.02, 0.02, 0.13)
	if status.thirst <= 20:
		return Color(0.08, 0.20, 0.42, 0.11)
	if status.hunger <= 20:
		return Color(0.55, 0.28, 0.02, 0.10)
	if status.stamina <= 20:
		return Color(0.32, 0.22, 0.08, 0.08)
	if status.mood <= 25 or status.has_state("fear"):
		return Color(0.22, 0.10, 0.34, 0.07)
	return Color(0, 0, 0, 0)


func _terrain_sensory_text(terrain: String) -> String:
	match terrain:
		"beach":
			return "모래가 발목을 붙잡고 짠 냄새가 코끝에 남는다."
		"meadow":
			return "풀잎이 바짓단을 스치고 작은 벌레 소리가 번진다."
		"forest":
			return "젖은 나무 냄새와 마른 잎 부스러기가 발밑에 깔린다."
		"river":
			return "흐르는 물소리가 가까워지고 목이 조금 풀리는 듯하다."
		"marsh":
			return "진흙이 질척이고 발을 뗄 때마다 물기가 따라온다."
		"cave":
			return "찬 공기가 안쪽에서 밀려와 피부가 서늘해진다."
		"hill":
			return "돌부리가 발바닥을 찌르고 숨이 조금 가빠진다."
		"ruins":
			return "오래된 돌과 먼지 냄새가 낮게 가라앉아 있다."
	return "섬의 소리와 바람이 잠깐 잦아든다."


func _terrain_sensory_icon(terrain: String) -> String:
	match terrain:
		"beach", "river", "marsh":
			return "status/thirst"
		"forest", "meadow":
			return "actions/gather"
		"cave", "hill", "ruins":
			return "status/fear"
	return "status/stable"


func _terrain_sensory_color(terrain: String) -> Color:
	match terrain:
		"beach":
			return Color(0.74, 0.62, 0.36)
		"meadow":
			return Color(0.48, 0.68, 0.36)
		"forest":
			return Color(0.34, 0.54, 0.30)
		"river":
			return Color(0.36, 0.62, 0.78)
		"marsh":
			return Color(0.42, 0.52, 0.34)
		"cave":
			return Color(0.50, 0.54, 0.58)
		"hill":
			return Color(0.58, 0.50, 0.38)
		"ruins":
			return Color(0.62, 0.56, 0.46)
	return Color(0.56, 0.64, 0.44)


func _fit_all_overlays() -> void:
	_fit_tool_menu_panel()
	_fit_center_overlay(action_result_panel, ACTION_RESULT_DESIRED_SIZE)
	_fit_center_overlay(status_detail_panel, STATUS_DETAIL_DESIRED_SIZE)
	_fit_center_overlay(event_panel, EVENT_DESIRED_SIZE)
	_fit_center_overlay(starting_item_panel, STARTING_ITEM_DESIRED_SIZE)
	_fit_center_overlay(tool_craft_panel, TOOL_CRAFT_MINIGAME_DESIRED_SIZE)
	_fit_item_toast_panel()
	_fit_action_delta_panel()
	_fit_center_overlay(item_action_panel, ITEM_ACTION_DESIRED_SIZE)
	if map_context_panel != null and map_context_panel.visible and selected_tile_id != "":
		_position_map_context_panel(selected_tile_id)


func _fit_tool_menu_panel() -> void:
	if tool_menu_panel == null or map_stack == null:
		return
	var bounds := map_stack.size
	if bounds.x <= 0.0 or bounds.y <= 0.0:
		return
	var width := minf(TOOL_MENU_DESIRED_SIZE.x, maxf(80.0, bounds.x - UI_SAFE_PADDING * 2.0))
	var height := minf(TOOL_MENU_DESIRED_SIZE.y, maxf(80.0, bounds.y - UI_SAFE_PADDING * 2.0))
	tool_menu_panel.custom_minimum_size = Vector2(width, height)
	tool_menu_panel.size = Vector2(width, height)
	var pos := Vector2(10.0, 72.0)
	if tool_menu_panel.position.length_squared() > 0.0:
		pos = tool_menu_panel.position
	var max_x := maxf(UI_SAFE_PADDING, bounds.x - width - UI_SAFE_PADDING)
	var max_y := maxf(UI_SAFE_PADDING, bounds.y - height - UI_SAFE_PADDING)
	tool_menu_panel.position = Vector2(
		clampf(pos.x, UI_SAFE_PADDING, max_x),
		clampf(pos.y, UI_SAFE_PADDING, max_y)
	)


func _fit_center_overlay(panel: Control, desired_size: Vector2) -> void:
	if panel == null:
		return
	var bounds := size
	if bounds.x <= 0.0 or bounds.y <= 0.0:
		return
	var width := minf(desired_size.x, maxf(80.0, bounds.x - UI_SAFE_PADDING * 2.0))
	var height := minf(desired_size.y, maxf(80.0, bounds.y - UI_SAFE_PADDING * 2.0))
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -width * 0.5
	panel.offset_right = width * 0.5
	panel.offset_top = -height * 0.5
	panel.offset_bottom = height * 0.5
	panel.custom_minimum_size = Vector2(width, height)


func _fit_item_toast_panel() -> void:
	if item_toast_panel == null:
		return
	var bounds := size
	if bounds.x <= 0.0:
		return
	var width := minf(ITEM_TOAST_DESIRED_SIZE.x, maxf(80.0, bounds.x - UI_SAFE_PADDING * 2.0))
	item_toast_panel.anchor_left = 0.5
	item_toast_panel.anchor_right = 0.5
	item_toast_panel.anchor_top = 0.0
	item_toast_panel.anchor_bottom = 0.0
	item_toast_panel.offset_left = -width * 0.5
	item_toast_panel.offset_right = width * 0.5
	item_toast_panel.offset_top = UI_SAFE_PADDING
	item_toast_panel.offset_bottom = UI_SAFE_PADDING + ITEM_TOAST_DESIRED_SIZE.y


func _fit_action_delta_panel() -> void:
	if action_delta_panel == null:
		return
	var bounds := size
	if bounds.x <= 0.0:
		return
	var width := minf(720.0, maxf(220.0, bounds.x - UI_SAFE_PADDING * 2.0))
	action_delta_panel.anchor_left = 0.5
	action_delta_panel.anchor_right = 0.5
	action_delta_panel.anchor_top = 1.0
	action_delta_panel.anchor_bottom = 1.0
	action_delta_panel.offset_left = -width * 0.5
	action_delta_panel.offset_right = width * 0.5
	action_delta_panel.offset_top = -92.0
	action_delta_panel.offset_bottom = -44.0
	action_delta_panel.custom_minimum_size = Vector2(width, 48.0)


func _refresh_tile_grid() -> void:
	_clear_children(map_grid)
	var map_size := _hex_map_size()
	map_grid.size = map_size
	map_grid.custom_minimum_size = map_size
	map_grid.scale = Vector2(map_zoom, map_zoom)
	_add_ocean_background_to_map_grid(map_size)
	for row in WorldManager.get_tile_rows():
		for tile in row:
			if tile == null or not bool(tile.get("playable", false)):
				continue
			var button := _make_tile_button(tile)
			button.position = _hex_tile_position(int(tile.get("x", 0)), int(tile.get("y", 0)))
			button.z_index = int(tile.get("y", 0))
			map_grid.add_child(button)
	for row in WorldManager.get_tile_rows():
		for tile in row:
			if tile == null or not bool(tile.get("playable", false)):
				continue
			var tile_id := String(tile.get("id", ""))
			if WorldManager.is_tile_revealed(tile_id):
				revealed_tile_memory[tile_id] = true
	_add_map_blocked_edge_walls()
	call_deferred("_center_map_on_current_tile")


func _add_ocean_background_to_map_grid(map_size: Vector2) -> void:
	if map_grid == null:
		return
	map_ocean_background = TextureRect.new()
	map_ocean_background.name = "MapTileBackplate"
	map_ocean_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_ocean_background.z_index = -2
	map_ocean_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_ocean_background.stretch_mode = TextureRect.STRETCH_SCALE
	var backplate_margin := Vector2(HEX_TILE_WIDTH * 0.20, HEX_TILE_HEIGHT * 0.20)
	map_ocean_background.position = -backplate_margin
	map_ocean_background.size = map_size + backplate_margin * 2.0
	map_ocean_background.custom_minimum_size = map_ocean_background.size
	var backplate_texture = _texture_from_path("res://assets/tiles/map_tile_backplate.svg")
	if backplate_texture != null:
		map_ocean_background.texture = backplate_texture
	map_grid.add_child(map_ocean_background)


func _center_map_on_current_tile() -> void:
	if map_camera == null or map_grid == null:
		return
	var camera_size := map_camera.size
	if camera_size.x <= 0 or camera_size.y <= 0:
		if map_center_retry_count < 12:
			map_center_retry_count += 1
			call_deferred("_center_map_on_current_tile")
		return
	map_center_retry_count = 0
	var map_size := _hex_map_size()
	map_grid.size = map_size
	map_grid.custom_minimum_size = map_size
	map_grid.scale = Vector2(map_zoom, map_zoom)
	if WorldManager.current_tile_id != last_map_center_tile_id:
		map_pan_offset = Vector2.ZERO
		last_map_center_tile_id = WorldManager.current_tile_id
	var base_position := _map_center_base_position(camera_size)
	_apply_map_grid_position(base_position + map_pan_offset, base_position)


func _map_center_base_position(camera_size: Vector2) -> Vector2:
	var tile = WorldManager.get_current_tile()
	if tile == null:
		return _clamp_map_grid_position((camera_size - _hex_map_visual_size()) * 0.5, camera_size)
	var tile_center := _hex_tile_center(int(tile.get("x", 0)), int(tile.get("y", 0))) * map_zoom
	var desired: Vector2 = camera_size * 0.5 - tile_center
	return _clamp_map_grid_position(desired, camera_size)


func _apply_map_grid_position(raw_position: Vector2, base_position: Vector2) -> void:
	if map_camera == null or map_grid == null:
		return
	var clamped := _clamp_map_grid_position(raw_position, map_camera.size)
	map_grid.position = clamped
	map_pan_offset = clamped - base_position


func _clamp_map_grid_position(raw_position: Vector2, camera_size: Vector2) -> Vector2:
	var map_size := _hex_map_visual_size()
	var result := raw_position
	if map_size.x <= camera_size.x:
		var centered_x := (camera_size.x - map_size.x) * 0.5
		result.x = clampf(raw_position.x, centered_x - MAP_PAN_OVERSCAN, centered_x + MAP_PAN_OVERSCAN)
	else:
		result.x = clampf(raw_position.x, camera_size.x - map_size.x - MAP_PAN_OVERSCAN, MAP_PAN_OVERSCAN)
	if map_size.y <= camera_size.y:
		var centered_y := (camera_size.y - map_size.y) * 0.5
		result.y = clampf(raw_position.y, centered_y - MAP_PAN_OVERSCAN, centered_y + MAP_PAN_OVERSCAN)
	else:
		result.y = clampf(raw_position.y, camera_size.y - map_size.y - MAP_PAN_OVERSCAN, MAP_PAN_OVERSCAN)
	return result


func _pan_map_by_screen_delta(delta: Vector2) -> void:
	if map_camera == null or map_grid == null:
		return
	var camera_size := map_camera.size
	if camera_size.x <= 0 or camera_size.y <= 0:
		return
	var base_position := _map_center_base_position(camera_size)
	_apply_map_grid_position(map_grid.position + delta, base_position)


func _zoom_map_at_screen_point(screen_point: Vector2, direction: int) -> void:
	if map_camera == null or map_grid == null:
		return
	var camera_size := map_camera.size
	if camera_size.x <= 0 or camera_size.y <= 0:
		return
	var old_zoom := map_zoom
	var zoom_factor := 1.0 + MAP_ZOOM_STEP * float(direction)
	var new_zoom := clampf(old_zoom * zoom_factor, MAP_MIN_ZOOM, MAP_MAX_ZOOM)
	if is_equal_approx(old_zoom, new_zoom):
		return
	var camera_point: Vector2 = map_camera.get_global_transform().affine_inverse() * screen_point
	var map_local_before := (camera_point - map_grid.position) / old_zoom
	map_zoom = new_zoom
	map_grid.scale = Vector2(map_zoom, map_zoom)
	var desired_position := camera_point - map_local_before * map_zoom
	var base_position := _map_center_base_position(camera_size)
	_apply_map_grid_position(desired_position, base_position)
	if map_context_panel != null and map_context_panel.visible and selected_tile_id != "":
		_position_map_context_panel(selected_tile_id)


func _hex_map_size() -> Vector2:
	return Vector2(
		HEX_TILE_WIDTH + HEX_COLUMN_STEP * (float(WorldManager.TILE_MAP_SIZE - 1) + 0.5),
		HEX_TILE_HEIGHT + HEX_ROW_STEP * float(WorldManager.TILE_MAP_SIZE - 1)
	)


func _hex_map_visual_size() -> Vector2:
	return _hex_map_size() * map_zoom


func _hex_tile_position(x: int, y: int) -> Vector2:
	var row_offset := 0.0
	if y % 2 == 1:
		row_offset = HEX_COLUMN_STEP * 0.5
	return Vector2(float(x) * HEX_COLUMN_STEP + row_offset, float(y) * HEX_ROW_STEP)


func _hex_tile_center(x: int, y: int) -> Vector2:
	return _hex_tile_position(x, y) + Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT) * 0.5


func _set_bottom_tab(tab_id: String) -> void:
	if tab_id == "base" and not _bottom_base_tab_available(_current_map_info_tile_id()):
		tab_id = "info"
	var changed := active_bottom_tab != tab_id
	active_bottom_tab = tab_id
	_refresh_map_info_panel()
	if changed:
		_play_bottom_tab_switch_feedback()


func _current_map_info_tile_id() -> String:
	return selected_tile_id if selected_tile_id != "" else WorldManager.current_tile_id


func _bottom_base_tab_available(tile_id: String) -> bool:
	var tile = WorldManager.get_tile(tile_id)
	return tile != null and int(tile.get("development", 0)) >= 100


func _refresh_bottom_tab_buttons() -> void:
	var target_id := _current_map_info_tile_id()
	var base_available := _bottom_base_tab_available(target_id)
	if active_bottom_tab == "base" and not base_available:
		active_bottom_tab = "info"
	if bottom_info_tab_button != null:
		var info_active := active_bottom_tab == "info"
		bottom_info_tab_button.button_pressed = info_active
		_apply_bottom_tab_button_style(bottom_info_tab_button, info_active)
	if bottom_cards_tab_button != null:
		var cards_active := active_bottom_tab == "cards"
		bottom_cards_tab_button.button_pressed = cards_active
		_apply_bottom_tab_button_style(bottom_cards_tab_button, cards_active)
	if bottom_base_tab_button != null:
		var base_active := active_bottom_tab == "base"
		bottom_base_tab_button.visible = base_available
		bottom_base_tab_button.button_pressed = base_active
		_apply_bottom_tab_button_style(bottom_base_tab_button, base_active)


func _apply_bottom_tab_button_style(button: Button, active: bool) -> void:
	if button == null:
		return
	button.add_theme_stylebox_override("normal", _make_panel_style(
		Color(0.095, 0.115, 0.085, 0.98) if active else Color(0.045, 0.060, 0.055, 0.96),
		Color(0.92, 0.76, 0.34, 0.96) if active else Color(0.28, 0.34, 0.30, 0.78),
		5
	))
	button.add_theme_stylebox_override("hover", _make_panel_style(
		Color(0.120, 0.145, 0.095, 0.98) if active else Color(0.070, 0.090, 0.074, 0.98),
		Color(1.00, 0.86, 0.42, 1.00),
		5
	))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.86, 0.72, 0.34, 0.98), Color(1.0, 0.90, 0.52, 1.0), 5))
	button.add_theme_color_override("font_color", Color(1.0, 0.92, 0.58) if active else Color(0.84, 0.90, 0.84))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.74))
	button.add_theme_color_override("font_pressed_color", Color(0.08, 0.10, 0.08))
	_set_button_reaction_mode(button, "tab")


func _play_bottom_tab_switch_feedback() -> void:
	if map_info_panel == null:
		return
	var existing = map_info_panel.get_meta("tab_switch_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	var tween := create_tween()
	map_info_panel.set_meta("tab_switch_tween", tween)
	tween.tween_property(map_info_panel, "modulate", Color(1, 1, 1, 1), 0.16).from(Color(1, 1, 1, 0.84)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _refresh_time_flow_hud() -> void:
	_apply_time_flow_visuals(true)
	_refresh_map_atmosphere_visibility()


func _refresh_base_time_chip() -> void:
	if base_time_label == null:
		return
	base_time_label.text = "DAY %d · %s %s · %s" % [
		GameState.day,
		GameState.get_day_phase(),
		GameState.get_time_label(),
		GameState.weather
	]
	base_time_label.tooltip_text = "일출 %s / 일몰 %s / 다음 날씨 %s" % [
		_minutes_label(GameState.get_sunrise_minutes()),
		_minutes_label(GameState.get_sunset_minutes()),
		GameState.next_weather
	]


func _on_time_compact_mouse_entered() -> void:
	time_hud_hovered = true
	_set_time_flow_detail_visible(true, true, false)


func _on_time_compact_mouse_exited() -> void:
	time_hud_hovered = false
	get_tree().create_timer(0.35).timeout.connect(_hide_time_flow_detail_if_not_hovered)


func _on_time_flow_panel_mouse_entered() -> void:
	time_hud_hovered = true


func _on_time_flow_panel_mouse_exited() -> void:
	time_hud_hovered = false
	get_tree().create_timer(0.25).timeout.connect(_hide_time_flow_detail_if_not_hovered)


func _hide_time_flow_detail_if_not_hovered() -> void:
	if not time_hud_hovered:
		_set_time_flow_detail_visible(false, true, false)


func _set_time_flow_detail_visible(show_detail: bool, animated: bool, auto_hide: bool = false) -> void:
	if time_flow_panel == null:
		return
	if time_hud_tween != null and time_hud_tween.is_valid():
		time_hud_tween.kill()
	var target_top := TIME_FLOW_SHOWN_TOP if show_detail else TIME_FLOW_HIDDEN_TOP
	var target_bottom := TIME_FLOW_SHOWN_BOTTOM if show_detail else TIME_FLOW_HIDDEN_BOTTOM
	var target_alpha := 1.0 if show_detail else 0.0
	var compact_top := TIME_COMPACT_HIDDEN_TOP if show_detail else TIME_COMPACT_SHOWN_TOP
	var compact_bottom := TIME_COMPACT_HIDDEN_BOTTOM if show_detail else TIME_COMPACT_SHOWN_BOTTOM
	var compact_alpha := 0.0 if show_detail else 1.0
	time_flow_panel.mouse_filter = Control.MOUSE_FILTER_STOP if show_detail else Control.MOUSE_FILTER_IGNORE
	if time_compact_panel != null:
		time_compact_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE if show_detail else Control.MOUSE_FILTER_STOP
	if not animated:
		time_flow_panel.offset_top = target_top
		time_flow_panel.offset_bottom = target_bottom
		time_flow_panel.modulate = Color(1, 1, 1, target_alpha)
		if time_compact_panel != null:
			time_compact_panel.offset_top = compact_top
			time_compact_panel.offset_bottom = compact_bottom
			time_compact_panel.modulate = Color(1, 1, 1, compact_alpha)
		return
	time_hud_tween = create_tween()
	time_hud_tween.tween_property(time_flow_panel, "offset_top", target_top, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT if show_detail else Tween.EASE_IN)
	time_hud_tween.parallel().tween_property(time_flow_panel, "offset_bottom", target_bottom, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT if show_detail else Tween.EASE_IN)
	time_hud_tween.parallel().tween_property(time_flow_panel, "modulate:a", target_alpha, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if time_compact_panel != null:
		time_hud_tween.parallel().tween_property(time_compact_panel, "offset_top", compact_top, 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN if show_detail else Tween.EASE_OUT)
		time_hud_tween.parallel().tween_property(time_compact_panel, "offset_bottom", compact_bottom, 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN if show_detail else Tween.EASE_OUT)
		time_hud_tween.parallel().tween_property(time_compact_panel, "modulate:a", compact_alpha, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if show_detail and auto_hide:
		time_hud_tween.tween_interval(1.35)
		time_hud_tween.tween_callback(Callable(self, "_hide_time_flow_detail_if_not_hovered"))


func _refresh_map_info_panel(tile_id: String = "") -> void:
	if map_info_title_label == null or map_info_body_label == null or map_info_chips_box == null:
		return
	_refresh_bottom_tab_buttons()
	var target_id := tile_id
	if target_id == "":
		target_id = selected_tile_id if selected_tile_id != "" else WorldManager.current_tile_id
	var tile = WorldManager.get_tile(target_id)
	if tile == null:
		map_info_title_label.text = "정보"
		map_info_body_label.text = "선택된 타일 정보가 없다."
		_clear_children(map_info_chips_box)
		if map_cards_box != null:
			_clear_children(map_cards_box)
		if map_base_box != null:
			_clear_children(map_base_box)
		if map_cards_scroll != null:
			map_cards_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		if map_base_scroll != null:
			map_base_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		_sync_bottom_tab_visibility()
		return
	var tile_name := String(tile.get("display_name", "타일"))
	map_info_title_label.text = "%s 필드 물품" % tile_name if active_bottom_tab == "cards" else tile_name
	if active_bottom_tab == "base":
		map_info_title_label.text = "%s 거점" % tile_name
	var image_path := String(tile.get("image_path", ""))
	if map_info_tile_preview != null:
		map_info_tile_preview.texture = _texture_from_path(image_path)
	_clear_children(map_info_chips_box)
	map_info_chips_box.add_child(_make_info_chip("status/fear", "위험", _danger_band(int(tile.get("danger", 0)))))
	map_info_chips_box.add_child(_make_info_chip("actions/investigate", "조사", _progress_band(int(tile.get("investigation", 0)), true)))
	if int(tile.get("development", 0)) > 0:
		map_info_chips_box.add_child(_make_info_chip("actions/develop", "개발", _progress_band(int(tile.get("development", 0)), false)))
	map_info_chips_box.add_child(_make_info_chip("actions/gather", "자원", _resource_band_with_field(target_id)))
	map_info_chips_box.add_child(_make_info_chip("actions/move", "접근", _access_band(target_id)))
	var body_lines: Array[String] = [
		String(tile.get("description", "")),
		_terrain_sensory_text(String(tile.get("terrain", "")))
	]
	var flow_hint := _current_flow_hint_for_tile(target_id)
	if flow_hint != "":
		body_lines.append(flow_hint)
	var tool_hint := _tile_equipment_hint(target_id)
	if tool_hint != "":
		body_lines.append(tool_hint)
	var object_summary := WorldManager.get_tile_resource_object_summary(target_id)
	if object_summary != "":
		body_lines.append("발견한 채취 대상: %s" % object_summary)
	var hunting_summary := WorldManager.get_tile_hunting_summary(target_id)
	if hunting_summary != "":
		body_lines.append("수렵: %s" % hunting_summary)
	var memory_summary := _tile_memory_summary(target_id)
	if memory_summary != "":
		body_lines.append("흔적: %s" % memory_summary)
	if WorldManager.has_tile_field_items(target_id):
		body_lines.append("놓아둔 물건: %s" % _tile_field_item_summary(target_id))
	map_info_body_label.text = _join_lines(body_lines, "\n")
	_refresh_bottom_card_tab(target_id)
	_refresh_bottom_base_tab(target_id)
	_sync_bottom_tab_visibility()


func _sync_bottom_tab_visibility() -> void:
	var info_visible := active_bottom_tab == "info"
	if map_info_chips_box != null:
		map_info_chips_box.visible = info_visible
	if map_info_body_label != null:
		map_info_body_label.visible = info_visible
	if map_cards_scroll != null:
		map_cards_scroll.visible = active_bottom_tab == "cards"
	if map_base_scroll != null:
		map_base_scroll.visible = active_bottom_tab == "base"


func _refresh_bottom_card_tab(tile_id: String) -> void:
	if map_cards_box == null:
		return
	_clear_children(map_cards_box)
	var sections := HBoxContainer.new()
	sections.name = "BottomFieldSections"
	sections.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sections.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sections.add_theme_constant_override("separation", 8)
	map_cards_box.add_child(sections)
	var field_grid := _make_bottom_field_grid()
	field_grid.name = "BottomFieldItemsGrid"
	map_cards_grid = field_grid
	sections.add_child(_make_bottom_field_section(
		"필드 물품",
		_make_item_drop_zone(
			"field",
			tile_id,
			["inventory"],
			field_grid,
			"소지품 → 이 타일",
			tile_id == WorldManager.current_tile_id
		)
	))
	var field_items := WorldManager.get_tile_field_items(tile_id)
	var field_keys := field_items.keys()
	field_keys.sort()
	var visible_field_cards := 0
	for raw_item_id in field_keys:
		var field_item_id := String(raw_item_id)
		var field_amount := int(field_items[raw_item_id])
		if field_amount > 0:
			field_grid.add_child(_make_field_item_card(tile_id, field_item_id, field_amount))
			visible_field_cards += 1
	_fill_bottom_empty_slots(field_grid, visible_field_cards, "비어 있음")

	var resource_grid := _make_bottom_field_grid()
	resource_grid.name = "BottomResourcesGrid"
	sections.add_child(_make_bottom_field_section("현장 자원", resource_grid))
	var tile = WorldManager.get_tile(tile_id)
	var visible_resource_cards := 0
	if tile != null and WorldManager.is_tile_investigated(tile_id):
		var resources: Dictionary = tile.get("resources", {})
		var keys := resources.keys()
		keys.sort()
		for raw_item_id in keys:
			var item_id := String(raw_item_id)
			var amount := int(resources[item_id])
			if amount > 0:
				resource_grid.add_child(_make_resource_card(item_id, amount))
				visible_resource_cards += 1
	var resource_empty_text := "미확인" if tile == null or not WorldManager.is_tile_investigated(tile_id) else "없음"
	_fill_bottom_empty_slots(resource_grid, visible_resource_cards, resource_empty_text)
	if map_cards_scroll != null:
		var visible_card_tiles := visible_field_cards + visible_resource_cards
		var max_visible_tiles := BOTTOM_FIELD_SLOT_COUNT * 2
		map_cards_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if visible_card_tiles > max_visible_tiles else ScrollContainer.SCROLL_MODE_DISABLED

	var note := _create_body_label()
	note.text = "필드 물품은 좌우 소지품 영역으로 드래그해 나눠 들 수 있다."
	note.add_theme_font_size_override("font_size", 10)
	note.add_theme_color_override("font_color", Color(0.72, 0.80, 0.75))
	note.max_lines_visible = 1
	map_cards_box.add_child(note)


func _refresh_bottom_base_tab(tile_id: String) -> void:
	if map_base_box == null:
		return
	_clear_children(map_base_box)
	if not _bottom_base_tab_available(tile_id):
		return
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return
	var panel_box := VBoxContainer.new()
	panel_box.add_theme_constant_override("separation", 5)
	var is_base_tile := bool(tile.get("is_base", false))
	var title := _small_title("동굴 거점" if is_base_tile else "거점 없음")
	title.add_theme_font_size_override("font_size", 13)
	panel_box.add_child(title)
	var body := _create_body_label()
	body.add_theme_font_size_override("font_size", 11)
	body.max_lines_visible = 3
	if is_base_tile:
		body.text = BaseManager.get_base_life_summary()
	else:
		body.text = "개발은 완료됐지만 이 타일에는 사용할 수 있는 거점 시설이 없습니다.\n현재 거점은 동굴 타일에서만 관리됩니다."
	panel_box.add_child(body)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	if is_base_tile:
		for cue in BaseManager.get_base_life_cues().slice(0, 3):
			row.add_child(_make_info_chip(String(cue.get("icon", "actions/place")), String(cue.get("label", "")), String(cue.get("value", ""))))
		var open_button := _make_compact_button("거점 보기", Callable(self, "_show_base_view"), "actions/place", Vector2(86, 24))
		open_button.disabled = tile_id != WorldManager.current_tile_id
		open_button.tooltip_text = "현재 위치가 동굴 거점일 때 거점 화면을 연다."
		row.add_child(open_button)
	else:
		row.add_child(_make_info_chip("actions/develop", "개발", "완료"))
		row.add_child(_make_info_chip("actions/place", "거점", "없음"))
	panel_box.add_child(row)
	map_base_box.add_child(_make_overlay_content_panel(panel_box))
	if map_base_scroll != null:
		map_base_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED


func _make_bottom_card_grid() -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = BOTTOM_CARD_GRID_COLUMNS
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 4)
	return grid


func _make_bottom_field_grid() -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = BOTTOM_FIELD_SECTION_COLUMNS
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.custom_minimum_size = Vector2(
		BOTTOM_FIELD_SLOT_SIZE.x * float(BOTTOM_FIELD_SECTION_COLUMNS) + 6.0 * float(BOTTOM_FIELD_SECTION_COLUMNS - 1),
		BOTTOM_FIELD_SLOT_SIZE.y * float(BOTTOM_CARD_VISIBLE_ROWS) + 4.0 * float(BOTTOM_CARD_VISIBLE_ROWS - 1)
	)
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 4)
	return grid


func _make_bottom_field_section(title_text: String, content: Control) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.clip_contents = true
	panel.custom_minimum_size = Vector2(0, 116)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.024, 0.036, 0.034, 0.62), Color(0.26, 0.34, 0.30, 0.58), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)
	var title := _make_bottom_card_section_label(title_text)
	box.add_child(title)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.custom_minimum_size = Vector2(0, 82)
	scroll.add_child(content)
	box.add_child(scroll)
	return panel


func _fill_bottom_empty_slots(grid: GridContainer, used_count: int, text: String) -> void:
	var slot_count: int = BOTTOM_FIELD_SLOT_COUNT
	var remaining: int = max(0, slot_count - min(used_count, slot_count))
	for index in range(remaining):
		grid.add_child(_make_bottom_empty_slot(text if index == 0 else ""))


func _make_bottom_empty_slot(text: String = "") -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = BOTTOM_FIELD_SLOT_SIZE
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.018, 0.025, 0.024, 0.46), Color(0.18, 0.23, 0.21, 0.48), 5))
	var label := Label.new()
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.48, 0.56, 0.52))
	_prepare_single_line_label(label, 0)
	panel.add_child(label)
	return panel


func _make_bottom_card_section_label(text: String) -> Label:
	var label := _small_title(text)
	label.add_theme_font_size_override("font_size", 12)
	return label


func _make_item_drop_zone(target_id: String, tile_id: String, accepted_sources: Array[String], content: Control, hint_text: String, enabled: bool = true) -> PanelContainer:
	var panel = ITEM_DROP_ZONE_SCRIPT.new()
	var compact_zone := hint_text == "" or target_id == "base_direct"
	panel.setup_drop_zone(target_id, tile_id, accepted_sources, enabled)
	panel.item_drop_requested.connect(_on_item_drop_requested)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 88 if compact_zone else 112)
	if compact_zone and enabled:
		hint_text = "소지품을 이 영역으로 드래그"
	panel.tooltip_text = hint_text if enabled else "현재 위치의 필드와만 물건을 주고받을 수 있다."
	var border_color := Color(0.34, 0.40, 0.34, 0.72) if enabled else Color(0.18, 0.20, 0.18, 0.48)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.034, 0.032, 0.72), border_color, 5))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)

	if not compact_zone:
		var hint := Label.new()
		hint.text = hint_text
		hint.clip_text = true
		hint.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		hint.add_theme_font_size_override("font_size", 9)
		hint.add_theme_color_override("font_color", Color(0.68, 0.76, 0.68) if enabled else Color(0.46, 0.50, 0.46))
		_prepare_single_line_label(hint, 90)
		box.add_child(hint)
	box.add_child(content)
	return panel


func _tile_action_summary(tile: Dictionary) -> String:
	var parts: Array[String] = []
	for action_id in ["investigate", "gather", "hunt", "set_trap", "check_trap", "fish", "develop", "wash", "rest"]:
		if not Array(tile.get("allowed_actions", [])).has(action_id):
			if action_id != "check_trap" or not WorldManager.has_tile_traps(String(tile.get("id", ""))):
				continue
		if action_id == "check_trap" and not WorldManager.has_tile_traps(String(tile.get("id", ""))):
			continue
		if ["hunt", "set_trap"].has(action_id) and not WorldManager.is_tile_investigated(String(tile.get("id", ""))):
			continue
		if action_id == "investigate" and not WorldManager.can_investigate_tile(String(tile.get("id", ""))):
			continue
		if action_id == "fish":
			var resources: Dictionary = tile.get("resources", {})
			if int(resources.get("fish", 0)) <= 0 or not InventoryManager.has_usable_tool_with_effect("fish_action"):
				continue
		var cost := WorldManager.get_tile_action_cost(action_id)
		var detail := "%s %s" % [_tile_context_action_label(action_id, String(tile.get("id", ""))), _action_cost_text(cost)]
		if action_id == "rest":
			detail = "%s 시간 선택 15분~2시간" % _tile_context_action_label(action_id, String(tile.get("id", "")))
		var restriction := _action_restriction_text_with_tools(action_id)
		if restriction != "":
			detail += " (%s)" % restriction
		if action_id == "develop":
			var requirements := WorldManager.get_tile_development_requirements(String(tile.get("id", "")))
			if not requirements.is_empty():
				detail += " 재료 %s" % _format_requirements(requirements)
		parts.append(detail)
	if bool(tile.get("is_base", false)):
		parts.append("거점 진입")
	if parts.is_empty():
		return "없음"
	return _join_lines(parts, " / ")


func _tile_equipment_hint(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return ""
	var hints: Array[String] = []
	if Array(tile.get("allowed_actions", [])).has("gather"):
		var gather_note := _action_tool_brief("gather", tile_id)
		if gather_note != "":
			hints.append("채집 %s" % gather_note)
	if tile_id == WorldManager.current_tile_id and Array(tile.get("allowed_actions", [])).has("investigate") and not GameState.is_daylight_time():
		var investigate_note := _action_tool_brief("investigate", tile_id)
		if investigate_note != "":
			hints.append("조사 %s" % investigate_note)
	if hints.is_empty():
		return ""
	return "장비: %s" % _join_lines(hints, " / ")


func _make_info_chip(icon_id: String, label_text: String, value_text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(94, 30)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.07, 0.095, 0.09), Color(0.22, 0.30, 0.28), 4))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var text := Label.new()
	text.text = "%s %s" % [label_text, value_text]
	text.clip_text = true
	text.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.add_theme_font_size_override("font_size", 11)
	text.add_theme_color_override("font_color", Color(0.88, 0.92, 0.87))
	_prepare_single_line_label(text, 58)
	row.add_child(text)
	return panel


func _danger_band(value: int) -> String:
	if value <= 0:
		return "낮음"
	if value == 1:
		return "낮음"
	if value == 2:
		return "중간"
	if value == 3:
		return "높음"
	return "매우높음"


func _progress_band(value: int, investigation: bool) -> String:
	if value <= 0:
		return "미확인" if investigation else "없음"
	if value < 30:
		return "낮음"
	if value < 60:
		return "중간"
	if value < 100:
		return "높음"
	return "완료"


func _resource_band(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return "없음"
	if not WorldManager.is_tile_investigated(tile_id):
		return "확인 전"
	var resources: Dictionary = tile.get("resources", {})
	var total := 0
	for item_id in resources.keys():
		total += max(0, int(resources[item_id]))
	if total <= 0:
		return "없음"
	if total <= 2:
		return "적음"
	if total <= 5:
		return "중간"
	if total <= 8:
		return "다소많음"
	return "많음"


func _resource_band_with_field(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return "없음"
	var field_total := 0
	for amount in WorldManager.get_tile_field_items(tile_id).values():
		field_total += max(0, int(amount))
	if not WorldManager.is_tile_investigated(tile_id) and field_total <= 0:
		return "확인 전"
	var total := field_total
	var resources: Dictionary = tile.get("resources", {})
	for item_id in resources.keys():
		total += max(0, int(resources[item_id]))
	for object in WorldManager.get_tile_resource_objects(tile_id):
		var remaining: int = maxi(0, int(object.get("remaining", 0)))
		var object_items: Dictionary = object.get("items", {})
		for raw_item_id in object_items.keys():
			total += max(0, int(object_items[raw_item_id])) * remaining
	if total <= 0:
		return "없음"
	if field_total > 0 and total == field_total:
		return "보관"
	if total <= 2:
		return "적음"
	if total <= 5:
		return "중간"
	if total <= 8:
		return "다소많음"
	return "많음"


func _access_band(tile_id: String) -> String:
	if tile_id == WorldManager.current_tile_id:
		return "현재"
	if WorldManager.is_tile_revealed(tile_id):
		var access_note := WorldManager.get_tile_access_note(tile_id, WorldManager.current_tile_id)
		if access_note != "":
			return "막힘"
	if WorldManager.is_tile_clickable(tile_id):
		return "가능"
	if WorldManager.is_tile_revealed(tile_id):
		return "우회"
	return "안개"


func _make_tile_button(tile: Dictionary) -> Button:
	var tile_id := String(tile.get("id", ""))
	var button := Button.new()
	button.name = "TileButton_%s" % tile_id
	button.custom_minimum_size = Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT)
	button.size = Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT)
	button.pivot_offset = Vector2(HEX_TILE_WIDTH * 0.5, HEX_TILE_HEIGHT * 0.5)
	button.clip_contents = true
	button.focus_mode = Control.FOCUS_NONE
	button.disabled = not WorldManager.is_tile_clickable(tile_id)
	button.tooltip_text = _tile_tooltip_text(tile)
	button.pressed.connect(_on_tile_pressed.bind(tile_id))
	button.mouse_entered.connect(Callable(self, "_on_tile_hover_entered").bind(button, tile_id))
	button.mouse_exited.connect(Callable(self, "_on_tile_hover_exited").bind(button))
	var empty_style := StyleBoxEmpty.new()
	button.add_theme_stylebox_override("normal", empty_style)
	button.add_theme_stylebox_override("hover", empty_style)
	button.add_theme_stylebox_override("pressed", empty_style)
	button.add_theme_stylebox_override("disabled", empty_style)

	var texture_rect := TextureRect.new()
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	var image_path := String(tile.get("image_path", ""))
	var tile_texture = _texture_from_path(image_path)
	if tile_texture != null:
		texture_rect.texture = tile_texture
	texture_rect.material = _make_hex_clip_material()
	button.add_child(texture_rect)

	_add_hex_tile_shape(button, tile)

	if bool(tile.get("playable", false)):
		if WorldManager.is_tile_revealed(tile_id):
			if bool(tile.get("playable", false)) and not bool(revealed_tile_memory.get(tile_id, false)):
				_add_reveal_fog_fade(button, tile)
			_add_tile_info_badges(button, tile)
			_add_tile_name_label(button, tile)
			if not _tile_is_near_player(tile_id):
				_add_distance_fog_mask(button)
		else:
			_add_unrevealed_tile_cover(button)

		if WorldManager.is_tile_revealed(tile_id) and _is_low_visibility_phase() and not _tile_is_near_player(tile_id):
			_add_night_visibility_mask(button)

		if selected_tile_id == tile_id:
			_add_selected_tile_ring(button)

		if tile_id == WorldManager.current_tile_id:
			_add_current_tile_aura(button)
			var current_fill := Polygon2D.new()
			current_fill.polygon = _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
			current_fill.color = Color(1.0, 0.86, 0.25, 0.12)
			button.add_child(current_fill)
			_add_tile_actor_marker(button, "res://assets/icons/map/player_marker.png", _tile_actor_marker_offset(tile_id, "player"), "플레이어 위치")
		if CharacterManager.partner_joined and CharacterManager.get_partner_tile_id(WorldManager.current_tile_id) == tile_id:
			var partner_tooltip := CharacterManager.get_partner_map_tooltip(_tile_label(tile_id))
			button.tooltip_text += "\n\n%s" % partner_tooltip
			_add_tile_actor_marker(button, "res://assets/icons/map/partner_marker.png", _tile_actor_marker_offset(tile_id, "partner"), partner_tooltip)
	return button


func _add_hex_tile_shape(button: Button, tile: Dictionary) -> void:
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var depth_shadow := Polygon2D.new()
	depth_shadow.polygon = _offset_hex_points(points, Vector2(0.0, 2.4))
	depth_shadow.color = Color(0.0, 0.0, 0.0, 0.18)
	button.add_child(depth_shadow)
	var overlay := Polygon2D.new()
	overlay.polygon = points
	overlay.color = _hex_tile_overlay_color(tile)
	button.add_child(overlay)

	var border := Line2D.new()
	border.width = 3.2
	border.default_color = _hex_tile_border_color(tile)
	for point in points:
		border.add_point(point)
	border.add_point(points[0])
	button.add_child(border)


func _offset_hex_points(points: PackedVector2Array, offset: Vector2) -> PackedVector2Array:
	var result := PackedVector2Array()
	for point in points:
		result.append(point + offset)
	return result


func _add_hex_corner_masks(button: Button) -> void:
	var tile_size := Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT)
	var mask_color := Color(0.035, 0.045, 0.045, 0.96)
	var masks := [
		PackedVector2Array([Vector2.ZERO, Vector2(tile_size.x * 0.5, 0.0), Vector2(0.0, tile_size.y * 0.27)]),
		PackedVector2Array([Vector2(tile_size.x * 0.5, 0.0), Vector2(tile_size.x, 0.0), Vector2(tile_size.x, tile_size.y * 0.27)]),
		PackedVector2Array([Vector2(tile_size.x, tile_size.y * 0.73), tile_size, Vector2(tile_size.x * 0.5, tile_size.y)]),
		PackedVector2Array([Vector2(0.0, tile_size.y * 0.73), Vector2(tile_size.x * 0.5, tile_size.y), Vector2(0.0, tile_size.y)])
	]
	for polygon_points in masks:
		var mask := Polygon2D.new()
		mask.polygon = polygon_points
		mask.color = mask_color
		button.add_child(mask)


func _hex_points(tile_size: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(tile_size.x * 0.50, 2.0),
		Vector2(tile_size.x - 3.0, tile_size.y * 0.27),
		Vector2(tile_size.x - 3.0, tile_size.y * 0.73),
		Vector2(tile_size.x * 0.50, tile_size.y - 2.0),
		Vector2(3.0, tile_size.y * 0.73),
		Vector2(3.0, tile_size.y * 0.27)
	])


func _hex_tile_overlay_color(tile: Dictionary) -> Color:
	var tile_id := String(tile.get("id", ""))
	if not bool(tile.get("playable", false)):
		return Color(0.0, 0.0, 0.0, 0.36)
	if bool(tile.get("movement_blocked", false)):
		return Color(0.05, 0.02, 0.02, 0.22)
	if not WorldManager.is_tile_revealed(tile_id):
		return Color(0.02, 0.03, 0.04, 0.22)
	if tile_id == WorldManager.current_tile_id:
		return Color(1.0, 0.82, 0.22, 0.10)
	if WorldManager.is_tile_clickable(tile_id):
		return Color(0.35, 0.58, 0.30, 0.045)
	if WorldManager.get_tile_access_note(tile_id, WorldManager.current_tile_id) != "":
		return Color(0.78, 0.30, 0.20, 0.10)
	return Color(0.04, 0.06, 0.06, 0.045)


func _hex_tile_border_color(tile: Dictionary) -> Color:
	var tile_id := String(tile.get("id", ""))
	if not bool(tile.get("playable", false)):
		return Color(0.05, 0.08, 0.09, 0.75)
	if bool(tile.get("movement_blocked", false)):
		return Color(0.82, 0.22, 0.18, 0.90)
	if tile_id == WorldManager.current_tile_id:
		return Color(1.0, 0.86, 0.22, 1.0)
	if WorldManager.is_tile_clickable(tile_id):
		return Color(0.70, 0.88, 0.42, 0.88)
	if WorldManager.get_tile_access_note(tile_id, WorldManager.current_tile_id) != "":
		return Color(0.95, 0.55, 0.20, 0.86)
	if WorldManager.is_tile_revealed(tile_id):
		return Color(0.30, 0.42, 0.38, 0.78)
	return Color(0.12, 0.16, 0.17, 0.82)


func _add_reveal_fog_fade(button: Button, tile: Dictionary) -> void:
	var fog_rect := TextureRect.new()
	fog_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fog_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fog_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fog_rect.stretch_mode = TextureRect.STRETCH_SCALE
	var fog_texture = _texture_from_path(String(tile.get("fog_path", "res://assets/tiles/region_hex/fog_tile.png")))
	if fog_texture != null:
		fog_rect.texture = fog_texture
	fog_rect.modulate = _fog_phase_modulate_color(_time_phase_id())
	var radial_material := _make_radial_fog_material()
	fog_rect.material = radial_material
	button.add_child(fog_rect)
	var tween := create_tween()
	tween.tween_interval(0.08)
	tween.tween_method(func(radius: float) -> void:
		if radial_material != null:
			radial_material.set_shader_parameter("radius", radius)
	, 0.0, 0.96, 0.78).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(fog_rect, "modulate:a", 0.0, 0.78).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(func() -> void:
		if is_instance_valid(fog_rect):
			fog_rect.queue_free()
	)


func _add_unrevealed_tile_cover(button: Button) -> void:
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var cover := Polygon2D.new()
	cover.name = "UnrevealedTileCover"
	cover.z_index = 44
	cover.polygon = points
	cover.color = Color(0.012, 0.018, 0.018, 1.0)
	button.add_child(cover)

	var rim := Line2D.new()
	rim.name = "UnrevealedTileRim"
	rim.z_index = 45
	rim.width = 2.6
	rim.default_color = Color(0.07, 0.09, 0.085, 0.92)
	for point in points:
		rim.add_point(point)
	rim.add_point(points[0])
	button.add_child(rim)


func _add_distance_fog_mask(button: Button) -> void:
	var fog_rect := TextureRect.new()
	fog_rect.name = "DistanceFogMask"
	fog_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fog_rect.z_index = 34
	fog_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fog_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fog_rect.stretch_mode = TextureRect.STRETCH_SCALE
	var fog_texture = _texture_from_path("res://assets/tiles/region_hex/fog_tile.png")
	if fog_texture != null:
		fog_rect.texture = fog_texture
	var phase_id := last_time_phase_id if last_time_phase_id != "" else _time_phase_id()
	var tint := _fog_phase_modulate_color(phase_id)
	tint.a = 0.68 if not _is_low_visibility_phase() else 0.82
	fog_rect.modulate = tint
	fog_rect.material = _make_hex_clip_material()
	button.add_child(fog_rect)


func _make_radial_fog_material() -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
uniform float radius = 0.0;
uniform float softness = 0.20;
uniform float feather = 0.018;

float hex_mask(vec2 uv) {
	float top = 0.025;
	float bottom = 0.975;
	float shoulder_top = 0.270;
	float shoulder_bottom = 0.730;
	float side_half_width = 0.467;
	float half_width = side_half_width;
	if (uv.y < shoulder_top) {
		half_width = side_half_width * clamp((uv.y - top) / (shoulder_top - top), 0.0, 1.0);
	} else if (uv.y > shoulder_bottom) {
		half_width = side_half_width * clamp((bottom - uv.y) / (bottom - shoulder_bottom), 0.0, 1.0);
	}
	float dx = abs(uv.x - 0.5) - half_width;
	float dy = max(top - uv.y, uv.y - bottom);
	float dist_to_edge = max(dx, dy);
	return 1.0 - smoothstep(0.0, feather, dist_to_edge);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV) * COLOR;
	float dist = distance(UV, vec2(0.5, 0.5));
	float fog_alpha = smoothstep(radius, radius + softness, dist);
	COLOR = vec4(tex.rgb, tex.a * fog_alpha * hex_mask(UV));
}
"""
	var material := ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("radius", 0.0)
	material.set_shader_parameter("softness", 0.22)
	material.set_shader_parameter("feather", 0.018)
	return material


func _make_hex_clip_material() -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
uniform float feather = 0.018;

float hex_mask(vec2 uv) {
	float top = 0.025;
	float bottom = 0.975;
	float shoulder_top = 0.270;
	float shoulder_bottom = 0.730;
	float side_half_width = 0.467;
	float half_width = side_half_width;
	if (uv.y < shoulder_top) {
		half_width = side_half_width * clamp((uv.y - top) / (shoulder_top - top), 0.0, 1.0);
	} else if (uv.y > shoulder_bottom) {
		half_width = side_half_width * clamp((bottom - uv.y) / (bottom - shoulder_bottom), 0.0, 1.0);
	}
	float dx = abs(uv.x - 0.5) - half_width;
	float dy = max(top - uv.y, uv.y - bottom);
	float dist_to_edge = max(dx, dy);
	return 1.0 - smoothstep(0.0, feather, dist_to_edge);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV) * COLOR;
	COLOR = vec4(tex.rgb, tex.a * hex_mask(UV));
}
"""
	var material := ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("feather", 0.018)
	return material


func _add_night_visibility_mask(button: Button) -> void:
	var mask := ColorRect.new()
	mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mask.z_index = 35
	mask.color = Color(0.0, 0.018, 0.07, 0.26)
	mask.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mask.material = _make_hex_clip_material()
	button.add_child(mask)


func _add_selected_tile_ring(button: Button) -> void:
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var fill := Polygon2D.new()
	fill.name = "SelectedTileFill"
	fill.polygon = points
	fill.color = Color(1.0, 0.88, 0.42, 0.11)
	button.add_child(fill)
	var ring := Line2D.new()
	ring.name = "SelectedTileRing"
	ring.width = 4.6
	ring.default_color = Color(1.0, 0.86, 0.34, 0.96)
	for point in points:
		ring.add_point(point)
	ring.add_point(points[0])
	button.add_child(ring)


func _add_current_tile_aura(button: Button) -> void:
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var aura := Polygon2D.new()
	aura.name = "CurrentTileAura"
	aura.polygon = points
	aura.color = Color(1.0, 0.78, 0.20, 0.18)
	button.add_child(aura)
	var ring := Line2D.new()
	ring.name = "CurrentTilePulse"
	ring.width = 4.0
	ring.default_color = Color(1.0, 0.92, 0.46, 0.95)
	for point in points:
		ring.add_point(point)
	ring.add_point(points[0])
	button.add_child(ring)
	var tween := create_tween()
	tween.set_loops()
	tween.set_parallel(true)
	tween.tween_property(aura, "color:a", 0.06, 0.86).from(0.23).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ring, "modulate:a", 0.42, 0.86).from(1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_tile_hover_entered(button: Button, tile_id: String) -> void:
	if button == null or button.disabled or not WorldManager.is_tile_clickable(tile_id):
		return
	_add_tile_hover_glow(button)
	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.045, 1.045), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_tile_hover_exited(button: Button) -> void:
	if button == null:
		return
	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var glow = button.get_node_or_null("HoverGlow")
	if glow != null:
		var fade := create_tween()
		fade.tween_property(glow, "modulate", Color(1, 1, 1, 0), 0.12)
		fade.tween_callback(func() -> void:
			if is_instance_valid(glow):
				glow.queue_free()
		)


func _add_tile_hover_glow(button: Button) -> void:
	if button.get_node_or_null("HoverGlow") != null:
		return
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var glow := Polygon2D.new()
	glow.name = "HoverGlow"
	glow.polygon = points
	glow.color = Color(0.96, 0.92, 0.58, 0.18)
	glow.modulate = Color(1, 1, 1, 0)
	button.add_child(glow)
	var shine := Line2D.new()
	shine.name = "HoverGlowLine"
	shine.width = 2.6
	shine.default_color = Color(1.0, 0.96, 0.64, 0.90)
	for point in points:
		shine.add_point(point)
	shine.add_point(points[0])
	glow.add_child(shine)
	var tween := create_tween()
	tween.tween_property(glow, "modulate", Color(1, 1, 1, 1), 0.10)


func _tile_is_near_player(tile_id: String) -> bool:
	if tile_id == WorldManager.current_tile_id:
		return true
	return WorldManager.get_reachable_adjacent_tile_ids(WorldManager.current_tile_id).has(tile_id)


func _is_low_visibility_phase() -> bool:
	return _time_phase_id() == "night"


func _add_tile_info_badges(button: Button, tile: Dictionary) -> void:
	var tile_id := String(tile.get("id", ""))
	if bool(tile.get("movement_blocked", false)):
		var blocked_badge := _make_tile_icon_badge("status/fear", String(tile.get("access_note", "막힌 지형")), 28.0, Color(0.18, 0.05, 0.05, 0.94), Color(0.92, 0.28, 0.24))
		_place_tile_control(blocked_badge, 0.5, 0.5, -14.0, -14.0, 14.0, 14.0)
		blocked_badge.tooltip_text = String(tile.get("access_note", "막힌 지형"))
		button.add_child(blocked_badge)
		return
	var edge_note := WorldManager.get_tile_access_note(tile_id, WorldManager.current_tile_id)
	if edge_note != "" and tile_id != WorldManager.current_tile_id:
		button.tooltip_text += "\n막힌 경로: %s" % edge_note
	var development := int(tile.get("development", 0))
	_add_tile_memory_badges(button, tile, development)
	if WorldManager.is_tile_investigated(tile_id):
		_add_tile_resource_column(button, tile)
		_add_tile_resource_object_buttons(button, tile)
	_add_tile_placed_item_column(button, tile)
	if development >= 100:
		_add_tile_map_mark(button, tile)


func _add_tile_name_label(button: Button, tile: Dictionary) -> void:
	var label := Label.new()
	label.name = "TileNameLabel"
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = 24
	label.text = String(tile.get("display_name", ""))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.98, 0.94, 0.74))
	label.add_theme_color_override("font_outline_color", Color(0.025, 0.025, 0.018, 0.88))
	label.add_theme_constant_override("outline_size", 3)
	var half_width := HEX_TILE_WIDTH * 0.35
	_place_tile_control(label, 0.5, 1.0, -half_width, -58.0, half_width, -32.0)
	button.add_child(label)


func _add_tile_resource_column(button: Button, tile: Dictionary) -> void:
	var resource_ids := _tile_gather_resource_ids(tile, 8)
	if resource_ids.is_empty():
		return
	var column := _make_tile_side_icon_grid("TileResourceColumn", resource_ids.size(), true)
	for item_id in resource_ids:
		column.add_child(_make_tile_plain_icon(_tile_resource_icon_path(item_id), _tile_resource_tooltip(tile, item_id), TILE_SIDE_ICON_SIZE))
	button.add_child(column)


func _add_tile_resource_object_buttons(button: Button, tile: Dictionary) -> void:
	var tile_id := String(tile.get("id", ""))
	var objects := WorldManager.get_tile_resource_objects(tile_id)
	if objects.is_empty():
		return
	var row := HBoxContainer.new()
	row.name = "TileResourceObjectButtons"
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	row.z_index = 27
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 3)
	var visible_count := mini(4, objects.size())
	var button_size := 28.0
	var width := float(visible_count) * button_size + float(maxi(0, visible_count - 1)) * 3.0
	row.custom_minimum_size = Vector2(width, button_size)
	_place_tile_control(row, 0.5, 0.5, -width * 0.5, 24.0, width * 0.5, 24.0 + button_size)
	for index in range(visible_count):
		row.add_child(_make_tile_resource_object_button(tile_id, objects[index]))
	button.add_child(row)


func _make_tile_resource_object_button(tile_id: String, object: Dictionary) -> Button:
	var object_id := String(object.get("id", ""))
	var object_name := String(object.get("display_name", object_id))
	var button := Button.new()
	button.name = "ResourceObject_%s" % object_id
	button.text = ""
	button.custom_minimum_size = Vector2(28, 28)
	button.size = Vector2(28, 28)
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.tooltip_text = _resource_object_tooltip(tile_id, object)
	button.disabled = tile_id != WorldManager.current_tile_id or int(object.get("remaining", 0)) <= 0
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.07, 0.10, 0.07, 0.90), Color(0.64, 0.72, 0.38, 0.92), 6))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.11, 0.16, 0.10, 0.98), Color(0.96, 0.82, 0.38, 0.98), 6))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.75, 0.60, 0.25, 0.96), Color(1.0, 0.92, 0.58, 1.0), 6))
	button.add_theme_stylebox_override("disabled", _make_panel_style(Color(0.05, 0.06, 0.05, 0.74), Color(0.22, 0.25, 0.20, 0.80), 6))
	var texture = _icon_texture(String(object.get("icon", "")))
	if texture != null:
		button.icon = texture
		button.expand_icon = false
		_limit_button_icon(button, 18)
	if not button.disabled:
		button.pressed.connect(Callable(self, "_open_resource_object_context_menu").bind(tile_id, object_id))
	button.set_meta("resource_object_name", object_name)
	_bind_button_reaction(button, "icon")
	return button


func _add_tile_hunting_badge(button: Button, tile: Dictionary) -> void:
	var tile_id := String(tile.get("id", ""))
	var traps: Dictionary = tile.get("traps", {})
	if int(tile.get("animals", 0)) <= 0 and traps.is_empty():
		return
	var icon_id := "res://assets/icons/tile_memory/animal_tracks.png"
	var color := Color(0.52, 0.42, 0.24, 0.94)
	var border := Color(0.86, 0.70, 0.38, 0.90)
	var text := ""
	for trap in traps.values():
		if String(Dictionary(trap).get("state", "set")) == "caught":
			text = "!"
			icon_id = "res://assets/icons/tile_memory/trap_catch.png"
			color = Color(0.20, 0.10, 0.05, 0.96)
			border = Color(0.96, 0.46, 0.24, 0.96)
			break
	var badge := _make_tile_info_badge(icon_id, text, color, border)
	badge.name = "TileHuntingBadge"
	badge.z_index = 26
	badge.tooltip_text = "수렵: %s" % WorldManager.get_tile_hunting_summary(tile_id)
	_place_tile_control(badge, 0.5, 0.0, -13.0, 42.0, 13.0, 68.0)
	button.add_child(badge)


func _tile_hunting_badge_entry(tile_id: String, tile: Dictionary) -> Dictionary:
	if not WorldManager.is_tile_investigated(tile_id):
		return {}
	var traps: Dictionary = tile.get("traps", {})
	if int(tile.get("animals", 0)) <= 0 and traps.is_empty():
		return {}
	var icon_id := "res://assets/icons/tile_memory/animal_tracks.png"
	var label_text := "수렵 흔적"
	var color := Color(0.13, 0.07, 0.04, 0.94)
	var border := Color(0.86, 0.48, 0.24, 0.92)
	if not traps.is_empty():
		icon_id = "res://assets/icons/tile_memory/trap_set.png"
		label_text = "덫 설치"
	for trap in traps.values():
		if String(Dictionary(trap).get("state", "set")) == "caught":
			icon_id = "res://assets/icons/tile_memory/trap_catch.png"
			label_text = "덫 포획"
			color = Color(0.20, 0.10, 0.05, 0.96)
			border = Color(0.96, 0.46, 0.24, 0.96)
			break
	var summary := WorldManager.get_tile_hunting_summary(tile_id)
	if summary == "":
		summary = label_text
	return {
		"icon": icon_id,
		"tooltip": "%s: %s" % [label_text, summary],
		"color": color,
		"border": border
	}


func _add_tile_memory_badges(button: Button, tile: Dictionary, development: int = 0) -> void:
	var tile_id := String(tile.get("id", ""))
	var memory_ids := _tile_memory_ordered_ids(tile_id)
	var entries: Array[Dictionary] = []
	if development > 0:
		entries.append({
			"icon": _tile_development_icon(development),
			"tooltip": _tile_development_tooltip(development),
			"color": _tile_development_color(development),
			"border": _tile_development_border_color(development)
		})
	var hunting_entry := _tile_hunting_badge_entry(tile_id, tile)
	if not hunting_entry.is_empty():
		entries.append(hunting_entry)
	for memory_id in memory_ids:
		if development > 0 and ["worked_ground", "developed"].has(memory_id):
			continue
		if not hunting_entry.is_empty() and ["trap_set", "trap_catch", "hunt_success", "animal_tracks"].has(memory_id):
			continue
		entries.append({
			"icon": _tile_memory_icon(memory_id),
			"tooltip": "%s: %s" % [_tile_memory_label(memory_id), _tile_memory_detail(memory_id)],
			"color": _tile_memory_color(memory_id),
			"border": _tile_memory_border_color(memory_id)
		})
		if entries.size() >= 4:
			break
	if entries.is_empty():
		return
	var icon_size := 20.0
	var gap := 3.0
	var visible_count := mini(4, entries.size())
	var width := float(visible_count) * icon_size + float(maxi(0, visible_count - 1)) * gap
	var row := HBoxContainer.new()
	row.name = "TileMemoryBadges"
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	row.z_index = 28
	row.add_theme_constant_override("separation", int(gap))
	_place_tile_control(row, 1.0, 0.0, -10.0 - width, 10.0, -10.0, 10.0 + icon_size)
	for index in range(visible_count):
		var entry := entries[index]
		var badge := _make_tile_icon_badge(
			String(entry.get("icon", "")),
			String(entry.get("tooltip", "")),
			icon_size,
			entry.get("color", Color(0.08, 0.10, 0.10, 0.92)),
			entry.get("border", Color(0.70, 0.74, 0.62, 0.88))
		)
		row.add_child(badge)
	button.add_child(row)


func _add_tile_placed_item_column(button: Button, tile: Dictionary) -> void:
	var item_ids := _tile_placed_item_ids(tile, 8)
	if item_ids.is_empty():
		return
	var column := _make_tile_side_icon_grid("TilePlacedColumn", item_ids.size(), false)
	for item_id in item_ids:
		var item = InventoryManager.get_item_data(item_id)
		var icon_id := _tile_resource_icon_path(item_id)
		if item != null and item.icon_path != "":
			icon_id = item.icon_path
		column.add_child(_make_tile_icon_badge(icon_id, _tile_placed_item_tooltip(tile, item_id), TILE_SIDE_ICON_SIZE, Color(0.14, 0.11, 0.08, 0.92), Color(0.74, 0.57, 0.32)))
	button.add_child(column)


func _add_tile_development_bar(button: Button, development: int) -> void:
	var panel := PanelContainer.new()
	panel.name = "TileDevelopmentBar"
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = 23
	panel.clip_contents = true
	panel.tooltip_text = "개발도 %d%%" % development
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.05, 0.04, 0.025, 0.88), Color(0.84, 0.66, 0.28, 0.82), 3))
	var half_width := HEX_TILE_WIDTH * 0.30
	_place_tile_control(panel, 0.5, 1.0, -half_width, -24.0, half_width, -10.0)
	var fill := ColorRect.new()
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill.anchor_left = 0.0
	fill.anchor_top = 0.0
	fill.anchor_right = clampf(float(development) / 100.0, 0.0, 1.0)
	fill.anchor_bottom = 1.0
	fill.color = Color(0.93, 0.68, 0.22, 0.92)
	panel.add_child(fill)
	button.add_child(panel)


func _add_tile_map_mark(button: Button, tile: Dictionary) -> void:
	var mark_id := WorldManager.get_tile_mark(String(tile.get("id", "")))
	if mark_id == "":
		return
	var badge := _make_tile_icon_badge(_tile_mark_icon(mark_id), "마크: %s" % _tile_mark_label(mark_id), 26.0, Color(0.08, 0.10, 0.10, 0.94), Color(0.88, 0.78, 0.40))
	badge.name = "TileMapMark"
	badge.z_index = 25
	_place_tile_control(badge, 0.5, 0.0, -13.0, 10.0, 13.0, 36.0)
	button.add_child(badge)


func _add_map_blocked_edge_walls() -> void:
	if map_grid == null:
		return
	for row in WorldManager.get_tile_rows():
		for tile in row:
			var tile_id := String(tile.get("id", ""))
			if tile_id == "" or not WorldManager.is_tile_investigated(tile_id):
				continue
			for neighbor_id in WorldManager.get_neighbor_tile_ids(tile_id):
				var note := WorldManager.get_blocked_edge_note(tile_id, neighbor_id)
				if note == "":
					continue
				if WorldManager.is_tile_investigated(neighbor_id) and tile_id > neighbor_id:
					continue
				var edge_points := _hex_edge_points_for_neighbor(tile, neighbor_id)
				if edge_points.size() < 2:
					continue
				var tile_position := _hex_tile_position(int(tile.get("x", 0)), int(tile.get("y", 0)))
				_add_map_blocked_edge_wall(tile_id, tile_position + edge_points[0], tile_position + edge_points[1], note)

func _hex_edge_points_for_neighbor(tile: Dictionary, neighbor_id: String) -> Array[Vector2]:
	var neighbor = WorldManager.get_tile(neighbor_id)
	if neighbor == null:
		return []
	var x := int(tile.get("x", 0))
	var y := int(tile.get("y", 0))
	var dx := int(neighbor.get("x", 0)) - x
	var dy := int(neighbor.get("y", 0)) - y
	var points := _hex_points(Vector2(HEX_TILE_WIDTH, HEX_TILE_HEIGHT))
	var edge_indices: Array[int] = []
	if dx == 1 and dy == 0:
		edge_indices = [1, 2]
	elif dx == -1 and dy == 0:
		edge_indices = [4, 5]
	elif y % 2 == 0:
		if dx == 0 and dy == -1:
			edge_indices = [0, 1]
		elif dx == -1 and dy == -1:
			edge_indices = [5, 0]
		elif dx == 0 and dy == 1:
			edge_indices = [2, 3]
		elif dx == -1 and dy == 1:
			edge_indices = [3, 4]
	else:
		if dx == 0 and dy == -1:
			edge_indices = [5, 0]
		elif dx == 1 and dy == -1:
			edge_indices = [0, 1]
		elif dx == 0 and dy == 1:
			edge_indices = [3, 4]
		elif dx == 1 and dy == 1:
			edge_indices = [2, 3]
	if edge_indices.size() < 2:
		return []
	return [points[edge_indices[0]], points[edge_indices[1]]]


func _add_map_blocked_edge_wall(tile_id: String, from_point: Vector2, to_point: Vector2, note: String) -> void:
	var inner_from := from_point.lerp(to_point, 0.10)
	var inner_to := from_point.lerp(to_point, 0.90)
	var shadow := Line2D.new()
	shadow.name = "BlockedEdgeShadow"
	shadow.z_index = 80
	shadow.width = 7.0
	shadow.default_color = Color(0.04, 0.02, 0.015, 0.88)
	shadow.add_point(inner_from + Vector2(0, 1.4))
	shadow.add_point(inner_to + Vector2(0, 1.4))
	map_grid.add_child(shadow)

	var wall := Line2D.new()
	wall.name = "BlockedEdgeWall"
	wall.z_index = 81
	wall.width = 4.2
	wall.default_color = Color(0.96, 0.38, 0.24, 0.98)
	wall.add_point(inner_from)
	wall.add_point(inner_to)
	map_grid.add_child(wall)

	var direction := (inner_to - inner_from).normalized()
	var normal := Vector2(-direction.y, direction.x)
	for index in range(3):
		var t := 0.22 + float(index) * 0.28
		var center := inner_from.lerp(inner_to, t)
		var slash := Line2D.new()
		slash.name = "BlockedEdgeSlash"
		slash.z_index = 82
		slash.width = 2.2
		slash.default_color = Color(1.0, 0.78, 0.48, 0.94)
		slash.add_point(center - normal * 4.5 - direction * 3.0)
		slash.add_point(center + normal * 4.5 + direction * 3.0)
		map_grid.add_child(slash)
	var blocked_badge := _make_tile_info_badge("actions/move", "!", Color(0.16, 0.05, 0.04, 0.96), Color(0.94, 0.36, 0.24))
	blocked_badge.name = "BlockedEdgeBadge"
	blocked_badge.z_index = 83
	blocked_badge.tooltip_text = note
	blocked_badge.custom_minimum_size = Vector2(28, 28)
	blocked_badge.size = Vector2(28, 28)
	blocked_badge.position = inner_from.lerp(inner_to, 0.5) - Vector2(14, 14)
	map_grid.add_child(blocked_badge)
	var button := map_grid.get_node_or_null("TileButton_%s" % tile_id) as Button
	if button != null and not button.tooltip_text.contains(note):
		button.tooltip_text += "\n막힌 경로: %s" % note


func _make_tile_info_badge(icon_id: String, text: String, bg_color: Color, border_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.custom_minimum_size = Vector2(24, 24)
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg_color, border_color, 4))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 2)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_right", 2)
	margin.add_theme_constant_override("margin_bottom", 2)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 1)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	if text != "":
		var label := Label.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.68))
		row.add_child(label)
	return panel


func _place_tile_control(control: Control, anchor_x: float, anchor_y: float, left: float, top: float, right: float, bottom: float) -> void:
	control.anchor_left = anchor_x
	control.anchor_right = anchor_x
	control.anchor_top = anchor_y
	control.anchor_bottom = anchor_y
	control.offset_left = left
	control.offset_top = top
	control.offset_right = right
	control.offset_bottom = bottom


func _make_tile_side_icon_grid(node_name: String, icon_count: int, left_side: bool) -> GridContainer:
	var grid := GridContainer.new()
	grid.name = node_name
	grid.mouse_filter = Control.MOUSE_FILTER_PASS
	grid.z_index = 22
	grid.add_theme_constant_override("h_separation", int(TILE_SIDE_ICON_GAP))
	grid.add_theme_constant_override("v_separation", int(TILE_SIDE_ICON_GAP))
	var columns := 1
	if icon_count > 4:
		columns = 2
	grid.columns = columns
	var rows := ceili(float(maxi(1, icon_count)) / float(columns))
	var width := float(columns) * TILE_SIDE_ICON_SIZE + float(columns - 1) * TILE_SIDE_ICON_GAP
	var height := float(rows) * TILE_SIDE_ICON_SIZE + float(rows - 1) * TILE_SIDE_ICON_GAP
	var top := clampf((HEX_TILE_HEIGHT - height) * 0.5 - 2.0, 10.0, HEX_TILE_HEIGHT - height - 10.0)
	if left_side:
		_place_tile_control(grid, 0.0, 0.0, 7.0, top, 7.0 + width, top + height)
	else:
		_place_tile_control(grid, 1.0, 0.0, -7.0 - width, top, -7.0, top + height)
	return grid


func _make_tile_plain_icon(icon_id: String, tooltip: String, size: float) -> TextureRect:
	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_PASS
	icon.custom_minimum_size = Vector2(size, size)
	icon.size = Vector2(size, size)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.tooltip_text = tooltip
	icon.modulate = Color(1.0, 1.0, 1.0, 0.96)
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	return icon


func _make_tile_icon_badge(icon_id: String, tooltip: String, size: float, bg_color: Color, border_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.custom_minimum_size = Vector2(size, size)
	panel.size = Vector2(size, size)
	panel.tooltip_text = tooltip
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg_color, border_color, 4))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 2)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_right", 2)
	margin.add_theme_constant_override("margin_bottom", 2)
	panel.add_child(margin)
	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(maxf(8.0, size - 5.0), maxf(8.0, size - 5.0))
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	margin.add_child(icon)
	return panel


func _tile_gather_resource_ids(tile: Dictionary, limit: int) -> Array[String]:
	var resources: Dictionary = tile.get("resources", {})
	var scored: Array[Dictionary] = []
	for raw_item_id in resources.keys():
		var item_id := String(raw_item_id)
		var amount := int(resources[raw_item_id])
		if amount > 0:
			scored.append({"id": item_id, "amount": amount})
	scored.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if int(a.get("amount", 0)) == int(b.get("amount", 0)):
			return String(a.get("id", "")) < String(b.get("id", ""))
		return int(a.get("amount", 0)) > int(b.get("amount", 0))
	)
	var ids: Array[String] = []
	for entry in scored:
		if ids.size() >= limit:
			break
		ids.append(String(entry.get("id", "")))
	return ids


func _tile_placed_item_ids(tile: Dictionary, limit: int) -> Array[String]:
	var field_items: Dictionary = tile.get("field_items", {})
	var ids: Array[String] = []
	var keys := field_items.keys()
	keys.sort()
	for raw_item_id in keys:
		if ids.size() >= limit:
			break
		var item_id := String(raw_item_id)
		if int(field_items[raw_item_id]) <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		if item == null:
			continue
		var category := String(item.category)
		if category == "tool" or category == "facility" or category == "furniture" or item.tags.has("tool") or item.tags.has("placeable"):
			ids.append(item_id)
	return ids


func _tile_resource_tooltip(tile: Dictionary, item_id: String) -> String:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var resources: Dictionary = tile.get("resources", {})
	return "%s\n채집 가능: %s" % [display_name, _amount_band(int(resources.get(item_id, 0)))]


func _resource_object_tooltip(tile_id: String, object: Dictionary) -> String:
	var lines: Array[String] = []
	var object_name := String(object.get("display_name", object.get("id", "")))
	lines.append(object_name)
	var description := String(object.get("description", ""))
	if description != "":
		lines.append(description)
	var items: Dictionary = object.get("items", {})
	lines.append("확정 획득: %s" % _format_items(items))
	var cost := WorldManager.get_resource_object_action_cost(tile_id, String(object.get("id", "")))
	lines.append(_action_cost_brief(cost))
	var remaining := int(object.get("remaining", 0))
	if tile_id != WorldManager.current_tile_id:
		lines.append("현재 위치에서만 채취할 수 있다.")
	elif remaining <= 0:
		lines.append("더 얻을 것이 없다.")
	else:
		lines.append("눌러서 채취한다.")
	return _join_lines(lines, "\n")


func _tile_placed_item_tooltip(tile: Dictionary, item_id: String) -> String:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var field_items: Dictionary = tile.get("field_items", {})
	return "%s x%d\n타일에 놓인 도구/시설" % [display_name, int(field_items.get(item_id, 0))]


func _tile_mark_icon(mark_id: String) -> String:
	for option in TILE_MARK_OPTIONS:
		if String(option.get("id", "")) == mark_id:
			return String(option.get("icon", "actions/place"))
	return "actions/place"


func _tile_mark_label(mark_id: String) -> String:
	if mark_id == "":
		return "없음"
	for option in TILE_MARK_OPTIONS:
		if String(option.get("id", "")) == mark_id:
			return String(option.get("label", mark_id))
	return mark_id


func _next_tile_mark_id(mark_id: String) -> String:
	if mark_id == "":
		return String(TILE_MARK_OPTIONS[0].get("id", ""))
	for index in range(TILE_MARK_OPTIONS.size()):
		if String(TILE_MARK_OPTIONS[index].get("id", "")) == mark_id:
			if index >= TILE_MARK_OPTIONS.size() - 1:
				return ""
			return String(TILE_MARK_OPTIONS[index + 1].get("id", ""))
	return ""


func _tile_memory_summary(tile_id: String) -> String:
	var labels: Array[String] = []
	for memory_id in _tile_memory_ordered_ids(tile_id):
		labels.append(_tile_memory_label(memory_id))
		if labels.size() >= 4:
			break
	return _join_lines(labels, ", ")


func _tile_memory_ordered_ids(tile_id: String) -> Array[String]:
	var ids := WorldManager.get_tile_memory_ids(tile_id)
	var ordered: Array[String] = []
	for candidate in [
		"wet_ground",
		"rain_puddle",
		"storm_debris",
		"washed_away",
		"damaged_trap",
		"trap_catch",
		"hunt_success",
		"animal_tracks",
		"found_objects",
		"fishing_spot",
		"fresh_gather",
		"picked_over",
		"worked_ground",
		"developed",
		"fully_surveyed",
		"first_survey",
		"trap_set"
	]:
		if ids.has(candidate):
			ordered.append(candidate)
	for memory_id in ids:
		if not ordered.has(memory_id):
			ordered.append(memory_id)
	return ordered


func _tile_memory_icon(memory_id: String) -> String:
	match memory_id:
		"wet_ground", "rain_puddle", "storm_debris", "washed_away", "damaged_trap", "trap_catch", "hunt_success", "animal_tracks", "found_objects", "fishing_spot", "fresh_gather", "picked_over", "worked_ground", "developed", "fully_surveyed", "first_survey", "trap_set":
			return "res://assets/icons/tile_memory/%s.png" % memory_id
	return "actions/place"


func _tile_development_icon(development: int) -> String:
	if development >= 100:
		return "res://assets/icons/tile_memory/development_100.png"
	if development >= 75:
		return "res://assets/icons/tile_memory/development_75.png"
	if development >= 50:
		return "res://assets/icons/tile_memory/development_50.png"
	return "res://assets/icons/tile_memory/development_25.png"


func _tile_development_tooltip(development: int) -> String:
	if development >= 100:
		return "개발도: 100% / 개발 완료"
	return "개발도: %d%%" % clampi(development, 1, 99)


func _tile_development_color(development: int) -> Color:
	if development >= 100:
		return Color(0.16, 0.12, 0.05, 0.94)
	if development >= 75:
		return Color(0.15, 0.10, 0.04, 0.92)
	if development >= 50:
		return Color(0.13, 0.10, 0.05, 0.92)
	return Color(0.11, 0.09, 0.06, 0.90)


func _tile_development_border_color(development: int) -> Color:
	if development >= 100:
		return Color(0.96, 0.78, 0.32, 0.96)
	if development >= 75:
		return Color(0.92, 0.68, 0.28, 0.94)
	if development >= 50:
		return Color(0.86, 0.60, 0.24, 0.92)
	return Color(0.74, 0.52, 0.24, 0.88)


func _tile_memory_label(memory_id: String) -> String:
	match memory_id:
		"wet_ground":
			return "젖은 땅"
		"rain_puddle":
			return "빗물 고임"
		"storm_debris":
			return "표류물"
		"washed_away":
			return "쓸려감"
		"damaged_trap":
			return "덫 파손"
		"first_survey":
			return "첫 조사"
		"found_objects":
			return "발견물"
		"fully_surveyed":
			return "조사 완료"
		"fresh_gather":
			return "채집 흔적"
		"picked_over":
			return "고갈"
		"fishing_spot":
			return "낚시 흔적"
		"animal_tracks":
			return "짐승 흔적"
		"hunt_success":
			return "수렵 흔적"
		"trap_set":
			return "덫 설치"
		"trap_catch":
			return "덫 포획"
		"worked_ground":
			return "작업 흔적"
		"developed":
			return "정비 완료"
	return memory_id


func _tile_memory_detail(memory_id: String) -> String:
	match memory_id:
		"wet_ground":
			return "비가 지나가 땅이 젖어 있다."
		"rain_puddle":
			return "빗물이 고여 물을 얻기 쉬워졌다."
		"storm_debris":
			return "폭풍이 표류물을 밀어 올렸다."
		"washed_away":
			return "강한 물살이 현장의 물건을 일부 쓸어갔다."
		"damaged_trap":
			return "나쁜 날씨에 덫이 망가진 흔적이 있다."
		"first_survey":
			return "이 장소를 처음 확인했다."
		"found_objects":
			return "직접 채취할 수 있는 대상이 눈에 띈다."
		"fully_surveyed":
			return "지형과 자원 상태를 충분히 파악했다."
		"fresh_gather":
			return "최근 채집한 흔적이 남아 있다."
		"picked_over":
			return "당장은 쉽게 얻을 자원이 적다."
		"fishing_spot":
			return "최근 물고기를 확인한 곳이다."
		"animal_tracks":
			return "놓친 짐승의 흔적이 남아 있다."
		"hunt_success":
			return "최근 사냥에 성공한 흔적이 있다."
		"trap_set":
			return "설치해 둔 덫이 있는 장소다."
		"trap_catch":
			return "덫에 먹잇감이 걸렸던 흔적이 있다."
		"worked_ground":
			return "개발 작업의 흔적이 남아 있다."
		"developed":
			return "생활에 맞게 정비된 장소다."
	return "기억해둘 만한 흔적이 있다."


func _tile_memory_color(memory_id: String) -> Color:
	match memory_id:
		"wet_ground", "rain_puddle", "fishing_spot":
			return Color(0.05, 0.12, 0.15, 0.92)
		"storm_debris", "washed_away", "damaged_trap":
			return Color(0.14, 0.11, 0.08, 0.94)
		"trap_catch", "hunt_success", "animal_tracks", "trap_set":
			return Color(0.13, 0.07, 0.04, 0.94)
		"found_objects", "fresh_gather":
			return Color(0.06, 0.12, 0.05, 0.92)
		"picked_over":
			return Color(0.13, 0.12, 0.09, 0.92)
		"worked_ground", "developed":
			return Color(0.13, 0.10, 0.05, 0.92)
	return Color(0.08, 0.10, 0.10, 0.92)


func _tile_memory_border_color(memory_id: String) -> Color:
	match memory_id:
		"wet_ground", "rain_puddle", "fishing_spot":
			return Color(0.36, 0.66, 0.82, 0.92)
		"storm_debris", "washed_away", "damaged_trap":
			return Color(0.82, 0.62, 0.34, 0.92)
		"trap_catch", "hunt_success", "animal_tracks", "trap_set":
			return Color(0.86, 0.48, 0.24, 0.92)
		"found_objects", "fresh_gather":
			return Color(0.58, 0.76, 0.34, 0.92)
		"picked_over":
			return Color(0.70, 0.62, 0.38, 0.88)
		"worked_ground", "developed":
			return Color(0.88, 0.68, 0.28, 0.92)
	return Color(0.70, 0.74, 0.62, 0.88)


func _tile_resource_badge_ids(tile: Dictionary, limit: int) -> Array[String]:
	var totals: Dictionary = {}
	var resources: Dictionary = tile.get("resources", {})
	for raw_item_id in resources.keys():
		var item_id := String(raw_item_id)
		var amount := int(resources[raw_item_id])
		if amount > 0:
			totals[item_id] = int(totals.get(item_id, 0)) + amount
	var field_items: Dictionary = tile.get("field_items", {})
	for raw_item_id in field_items.keys():
		var item_id := String(raw_item_id)
		var amount := int(field_items[raw_item_id])
		if amount > 0:
			totals[item_id] = int(totals.get(item_id, 0)) + amount + 100
	var scored: Array[Dictionary] = []
	for item_id in totals.keys():
		scored.append({"id": String(item_id), "amount": int(totals[item_id])})
	scored.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if int(a.get("amount", 0)) == int(b.get("amount", 0)):
			return String(a.get("id", "")) < String(b.get("id", ""))
		return int(a.get("amount", 0)) > int(b.get("amount", 0))
	)
	var ids: Array[String] = []
	for entry in scored:
		if ids.size() >= limit:
			break
		ids.append(String(entry.get("id", "")))
	return ids


func _tile_resource_icon_path(item_id: String) -> String:
	var item = InventoryManager.get_item_data(item_id)
	if item != null and item.icon_path != "":
		return item.icon_path
	return "items/stone"


func _development_badge_text(development: int) -> String:
	if development >= 100:
		return "완"
	if development >= 70:
		return "대"
	if development >= 40:
		return "중"
	return "소"


func _tile_tooltip_text(tile: Dictionary) -> String:
	var tile_id := String(tile.get("id", ""))
	var lines: Array[String] = []
	if not bool(tile.get("playable", false)):
		lines.append(String(tile.get("display_name", "타일")))
		lines.append("외곽")
	elif not WorldManager.is_tile_revealed(tile_id):
		lines.append("미탐색 타일")
		lines.append("조사로 시야를 확보해야 한다.")
	else:
		lines.append(String(tile.get("display_name", "타일")))
		var access_note := WorldManager.get_tile_access_note(tile_id, WorldManager.current_tile_id)
		if access_note != "":
			lines.append("접근: %s" % access_note)
		elif WorldManager.is_tile_clickable(tile_id):
			lines.append("접근: 가능")
		else:
			lines.append("접근: 우회 필요")
		lines.append("위험 %s / 조사 %s / 개발 %s" % [
			_danger_band(int(tile.get("danger", 0))),
			_progress_band(int(tile.get("investigation", 0)), true),
			_progress_band(int(tile.get("development", 0)), false)
		])
		if WorldManager.is_tile_investigated(tile_id) or WorldManager.has_tile_field_items(tile_id):
			lines.append("자원 %s" % _tile_resource_summary_with_field(tile))
		if WorldManager.is_tile_investigated(tile_id):
			var hunting_summary := WorldManager.get_tile_hunting_summary(tile_id)
			if hunting_summary != "":
				lines.append("수렵 %s" % hunting_summary)
	return _join_lines(lines, "\n")


func _tile_resource_summary(tile: Dictionary) -> String:
	var parts: Array[String] = []
	for item_id in _tile_resource_badge_ids(tile, 6):
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		var resources: Dictionary = tile.get("resources", {})
		parts.append("%s %s" % [display_name, _amount_band(int(resources.get(item_id, 0)))])
	if parts.is_empty():
		return "없음"
	return _join_lines(parts, ", ")


func _tile_resource_summary_with_field(tile: Dictionary) -> String:
	var parts: Array[String] = []
	var resources: Dictionary = tile.get("resources", {})
	var resource_keys := resources.keys()
	resource_keys.sort()
	for raw_item_id in resource_keys:
		var item_id := String(raw_item_id)
		var amount := int(resources[raw_item_id])
		if amount <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		parts.append("%s %s" % [display_name, _amount_band(amount)])
	var field_items: Dictionary = tile.get("field_items", {})
	var field_keys := field_items.keys()
	field_keys.sort()
	for raw_item_id in field_keys:
		var item_id := String(raw_item_id)
		var amount := int(field_items[raw_item_id])
		if amount <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		parts.append("%s 보관 x%d" % [display_name, amount])
	var tile_id := String(tile.get("id", ""))
	for object in WorldManager.get_tile_resource_objects(tile_id):
		parts.append("%s 확정" % String(object.get("display_name", object.get("id", ""))))
	if parts.is_empty():
		return "없음"
	return _join_lines(parts, ", ")


func _tile_field_item_summary(tile_id: String) -> String:
	var parts: Array[String] = []
	var field_items := WorldManager.get_tile_field_items(tile_id)
	var keys := field_items.keys()
	keys.sort()
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var amount := int(field_items[raw_item_id])
		if amount <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		parts.append("%s x%d" % [display_name, amount])
	if parts.is_empty():
		return "없음"
	return _join_lines(parts, ", ")


func _add_tile_actor_markers(button: Button) -> void:
	_add_tile_actor_marker(button, "res://assets/icons/map/player_marker.png", _tile_actor_marker_offset(WorldManager.current_tile_id, "player"), "플레이어 위치")
	if CharacterManager.partner_joined:
		var partner_tile_id := CharacterManager.get_partner_tile_id(WorldManager.current_tile_id)
		_add_tile_actor_marker(button, "res://assets/icons/map/partner_marker.png", _tile_actor_marker_offset(partner_tile_id, "partner"), CharacterManager.get_partner_map_tooltip(_tile_label(partner_tile_id)))


func _tile_actor_marker_offset(tile_id: String, actor_id: String) -> Vector2:
	var has_player := tile_id == WorldManager.current_tile_id
	var has_partner := CharacterManager.partner_joined and CharacterManager.get_partner_tile_id(WorldManager.current_tile_id) == tile_id
	if has_player and has_partner:
		if actor_id == "player":
			return Vector2(-44.0, -20.0)
		return Vector2(4.0, -20.0)
	return Vector2(-20.0, -20.0)


func _add_tile_actor_marker(button: Button, icon_path: String, offset: Vector2, tooltip: String) -> void:
	var marker := TextureRect.new()
	marker.name = "PlayerMarker" if icon_path.contains("player") else "PartnerMarker"
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.z_index = 34
	marker.anchor_left = 0.5
	marker.anchor_top = 0.5
	marker.anchor_right = 0.5
	marker.anchor_bottom = 0.5
	marker.offset_left = offset.x
	marker.offset_top = offset.y
	marker.offset_right = offset.x + TILE_ACTOR_ICON_SIZE
	marker.offset_bottom = offset.y + TILE_ACTOR_ICON_SIZE
	marker.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	marker.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	marker.tooltip_text = tooltip
	var texture = _texture_from_path(icon_path)
	if texture != null:
		marker.texture = texture
	button.add_child(marker)


func _refresh_character_panels() -> void:
	_clear_children(player_info_box)
	_clear_children(partner_info_box)
	_set_character_image_state(player_image_frame, true, CharacterManager.player_status, false)
	_set_character_image_state(partner_image_frame, CharacterManager.partner_joined, CharacterManager.partner_status, true)
	_set_partner_panel_blank(not CharacterManager.partner_joined)
	_add_status_card(player_info_box, "플레이어", CharacterManager.player_status, false)
	_add_inventory_summary(player_info_box, "player", false)
	player_info_box.add_child(_make_equipment_belt())
	player_info_box.add_child(_make_carry_weight_panel(true, "player"))
	player_info_box.add_child(_make_button("상세", Callable(self, "_show_status_detail").bind("player"), "status/stable"))
	if CharacterManager.partner_joined:
		var title := "동행자"
		if CharacterManager.partner_personality != null:
			title += " / %s" % CharacterManager.partner_personality.display_name
		_add_status_card(partner_info_box, title, CharacterManager.partner_status, true)
		_add_inventory_summary(partner_info_box, "partner", false)
		partner_info_box.add_child(_make_carry_weight_panel(true, "partner"))
		_add_partner_summary(partner_info_box, true)
		partner_info_box.add_child(_make_button("상세", Callable(self, "_show_status_detail").bind("partner"), "status/stable"))
		var talk_button := _make_button("대화", Callable(self, "_toggle_tool_menu").bind("partner"), "actions/talk")
		talk_button.disabled = not _can_talk_to_partner()
		partner_info_box.add_child(talk_button)
	else:
		_add_partner_absent_summary(partner_info_box)
		return


func _set_partner_panel_blank(is_blank: bool) -> void:
	if partner_image_frame != null:
		partner_image_frame.visible = not is_blank
		var parent = partner_image_frame.get_parent()
		if parent != null:
			var title_label = parent.get_node_or_null("CharacterPanelTitle")
			if title_label != null:
				title_label.visible = not is_blank


func _add_partner_absent_summary(parent: VBoxContainer) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.028, 0.038, 0.038, 0.72), Color(0.18, 0.24, 0.23, 0.50), 6))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 9)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 9)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	var title := _small_title("동행자 미합류")
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.66, 0.72, 0.68))
	box.add_child(title)

	var body := _create_body_label()
	body.text = "지금은 단서와 목표만 낮게 표시한다. 합류하면 상태와 지시 패널이 열린다."
	body.max_lines_visible = 3
	body.add_theme_font_size_override("font_size", 11)
	body.add_theme_color_override("font_color", Color(0.62, 0.68, 0.64))
	box.add_child(body)

	var button := _make_compact_button("기록 보기", Callable(self, "_toggle_tool_menu").bind("log"), "actions/investigate", Vector2(0, 26))
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(button)
	parent.add_child(panel)


func _refresh_base_view() -> void:
	_refresh_base_time_chip()
	_refresh_base_life_scene()
	if base_summary_label != null:
		base_summary_label.text = BaseManager.get_base_life_summary()
	_refresh_base_condition_grid()
	if base_drop_overlay != null:
		base_drop_overlay.setup_drop_surface(
			"base_direct",
			WorldManager.current_tile_id,
			["inventory"],
			base_view_panel != null and base_view_panel.visible and BaseManager.is_at_base()
		)
	if base_actions_box == null:
		return
	_clear_children(base_actions_box)
	base_actions_box.add_child(_make_item_drop_zone(
		"base_direct",
		WorldManager.current_tile_id,
		["inventory"],
		_make_base_direct_drop_content(),
		"소지품 → 거점 사용/배치",
		BaseManager.is_at_base()
	))
	_add_base_basic_actions()
	var placeable_ids := BaseManager.get_placeable_item_ids()
	var place_box := VBoxContainer.new()
	place_box.add_theme_constant_override("separation", 4)
	var place_title := _small_title("배치")
	place_title.add_theme_font_size_override("font_size", 12)
	place_box.add_child(place_title)
	var place_grid := GridContainer.new()
	place_grid.columns = 2
	place_grid.add_theme_constant_override("h_separation", 5)
	place_grid.add_theme_constant_override("v_separation", 5)
	place_box.add_child(place_grid)
	base_actions_box.add_child(_make_overlay_content_panel(place_box))
	for raw_item_id in placeable_ids:
		var item_id := String(raw_item_id)
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		var cost := BaseManager.get_placement_cost(item_id)
		var button := _make_button("%s 배치  %s" % [display_name, _action_cost_text(cost)], Callable(self, "_on_place_item_pressed").bind(item_id), "actions/place")
		button.disabled = InventoryManager.get_count(item_id) <= 0 \
			or not GameState.can_spend_action_points(int(cost.get("time", 2))) \
			or not CharacterManager.can_spend_stamina(int(cost.get("stamina", 8)))
		button.text = display_name
		button.custom_minimum_size = Vector2(122, 28)
		button.tooltip_text = "%s 배치\n%s" % [display_name, _action_cost_text(cost)]
		button.add_theme_font_size_override("font_size", 11)
		_limit_button_icon(button, COMPACT_BUTTON_ICON_SIZE)
		place_grid.add_child(button)


func _refresh_base_life_scene() -> void:
	if base_life_visual != null:
		var visual_texture = _texture_from_path(_base_growth_visual_path())
		if visual_texture != null:
			base_life_visual.texture = visual_texture
	if base_life_note_label != null:
		base_life_note_label.text = BaseManager.get_base_life_note()
	if base_facility_grid == null:
		return
	_clear_children(base_facility_grid)
	var placed_objects := BaseManager.get_placed_objects()
	if placed_objects.is_empty():
		for placeholder in [
			{"id": "small_campfire", "label": "잔불"},
			{"id": "simple_bed", "label": "잠자리"},
			{"id": "water_bucket", "label": "물자리"},
			{"id": "workbench", "label": "작업자리"}
		]:
			base_facility_grid.add_child(_make_base_facility_token(
				String(placeholder.get("id", "")),
				String(placeholder.get("label", "")),
				false
			))
		return
	for placed in placed_objects:
		var item_id := String(placed.get("id", ""))
		var item = InventoryManager.get_item_data(item_id)
		var label: String = item.display_name if item != null else item_id
		base_facility_grid.add_child(_make_base_facility_token(item_id, label, true))


func _refresh_base_condition_grid() -> void:
	if base_condition_grid == null:
		return
	_clear_children(base_condition_grid)
	for cue in BaseManager.get_base_life_cues():
		base_condition_grid.add_child(_make_base_condition_token(cue))


func _make_base_facility_token(item_id: String, label_text: String, active: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(112, 38)
	var bg := Color(0.08, 0.075, 0.055, 0.76) if active else Color(0.05, 0.055, 0.050, 0.42)
	var border := Color(0.80, 0.65, 0.34, 0.78) if active else Color(0.42, 0.42, 0.35, 0.42)
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg, border, 5))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(_base_facility_icon(item_id))
	if texture != null:
		icon.texture = texture
	icon.modulate = Color(1, 1, 1, 1) if active else Color(0.65, 0.65, 0.58, 0.55)
	row.add_child(icon)

	var label := Label.new()
	label.text = label_text
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.94, 0.89, 0.70) if active else Color(0.58, 0.60, 0.55))
	_prepare_single_line_label(label, 64)
	row.add_child(label)
	return panel


func _make_base_condition_token(cue: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(112, 40)
	panel.tooltip_text = String(cue.get("detail", ""))
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.058, 0.052, 0.92), Color(0.36, 0.46, 0.38, 0.65), 5))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(cue.get("icon", "")))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 0)
	row.add_child(text_box)

	var label := Label.new()
	label.text = String(cue.get("label", ""))
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.64, 0.76, 0.66))
	_prepare_single_line_label(label, 54)
	text_box.add_child(label)

	var value := Label.new()
	value.text = String(cue.get("value", ""))
	value.add_theme_font_size_override("font_size", 12)
	value.add_theme_color_override("font_color", _base_condition_value_color(value.text))
	_prepare_single_line_label(value, 54)
	text_box.add_child(value)
	return panel


func _base_facility_icon(item_id: String) -> String:
	match item_id:
		"small_campfire":
			return "items/campfire"
		"campfire":
			return "items/campfire"
		"stone_oven":
			return "items/campfire"
		"simple_bed":
			return "items/simple_bed"
		"storage_box":
			return "items/storage_box"
		"water_bucket", "rain_collector":
			return "items/%s" % item_id
		"drying_rack", "fish_trap":
			return "items/%s" % item_id
		"workbench":
			return "items/workbench"
		"leaf_shelter", "mud_wall":
			return "items/%s" % item_id
	return _item_primary_icon(InventoryManager.get_item_data(item_id), "items/storage_box")


func _base_condition_value_color(text: String) -> Color:
	match text:
		"든든":
			return Color(0.72, 0.92, 0.68)
		"보통":
			return Color(0.90, 0.84, 0.56)
		"약함":
			return Color(0.95, 0.63, 0.40)
	return Color(0.93, 0.40, 0.34)


func _make_base_direct_drop_content() -> Control:
	return _make_base_storage_drop_content(null)
	var label := Label.new()
	label.text = "설치물, 음식, 도구를 거점에 드래그"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.74))
	_prepare_single_line_label(label, 120)
	return _make_base_storage_drop_content(label)


func _make_base_storage_drop_content(title_label: Label) -> Control:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	if title_label != null:
		title_label.text = "거점에 내려놓기 / 설치"
		box.add_child(title_label)
	var storage_label := Label.new()
	storage_label.text = "보관 %.1f / %.1f" % [BaseManager.get_stored_weight(), BaseManager.get_storage_capacity()]
	storage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	storage_label.add_theme_font_size_override("font_size", 10)
	storage_label.add_theme_color_override("font_color", Color(0.62, 0.72, 0.62))
	box.add_child(storage_label)
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 5)
	grid.add_theme_constant_override("v_separation", 4)
	box.add_child(grid)
	var stored_items := BaseManager.get_stored_items()
	var keys := stored_items.keys()
	keys.sort()
	var shown := 0
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var amount := int(stored_items[raw_item_id])
		if amount <= 0:
			continue
		grid.add_child(_make_base_storage_item_card(item_id, amount))
		shown += 1
		if shown >= 8:
			break
	if shown == 0:
		grid.add_child(_make_bottom_empty_slot("보관품 없음"))
	return box


func _add_base_basic_actions() -> void:
	var row := GridContainer.new()
	row.columns = 3
	row.add_theme_constant_override("separation", 6)
	row.add_theme_constant_override("h_separation", 5)
	row.add_theme_constant_override("v_separation", 5)
	row.add_child(_make_button("제작", Callable(self, "_toggle_tool_menu").bind("craft"), "actions/craft"))
	row.add_child(_make_button("아이템", Callable(self, "_toggle_tool_menu").bind("inventory"), "items/berry"))
	row.add_child(_make_button("도구", Callable(self, "_toggle_tool_menu").bind("tools"), "items/stone_axe"))
	row.add_child(_make_button("수면", Callable(self, "_open_time_adjustment").bind("sleep", {}), "actions/rest"))
	var wash_cost := WorldManager.get_tile_action_cost("wash")
	var wash_button := _make_button("씻기  %s" % _action_cost_text(wash_cost), Callable(self, "_perform_tile_action").bind("wash", {}), "items/water")
	wash_button.disabled = not _can_start_action("wash", wash_cost)
	row.add_child(wash_button)
	var rest_cost := WorldManager.get_tile_action_cost("rest")
	var rest_button := _make_button("휴식 조정", Callable(self, "_open_time_adjustment").bind("rest", {}), "actions/rest")
	rest_button.disabled = not _can_start_action("rest", rest_cost)
	row.add_child(rest_button)
	for child in row.get_children():
		if child is Button:
			child.custom_minimum_size = Vector2(86, 28)
			child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			child.add_theme_font_size_override("font_size", 11)
	base_actions_box.add_child(_make_overlay_content_panel(row))


func _on_tile_pressed(tile_id: String) -> void:
	_open_tile_context_menu(tile_id)


func _open_tile_context_menu(tile_id: String) -> void:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null or not WorldManager.is_tile_clickable(tile_id):
		return
	selected_tile_id = tile_id
	_update_map_context_signal_preview(tile_id)
	_refresh_map_info_panel(tile_id)
	_clear_children(map_context_actions_box)
	if tile_id == WorldManager.current_tile_id and _maybe_open_hunt_trace_prompt(tile_id):
		return
	if tile_id == WorldManager.current_tile_id:
		_add_context_partner_status_chip()
		var base_needs_entry := bool(tile.get("is_base", false)) and not GameState.has_flag("entered_base")
		if base_needs_entry:
			_add_context_action_button("거점 진입", "enter_base", {}, "actions/place")
		for action_id in ["investigate", "gather", "hunt", "set_trap", "check_trap", "fish", "develop", "wash", "rest"]:
			if not Array(tile.get("allowed_actions", [])).has(action_id):
				if action_id != "check_trap" or not WorldManager.has_tile_traps(tile_id):
					continue
			if action_id == "check_trap" and not WorldManager.has_tile_traps(tile_id):
				continue
			if ["hunt", "set_trap"].has(action_id) and not WorldManager.is_tile_investigated(tile_id):
				continue
			if action_id == "investigate" and not WorldManager.can_investigate_tile(tile_id):
				continue
			if not _can_start_action(action_id, WorldManager.get_tile_action_cost(action_id)):
				continue
			_add_context_action_button(_tile_context_action_label(action_id, tile_id), action_id, {}, _action_icon_id(action_id))
		if bool(tile.get("is_base", false)) and not base_needs_entry:
			_add_context_action_button("거점 진입", "enter_base", {}, "actions/place")
		_add_context_mark_button(tile_id)
		_add_context_sleep_buttons()
	else:
		_add_context_action_button("이동", "move", {"target_tile_id": tile_id}, "actions/move")

	if map_context_actions_box.get_child_count() == 0:
		_add_context_empty_button()

	_sync_context_button_sizes()
	map_context_panel.custom_minimum_size = _context_panel_size()
	map_context_panel.size = _context_panel_size()
	map_context_panel.position = Vector2(MAP_CONTEXT_PADDING, MAP_CONTEXT_PADDING)
	map_context_panel.visible = true
	map_context_panel.move_to_front()
	map_context_panel.queue_sort()
	_position_map_context_panel(tile_id)
	_maybe_show_partner_suggestion("tile_selected", "", {"tile_id": tile_id})
	call_deferred("_sync_map_context_layout", tile_id, true)


func _maybe_open_hunt_trace_prompt(tile_id: String) -> bool:
	if not _can_offer_hunt_trace_prompt(tile_id):
		return false
	_mark_hunt_trace_prompt_checked(tile_id)
	if randi_range(1, 100) > HUNT_TRACE_PROMPT_CHANCE:
		return false
	_clear_children(map_context_actions_box)
	_add_context_trace_header(tile_id)
	_add_context_trace_choice_button("쫓기", Callable(self, "_on_hunt_trace_follow").bind(tile_id), "items/wooden_spear", "흔적을 따라가 사냥 방식을 고른다.")
	_add_context_trace_choice_button("지나침", Callable(self, "_on_hunt_trace_ignore").bind(tile_id), "actions/move", "흔적은 남겨두고 다른 행동을 고른다.")
	_sync_context_button_sizes()
	map_context_panel.custom_minimum_size = _context_panel_size()
	map_context_panel.size = _context_panel_size()
	map_context_panel.position = Vector2(MAP_CONTEXT_PADDING, MAP_CONTEXT_PADDING)
	map_context_panel.visible = true
	map_context_panel.move_to_front()
	map_context_panel.queue_sort()
	_position_map_context_panel(tile_id)
	_append_log("%s에서 방금 남은 듯한 짐승 흔적을 발견했다." % _tile_label(tile_id))
	_show_sensory_toast("res://assets/icons/tile_memory/animal_tracks.png", "풀 사이에 새 발자국이 보인다.", Color(0.86, 0.58, 0.28))
	call_deferred("_sync_map_context_layout", tile_id, true)
	return true


func _maybe_open_hunt_trace_prompt_after_action(action_id: String, tile_id: String) -> void:
	if not ["investigate", "gather", "fish", "develop", "wash", "rest", "set_trap", "check_trap"].has(action_id):
		return
	_maybe_open_hunt_trace_prompt(tile_id)


func _can_offer_hunt_trace_prompt(tile_id: String) -> bool:
	if GameState.has_flag(_hunt_trace_prompt_key(tile_id)):
		return false
	if tile_id == "" or tile_id != WorldManager.current_tile_id:
		return false
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return false
	if not Array(tile.get("allowed_actions", [])).has("hunt"):
		return false
	if not WorldManager.is_tile_investigated(tile_id):
		return false
	if int(tile.get("animals", 0)) <= 0:
		return false
	if not InventoryManager.has_usable_tool_with_effect("hunt_action"):
		return false
	return _can_start_action("hunt", WorldManager.get_tile_action_cost("hunt"))


func _hunt_trace_prompt_key(tile_id: String) -> String:
	var slot := int(floor(float(GameState.current_minutes) / float(HUNT_TRACE_PROMPT_SLOT_MINUTES)))
	return "hunt_trace_prompt_%s_%d_%d" % [tile_id, GameState.day, slot]


func _mark_hunt_trace_prompt_checked(tile_id: String) -> void:
	GameState.set_flag(_hunt_trace_prompt_key(tile_id), true)


func _add_context_trace_header(tile_id: String) -> void:
	var button := _make_context_button("흔적 발견", Callable(), "res://assets/icons/tile_memory/animal_tracks.png")
	button.disabled = true
	button.tooltip_text = "%s\n방금 남은 듯한 발자국과 꺾인 풀이 보인다." % _tile_label(tile_id)
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = "짐승 흔적"
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = "따라갈지 고른다"
	map_context_actions_box.add_child(button)


func _add_context_trace_choice_button(text: String, callback: Callable, icon_id: String, detail: String) -> void:
	var button := _make_context_button(text, callback, icon_id)
	button.tooltip_text = "흔적 발견\n%s" % detail
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = "즉시 선택"
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = detail
	map_context_actions_box.add_child(button)


func _on_hunt_trace_follow(tile_id: String) -> void:
	selected_tile_id = tile_id
	_show_sensory_toast("items/wooden_spear", "숨을 낮추고 흔적을 따라갈 준비를 한다.", Color(0.84, 0.58, 0.30))
	_open_action_method_menu("hunt", {"trace": true})


func _on_hunt_trace_ignore(tile_id: String) -> void:
	_show_sensory_toast("res://assets/icons/tile_memory/animal_tracks.png", "흔적은 기억해두고 다른 일을 고른다.", Color(0.66, 0.58, 0.38))
	_open_tile_context_menu(tile_id)


func _open_resource_object_context_menu(tile_id: String, object_id: String) -> void:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null or not WorldManager.is_tile_clickable(tile_id):
		return
	var object := WorldManager.get_resource_object(tile_id, object_id)
	if object.is_empty():
		return
	selected_tile_id = tile_id
	_refresh_map_info_panel(tile_id)
	_clear_children(map_context_actions_box)
	_add_context_resource_object_button(tile_id, object_id, object)
	if map_context_actions_box.get_child_count() == 0:
		_add_context_empty_button()
	_sync_context_button_sizes()
	map_context_panel.custom_minimum_size = _context_panel_size()
	map_context_panel.size = _context_panel_size()
	map_context_panel.position = Vector2(MAP_CONTEXT_PADDING, MAP_CONTEXT_PADDING)
	map_context_panel.visible = true
	map_context_panel.move_to_front()
	map_context_panel.queue_sort()
	_position_map_context_panel(tile_id)
	call_deferred("_sync_map_context_layout", tile_id, true)


func _hide_map_context_menu() -> void:
	map_context_panel.visible = false
	if map_context_signal_panel != null:
		map_context_signal_panel.visible = false
	selected_tile_id = ""
	_refresh_map_info_panel()


func _position_map_context_panel(tile_id: String) -> void:
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	var panel_size := _context_panel_size()
	map_context_panel.size = panel_size
	var map_size := map_stack.size
	var pos := Vector2(MAP_CONTEXT_PADDING, MAP_CONTEXT_PADDING)
	if button != null:
		var tile_center: Vector2 = map_stack.get_global_transform().affine_inverse() * button.get_global_rect().get_center()
		pos = tile_center - panel_size * 0.5
	pos.x = clampf(pos.x, MAP_CONTEXT_PADDING, maxf(MAP_CONTEXT_PADDING, map_size.x - panel_size.x - MAP_CONTEXT_PADDING))
	pos.y = clampf(pos.y, MAP_CONTEXT_PADDING, maxf(MAP_CONTEXT_PADDING, map_size.y - panel_size.y - MAP_CONTEXT_PADDING))
	map_context_panel.position = pos


func _sync_map_context_layout(tile_id: String, animate: bool = false) -> void:
	if map_context_panel == null or not map_context_panel.visible:
		return
	_sync_context_button_sizes()
	map_context_panel.custom_minimum_size = _context_panel_size()
	map_context_panel.size = _context_panel_size()
	map_context_panel.queue_sort()
	_position_map_context_panel(tile_id)
	if animate:
		_animate_context_buttons_from_center()


func _sync_context_button_sizes() -> void:
	var panel_size := _context_panel_size()
	map_context_actions_box.custom_minimum_size = panel_size
	map_context_actions_box.size = panel_size
	var center := panel_size * 0.5
	var children := map_context_actions_box.get_children()
	var count := maxi(1, children.size())
	var radius := minf(panel_size.x, panel_size.y) * 0.32
	if count <= 2:
		radius = minf(panel_size.x, panel_size.y) * 0.24
	for index in range(children.size()):
		var child = children[index]
		if child is Control:
			var control := child as Control
			var button_size := Vector2(82.0, 44.0)
			if count >= 7:
				button_size = Vector2(72.0, 38.0)
			elif count >= 5:
				button_size = Vector2(78.0, 42.0)
			control.custom_minimum_size = button_size
			control.size = button_size
			var angle := -PI * 0.50
			if count > 1:
				angle = -PI * 0.50 + float(index) * (TAU / float(count))
			var point := center + Vector2(cos(angle), sin(angle)) * radius - button_size * 0.5
			control.position = point


func _animate_context_buttons_from_center() -> void:
	if map_context_actions_box == null:
		return
	if map_context_tween != null and map_context_tween.is_valid():
		map_context_tween.kill()
	var panel_size := map_context_actions_box.size
	if panel_size.x <= 0.0 or panel_size.y <= 0.0:
		panel_size = _context_panel_size()
	var center := panel_size * 0.5
	var children := map_context_actions_box.get_children()
	map_context_tween = create_tween()
	map_context_tween.set_parallel(true)
	for index in range(children.size()):
		var child = children[index]
		if not (child is Control):
			continue
		var control := child as Control
		var target_position := control.position
		var target_scale := Vector2.ONE
		var delay := float(index) * 0.018
		control.pivot_offset = control.size * 0.5
		control.position = center - control.size * 0.5
		control.scale = Vector2(0.42, 0.42)
		control.modulate = Color(1, 1, 1, 0)
		map_context_tween.tween_property(control, "position", target_position, 0.16).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		map_context_tween.tween_property(control, "scale", target_scale, 0.16).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		map_context_tween.tween_property(control, "modulate", Color.WHITE, 0.10).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _context_panel_size() -> Vector2:
	var width := 230.0
	var height := 190.0
	if map_stack != null and map_stack.size.x > 0.0:
		width = minf(width, maxf(150.0, map_stack.size.x - MAP_CONTEXT_PADDING * 2.0))
		height = minf(height, maxf(140.0, map_stack.size.y - MAP_CONTEXT_PADDING * 2.0))
	return Vector2(width, height)


func _context_panel_width() -> float:
	if map_stack == null or map_stack.size.x <= 0.0:
		return MAP_CONTEXT_WIDTH
	return minf(MAP_CONTEXT_WIDTH, maxf(72.0, map_stack.size.x - MAP_CONTEXT_PADDING * 2.0))


func _update_map_context_signal_preview(tile_id: String) -> void:
	if map_context_signal_panel == null or map_context_signal_visual == null:
		return
	map_context_signal_panel.visible = false
	return
	var visual_path := _tile_context_signal_visual_path(tile_id)
	var texture = _texture_from_path(visual_path)
	if texture == null:
		map_context_signal_panel.visible = false
		return
	map_context_signal_visual.texture = texture
	if map_context_signal_label != null:
		map_context_signal_label.text = _tile_context_signal_label(tile_id)
	map_context_signal_panel.visible = true
	map_context_signal_panel.modulate = Color(1, 1, 1, 0.82)


func _tile_context_signal_visual_path(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return ""
	var terrain := String(tile.get("terrain", ""))
	if not WorldManager.is_tile_investigated(tile_id):
		return _generated_ui_asset_path("terrain_tiles", "jungle_trail")
	if bool(tile.get("is_base", false)):
		return _generated_transition_asset_path("base_transition")
	if int(tile.get("danger", 0)) >= 4:
		return _generated_transition_asset_path("danger_alert")
	if terrain == "marsh":
		return _generated_ui_asset_path("danger_signals", "stagnant_water")
	if int(tile.get("animals", 0)) >= 3:
		return _generated_ui_asset_path("danger_signals", "animal_tracks")
	var resources: Dictionary = tile.get("resources", {})
	if int(resources.get("water", 0)) > 0 and ["river", "cave", "beach"].has(terrain):
		return _generated_ui_asset_path("resource_objects", "freshwater_spring")
	if int(resources.get("berry", 0)) > 0:
		return _generated_ui_asset_path("resource_objects", "berry_bush")
	if int(resources.get("stone", 0)) > 0 or int(resources.get("clay", 0)) > 0:
		return _generated_ui_asset_path("resource_objects", "stone_outcrop")
	if int(resources.get("wood", 0)) > 0 or int(resources.get("palm_frond", 0)) > 0 or int(resources.get("fiber", 0)) > 0 or int(resources.get("vine", 0)) > 0:
		return _generated_ui_asset_path("resource_objects", "driftwood_pile")
	match terrain:
		"hill", "cave":
			return _generated_ui_asset_path("terrain_tiles", "cliff_ledge")
		"ruins":
			return _generated_ui_asset_path("terrain_tiles", "ruined_marker")
		"forest":
			return _generated_ui_asset_path("terrain_tiles", "jungle_trail")
		"beach", "meadow":
			return _generated_ui_asset_path("terrain_tiles", "base_clearing")
	return String(tile.get("image_path", ""))


func _tile_context_signal_label(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return ""
	if not WorldManager.is_tile_investigated(tile_id):
		return "미확인"
	if bool(tile.get("is_base", false)):
		return "거점"
	if int(tile.get("danger", 0)) >= 4:
		return "위험"
	var terrain := String(tile.get("terrain", ""))
	if terrain == "marsh":
		return "습지"
	if int(tile.get("animals", 0)) >= 3:
		return "흔적"
	var resources: Dictionary = tile.get("resources", {})
	if int(resources.get("water", 0)) > 0:
		return "식수"
	if int(resources.get("berry", 0)) > 0:
		return "식량"
	if int(resources.get("stone", 0)) > 0 or int(resources.get("clay", 0)) > 0:
		return "석재"
	if int(resources.get("wood", 0)) > 0 or int(resources.get("palm_frond", 0)) > 0 or int(resources.get("fiber", 0)) > 0 or int(resources.get("vine", 0)) > 0:
		return "재료"
	return _terrain_display_label_for_signal(terrain)


func _terrain_display_label_for_signal(terrain: String) -> String:
	match terrain:
		"beach":
			return "해변"
		"meadow":
			return "초원"
		"forest":
			return "숲"
		"river":
			return "강가"
		"cave":
			return "동굴"
		"hill":
			return "암벽"
		"ruins":
			return "유적"
	return "지역"


func _add_context_partner_status_chip() -> void:
	if not CharacterManager.partner_joined:
		return
	var partner_tile_id := CharacterManager.get_partner_tile_id(WorldManager.current_tile_id)
	var mode_id := CharacterManager.get_partner_mode_id()
	var button := _make_context_button(CharacterManager.get_partner_mode_label(), Callable(), _partner_mode_icon(mode_id))
	button.tooltip_text = CharacterManager.get_partner_mode_summary(_tile_label(partner_tile_id) if partner_tile_id != "" else "알 수 없음")
	button.add_theme_stylebox_override("normal", _make_panel_style(_partner_mode_color(mode_id, 0.92), _partner_mode_border_color(mode_id), 16))
	map_context_actions_box.add_child(button)


func _add_context_partner_toggle() -> void:
	if not CharacterManager.partner_joined:
		action_together_enabled = false
		return
	var button := _make_context_button("동행", Callable(self, "_toggle_context_partner_mode"), "actions/assist")
	button.toggle_mode = true
	button.button_pressed = action_together_enabled
	button.tooltip_text = "파트너 동행: %s" % ("켜짐" if action_together_enabled else "꺼짐")
	map_context_actions_box.add_child(button)


func _toggle_context_partner_mode() -> void:
	_on_context_partner_toggled(not action_together_enabled)


func _add_context_action_button(text: String, action_id: String, args: Dictionary, icon_id: String) -> void:
	var cost := WorldManager.get_tile_action_cost(action_id)
	if not _can_start_action(action_id, cost):
		return
	var restriction := _action_restriction_text_with_tools(action_id)
	var detail := _action_cost_brief(cost)
	if action_id == "rest":
		detail = "시간 선택 15분~2시간 / 쉼"
	var partner_note := ""
	if CharacterManager.is_partner_following() and _can_use_partner_mode_for_action(action_id):
		partner_note = _partner_action_cost_brief(action_id, cost)
		if partner_note != "":
			detail += " / %s" % partner_note
	if restriction != "":
		detail += " / %s" % restriction
	var tool_note := _action_tool_brief(action_id, selected_tile_id)
	if tool_note != "":
		detail += " / %s" % tool_note
	if action_id == "develop":
		var requirements := WorldManager.get_tile_development_requirements(selected_tile_id)
		if not requirements.is_empty():
			detail += " / 재료 필요"
	if action_id == "set_trap":
		detail += " / 올가미 덫 필요"
	var description := _tile_action_life_description(action_id, selected_tile_id)
	var button := _make_context_button(text, Callable(self, "_perform_context_action").bind(action_id, args), icon_id)
	var tooltip_lines: Array[String] = [text, detail, description]
	var partner_preview := _partner_action_preview_for_context(action_id, selected_tile_id)
	if not partner_preview.is_empty():
		tooltip_lines.append("파트너: \"%s\"" % String(partner_preview.get("text", "")))
		button.mouse_entered.connect(Callable(self, "_on_context_action_button_hovered").bind(action_id, selected_tile_id))
	if partner_note != "":
		tooltip_lines.append("동행 효과: 위험을 낮추지만 동행자도 기력을 쓴다.")
	if tool_note != "":
		tooltip_lines.append(_action_tool_detail(action_id, selected_tile_id))
	button.tooltip_text = _join_lines(tooltip_lines, "\n")
	button.disabled = false
	if _is_recommended_flow_action(action_id, args):
		_apply_recommended_context_style(button, _current_flow_hint_for_tile(selected_tile_id))
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = detail
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = description
	map_context_actions_box.add_child(button)


func _on_context_action_button_hovered(action_id: String, tile_id: String) -> void:
	var preview := _partner_action_preview_for_context(action_id, tile_id)
	if preview.is_empty():
		return
	var text := String(preview.get("text", ""))
	if text == "":
		return
	var key := String(preview.get("key", "preview_%s" % action_id))
	if _partner_action_preview_is_suppressed(key):
		return
	last_partner_action_preview_key = key
	last_partner_action_preview_msec = Time.get_ticks_msec()
	_show_partner_reaction_feedback(text, String(preview.get("icon", _action_icon_id(action_id))))


func _partner_action_preview_is_suppressed(key: String) -> bool:
	var now := Time.get_ticks_msec()
	if last_partner_action_preview_msec > 0 and now - last_partner_action_preview_msec < PARTNER_ACTION_PREVIEW_GLOBAL_MSEC:
		return true
	if last_partner_action_preview_msec > 0 and now - last_partner_action_preview_msec < PARTNER_ACTION_PREVIEW_COOLDOWN_MSEC:
		return key == last_partner_action_preview_key
	return false


func _add_context_resource_object_button(tile_id: String, object_id: String, object: Dictionary) -> void:
	var object_name := String(object.get("display_name", object_id))
	var icon_id := String(object.get("icon", "actions/gather"))
	var cost := WorldManager.get_resource_object_action_cost(tile_id, object_id)
	if not _can_start_resource_object_gather(tile_id, object_id, cost):
		return
	var items: Dictionary = object.get("items", {})
	var button := _make_context_button("채취", Callable(self, "_perform_resource_object_gather").bind(tile_id, object_id), icon_id)
	var tooltip_lines: Array[String] = [
		object_name,
		"확정 획득: %s" % _format_items(items),
		_action_cost_brief(cost)
	]
	var description := String(object.get("description", ""))
	if description != "":
		tooltip_lines.append(description)
	if tile_id != WorldManager.current_tile_id:
		tooltip_lines.append("현재 위치에서만 채취할 수 있다.")
	button.tooltip_text = _join_lines(tooltip_lines, "\n")
	button.disabled = false
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = _action_cost_brief(cost)
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = object_name
	map_context_actions_box.add_child(button)


func _action_tool_brief(action_id: String, tile_id: String = "") -> String:
	if action_id == "investigate" and not GameState.is_daylight_time():
		var torch_id := InventoryManager.get_best_tool_for_effect("night_investigate")
		if torch_id != "":
			return "횃불 %s" % _equipment_slot_state_text(torch_id, InventoryManager.get_item_data(torch_id), true)
		return ""
	if action_id == "fish":
		var rod_id := InventoryManager.get_best_tool_for_effect("fish_action")
		if rod_id == "":
			return "낚싯대 필요"
		var rod = InventoryManager.get_item_data(rod_id)
		return "도구 %s" % _equipment_slot_state_text(rod_id, rod, true)
	if action_id == "hunt":
		var hunt_tool_id := InventoryManager.get_best_tool_for_effect("hunt_action")
		if hunt_tool_id == "":
			return "사냥 도구 필요"
		var hunt_tool = InventoryManager.get_item_data(hunt_tool_id)
		return "도구 %s" % _equipment_slot_state_text(hunt_tool_id, hunt_tool, true)
	if action_id != "gather":
		return ""
	var labels: Array[String] = []
	for effect_id in _action_tool_effects_for_tile(tile_id):
		var tool_id := InventoryManager.get_best_tool_for_effect(effect_id)
		if tool_id == "":
			continue
		var item = InventoryManager.get_item_data(tool_id)
		if item == null:
			continue
		var state := _equipment_slot_state_text(tool_id, item, true)
		var label := "%s %s" % [item.display_name, state]
		if not labels.has(label):
			labels.append(label)
	if labels.is_empty():
		return "맨손"
	return "장비 %s" % _join_lines(labels.slice(0, 2), ", ")


func _action_tool_detail(action_id: String, tile_id: String = "") -> String:
	if action_id == "investigate" and not GameState.is_daylight_time():
		var torch_id := InventoryManager.get_best_tool_for_effect("night_investigate")
		if torch_id != "":
			return "사용 장비: %s\n밤에도 조사할 수 있지만 시간과 기력 부담이 늘고 횃불이 닳는다." % _tool_full_label(torch_id)
		return "야간 조사에 필요한 불빛이 없다."
	if action_id == "fish":
		var rod_id := InventoryManager.get_best_tool_for_effect("fish_action")
		if rod_id == "":
			return "사용 도구: 낚싯대 필요\n낚시는 낚싯대를 들고 있을 때만 가능하다."
		return "사용 도구: %s\n낚싯대 상태가 줄어든다.\n진행 중 물결과 줄의 긴장을 고르는 미니게임이 열린다." % _tool_full_label(rod_id)
	if action_id == "hunt":
		var hunt_tool_id := InventoryManager.get_best_tool_for_effect("hunt_action")
		if hunt_tool_id == "":
			return "사용 도구: 창이나 활 필요\n사냥은 먹잇감과 거리를 벌릴 도구가 있을 때만 가능하다."
		return "사용 도구: %s\n사냥 도구 상태가 줄어든다.\n진행 중 흔적과 거리 판단을 고르는 미니게임이 열린다." % _tool_full_label(hunt_tool_id)
	if action_id != "gather":
		return ""
	var lines: Array[String] = []
	for effect_id in _action_tool_effects_for_tile(tile_id):
		var tool_id := InventoryManager.get_best_tool_for_effect(effect_id)
		if tool_id == "":
			continue
		var line := "%s: %s" % [_tool_effect_label(effect_id), _tool_full_label(tool_id)]
		if not lines.has(line):
			lines.append(line)
	if lines.is_empty():
		return "사용 장비: 맨손\n도구가 있으면 일부 자원을 더 얻지만 도구 내구도가 닳는다."
	return "사용 장비:\n%s\n도구 보정이 적용되면 내구도가 닳는다." % _join_lines(lines, "\n")


func _action_tool_effects_for_tile(tile_id: String) -> Array[String]:
	var effects: Array[String] = []
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return effects
	var resources: Dictionary = tile.get("resources", {})
	for raw_item_id in resources.keys():
		if int(resources[raw_item_id]) <= 0:
			continue
		var effect_id := _tool_effect_for_resource_ui(String(raw_item_id))
		if effect_id != "" and not effects.has(effect_id):
			effects.append(effect_id)
	for object in WorldManager.get_tile_resource_objects(tile_id):
		var object_items: Dictionary = object.get("items", {})
		for raw_item_id in object_items.keys():
			if int(object_items[raw_item_id]) <= 0:
				continue
			var effect_id := _tool_effect_for_resource_ui(String(raw_item_id))
			if effect_id != "" and not effects.has(effect_id):
				effects.append(effect_id)
	return effects


func _tool_effect_for_resource_ui(item_id: String) -> String:
	match item_id:
		"wood":
			return "gather_wood_bonus"
		"fiber", "vine", "palm_frond":
			return "gather_fiber_bonus"
		"stone":
			return "gather_stone_bonus"
		"clay":
			return "gather_clay_bonus"
		"water":
			return "gather_water_bonus"
	return ""


func _tool_effect_label(effect_id: String) -> String:
	match effect_id:
		"gather_wood_bonus":
			return "나무"
		"gather_fiber_bonus":
			return "섬유/덩굴"
		"gather_stone_bonus":
			return "돌"
		"gather_clay_bonus":
			return "점토"
		"gather_water_bonus":
			return "물"
		"night_investigate":
			return "야간 조사"
	if effect_id == "fish_action":
		return "낚시"
	if effect_id == "hunt_action":
		return "사냥"
	return effect_id


func _tool_full_label(item_id: String) -> String:
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		return item_id
	return "%s (%s)" % [item.display_name, InventoryManager.get_tool_condition_text(item_id)]


func _partner_action_cost_brief(action_id: String, cost: Dictionary) -> String:
	if action_id == "rest":
		return "함께 회복"
	var stamina_cost := int(cost.get("stamina", 0))
	if stamina_cost <= 0:
		return "동행"
	var base_partner_cost := maxi(1, int(ceil(float(stamina_cost) * 0.5)))
	var effective_partner_cost := CharacterManager.get_effective_stamina_cost_preview(base_partner_cost, "partner")
	if effective_partner_cost > base_partner_cost:
		return "동행 기력 -%d(+%d)" % [effective_partner_cost, effective_partner_cost - base_partner_cost]
	return "동행 기력 -%d" % base_partner_cost


func _add_context_mark_button(tile_id: String) -> void:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null or int(tile.get("development", 0)) < 100:
		return
	var mark_id := WorldManager.get_tile_mark(tile_id)
	var next_mark_id := _next_tile_mark_id(mark_id)
	var icon_id := _tile_mark_icon(mark_id) if mark_id != "" else "actions/place"
	var button := _make_context_button("마크", Callable(self, "_cycle_tile_mark").bind(tile_id), icon_id)
	button.tooltip_text = "개발 완료 타일의 지도 마크를 바꾼다.\n현재: %s\n다음: %s" % [_tile_mark_label(mark_id), _tile_mark_label(next_mark_id)]
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = _tile_mark_label(mark_id)
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = "상단 표식 변경"
	map_context_actions_box.add_child(button)


func _cycle_tile_mark(tile_id: String) -> void:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null or int(tile.get("development", 0)) < 100:
		_show_sensory_toast("actions/place", "개발을 끝낸 타일에만 마크를 둘 수 있다.", Color(0.78, 0.55, 0.26))
		return
	var current_mark := WorldManager.get_tile_mark(tile_id)
	var next_mark := _next_tile_mark_id(current_mark)
	if not WorldManager.set_tile_mark(tile_id, next_mark):
		return
	_append_log("%s 마크: %s" % [_tile_label(tile_id), _tile_mark_label(next_mark)])
	_show_sensory_toast(_tile_mark_icon(next_mark) if next_mark != "" else "actions/place", "마크: %s" % _tile_mark_label(next_mark), Color(0.78, 0.68, 0.34))
	call_deferred("_open_tile_context_menu", tile_id)


func _add_context_sleep_buttons() -> void:
	var button := _make_context_button("수면", Callable(self, "_open_time_adjustment").bind("sleep", {}), "actions/rest")
	button.tooltip_text = "수면 시간 선택"
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = "시간 선택 / 회복"
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = "몸을 눕힐 곳을 찾는다"
	map_context_actions_box.add_child(button)


func _add_context_empty_button() -> void:
	var button := _make_context_button("행동 없음", Callable(), "")
	button.disabled = true
	button.tooltip_text = "현재 선택한 타일에서 실행할 수 있는 행동이 없다."
	map_context_actions_box.add_child(button)


func _perform_context_action(action_id: String, args: Dictionary) -> void:
	if action_id == "rest":
		_hide_map_context_menu()
		_open_time_adjustment("rest", args)
		return
	if _action_uses_method_choice(action_id) and not args.has("method_id"):
		_open_action_method_menu(action_id, args)
		return
	_hide_map_context_menu()
	_perform_tile_action(action_id, args)


func _perform_context_action_with_method(action_id: String, args: Dictionary, method_id: String) -> void:
	var action_args := args.duplicate(true)
	action_args["method_id"] = method_id
	_hide_map_context_menu()
	_perform_tile_action(action_id, action_args)


func _open_time_adjustment(mode: String, args: Dictionary = {}) -> void:
	if time_adjust_panel == null:
		return
	if map_context_panel != null and map_context_panel.visible:
		_hide_map_context_menu()
	var normalized_mode := "sleep" if mode == "sleep" else "rest"
	var min_value := 15
	var max_value := 120
	var step_value := 15
	var default_value := int(args.get("rest_minutes", 30))
	if normalized_mode == "sleep":
		min_value = 1
		max_value = 20
		step_value = 1
		default_value = int(args.get("hours", 8))
	default_value = _snap_time_adjust_value_for_bounds(default_value, min_value, max_value, step_value)
	active_time_adjustment = {
		"mode": normalized_mode,
		"args": args.duplicate(true),
		"min": min_value,
		"max": max_value,
		"step": step_value,
		"value": default_value
	}
	time_adjust_slider.min_value = min_value
	time_adjust_slider.max_value = max_value
	time_adjust_slider.step = step_value
	time_adjust_slider.set_value_no_signal(default_value)
	time_adjust_panel.visible = true
	_raise_root_overlay(time_adjust_panel, Z_ROOT_MODAL + 2)
	_fit_center_overlay(time_adjust_panel, Vector2(480, 280))
	_refresh_time_adjust_panel()


func _hide_time_adjust_panel() -> void:
	if time_adjust_panel != null:
		time_adjust_panel.visible = false
	active_time_adjustment.clear()


func _step_time_adjustment(direction: int) -> void:
	if active_time_adjustment.is_empty():
		return
	var step_value := int(active_time_adjustment.get("step", 1))
	var next_value := int(active_time_adjustment.get("value", 0)) + step_value * direction
	_set_time_adjustment_value(next_value)


func _on_time_adjust_slider_changed(value: float) -> void:
	_set_time_adjustment_value(int(round(value)))


func _set_time_adjustment_value(value: int) -> void:
	if active_time_adjustment.is_empty():
		return
	var min_value := int(active_time_adjustment.get("min", 0))
	var max_value := int(active_time_adjustment.get("max", 0))
	var step_value := int(active_time_adjustment.get("step", 1))
	var snapped := _snap_time_adjust_value_for_bounds(value, min_value, max_value, step_value)
	active_time_adjustment["value"] = snapped
	if time_adjust_slider != null:
		time_adjust_slider.set_value_no_signal(snapped)
	_refresh_time_adjust_panel()


func _snap_time_adjust_value_for_bounds(value: int, min_value: int, max_value: int, step_value: int) -> int:
	var safe_step := maxi(1, step_value)
	var clamped := clampi(value, min_value, max_value)
	var snapped := min_value + int(round(float(clamped - min_value) / float(safe_step))) * safe_step
	return clampi(snapped, min_value, max_value)


func _refresh_time_adjust_panel() -> void:
	if active_time_adjustment.is_empty() or time_adjust_value_label == null:
		return
	var mode := String(active_time_adjustment.get("mode", "rest"))
	var value := int(active_time_adjustment.get("value", 0))
	var detail_lines: Array[String] = []
	var can_confirm := not GameState.is_game_over
	if mode == "sleep":
		time_adjust_title_label.text = "수면 시간 조정"
		time_adjust_value_label.text = "%d시간" % value
		if time_adjust_confirm_button != null:
			time_adjust_confirm_button.text = "수면"
		detail_lines.append("1시간 단위로 1시간부터 20시간까지 조정한다.")
		detail_lines.append("현재 %s -> %s" % [GameState.get_time_label(), _time_label_after_minutes(value * 60)])
	else:
		time_adjust_title_label.text = "휴식 시간 조정"
		time_adjust_value_label.text = _duration_text_from_minutes(value)
		if time_adjust_confirm_button != null:
			time_adjust_confirm_button.text = "휴식"
		can_confirm = can_confirm and GameState.can_spend_minutes(value)
		detail_lines.append("15분 단위로 15분부터 2시간까지 조정한다.")
		detail_lines.append("현재 %s -> %s" % [GameState.get_time_label(), _time_label_after_minutes(value)])
		if not GameState.can_spend_minutes(value):
			detail_lines.append("오늘 남은 시간이 부족하다.")
	time_adjust_detail_label.text = _join_lines(detail_lines, "\n")
	if time_adjust_confirm_button != null:
		time_adjust_confirm_button.disabled = not can_confirm


func _confirm_time_adjustment() -> void:
	if active_time_adjustment.is_empty():
		return
	var mode := String(active_time_adjustment.get("mode", "rest"))
	var value := int(active_time_adjustment.get("value", 0))
	var stored_args = active_time_adjustment.get("args", {})
	var args: Dictionary = {}
	if stored_args is Dictionary:
		args = stored_args.duplicate(true)
	if mode == "sleep":
		_hide_time_adjust_panel()
		_perform_sleep(value)
		return
	if not GameState.can_spend_minutes(value):
		_show_sensory_toast("actions/rest", "오늘 남은 시간이 부족하다.", Color(0.72, 0.46, 0.32))
		_refresh_time_adjust_panel()
		return
	args["rest_minutes"] = value
	_hide_time_adjust_panel()
	_perform_tile_action("rest", args)


func _duration_text_from_minutes(minutes: int) -> String:
	var safe_minutes := maxi(0, minutes)
	var hour_count := int(safe_minutes / 60)
	var minute_count := safe_minutes % 60
	if hour_count > 0 and minute_count > 0:
		return "%d시간 %d분" % [hour_count, minute_count]
	if hour_count > 0:
		return "%d시간" % hour_count
	return "%d분" % minute_count


func _time_label_after_minutes(minutes: int) -> String:
	var total_minutes := GameState.current_minutes + maxi(0, minutes)
	var day_delta := int(floor(float(total_minutes) / float(GameState.MINUTES_PER_DAY)))
	var minute_of_day := total_minutes % GameState.MINUTES_PER_DAY
	var label := "%02d:%02d" % [int(minute_of_day / 60), minute_of_day % 60]
	if day_delta > 0:
		label += " (+%d일)" % day_delta
	return label


func _open_action_method_menu(action_id: String, args: Dictionary) -> void:
	if selected_tile_id == "":
		return
	_clear_children(map_context_actions_box)
	for option in _action_method_options(action_id):
		_add_context_action_method_button(action_id, args, option)
	if map_context_actions_box.get_child_count() == 0:
		_hide_map_context_menu()
		_show_sensory_toast(_action_icon_id(action_id), "지금 가능한 방식이 없다.", Color(0.72, 0.54, 0.30))
		return
	_sync_context_button_sizes()
	map_context_panel.custom_minimum_size = _context_panel_size()
	map_context_panel.size = _context_panel_size()
	map_context_panel.visible = true
	map_context_panel.move_to_front()
	map_context_panel.queue_sort()
	_position_map_context_panel(selected_tile_id)
	call_deferred("_sync_map_context_layout", selected_tile_id, true)


func _add_context_action_method_button(action_id: String, args: Dictionary, option: Dictionary) -> void:
	var method_id := String(option.get("id", ""))
	var label := String(option.get("label", method_id))
	var icon_id := String(option.get("icon", _action_icon_id(action_id)))
	var cost := WorldManager.get_tile_action_method_cost(action_id, method_id)
	if not _can_start_action(action_id, cost):
		return
	var button := _make_context_button(label, Callable(self, "_perform_context_action_with_method").bind(action_id, args, method_id), icon_id)
	button.tooltip_text = "%s\n%s\n%s\n%s" % [
		label,
		String(option.get("summary", "")),
		_action_cost_brief(cost),
		String(option.get("detail", ""))
	]
	button.disabled = false
	var detail_label = button.get_node_or_null("Content/TextBox/Detail")
	if detail_label != null:
		detail_label.text = _action_cost_brief(cost)
	var desc_label = button.get_node_or_null("Content/TextBox/Description")
	if desc_label != null:
		desc_label.text = String(option.get("summary", ""))
	map_context_actions_box.add_child(button)


func _action_uses_method_choice(action_id: String) -> bool:
	return ACTION_METHOD_OPTIONS.has(action_id)


func _action_method_options(action_id: String) -> Array:
	return ACTION_METHOD_OPTIONS.get(action_id, [])


func _perform_tile_action(action_id: String, args: Dictionary = {}) -> void:
	if _action_requires_minigame(action_id) and not args.has("minigame_result"):
		_start_action_minigame(action_id, args)
		return
	var before_snapshot := _capture_play_state()
	var action_args := args.duplicate(true)
	if not action_args.has("together") and _can_use_partner_mode_for_action(action_id):
		action_args["together"] = CharacterManager.is_partner_following()
	var suggestion_tile_id := String(action_args.get("target_tile_id", selected_tile_id if selected_tile_id != "" else WorldManager.current_tile_id))
	_maybe_show_partner_suggestion("before_action", action_id, {"tile_id": suggestion_tile_id})
	var result := WorldManager.execute_tile_action(action_id, action_args)
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	if action_id == "enter_base" and bool(result.get("ok", false)):
		_show_base_view()
	if bool(result.get("ok", false)):
		var resolved_action_id := String(result.get("action_id", action_id))
		var resolved_tile_id := String(result.get("tile_id", WorldManager.current_tile_id))
		var before_tile_id := String(before_snapshot.get("tile_id", ""))
		_record_action_memory_if_needed(resolved_action_id, result, before_snapshot, after_snapshot)
		_append_log(_build_action_delta_text(before_snapshot, after_snapshot, result))
		_refresh_all()
		call_deferred("_play_post_action_feedback", resolved_action_id, resolved_tile_id, before_tile_id, result)
		if bool(action_args.get("together", false)) and _can_use_partner_mode_for_action(resolved_action_id):
			_show_together_action_feedback(resolved_action_id)
		_show_action_result(resolved_action_id, result, before_snapshot, after_snapshot)
		EventManager.evaluate_after_action(resolved_action_id, GameState.current_region_id, result)
		_maybe_show_partner_suggestion("after_action", resolved_action_id, result)
		_maybe_show_early_survival_nudge("after_action")
		call_deferred("_maybe_open_hunt_trace_prompt_after_action", resolved_action_id, resolved_tile_id)
	else:
		_refresh_all()
		_show_action_result(action_id, result, before_snapshot, after_snapshot)


func _perform_resource_object_gather(tile_id: String, object_id: String) -> void:
	_hide_map_context_menu()
	var before_snapshot := _capture_play_state()
	var together := CharacterManager.is_partner_following()
	var result := WorldManager.gather_resource_object(tile_id, object_id, together)
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	if bool(result.get("ok", false)):
		var resolved_tile_id := String(result.get("tile_id", tile_id))
		var before_tile_id := String(before_snapshot.get("tile_id", ""))
		_record_action_memory_if_needed("gather", result, before_snapshot, after_snapshot)
		_append_log(_build_action_delta_text(before_snapshot, after_snapshot, result))
		_refresh_all()
		call_deferred("_play_post_action_feedback", "gather", resolved_tile_id, before_tile_id, result)
		if together:
			_show_together_action_feedback("gather")
		_show_action_result("gather", result, before_snapshot, after_snapshot)
		EventManager.evaluate_after_action("gather", GameState.current_region_id, result)
		_maybe_show_partner_suggestion("after_action", "gather", result)
		_maybe_show_early_survival_nudge("after_gather")
	else:
		_refresh_all()
		_show_action_result("gather", result, before_snapshot, after_snapshot)


func _action_requires_minigame(action_id: String) -> bool:
	return ["fish", "hunt"].has(action_id)


func _start_action_minigame(action_id: String, args: Dictionary) -> void:
	if selected_tile_id == "":
		selected_tile_id = WorldManager.current_tile_id
	var method_id := String(args.get("method_id", ""))
	if method_id == "":
		method_id = "patient" if action_id == "fish" else "track"
	var cost := WorldManager.get_tile_action_method_cost(action_id, method_id)
	if not _can_start_action(action_id, cost):
		_show_sensory_toast(_action_icon_id(action_id), "지금은 %s을/를 시작할 수 없다." % _action_display_name(action_id), Color(0.72, 0.46, 0.32))
		return
	var steps := _action_minigame_steps(action_id, method_id)
	if steps.is_empty():
		var direct_args := args.duplicate(true)
		direct_args["method_id"] = method_id
		direct_args["minigame_result"] = {"score": 50, "grade": "normal", "grade_text": "보통", "mistakes": 0}
		_perform_tile_action(action_id, direct_args)
		return
	_hide_tool_menu()
	_hide_map_context_menu()
	action_minigame = {
		"active": false,
		"preparing": true,
		"action_id": action_id,
		"args": args.duplicate(true),
		"method_id": method_id,
		"steps": steps,
		"index": 0,
		"score": 0,
		"mistakes": 0,
		"meter_value": 50.0,
		"meter_phase": randf_range(0.0, TAU),
		"meter_speed": 1.0,
		"target_center": 50.0,
		"target_width": 26.0,
		"tension": 50.0,
		"hook_progress": 0.0,
		"distance": 74.0,
		"noise": 22.0,
		"prepare_total": 1.25,
		"prepare_time": 1.25,
		"max_time": _action_minigame_time_limit(action_id, method_id),
		"time_left": _action_minigame_time_limit(action_id, method_id)
	}
	if tool_craft_layer != null:
		tool_craft_layer.visible = true
		_raise_root_overlay(tool_craft_layer, Z_ROOT_MODAL + 4)
	if tool_craft_visual_frame != null:
		tool_craft_visual_frame.visible = false
	if fishing_visual_frame != null:
		fishing_visual_frame.visible = action_id == "fish"
	if hunting_visual_frame != null:
		hunting_visual_frame.visible = action_id == "hunt"
	if fishing_visual_flash != null:
		fishing_visual_flash.color = Color(1, 1, 1, 0)
	if fishing_bobber != null:
		fishing_bobber.scale = Vector2(1, 1)
	if fishing_ripple_ring != null:
		fishing_ripple_ring.scale = Vector2(1, 1)
	if hunting_visual_flash != null:
		hunting_visual_flash.color = Color(1, 1, 1, 0)
	if hunting_track_marker != null:
		hunting_track_marker.scale = Vector2(1, 1)
	if hunting_noise_ring != null:
		hunting_noise_ring.scale = Vector2(1, 1)
	if tool_craft_icon != null:
		var icon_texture = _icon_texture(_action_icon_id(action_id))
		if icon_texture != null:
			tool_craft_icon.texture = icon_texture
	if tool_craft_title_label != null:
		tool_craft_title_label.text = "%s 진행" % _action_display_name(action_id)
	if tool_craft_footer_label != null:
		tool_craft_footer_label.text = _action_minigame_footer(action_id)
	_set_action_minigame_meter_visible(false)
	_fit_center_overlay(tool_craft_panel, TOOL_CRAFT_MINIGAME_DESIRED_SIZE)
	_show_action_minigame_prepare()


func _show_action_minigame_prepare() -> void:
	if action_minigame.is_empty():
		return
	var action_id := String(action_minigame.get("action_id", ""))
	var method_id := String(action_minigame.get("method_id", ""))
	if tool_craft_step_label != null:
		tool_craft_step_label.text = "%s 준비" % _action_display_name(action_id)
	if tool_craft_body_label != null:
		tool_craft_body_label.text = _action_minigame_prepare_text(action_id, method_id)
	if tool_craft_quality_label != null:
		tool_craft_quality_label.text = "호흡을 고르는 중"
	if tool_craft_hint_label != null:
		tool_craft_hint_label.text = "잠시 후 시작"
	if tool_craft_progress != null:
		tool_craft_progress.value = 100.0
	_clear_children(tool_craft_actions_box)
	var ready := _make_button("준비 중", Callable(), _action_icon_id(action_id))
	ready.disabled = true
	ready.custom_minimum_size = Vector2(140, 40)
	tool_craft_actions_box.add_child(ready)
	if action_id == "fish":
		_refresh_fishing_minigame_prepare_visual()
	elif action_id == "hunt":
		_refresh_hunting_minigame_prepare_visual()


func _update_action_minigame_prepare() -> void:
	var total := maxf(0.1, float(action_minigame.get("prepare_total", 1.25)))
	var left := clampf(float(action_minigame.get("prepare_time", total)), 0.0, total)
	if tool_craft_progress != null:
		tool_craft_progress.value = left / total * 100.0
	if tool_craft_hint_label != null:
		tool_craft_hint_label.text = "%.1f초" % left
	var action_id := String(action_minigame.get("action_id", ""))
	if action_id == "fish":
		_refresh_fishing_minigame_prepare_visual()
	elif action_id == "hunt":
		_refresh_hunting_minigame_prepare_visual()


func _action_minigame_prepare_text(action_id: String, method_id: String) -> String:
	if action_id == "fish":
		return "낚싯대를 낮추고 물결을 본다.\n첫 선택지가 나오기 전까지 찌의 위치와 물결 색을 확인한다."
	if action_id == "hunt":
		return "발소리를 낮추고 바람을 본다.\n첫 선택지가 나오기 전까지 흔적과 소음 범위를 확인한다."
	return "%s 준비 중" % method_id


func _refresh_fishing_minigame_prepare_visual() -> void:
	if fishing_visual_frame == null:
		return
	fishing_visual_frame.visible = true
	if fishing_bobber_label != null:
		fishing_bobber_label.text = "..."
	if fishing_visual_flash != null:
		fishing_visual_flash.color = Color(0.40, 0.68, 0.86, 0.08)
	if fishing_bobber != null:
		fishing_bobber.size = Vector2(36, 36)
		fishing_bobber.position = Vector2(maxf(48.0, fishing_visual_frame.size.x * 0.38), maxf(80.0, fishing_visual_frame.size.y * 0.56))
	if fishing_ripple_ring != null:
		fishing_ripple_ring.size = Vector2(68, 68)
		fishing_ripple_ring.position = fishing_bobber.position + fishing_bobber.size * 0.5 - fishing_ripple_ring.size * 0.5 if fishing_bobber != null else Vector2.ZERO


func _refresh_hunting_minigame_prepare_visual() -> void:
	if hunting_visual_frame == null:
		return
	hunting_visual_frame.visible = true
	if hunting_track_label != null:
		hunting_track_label.text = "?"
	if hunting_visual_flash != null:
		hunting_visual_flash.color = Color(0.58, 0.72, 0.36, 0.08)
	if hunting_track_marker != null:
		hunting_track_marker.size = Vector2(38, 38)
		hunting_track_marker.position = Vector2(maxf(56.0, hunting_visual_frame.size.x * 0.54), maxf(72.0, hunting_visual_frame.size.y * 0.48))
	if hunting_noise_ring != null and hunting_track_marker != null:
		hunting_noise_ring.size = Vector2(78, 78)
		hunting_noise_ring.position = hunting_track_marker.position + hunting_track_marker.size * 0.5 - hunting_noise_ring.size * 0.5


func _show_action_minigame_step() -> void:
	if not bool(action_minigame.get("active", false)):
		return
	var steps: Array = action_minigame.get("steps", [])
	var index := int(action_minigame.get("index", 0))
	if index >= steps.size():
		_finish_action_minigame()
		return
	var step: Dictionary = steps[index]
	var max_time := float(action_minigame.get("max_time", 3.0))
	action_minigame["time_left"] = max_time
	var timing := _action_minigame_timing_profile(
		String(action_minigame.get("action_id", "")),
		String(action_minigame.get("method_id", "")),
		index
	)
	action_minigame["target_center"] = float(timing.get("center", 50.0))
	action_minigame["target_width"] = float(timing.get("width", 26.0))
	action_minigame["meter_speed"] = float(timing.get("speed", 1.0))
	action_minigame["meter_phase"] = randf_range(0.0, TAU)
	if tool_craft_step_label != null:
		tool_craft_step_label.text = "%d / %d  %s" % [index + 1, steps.size(), String(step.get("title", "집중"))]
	if tool_craft_body_label != null:
		tool_craft_body_label.text = "%s\n%s" % [
			String(step.get("prompt", "")),
			_action_minigame_partner_note(String(action_minigame.get("action_id", "")))
		]
	var active_action_id := String(action_minigame.get("action_id", ""))
	if active_action_id == "fish":
		_refresh_fishing_minigame_visual(step, index, steps.size())
	elif active_action_id == "hunt":
		_refresh_hunting_minigame_visual(step, index, steps.size())
	_clear_children(tool_craft_actions_box)
	var options: Array = Array(step.get("options", [])).duplicate()
	options.shuffle()
	for raw_option in options:
		var option := String(raw_option)
		var button := _make_fishing_action_button(option) if active_action_id == "fish" else _make_hunting_action_button(option) if active_action_id == "hunt" else _make_button(option, Callable(self, "_on_action_minigame_option_pressed").bind(option), _action_minigame_option_icon(option))
		if active_action_id != "fish" and active_action_id != "hunt":
			button.custom_minimum_size = Vector2(118, 42)
			button.tooltip_text = _action_minigame_option_hint(option)
		tool_craft_actions_box.add_child(button)
	_update_action_minigame_progress()


func _on_action_minigame_option_pressed(option: String) -> void:
	_resolve_action_minigame_step(option)


func _resolve_action_minigame_step(option: String) -> void:
	if not bool(action_minigame.get("active", false)):
		return
	var steps: Array = action_minigame.get("steps", [])
	var index := int(action_minigame.get("index", 0))
	if index >= steps.size():
		_finish_action_minigame()
		return
	var step: Dictionary = steps[index]
	var correct := String(step.get("correct", ""))
	var near_options: Array = Array(step.get("near", []))
	var max_time := maxf(0.1, float(action_minigame.get("max_time", 3.0)))
	var time_ratio := clampf(float(action_minigame.get("time_left", 0.0)) / max_time, 0.0, 1.0)
	var timing := _action_minigame_timing_result()
	var score := int(action_minigame.get("score", 0))
	var mistakes := int(action_minigame.get("mistakes", 0))
	if option == correct:
		score += 10 + int(round(time_ratio * 5.0)) + int(timing.get("score", 0))
		if not bool(timing.get("in_zone", false)):
			mistakes += 1
		_play_screen_flash(Color(0.78, 0.68, 0.36), 0.08, 0.16)
	elif option != "" and near_options.has(option):
		score += 5 + int(round(float(int(timing.get("score", 0))) * 0.45))
		mistakes += 1
		_play_screen_flash(Color(0.70, 0.58, 0.34), 0.06, 0.16)
	else:
		score -= 8 if option != "" else 14
		mistakes += 1
		_play_screen_shake(2.8, 0.14)
		_play_screen_flash(Color(0.78, 0.28, 0.22), 0.10, 0.18)
	var state_delta := _apply_action_minigame_state(option, option == correct, near_options.has(option), timing)
	score += int(state_delta.get("score", 0))
	mistakes += int(state_delta.get("mistakes", 0))
	if String(action_minigame.get("action_id", "")) == "fish":
		_play_fishing_minigame_feedback(option == correct and bool(timing.get("in_zone", false)), option, timing)
	elif String(action_minigame.get("action_id", "")) == "hunt":
		_play_hunting_minigame_feedback(option == correct and bool(timing.get("in_zone", false)), option, timing)
	action_minigame["score"] = clampi(score, 0, 120)
	action_minigame["mistakes"] = mistakes
	action_minigame["index"] = index + 1
	if int(action_minigame.get("index", 0)) >= steps.size():
		_finish_action_minigame()
	else:
		_show_action_minigame_step()


func _finish_action_minigame() -> void:
	if not bool(action_minigame.get("active", false)):
		return
	var action_id := String(action_minigame.get("action_id", ""))
	var method_id := String(action_minigame.get("method_id", ""))
	var action_args: Dictionary = action_minigame.get("args", {}).duplicate(true)
	var steps: Array = action_minigame.get("steps", [])
	var max_score := maxi(1, steps.size() * 25)
	var raw_score := int(action_minigame.get("score", 0)) + _action_minigame_final_state_bonus(action_id)
	var score := clampi(int(round(float(raw_score) / float(max_score) * 100.0)), 0, 100)
	if CharacterManager.is_partner_following() and _can_use_partner_mode_for_action(action_id):
		score = clampi(score + 6, 0, 100)
	var mistakes := int(action_minigame.get("mistakes", 0))
	var result := {
		"score": score,
		"mistakes": mistakes,
		"grade": _action_minigame_grade(score),
		"grade_text": _action_minigame_grade_text(score),
		"state_text": _action_minigame_final_state_text(action_id),
		"passed": score >= 35
	}
	action_minigame.clear()
	_set_action_minigame_meter_visible(false)
	if fishing_visual_tween != null and fishing_visual_tween.is_valid():
		fishing_visual_tween.kill()
	if hunting_visual_tween != null and hunting_visual_tween.is_valid():
		hunting_visual_tween.kill()
	if tool_craft_layer != null:
		tool_craft_layer.visible = false
	action_args["method_id"] = method_id
	action_args["minigame_result"] = result
	_append_log("%s 집중 판정: %s (%d)" % [_action_display_name(action_id), String(result.get("grade_text", "보통")), score])
	_perform_tile_action(action_id, action_args)


func _cancel_action_minigame() -> void:
	if action_minigame.is_empty():
		return
	var action_id := String(action_minigame.get("action_id", ""))
	action_minigame.clear()
	_set_action_minigame_meter_visible(false)
	if fishing_visual_tween != null and fishing_visual_tween.is_valid():
		fishing_visual_tween.kill()
	if hunting_visual_tween != null and hunting_visual_tween.is_valid():
		hunting_visual_tween.kill()
	if tool_craft_layer != null:
		tool_craft_layer.visible = false
	_append_log("%s을/를 멈췄다. 시간과 기력은 쓰지 않았다." % _action_display_name(action_id))
	_refresh_sensory_feedback()


func _cancel_active_minigame() -> void:
	if bool(action_minigame.get("active", false)) or bool(action_minigame.get("preparing", false)):
		_cancel_action_minigame()
		return
	_cancel_tool_craft_minigame()


func _update_action_minigame_progress() -> void:
	if tool_craft_progress == null or tool_craft_quality_label == null:
		return
	var max_time := maxf(0.1, float(action_minigame.get("max_time", 3.0)))
	var time_left := clampf(float(action_minigame.get("time_left", max_time)), 0.0, max_time)
	tool_craft_progress.value = time_left / max_time * 100.0
	var steps: Array = action_minigame.get("steps", [])
	var max_score := maxi(1, steps.size() * 25)
	var score := clampi(int(round(float(int(action_minigame.get("score", 0))) / float(max_score) * 100.0)), 0, 100)
	tool_craft_quality_label.text = "%s / 실수 %d" % [_action_minigame_score_text(score), int(action_minigame.get("mistakes", 0))]
	if tool_craft_hint_label != null:
		tool_craft_hint_label.text = "남은 %.1f초" % time_left
	_update_action_minigame_meter_visual()


func _set_action_minigame_meter_visible(visible: bool) -> void:
	if action_minigame_meter_box != null:
		action_minigame_meter_box.visible = visible


func _tick_action_minigame(delta: float) -> void:
	var time_left := float(action_minigame.get("time_left", 0.0)) - delta
	action_minigame["time_left"] = time_left
	var phase := float(action_minigame.get("meter_phase", 0.0))
	var speed := float(action_minigame.get("meter_speed", 1.0))
	phase += delta * speed * TAU
	action_minigame["meter_phase"] = phase
	action_minigame["meter_value"] = 50.0 + sin(phase) * 50.0
	var action_id := String(action_minigame.get("action_id", ""))
	if action_id == "fish":
		var tension := float(action_minigame.get("tension", 50.0))
		tension += sin(phase * 0.55) * delta * 5.0
		action_minigame["tension"] = clampf(tension, 0.0, 100.0)
	elif action_id == "hunt":
		var noise := float(action_minigame.get("noise", 22.0))
		noise += delta * (1.4 + float(action_minigame.get("index", 0)) * 0.35)
		action_minigame["noise"] = clampf(noise, 0.0, 100.0)


func _update_action_minigame_meter_visual() -> void:
	if action_minigame_meter_bar == null:
		return
	var meter := clampf(float(action_minigame.get("meter_value", 50.0)), 0.0, 100.0)
	var center := float(action_minigame.get("target_center", 50.0))
	var width := float(action_minigame.get("target_width", 26.0))
	var low := clampf(center - width * 0.5, 0.0, 100.0)
	var high := clampf(center + width * 0.5, 0.0, 100.0)
	action_minigame_meter_bar.value = meter
	if action_minigame_meter_label != null:
		action_minigame_meter_label.text = "타이밍 %.0f / 목표 %.0f-%.0f" % [meter, low, high]
	if action_minigame_state_label != null:
		var action_id := String(action_minigame.get("action_id", ""))
		if action_id == "fish":
			if action_minigame_meter_label != null:
				action_minigame_meter_label.text = "찌가 밝은 물결 안에 들어올 때 선택"
			action_minigame_state_label.text = "줄 %s / 입질 %s" % [
				_fishing_tension_text(float(action_minigame.get("tension", 50.0))),
				_fishing_hook_text(float(action_minigame.get("hook_progress", 0.0)))
			]
			_update_fishing_minigame_visual()
		elif action_id == "hunt":
			if action_minigame_meter_label != null:
				action_minigame_meter_label.text = "흔적 표식이 밝은 길 안에 들어올 때 선택"
			action_minigame_state_label.text = "거리 %s / 기척 %s" % [
				_hunting_distance_text(float(action_minigame.get("distance", 74.0))),
				_hunting_noise_text(float(action_minigame.get("noise", 22.0)))
			]
			_update_hunting_minigame_visual()
		else:
			action_minigame_state_label.text = ""


func _refresh_fishing_minigame_visual(step: Dictionary, index: int, total_steps: int) -> void:
	if fishing_visual_frame == null:
		return
	fishing_visual_frame.visible = true
	if fishing_bobber_label != null:
		fishing_bobber_label.text = _fishing_step_symbol(String(step.get("correct", "")))
	if fishing_visual_flash != null:
		fishing_visual_flash.color = Color(1, 1, 1, 0)
	if fishing_ripple_ring != null:
		var color := _fishing_option_color(String(step.get("correct", "")))
		fishing_ripple_ring.add_theme_stylebox_override("panel", _make_panel_style(Color(color.r, color.g, color.b, 0.04), Color(color.r, color.g, color.b, 0.56), 99))
	if tool_craft_step_label != null:
		tool_craft_step_label.text = "%d / %d  %s" % [index + 1, total_steps, String(step.get("title", "입질"))]
	_update_fishing_minigame_visual()


func _update_fishing_minigame_visual() -> void:
	if fishing_visual_frame == null or not fishing_visual_frame.visible:
		return
	var frame_size := fishing_visual_frame.size
	if frame_size.x <= 1.0 or frame_size.y <= 1.0:
		call_deferred("_update_fishing_minigame_visual")
		return
	var meter := clampf(float(action_minigame.get("meter_value", 50.0)), 0.0, 100.0)
	var center := clampf(float(action_minigame.get("target_center", 50.0)), 0.0, 100.0)
	var width := maxf(6.0, float(action_minigame.get("target_width", 26.0)))
	var tension := clampf(float(action_minigame.get("tension", 50.0)), 0.0, 100.0)
	var hook := clampf(float(action_minigame.get("hook_progress", 0.0)), 0.0, 100.0)
	var phase := float(action_minigame.get("meter_phase", 0.0))
	var water_left := 94.0
	var water_right := maxf(water_left + 12.0, frame_size.x - 82.0)
	var x := lerpf(water_left, water_right, meter / 100.0)
	var y := frame_size.y * 0.58 - hook * 0.34 + sin(phase * 1.35) * 6.0 + (tension - 50.0) * 0.10
	y = clampf(y, frame_size.y * 0.24, frame_size.y * 0.78)
	var bobber_center := Vector2(x, y)
	if fishing_target_zone != null:
		var low := clampf(center - width * 0.5, 0.0, 100.0)
		var high := clampf(center + width * 0.5, 0.0, 100.0)
		var low_x := lerpf(water_left, water_right, low / 100.0)
		var high_x := lerpf(water_left, water_right, high / 100.0)
		fishing_target_zone.position = Vector2(low_x, frame_size.y * 0.22)
		fishing_target_zone.size = Vector2(maxf(20.0, high_x - low_x), frame_size.y * 0.56)
		var in_zone := meter >= low and meter <= high
		fishing_target_zone.color = Color(0.95, 0.90, 0.38, 0.22 if in_zone else 0.13)
	if fishing_bobber != null:
		fishing_bobber.size = Vector2(36, 36)
		fishing_bobber.position = bobber_center - fishing_bobber.size * 0.5
		fishing_bobber.pivot_offset = fishing_bobber.size * 0.5
		var tense_color := Color(0.96, 0.18, 0.12).lerp(Color(1.0, 0.76, 0.16), absf(tension - 50.0) / 50.0)
		fishing_bobber.add_theme_stylebox_override("panel", _make_panel_style(Color(tense_color.r, tense_color.g, tense_color.b, 0.96), Color(1.0, 0.95, 0.76, 0.92), 99))
	if fishing_ripple_ring != null:
		var ring_size := 54.0 + hook * 0.38 + absf(tension - 50.0) * 0.16
		fishing_ripple_ring.size = Vector2(ring_size, ring_size)
		fishing_ripple_ring.position = bobber_center - fishing_ripple_ring.size * 0.5
		fishing_ripple_ring.pivot_offset = fishing_ripple_ring.size * 0.5
		fishing_ripple_ring.modulate.a = clampf(0.35 + hook / 160.0, 0.32, 0.86)
	if fishing_line_visual != null:
		var start := Vector2(46.0, frame_size.y - 40.0)
		var delta := bobber_center - start
		fishing_line_visual.position = start
		fishing_line_visual.size = Vector2(maxf(8.0, delta.length()), 2.0)
		fishing_line_visual.pivot_offset = Vector2(0, 1)
		fishing_line_visual.rotation = delta.angle()
		fishing_line_visual.color = Color(0.95, 0.78, 0.38, 0.55 + absf(tension - 50.0) / 120.0)
	if fishing_tension_bar != null:
		fishing_tension_bar.value = tension
	if fishing_hook_bar != null:
		fishing_hook_bar.value = hook


func _make_fishing_action_button(option: String) -> Button:
	var button := _make_button(option, Callable(self, "_on_action_minigame_option_pressed").bind(option), _action_minigame_option_icon(option))
	button.custom_minimum_size = Vector2(118, 44)
	button.tooltip_text = _action_minigame_option_hint(option)
	_limit_button_icon(button, 22)
	var color := _fishing_option_color(option)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.035, 0.065, 0.070, 0.96), color.darkened(0.30), 8))
	button.add_theme_stylebox_override("hover", _make_panel_style(color.darkened(0.34), color, 8))
	button.add_theme_stylebox_override("pressed", _make_panel_style(color.darkened(0.10), color.lightened(0.22), 8))
	return button


func _play_fishing_minigame_feedback(success: bool, option: String, timing: Dictionary) -> void:
	if fishing_visual_frame == null or not fishing_visual_frame.visible:
		return
	if fishing_visual_tween != null and fishing_visual_tween.is_valid():
		fishing_visual_tween.kill()
	var color := Color(0.54, 0.90, 0.88) if success else Color(0.88, 0.30, 0.20)
	if option == "줄늦춤":
		color = Color(0.42, 0.72, 0.96) if success else color
	if fishing_visual_flash != null:
		fishing_visual_flash.color = Color(color.r, color.g, color.b, 0.28 if success else 0.38)
	if fishing_bobber != null:
		fishing_bobber.scale = Vector2(1, 1)
	if fishing_ripple_ring != null:
		fishing_ripple_ring.scale = Vector2(1, 1)
	fishing_visual_tween = create_tween()
	fishing_visual_tween.set_parallel(true)
	if fishing_visual_flash != null:
		fishing_visual_tween.tween_property(fishing_visual_flash, "color:a", 0.0, 0.32).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if fishing_bobber != null:
		var bobber_scale := Vector2(1.18, 1.18) if success else Vector2(0.82, 1.24)
		fishing_visual_tween.tween_property(fishing_bobber, "scale", bobber_scale, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		fishing_visual_tween.tween_property(fishing_bobber, "scale", Vector2(1, 1), 0.20).set_delay(0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if fishing_ripple_ring != null:
		fishing_visual_tween.tween_property(fishing_ripple_ring, "scale", Vector2(1.42, 1.42), 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		fishing_visual_tween.tween_property(fishing_ripple_ring, "scale", Vector2(1, 1), 0.20).set_delay(0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_spawn_fishing_splash(success, option, bool(timing.get("in_zone", false)))


func _spawn_fishing_splash(success: bool, option: String, in_zone: bool) -> void:
	if fishing_visual_frame == null or fishing_bobber == null:
		return
	var center := fishing_bobber.position + fishing_bobber.size * 0.5
	var particle_count := 8 if success else 5
	var color := Color(0.82, 0.97, 1.0, 0.92) if success else Color(1.0, 0.58, 0.40, 0.88)
	for index in range(particle_count):
		var dot := PanelContainer.new()
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dot.size = Vector2(8, 8)
		dot.position = center - dot.size * 0.5
		dot.add_theme_stylebox_override("panel", _make_panel_style(Color(color.r, color.g, color.b, 0.72), Color(color.r, color.g, color.b, 0.80), 99))
		fishing_visual_frame.add_child(dot)
		var angle := TAU * float(index) / float(maxi(1, particle_count)) + (0.18 if in_zone else -0.10)
		var distance := 24.0 + float(index % 3) * 8.0
		if option == "줄당김" or option == "챔질":
			distance += 10.0
		var target := center + Vector2(cos(angle), sin(angle)) * distance
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(dot, "position", target - dot.size * 0.5, 0.38).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(dot, "modulate:a", 0.0, 0.38).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.finished.connect(func() -> void:
			if is_instance_valid(dot):
				dot.queue_free()
		)


func _fishing_option_color(option: String) -> Color:
	match option:
		"던지기", "위치바꾸기":
			return Color(0.46, 0.76, 0.92)
		"기다리기", "발소리죽임":
			return Color(0.48, 0.82, 0.70)
		"챔질":
			return Color(0.92, 0.70, 0.30)
		"줄당김", "거두기":
			return Color(0.82, 0.54, 0.30)
		"줄늦춤":
			return Color(0.44, 0.62, 0.94)
	return Color(0.62, 0.78, 0.82)


func _fishing_step_symbol(option: String) -> String:
	match option:
		"던지기", "위치바꾸기":
			return "⌁"
		"기다리기", "발소리죽임":
			return "•"
		"챔질":
			return "!"
		"줄당김", "거두기":
			return "›"
		"줄늦춤":
			return "‹"
	return "•"


func _fishing_tension_text(value: float) -> String:
	if value < 20.0:
		return "느슨함"
	if value > 84.0:
		return "끊어질 듯함"
	if value > 66.0:
		return "팽팽함"
	if value < 36.0:
		return "조금 느슨함"
	return "안정"


func _fishing_hook_text(value: float) -> String:
	if value >= 78.0:
		return "거의 걸림"
	if value >= 52.0:
		return "묵직함"
	if value >= 24.0:
		return "살짝 당김"
	return "희미함"


func _refresh_hunting_minigame_visual(step: Dictionary, index: int, total_steps: int) -> void:
	if hunting_visual_frame == null:
		return
	hunting_visual_frame.visible = true
	if hunting_track_label != null:
		hunting_track_label.text = _hunting_step_symbol(String(step.get("correct", "")))
	if hunting_visual_flash != null:
		hunting_visual_flash.color = Color(1, 1, 1, 0)
	if hunting_noise_ring != null:
		var color := _hunting_option_color(String(step.get("correct", "")))
		hunting_noise_ring.add_theme_stylebox_override("panel", _make_panel_style(Color(color.r, color.g, color.b, 0.04), Color(color.r, color.g, color.b, 0.52), 99))
	if tool_craft_step_label != null:
		tool_craft_step_label.text = "%d / %d  %s" % [index + 1, total_steps, String(step.get("title", "흔적"))]
	_update_hunting_minigame_visual()


func _update_hunting_minigame_visual() -> void:
	if hunting_visual_frame == null or not hunting_visual_frame.visible:
		return
	var frame_size := hunting_visual_frame.size
	if frame_size.x <= 1.0 or frame_size.y <= 1.0:
		frame_size = Vector2(maxf(720.0, hunting_visual_frame.custom_minimum_size.x), maxf(232.0, hunting_visual_frame.custom_minimum_size.y))
	var meter := clampf(float(action_minigame.get("meter_value", 50.0)), 0.0, 100.0)
	var center := clampf(float(action_minigame.get("target_center", 50.0)), 0.0, 100.0)
	var width := maxf(6.0, float(action_minigame.get("target_width", 26.0)))
	var distance := clampf(float(action_minigame.get("distance", 74.0)), 0.0, 100.0)
	var noise := clampf(float(action_minigame.get("noise", 22.0)), 0.0, 100.0)
	var phase := float(action_minigame.get("meter_phase", 0.0))
	var trail_start := Vector2(82.0, frame_size.y * 0.76)
	var trail_end := Vector2(frame_size.x - 96.0, frame_size.y * 0.28)
	var trail_delta := trail_end - trail_start
	var low := clampf(center - width * 0.5, 0.0, 100.0)
	var high := clampf(center + width * 0.5, 0.0, 100.0)
	var marker_pos := trail_start.lerp(trail_end, meter / 100.0)
	marker_pos.y += sin(phase * 1.1) * 5.5
	marker_pos.x += cos(phase * 0.6) * 3.5
	if hunting_target_zone != null:
		var low_pos := trail_start.lerp(trail_end, low / 100.0)
		var high_pos := trail_start.lerp(trail_end, high / 100.0)
		var zone_length := maxf(28.0, low_pos.distance_to(high_pos))
		hunting_target_zone.position = low_pos.lerp(high_pos, 0.5) - Vector2(zone_length * 0.5, 15.0)
		hunting_target_zone.size = Vector2(zone_length, 30.0)
		hunting_target_zone.pivot_offset = Vector2(zone_length * 0.5, 15.0)
		hunting_target_zone.rotation = trail_delta.angle()
		var in_zone := meter >= low and meter <= high
		hunting_target_zone.color = Color(0.94, 0.76, 0.30, 0.24 if in_zone else 0.12)
	if hunting_track_marker != null:
		hunting_track_marker.size = Vector2(38, 38)
		hunting_track_marker.position = marker_pos - hunting_track_marker.size * 0.5
		hunting_track_marker.pivot_offset = hunting_track_marker.size * 0.5
		var alert_color := Color(0.60, 0.86, 0.42).lerp(Color(0.92, 0.34, 0.20), noise / 100.0)
		hunting_track_marker.add_theme_stylebox_override("panel", _make_panel_style(Color(0.05, 0.08, 0.035, 0.92), alert_color, 99))
	if hunting_noise_ring != null:
		var ring_size := 48.0 + noise * 0.82
		hunting_noise_ring.size = Vector2(ring_size, ring_size)
		hunting_noise_ring.position = marker_pos - hunting_noise_ring.size * 0.5
		hunting_noise_ring.pivot_offset = hunting_noise_ring.size * 0.5
		hunting_noise_ring.modulate.a = clampf(0.24 + noise / 130.0, 0.22, 0.92)
	if hunting_wind_arrow != null:
		hunting_wind_arrow.rotation = -0.45 + sin(phase * 0.28) * 0.16
		hunting_wind_arrow.modulate = Color(0.80, 0.96, 0.66, clampf(0.50 + (100.0 - noise) / 170.0, 0.50, 0.92))
	if hunting_distance_bar != null:
		hunting_distance_bar.value = 100.0 - distance
	if hunting_noise_bar != null:
		hunting_noise_bar.value = noise


func _make_hunting_action_button(option: String) -> Button:
	var button := _make_button(option, Callable(self, "_on_action_minigame_option_pressed").bind(option), _action_minigame_option_icon(option))
	button.custom_minimum_size = Vector2(118, 44)
	button.tooltip_text = _action_minigame_option_hint(option)
	_limit_button_icon(button, 22)
	var color := _hunting_option_color(option)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.040, 0.055, 0.035, 0.96), color.darkened(0.30), 8))
	button.add_theme_stylebox_override("hover", _make_panel_style(color.darkened(0.36), color, 8))
	button.add_theme_stylebox_override("pressed", _make_panel_style(color.darkened(0.08), color.lightened(0.22), 8))
	return button


func _play_hunting_minigame_feedback(success: bool, option: String, timing: Dictionary) -> void:
	if hunting_visual_frame == null or not hunting_visual_frame.visible:
		return
	if hunting_visual_tween != null and hunting_visual_tween.is_valid():
		hunting_visual_tween.kill()
	var color := Color(0.70, 0.90, 0.42) if success else Color(0.86, 0.30, 0.20)
	if ["몸낮추기", "바람보기", "발자국", "멈추기"].has(option) and success:
		color = Color(0.54, 0.84, 0.62)
	if hunting_visual_flash != null:
		hunting_visual_flash.color = Color(color.r, color.g, color.b, 0.26 if success else 0.40)
	if hunting_track_marker != null:
		hunting_track_marker.scale = Vector2(1, 1)
	if hunting_noise_ring != null:
		hunting_noise_ring.scale = Vector2(1, 1)
	hunting_visual_tween = create_tween()
	hunting_visual_tween.set_parallel(true)
	if hunting_visual_flash != null:
		hunting_visual_tween.tween_property(hunting_visual_flash, "color:a", 0.0, 0.34).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if hunting_track_marker != null:
		var marker_scale := Vector2(1.14, 1.14) if success else Vector2(1.26, 0.82)
		hunting_visual_tween.tween_property(hunting_track_marker, "scale", marker_scale, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		hunting_visual_tween.tween_property(hunting_track_marker, "scale", Vector2(1, 1), 0.20).set_delay(0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if hunting_noise_ring != null:
		var ring_scale := Vector2(1.18, 1.18) if success else Vector2(1.58, 1.58)
		hunting_visual_tween.tween_property(hunting_noise_ring, "scale", ring_scale, 0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		hunting_visual_tween.tween_property(hunting_noise_ring, "scale", Vector2(1, 1), 0.20).set_delay(0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_spawn_hunting_leaf_dust(success, option, bool(timing.get("in_zone", false)))


func _spawn_hunting_leaf_dust(success: bool, option: String, in_zone: bool) -> void:
	if hunting_visual_frame == null or hunting_track_marker == null:
		return
	var center := hunting_track_marker.position + hunting_track_marker.size * 0.5
	var count := 7 if success else 11
	var color := Color(0.72, 0.86, 0.38, 0.82) if success else Color(0.86, 0.52, 0.28, 0.86)
	for index in range(count):
		var leaf := ColorRect.new()
		leaf.mouse_filter = Control.MOUSE_FILTER_IGNORE
		leaf.color = color
		leaf.size = Vector2(10, 4)
		leaf.position = center - leaf.size * 0.5
		leaf.rotation = randf_range(-0.8, 0.8)
		hunting_visual_frame.add_child(leaf)
		var direction := Vector2(cos(TAU * float(index) / float(maxi(1, count))), sin(TAU * float(index) / float(maxi(1, count))))
		if option == "후퇴":
			direction.x -= 0.7
		elif ["몰아넣기", "거리좁힘", "찌르기", "쏘기"].has(option):
			direction.x += 0.7
		var distance := 26.0 + float(index % 4) * 9.0 + (12.0 if not success else 0.0)
		var target := center + direction.normalized() * distance
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(leaf, "position", target - leaf.size * 0.5, 0.40).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(leaf, "rotation", leaf.rotation + randf_range(-1.2, 1.2), 0.40)
		tween.tween_property(leaf, "modulate:a", 0.0, 0.40).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.finished.connect(func() -> void:
			if is_instance_valid(leaf):
				leaf.queue_free()
		)


func _hunting_option_color(option: String) -> Color:
	match option:
		"발자국", "바람보기":
			return Color(0.58, 0.82, 0.46)
		"몸낮추기", "멈추기":
			return Color(0.44, 0.70, 0.52)
		"거리좁힘", "몰아넣기":
			return Color(0.84, 0.64, 0.32)
		"찌르기", "쏘기":
			return Color(0.82, 0.42, 0.28)
		"후퇴":
			return Color(0.48, 0.62, 0.72)
	return Color(0.68, 0.74, 0.48)


func _hunting_step_symbol(option: String) -> String:
	match option:
		"발자국":
			return "⌾"
		"바람보기":
			return "↗"
		"몸낮추기", "멈추기":
			return "•"
		"몰아넣기", "거리좁힘":
			return "›"
		"찌르기", "쏘기":
			return "!"
		"후퇴":
			return "‹"
	return "⌾"


func _hunting_distance_text(value: float) -> String:
	if value <= 18.0:
		return "눈앞"
	if value <= 38.0:
		return "가까움"
	if value <= 64.0:
		return "중간"
	return "멀리"


func _hunting_noise_text(value: float) -> String:
	if value >= 82.0:
		return "들킬 듯함"
	if value >= 60.0:
		return "거슬림"
	if value >= 34.0:
		return "낮음"
	return "숨죽임"


func _action_minigame_steps(action_id: String, method_id: String) -> Array[Dictionary]:
	match action_id:
		"fish":
			match method_id:
				"quick":
					return [
						{"title": "던질 자리", "prompt": "물결이 겹치는 작은 그림자에 낚싯줄을 던진다.", "correct": "던지기", "near": ["기다리기"], "options": ["던지기", "챔질", "줄당김"]},
						{"title": "첫 떨림", "prompt": "줄 끝이 짧게 떨린다. 너무 빨리 당기면 빠져나간다.", "correct": "기다리기", "near": ["줄늦춤"], "options": ["챔질", "기다리기", "줄늦춤"]},
						{"title": "입질", "prompt": "물속 그림자가 방향을 바꿨다.", "correct": "챔질", "near": ["줄당김"], "options": ["기다리기", "챔질", "줄늦춤"]},
						{"title": "마무리", "prompt": "얕은 물가까지 끌어낼 순간이다.", "correct": "줄당김", "near": ["거두기"], "options": ["줄당김", "줄늦춤", "거두기"]}
					]
				"quiet":
					return [
						{"title": "발소리", "prompt": "물가의 모래가 삐걱거린다. 기척을 낮춰야 한다.", "correct": "발소리죽임", "near": ["기다리기"], "options": ["발소리죽임", "위치바꾸기", "던지기"]},
						{"title": "그늘", "prompt": "물고기가 그늘 쪽으로 붙는다.", "correct": "던지기", "near": ["기다리기"], "options": ["던지기", "줄당김", "챔질"]},
						{"title": "줄 조절", "prompt": "줄이 팽팽해지며 손끝이 당긴다.", "correct": "줄늦춤", "near": ["기다리기"], "options": ["줄늦춤", "챔질", "거두기"]},
						{"title": "챔질", "prompt": "짧고 확실한 입질이 온다.", "correct": "챔질", "near": ["줄당김"], "options": ["기다리기", "챔질", "줄늦춤"]}
					]
			return [
				{"title": "물결 읽기", "prompt": "잔물결 사이로 작은 그림자가 지나간다.", "correct": "기다리기", "near": ["던지기"], "options": ["기다리기", "챔질", "줄당김"]},
				{"title": "자리 잡기", "prompt": "바람이 줄을 밀어낸다. 어느 쪽으로 맞출까?", "correct": "던지기", "near": ["위치바꾸기"], "options": ["던지기", "줄늦춤", "거두기"]},
				{"title": "팽팽한 줄", "prompt": "물속에서 방향이 바뀌며 줄이 세게 당겨진다.", "correct": "줄늦춤", "near": ["줄당김"], "options": ["줄당김", "줄늦춤", "챔질"]},
				{"title": "끌어내기", "prompt": "힘이 빠진 물고기가 얕은 곳으로 밀려온다.", "correct": "줄당김", "near": ["거두기"], "options": ["줄당김", "기다리기", "거두기"]}
			]
		"hunt":
			match method_id:
				"drive":
					return [
						{"title": "바람", "prompt": "짐승이 냄새를 맡기 전에 바람 방향을 본다.", "correct": "바람보기", "near": ["몸낮추기"], "options": ["바람보기", "몰아넣기", "찌르기"]},
						{"title": "몰이", "prompt": "열린 길로 몰아붙일 타이밍이다.", "correct": "몰아넣기", "near": ["거리좁힘"], "options": ["몰아넣기", "후퇴", "멈추기"]},
						{"title": "거리", "prompt": "달아나는 방향이 꺾였다. 마지막 거리를 좁힌다.", "correct": "거리좁힘", "near": ["몸낮추기"], "options": ["거리좁힘", "바람보기", "후퇴"]},
						{"title": "마무리", "prompt": "도구가 닿을 만큼 가까워졌다.", "correct": "찌르기", "near": ["쏘기"], "options": ["찌르기", "멈추기", "후퇴"]}
					]
				"cautious":
					return [
						{"title": "흔적", "prompt": "발자국 옆으로 작은 피난길이 보인다.", "correct": "발자국", "near": ["바람보기"], "options": ["발자국", "몰아넣기", "찌르기"]},
						{"title": "기척", "prompt": "덤불 안쪽에서 숨소리가 들린다.", "correct": "몸낮추기", "near": ["멈추기"], "options": ["몸낮추기", "거리좁힘", "몰아넣기"]},
						{"title": "판단", "prompt": "너무 가까워지면 역으로 다칠 수 있다.", "correct": "멈추기", "near": ["후퇴"], "options": ["찌르기", "멈추기", "거리좁힘"]},
						{"title": "기회", "prompt": "짧은 빈틈이 생겼다. 안전하게 마무리한다.", "correct": "쏘기", "near": ["찌르기"], "options": ["쏘기", "몰아넣기", "후퇴"]}
					]
			return [
				{"title": "발자국", "prompt": "젖은 흙 위의 발자국이 어느 방향으로 이어질까?", "correct": "발자국", "near": ["바람보기"], "options": ["발자국", "몰아넣기", "찌르기"]},
				{"title": "바람", "prompt": "냄새가 흘러가는 방향을 확인한다.", "correct": "바람보기", "near": ["몸낮추기"], "options": ["바람보기", "거리좁힘", "후퇴"]},
				{"title": "접근", "prompt": "낮은 풀 사이로 기척을 숨기며 다가간다.", "correct": "몸낮추기", "near": ["거리좁힘"], "options": ["몰아넣기", "몸낮추기", "찌르기"]},
				{"title": "결정", "prompt": "도구를 쓸 수 있는 마지막 거리다.", "correct": "찌르기", "near": ["쏘기"], "options": ["찌르기", "멈추기", "후퇴"]}
			]
	return []


func _action_minigame_time_limit(action_id: String, method_id: String) -> float:
	if action_id == "fish":
		if method_id == "quick":
			return 2.2
		if method_id == "quiet":
			return 3.3
		return 3.0
	if action_id == "hunt":
		if method_id == "drive":
			return 2.4
		if method_id == "cautious":
			return 3.4
		return 2.8
	return 3.0


func _action_minigame_timing_profile(action_id: String, method_id: String, index: int) -> Dictionary:
	var centers := [48.0, 56.0, 44.0, 62.0]
	var center := float(centers[index % centers.size()])
	var width := 28.0
	var speed := 0.82 + float(index) * 0.10
	if action_id == "fish":
		if method_id == "quick":
			width = 20.0
			speed += 0.36
		elif method_id == "quiet":
			width = 32.0
			speed -= 0.12
		if ["챔질", "줄당김"].has(String(_action_minigame_current_step().get("correct", ""))):
			center += 7.0
	elif action_id == "hunt":
		if method_id == "drive":
			width = 20.0
			speed += 0.42
		elif method_id == "cautious":
			width = 34.0
			speed -= 0.10
		if ["찌르기", "쏘기"].has(String(_action_minigame_current_step().get("correct", ""))):
			center += 10.0
	return {
		"center": clampf(center, 20.0, 80.0),
		"width": width,
		"speed": maxf(0.45, speed)
	}


func _action_minigame_current_step() -> Dictionary:
	var steps: Array = action_minigame.get("steps", [])
	var index := int(action_minigame.get("index", 0))
	if index < 0 or index >= steps.size():
		return {}
	return steps[index]


func _action_minigame_timing_result() -> Dictionary:
	var meter := clampf(float(action_minigame.get("meter_value", 50.0)), 0.0, 100.0)
	var center := float(action_minigame.get("target_center", 50.0))
	var width := maxf(6.0, float(action_minigame.get("target_width", 26.0)))
	var half_width := width * 0.5
	var distance := absf(meter - center)
	if distance <= half_width * 0.32:
		return {"grade": "perfect", "score": 10, "in_zone": true}
	if distance <= half_width:
		return {"grade": "good", "score": 6, "in_zone": true}
	if distance <= half_width * 1.65:
		return {"grade": "near", "score": 1, "in_zone": false}
	return {"grade": "miss", "score": -5, "in_zone": false}


func _apply_action_minigame_state(option: String, correct: bool, near: bool, timing: Dictionary) -> Dictionary:
	var action_id := String(action_minigame.get("action_id", ""))
	var in_zone := bool(timing.get("in_zone", false))
	var score_delta := 0
	var mistake_delta := 0
	if action_id == "fish":
		var tension := float(action_minigame.get("tension", 50.0))
		var hook := float(action_minigame.get("hook_progress", 0.0))
		match option:
			"챔질":
				tension += 14.0
				hook += 18.0 if correct and in_zone else 6.0
			"줄당김", "거두기":
				tension += 12.0
				hook += 16.0 if correct and in_zone else 5.0
			"줄늦춤":
				tension -= 20.0
				hook += 8.0 if correct else -3.0
			"기다리기", "발소리죽임":
				tension = lerpf(tension, 50.0, 0.24)
				hook += 10.0 if correct and in_zone else 2.0
			"던지기":
				hook += 12.0 if correct and in_zone else 4.0
			_:
				tension += 8.0
		if correct and in_zone:
			tension = lerpf(tension, 50.0, 0.18)
			score_delta += 4
		if tension < 15.0 or tension > 88.0:
			score_delta -= 8
			mistake_delta += 1
			_play_screen_shake(2.0, 0.10)
		action_minigame["tension"] = clampf(tension, 0.0, 100.0)
		action_minigame["hook_progress"] = clampf(hook, 0.0, 100.0)
	elif action_id == "hunt":
		var distance := float(action_minigame.get("distance", 74.0))
		var noise := float(action_minigame.get("noise", 22.0))
		if correct and in_zone:
			distance -= 16.0
			noise -= 7.0
			score_delta += 4
		elif near:
			distance -= 7.0
			noise += 5.0
		else:
			distance += 5.0
			noise += 16.0
		match option:
			"몸낮추기", "바람보기", "발자국", "멈추기":
				noise -= 4.0
			"몰아넣기", "거리좁힘":
				distance -= 8.0
				noise += 9.0
			"찌르기", "쏘기":
				distance -= 12.0 if in_zone else -4.0
				noise += 8.0
			"후퇴":
				distance += 12.0
				noise -= 8.0
		if noise >= 82.0:
			score_delta -= 10
			mistake_delta += 1
			_play_screen_shake(2.4, 0.12)
		action_minigame["distance"] = clampf(distance, 0.0, 100.0)
		action_minigame["noise"] = clampf(noise, 0.0, 100.0)
	return {"score": score_delta, "mistakes": mistake_delta}


func _action_minigame_final_state_bonus(action_id: String) -> int:
	if action_id == "fish":
		var tension := float(action_minigame.get("tension", 50.0))
		var hook := float(action_minigame.get("hook_progress", 0.0))
		return int(round(hook * 0.16 - absf(tension - 50.0) * 0.20))
	if action_id == "hunt":
		var distance := float(action_minigame.get("distance", 74.0))
		var noise := float(action_minigame.get("noise", 22.0))
		return int(round((100.0 - distance) * 0.12 - noise * 0.18))
	return 0


func _action_minigame_final_state_text(action_id: String) -> String:
	if action_id == "fish":
		return "긴장 %.0f / 걸림 %.0f" % [
			float(action_minigame.get("tension", 50.0)),
			float(action_minigame.get("hook_progress", 0.0))
		]
	if action_id == "hunt":
		return "거리 %.0f / 기척 %.0f" % [
			float(action_minigame.get("distance", 74.0)),
			float(action_minigame.get("noise", 22.0))
		]
	return ""


func _action_minigame_score_text(score: int) -> String:
	return "집중 %d (%s)" % [score, _action_minigame_grade_text(score)]


func _action_minigame_footer(action_id: String) -> String:
	if action_id == "fish":
		return "낚시는 줄의 긴장과 타이밍을 본다. 집중도가 높을수록 성공률과 추가 어획 기회가 오른다."
	if action_id == "hunt":
		return "사냥은 흔적, 바람, 거리 판단을 본다. 집중도가 낮으면 실패하거나 먹잇감이 달아날 가능성이 커진다."
	return "집중도가 행동 결과에 반영된다."


func _action_minigame_partner_note(action_id: String) -> String:
	if CharacterManager.is_partner_following() and _can_use_partner_mode_for_action(action_id):
		return "동행자가 옆에서 기척을 살펴 집중을 조금 보태준다."
	return "짧은 순간의 판단이 결과를 바꾼다."


func _action_minigame_option_icon(option: String) -> String:
	match option:
		"던지기", "줄늦춤", "줄당김", "거두기":
			return "actions/fish"
		"챔질":
			return "items/simple_fishing_rod"
		"기다리기", "멈추기":
			return "actions/rest"
		"발소리죽임", "몸낮추기":
			return "actions/investigate"
		"위치바꾸기", "거리좁힘", "후퇴":
			return "actions/move"
		"발자국", "바람보기":
			return "res://assets/icons/tile_memory/animal_tracks.png"
		"몰아넣기":
			return "actions/gather"
		"찌르기":
			return "items/wooden_spear"
		"쏘기":
			return "items/simple_bow"
	return "actions/investigate"


func _action_minigame_option_hint(option: String) -> String:
	match option:
		"던지기":
			return "그림자가 지나는 곳으로 줄을 던진다."
		"기다리기":
			return "성급하게 당기지 않고 물결을 본다."
		"챔질":
			return "입질이 확실할 때 짧게 당긴다."
		"줄늦춤":
			return "줄의 긴장을 풀어 빠져나가지 않게 한다."
		"줄당김", "거두기":
			return "힘이 빠진 순간 천천히 끌어낸다."
		"발자국":
			return "흔적의 방향과 오래된 정도를 읽는다."
		"바람보기":
			return "냄새와 소리가 흘러가는 방향을 본다."
		"몸낮추기":
			return "기척을 줄이고 접근한다."
		"몰아넣기":
			return "위험을 감수하고 열린 쪽으로 몰아간다."
		"찌르기", "쏘기":
			return "도구가 닿는 순간을 노린다."
		"후퇴":
			return "위험하면 거리를 벌린다."
	return "상황에 맞는 판단을 고른다."


func _action_minigame_grade(score: int) -> String:
	if score >= 85:
		return "excellent"
	if score >= 65:
		return "good"
	if score >= 40:
		return "rough"
	if score >= 20:
		return "poor"
	return "failed"


func _action_minigame_grade_text(score: int) -> String:
	if score >= 85:
		return "완벽한 집중"
	if score >= 65:
		return "안정적"
	if score >= 40:
		return "아슬아슬"
	if score >= 20:
		return "흐트러짐"
	return "놓침"


func _show_base_view() -> void:
	var tile = WorldManager.get_current_tile()
	if tile != null and bool(tile.get("is_base", false)):
		GameState.set_flag("entered_base", true)
	if tool_menu_panel != null and tool_menu_panel.visible:
		_hide_tool_menu()
	if base_view_tween != null and base_view_tween.is_valid():
		base_view_tween.kill()
	base_view_panel.visible = true
	base_view_panel.modulate = Color(1, 1, 1, 0)
	base_view_panel.position = Vector2(0, 10)
	if map_info_panel != null:
		map_info_panel.visible = false
	base_view_panel.move_to_front()
	if base_drop_overlay != null:
		base_drop_overlay.move_to_front()
	_refresh_base_view()
	base_view_tween = create_tween()
	base_view_tween.set_parallel(true)
	base_view_tween.tween_property(base_view_panel, "modulate", Color(1, 1, 1, 1), 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	base_view_tween.tween_property(base_view_panel, "position", Vector2.ZERO, 0.24).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _hide_base_view() -> void:
	if base_view_panel == null:
		return
	if base_view_tween != null and base_view_tween.is_valid():
		base_view_tween.kill()
	if map_info_panel != null:
		map_info_panel.visible = true
	if base_drop_overlay != null:
		base_drop_overlay.clear_drag_hint()
		base_drop_overlay.setup_drop_surface("base_direct", WorldManager.current_tile_id, ["inventory"], false)
	base_view_tween = create_tween()
	base_view_tween.set_parallel(true)
	base_view_tween.tween_property(base_view_panel, "modulate", Color(1, 1, 1, 0), 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	base_view_tween.tween_property(base_view_panel, "position", Vector2(0, 8), 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	base_view_tween.chain().tween_callback(func() -> void:
		if base_view_panel != null:
			base_view_panel.visible = false
			base_view_panel.position = Vector2.ZERO
			base_view_panel.modulate = Color(1, 1, 1, 1)
	)


func _on_context_partner_toggled(enabled: bool) -> void:
	action_together_enabled = enabled and CharacterManager.partner_joined
	if selected_tile_id != "":
		_open_tile_context_menu(selected_tile_id)


func _toggle_tool_menu(menu_id: String) -> void:
	if active_tool_menu == menu_id and tool_menu_panel.visible:
		_hide_tool_menu()
		return
	active_tool_menu = menu_id
	tool_menu_panel.visible = true
	_fit_tool_menu_panel()
	tool_menu_panel.move_to_front()
	_refresh_tool_menu(menu_id)
	_fit_tool_menu_panel()


func _hide_tool_menu() -> void:
	active_tool_menu = ""
	tool_menu_panel.visible = false


func _refresh_tool_menu(menu_id: String) -> void:
	_clear_children(tool_menu_content)
	match menu_id:
		"inventory":
			tool_menu_title_label.text = "인벤토리"
			_populate_inventory_menu()
		"tools":
			tool_menu_title_label.text = "도구"
			_populate_tools_menu()
		"craft":
			tool_menu_title_label.text = "제작"
			_populate_craft_menu()
		"map":
			tool_menu_title_label.text = "지도"
			_populate_map_menu()
		"base":
			tool_menu_title_label.text = "거점"
			_populate_base_menu()
		"log":
			tool_menu_title_label.text = "로그"
			_populate_log_menu()
		"sleep":
			tool_menu_title_label.text = "수면"
			_populate_sleep_menu()
		"system":
			tool_menu_title_label.text = "상세 / 시스템"
			_populate_system_menu()
		"settings":
			tool_menu_title_label.text = "설정"
			_populate_settings_menu()
		"partner":
			tool_menu_title_label.text = "파트너 대화"
			_populate_partner_dialogue_menu()


func _populate_inventory_menu() -> void:
	_populate_inventory_owner_section("player", "플레이어 소지품")
	if CharacterManager.partner_joined:
		_populate_inventory_owner_section("partner", "파트너 소지품")


func _make_inventory_sort_bar() -> PanelContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sort_defs := [
		{"id": "order", "text": "입수순", "hint": "아이템이 들어온 순서대로 본다."},
		{"id": "name", "text": "이름", "hint": "이름순으로 정렬한다."},
		{"id": "amount", "text": "수량", "hint": "많이 가진 아이템부터 본다."},
		{"id": "category", "text": "분류", "hint": "도구, 음식, 재료 같은 분류로 묶어 본다."}
	]
	for sort_def in sort_defs:
		var sort_id := String(sort_def.get("id", "order"))
		var button := _make_compact_button(String(sort_def.get("text", sort_id)), Callable(self, "_set_inventory_sort_mode").bind(sort_id), "items/storage_box", Vector2(62, 24))
		button.toggle_mode = true
		button.button_pressed = sort_id == inventory_sort_mode
		button.tooltip_text = String(sort_def.get("hint", ""))
		row.add_child(button)
	return _make_overlay_content_panel(row)


func _set_inventory_sort_mode(sort_mode: String) -> void:
	inventory_sort_mode = sort_mode
	if active_tool_menu == "inventory":
		_refresh_tool_menu("inventory")


func _populate_inventory_owner_section(owner_id: String, title_text: String) -> void:
	var title := _small_title(title_text)
	title.add_theme_font_size_override("font_size", 14)
	tool_menu_content.add_child(title)
	tool_menu_content.add_child(_make_inventory_sort_bar())
	var target_items := InventoryManager.get_items(owner_id)
	var keys := InventoryManager.get_ordered_item_ids(owner_id, inventory_sort_mode)
	tool_menu_content.add_child(_make_carry_weight_panel(false, owner_id))
	if keys.is_empty():
		var empty := _create_body_label()
		empty.text = "비어 있음"
		tool_menu_content.add_child(empty)
		return
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		var icon_path := ""
		if item != null:
			display_name = item.display_name
			icon_path = item.icon_path
		var row := _make_item_chip(display_name, int(target_items[item_id]), icon_path)
		if item != null and item.tags.has("guide"):
			row.add_child(_make_button("읽기", Callable(self, "_show_survival_guide"), "actions/investigate"))
		elif item != null and _item_is_directly_usable(item):
			var use_target := "partner" if owner_id == "partner" else "player"
			var use_button := _make_button("사용", Callable(self, "_on_use_item_pressed").bind(item_id, use_target, owner_id))
			use_button.disabled = owner_id == "partner" and not InventoryManager.can_access_partner_inventory()
			row.add_child(use_button)
			if CharacterManager.partner_joined and owner_id == "player":
				var partner_button := _make_button("파트너", Callable(self, "_on_use_item_pressed").bind(item_id, "partner", owner_id))
				partner_button.disabled = not _can_talk_to_partner()
				row.add_child(partner_button)
		var transfer_owner := "partner" if owner_id == "player" else "player"
		var transfer_button := _make_button("넘김" if owner_id == "player" else "받기", Callable(self, "_on_transfer_item_pressed").bind(item_id, 1, owner_id, transfer_owner), "actions/assist")
		transfer_button.disabled = not InventoryManager.can_access_partner_inventory()
		transfer_button.tooltip_text = "%s에게 1개 옮기기" % InventoryManager.get_owner_display_name(transfer_owner)
		row.add_child(transfer_button)
		var drop_one_button := _make_button("놓기", Callable(self, "_on_drop_item_pressed").bind(item_id, 1, owner_id), "actions/place")
		drop_one_button.tooltip_text = "현재 타일에 1개 내려놓기"
		drop_one_button.disabled = owner_id == "partner" and not InventoryManager.can_access_partner_inventory()
		row.add_child(drop_one_button)
		if int(target_items[item_id]) > 1:
			var drop_all_button := _make_button("전부", Callable(self, "_on_drop_item_pressed").bind(item_id, int(target_items[item_id]), owner_id), "actions/place")
			drop_all_button.tooltip_text = "현재 타일에 전부 내려놓기"
			drop_all_button.disabled = owner_id == "partner" and not InventoryManager.can_access_partner_inventory()
			row.add_child(drop_all_button)
		tool_menu_content.add_child(row)


func _populate_tools_menu() -> void:
	var found := false
	var keys := InventoryManager.items.keys()
	keys.sort()
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var item = InventoryManager.get_item_data(item_id)
		if item == null:
			continue
		if item.category != "tool" and not item.tags.has("tool") and not item.tags.has("placeable"):
			continue
		found = true
		tool_menu_content.add_child(_make_tool_inventory_row(item_id, item, int(InventoryManager.items[item_id])))
	if not found:
		var empty := _create_body_label()
		empty.text = "사용 가능한 도구나 배치물이 없다."
		tool_menu_content.add_child(empty)


func _make_equipment_belt() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 82)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.047, 0.92), Color(0.28, 0.34, 0.28), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 5)
	box.add_child(header)
	var title := Label.new()
	title.text = "손 장비"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(0.94, 0.90, 0.72))
	header.add_child(title)
	var hint := Label.new()
	hint.text = _equipment_belt_summary()
	hint.clip_text = true
	hint.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	hint.add_theme_font_size_override("font_size", 10)
	hint.add_theme_color_override("font_color", Color(0.70, 0.80, 0.72))
	header.add_child(hint)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	box.add_child(row)
	for slot in _equipment_slot_defs():
		row.add_child(_make_equipment_slot(slot))
	return panel


func _equipment_slot_defs() -> Array[Dictionary]:
	return [
		{"id": "stone_axe", "ids": ["survival_axe", "stone_axe"], "fallback": "items/stone_axe", "label": "벌목", "need": "나무"},
		{"id": "stone_knife", "fallback": "items/stone_knife", "label": "채집", "need": "섬유"},
		{"id": "wooden_spear", "ids": ["simple_bow", "wooden_spear"], "fallback": "items/wooden_spear", "label": "사냥", "need": "흔적"},
		{"id": "torch", "ids": ["lighter", "torch"], "fallback": "items/torch", "label": "불빛", "need": "밤"}
	]


func _make_equipment_slot(slot: Dictionary) -> Button:
	var item_id := _equipment_item_id_for_slot(slot)
	var item = InventoryManager.get_item_data(item_id)
	var owned := InventoryManager.get_count(item_id) > 0
	var usable := InventoryManager.has_usable_tool(item_id) if owned else false
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(44, 46)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(Callable(self, "_toggle_tool_menu").bind("tools"))
	var color := Color(0.30, 0.34, 0.31)
	if owned:
		color = _tool_condition_color(item_id, item)
	if not usable and owned:
		color = Color(0.80, 0.25, 0.20)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.055, 0.075, 0.068, 0.94), color.darkened(0.25), 5))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.09, 0.12, 0.10, 0.98), color, 5))
	button.add_theme_stylebox_override("pressed", _make_panel_style(color.darkened(0.05), color.lightened(0.16), 5))

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	button.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 1)
	margin.add_child(box)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var icon_path := String(slot.get("fallback", "actions/craft"))
	if item != null:
		icon_path = item.icon_path
	var texture = _icon_texture(icon_path) if not icon_path.begins_with("res://") else _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	icon.modulate = Color(1, 1, 1, 1) if owned else Color(0.36, 0.40, 0.36, 0.75)
	box.add_child(icon)

	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = String(slot.get("label", "장비"))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.70) if owned else Color(0.50, 0.56, 0.50))
	box.add_child(label)

	var state := Label.new()
	state.mouse_filter = Control.MOUSE_FILTER_IGNORE
	state.text = _equipment_slot_state_text(item_id, item, owned)
	state.clip_text = true
	state.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	state.add_theme_font_size_override("font_size", 8)
	state.add_theme_color_override("font_color", color.lightened(0.28) if owned else Color(0.48, 0.54, 0.48))
	box.add_child(state)

	if owned and item != null:
		button.tooltip_text = "%s\n%s\n%s" % [
			item.display_name,
			InventoryManager.get_tool_condition_text(item_id),
			InventoryManager.get_tool_effect_summary(item_id)
		]
	else:
		button.tooltip_text = "%s 장비 없음\n필요할 때 제작 메뉴에서 만들 수 있다." % String(slot.get("need", "해당"))
	_bind_button_reaction(button, "icon")
	return button


func _equipment_slot_state_text(item_id: String, item, owned: bool) -> String:
	if not owned or item == null:
		return "없음"
	if not InventoryManager.has_usable_tool(item_id):
		return "망가짐"
	var max_durability := InventoryManager.get_tool_max_durability(item_id)
	if max_durability <= 0:
		return "준비"
	var ratio := InventoryManager.get_tool_condition_ratio(item_id)
	if ratio >= 1.15:
		return "정교"
	if ratio >= 0.65:
		return "양호"
	if ratio >= 0.35:
		return "마모"
	return "위태"


func _equipment_belt_summary() -> String:
	var ready := 0
	for slot in _equipment_slot_defs():
		if InventoryManager.has_usable_tool(_equipment_item_id_for_slot(slot)):
			ready += 1
	return "%d/%d" % [ready, _equipment_slot_defs().size()]


func _equipment_item_id_for_slot(slot: Dictionary) -> String:
	if slot.has("ids"):
		for raw_item_id in Array(slot.get("ids", [])):
			var candidate := String(raw_item_id)
			if InventoryManager.get_count(candidate) > 0:
				return candidate
		var ids := Array(slot.get("ids", []))
		if not ids.is_empty():
			return String(ids[0])
	return String(slot.get("id", ""))


func _make_tool_inventory_row(item_id: String, item, amount: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.063, 0.058), Color(0.19, 0.26, 0.22), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 7)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(34, 34)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(item.icon_path)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 2)
	row.add_child(text_box)

	var title := Label.new()
	title.text = "%s x%d" % [item.display_name, amount]
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.94, 0.90, 0.74))
	text_box.add_child(title)

	var condition := Label.new()
	condition.text = _tool_condition_line(item_id, item)
	condition.add_theme_font_size_override("font_size", 11)
	condition.add_theme_color_override("font_color", _tool_condition_color(item_id, item))
	text_box.add_child(condition)

	var effect := Label.new()
	effect.text = InventoryManager.get_tool_effect_summary(item_id)
	effect.clip_text = true
	effect.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	effect.add_theme_font_size_override("font_size", 11)
	effect.add_theme_color_override("font_color", Color(0.76, 0.84, 0.76))
	text_box.add_child(effect)

	if item.tags.has("placeable"):
		var place_button := _make_button("배치", Callable(self, "_on_place_item_pressed").bind(item_id), "actions/place")
		place_button.disabled = not BaseManager.can_place_item(item_id)
		place_button.tooltip_text = "거점에 배치해 생활 효과를 얻는다."
		row.add_child(place_button)

	panel.tooltip_text = "%s\n%s\n%s" % [
		item.description,
		_tool_condition_line(item_id, item),
		InventoryManager.get_tool_effect_summary(item_id)
	]
	return panel


func _tool_condition_line(item_id: String, item) -> String:
	if item == null:
		return "상태 알 수 없음"
	if item.category == "tool" or item.tags.has("tool"):
		return InventoryManager.get_tool_condition_text(item_id)
	if item.tags.has("placeable"):
		return "거점 배치 가능"
	return "소지 중"


func _tool_condition_color(item_id: String, item) -> Color:
	if item == null or not (item.category == "tool" or item.tags.has("tool")):
		return Color(0.76, 0.82, 0.76)
	var ratio := InventoryManager.get_tool_condition_ratio(item_id)
	if ratio >= 0.65:
		return Color(0.72, 0.88, 0.62)
	if ratio >= 0.35:
		return Color(0.90, 0.72, 0.34)
	return Color(0.92, 0.42, 0.28)


func _populate_craft_menu() -> void:
	_add_craft_category_bar()
	tool_menu_content.add_child(_make_craft_discovery_summary())
	tool_menu_content.add_child(_make_craft_table_header())

	var found := false
	var entries: Array[Dictionary] = []
	for raw_recipe_id in CraftingManager.get_unlocked_recipe_ids():
		var recipe_id := String(raw_recipe_id)
		var recipe = CraftingManager.get_recipe(recipe_id)
		if recipe == null:
			continue
		if not _recipe_matches_craft_category(recipe):
			continue
		entries.append({
			"id": recipe_id,
			"recipe": recipe,
			"can_craft": _can_attempt_recipe(recipe, false)
		})
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if bool(a.get("can_craft", false)) != bool(b.get("can_craft", false)):
			return bool(a.get("can_craft", false))
		return String(a.get("id", "")) < String(b.get("id", ""))
	)
	for entry in entries:
		found = true
		tool_menu_content.add_child(_make_craft_recipe_row(String(entry.get("id", "")), entry.get("recipe", null)))
	if not found:
		var empty := _create_body_label()
		empty.text = "아직 떠오른 제작법이 없다."
		tool_menu_content.add_child(empty)


func _make_craft_discovery_summary() -> PanelContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_make_info_chip("actions/craft", "제작법", "%d/%d" % [CraftingManager.get_known_recipe_count(), CraftingManager.get_total_recipe_count()]))
	row.add_child(_make_info_chip("items/stone", "손맛", CraftingManager.get_crafting_mastery_label()))
	return _make_overlay_content_panel(row)


func _add_craft_category_bar() -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	var categories := [
		{"id": "all", "text": "전체", "icon": "actions/craft"},
		{"id": "tool", "text": "도구", "icon": "items/stone_axe"},
		{"id": "fire", "text": "불", "icon": "items/campfire"},
		{"id": "cooking", "text": "요리", "icon": "items/cooked_fish"},
		{"id": "facility", "text": "거점", "icon": "actions/place"},
		{"id": "component", "text": "재료", "icon": "items/fiber"}
	]
	for raw_category in categories:
		var category: Dictionary = raw_category
		var category_id := String(category.get("id", "all"))
		var button := _make_button(String(category.get("text", category_id)), Callable(self, "_set_craft_category").bind(category_id), String(category.get("icon", "actions/craft")))
		button.toggle_mode = true
		button.button_pressed = category_id == active_craft_category
		button.custom_minimum_size = Vector2(80, 30)
		row.add_child(button)
	tool_menu_content.add_child(row)


func _set_craft_category(category_id: String) -> void:
	active_craft_category = category_id
	if active_tool_menu == "craft":
		_refresh_tool_menu("craft")


func _make_craft_table_header() -> PanelContainer:
	var row := _make_craft_table_row_base(Color(0.075, 0.095, 0.09), Color(0.32, 0.38, 0.32))
	var box = row.get_node("Margin/Row") as HBoxContainer
	box.add_child(_make_craft_header_cell("", 34))
	box.add_child(_make_craft_header_cell("이름", 88))
	box.add_child(_make_craft_header_cell("필요재료", 220))
	box.add_child(_make_craft_header_cell("시간/기력", 74))
	box.add_child(_make_craft_header_cell("비고", 110))
	box.add_child(_make_craft_header_cell("제작", 86))
	return row


func _make_craft_recipe_row(recipe_id: String, recipe) -> PanelContainer:
	var can_craft := _can_attempt_recipe(recipe, false)
	var row := _make_craft_table_row_base(Color(0.045, 0.063, 0.06), Color(0.18, 0.24, 0.22))
	row.tooltip_text = _craft_recipe_tooltip(recipe, can_craft)
	var box = row.get_node("Margin/Row") as HBoxContainer

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(34, 34)
	icon.tooltip_text = row.tooltip_text
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var icon_texture = _texture_from_path(_recipe_result_icon_path(recipe))
	if icon_texture != null:
		icon.texture = icon_texture
	box.add_child(icon)

	box.add_child(_make_craft_text_cell(recipe.display_name, 88, 12, Color(0.94, 0.90, 0.76)))
	box.add_child(_make_craft_materials_cell(recipe.required_items, 220))
	box.add_child(_make_craft_text_cell(_craft_resource_text(recipe), 74, 11, Color(0.86, 0.90, 0.86)))
	box.add_child(_make_craft_text_cell(_craft_note_text(recipe, can_craft), 110, 11, Color(0.80, 0.86, 0.82)))

	var button_box := HBoxContainer.new()
	button_box.custom_minimum_size = Vector2(86, 34)
	button_box.add_theme_constant_override("separation", 4)
	var craft_button_text := "손작업" if _is_tool_recipe(recipe) else "제작"
	var craft_button := _make_button(craft_button_text, Callable(self, "_on_craft_pressed").bind(recipe_id, false), "actions/craft")
	craft_button.disabled = not can_craft
	craft_button.tooltip_text = row.tooltip_text
	if _is_tool_recipe(recipe):
		craft_button.tooltip_text = "도구는 짧은 손작업 미니게임을 거쳐 품질을 판정한다."
	if craft_button.tooltip_text != row.tooltip_text:
		craft_button.tooltip_text = "%s\n%s" % [row.tooltip_text, craft_button.tooltip_text]
	button_box.add_child(craft_button)
	if recipe.can_partner_assist:
		var assist_button := _make_button("함께", Callable(self, "_on_craft_pressed").bind(recipe_id, true), "actions/assist")
		assist_button.disabled = not CharacterManager.is_partner_following() or not _can_attempt_recipe(recipe, true)
		if _is_tool_recipe(recipe):
			assist_button.tooltip_text = "파트너가 재료를 잡아주면 손작업 판정이 조금 안정된다."
		button_box.add_child(assist_button)
	box.add_child(button_box)
	return row


func _make_craft_table_row_base(bg_color: Color, border_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg_color, border_color, 4))
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.name = "Row"
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)
	return panel


func _make_craft_header_cell(text: String, width: int) -> Label:
	var label := _make_craft_text_cell(text, width, 11, Color(0.96, 0.91, 0.73))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label


func _make_craft_text_cell(text: String, width: int, font_size: int, font_color: Color) -> Label:
	var label := Label.new()
	label.custom_minimum_size = Vector2(width, 0)
	label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	label.text = text
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	return label


func _make_craft_materials_cell(required_items: Dictionary, width: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(width, 38)
	row.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	row.alignment = BoxContainer.ALIGNMENT_BEGIN
	row.add_theme_constant_override("separation", 5)
	var keys := required_items.keys()
	keys.sort()
	for raw_item_id in keys:
		row.add_child(_make_craft_material_token(String(raw_item_id), int(required_items[raw_item_id])))
	if keys.is_empty():
		row.add_child(_make_craft_text_cell("-", width, 11, Color(0.74, 0.78, 0.74)))
	return row


func _make_craft_material_token(item_id: String, required_amount: int) -> PanelContainer:
	var have := InventoryManager.get_accessible_count(item_id)
	var has_enough := have >= required_amount
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(50, 34)
	panel.tooltip_text = _craft_material_tooltip(item_id, have, required_amount)
	var bg := Color(0.075, 0.14, 0.09, 0.94) if has_enough else Color(0.20, 0.075, 0.060, 0.94)
	var border := Color(0.42, 0.78, 0.36, 0.90) if has_enough else Color(0.95, 0.38, 0.25, 0.95)
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg, border, 5))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 3)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var item = InventoryManager.get_item_data(item_id)
	var texture = _icon_texture(_item_primary_icon(item, "items/fiber"))
	if texture != null:
		icon.texture = texture
	icon.modulate = Color(1, 1, 1, 1) if has_enough else Color(1.0, 0.62, 0.55, 0.90)
	row.add_child(icon)

	var amount_label := Label.new()
	amount_label.text = "%d/%d" % [have, required_amount]
	amount_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	amount_label.add_theme_font_size_override("font_size", 10)
	amount_label.add_theme_color_override("font_color", Color(0.78, 0.96, 0.72) if has_enough else Color(1.0, 0.72, 0.62))
	_prepare_single_line_label(amount_label, 23)
	row.add_child(amount_label)
	return panel


func _craft_material_tooltip(item_id: String, have: int, required_amount: int) -> String:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var missing := maxi(0, required_amount - have)
	if missing <= 0:
		return "%s 충분함: %d/%d" % [display_name, have, required_amount]
	return "%s 부족: %d개 더 필요 (%d/%d)" % [display_name, missing, have, required_amount]


func _recipe_matches_craft_category(recipe) -> bool:
	if active_craft_category == "all":
		return true
	var recipe_category := String(recipe.category)
	if active_craft_category == "fire":
		return ["small_campfire", "campfire", "stone_oven", "torch"].has(String(recipe.id))
	if active_craft_category == "cooking":
		return ["cooking", "food"].has(recipe_category)
	if active_craft_category == "facility":
		return ["facility", "furniture"].has(recipe_category)
	return recipe_category == active_craft_category


func _is_tool_recipe(recipe) -> bool:
	if recipe == null:
		return false
	if String(recipe.category) == "tool":
		return true
	for item_id in recipe.result_items.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		if item != null and (item.category == "tool" or item.tags.has("tool")):
			return true
	return false


func _craft_resource_text(recipe) -> String:
	var craft_cost := GameState.get_adjusted_action_cost("craft", {"time": recipe.time_cost, "stamina": recipe.stamina_cost})
	return "%d분 / %d" % [
		int(craft_cost.get("time", recipe.time_cost)) * GameState.MINUTES_PER_ACTION_SLOT,
		int(craft_cost.get("stamina", recipe.stamina_cost))
	]


func _craft_note_text(recipe, can_craft: bool) -> String:
	var notes: Array[String] = []
	if not CraftingManager.is_recipe_unlocked(String(recipe.id)):
		return "아직 모름"
	if recipe.required_station != "":
		notes.append(BaseManager.get_station_name(recipe.required_station))
	var restriction := GameState.get_action_restriction_text("craft")
	if restriction != "":
		notes.append(restriction)
	if recipe.can_partner_assist:
		notes.append("함께 가능")
	if _is_tool_recipe(recipe):
		notes.append("손작업")
	if not InventoryManager.has_items(recipe.required_items):
		notes.append("재료 부족")
	elif not can_craft:
		notes.append("조건 부족")
	if notes.is_empty():
		return "-"
	return _join_lines(notes, ", ")


func _craft_recipe_tooltip(recipe, can_craft: bool) -> String:
	if recipe == null:
		return ""
	var lines: Array[String] = []
	lines.append(String(recipe.display_name))
	var result_lines: Array[String] = []
	for raw_item_id in recipe.result_items.keys():
		var item_id := String(raw_item_id)
		var amount := int(recipe.result_items[raw_item_id])
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = String(item.display_name)
		result_lines.append("%s x%d" % [display_name, amount])
	lines.append("완성품: %s" % _join_lines(result_lines, ", "))
	var descriptions: Array[String] = []
	for raw_item_id in recipe.result_items.keys():
		var item = InventoryManager.get_item_data(String(raw_item_id))
		if item != null and String(item.description) != "":
			descriptions.append(String(item.description))
	if not descriptions.is_empty():
		lines.append(_join_lines(descriptions, "\n"))
	lines.append("필요: %s" % _format_requirements(recipe.required_items))
	lines.append("소모: %s" % _craft_resource_text(recipe))
	if recipe.required_station != "":
		lines.append("장소: %s" % BaseManager.get_station_name(recipe.required_station))
	lines.append("상태: %s" % ("제작 가능" if can_craft else _craft_note_text(recipe, can_craft)))
	if _is_tool_recipe(recipe):
		lines.append("제작 전 손작업 미니게임으로 품질이 결정된다.")
	return _join_lines(lines, "\n")


func _populate_map_menu() -> void:
	var current_tile = WorldManager.get_current_tile()
	var lines: Array[String] = []
	lines.append("탐색 규칙")
	lines.append("- 현재 타일에서 조사를 완료하면 벽으로 막히지 않은 인접 타일의 안개가 걷힌다.")
	lines.append("- 덮인 미탐색 타일은 클릭하거나 이동할 수 없다.")
	lines.append("- 드러난 인접 타일만 이동 대상으로 선택할 수 있다.")
	var flow_hint := _current_flow_hint_for_tile(WorldManager.current_tile_id)
	if flow_hint != "":
		lines.append("")
		lines.append(flow_hint)
	if current_tile != null:
		lines.append("")
		lines.append("현재 타일: %s (%d,%d)" % [
			String(current_tile.get("display_name", "타일")),
			int(current_tile.get("x", 0)),
			int(current_tile.get("y", 0))
		])
		lines.append("조사 %d / 개발 %d / 위험 %d" % [
			int(current_tile.get("investigation", 0)),
			int(current_tile.get("development", 0)),
			int(current_tile.get("danger", 0))
		])
	var revealed := 0
	var investigated := 0
	for row in WorldManager.get_tile_rows():
		for tile in row:
			var tile_id := String(tile.get("id", ""))
			if WorldManager.is_tile_revealed(tile_id):
				revealed += 1
			if WorldManager.is_tile_investigated(tile_id):
				investigated += 1
	lines.append("")
	lines.append("드러난 타일 %d / 조사 완료 %d" % [revealed, investigated])
	var label := _create_body_label()
	label.text = _join_lines(lines, "\n")
	tool_menu_content.add_child(label)


func _populate_base_menu() -> void:
	var tile = WorldManager.get_current_tile()
	var summary := _create_body_label()
	summary.text = BaseManager.get_base_summary()
	tool_menu_content.add_child(summary)
	if tile != null and bool(tile.get("is_base", false)):
		tool_menu_content.add_child(_make_button("거점 진입", Callable(self, "_perform_tile_action").bind("enter_base", {}), "actions/place"))
	else:
		var hint := _create_body_label()
		hint.text = "동굴 거점 타일에서만 거점 화면에 진입할 수 있다."
		tool_menu_content.add_child(hint)


func _populate_log_menu() -> void:
	var label := _create_body_label()
	label.text = _log_popup_text()
	tool_menu_content.add_child(label)


func _populate_sleep_menu() -> void:
	var label := _create_body_label()
	var profile := BaseManager.get_sleep_recovery_profile()
	label.text = "수면 시간을 선택한다.\n%s 수면 회복: 시간당 기력 %d / 허기절약 %d / 수분절약 %d\n현재 시각: %s / %s" % [
		String(profile.get("label", "야외")),
		int(profile.get("stamina_per_hour", 6)),
		int(profile.get("hunger_saving", 0)),
		int(profile.get("thirst_saving", 0)),
		GameState.get_time_label(),
		GameState.get_day_phase()
	]
	tool_menu_content.add_child(label)
	tool_menu_content.add_child(_make_button("수면 시간 조정", Callable(self, "_open_time_adjustment").bind("sleep", {}), "actions/rest"))


func _populate_system_menu() -> void:
	var detail := _create_body_label()
	detail.text = "날짜: DAY %d / %s\n시간: %s %s\n날씨: %s, 다음 %s\n일출: %s / 일몰: %s\n남은 행동: %d칸(%d분)" % [
		GameState.day,
		GameState.season,
		GameState.get_day_phase(),
		GameState.get_time_label(),
		GameState.weather,
		GameState.next_weather,
		_minutes_label(GameState.get_sunrise_minutes()),
		_minutes_label(GameState.get_sunset_minutes()),
		GameState.action_points,
		GameState.action_points * GameState.MINUTES_PER_ACTION_SLOT
	]
	tool_menu_content.add_child(_make_overlay_content_panel(detail))
	_add_save_slot_section()
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.add_child(_make_button("새 게임", Callable(self, "_on_new_game_pressed"), "actions/new_game"))
	row.add_child(_make_button("게임 종료", Callable(self, "_on_quit_game_pressed"), "actions/end_day"))
	tool_menu_content.add_child(row)


func _populate_settings_menu() -> void:
	var label := _create_body_label()
	label.text = "현재 설정\n- 행동은 30분 슬롯 단위로 시간을 소모한다.\n- 밤에는 조사와 제작이 제한된다.\n- 조작은 지도 타일 클릭을 중심으로 한다."
	tool_menu_content.add_child(label)
	_add_save_slot_section()
	tool_menu_content.add_child(_make_button("새 게임", Callable(self, "_on_new_game_pressed"), "actions/new_game"))


func _add_save_slot_section() -> void:
	var title := _small_title("세이브 슬롯")
	title.add_theme_font_size_override("font_size", 15)
	tool_menu_content.add_child(title)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	for slot in range(1, SaveManager.SAVE_SLOT_COUNT + 1):
		grid.add_child(_make_save_slot_panel(slot))
	tool_menu_content.add_child(grid)


func _make_save_slot_panel(slot: int) -> PanelContainer:
	var summary := SaveManager.get_slot_summary(slot)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 132)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.046, 0.92), Color(0.36, 0.44, 0.34, 0.72), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 5)
	box.add_child(header)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/save")
	if texture != null:
		icon.texture = texture
	header.add_child(icon)
	var title := Label.new()
	title.text = "슬롯 %d" % slot
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(0.95, 0.91, 0.72))
	_prepare_single_line_label(title, 54)
	header.add_child(title)

	var body := Label.new()
	body.text = _save_slot_summary_text(summary)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(120, 40)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_font_size_override("font_size", 11)
	body.add_theme_color_override("font_color", Color(0.83, 0.88, 0.82))
	body.set_meta("allow_multiline_text", true)
	box.add_child(body)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	box.add_child(row)
	row.add_child(_make_compact_button("저장", Callable(self, "_on_save_slot_pressed").bind(slot), "actions/save", Vector2(74, 26)))
	var load_button := _make_compact_button("불러오기", Callable(self, "_on_load_slot_pressed").bind(slot), "actions/load", Vector2(88, 26))
	load_button.disabled = not bool(summary.get("exists", false)) or bool(summary.get("broken", false))
	row.add_child(load_button)
	return panel


func _save_slot_summary_text(summary: Dictionary) -> String:
	if bool(summary.get("broken", false)):
		return "손상된 저장 데이터"
	if not bool(summary.get("exists", false)):
		return "비어 있음"
	var line := "DAY %d · %s %s" % [
		int(summary.get("day", 1)),
		String(summary.get("season", "")),
		String(summary.get("time", ""))
	]
	var weather := String(summary.get("weather", ""))
	if weather != "":
		line += "\n날씨 %s" % weather
	var saved_at := String(summary.get("saved_at", ""))
	if saved_at != "":
		line += "\n%s" % saved_at
	return line


func _populate_partner_dialogue_menu() -> void:
	if not CharacterManager.partner_joined:
		var missing := _create_body_label()
		missing.text = "아직 말을 걸 파트너가 없다."
		tool_menu_content.add_child(missing)
		return
	var current_tile_id := WorldManager.current_tile_id
	var partner_tile_id := CharacterManager.get_partner_tile_id(current_tile_id)
	var can_talk := CharacterManager.is_partner_following() or partner_tile_id == current_tile_id
	var status := _create_body_label()
	status.text = CharacterManager.get_partner_menu_summary(_tile_label(partner_tile_id) if partner_tile_id != "" else "알 수 없음")
	tool_menu_content.add_child(_make_overlay_content_panel(status))
	tool_menu_content.add_child(_make_partner_dialogue_section("대화", [
		{"text": "상태 묻기", "icon": "status/mood", "callback": Callable(self, "_on_partner_check_pressed"), "disabled": not can_talk, "hint": "파트너가 지금 무엇을 힘들어하는지 묻는다."},
		{"text": "짧은 대화", "icon": "actions/talk", "callback": Callable(self, "_on_partner_daily_talk_pressed"), "disabled": not can_talk, "hint": "30분을 써서 감정과 신뢰를 조금 회복한다."},
		{"text": "안심시키기", "icon": "status/stable", "callback": Callable(self, "_on_partner_comfort_pressed"), "disabled": not can_talk, "hint": "불안, 공포, 외로움이 있을 때 효과가 크다."},
		{"text": "오늘 계획", "icon": "actions/investigate", "callback": Callable(self, "_on_partner_plan_pressed"), "disabled": not can_talk, "hint": "현재 시간, 날씨, 상태를 보고 행동 방향을 제안받는다."}
	]))
	var instruction_items: Array[Dictionary] = []
	if CharacterManager.is_partner_following():
		instruction_items.append({"text": "따로 다니자", "icon": "actions/move", "callback": Callable(self, "_on_partner_separate_pressed"), "disabled": false, "hint": "파트너를 현재 타일에 남기고 혼자 행동한다."})
	else:
		instruction_items.append({"text": "동행하자", "icon": "actions/assist", "callback": Callable(self, "_on_partner_follow_pressed"), "disabled": not can_talk, "hint": "같은 타일에 있을 때 다시 함께 이동한다."})
	tool_menu_content.add_child(_make_partner_dialogue_section("지시", instruction_items))
	var assign_items: Array[Dictionary] = []
	for task in CharacterManager.get_partner_available_tasks():
		var task_id := String(task.get("id", "wait"))
		var disabled_reason := String(task.get("disabled_reason", ""))
		var disabled := not can_talk or disabled_reason != ""
		var hint := String(task.get("detail", ""))
		var stamina_cost := int(task.get("stamina_cost", 0))
		if stamina_cost > 0:
			hint += "\n기력 -%d" % stamina_cost
		hint += "\n대상: %s" % _tile_label(current_tile_id)
		hint += "\n예상: %s - %s" % [GameState.get_time_label(), _time_label_after_slots(_partner_task_duration_slots(task_id))]
		if disabled_reason != "":
			hint += "\n%s" % disabled_reason
		assign_items.append({
			"text": String(task.get("label", "대기")),
			"icon": String(task.get("icon", "actions/rest")),
			"callback": Callable(self, "_on_partner_assign_task_pressed").bind(task_id),
			"disabled": disabled,
			"hint": hint
		})
	tool_menu_content.add_child(_make_partner_dialogue_section("맡김", assign_items))
	var care_items: Array[Dictionary] = [
		{"text": "함께 쉬기", "icon": "actions/rest", "callback": Callable(self, "_on_partner_rest_request_pressed"), "disabled": not CharacterManager.is_partner_following(), "hint": "시간을 정해 함께 쉬며 긴장을 낮춘다."}
	]
	if InventoryManager.get_count("berry") > 0:
		care_items.append({
			"text": "열매 선물",
			"icon": "actions/gift",
			"callback": Callable(self, "_on_gift_berry_pressed"),
			"disabled": not can_talk,
			"hint": "먹는 것보다 마음을 건네는 행동이다. 성격에 따라 반응이 달라진다."
		})
	for item_id in CharacterManager.get_partner_care_candidates():
		var item = InventoryManager.get_item_data(item_id)
		var item_name := String(item_id)
		var icon_id := "actions/gift"
		if item != null:
			item_name = item.display_name
			icon_id = item.icon_path
		care_items.append({
			"text": "%s 건네기" % item_name,
			"icon": icon_id,
			"callback": Callable(self, "_on_partner_care_item_pressed").bind(item_id),
			"disabled": not can_talk,
			"hint": "%s을/를 파트너에게 건네 상태를 회복시킨다." % item_name
		})
	tool_menu_content.add_child(_make_partner_dialogue_section("돌봄", care_items))


func _make_partner_dialogue_section(title: String, items: Array[Dictionary]) -> PanelContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	var title_label := _small_title(title)
	title_label.add_theme_font_size_override("font_size", 13)
	box.add_child(title_label)
	var row := GridContainer.new()
	row.columns = 2
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 6)
	box.add_child(row)
	for item in items:
		var button := _make_button(String(item.get("text", "")), item.get("callback", Callable()), String(item.get("icon", "")))
		button.disabled = bool(item.get("disabled", false))
		button.custom_minimum_size = Vector2(128, 32)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		if item.has("hint"):
			button.tooltip_text = String(item["hint"])
		row.add_child(button)
	return _make_overlay_content_panel(box)


func _show_action_result(action_id: String, result: Dictionary, before_snapshot: Dictionary, after_snapshot: Dictionary) -> void:
	_show_item_toast_from_result(result)
	if bool(result.get("ok", false)):
		_show_action_delta_toast(action_id, before_snapshot, after_snapshot, result)


func _hide_action_result_panel() -> void:
	action_result_panel.visible = false


func _show_item_toast_from_result(result: Dictionary) -> void:
	var items: Dictionary = result.get("items", {})
	if items.is_empty():
		return
	_clear_children(item_toast_items_box)
	for item_id in items.keys():
		if int(items[item_id]) <= 0:
			continue
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		var icon_path := ""
		if item != null:
			display_name = item.display_name
			icon_path = item.icon_path
		item_toast_items_box.add_child(_make_item_chip(display_name, int(items[item_id]), icon_path, true))
	if item_toast_items_box.get_child_count() == 0:
		return
	if item_toast_tween != null and item_toast_tween.is_valid():
		item_toast_tween.kill()
	item_toast_panel.visible = true
	_fit_item_toast_panel()
	item_toast_panel.modulate = Color(1, 1, 1, 1)
	_raise_root_overlay(item_toast_panel, Z_ROOT_TOAST)
	item_toast_tween = create_tween()
	item_toast_tween.tween_interval(1.35)
	item_toast_tween.tween_property(item_toast_panel, "modulate", Color(1, 1, 1, 0), 0.35)
	item_toast_tween.tween_callback(func() -> void: item_toast_panel.visible = false)


func _show_action_delta_toast(action_id: String, before_snapshot: Dictionary, after_snapshot: Dictionary, result: Dictionary) -> void:
	if action_delta_panel == null or action_delta_items_box == null:
		return
	var chips := _build_action_delta_chips(action_id, before_snapshot, after_snapshot, result)
	if chips.is_empty():
		return
	_clear_children(action_delta_items_box)
	for chip_data in chips:
		action_delta_items_box.add_child(_make_action_delta_chip(chip_data))
	if action_delta_tween != null and action_delta_tween.is_valid():
		action_delta_tween.kill()
	action_delta_panel.visible = true
	_fit_action_delta_panel()
	action_delta_panel.modulate = Color(1, 1, 1, 0)
	_raise_root_overlay(action_delta_panel, Z_ROOT_TOAST - 1)
	action_delta_tween = create_tween()
	action_delta_tween.tween_property(action_delta_panel, "modulate", Color(1, 1, 1, 1), 0.12)
	action_delta_tween.tween_interval(1.45)
	action_delta_tween.tween_property(action_delta_panel, "modulate", Color(1, 1, 1, 0), 0.28)
	action_delta_tween.tween_callback(func() -> void:
		if action_delta_panel != null:
			action_delta_panel.visible = false
	)


func _build_action_delta_chips(action_id: String, before_snapshot: Dictionary, after_snapshot: Dictionary, result: Dictionary) -> Array[Dictionary]:
	var chips: Array[Dictionary] = []
	var before_absolute := int(before_snapshot.get("day", 1)) * GameState.MINUTES_PER_DAY + int(before_snapshot.get("minutes", 0))
	var after_absolute := int(after_snapshot.get("day", 1)) * GameState.MINUTES_PER_DAY + int(after_snapshot.get("minutes", 0))
	var elapsed_minutes := after_absolute - before_absolute
	if elapsed_minutes > 0:
		chips.append({"icon": "actions/rest", "text": "+%d분" % elapsed_minutes, "color": Color(0.82, 0.72, 0.40)})
	var before_tile := String(before_snapshot.get("tile_id", ""))
	var after_tile := String(after_snapshot.get("tile_id", ""))
	if before_tile != after_tile:
		chips.append({"icon": "actions/move", "text": _tile_label(after_tile), "color": Color(0.72, 0.66, 0.42)})
	_add_status_delta_chips(chips, before_snapshot.get("player", {}), after_snapshot.get("player", {}), false)
	if CharacterManager.partner_joined or bool(result.get("together", false)):
		_add_status_delta_chips(chips, before_snapshot.get("partner", {}), after_snapshot.get("partner", {}), true)
	return chips.slice(0, mini(chips.size(), 8))


func _add_status_delta_chips(chips: Array[Dictionary], before_status: Dictionary, after_status: Dictionary, partner: bool) -> void:
	var keys: Array[String] = ["hp", "stamina", "hunger", "thirst", "hygiene", "mood"]
	if partner:
		keys = ["stamina", "hp", "hunger", "thirst", "mood"]
	for key in keys:
		var delta := int(after_status.get(key, 0)) - int(before_status.get(key, 0))
		if delta == 0:
			continue
		var label := _stat_display_name(key)
		if partner:
			label = "동행 " + label
		var after_value := int(after_status.get(key, 0))
		var critical: bool = ["hp", "stamina", "hunger", "thirst"].has(key) and delta < 0 and (abs(delta) >= 8 or after_value <= 35)
		chips.append({
			"icon": _stat_delta_signal_icon_path(key) if critical else _stat_delta_icon_id(key),
			"text": "%s %s" % [label, _signed_int(delta)],
			"color": _stat_delta_color(key, delta),
			"critical": critical
		})


func _make_action_delta_chip(chip_data: Dictionary) -> PanelContainer:
	var color: Color = chip_data.get("color", Color(0.72, 0.66, 0.42))
	var critical := bool(chip_data.get("critical", false))
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(92, 34) if critical else Vector2(74, 28)
	var bg_color := Color(0.050, 0.030, 0.028, 0.96) if critical else Color(0.025, 0.036, 0.034, 0.92)
	var border_color := color.lightened(0.15) if critical else color
	panel.add_theme_stylebox_override("panel", _make_panel_style(bg_color, border_color, 6))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 4)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22) if critical else Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(chip_data.get("icon", "")))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = String(chip_data.get("text", ""))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_font_size_override("font_size", 12 if critical else 11)
	label.add_theme_color_override("font_color", color.lightened(0.35))
	row.add_child(label)
	return panel


func _stat_delta_icon_id(stat_id: String) -> String:
	match stat_id:
		"hp":
			return "status/hp"
		"stamina":
			return "status/stamina"
		"hunger":
			return "status/hunger"
		"thirst":
			return "status/thirst"
		"mood":
			return "status/mood"
		"trust":
			return "status/trust"
	return "status/stable"


func _stat_delta_signal_icon_path(stat_id: String) -> String:
	match stat_id:
		"hp", "stamina":
			return _generated_ui_asset_path("survival_status", "exhaustion")
		"hunger":
			return _generated_ui_asset_path("survival_status", "hunger")
		"thirst":
			return _generated_ui_asset_path("survival_status", "dehydration")
	return _stat_delta_icon_id(stat_id)


func _stat_delta_color(stat_id: String, delta: int) -> Color:
	if stat_id == "hp":
		return Color(0.92, 0.24, 0.20) if delta < 0 else Color(0.66, 0.86, 0.42)
	if stat_id == "stamina":
		return Color(0.90, 0.62, 0.24) if delta < 0 else Color(0.76, 0.82, 0.42)
	if stat_id == "hunger":
		return Color(0.82, 0.48, 0.22) if delta < 0 else Color(0.70, 0.86, 0.38)
	if stat_id == "thirst":
		return Color(0.30, 0.62, 0.86) if delta < 0 else Color(0.54, 0.82, 0.95)
	if stat_id == "mood":
		return Color(0.66, 0.44, 0.76) if delta < 0 else Color(0.80, 0.68, 0.36)
	if stat_id == "trust":
		return Color(0.62, 0.48, 0.38) if delta < 0 else Color(0.90, 0.72, 0.34)
	if delta < 0:
		return Color(0.78, 0.42, 0.32)
	return Color(0.58, 0.76, 0.42)


func _perform_sleep(hours: int) -> void:
	_hide_map_context_menu()
	_hide_tool_menu()
	var before_snapshot := _capture_play_state()
	var messages := CharacterManager.recover_sleep(hours)
	var sleep_result := GameState.sleep_for_hours(hours)
	var days_advanced := int(sleep_result.get("days_advanced", 0))
	var daily_yields: Dictionary = sleep_result.get("daily_yields", {})
	for transition_message in Array(sleep_result.get("messages", [])):
		messages.append(String(transition_message))
	var summary_lines: Array[String] = []
	summary_lines.append("%d시간 잠을 잤다. 현재 시각은 %s이다." % [hours, GameState.get_time_label()])
	if days_advanced > 0:
		summary_lines.append("%d일이 지났다. 지역 자원이 조금 회복되었다." % days_advanced)
		if not daily_yields.is_empty():
			summary_lines.append("거점 설치물이 자원을 모았다: %s" % _format_items(daily_yields))
	for message in messages:
		summary_lines.append(message)
	if messages.is_empty():
		summary_lines.append("몸이 조금 가벼워졌다.")
	var after_snapshot := _capture_play_state()
	_append_log(_join_lines(summary_lines, "\n"))
	_refresh_all()
	_play_screen_action_feedback("sleep", WorldManager.current_tile_id)
	_play_action_cutin("sleep", WorldManager.current_tile_id, {"ok": true, "cutin_text": "정한 시간만큼 눈을 붙이며 몸의 열과 호흡을 되찾는다."})
	_show_action_result("sleep", {
		"ok": true,
		"action_id": "sleep",
		"text": _join_lines(summary_lines, "\n"),
		"items": daily_yields
	}, before_snapshot, after_snapshot)
	_maybe_show_night_review(days_advanced, before_snapshot, after_snapshot, summary_lines)
	_maybe_show_partner_suggestion("after_sleep", "sleep", {"days_advanced": days_advanced, "items": daily_yields})
	_maybe_show_early_survival_nudge("after_sleep")


func _show_status_detail(target_id: String) -> void:
	var status = CharacterManager.player_status
	var title := "플레이어 상태 상세"
	var show_trust := false
	if target_id == "partner":
		if not CharacterManager.partner_joined:
			return
		status = CharacterManager.partner_status
		title = "동행자 상태 상세"
		show_trust = true
	status_detail_title_label.text = title
	status_detail_body_label.text = _status_detail_text(status, show_trust)
	_set_status_detail_visual(status, show_trust)
	status_detail_panel.visible = true
	_fit_center_overlay(status_detail_panel, STATUS_DETAIL_DESIRED_SIZE)
	_raise_root_overlay(status_detail_panel, Z_ROOT_MODAL)


func _show_survival_guide() -> void:
	if status_detail_panel == null:
		return
	status_detail_title_label.text = "생존 가이드"
	status_detail_body_label.text = _survival_guide_text()
	_hide_status_detail_visual()
	status_detail_panel.visible = true
	_fit_center_overlay(status_detail_panel, STATUS_DETAIL_DESIRED_SIZE)
	_raise_root_overlay(status_detail_panel, Z_ROOT_MODAL)


func _show_top_info_detail(info_id: String) -> void:
	if status_detail_panel == null:
		return
	_hide_status_detail_visual()
	match info_id:
		"date":
			status_detail_title_label.text = "날짜"
			status_detail_body_label.text = _date_detail_text()
		"time":
			status_detail_title_label.text = "시간"
			status_detail_body_label.text = _time_detail_text()
		"weather":
			status_detail_title_label.text = "날씨"
			status_detail_body_label.text = _weather_detail_text()
		_:
			status_detail_title_label.text = "상세 정보"
			status_detail_body_label.text = _date_detail_text()
	status_detail_panel.visible = true
	_fit_center_overlay(status_detail_panel, STATUS_DETAIL_DESIRED_SIZE)
	_raise_root_overlay(status_detail_panel, Z_ROOT_MODAL)


func _set_status_detail_visual(status, show_trust: bool) -> void:
	if status_detail_visual_panel == null or status_detail_visual == null:
		return
	var visual_path := _status_signal_visual_path(status, show_trust)
	var texture = _texture_from_path(visual_path) if visual_path != "" else null
	if texture == null:
		_hide_status_detail_visual()
		return
	status_detail_visual.texture = texture
	status_detail_visual_panel.visible = true


func _hide_status_detail_visual() -> void:
	if status_detail_visual_panel != null:
		status_detail_visual_panel.visible = false


func _status_signal_visual_path(status, show_trust: bool) -> String:
	if status == null:
		return ""
	if show_trust and CharacterManager.partner_joined:
		if status.mood <= 35 or status.trust <= 35 or status.has_state("anxiety") or status.has_state("fear"):
			return _generated_ui_asset_path("companion_state", "companion_anxious")
		if status.stamina <= 30:
			return _generated_ui_asset_path("survival_status", "exhaustion")
		if status.trust >= 70 and status.mood >= 55:
			return _generated_ui_asset_path("companion_state", "companion_trust")
		return _generated_ui_asset_path("companion_state", "companion_relieved")
	if status.thirst <= 35 or status.has_state("thirst_risk"):
		return _generated_ui_asset_path("survival_status", "dehydration")
	if status.hunger <= 35 or status.has_state("hunger_risk"):
		return _generated_ui_asset_path("survival_status", "hunger")
	if status.stamina <= 35 or status.has_state("fatigue"):
		return _generated_ui_asset_path("survival_status", "exhaustion")
	if status.has_state("wet"):
		return _generated_ui_asset_path("survival_status", "wet_cold")
	return _generated_ui_asset_path("survival_status", "exhaustion") if status.hp <= 35 else ""


func _hide_status_detail_panel() -> void:
	status_detail_panel.visible = false


func _hide_night_review_panel() -> void:
	if night_review_panel != null:
		night_review_panel.visible = false
	active_night_review_context.clear()


func _maybe_show_night_review(days_advanced: int, before_snapshot: Dictionary, after_snapshot: Dictionary, summary_lines: Array[String]) -> void:
	if days_advanced <= 0 or not CharacterManager.partner_joined:
		return
	if EventManager.current_event != null:
		return
	if last_night_review_day == GameState.day:
		return
	last_night_review_day = GameState.day
	active_night_review_context = {
		"day": GameState.day,
		"before": before_snapshot.duplicate(true),
		"after": after_snapshot.duplicate(true),
		"summary": summary_lines.duplicate()
	}
	night_review_title_label.text = "밤의 회고"
	night_review_body_label.text = _night_review_text(before_snapshot, after_snapshot)
	_clear_children(night_review_buttons_box)
	night_review_buttons_box.add_child(_make_button("먼저 사과한다", Callable(self, "_on_night_review_choice").bind("apology"), "actions/talk"))
	night_review_buttons_box.add_child(_make_button("내일 계획", Callable(self, "_on_night_review_choice").bind("plan"), "actions/investigate"))
	night_review_buttons_box.add_child(_make_button("조용히 쉰다", Callable(self, "_on_night_review_choice").bind("quiet"), "actions/rest"))
	night_review_panel.visible = true
	_fit_center_overlay(night_review_panel, NIGHT_REVIEW_DESIRED_SIZE)
	_raise_root_overlay(night_review_panel, Z_ROOT_EVENT + 1)


func _night_review_text(before_snapshot: Dictionary, after_snapshot: Dictionary) -> String:
	var lines: Array[String] = []
	var partner = CharacterManager.partner_status
	var place := "거점" if BaseManager.is_at_base() else _tile_label(WorldManager.current_tile_id)
	lines.append("%s에서 하루가 접힌 뒤, 둘 사이에 남은 말이 천천히 떠오른다." % place)
	var latest_memory := CharacterManager.get_latest_relationship_memory_text("")
	if latest_memory != "":
		lines.append("최근 기억: %s" % latest_memory)
	var partner_before: Dictionary = before_snapshot.get("partner", {})
	var partner_after: Dictionary = after_snapshot.get("partner", {})
	var mood_delta := int(partner_after.get("mood", partner.mood)) - int(partner_before.get("mood", partner.mood))
	if partner.hp <= 35 or partner.has_state("wound"):
		lines.append("파트너는 상처가 닿는 곳을 피하며 조심스럽게 자리를 잡았다.")
	elif partner.thirst <= 35:
		lines.append("파트너는 자주 입술을 적시며 남은 물을 확인했다.")
	elif partner.hunger <= 35:
		lines.append("파트너는 배고프다는 말 대신 손끝을 문질렀다.")
	elif partner.stamina <= 30:
		lines.append("파트너는 잠들기 전까지도 눈꺼풀이 무거워 보였다.")
	elif partner.mood <= 40 or mood_delta < -2:
		lines.append("낮에 쌓인 긴장 때문인지, 파트너는 한동안 말을 고르지 못했다.")
	else:
		lines.append("파트너는 숨을 고르며 내일 움직일 길을 조용히 떠올렸다.")
	lines.append("")
	lines.append("반응: %s" % CharacterManager.get_relationship_cue_text())
	return _join_lines(lines, "\n")


func _on_night_review_choice(choice_id: String) -> void:
	if active_night_review_context.is_empty():
		_hide_night_review_panel()
		return
	var line := ""
	var memory_text := ""
	var memory_icon := "actions/talk"
	match choice_id:
		"apology":
			CharacterManager.partner_status.apply_delta({"mood": 3, "trust": 1, "affection": 2})
			line = "괜찮아. 그렇게 말해주면 조금 덜 무서워."
			memory_text = "무리한 하루 뒤, 먼저 사과하고 쉬어가기로 했다."
			memory_icon = "actions/talk"
		"plan":
			CharacterManager.partner_status.apply_delta({"mood": 1, "trust": 2, "affection": 1})
			line = "내일은 너무 멀리 가지 말자. 대신 필요한 건 같이 보자."
			memory_text = "밤이 지나기 전, 다음 날 움직일 순서를 함께 정했다."
			memory_icon = "actions/investigate"
		"quiet":
			CharacterManager.partner_status.apply_delta({"mood": 2})
			line = "고마워. 지금은 조금 조용히 있고 싶어."
			memory_text = "말을 더 얹지 않고, 지친 파트너가 쉴 시간을 남겼다."
			memory_icon = "actions/rest"
	if memory_text != "":
		CharacterManager.record_relationship_memory("night_review_%s_day_%d" % [choice_id, GameState.day], memory_text, memory_icon, 1)
		_append_log("밤의 회고: %s" % memory_text)
	CharacterManager.notify_status_changed()
	_hide_night_review_panel()
	_refresh_all()
	_show_partner_reaction_feedback("“%s”" % line, memory_icon)


func _survival_guide_text() -> String:
	var lines: Array[String] = []
	lines.append("1. 먼저 현재 타일을 조사해 안개를 걷힌다.")
	lines.append("2. 낮에는 물과 먹을 것을 우선 확보한다.")
	lines.append("3. 손에 맞는 도구를 만들고, 해가 지기 전 쉴 곳을 찾는다.")
	lines.append("4. 밤에는 조사와 제작이 막히거나 부담이 커진다. 불빛이 있으면 조금 버틸 수 있다.")
	lines.append("5. 무거운 자원은 필요한 곳에 내려두고, 다시 주워 가는 식으로 움직인다.")
	lines.append("")
	lines.append("초반 3일 흐름")
	var goals := _survival_loop_goal_rows()
	var next_goal := _next_survival_loop_goal()
	for day_index in [1, 2, 3]:
		lines.append("DAY %d" % day_index)
		for goal in goals:
			if int(goal.get("day", 1)) != day_index:
				continue
			var state := "완료" if bool(goal.get("done", false)) else "다음" if String(next_goal.get("id", "")) == String(goal.get("id", "")) else "대기"
			lines.append("- %s · %s: %s" % [state, String(goal.get("title", "")), String(goal.get("guide", ""))])
	return _join_lines(lines, "\n")


func _survival_loop_goal_rows() -> Array[Dictionary]:
	var start_tile_id := WorldManager.get_tile_id(2, 7)
	var cave_tile_id := WorldManager.get_tile_id(3, 6)
	return [
		{
			"id": "survey_start",
			"day": 1,
			"title": "해변 조사",
			"icon": "actions/investigate",
			"done": WorldManager.is_tile_investigated(start_tile_id),
			"guide": "발밑의 해변을 살피면 주변 안개와 채취 대상이 열린다.",
			"nudge": "먼저 발밑의 해변을 조사하자. 주변 안개와 채취 대상이 함께 열린다."
		},
		{
			"id": "secure_food_water",
			"day": 1,
			"title": "쉴 곳 찾기",
			"icon": "actions/place",
			"done": BaseManager.is_at_base() or GameState.has_flag("entered_base"),
			"guide": "초반에는 자원보다 먼저 바람과 밤을 피할 동굴을 찾는다.",
			"nudge": "주변 자원은 많지만 지금은 오래 머물 때가 아니다. 해가 지기 전에 쉴 곳을 찾아야 한다."
		},
		{
			"id": "secure_food_water",
			"day": 1,
			"title": "물과 먹을 것",
			"icon": "items/water",
			"done": _party_item_count_many(["water"]) >= 2 and _party_item_count_many(["berry", "wild_potato", "fish", "cooked_fish"]) >= 3,
			"guide": "동굴을 확보한 뒤 야자 열매, 열매 덤불, 물웅덩이를 챙긴다.",
			"nudge": "쉴 곳을 확인했다면 주변 자원을 챙기자. 야자 열매와 열매 덤불은 초반을 버티게 해준다."
		},
		{
			"id": "first_tool",
			"day": 1,
			"title": "첫 불",
			"icon": "items/campfire",
			"done": _has_any_party_item(["small_campfire", "campfire", "stone_oven", "torch"]) or BaseManager.has_any_placed_item(["small_campfire", "campfire", "stone_oven"]),
			"guide": "동굴의 마른 나뭇가지와 잎으로 작은 모닥불부터 만든다.",
			"nudge": "동굴에 마른 재료가 보이면 작은 모닥불부터 붙이자. 약해도 첫 밤을 버틸 수 있다."
		},
		{
			"id": "meet_partner",
			"day": 2,
			"title": "파트너 합류",
			"icon": "actions/talk",
			"done": CharacterManager.partner_joined,
			"guide": "초원 계열 타일을 조사하면 재회 단서가 열린다.",
			"nudge": "해변만 맴돌면 혼자 버티게 된다. 초원 쪽을 살피면 누군가의 흔적을 찾을 수 있다."
		},
		{
			"id": "find_base",
			"day": 2,
			"title": "거점 후보",
			"icon": "actions/place",
			"done": BaseManager.is_at_base() or WorldManager.is_tile_revealed(cave_tile_id),
			"guide": "동굴을 찾고, 바로 막힌 길은 돌아갈 경로를 찾는다.",
			"nudge": "밤을 제대로 넘기려면 동굴을 찾아야 한다. 바로 앞이 막혀도 돌아가는 길이 있을 수 있다."
		},
		{
			"id": "routine_source",
			"day": 2,
			"title": "물/음식 루틴",
			"icon": "items/berry",
			"done": _has_discovered_resource_object_type("freshwater_spring") or _has_discovered_resource_object_type("wild_potato_patch") or BaseManager.has_placed_item("rain_collector") or BaseManager.has_placed_item("fish_trap"),
			"guide": "한 번 줍는 자원보다 다시 돌아올 이유가 있는 장소를 기억한다.",
			"nudge": "하루치만 들고 다니면 곧 막힌다. 물웅덩이, 감자밭, 덫 같은 반복 루틴을 찾아두자."
		},
		{
			"id": "fire",
			"day": 3,
			"title": "불",
			"icon": "items/campfire",
			"done": _has_any_party_item(["small_campfire", "campfire", "stone_oven", "torch"]) or BaseManager.has_any_placed_item(["small_campfire", "campfire", "stone_oven"]),
			"guide": "작은 모닥불을 캠프파이어, 돌 화덕으로 키우면 요리와 밤 버티기가 안정된다.",
			"nudge": "셋째 날 폭풍 전에는 불을 준비하는 편이 좋다. 작은 모닥불이라도 밤과 젖음, 날고기 처리가 쉬워진다."
		},
		{
			"id": "hunt_or_fish",
			"day": 3,
			"title": "수렵 또는 낚시",
			"icon": "actions/fish",
			"done": _has_any_party_item(["snare_trap", "fish_trap", "fish", "raw_meat", "cooked_fish", "cooked_meat"]) or BaseManager.has_placed_item("fish_trap"),
			"guide": "채집만으로 버티되, 안정되면 단백질 루틴을 만든다.",
			"nudge": "열매만으로는 오래 버티기 어렵다. 덫, 낚시, 사냥 중 하나를 준비해보자."
		},
		{
			"id": "base_comfort",
			"day": 3,
			"title": "잠자리/보관",
			"icon": "items/simple_bed",
			"done": _has_any_party_item(["simple_bed", "storage_box", "leaf_shelter"]) or BaseManager.has_placed_item("simple_bed") or BaseManager.has_placed_item("storage_box") or BaseManager.has_placed_item("leaf_shelter"),
			"guide": "무거운 재료는 거점에 두고, 잠자리나 보관함으로 회복과 이동을 안정시킨다.",
			"nudge": "짐이 무거워지면 탐험이 끊긴다. 거점에 보관할 곳이나 마른 잠자리를 먼저 만들자."
		}
	]


func _next_survival_loop_goal() -> Dictionary:
	if GameState.day > 3:
		return {}
	var current_day := clampi(GameState.day, 1, 3)
	for goal in _survival_loop_goal_rows():
		if int(goal.get("day", 1)) <= current_day and not bool(goal.get("done", false)):
			return goal
	return {}


func _maybe_show_early_survival_nudge(trigger_id: String) -> void:
	if GameState.day > 3 or not GameState.has_flag(STARTING_ITEM_SELECTED_FLAG):
		return
	var goal := _next_survival_loop_goal()
	if goal.is_empty():
		return
	var goal_id := String(goal.get("id", ""))
	var flag_id := "early_survival_nudge_day_%d_%s" % [GameState.day, goal_id]
	if GameState.has_flag(flag_id):
		return
	GameState.set_flag(flag_id, true)
	var text := String(goal.get("nudge", ""))
	if text == "":
		return
	_append_log("생존 가이드: %s" % text)
	_show_sensory_toast(String(goal.get("icon", "actions/investigate")), text, Color(0.86, 0.74, 0.38))


func _party_item_count_many(item_ids: Array) -> int:
	var total := 0
	for item_id in item_ids:
		var id := String(item_id)
		total += InventoryManager.get_count(id, InventoryManager.OWNER_PLAYER)
		total += InventoryManager.get_count(id, InventoryManager.OWNER_PARTNER)
	return total


func _has_any_party_item(item_ids: Array) -> bool:
	return _party_item_count_many(item_ids) > 0


func _has_discovered_resource_object_type(type_id: String) -> bool:
	for y in range(WorldManager.TILE_MAP_SIZE):
		for x in range(WorldManager.TILE_MAP_SIZE):
			var tile_id := WorldManager.get_tile_id(x, y)
			if not WorldManager.is_tile_investigated(tile_id):
				continue
			for object in WorldManager.get_tile_resource_objects(tile_id, true):
				if String(object.get("type", "")) == type_id and int(object.get("remaining", 0)) > 0:
					return true
	return false


func _status_detail_text(status, show_trust: bool) -> String:
	if status == null:
		return "상태 정보 없음"
	var lines: Array[String] = []
	lines.append("체력 %d/100" % status.hp)
	lines.append("기력 %d/100" % status.stamina)
	lines.append("허기 %d/100" % status.hunger)
	lines.append("수분 %d/100" % status.thirst)
	lines.append("위생 %d/100 (%s)" % [status.hygiene, _hygiene_stage(status.hygiene)])
	lines.append("감정 %d/100 (%s)" % [status.mood, _mood_stage(status.mood)])
	if show_trust:
		lines.append("관계: %s" % CharacterManager.get_relationship_state_label())
		lines.append(CharacterManager.get_relationship_cue_text())
	lines.append("")
	lines.append("상태 효과")
	if status.states.is_empty():
		lines.append("- 기본 보통")
	else:
		for raw_state in status.states:
			lines.append("- %s" % _state_display_name(String(raw_state)))
	lines.append("")
	var pressure_lines := _survival_pressure_lines(status)
	if not pressure_lines.is_empty():
		lines.append("생존 압박")
		for pressure in pressure_lines:
			lines.append("- %s" % pressure)
		lines.append("")
	lines.append("관리 힌트")
	lines.append("- 허기와 수분이 0에 닿으면 체력이 감소한다.")
	lines.append("- 위생이 낮으면 위생불량이 생기고 상처가 악화될 수 있다.")
	lines.append("- 비, 낚시, 폭풍은 젖음 상태를 만들 수 있다.")
	lines.append("- 갈증, 허기, 젖음, 상처는 행동 기력 소모를 늘린다.")
	lines.append("- 갈증과 허기는 휴식/수면 회복량도 줄인다.")
	lines.append("- 동행 행동은 위험을 줄이지만 동행자 기력도 소모한다.")
	return _join_lines(lines, "\n")


func _survival_pressure_lines(status) -> Array[String]:
	var lines: Array[String] = []
	if status.thirst <= 20:
		lines.append("수분 부족: 행동이 무겁고 회복이 크게 줄어든다.")
	elif status.thirst <= 35:
		lines.append("갈증: 행동 기력 소모가 조금 늘어난다.")
	if status.hunger <= 20:
		lines.append("허기 위험: 힘이 빨리 빠지고 회복이 줄어든다.")
	elif status.hunger <= 35:
		lines.append("공복: 오래 움직이면 기력 소모가 커진다.")
	if status.has_state("wet"):
		lines.append("젖음: 휴식 회복이 줄고 밤을 보내면 더 지친다.")
	if status.has_state("wound"):
		lines.append("상처: 움직일 때 기력 부담이 커진다.")
	if status.has_state("poor_hygiene") and status.has_state("wound"):
		lines.append("오염된 상처: 감염 위험이 생길 수 있다.")
	if status.has_state("infection_risk"):
		lines.append("감염 위험: 하루가 지날 때 체력과 기력이 깎인다.")
	return lines


func _capture_play_state() -> Dictionary:
	return {
		"day": GameState.day,
		"action_points": GameState.action_points,
		"minutes": GameState.current_minutes,
		"tile_id": WorldManager.current_tile_id,
		"player": _status_snapshot(CharacterManager.player_status),
		"partner": _status_snapshot(CharacterManager.partner_status)
	}


func _status_snapshot(status) -> Dictionary:
	if status == null:
		return {}
	return {
		"hp": status.hp,
		"stamina": status.stamina,
		"hunger": status.hunger,
		"thirst": status.thirst,
		"hygiene": status.hygiene,
		"mood": status.mood,
		"trust": status.trust,
		"affection": status.affection
	}


func _snapshot_time_label(snapshot: Dictionary) -> String:
	return "Day %d %s" % [
		int(snapshot.get("day", 1)),
		_minutes_label(int(snapshot.get("minutes", 0)))
	]


func _build_action_delta_text(before_snapshot: Dictionary, after_snapshot: Dictionary, result: Dictionary) -> String:
	var lines: Array[String] = []
	var before_absolute := int(before_snapshot.get("day", 1)) * GameState.MINUTES_PER_DAY + int(before_snapshot.get("minutes", 0))
	var after_absolute := int(after_snapshot.get("day", 1)) * GameState.MINUTES_PER_DAY + int(after_snapshot.get("minutes", 0))
	var elapsed_minutes := after_absolute - before_absolute
	if elapsed_minutes > 0:
		lines.append("시간 +%d분 (%s -> %s)" % [
			elapsed_minutes,
			_snapshot_time_label(before_snapshot),
			_snapshot_time_label(after_snapshot)
		])
	var before_tile := String(before_snapshot.get("tile_id", ""))
	var after_tile := String(after_snapshot.get("tile_id", ""))
	if before_tile != after_tile:
		lines.append("위치: %s -> %s" % [_tile_label(before_tile), _tile_label(after_tile)])
	_add_status_delta_lines(lines, "플레이어", before_snapshot.get("player", {}), after_snapshot.get("player", {}), false)
	if CharacterManager.partner_joined or bool(result.get("together", false)):
		_add_status_delta_lines(lines, "동행자", before_snapshot.get("partner", {}), after_snapshot.get("partner", {}), false)
	if lines.is_empty():
		return "상태 변화 없음"
	return _join_lines(lines, "\n")


func _add_status_delta_lines(lines: Array[String], label: String, before_status: Dictionary, after_status: Dictionary, include_trust: bool) -> void:
	var keys: Array[String] = ["hp", "stamina", "hunger", "thirst", "hygiene", "mood"]
	var parts: Array[String] = []
	for key in keys:
		var delta := int(after_status.get(key, 0)) - int(before_status.get(key, 0))
		if delta != 0:
			parts.append("%s %s" % [_stat_display_name(key), _signed_int(delta)])
	if not parts.is_empty():
		lines.append("%s: %s" % [label, _join_lines(parts, " / ")])


func _flash_tile_node(tile_id: String) -> void:
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	if button == null:
		return
	button.modulate = Color(1.0, 0.92, 0.55)
	var tween := create_tween()
	tween.tween_property(button, "modulate", Color.WHITE, 0.35)


func _play_post_action_feedback(action_id: String, tile_id: String, before_tile_id: String, result: Dictionary) -> void:
	_flash_tile_node(tile_id)
	_play_screen_action_feedback(action_id, tile_id)
	_play_action_cutin(action_id, tile_id, result)
	_play_tile_action_fx(action_id, tile_id, before_tile_id, result)
	_show_action_sensory_bubble(action_id, tile_id, result)


func _play_screen_action_feedback(action_id: String, tile_id: String = "") -> void:
	var color := _action_cutin_color(action_id)
	match action_id:
		"move":
			_play_screen_streak(color, 0.16)
		"investigate":
			_play_screen_flash(color, 0.08, 0.18)
			_play_impact_ring_at_tile(tile_id, color)
		"gather":
			_play_screen_shake(1.4, 0.14)
		"hunt", "set_trap", "check_trap":
			_play_screen_shake(1.8, 0.16)
		"fish", "wash":
			_play_screen_flash(color, 0.18, 0.20)
		"develop":
			_play_screen_flash(color, 0.16, 0.20)
			_play_screen_shake(4.0, 0.24)
			_play_impact_ring_at_tile(tile_id, color)
		"enter_base":
			_play_screen_flash(color, 0.24, 0.26)
			_play_screen_shake(3.0, 0.22)
		"rest":
			_play_screen_flash(color, 0.06, 0.46)
		"craft":
			_play_screen_flash(color, 0.14, 0.20)
			_play_screen_shake(2.0, 0.16)
		_:
			_play_screen_flash(color, 0.10, 0.18)


func _play_action_cutin(action_id: String, tile_id: String, result: Dictionary = {}) -> void:
	if action_cutin_layer == null or not _should_show_action_cutin(action_id):
		return
	if action_cutin_tween != null and action_cutin_tween.is_valid():
		action_cutin_tween.kill()
	var color := _action_cutin_color(action_id)
	var icon_texture = _icon_texture(_action_icon_id(action_id))
	if action_cutin_icon != null:
		action_cutin_icon.texture = icon_texture
		action_cutin_icon.modulate = color.lightened(0.35)
	if action_cutin_title_label != null:
		action_cutin_title_label.text = _action_cutin_title(action_id)
		action_cutin_title_label.add_theme_color_override("font_color", color.lightened(0.35))
	if action_cutin_body_label != null:
		action_cutin_body_label.text = _action_cutin_body(action_id, tile_id, result)
	if action_cutin_backdrop != null:
		var visual_path := _action_cutin_visual_path(action_id, result)
		var visual_texture = _texture_from_path(visual_path) if visual_path != "" else null
		if visual_texture != null:
			action_cutin_backdrop.texture = visual_texture
			action_cutin_backdrop.modulate = Color(1.0, 1.0, 1.0, 0.88)
		else:
			var fallback_texture = _texture_from_path("res://assets/ui/action_cutin/action_cutin_panel.png")
			if fallback_texture != null:
				action_cutin_backdrop.texture = fallback_texture
			action_cutin_backdrop.modulate = color.lerp(Color.WHITE, 0.38)
	if action_cutin_streaks != null:
		action_cutin_streaks.position = Vector2(-180.0, 0.0)
		action_cutin_streaks.modulate = Color(color.r, color.g, color.b, 0.0)
	var content = action_cutin_layer.get_node_or_null("Content")
	if content != null:
		content.scale = Vector2(0.96, 0.96)
		content.position = Vector2(24.0, 0.0)
	action_cutin_layer.visible = true
	action_cutin_layer.modulate = Color(1, 1, 1, 0)
	_raise_root_overlay(action_cutin_layer, Z_ROOT_CUTIN)
	action_cutin_tween = create_tween()
	action_cutin_tween.set_parallel(true)
	action_cutin_tween.tween_property(action_cutin_layer, "modulate", Color(1, 1, 1, 1), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if content != null:
		action_cutin_tween.tween_property(content, "position", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		action_cutin_tween.tween_property(content, "scale", Vector2(1.0, 1.0), 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if action_cutin_streaks != null:
		action_cutin_tween.tween_property(action_cutin_streaks, "position", Vector2(100.0, 0.0), 0.72).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		action_cutin_tween.tween_property(action_cutin_streaks, "modulate", Color(color.r, color.g, color.b, 0.78), 0.12)
	action_cutin_tween.chain().tween_interval(0.42)
	if action_cutin_streaks != null:
		action_cutin_tween.chain().tween_property(action_cutin_streaks, "modulate", Color(color.r, color.g, color.b, 0.0), 0.18)
	action_cutin_tween.chain().tween_property(action_cutin_layer, "modulate", Color(1, 1, 1, 0), 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	action_cutin_tween.chain().tween_callback(func() -> void:
		if action_cutin_layer != null:
			action_cutin_layer.visible = false
	)


func _should_show_action_cutin(action_id: String) -> bool:
	return ["gather", "fish", "hunt", "set_trap", "check_trap", "develop", "wash", "enter_base", "craft", "sleep", "gift", "partner_comfort", "partner_care", "partner_check", "partner_plan"].has(action_id)


func _generated_ui_asset_path(category: String, asset_name: String) -> String:
	if category == "" or asset_name == "":
		return ""
	return "%s/%s/%s.png" % [GENERATED_UI_SIGNAL_ROOT, category, asset_name]


func _generated_transition_asset_path(asset_name: String) -> String:
	if asset_name == "":
		return ""
	return "%s/%s.png" % [GENERATED_UI_TRANSITION_ROOT, asset_name]


func _action_cutin_visual_path(action_id: String, result: Dictionary) -> String:
	var text := String(result.get("text", ""))
	if text.contains("망가") or text.contains("부서") or text.contains("파손"):
		return _generated_ui_asset_path("action_results", "tool_broken")
	var items: Dictionary = result.get("items", {})
	match action_id:
		"gather":
			if items.has("water"):
				return _generated_ui_asset_path("action_results", "water_found")
			if _result_has_food_item(items):
				return _generated_ui_asset_path("action_results", "food_gathered")
			return _generated_ui_asset_path("resource_objects", _resource_signal_asset_for_items(items))
		"fish":
			return _generated_ui_asset_path("action_results", "food_gathered")
		"hunt":
			return _generated_ui_asset_path("action_results", "trap_success") if not items.is_empty() else _generated_transition_asset_path("danger_alert")
		"set_trap":
			return _generated_transition_asset_path("danger_alert")
		"check_trap":
			return _generated_ui_asset_path("action_results", "trap_success") if not items.is_empty() else _generated_transition_asset_path("danger_alert")
		"wash":
			return _generated_ui_asset_path("action_results", "water_found")
		"enter_base":
			return _generated_transition_asset_path("base_transition")
		"develop", "sleep":
			return _base_growth_visual_path()
		"craft":
			return _generated_transition_asset_path("craft_transition")
		"gift":
			return _generated_ui_asset_path("companion_state", "companion_trust")
		"partner_comfort", "partner_care":
			return _generated_ui_asset_path("companion_state", "companion_relieved")
		"partner_check", "partner_plan":
			return _generated_ui_asset_path("companion_state", "companion_anxious")
	return ""


func _result_has_food_item(items: Dictionary) -> bool:
	for raw_item_id in items.keys():
		if ["berry", "wild_potato", "fish", "raw_meat", "cooked_fish", "cooked_meat", "dried_fish"].has(String(raw_item_id)):
			return true
	return false


func _resource_signal_asset_for_items(items: Dictionary) -> String:
	for raw_item_id in items.keys():
		match String(raw_item_id):
			"water":
				return "freshwater_spring"
			"berry":
				return "berry_bush"
			"wood", "palm_frond", "fiber", "vine":
				return "driftwood_pile"
			"stone", "sharp_stone", "clay":
				return "stone_outcrop"
	return "driftwood_pile"


func _base_growth_visual_path() -> String:
	var placed := BaseManager.get_placed_objects()
	if placed.is_empty():
		return _generated_ui_asset_path("base_growth", "camp_bare")
	var ids: Array[String] = []
	for raw_entry in placed:
		var entry: Dictionary = raw_entry
		ids.append(String(entry.get("id", "")))
	if ids.size() >= 5 or ids.has("workbench") or ids.has("mud_wall") or ids.has("drying_rack"):
		return _generated_ui_asset_path("base_growth", "camp_refuge")
	if ids.size() >= 3 or ids.has("simple_bed") or ids.has("rain_collector") or ids.has("storage_box"):
		return _generated_ui_asset_path("base_growth", "camp_improved")
	if ids.has("small_campfire") or ids.has("campfire") or ids.has("stone_oven") or ids.has("leaf_shelter"):
		return _generated_ui_asset_path("base_growth", "camp_fire_shelter")
	return _generated_ui_asset_path("base_growth", "camp_bare")


func _action_cutin_color(action_id: String) -> Color:
	match action_id:
		"investigate":
			return Color(0.92, 0.88, 0.42)
		"gather":
			return Color(0.46, 0.76, 0.34)
		"fish", "wash":
			return Color(0.36, 0.68, 0.88)
		"develop", "craft":
			return Color(0.92, 0.62, 0.30)
		"rest", "sleep":
			return Color(0.70, 0.74, 0.48)
		"enter_base":
			return Color(0.96, 0.72, 0.34)
		"gift":
			return Color(0.96, 0.56, 0.64)
		"partner_comfort", "partner_care", "partner_check", "partner_plan":
			return Color(0.86, 0.72, 0.48)
		"move":
			return Color(0.76, 0.66, 0.42)
	return Color(0.82, 0.76, 0.48)


func _action_cutin_title(action_id: String) -> String:
	match action_id:
		"investigate":
			return "흔적을 살핀다"
		"gather":
			return "쓸 만한 것을 모은다"
		"fish":
			return "물가에 집중한다"
		"develop":
			return "머물 곳을 다듬는다"
		"wash":
			return "흙과 땀을 씻어낸다"
		"rest":
			return "잠시 숨을 고른다"
		"sleep":
			return "몸을 맡기고 잔다"
		"craft":
			return "손끝으로 만든다"
		"enter_base":
			return "거점으로 들어간다"
		"gift":
			return "마음을 건넨다"
		"partner_comfort":
			return "불안을 가라앉힌다"
		"partner_care":
			return "곁을 챙긴다"
		"partner_check":
			return "표정을 살핀다"
		"partner_plan":
			return "오늘을 의논한다"
	return _action_display_name(action_id)


func _action_cutin_body(action_id: String, tile_id: String, result: Dictionary = {}) -> String:
	if result.has("cutin_text"):
		var text := String(result.get("cutin_text", "")).replace("\n", " ")
		if text.length() > 0:
			return text
	var tile_text := _tile_label(tile_id) if tile_id != "" else ""
	var method_body := _action_method_cutin_body(action_id, tile_text, String(result.get("method_id", "")))
	if method_body != "":
		return method_body
	match action_id:
		"investigate":
			return "%s 주변의 냄새와 발자국, 작은 흔적을 더듬어 본다." % tile_text
		"gather":
			return "%s에서 오늘 버틸 만한 자원을 찾아 손에 담는다." % tile_text
		"fish":
			return "물결의 리듬에 맞춰 줄을 늦추고 당긴다."
		"develop":
			return "%s의 거친 땅을 생활할 수 있는 자리로 바꿔 간다." % tile_text
		"wash":
			return "차가운 물이 피부에 남은 모래와 피로를 씻어낸다."
		"rest":
			return "바람 소리를 들으며 무너진 호흡을 천천히 되찾는다."
		"sleep":
			return "밤의 소리가 멀어지고 몸의 긴장이 풀린다."
		"craft":
			return "가진 재료를 맞대어 살아남기 위한 형태로 엮는다."
		"enter_base":
			return "밖의 소리가 조금 멀어지고 익숙한 물건들이 눈에 들어온다."
		"gift":
			return "작은 물건에 말로 다 못한 신경을 담는다."
		"partner_comfort":
			return "살아남아야 한다는 말 대신, 지금 곁에 있다는 사실을 전한다."
		"partner_care":
			return "남은 물자 일부를 내밀자 긴장이 조금 누그러진다."
		"partner_check":
			return "숫자로는 보이지 않는 피로와 불안을 말로 확인한다."
		"partner_plan":
			return "날씨와 몸 상태를 놓고 오늘의 움직임을 함께 고른다."
	return _action_life_description(action_id)


func _action_method_cutin_body(action_id: String, tile_text: String, method_id: String) -> String:
	if method_id == "":
		return ""
	match action_id:
		"gather":
			match method_id:
				"careful":
					return "%s의 풀잎과 모래를 손끝으로 걷어내며 필요한 것만 골라낸다." % tile_text
				"wide":
					return "%s 주변을 크게 돌며 눈에 띄지 않던 자원까지 훑는다." % tile_text
				"quick":
					return "%s에서 눈에 들어오는 것만 빠르게 챙기고 몸을 빼낸다." % tile_text
		"fish":
			match method_id:
				"patient":
					return "물결이 잦아들 때까지 숨을 고르고 줄 끝의 흔들림을 기다린다."
				"quick":
					return "짧게 던지고 바로 거두며 남은 시간을 아낀다."
				"quiet":
					return "발소리를 죽이고 얕은 물가의 그림자만 따라간다."
		"hunt":
			match method_id:
				"track":
					return "발자국과 꺾인 가지를 이어 보며 짐승과의 거리를 좁힌다."
				"drive":
					return "숨을 몰아쉬며 짐승을 열린 쪽으로 몰아붙인다."
				"cautious":
					return "물러설 길을 눈에 담아둔 채 조심스럽게 따라붙는다."
		"set_trap":
			match method_id:
				"hidden":
					return "손자국과 냄새를 잎과 흙으로 덮어 덫을 숨긴다."
				"quick":
					return "주변 기척이 커지기 전에 덫을 빠르게 걸고 물러난다."
				"sturdy":
					return "섬유를 한 번 더 감아 덫의 고정점을 단단히 묶는다."
	return ""


func _play_screen_flash(color: Color, alpha: float, duration: float) -> void:
	if screen_flash_overlay == null:
		return
	screen_flash_overlay.visible = true
	screen_flash_overlay.color = Color(color.r, color.g, color.b, alpha)
	_raise_root_overlay(screen_flash_overlay, Z_ROOT_CUTIN - 1)
	var tween := create_tween()
	tween.tween_property(screen_flash_overlay, "color:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func() -> void:
		if screen_flash_overlay != null:
			screen_flash_overlay.visible = false
	)


func _play_screen_streak(color: Color, alpha: float) -> void:
	if action_cutin_streaks == null:
		_play_screen_flash(color, alpha, 0.16)
		return
	var streak := TextureRect.new()
	streak.mouse_filter = Control.MOUSE_FILTER_IGNORE
	streak.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	streak.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	streak.stretch_mode = TextureRect.STRETCH_SCALE
	streak.texture = action_cutin_streaks.texture
	streak.modulate = Color(color.r, color.g, color.b, 0.0)
	streak.z_as_relative = false
	streak.z_index = Z_ROOT_CUTIN - 1
	add_child(streak)
	streak.position = Vector2(-240.0, 0.0)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(streak, "position", Vector2(80.0, 0.0), 0.38).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(streak, "modulate", Color(color.r, color.g, color.b, alpha), 0.08)
	tween.chain().tween_property(streak, "modulate", Color(color.r, color.g, color.b, 0.0), 0.18)
	tween.chain().tween_callback(func() -> void:
		if is_instance_valid(streak):
			streak.queue_free()
	)


func _play_screen_shake(intensity: float, duration: float) -> void:
	if map_camera == null:
		return
	var original := map_camera.position
	var tween := create_tween()
	var steps := maxi(3, int(duration / 0.035))
	for index in range(steps):
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(map_camera, "position", original + offset, duration / float(steps)).set_trans(Tween.TRANS_SINE)
	tween.tween_property(map_camera, "position", original, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _play_impact_ring_at_tile(tile_id: String, color: Color) -> void:
	if tile_id == "" or map_stack == null:
		return
	var local_center := _tile_marker_position_in_map_stack(tile_id, Vector2.ZERO)
	var ring := TextureRect.new()
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.custom_minimum_size = Vector2(96, 96)
	ring.size = Vector2(96, 96)
	ring.position = local_center - ring.size * 0.5
	ring.pivot_offset = ring.size * 0.5
	ring.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ring.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ring.modulate = Color(color.r, color.g, color.b, 0.0)
	var texture = _texture_from_path("res://assets/ui/action_cutin/impact_ring.png")
	if texture != null:
		ring.texture = texture
	map_stack.add_child(ring)
	_raise_effect_overlay(ring)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(ring, "modulate", Color(color.r, color.g, color.b, 0.82), 0.08)
	tween.tween_property(ring, "scale", Vector2(1.85, 1.85), 0.42).from(Vector2(0.45, 0.45)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(ring, "modulate", Color(color.r, color.g, color.b, 0.0), 0.18)
	tween.chain().tween_callback(func() -> void:
		if is_instance_valid(ring):
			ring.queue_free()
	)


func _play_tile_action_fx(action_id: String, tile_id: String, before_tile_id: String = "", result: Dictionary = {}) -> void:
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	if button == null:
		return
	match action_id:
		"move":
			_play_move_tile_fx(button, before_tile_id, tile_id)
		"investigate":
			_play_investigate_tile_fx(button, tile_id)
		"gather":
			_play_gather_tile_fx(button, tile_id, result)
		"fish":
			_play_fish_tile_fx(button, tile_id, result)
		"develop":
			_play_develop_tile_fx(button, tile_id)
		"wash":
			_play_wash_tile_fx(button)
		"rest":
			_play_rest_tile_fx(button)
		"enter_base":
			_play_enter_base_fx(button)
	var fx := PanelContainer.new()
	fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.anchor_left = 0.5
	fx.anchor_top = 0.5
	fx.anchor_right = 0.5
	fx.anchor_bottom = 0.5
	fx.offset_left = -34
	fx.offset_top = -26
	fx.offset_right = 34
	fx.offset_bottom = 0
	fx.add_theme_stylebox_override("panel", _make_panel_style(Color(0.02, 0.03, 0.03, 0.82), Color(0.96, 0.86, 0.42, 0.92), 6))
	button.add_child(fx)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 3)
	fx.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(14, 14)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(_action_icon_id(action_id))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var label := Label.new()
	label.text = _action_fx_text(action_id)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.98, 0.94, 0.72))
	row.add_child(label)

	var start_pos := fx.position
	fx.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(fx, "modulate", Color(1, 1, 1, 1), 0.08)
	tween.parallel().tween_property(fx, "position", start_pos + Vector2(0, -12), 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.25)
	tween.tween_property(fx, "modulate", Color(1, 1, 1, 0), 0.18)
	tween.tween_callback(fx.queue_free)


func _show_action_sensory_bubble(action_id: String, tile_id: String, result: Dictionary) -> void:
	if map_stack == null or map_grid == null:
		return
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	if button == null:
		return
	var cue := _action_sensory_cue(action_id, tile_id, result)
	var color: Color = cue.get("color", Color(0.72, 0.66, 0.42))
	var bubble := PanelContainer.new()
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.custom_minimum_size = Vector2(260, 34)
	bubble.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.035, 0.033, 0.92), color, 8))
	map_stack.add_child(bubble)
	_raise_effect_overlay(bubble)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 9)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 9)
	margin.add_theme_constant_override("margin_bottom", 5)
	bubble.add_child(margin)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 6)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(cue.get("icon", _action_icon_id(action_id))))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var label := Label.new()
	label.text = String(cue.get("text", _action_life_description(action_id)))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", color.lightened(0.34))
	row.add_child(label)

	var tile_center: Vector2 = map_stack.get_global_transform().affine_inverse() * button.get_global_rect().get_center()
	var target: Vector2 = tile_center + Vector2(-130, -58)
	target.x = clampf(target.x, UI_SAFE_PADDING, maxf(UI_SAFE_PADDING, map_stack.size.x - 270.0))
	target.y = clampf(target.y, UI_SAFE_PADDING, maxf(UI_SAFE_PADDING, map_stack.size.y - 48.0))
	bubble.position = target + Vector2(0, 8)
	bubble.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(bubble, "modulate", Color(1, 1, 1, 1), 0.12)
	tween.parallel().tween_property(bubble, "position", target, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.92)
	tween.tween_property(bubble, "modulate", Color(1, 1, 1, 0), 0.24)
	tween.tween_callback(func() -> void:
		if is_instance_valid(bubble):
			bubble.queue_free()
	)


func _action_sensory_cue(action_id: String, tile_id: String, result: Dictionary) -> Dictionary:
	var tile = WorldManager.get_tile(tile_id)
	var terrain := ""
	if tile != null:
		terrain = String(tile.get("terrain", ""))
	match action_id:
		"move":
			return {"text": _move_sensory_text(terrain), "icon": "actions/move", "color": Color(0.74, 0.64, 0.38)}
		"investigate":
			return {"text": _investigate_sensory_text(terrain), "icon": "actions/investigate", "color": Color(0.72, 0.78, 0.42)}
		"gather":
			return {"text": _gather_sensory_text(terrain, result), "icon": "actions/gather", "color": Color(0.48, 0.68, 0.36)}
		"fish":
			return {"text": "물비늘이 흔들리고 손끝에 줄의 떨림이 전해진다.", "icon": "actions/fish", "color": Color(0.38, 0.62, 0.78)}
		"hunt":
			return {"text": "풀잎이 눌린 자국을 따라 숨소리를 낮춘다.", "icon": "actions/gather", "color": Color(0.64, 0.50, 0.30)}
		"set_trap":
			return {"text": "나뭇가지와 끈이 길목 아래로 조용히 숨는다.", "icon": "items/fiber", "color": Color(0.62, 0.55, 0.34)}
		"check_trap":
			return {"text": "묶어 둔 끈이 팽팽한지 손끝으로 확인한다.", "icon": "items/fiber", "color": Color(0.70, 0.60, 0.34)}
		"wash":
			return {"text": "차가운 물이 피부의 열과 모래를 씻어낸다.", "icon": "items/water", "color": Color(0.40, 0.68, 0.82)}
		"rest":
			return {"text": "잠깐 앉자 발바닥의 열이 천천히 식는다.", "icon": "actions/rest", "color": Color(0.62, 0.66, 0.42)}
		"develop":
			return {"text": "손바닥에 거친 재료의 결이 남는다.", "icon": "actions/develop", "color": Color(0.74, 0.58, 0.32)}
	return {"text": _action_life_description(action_id), "icon": _action_icon_id(action_id), "color": Color(0.72, 0.66, 0.42)}


func _move_sensory_text(terrain: String) -> String:
	match terrain:
		"beach":
			return "모래가 발밑에서 밀리고 짠 바람이 얼굴을 친다."
		"forest":
			return "마른 가지가 부러지고 잎 냄새가 훅 올라온다."
		"river":
			return "물가의 축축한 흙이 발자국을 붙잡는다."
		"marsh":
			return "진흙이 발목을 놓아주지 않으려 한다."
		"cave":
			return "동굴 안쪽의 찬 공기가 목덜미를 스친다."
		"hill":
			return "돌길이 발바닥을 두드리고 숨이 가빠진다."
	return "발걸음에 맞춰 섬의 소리가 조금씩 바뀐다."


func _investigate_sensory_text(terrain: String) -> String:
	match terrain:
		"beach":
			return "파도에 밀려온 흔적을 손으로 헤집어 본다."
		"forest":
			return "잎사귀 아래를 들추자 축축한 흙 냄새가 번진다."
		"river":
			return "물소리를 따라 눈이 자연스럽게 움직인다."
		"cave":
			return "어둠 안쪽에서 울림이 낮게 되돌아온다."
	return "주변의 작은 흔적들이 하나씩 눈에 들어온다."


func _gather_sensory_text(terrain: String, result: Dictionary) -> String:
	var items: Dictionary = result.get("items", {})
	if items.has("berry"):
		return "손끝에 달큰한 열매즙이 조금 묻어난다."
	if items.has("water"):
		return "차가운 물이 손바닥에 고이며 목이 반응한다."
	match terrain:
		"beach":
			return "모래 사이에서 쓸 만한 것이 손에 걸린다."
		"forest":
			return "잎과 나뭇가지가 흩날리며 품 안에 쌓인다."
		"river":
			return "물가의 자갈과 젖은 풀을 골라낸다."
	return "손으로 더듬어 쓸 만한 것들을 챙긴다."


func _play_move_tile_fx(button: Control, before_tile_id: String = "", after_tile_id: String = "") -> void:
	_play_player_marker_move(before_tile_id, after_tile_id)
	for index in range(3):
		var step := PanelContainer.new()
		step.mouse_filter = Control.MOUSE_FILTER_IGNORE
		step.custom_minimum_size = Vector2(14, 9)
		step.position = Vector2(10 + index * 16, 42 - index * 10)
		step.rotation_degrees = -18 + index * 10
		step.add_theme_stylebox_override("panel", _make_panel_style(Color(0.96, 0.86, 0.52, 0.0), Color(0.96, 0.86, 0.52, 0.0), 8))
		button.add_child(step)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.07)
		tween.tween_method(func(alpha: float) -> void:
			if is_instance_valid(step):
				step.add_theme_stylebox_override("panel", _make_panel_style(Color(0.96, 0.86, 0.52, alpha), Color(0.96, 0.86, 0.52, alpha), 8))
		, 0.0, 0.80, 0.12)
		tween.tween_interval(0.22)
		tween.tween_method(func(alpha: float) -> void:
			if is_instance_valid(step):
				step.add_theme_stylebox_override("panel", _make_panel_style(Color(0.96, 0.86, 0.52, alpha), Color(0.96, 0.86, 0.52, alpha), 8))
		, 0.80, 0.0, 0.20)
		tween.tween_callback(func() -> void:
			if is_instance_valid(step):
				step.queue_free()
		)


func _play_player_marker_move(before_tile_id: String, after_tile_id: String) -> void:
	if before_tile_id == "" or after_tile_id == "" or before_tile_id == after_tile_id:
		return
	var from_button = map_grid.get_node_or_null("TileButton_%s" % before_tile_id)
	var to_button = map_grid.get_node_or_null("TileButton_%s" % after_tile_id)
	if from_button == null or to_button == null:
		return
	var final_marker = to_button.get_node_or_null("PlayerMarker")
	if final_marker != null:
		final_marker.visible = false
	var temp_marker := TextureRect.new()
	temp_marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	temp_marker.custom_minimum_size = Vector2(24, 24)
	temp_marker.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	temp_marker.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	temp_marker.z_as_relative = false
	temp_marker.z_index = Z_ACTION_FEEDBACK
	var texture = _texture_from_path("res://assets/icons/map/player_marker.png")
	if texture != null:
		temp_marker.texture = texture
	map_stack.add_child(temp_marker)
	var start_pos := _tile_marker_position_in_map_stack(before_tile_id, Vector2(-12, -12))
	var end_pos := _tile_marker_position_in_map_stack(after_tile_id, _tile_actor_marker_offset(after_tile_id, "player"))
	temp_marker.position = start_pos
	temp_marker.modulate = Color(1.0, 1.0, 1.0, 0.96)
	var tween := create_tween()
	tween.tween_property(temp_marker, "position", end_pos, 0.46).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(temp_marker, "scale", Vector2(1.08, 1.08), 0.20).from(Vector2(0.92, 0.92))
	tween.tween_callback(func() -> void:
		if final_marker != null and is_instance_valid(final_marker):
			final_marker.visible = true
		if is_instance_valid(temp_marker):
			temp_marker.queue_free()
	)


func _tile_marker_position_in_map_stack(tile_id: String, offset: Vector2) -> Vector2:
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	if button == null:
		return Vector2.ZERO
	var button_center: Vector2 = map_stack.get_global_transform().affine_inverse() * button.get_global_rect().get_center()
	return button_center + offset


func _play_investigate_tile_fx(button: Control, tile_id: String) -> void:
	var tile = WorldManager.get_tile(tile_id)
	var terrain := ""
	if tile != null:
		terrain = String(tile.get("terrain", ""))
	_play_investigate_scan_sweep(button, terrain)
	_play_investigate_clue_motes(button, terrain)
	for index in range(2):
		var ring := PanelContainer.new()
		ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ring.anchor_left = 0.5
		ring.anchor_top = 0.5
		ring.anchor_right = 0.5
		ring.anchor_bottom = 0.5
		ring.offset_left = -18
		ring.offset_top = -18
		ring.offset_right = 18
		ring.offset_bottom = 18
		ring.pivot_offset = Vector2(18, 18)
		ring.add_theme_stylebox_override("panel", _make_panel_style(Color(0.18, 0.28, 0.20, 0.06), Color(0.90, 0.96, 0.62, 0.75), 18))
		button.add_child(ring)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.10)
		tween.parallel().tween_property(ring, "scale", Vector2(1.75, 1.75), 0.48).from(Vector2(0.45, 0.45)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(ring, "modulate", Color(1, 1, 1, 0), 0.48).from(Color(1, 1, 1, 1))
		tween.tween_callback(func() -> void:
			if is_instance_valid(ring):
				ring.queue_free()
		)
	var spark := Label.new()
	spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spark.text = "!"
	spark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	spark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	spark.anchor_left = 0.5
	spark.anchor_right = 0.5
	spark.anchor_top = 0.5
	spark.anchor_bottom = 0.5
	spark.offset_left = -8
	spark.offset_right = 8
	spark.offset_top = -24
	spark.offset_bottom = -8
	spark.add_theme_font_size_override("font_size", 18)
	spark.add_theme_color_override("font_color", Color(1.0, 0.95, 0.62))
	button.add_child(spark)
	var spark_tween := create_tween()
	spark_tween.tween_property(spark, "position", spark.position + Vector2(0, -10), 0.38)
	spark_tween.parallel().tween_property(spark, "modulate", Color(1, 1, 1, 0), 0.38).from(Color(1, 1, 1, 1))
	spark_tween.tween_callback(func() -> void:
		if is_instance_valid(spark):
			spark.queue_free()
	)


func _play_investigate_scan_sweep(button: Control, terrain: String) -> void:
	var color := _investigate_scan_color(terrain)
	for index in range(2):
		var line := ColorRect.new()
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		line.color = Color(color.r, color.g, color.b, 0.0)
		line.custom_minimum_size = Vector2(92, 3)
		line.size = Vector2(92, 3)
		line.position = Vector2(-12, 20 + index * 18)
		line.rotation_degrees = -18
		button.add_child(line)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.11)
		tween.parallel().tween_property(line, "position", line.position + Vector2(38, 12), 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(line, "color", Color(color.r, color.g, color.b, 0.64), 0.10)
		tween.tween_property(line, "color", Color(color.r, color.g, color.b, 0.0), 0.22)
		tween.tween_callback(func() -> void:
			if is_instance_valid(line):
				line.queue_free()
		)


func _play_investigate_clue_motes(button: Control, terrain: String) -> void:
	var color := _investigate_scan_color(terrain).lightened(0.18)
	for index in range(6):
		var mote := PanelContainer.new()
		mote.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var size := Vector2(5 + index % 2, 5 + index % 2)
		mote.custom_minimum_size = size
		mote.size = size
		mote.position = Vector2(randf_range(20.0, 62.0), randf_range(22.0, 54.0))
		mote.add_theme_stylebox_override("panel", _make_panel_style(Color(color.r, color.g, color.b, 0.82), color.lightened(0.22), 8))
		button.add_child(mote)
		var drift := Vector2(randf_range(-10.0, 10.0), randf_range(-24.0, -10.0))
		var tween := create_tween()
		tween.tween_interval(0.10 + float(index) * 0.035)
		tween.parallel().tween_property(mote, "position", mote.position + drift, 0.44).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(mote, "scale", Vector2(1.5, 1.5), 0.16).from(Vector2(0.5, 0.5))
		tween.parallel().tween_property(mote, "modulate", Color(1, 1, 1, 0), 0.44).from(Color(1, 1, 1, 1))
		tween.tween_callback(func() -> void:
			if is_instance_valid(mote):
				mote.queue_free()
		)


func _investigate_scan_color(terrain: String) -> Color:
	match terrain:
		"cave", "ruins":
			return Color(0.74, 0.66, 0.94)
		"river", "marsh":
			return Color(0.62, 0.86, 0.94)
		"forest", "meadow":
			return Color(0.82, 0.92, 0.48)
	return Color(0.96, 0.86, 0.46)


func _play_gather_tile_fx(button: Control, tile_id: String, result: Dictionary) -> void:
	var tile = WorldManager.get_tile(tile_id)
	var terrain := ""
	if tile != null:
		terrain = String(tile.get("terrain", ""))
	_play_gather_swipe_fx(button, terrain)
	_play_gather_ground_rustle(button, terrain)
	_play_gather_particles(button, terrain)
	_play_gather_item_cards(tile_id, result)


func _play_gather_swipe_fx(button: Control, terrain: String) -> void:
	var color := _gather_particle_colors(terrain)[0].lightened(0.12)
	for index in range(2):
		var swipe := ColorRect.new()
		swipe.mouse_filter = Control.MOUSE_FILTER_IGNORE
		swipe.color = Color(color.r, color.g, color.b, 0.0)
		swipe.custom_minimum_size = Vector2(46, 4)
		swipe.size = Vector2(46, 4)
		swipe.position = Vector2(18 + index * 10, 20 + index * 14)
		swipe.rotation_degrees = 24 - index * 42
		button.add_child(swipe)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.12)
		tween.parallel().tween_property(swipe, "position", swipe.position + Vector2(16, 10), 0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(swipe, "color", Color(color.r, color.g, color.b, 0.68), 0.06)
		tween.tween_property(swipe, "color", Color(color.r, color.g, color.b, 0.0), 0.16)
		tween.tween_callback(func() -> void:
			if is_instance_valid(swipe):
				swipe.queue_free()
		)


func _play_gather_ground_rustle(button: Control, terrain: String) -> void:
	var color := _gather_particle_colors(terrain)[1]
	var patch := PanelContainer.new()
	patch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	patch.anchor_left = 0.5
	patch.anchor_top = 0.5
	patch.anchor_right = 0.5
	patch.anchor_bottom = 0.5
	patch.offset_left = -28
	patch.offset_top = -16
	patch.offset_right = 28
	patch.offset_bottom = 18
	patch.pivot_offset = Vector2(28, 17)
	patch.add_theme_stylebox_override("panel", _make_panel_style(Color(color.r, color.g, color.b, 0.10), Color(color.r, color.g, color.b, 0.34), 18))
	button.add_child(patch)
	var tween := create_tween()
	tween.parallel().tween_property(patch, "scale", Vector2(1.35, 0.92), 0.36).from(Vector2(0.72, 0.58)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(patch, "modulate", Color(1, 1, 1, 0), 0.42).from(Color(1, 1, 1, 0.78))
	tween.tween_callback(func() -> void:
		if is_instance_valid(patch):
			patch.queue_free()
	)


func _play_fish_tile_fx(button: Control, tile_id: String, result: Dictionary) -> void:
	for index in range(3):
		var ripple := PanelContainer.new()
		ripple.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ripple.anchor_left = 0.5
		ripple.anchor_top = 0.5
		ripple.anchor_right = 0.5
		ripple.anchor_bottom = 0.5
		ripple.offset_left = -20
		ripple.offset_top = -12
		ripple.offset_right = 20
		ripple.offset_bottom = 12
		ripple.pivot_offset = Vector2(20, 12)
		ripple.add_theme_stylebox_override("panel", _make_panel_style(Color(0.12, 0.32, 0.48, 0.08), Color(0.52, 0.86, 1.0, 0.72), 18))
		button.add_child(ripple)
		var ripple_tween := create_tween()
		ripple_tween.tween_interval(float(index) * 0.10)
		ripple_tween.parallel().tween_property(ripple, "scale", Vector2(2.05, 1.45), 0.56).from(Vector2(0.45, 0.35)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		ripple_tween.parallel().tween_property(ripple, "modulate", Color(1, 1, 1, 0), 0.56).from(Color(1, 1, 1, 0.88))
		ripple_tween.tween_callback(func() -> void:
			if is_instance_valid(ripple):
				ripple.queue_free()
		)
	for index in range(9):
		var drop := PanelContainer.new()
		drop.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var drop_size := Vector2(randf_range(3.0, 6.0), randf_range(5.0, 9.0))
		drop.custom_minimum_size = drop_size
		drop.size = drop_size
		drop.position = Vector2(randf_range(24.0, 54.0), randf_range(22.0, 42.0))
		drop.add_theme_stylebox_override("panel", _make_panel_style(Color(0.42, 0.72, 0.92, 0.88), Color(0.84, 0.96, 1.0, 0.92), 6))
		button.add_child(drop)
		var drift := Vector2(randf_range(-22.0, 22.0), randf_range(-34.0, -16.0))
		var drop_tween := create_tween()
		drop_tween.tween_interval(float(index) * 0.025)
		drop_tween.parallel().tween_property(drop, "position", drop.position + drift, 0.46).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		drop_tween.parallel().tween_property(drop, "modulate", Color(1, 1, 1, 0), 0.46).from(Color(1, 1, 1, 0.96))
		drop_tween.tween_callback(func() -> void:
			if is_instance_valid(drop):
				drop.queue_free()
		)
	_play_gather_item_cards(tile_id, result)


func _play_develop_tile_fx(button: Control, tile_id: String) -> void:
	_play_impact_ring_at_tile(tile_id, Color(0.96, 0.66, 0.30))
	var tool := TextureRect.new()
	tool.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tool.custom_minimum_size = Vector2(28, 28)
	tool.size = Vector2(28, 28)
	tool.position = button.size * 0.5 + Vector2(-14, -34)
	tool.pivot_offset = Vector2(14, 14)
	tool.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tool.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/develop")
	if texture != null:
		tool.texture = texture
	button.add_child(tool)
	var tool_tween := create_tween()
	tool_tween.tween_property(tool, "rotation_degrees", -22.0, 0.05).from(24.0)
	tool_tween.tween_property(tool, "rotation_degrees", 18.0, 0.08)
	tool_tween.parallel().tween_property(tool, "position", tool.position + Vector2(8, 12), 0.08)
	tool_tween.tween_interval(0.08)
	tool_tween.tween_property(tool, "modulate", Color(1, 1, 1, 0), 0.18)
	tool_tween.tween_callback(func() -> void:
		if is_instance_valid(tool):
			tool.queue_free()
	)
	for index in range(13):
		var chip := PanelContainer.new()
		chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var chip_size := Vector2(randf_range(4.0, 9.0), randf_range(3.0, 6.0))
		chip.custom_minimum_size = chip_size
		chip.size = chip_size
		chip.position = button.size * 0.5 + Vector2(randf_range(-10.0, 10.0), randf_range(-6.0, 8.0))
		chip.rotation_degrees = randf_range(-40.0, 40.0)
		var color := Color(0.62, 0.48, 0.30, 0.94) if index % 2 == 0 else Color(0.82, 0.62, 0.34, 0.94)
		chip.add_theme_stylebox_override("panel", _make_panel_style(color, color.lightened(0.18), 3))
		button.add_child(chip)
		var drift := Vector2(randf_range(-36.0, 36.0), randf_range(-32.0, 18.0))
		var chip_tween := create_tween()
		chip_tween.tween_interval(float(index) * 0.018)
		chip_tween.parallel().tween_property(chip, "position", chip.position + drift, 0.50).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		chip_tween.parallel().tween_property(chip, "rotation_degrees", chip.rotation_degrees + randf_range(-150.0, 150.0), 0.50)
		chip_tween.parallel().tween_property(chip, "modulate", Color(1, 1, 1, 0), 0.50).from(Color(1, 1, 1, 1))
		chip_tween.tween_callback(func() -> void:
			if is_instance_valid(chip):
				chip.queue_free()
		)


func _play_wash_tile_fx(button: Control) -> void:
	for index in range(2):
		var wave := PanelContainer.new()
		wave.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wave.anchor_left = 0.5
		wave.anchor_top = 0.5
		wave.anchor_right = 0.5
		wave.anchor_bottom = 0.5
		wave.offset_left = -24
		wave.offset_top = -18
		wave.offset_right = 24
		wave.offset_bottom = 18
		wave.pivot_offset = Vector2(24, 18)
		wave.add_theme_stylebox_override("panel", _make_panel_style(Color(0.18, 0.42, 0.58, 0.10), Color(0.62, 0.90, 1.0, 0.78), 20))
		button.add_child(wave)
		var wave_tween := create_tween()
		wave_tween.tween_interval(float(index) * 0.12)
		wave_tween.parallel().tween_property(wave, "scale", Vector2(1.70, 1.35), 0.60).from(Vector2(0.55, 0.45)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		wave_tween.parallel().tween_property(wave, "modulate", Color(1, 1, 1, 0), 0.60).from(Color(1, 1, 1, 0.92))
		wave_tween.tween_callback(func() -> void:
			if is_instance_valid(wave):
				wave.queue_free()
		)
	for index in range(12):
		var foam := PanelContainer.new()
		foam.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var foam_size := Vector2(randf_range(4.0, 8.0), randf_range(4.0, 8.0))
		foam.custom_minimum_size = foam_size
		foam.size = foam_size
		foam.position = Vector2(randf_range(22.0, 56.0), randf_range(24.0, 50.0))
		foam.add_theme_stylebox_override("panel", _make_panel_style(Color(0.82, 0.96, 1.0, 0.86), Color(0.94, 1.0, 1.0, 0.94), 8))
		button.add_child(foam)
		var foam_tween := create_tween()
		foam_tween.tween_interval(float(index) * 0.02)
		foam_tween.parallel().tween_property(foam, "position", foam.position + Vector2(randf_range(-20.0, 20.0), randf_range(-26.0, -8.0)), 0.46)
		foam_tween.parallel().tween_property(foam, "modulate", Color(1, 1, 1, 0), 0.46).from(Color(1, 1, 1, 0.90))
		foam_tween.tween_callback(func() -> void:
			if is_instance_valid(foam):
				foam.queue_free()
		)


func _play_rest_tile_fx(button: Control) -> void:
	_play_rest_breath_fx(button)
	var aura := PanelContainer.new()
	aura.mouse_filter = Control.MOUSE_FILTER_IGNORE
	aura.anchor_left = 0.5
	aura.anchor_top = 0.5
	aura.anchor_right = 0.5
	aura.anchor_bottom = 0.5
	aura.offset_left = -32
	aura.offset_top = -26
	aura.offset_right = 32
	aura.offset_bottom = 26
	aura.pivot_offset = Vector2(32, 26)
	aura.add_theme_stylebox_override("panel", _make_panel_style(Color(0.42, 0.46, 0.22, 0.10), Color(0.86, 0.86, 0.52, 0.62), 26))
	button.add_child(aura)
	var aura_tween := create_tween()
	aura_tween.parallel().tween_property(aura, "scale", Vector2(1.28, 1.16), 0.58).from(Vector2(0.84, 0.78)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	aura_tween.parallel().tween_property(aura, "modulate", Color(1, 1, 1, 0), 0.58).from(Color(1, 1, 1, 0.88))
	aura_tween.tween_callback(func() -> void:
		if is_instance_valid(aura):
			aura.queue_free()
	)
	for index in range(7):
		var mote := PanelContainer.new()
		mote.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mote.custom_minimum_size = Vector2(5, 5)
		mote.size = Vector2(5, 5)
		mote.position = Vector2(randf_range(24.0, 56.0), randf_range(32.0, 54.0))
		mote.add_theme_stylebox_override("panel", _make_panel_style(Color(0.94, 0.86, 0.50, 0.86), Color(1.0, 0.96, 0.70, 0.94), 8))
		button.add_child(mote)
		var mote_tween := create_tween()
		mote_tween.tween_interval(float(index) * 0.08)
		mote_tween.parallel().tween_property(mote, "position", mote.position + Vector2(randf_range(-10.0, 10.0), randf_range(-34.0, -18.0)), 0.72)
		mote_tween.parallel().tween_property(mote, "modulate", Color(1, 1, 1, 0), 0.72).from(Color(1, 1, 1, 0.88))
		mote_tween.tween_callback(func() -> void:
			if is_instance_valid(mote):
				mote.queue_free()
		)


func _play_rest_breath_fx(button: Control) -> void:
	for index in range(3):
		var breath := Label.new()
		breath.mouse_filter = Control.MOUSE_FILTER_IGNORE
		breath.text = "Z" if index == 0 else "."
		breath.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		breath.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		breath.add_theme_font_size_override("font_size", 13 - index)
		breath.add_theme_color_override("font_color", Color(0.92, 0.88, 0.58, 0.86))
		breath.position = Vector2(45 + index * 7, 30 - index * 3)
		breath.size = Vector2(16, 16)
		button.add_child(breath)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.18)
		tween.parallel().tween_property(breath, "position", breath.position + Vector2(4 + index * 2, -28 - index * 4), 0.86).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(breath, "modulate", Color(1, 1, 1, 0), 0.86).from(Color(1, 1, 1, 0.86))
		tween.tween_callback(func() -> void:
			if is_instance_valid(breath):
				breath.queue_free()
		)
	var shade := ColorRect.new()
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shade.color = Color(0.08, 0.10, 0.08, 0.0)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	button.add_child(shade)
	var shade_tween := create_tween()
	shade_tween.tween_property(shade, "color", Color(0.08, 0.10, 0.08, 0.16), 0.22)
	shade_tween.tween_property(shade, "color", Color(0.08, 0.10, 0.08, 0.0), 0.58)
	shade_tween.tween_callback(func() -> void:
		if is_instance_valid(shade):
			shade.queue_free()
	)


func _play_enter_base_fx(button: Control) -> void:
	var glow := PanelContainer.new()
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow.anchor_left = 0.5
	glow.anchor_top = 0.5
	glow.anchor_right = 0.5
	glow.anchor_bottom = 0.5
	glow.offset_left = -26
	glow.offset_top = -34
	glow.offset_right = 26
	glow.offset_bottom = 24
	glow.pivot_offset = Vector2(26, 34)
	glow.add_theme_stylebox_override("panel", _make_panel_style(Color(0.68, 0.42, 0.12, 0.18), Color(1.0, 0.78, 0.34, 0.82), 8))
	button.add_child(glow)
	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(30, 30)
	icon.size = Vector2(30, 30)
	icon.position = button.size * 0.5 + Vector2(-15, -19)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/place")
	if texture != null:
		icon.texture = texture
	button.add_child(icon)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(glow, "scale", Vector2(1.30, 1.08), 0.42).from(Vector2(0.72, 0.82)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(glow, "modulate", Color(1, 1, 1, 0), 0.54).from(Color(1, 1, 1, 0.96))
	tween.tween_property(icon, "position", icon.position + Vector2(0, -8), 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(icon, "modulate", Color(1, 1, 1, 0), 0.54).from(Color(1, 1, 1, 1))
	tween.chain().tween_callback(func() -> void:
		if is_instance_valid(glow):
			glow.queue_free()
		if is_instance_valid(icon):
			icon.queue_free()
	)


func _play_gather_particles(button: Control, terrain: String) -> void:
	var colors := _gather_particle_colors(terrain)
	for index in range(12):
		var particle := PanelContainer.new()
		particle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var size := Vector2(randf_range(4.0, 9.0), randf_range(3.0, 7.0))
		particle.custom_minimum_size = size
		particle.size = size
		particle.position = Vector2(randf_range(18.0, 46.0), randf_range(28.0, 48.0))
		particle.rotation_degrees = randf_range(-28.0, 28.0)
		var color := colors[index % colors.size()]
		particle.add_theme_stylebox_override("panel", _make_panel_style(color, color.lightened(0.18), 4))
		button.add_child(particle)
		var drift := Vector2(randf_range(-34.0, 34.0), randf_range(-36.0, -12.0))
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.025)
		tween.parallel().tween_property(particle, "position", particle.position + drift, 0.58).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(particle, "rotation_degrees", particle.rotation_degrees + randf_range(-110.0, 110.0), 0.58)
		tween.parallel().tween_property(particle, "modulate", Color(1, 1, 1, 0), 0.58).from(Color(1, 1, 1, 0.92))
		tween.tween_callback(func() -> void:
			if is_instance_valid(particle):
				particle.queue_free()
		)


func _gather_particle_colors(terrain: String) -> Array[Color]:
	match terrain:
		"beach":
			return [Color(0.88, 0.76, 0.48), Color(0.74, 0.62, 0.38), Color(0.96, 0.86, 0.60)]
		"forest":
			return [Color(0.30, 0.58, 0.24), Color(0.52, 0.36, 0.18), Color(0.42, 0.70, 0.28)]
		"meadow":
			return [Color(0.44, 0.72, 0.30), Color(0.72, 0.66, 0.34), Color(0.30, 0.54, 0.24)]
		"river":
			return [Color(0.34, 0.66, 0.86), Color(0.72, 0.86, 0.92), Color(0.32, 0.48, 0.36)]
		"marsh":
			return [Color(0.30, 0.46, 0.28), Color(0.46, 0.38, 0.22), Color(0.54, 0.62, 0.34)]
		"cave", "hill", "ruins":
			return [Color(0.50, 0.46, 0.40), Color(0.34, 0.32, 0.30), Color(0.66, 0.58, 0.42)]
	return [Color(0.58, 0.66, 0.40), Color(0.48, 0.40, 0.26), Color(0.72, 0.64, 0.42)]


func _play_gather_item_cards(tile_id: String, result: Dictionary) -> void:
	var items: Dictionary = result.get("items", {})
	if items.is_empty():
		return
	var start_position := _tile_center_in_root(tile_id) + Vector2(-34.0, -18.0)
	var end_position := _inventory_target_in_root()
	var keys := items.keys()
	keys.sort()
	var index := 0
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var amount := int(items[raw_item_id])
		if amount <= 0:
			continue
		var card := _make_flying_resource_card(item_id, amount)
		card.position = start_position + Vector2(float(index) * 8.0, float(index) * 4.0)
		card.modulate = Color(1, 1, 1, 0)
		add_child(card)
		_raise_effect_overlay(card)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.10)
		tween.tween_property(card, "modulate", Color(1, 1, 1, 1), 0.10)
		tween.parallel().tween_property(card, "position", end_position + Vector2(float(index) * 5.0, 0.0), 0.64).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(card, "scale", Vector2(0.72, 0.72), 0.64).from(Vector2(1.0, 1.0))
		tween.tween_property(card, "modulate", Color(1, 1, 1, 0), 0.16)
		tween.tween_callback(func() -> void:
			if is_instance_valid(card):
				card.queue_free()
		)
		index += 1


func _play_item_transfer_animation(item_id: String, amount: int, start_position: Vector2, end_position: Vector2) -> void:
	var card := _make_flying_resource_card(item_id, amount)
	card.position = start_position - card.size * 0.5
	card.modulate = Color(1, 1, 1, 0)
	add_child(card)
	_raise_root_overlay(card, Z_ROOT_TOAST - 2)
	var mid_position := (start_position + end_position) * 0.5 + Vector2(0.0, -42.0)
	var tween := create_tween()
	tween.tween_property(card, "modulate", Color(1, 1, 1, 1), 0.08)
	tween.parallel().tween_property(card, "position", mid_position - card.size * 0.5, 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(card, "scale", Vector2(1.05, 1.05), 0.20).from(Vector2(0.86, 0.86))
	tween.tween_property(card, "position", end_position - card.size * 0.5, 0.28).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(card, "scale", Vector2(0.58, 0.58), 0.28).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(card, "modulate", Color(1, 1, 1, 0), 0.12)
	tween.tween_callback(func() -> void:
		if is_instance_valid(card):
			card.queue_free()
	)


func _make_flying_resource_card(item_id: String, amount: int) -> PanelContainer:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var card := PanelContainer.new()
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.custom_minimum_size = Vector2(76, 42)
	card.size = Vector2(76, 42)
	card.add_theme_stylebox_override("panel", _make_panel_style(Color(0.065, 0.085, 0.074, 0.96), Color(0.92, 0.78, 0.36), 6))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 5)
	card.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = "%s x%d" % [display_name, amount]
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.96, 0.92, 0.76))
	row.add_child(label)
	return card


func _play_craft_result_fx(result: Dictionary) -> void:
	var origin := _craft_fx_origin_in_root()
	var color := Color(0.96, 0.68, 0.28)
	for index in range(14):
		var spark := PanelContainer.new()
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var spark_size := Vector2(randf_range(4.0, 9.0), randf_range(3.0, 7.0))
		spark.custom_minimum_size = spark_size
		spark.size = spark_size
		spark.position = origin + Vector2(randf_range(-26.0, 26.0), randf_range(-14.0, 18.0))
		spark.rotation_degrees = randf_range(-45.0, 45.0)
		var spark_color := color.lightened(randf_range(0.0, 0.22))
		spark.add_theme_stylebox_override("panel", _make_panel_style(spark_color, Color(1.0, 0.90, 0.56, 0.94), 4))
		add_child(spark)
		_raise_effect_overlay(spark)
		var drift := Vector2(randf_range(-42.0, 42.0), randf_range(-48.0, -12.0))
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.018)
		tween.parallel().tween_property(spark, "position", spark.position + drift, 0.52).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(spark, "rotation_degrees", spark.rotation_degrees + randf_range(-180.0, 180.0), 0.52)
		tween.parallel().tween_property(spark, "modulate", Color(1, 1, 1, 0), 0.52).from(Color(1, 1, 1, 0.96))
		tween.tween_callback(func() -> void:
			if is_instance_valid(spark):
				spark.queue_free()
		)
	var items: Dictionary = result.get("items", {})
	if items.is_empty():
		return
	var target := _inventory_target_in_root()
	var keys := items.keys()
	keys.sort()
	var card_index := 0
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var amount := int(items[raw_item_id])
		if amount <= 0:
			continue
		var card := _make_flying_resource_card(item_id, amount)
		card.position = origin + Vector2(-36.0 + float(card_index) * 12.0, -8.0 + float(card_index) * 3.0)
		card.modulate = Color(1, 1, 1, 0)
		add_child(card)
		_raise_effect_overlay(card)
		var card_tween := create_tween()
		card_tween.tween_interval(0.12 + float(card_index) * 0.08)
		card_tween.tween_property(card, "modulate", Color(1, 1, 1, 1), 0.10)
		card_tween.parallel().tween_property(card, "position", target + Vector2(float(card_index) * 5.0, -8.0), 0.58).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		card_tween.parallel().tween_property(card, "scale", Vector2(0.72, 0.72), 0.58).from(Vector2(1.0, 1.0))
		card_tween.tween_property(card, "modulate", Color(1, 1, 1, 0), 0.18)
		card_tween.tween_callback(func() -> void:
			if is_instance_valid(card):
				card.queue_free()
		)
		card_index += 1


func _craft_fx_origin_in_root() -> Vector2:
	if tool_menu_panel != null and tool_menu_panel.visible:
		return get_global_transform().affine_inverse() * tool_menu_panel.get_global_rect().get_center()
	if player_info_box != null:
		return get_global_transform().affine_inverse() * player_info_box.get_global_rect().get_center()
	return size * 0.5


func _tile_center_in_root(tile_id: String) -> Vector2:
	var button = map_grid.get_node_or_null("TileButton_%s" % tile_id)
	if button == null:
		return size * 0.5
	var global_center: Vector2 = button.get_global_rect().get_center()
	return get_global_transform().affine_inverse() * global_center


func _inventory_target_in_root() -> Vector2:
	if player_info_box != null:
		var global_center: Vector2 = player_info_box.get_global_rect().get_center()
		return get_global_transform().affine_inverse() * global_center
	return Vector2(96, size.y * 0.5)


func _show_together_action_feedback(action_id: String) -> void:
	if player_image_frame == null or partner_image_frame == null:
		return
	var player_center := player_image_frame.get_global_rect().get_center()
	var partner_center := partner_image_frame.get_global_rect().get_center()
	var local_player := get_global_transform().affine_inverse() * player_center
	var local_partner := get_global_transform().affine_inverse() * partner_center
	var line := ColorRect.new()
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.color = Color(0.96, 0.78, 0.34, 0.72)
	line.position = Vector2(minf(local_player.x, local_partner.x), minf(local_player.y, local_partner.y) + 8.0)
	line.size = Vector2(absf(local_partner.x - local_player.x), 3.0)
	add_child(line)

	var bubble := PanelContainer.new()
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.anchor_left = 0.5
	bubble.anchor_right = 0.5
	bubble.anchor_top = 0.0
	bubble.anchor_bottom = 0.0
	bubble.offset_left = -185
	bubble.offset_right = 185
	bubble.offset_top = 116
	bubble.offset_bottom = 164
	bubble.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.08, 0.065, 0.94), Color(0.94, 0.78, 0.36), 7))
	add_child(bubble)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	bubble.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/assist")
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = _together_banter_text(action_id)
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color(0.96, 0.92, 0.78))
	row.add_child(label)

	if partner_banter_tween != null and partner_banter_tween.is_valid():
		partner_banter_tween.kill()
	partner_banter_tween = create_tween()
	partner_banter_tween.set_parallel(true)
	line.modulate = Color(1, 1, 1, 0)
	bubble.modulate = Color(1, 1, 1, 0)
	partner_banter_tween.tween_property(line, "modulate", Color(1, 1, 1, 1), 0.18)
	partner_banter_tween.tween_property(bubble, "modulate", Color(1, 1, 1, 1), 0.18)
	partner_banter_tween.chain().tween_interval(1.05)
	partner_banter_tween.chain().tween_property(line, "modulate", Color(1, 1, 1, 0), 0.25)
	partner_banter_tween.parallel().tween_property(bubble, "modulate", Color(1, 1, 1, 0), 0.25)
	partner_banter_tween.chain().tween_callback(func() -> void:
		if is_instance_valid(line):
			line.queue_free()
		if is_instance_valid(bubble):
			bubble.queue_free()
	)


func _show_partner_reaction_feedback(text: String, icon_id: String = "actions/talk") -> void:
	if text == "" or partner_image_frame == null:
		return
	var partner_rect := partner_image_frame.get_global_rect()
	var local_anchor := get_global_transform().affine_inverse() * Vector2(partner_rect.position.x + partner_rect.size.x * 0.5, partner_rect.position.y + 18.0)
	var bubble := PanelContainer.new()
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.custom_minimum_size = Vector2(272, 48)
	bubble.size = Vector2(272, 48)
	bubble.position = Vector2(
		clampf(local_anchor.x - 136.0, 18.0, maxf(18.0, size.x - 290.0)),
		clampf(local_anchor.y, 96.0, maxf(96.0, size.y - 76.0))
	)
	bubble.z_as_relative = false
	bubble.z_index = Z_ROOT_TOAST - 1
	bubble.add_theme_stylebox_override("panel", _make_panel_style(Color(0.055, 0.075, 0.065, 0.95), Color(0.94, 0.78, 0.36, 0.88), 8))
	add_child(bubble)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	bubble.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color(0.96, 0.92, 0.78))
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)

	bubble.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(bubble, "modulate", Color(1, 1, 1, 1), 0.16)
	tween.tween_interval(1.55)
	tween.tween_property(bubble, "modulate", Color(1, 1, 1, 0), 0.28)
	tween.tween_callback(func() -> void:
		if is_instance_valid(bubble):
			bubble.queue_free()
	)


func _maybe_show_partner_suggestion(trigger_id: String, action_id: String = "", context: Dictionary = {}) -> void:
	if not _can_show_partner_suggestion():
		return
	var suggestion := _partner_suggestion_for_context(trigger_id, action_id, context)
	if suggestion.is_empty():
		return
	var key := String(suggestion.get("key", trigger_id))
	if _partner_suggestion_is_suppressed(key):
		return
	var text := String(suggestion.get("text", ""))
	if text == "":
		return
	_mark_partner_suggestion(key)
	var icon_id := String(suggestion.get("icon", "actions/talk"))
	_append_log("파트너: \"%s\"" % text)
	_show_partner_reaction_feedback(text, icon_id)


func _can_show_partner_suggestion() -> bool:
	if top_status_label == null or partner_image_frame == null:
		return false
	if not CharacterManager.partner_joined:
		return false
	return _can_talk_to_partner()


func _partner_suggestion_for_context(trigger_id: String, action_id: String, context: Dictionary) -> Dictionary:
	var tile_id := String(context.get("tile_id", selected_tile_id if selected_tile_id != "" else WorldManager.current_tile_id))
	if tile_id == "":
		tile_id = WorldManager.current_tile_id
	var tile = WorldManager.get_tile(tile_id)
	match trigger_id:
		"day_start":
			return _partner_day_start_suggestion()
		"tile_selected":
			return _partner_tile_selected_suggestion(tile_id, tile)
		"before_action":
			var before_suggestion := _partner_before_action_suggestion(action_id, tile_id, tile)
			if not before_suggestion.is_empty():
				return before_suggestion
			return _partner_state_suggestion()
		"after_action":
			return _partner_after_action_suggestion(action_id, tile_id, tile, context)
		"after_craft":
			var craft_suggestion := _partner_after_craft_suggestion(action_id)
			if not craft_suggestion.is_empty():
				return craft_suggestion
			return _partner_state_suggestion()
		"after_sleep":
			if int(context.get("days_advanced", 0)) > 0:
				return _partner_day_start_suggestion()
			return _partner_state_suggestion()
	return {}


func _partner_action_preview_for_context(action_id: String, tile_id: String = "") -> Dictionary:
	if not _can_show_partner_suggestion():
		return {}
	var resolved_tile_id := tile_id if tile_id != "" else selected_tile_id
	if resolved_tile_id == "":
		resolved_tile_id = WorldManager.current_tile_id
	var tile = WorldManager.get_tile(resolved_tile_id)
	var warning := _partner_before_action_suggestion(action_id, resolved_tile_id, tile)
	if not warning.is_empty():
		return warning
	var state_suggestion := _partner_state_suggestion()
	if not state_suggestion.is_empty():
		return state_suggestion
	return _partner_action_intent_suggestion(action_id, resolved_tile_id, tile)


func _partner_action_intent_suggestion(action_id: String, tile_id: String, tile) -> Dictionary:
	var personality_id := _partner_personality_id()
	var relationship_id := CharacterManager.get_relationship_state_id()
	var key := "intent_%s_%s_%s" % [action_id, personality_id, relationship_id]
	var icon_id := _action_icon_id(action_id)
	var line := ""
	match action_id:
		"move":
			if relationship_id == "guarded":
				line = "먼저 길을 확인해줘. 너무 빨리 멀어지진 말고."
			elif relationship_id == "deep_bond":
				line = "내가 뒤쪽을 볼게. 너는 앞만 봐."
			else:
				line = "움직일 거면 돌아올 길도 같이 기억해두자."
		"investigate":
			if personality_id == "curious":
				line = "여기엔 그냥 지나치면 놓칠 흔적이 있을지도 몰라."
			elif relationship_id == "reliable_distance":
				line = "네가 앞을 보면 나는 주변 소리를 볼게."
			else:
				line = "천천히 살피자. 발밑부터 확인하면 덜 위험해."
		"gather":
			if CharacterManager.partner_status.stamina <= 30:
				line = "챙기긴 하자. 대신 오래 버티기는 힘들어."
			elif relationship_id == "warm_anxiety":
				line = "같이 있으면 괜찮아. 무리하지 않는 만큼만 줍자."
			else:
				line = "보이는 것부터 나눠 들면 짐이 덜 부담될 거야."
		"fish":
			if personality_id == "optimistic":
				line = "조용히 기다리면 오늘 저녁은 조금 나아질지도 몰라."
			else:
				line = "물가에 오래 있으면 몸이 식어. 짧게 판단하자."
		"hunt":
			if personality_id == "cautious":
				line = "흔적만 보고 바로 쫓아가진 말자. 빠질 길부터 봐야 해."
			else:
				line = "위험한 일이라도 같이 움직이면 놓치는 게 줄어들 거야."
		"set_trap":
			line = "덫은 설치보다 기억이 중요해. 어디에 뒀는지 표시하자."
		"check_trap":
			line = "확인만 하고 오래 머물진 말자. 냄새가 남을 수 있어."
		"develop":
			if relationship_id == "deep_bond":
				line = "내가 고정할게. 네가 힘을 주는 쪽을 맞춰보자."
			else:
				line = "손이 많이 가는 일이야. 중간에 쉬어도 괜찮아."
		"wash":
			line = "젖은 흙을 털어내면 밤이 조금 편해질 거야."
		"rest":
			if CharacterManager.partner_status.mood <= 40:
				line = "잠깐 쉬면 말도 다시 이어질 것 같아."
			else:
				line = "짧게라도 쉬면 다음 움직임이 덜 흔들릴 거야."
	if line == "":
		return {}
	return _partner_suggestion(key, icon_id, line)


func _partner_day_start_suggestion() -> Dictionary:
	var state_suggestion := _partner_state_suggestion()
	if not state_suggestion.is_empty():
		return state_suggestion
	var weather_text := GameState.weather
	if weather_text.find("폭") >= 0 or weather_text.find("비") >= 0:
		return _partner_suggestion("weather", "items/water", _partner_suggestion_line("weather"))
	if not GameState.has_flag("entered_base"):
		return _partner_suggestion("base", "actions/place", _partner_suggestion_line("base"))
	if not CharacterManager.is_partner_following():
		return _partner_suggestion("separated", "actions/assist", _partner_suggestion_line("separated"))
	return {}


func _partner_tile_selected_suggestion(tile_id: String, tile) -> Dictionary:
	if tile == null:
		return {}
	if tile_id == WorldManager.current_tile_id:
		if WorldManager.has_tile_field_items(tile_id):
			return _partner_suggestion("field_items", "items/storage_box", _partner_suggestion_line("field_items"))
		if WorldManager.get_tile_resource_objects(tile_id).size() > 0:
			return _partner_suggestion("resource_object", "actions/gather", _partner_suggestion_line("resource_object"))
	if int(tile.get("danger", 0)) >= 4 and WorldManager.is_tile_investigated(tile_id):
		return _partner_suggestion("danger_tile", "status/fear", _partner_suggestion_line("danger_tile"))
	if tile_id != WorldManager.current_tile_id and not CharacterManager.is_partner_following() and _can_talk_to_partner():
		return _partner_suggestion("separated", "actions/assist", _partner_suggestion_line("separated"))
	return {}


func _partner_before_action_suggestion(action_id: String, tile_id: String, tile) -> Dictionary:
	if not CharacterManager.is_partner_following() and _can_use_partner_mode_for_action(action_id):
		return _partner_suggestion("separated_action", "actions/assist", _partner_suggestion_line("separated_action"))
	if tile != null and int(tile.get("danger", 0)) >= 3 and ["hunt", "develop"].has(action_id):
		return _partner_suggestion("danger_action", "status/fear", _partner_suggestion_line("danger_action"))
	if not GameState.is_daylight_time() and ["move", "investigate", "gather", "fish", "hunt", "set_trap", "check_trap", "develop"].has(action_id):
		return _partner_suggestion("night_action", "actions/rest", _partner_suggestion_line("night_action"))
	if action_id == "move" and CharacterManager.player_status.stamina <= 22:
		return _partner_suggestion("stamina_move", "status/stamina", _partner_suggestion_line("stamina"))
	if tile_id != "" and tile != null and bool(tile.get("movement_blocked", false)):
		return _partner_suggestion("blocked_tile", "status/fear", _partner_suggestion_line("blocked_tile"))
	return {}


func _partner_after_action_suggestion(action_id: String, tile_id: String, tile, context: Dictionary) -> Dictionary:
	var state_suggestion := _partner_state_suggestion()
	if not state_suggestion.is_empty():
		return state_suggestion
	if action_id == "investigate" and WorldManager.get_tile_resource_objects(tile_id).size() > 0:
		return _partner_suggestion("resource_object", "actions/gather", _partner_suggestion_line("resource_object"))
	if action_id == "move" and tile != null and int(tile.get("danger", 0)) >= 3:
		return _partner_suggestion("danger_tile", "status/fear", _partner_suggestion_line("danger_tile"))
	if action_id == "gather" and _result_has_items(context) and InventoryManager.get_weight_ratio(InventoryManager.OWNER_PLAYER) >= 0.82:
		return _partner_suggestion("heavy_load", "items/storage_box", _partner_suggestion_line("heavy_load"))
	if action_id == "set_trap":
		return _partner_suggestion("trap_set", "status/fear", _partner_suggestion_line("trap_set"))
	if action_id == "check_trap" and _result_has_items(context):
		return _partner_suggestion("trap_caught", "status/fear", _partner_suggestion_line("trap_caught"))
	return _partner_result_suggestion(action_id, context)


func _partner_result_suggestion(action_id: String, result: Dictionary) -> Dictionary:
	var personality_id := _partner_personality_id()
	var relationship_id := CharacterManager.get_relationship_state_id()
	var key := "result_%s_%s" % [action_id, relationship_id]
	var icon_id := _action_icon_id(action_id)
	var line := ""
	match action_id:
		"move":
			if relationship_id == "guarded":
				line = "응, 여기까지는 따라왔어. 다음 길은 한 번 더 보자."
			else:
				line = "방금 지나온 길은 기억해둘게."
		"investigate":
			if personality_id == "curious":
				line = "방금 본 흔적, 나중에 다른 단서랑 이어질지도 몰라."
			else:
				line = "이제 이 근처는 조금 덜 낯설어졌어."
		"gather":
			if _result_has_items(result):
				line = "이 정도면 헛걸음은 아니야. 무거워지기 전에 정리하자."
			else:
				line = "여긴 이미 손댄 곳이 많은 것 같아. 다음엔 다른 쪽을 보자."
		"fish":
			if _result_has_items(result):
				line = "잡았어. 상하기 전에 불이나 보관할 곳을 생각하자."
			else:
				line = "물결이 너무 불안해. 조금 있다 다시 해도 돼."
		"hunt":
			if _result_has_items(result):
				line = "성공했지만 냄새가 남을 수 있어. 오래 머물진 말자."
			else:
				line = "놓쳤어도 흔적은 남았어. 무리해서 쫓진 말자."
		"develop":
			if relationship_id == "deep_bond":
				line = "방금은 손이 잘 맞았어. 다음엔 더 빨리 끝낼 수 있겠다."
			else:
				line = "조금씩이라도 손댄 흔적이 남는 게 중요해."
		"wash":
			line = "이제 몸이 조금 가벼워 보여. 젖은 채로 밤을 보내진 말자."
		"rest":
			line = "숨이 좀 돌아왔어. 다음 행동은 덜 흔들릴 거야."
	if line == "":
		return {}
	return _partner_suggestion(key, icon_id, line)


func _record_action_memory_if_needed(action_id: String, result: Dictionary, before_snapshot: Dictionary, after_snapshot: Dictionary) -> void:
	if not CharacterManager.partner_joined:
		return
	var tile_id := String(result.get("tile_id", WorldManager.current_tile_id))
	var tile = WorldManager.get_tile(tile_id)
	var together := bool(result.get("together", CharacterManager.is_partner_following()))
	if together and tile != null and int(tile.get("danger", 0)) >= 3 and ["move", "investigate", "hunt", "develop"].has(action_id):
		CharacterManager.record_relationship_memory(
			"shared_danger_%s" % tile_id,
			"%s의 위험한 지형에서 서로 시야를 놓치지 않았다." % _tile_label(tile_id),
			"status/fear",
			2
		)
		return
	if together and _result_has_items(result) and ["gather", "fish", "hunt"].has(action_id):
		var memory_id := "shared_supply_%s" % action_id
		var text := "함께 %s을/를 마치고 오늘 버틸 물자를 챙겼다." % _action_display_name(action_id)
		if action_id == "fish":
			text = "물가에서 함께 숨을 낮추고 먹을 것을 구했다."
		elif action_id == "hunt":
			text = "위험을 나누어 감당하며 사냥의 흔적을 따라갔다."
		CharacterManager.record_relationship_memory(memory_id, text, _action_icon_id(action_id), 1)
		return
	var partner_before: Dictionary = before_snapshot.get("partner", {})
	var partner_after: Dictionary = after_snapshot.get("partner", {})
	if CharacterManager.partner_status.mood <= 35 and int(partner_after.get("mood", 0)) > int(partner_before.get("mood", 0)) and ["rest", "talk", "partner_comfort"].has(action_id):
		CharacterManager.record_relationship_memory(
			"recovered_tension_day_%d" % GameState.day,
			"긴장이 쌓인 뒤, 멈춰 서서 파트너의 숨을 고르게 했다.",
			"status/stable",
			1
		)


func _partner_after_craft_suggestion(recipe_id: String) -> Dictionary:
	match recipe_id:
		"campfire":
			return _partner_suggestion("crafted_campfire", "items/campfire", _partner_suggestion_line("crafted_campfire"))
		"simple_bed":
			return _partner_suggestion("crafted_bed", "items/simple_bed", _partner_suggestion_line("crafted_bed"))
		"rain_collector", "water_bucket":
			return _partner_suggestion("crafted_water", "items/%s" % recipe_id, _partner_suggestion_line("crafted_water"))
		"snare_trap", "fish_trap":
			return _partner_suggestion("crafted_trap", "items/%s" % recipe_id, _partner_suggestion_line("crafted_trap"))
		"storage_box":
			return _partner_suggestion("crafted_storage", "items/storage_box", _partner_suggestion_line("crafted_storage"))
	return {}


func _partner_state_suggestion() -> Dictionary:
	var player = CharacterManager.player_status
	if player == null:
		return {}
	if player.hp <= 35 or player.has_state("wound"):
		return _partner_suggestion("low_hp", "status/hp", _partner_suggestion_line("low_hp"))
	if player.thirst <= 25:
		if _party_item_count("water") > 0:
			return _partner_suggestion("low_thirst_have_water", "items/water", _partner_suggestion_line("low_thirst_have_water"))
		return _partner_suggestion("low_thirst", "status/thirst", _partner_suggestion_line("low_thirst"))
	if player.hunger <= 25:
		if _party_has_food():
			return _partner_suggestion("low_hunger_have_food", "items/berry", _partner_suggestion_line("low_hunger_have_food"))
		return _partner_suggestion("low_hunger", "status/hunger", _partner_suggestion_line("low_hunger"))
	if player.stamina <= 20:
		return _partner_suggestion("low_stamina", "status/stamina", _partner_suggestion_line("stamina"))
	if CharacterManager.partner_joined and CharacterManager.partner_status != null and CharacterManager.partner_status.stamina <= 20:
		return _partner_suggestion("partner_low_stamina", "status/stamina", _partner_suggestion_line("partner_stamina"))
	if InventoryManager.get_weight_ratio(InventoryManager.OWNER_PLAYER) >= 0.9:
		return _partner_suggestion("heavy_load", "items/storage_box", _partner_suggestion_line("heavy_load"))
	return {}


func _partner_suggestion_line(topic: String) -> String:
	var personality_id := _partner_personality_id()
	match topic:
		"weather":
			if personality_id == "curious":
				return "비가 오면 물길도 바뀌어. 먼저 안전한 길만 보자."
			if personality_id == "optimistic":
				return "비는 힘들지만 물은 모을 수 있어. 젖기 전에 준비하자."
			return "날씨가 나빠. 무리하지 말고 물과 쉴 곳부터 챙기자."
		"base":
			if personality_id == "curious":
				return "쉴 곳을 정해두면 더 멀리 살펴볼 수 있을 것 같아."
			if personality_id == "optimistic":
				return "오늘은 돌아올 곳부터 만들자. 그러면 마음이 좀 놓일 거야."
			return "해 지기 전에 몸을 숨길 곳을 정하는 게 먼저야."
		"danger_tile":
			if personality_id == "curious":
				return "저쪽은 흔적이 복잡해. 천천히 확인하자."
			if personality_id == "optimistic":
				return "갈 수는 있겠지만, 준비하고 같이 움직이자."
			return "저긴 위험해 보여. 혼자 들어가진 말자."
		"danger_action":
			if personality_id == "curious":
				return "위험한 일일수록 흔적을 먼저 읽어야 해."
			if personality_id == "optimistic":
				return "할 수 있어. 대신 서로 시야를 놓치지 말자."
			return "지금 행동은 위험해. 같이 하거나 시간을 바꾸자."
		"night_action":
			if personality_id == "curious":
				return "밤에는 같은 길도 다르게 보여. 표시를 남기며 움직이자."
			if personality_id == "optimistic":
				return "어두워졌어. 오늘 할 일은 조금만 줄이자."
			return "해가 졌어. 조사나 큰일은 내일로 미루는 게 안전해."
		"stamina", "partner_stamina":
			if personality_id == "optimistic":
				return "잠깐만 숨 돌리자. 다시 움직일 힘이 돌아올 거야."
			return "발걸음이 무거워 보여. 쉬지 않으면 실수할 수 있어."
		"low_hp":
			return "상처부터 봐야 해. 움직이는 것보다 치료가 먼저야."
		"low_thirst_have_water":
			return "물 가지고 있잖아. 지금 마셔두자."
		"low_thirst":
			return "목이 말라 보여. 다음 행동은 물을 찾는 쪽이 좋겠어."
		"low_hunger_have_food":
			return "먹을 게 있으면 아끼기보다 지금 조금 먹자."
		"low_hunger":
			return "배가 비면 힘도 빨리 빠져. 쉬운 먹을거리부터 찾자."
		"heavy_load":
			return "짐이 무거워. 이 근처에 내려두거나 나한테 나눠줘."
		"field_items":
			return "여기 둔 물건이 있어. 떠나기 전에 필요한 것만 챙기자."
		"resource_object":
			if personality_id == "curious":
				return "방금 찾은 건 그냥 자원이 아니라 단서 같아. 직접 확인해보자."
			return "눈에 띄는 채집 대상부터 챙기면 헛손질이 줄어들 거야."
		"separated", "separated_action":
			if personality_id == "optimistic":
				return "따로 움직여도 괜찮지만, 위험한 일은 같이 하자."
			return "지금은 떨어져 있어. 위험한 일은 먼저 같이 가자고 말해줘."
		"blocked_tile":
			return "저쪽은 길이 막혀 있어. 돌아갈 길을 찾아야 해."
		"trap_set":
			return "덫은 기다림이 필요해. 다음에는 상태를 확인해보자."
		"trap_caught":
			return "잡힌 게 있어. 상하기 전에 처리하자."
		"crafted_campfire":
			return "불이 있으면 밤이 조금 달라질 거야."
		"crafted_bed":
			return "이제 쉬는 시간이 진짜 회복이 될 수 있겠다."
		"crafted_water":
			return "물 걱정이 조금 줄었어. 비 올 때 더 챙겨두자."
		"crafted_trap":
			return "이건 계속 확인해야 의미가 있어. 위치를 기억해두자."
		"crafted_storage":
			return "짐을 놓을 곳이 생겼어. 무거운 재료부터 정리하자."
	return "잠깐만. 지금 상황을 한 번 더 보고 움직이자."


func _partner_suggestion(key: String, icon_id: String, text: String) -> Dictionary:
	return {
		"key": key,
		"icon": icon_id,
		"text": text
	}


func _partner_personality_id() -> String:
	if CharacterManager.partner_personality == null:
		return "cautious"
	return String(CharacterManager.partner_personality.id)


func _partner_suggestion_is_suppressed(key: String) -> bool:
	var global_stamp := _partner_suggestion_slot(PARTNER_SUGGESTION_GLOBAL_MINUTES)
	if String(partner_suggestion_cooldowns.get("_global", "")) == global_stamp:
		return true
	var topic_stamp := _partner_suggestion_slot(PARTNER_SUGGESTION_TOPIC_MINUTES)
	return String(partner_suggestion_cooldowns.get(key, "")) == topic_stamp


func _mark_partner_suggestion(key: String) -> void:
	partner_suggestion_cooldowns["_global"] = _partner_suggestion_slot(PARTNER_SUGGESTION_GLOBAL_MINUTES)
	partner_suggestion_cooldowns[key] = _partner_suggestion_slot(PARTNER_SUGGESTION_TOPIC_MINUTES)


func _partner_suggestion_slot(minutes_per_slot: int) -> String:
	var safe_slot_minutes := maxi(1, minutes_per_slot)
	return "%d:%d" % [GameState.day, int(floor(float(GameState.current_minutes) / float(safe_slot_minutes)))]


func _result_has_items(result: Dictionary) -> bool:
	var items = result.get("items", {})
	if typeof(items) != TYPE_DICTIONARY:
		return false
	for raw_amount in Dictionary(items).values():
		if int(raw_amount) > 0:
			return true
	return false


func _party_item_count(item_id: String) -> int:
	var amount := InventoryManager.get_count(item_id, InventoryManager.OWNER_PLAYER)
	if CharacterManager.partner_joined:
		amount += InventoryManager.get_count(item_id, InventoryManager.OWNER_PARTNER)
	return amount


func _party_has_food() -> bool:
	for owner_id in [InventoryManager.OWNER_PLAYER, InventoryManager.OWNER_PARTNER]:
		if owner_id == InventoryManager.OWNER_PARTNER and not CharacterManager.partner_joined:
			continue
		var items: Dictionary = InventoryManager.get_items(owner_id)
		for raw_item_id in items.keys():
			if int(items[raw_item_id]) <= 0:
				continue
			var item = InventoryManager.get_item_data(String(raw_item_id))
			if item != null and (item.tags.has("food") or item.category == "food"):
				return true
	return false


func _together_banter_text(action_id: String) -> String:
	match action_id:
		"investigate":
			return "“저쪽은 내가 볼게.”"
		"gather":
			return "“무리하지 말고 나눠 들자.”"
		"fish":
			return "“조용히 있으면 잡힐지도 몰라.”"
		"develop":
			return "“여기, 내가 잡고 있을게.”"
		"rest":
			return "“잠깐만 쉬었다 가자.”"
		"talk", "partner_check":
			return "“응, 계속 이야기해 줘.”"
		"partner_comfort":
			return "“네 목소리 들으니까 좀 낫다.”"
		"partner_care", "gift":
			return "“챙겨줘서 고마워.”"
	return "둘이 호흡을 맞춘다."


func _action_fx_text(action_id: String) -> String:
	match action_id:
		"move":
			return "이동"
		"investigate":
			return "탐색"
		"gather":
			return "채집"
		"fish":
			return "낚시"
		"develop":
			return "정비"
		"wash":
			return "씻기"
		"rest":
			return "휴식"
		"sleep":
			return "수면"
		"craft":
			return "제작"
		"partner_check":
			return "확인"
		"partner_comfort":
			return "안심"
		"partner_plan":
			return "의논"
		"partner_care":
			return "돌봄"
	return _action_display_name(action_id)


func _on_talk_pressed() -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 대화할 수 없다.")
		return
	var before_snapshot := _capture_play_state()
	var result := CharacterManager.talk()
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	_refresh_all()
	_show_action_result("talk", result, before_snapshot, after_snapshot)
	if bool(result.get("ok", false)):
		EventManager.evaluate_after_action("talk", GameState.current_region_id, result)


func _on_partner_daily_talk_pressed() -> void:
	_on_talk_pressed()


func _on_partner_check_pressed() -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 상태를 물을 수 없다.")
		return
	var result := CharacterManager.ask_partner_condition()
	_append_log(String(result.get("text", "")))
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/talk")


func _on_partner_comfort_pressed() -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 안심시킬 수 없다.")
		return
	var before_snapshot := _capture_play_state()
	var result := CharacterManager.comfort_partner()
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	_refresh_all()
	_show_action_result("partner_comfort", result, before_snapshot, after_snapshot)
	if bool(result.get("ok", false)):
		_play_screen_action_feedback("partner_comfort", WorldManager.current_tile_id)
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "status/stable")
		EventManager.evaluate_after_action("talk", GameState.current_region_id, result)


func _on_partner_plan_pressed() -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 계획을 의논할 수 없다.")
		return
	var result := CharacterManager.discuss_plan()
	_append_log(String(result.get("text", "")))
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/investigate")


func _on_partner_separate_pressed() -> void:
	var result := CharacterManager.separate_partner_at_tile(WorldManager.current_tile_id)
	_append_log(String(result.get("text", "")))
	action_together_enabled = false
	_hide_tool_menu()
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/move")


func _on_partner_follow_pressed() -> void:
	var result := CharacterManager.ask_partner_to_follow(WorldManager.current_tile_id)
	_append_log(String(result.get("text", "")))
	action_together_enabled = CharacterManager.is_partner_following()
	_hide_tool_menu()
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/assist")


func _on_partner_assign_task_pressed(task_id: String) -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 일을 맡길 수 없다.")
		return
	var target_tile_id := WorldManager.current_tile_id
	var start_time := GameState.get_time_label()
	var result := CharacterManager.assign_partner_task(task_id, target_tile_id)
	if bool(result.get("ok", false)):
		var feedback := _resolve_partner_assigned_task_feedback(task_id, target_tile_id, start_time)
		if String(feedback.get("text", "")) != "":
			result["text"] = "%s\n%s" % [String(result.get("text", "")), String(feedback.get("text", ""))]
		if feedback.has("items"):
			result["items"] = feedback.get("items", {})
	_append_log(String(result.get("text", "")))
	action_together_enabled = false
	_hide_tool_menu()
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_item_toast_from_result(result)
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), _partner_task_icon(task_id))


func _resolve_partner_assigned_task_feedback(task_id: String, tile_id: String, start_time: String) -> Dictionary:
	var duration_slots := _partner_task_duration_slots(task_id)
	var end_time := _time_label_after_slots(duration_slots)
	var lines: Array[String] = []
	lines.append("대상: %s" % _tile_label(tile_id))
	lines.append("시간: %s - %s" % [start_time, end_time])
	var items: Dictionary = {}
	match task_id:
		"scout":
			var found_item_id := _partner_scout_candidate_item(tile_id)
			if found_item_id != "":
				var added := InventoryManager.add_item(found_item_id, 1, "partner")
				var item = InventoryManager.get_item_data(found_item_id)
				var item_name := found_item_id
				if item != null:
					item_name = item.display_name
				if added > 0:
					items[found_item_id] = added
					lines.append("결과: %s을/를 발견해 챙겼다." % item_name)
				else:
					lines.append("결과: %s을/를 찾았지만 짐이 무거워 챙기지 못했다." % item_name)
			else:
				lines.append("결과: 쓸 만한 물건은 없었지만 지형과 흔적을 확인했다.")
			_mark_partner_task_tile_memory(tile_id, "partner_scout")
		"watch":
			lines.append("결과: 주변 경계 지점을 확인했다. 위험한 기척이 있으면 먼저 알아차리기 쉬워진다.")
			_mark_partner_task_tile_memory(tile_id, "partner_watch")
		"recover":
			lines.append("결과: 파트너가 숨을 고르고 다음 행동을 준비한다.")
		_:
			lines.append("결과: 해당 위치에서 대기한다.")
	var result := {"text": _join_lines(lines, "\n")}
	if not items.is_empty():
		result["items"] = items
	return result


func _partner_scout_candidate_item(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return ""
	var candidates: Array[String] = []
	var field_items: Dictionary = tile.get("field_items", {})
	for raw_item_id in field_items.keys():
		var item_id := String(raw_item_id)
		if int(field_items[raw_item_id]) > 0 and InventoryManager.get_item_data(item_id) != null:
			candidates.append(item_id)
	var resources: Dictionary = tile.get("resources", {})
	for raw_item_id in resources.keys():
		var item_id := String(raw_item_id)
		if int(resources[raw_item_id]) > 0 and InventoryManager.get_item_data(item_id) != null and not candidates.has(item_id):
			candidates.append(item_id)
	for object in WorldManager.get_tile_resource_objects(tile_id, true):
		var object_items: Dictionary = object.get("items", {})
		for raw_item_id in object_items.keys():
			var item_id := String(raw_item_id)
			if int(object_items[raw_item_id]) > 0 and InventoryManager.get_item_data(item_id) != null and not candidates.has(item_id):
				candidates.append(item_id)
	if candidates.is_empty():
		return ""
	candidates.sort_custom(func(a: String, b: String) -> bool:
		var weight_a := InventoryManager.get_item_weight(a)
		var weight_b := InventoryManager.get_item_weight(b)
		if is_equal_approx(weight_a, weight_b):
			return a < b
		return weight_a < weight_b
	)
	return candidates[0]


func _mark_partner_task_tile_memory(tile_id: String, memory_id: String) -> void:
	if tile_id == "" or memory_id == "":
		return
	WorldManager.add_tile_memory(tile_id, memory_id, 1)


func _partner_task_duration_slots(task_id: String) -> int:
	match task_id:
		"scout", "watch":
			return 1
		"recover":
			return 2
	return 0


func _time_label_after_slots(slots: int) -> String:
	var minutes := clampi(GameState.current_minutes + maxi(0, slots) * GameState.MINUTES_PER_ACTION_SLOT, 0, GameState.MINUTES_PER_DAY - 1)
	var hour := int(minutes / 60)
	var minute := minutes % 60
	return "%02d:%02d" % [hour, minute]


func _on_partner_rest_request_pressed() -> void:
	_hide_tool_menu()
	_open_time_adjustment("rest", {"together": CharacterManager.is_partner_following()})


func _on_partner_care_item_pressed(item_id: String) -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 아이템을 건넬 수 없다.")
		return
	var before_snapshot := _capture_play_state()
	var result := CharacterManager.care_for_partner(item_id)
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	_refresh_all()
	_show_action_result("partner_care", result, before_snapshot, after_snapshot)
	if bool(result.get("ok", false)):
		_play_screen_action_feedback("partner_care", WorldManager.current_tile_id)
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/gift")


func _on_gift_berry_pressed() -> void:
	if not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 선물을 건넬 수 없다.")
		return
	var before_snapshot := _capture_play_state()
	var result := CharacterManager.gift_item("berry")
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	_refresh_all()
	_show_action_result("gift", result, before_snapshot, after_snapshot)
	if bool(result.get("ok", false)):
		_play_screen_action_feedback("gift", WorldManager.current_tile_id)
		_play_action_cutin("gift", WorldManager.current_tile_id, result)
		_show_partner_reaction_feedback(String(result.get("partner_line", "")), "actions/gift")
		EventManager.evaluate_after_action("gift", GameState.current_region_id, result)


func _on_use_item_pressed(item_id: String, target_id: String, owner_id: String = "player") -> void:
	if owner_id == "partner" and not InventoryManager.can_access_partner_inventory():
		_append_log("파트너가 같은 타일에 없어 소지품을 사용할 수 없다.")
		return
	if target_id == "partner" and not _can_talk_to_partner():
		_append_log("파트너가 같은 타일에 없어 아이템을 건넬 수 없다.")
		return
	var result := InventoryManager.use_item(item_id, target_id, owner_id)
	_append_log(String(result.get("text", "")))
	_refresh_all()


func _on_end_day_pressed() -> void:
	_toggle_tool_menu("sleep")


func _on_craft_pressed(recipe_id: String, partner_assist: bool) -> void:
	var recipe = CraftingManager.get_recipe(recipe_id)
	if recipe == null or not CraftingManager.is_recipe_unlocked(recipe_id):
		_show_sensory_toast("actions/craft", "아직 떠올리지 못한 제작법이다.", Color(0.70, 0.62, 0.42))
		return
	if recipe != null and _is_tool_recipe(recipe):
		_start_tool_craft_minigame(recipe_id, partner_assist)
		return
	_complete_craft(recipe_id, partner_assist)


func _on_recipe_unlocked(recipe_id: String, reason: String) -> void:
	var recipe = CraftingManager.get_recipe(recipe_id)
	var recipe_name := recipe_id
	if recipe != null:
		recipe_name = String(recipe.display_name)
	var message := "새 제작법: %s" % recipe_name
	if reason != "":
		message += " (%s)" % reason
	_append_log(message)
	_show_sensory_toast("actions/craft", "새 제작법: %s" % recipe_name, Color(0.88, 0.74, 0.36))
	if active_tool_menu == "craft":
		_refresh_tool_menu("craft")


func _complete_craft(recipe_id: String, partner_assist: bool, minigame_result: Dictionary = {}) -> void:
	var before_snapshot := _capture_play_state()
	var result := CraftingManager.craft(recipe_id, partner_assist)
	if not minigame_result.is_empty():
		_apply_tool_craft_quality_result(result, minigame_result, partner_assist)
	_append_log(String(result.get("text", "")))
	var after_snapshot := _capture_play_state()
	if bool(result.get("ok", false)):
		_append_log(_build_action_delta_text(before_snapshot, after_snapshot, result))
	if bool(result.get("ok", false)):
		EventManager.evaluate_after_action("craft", GameState.current_region_id, result)
	_refresh_all()
	if bool(result.get("ok", false)):
		_play_screen_action_feedback("craft", WorldManager.current_tile_id)
		_play_action_cutin("craft", WorldManager.current_tile_id, result)
		_play_craft_result_fx(result)
		if partner_assist:
			_show_together_action_feedback("craft")
	_show_item_toast_from_result(result)
	if bool(result.get("ok", false)):
		_maybe_show_partner_suggestion("after_craft", recipe_id, result)


func _refresh_tool_craft_visual(recipe, step: Dictionary, index: int, total_steps: int) -> void:
	if recipe == null:
		return
	var result_icon_path := _recipe_result_icon_path(recipe)
	var result_texture = _texture_from_path(result_icon_path)
	if tool_craft_workpiece_icon != null and result_texture != null:
		tool_craft_workpiece_icon.texture = result_texture
	if tool_craft_step_text_label != null:
		tool_craft_step_text_label.text = "%d/%d  %s" % [index + 1, total_steps, String(step.get("title", "손작업"))]
	var correct := String(step.get("correct", ""))
	var step_color := _tool_craft_option_color(correct)
	if tool_craft_step_icon != null:
		var stage_texture = _icon_texture(_tool_craft_option_icon(correct))
		if stage_texture != null:
			tool_craft_step_icon.texture = stage_texture
	if tool_craft_step_badge != null:
		tool_craft_step_badge.add_theme_stylebox_override("panel", _make_panel_style(step_color.darkened(0.52), step_color, 6))
	if tool_craft_materials_box != null:
		_clear_children(tool_craft_materials_box)
		var item_ids: Array = recipe.required_items.keys()
		item_ids.sort()
		for raw_item_id in item_ids:
			var item_id := String(raw_item_id)
			var item = InventoryManager.get_item_data(item_id)
			var display_name := item_id
			var icon_path := ""
			if item != null:
				display_name = item.display_name
				icon_path = item.icon_path
			tool_craft_materials_box.add_child(_make_tool_craft_material_slot(display_name, int(recipe.required_items[item_id]), icon_path))
	_update_tool_craft_workpiece_style()


func _make_tool_craft_material_slot(display_name: String, amount: int, icon_path: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(92, 40)
	panel.tooltip_text = "%s x%d" % [display_name, amount]
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.030, 0.040, 0.035, 0.78), Color(0.78, 0.72, 0.48, 0.42), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 5)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(26, 26)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = "x%d" % amount
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.97, 0.92, 0.70))
	row.add_child(label)
	return panel


func _make_tool_craft_visual_option_button(option: String) -> Button:
	var button := _make_button(option, Callable(self, "_on_tool_craft_option_pressed").bind(option), _tool_craft_option_icon(option))
	button.custom_minimum_size = Vector2(118, 46)
	button.tooltip_text = _tool_craft_option_hint(option)
	_limit_button_icon(button, 24)
	var color := _tool_craft_option_color(option)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.045, 0.060, 0.052, 0.96), color.darkened(0.28), 8))
	button.add_theme_stylebox_override("hover", _make_panel_style(color.darkened(0.30), color, 8))
	button.add_theme_stylebox_override("pressed", _make_panel_style(color.darkened(0.08), color.lightened(0.22), 8))
	return button


func _tool_craft_option_color(option: String) -> Color:
	match option:
		"맞추기":
			return Color(0.82, 0.72, 0.38)
		"다듬기":
			return Color(0.58, 0.68, 0.72)
		"묶기", "감싸기", "고정":
			return Color(0.50, 0.70, 0.42)
		"두드리기":
			return Color(0.74, 0.52, 0.32)
		"불붙이기":
			return Color(0.86, 0.42, 0.24)
	return Color(0.72, 0.70, 0.52)


func _play_tool_craft_visual_feedback(success: bool, step: Dictionary) -> void:
	if tool_craft_visual_frame == null:
		return
	if tool_craft_visual_tween != null and tool_craft_visual_tween.is_valid():
		tool_craft_visual_tween.kill()
	var color := _tool_craft_option_color(String(step.get("correct", "")))
	if not success:
		color = Color(0.85, 0.26, 0.18)
	if tool_craft_visual_flash != null:
		tool_craft_visual_flash.color = Color(color.r, color.g, color.b, 0.30 if success else 0.42)
	if tool_craft_workpiece_panel != null:
		tool_craft_workpiece_panel.scale = Vector2(1, 1)
	tool_craft_visual_tween = create_tween()
	tool_craft_visual_tween.set_parallel(true)
	if tool_craft_visual_flash != null:
		tool_craft_visual_tween.tween_property(tool_craft_visual_flash, "color:a", 0.0, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if tool_craft_workpiece_panel != null:
		var target_scale := Vector2(1.06, 1.06) if success else Vector2(0.96, 1.04)
		tool_craft_visual_tween.tween_property(tool_craft_workpiece_panel, "scale", target_scale, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tool_craft_visual_tween.tween_property(tool_craft_workpiece_panel, "scale", Vector2(1, 1), 0.18).set_delay(0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_spawn_tool_craft_feedback_icon(_tool_craft_option_icon(String(step.get("correct", ""))), success, color)


func _spawn_tool_craft_feedback_icon(icon_id: String, success: bool, color: Color) -> void:
	if tool_craft_visual_frame == null:
		return
	var texture = _icon_texture(icon_id)
	if texture == null:
		return
	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.texture = texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.modulate = Color(color.r, color.g, color.b, 0.95)
	icon.anchor_left = 0.5
	icon.anchor_right = 0.5
	icon.anchor_top = 0.5
	icon.anchor_bottom = 0.5
	icon.offset_left = -24
	icon.offset_right = 24
	icon.offset_top = -24
	icon.offset_bottom = 24
	tool_craft_visual_frame.add_child(icon)
	var tween := create_tween()
	var lift := -54.0 if success else -18.0
	tween.set_parallel(true)
	tween.tween_property(icon, "position:y", icon.position.y + lift, 0.44).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(icon, "modulate:a", 0.0, 0.44).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(icon, "scale", Vector2(1.38, 1.38) if success else Vector2(0.86, 0.86), 0.44).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func() -> void:
		if is_instance_valid(icon):
			icon.queue_free()
	)


func _start_tool_craft_minigame(recipe_id: String, partner_assist: bool) -> void:
	var recipe = CraftingManager.get_recipe(recipe_id)
	if recipe == null:
		_append_log("도구 제작 정보를 찾을 수 없다.")
		return
	if not _can_attempt_recipe(recipe, partner_assist):
		_append_log("도구 제작 조건이 부족하다.")
		return
	var steps := _tool_craft_steps(recipe)
	if steps.is_empty():
		_complete_craft(recipe_id, partner_assist)
		return
	_hide_tool_menu()
	_hide_map_context_menu()
	tool_craft_minigame = {
		"active": true,
		"recipe_id": recipe_id,
		"partner_assist": partner_assist,
		"steps": steps,
		"index": 0,
		"quality": 0,
		"mistakes": 0,
		"max_time": 3.3 if not partner_assist else 3.8,
		"time_left": 3.3 if not partner_assist else 3.8
	}
	if tool_craft_layer != null:
		tool_craft_layer.visible = true
		_raise_root_overlay(tool_craft_layer, Z_ROOT_MODAL + 4)
	if tool_craft_visual_frame != null:
		tool_craft_visual_frame.visible = true
	if fishing_visual_frame != null:
		fishing_visual_frame.visible = false
	if hunting_visual_frame != null:
		hunting_visual_frame.visible = false
	if tool_craft_icon != null:
		var icon_texture = _texture_from_path(_recipe_result_icon_path(recipe))
		if icon_texture != null:
			tool_craft_icon.texture = icon_texture
	if tool_craft_visual_flash != null:
		tool_craft_visual_flash.color = Color(1, 1, 1, 0)
	if tool_craft_workpiece_panel != null:
		tool_craft_workpiece_panel.scale = Vector2(1, 1)
	tool_craft_title_label.text = "%s 손작업" % recipe.display_name
	if tool_craft_footer_label != null:
		tool_craft_footer_label.text = "도구 제작은 손작업 품질을 본다. 성공하면 기존 제작 비용이 소모되고, 실패하면 재료는 잃지 않지만 30분과 약간의 기력이 줄어든다."
	_set_action_minigame_meter_visible(false)
	_fit_center_overlay(tool_craft_panel, TOOL_CRAFT_MINIGAME_DESIRED_SIZE)
	_show_tool_craft_step()


func _show_tool_craft_step() -> void:
	if not bool(tool_craft_minigame.get("active", false)):
		return
	var steps: Array = tool_craft_minigame.get("steps", [])
	var index := int(tool_craft_minigame.get("index", 0))
	if index >= steps.size():
		_finish_tool_craft_minigame()
		return
	var step: Dictionary = steps[index]
	var max_time := float(tool_craft_minigame.get("max_time", 3.3))
	tool_craft_minigame["time_left"] = max_time
	if tool_craft_step_label != null:
		tool_craft_step_label.text = "%d / %d  %s" % [index + 1, steps.size(), String(step.get("title", "손작업"))]
	if tool_craft_body_label != null:
		tool_craft_body_label.text = "%s\n%s" % [
			String(step.get("prompt", "")),
			"파트너가 재료를 잡아줘 손끝이 안정된다." if bool(tool_craft_minigame.get("partner_assist", false)) else "작업대 위의 단서와 손동작 아이콘을 보고 고른다."
		]
	var recipe = CraftingManager.get_recipe(String(tool_craft_minigame.get("recipe_id", "")))
	_refresh_tool_craft_visual(recipe, step, index, steps.size())
	_clear_children(tool_craft_actions_box)
	var options: Array = Array(step.get("options", [])).duplicate()
	options.shuffle()
	for raw_option in options:
		var option := String(raw_option)
		var button := _make_tool_craft_visual_option_button(option)
		tool_craft_actions_box.add_child(button)
	_update_tool_craft_progress()


func _on_tool_craft_option_pressed(option: String) -> void:
	_resolve_tool_craft_step(option)


func _resolve_tool_craft_step(option: String) -> void:
	if not bool(tool_craft_minigame.get("active", false)):
		return
	var steps: Array = tool_craft_minigame.get("steps", [])
	var index := int(tool_craft_minigame.get("index", 0))
	if index >= steps.size():
		_finish_tool_craft_minigame()
		return
	var step: Dictionary = steps[index]
	var correct := String(step.get("correct", ""))
	var max_time := maxf(0.1, float(tool_craft_minigame.get("max_time", 3.3)))
	var time_ratio := clampf(float(tool_craft_minigame.get("time_left", 0.0)) / max_time, 0.0, 1.0)
	var quality := int(tool_craft_minigame.get("quality", 0))
	var mistakes := int(tool_craft_minigame.get("mistakes", 0))
	if option == correct:
		quality += 12 + int(round(time_ratio * 10.0))
		_play_tool_craft_visual_feedback(true, step)
		_play_screen_flash(Color(0.90, 0.72, 0.34), 0.08, 0.16)
	else:
		mistakes += 1
		quality -= 8
		_play_tool_craft_visual_feedback(false, step)
		_play_screen_shake(3.0, 0.14)
		_play_screen_flash(Color(0.80, 0.30, 0.22), 0.10, 0.18)
	tool_craft_minigame["quality"] = clampi(quality, 0, 100)
	tool_craft_minigame["mistakes"] = mistakes
	tool_craft_minigame["index"] = index + 1
	if int(tool_craft_minigame.get("index", 0)) >= steps.size():
		_finish_tool_craft_minigame()
	else:
		_show_tool_craft_step()


func _finish_tool_craft_minigame() -> void:
	if not bool(tool_craft_minigame.get("active", false)):
		return
	var recipe_id := String(tool_craft_minigame.get("recipe_id", ""))
	var partner_assist := bool(tool_craft_minigame.get("partner_assist", false))
	var steps: Array = tool_craft_minigame.get("steps", [])
	var max_quality := maxi(1, steps.size() * 22)
	var raw_quality := int(tool_craft_minigame.get("quality", 0))
	var quality := clampi(int(round(float(raw_quality) / float(max_quality) * 100.0)), 0, 100)
	if partner_assist:
		quality = clampi(quality + 8, 0, 100)
	var mistakes := int(tool_craft_minigame.get("mistakes", 0))
	var result := {
		"quality": quality,
		"mistakes": mistakes,
		"grade": _tool_craft_quality_grade(quality),
		"grade_text": _tool_craft_quality_text(quality)
	}
	tool_craft_minigame.clear()
	_set_action_minigame_meter_visible(false)
	if tool_craft_visual_tween != null and tool_craft_visual_tween.is_valid():
		tool_craft_visual_tween.kill()
	if tool_craft_layer != null:
		tool_craft_layer.visible = false
	if quality < 35:
		_apply_failed_tool_craft_attempt(recipe_id, result)
		return
	_complete_craft(recipe_id, partner_assist, result)


func _cancel_tool_craft_minigame() -> void:
	if tool_craft_minigame.is_empty():
		return
	tool_craft_minigame.clear()
	_set_action_minigame_meter_visible(false)
	if tool_craft_visual_tween != null and tool_craft_visual_tween.is_valid():
		tool_craft_visual_tween.kill()
	if tool_craft_layer != null:
		tool_craft_layer.visible = false
	_append_log("도구 손작업을 멈췄다. 재료는 그대로 남아 있다.")


func _apply_failed_tool_craft_attempt(recipe_id: String, minigame_result: Dictionary) -> void:
	var before_snapshot := _capture_play_state()
	var spent_time := GameState.spend_action_points(1)
	if spent_time:
		CharacterManager.spend_stamina(3)
		CharacterManager.apply_action_metabolism("craft", 1, 3, false)
	var recipe = CraftingManager.get_recipe(recipe_id)
	var display_name := "도구"
	if recipe != null:
		display_name = String(recipe.display_name)
	var text := "%s 손작업이 흐트러졌다. 재료는 잃지 않았지만 30분과 기력을 조금 썼다.\n판정: %s" % [
		display_name,
		String(minigame_result.get("grade_text", "거칠음"))
	]
	_append_log(text)
	var after_snapshot := _capture_play_state()
	_refresh_all()
	_show_action_delta_toast("craft", before_snapshot, after_snapshot, {"ok": true})
	_play_screen_action_feedback("craft", WorldManager.current_tile_id)


func _apply_tool_craft_quality_result(result: Dictionary, minigame_result: Dictionary, partner_assist: bool) -> void:
	if not bool(result.get("ok", false)):
		return
	var grade_text := String(minigame_result.get("grade_text", "보통"))
	var quality := int(minigame_result.get("quality", 0))
	var text := String(result.get("text", ""))
	text += "\n손작업 판정: %s (%d)" % [grade_text, quality]
	var crafted_items: Dictionary = result.get("items", {})
	for raw_item_id in crafted_items.keys():
		var item_id := String(raw_item_id)
		var max_durability := InventoryManager.get_tool_max_durability(item_id)
		if max_durability <= 0:
			continue
		var target_durability := max_durability
		if quality >= 80:
			target_durability = max_durability + int(ceil(float(max_durability) * 0.25))
		elif quality < 55:
			target_durability = maxi(1, int(ceil(float(max_durability) * 0.75)))
		InventoryManager.set_tool_durability(item_id, target_durability)
	if quality >= 80:
		CharacterManager.player_status.apply_delta({"mood": 2})
		if partner_assist and CharacterManager.partner_joined:
			CharacterManager.partner_status.apply_delta({"mood": 2, "trust": 2, "affection": 1})
			CharacterManager.record_relationship_memory("careful_craft_day_%d" % GameState.day, "재료를 함께 잡고 손작업의 호흡을 맞췄다.", "actions/craft", 1)
		CharacterManager.notify_status_changed()
		text += "\n재료의 결이 잘 맞아 손에 쥐는 느낌이 안정적이다."
	elif quality < 55:
		CharacterManager.player_status.apply_delta({"stamina": -2})
		CharacterManager.notify_status_changed()
		text += "\n형태는 갖췄지만 손에 힘이 더 들어갔다."
	result["text"] = text
	result["quality"] = quality
	result["quality_grade"] = String(minigame_result.get("grade", "normal"))
	result["cutin_text"] = "손끝으로 맞춘 결과: %s" % grade_text


func _update_tool_craft_workpiece_style() -> void:
	if tool_craft_workpiece_panel == null:
		return
	var steps: Array = tool_craft_minigame.get("steps", [])
	var max_quality := maxi(1, steps.size() * 22)
	var quality_ratio := clampf(float(int(tool_craft_minigame.get("quality", 0))) / float(max_quality), 0.0, 1.0)
	var mistakes := int(tool_craft_minigame.get("mistakes", 0))
	var border := Color(0.95, 0.78, 0.34).lerp(Color(0.50, 0.78, 0.46), quality_ratio)
	if mistakes > 0:
		border = border.lerp(Color(0.90, 0.32, 0.22), clampf(float(mistakes) * 0.25, 0.0, 0.75))
	var fill := Color(border.r, border.g, border.b, 0.12 + quality_ratio * 0.14)
	tool_craft_workpiece_panel.add_theme_stylebox_override("panel", _make_panel_style(fill, border, 15))
	if tool_craft_workpiece_panel.size.x > 0.0 and tool_craft_workpiece_panel.size.y > 0.0:
		tool_craft_workpiece_panel.pivot_offset = tool_craft_workpiece_panel.size * 0.5


func _update_tool_craft_progress() -> void:
	if tool_craft_progress == null or tool_craft_quality_label == null:
		return
	var max_time := maxf(0.1, float(tool_craft_minigame.get("max_time", 3.3)))
	var time_left := clampf(float(tool_craft_minigame.get("time_left", max_time)), 0.0, max_time)
	tool_craft_progress.value = time_left / max_time * 100.0
	var steps: Array = tool_craft_minigame.get("steps", [])
	var max_quality := maxi(1, steps.size() * 22)
	var quality := clampi(int(round(float(int(tool_craft_minigame.get("quality", 0))) / float(max_quality) * 100.0)), 0, 100)
	tool_craft_quality_label.text = "손작업 품질 %d / 실수 %d" % [quality, int(tool_craft_minigame.get("mistakes", 0))]
	if tool_craft_hint_label != null:
		tool_craft_hint_label.text = "남은 %.1f초" % time_left
	_update_tool_craft_workpiece_style()


func _tool_craft_steps(recipe) -> Array[Dictionary]:
	match String(recipe.id):
		"stone_axe":
			return [
				{"title": "머리 맞추기", "prompt": "돌과 나무 손잡이의 각도를 맞춘다.", "correct": "맞추기", "options": ["맞추기", "다듬기", "묶기"]},
				{"title": "날 다듬기", "prompt": "부딪히는 면을 조금 깎아 날을 세운다.", "correct": "다듬기", "options": ["다듬기", "감싸기", "고정"]},
				{"title": "섬유 감기", "prompt": "젖은 섬유가 풀리지 않도록 단단히 감는다.", "correct": "감싸기", "options": ["감싸기", "두드리기", "맞추기"]},
				{"title": "마지막 고정", "prompt": "손잡이를 흔들어 헐거운 곳을 바로잡는다.", "correct": "고정", "options": ["고정", "다듬기", "불붙이기"]}
			]
		"stone_knife":
			return [
				{"title": "날 고르기", "prompt": "날카로운 돌의 방향을 손잡이에 맞춘다.", "correct": "맞추기", "options": ["맞추기", "감싸기", "불붙이기"]},
				{"title": "끈 묶기", "prompt": "섬유를 교차시켜 미끄러지지 않게 묶는다.", "correct": "묶기", "options": ["묶기", "두드리기", "고정"]},
				{"title": "끝 다듬기", "prompt": "손에 닿는 거친 부분을 조금씩 눌러 정리한다.", "correct": "다듬기", "options": ["다듬기", "불붙이기", "맞추기"]}
			]
		"torch":
			return [
				{"title": "끝 감싸기", "prompt": "섬유를 나무 끝에 감아 불이 붙을 자리를 만든다.", "correct": "감싸기", "options": ["감싸기", "다듬기", "두드리기"]},
				{"title": "단단히 묶기", "prompt": "걷다가 풀리지 않도록 아래쪽을 조인다.", "correct": "묶기", "options": ["묶기", "맞추기", "고정"]},
				{"title": "마른 면 고르기", "prompt": "비교적 마른 쪽을 바깥으로 돌려 잡는다.", "correct": "맞추기", "options": ["맞추기", "불붙이기", "다듬기"]}
			]
	return []


func _tool_craft_option_icon(option: String) -> String:
	match option:
		"맞추기":
			return "actions/assist"
		"다듬기":
			return "items/stone"
		"묶기", "감싸기", "고정":
			return "items/fiber"
		"두드리기":
			return "actions/develop"
		"불붙이기":
			return "items/campfire"
	return "actions/craft"


func _tool_craft_option_hint(option: String) -> String:
	match option:
		"맞추기":
			return "각도와 방향을 맞춘다."
		"다듬기":
			return "거친 부분을 깎고 정리한다."
		"묶기":
			return "섬유와 덩굴을 조여 묶는다."
		"감싸기":
			return "재료를 둘러 감아 흔들림을 줄인다."
		"고정":
			return "마지막으로 흔들림을 잡는다."
		"두드리기":
			return "힘을 줘 형태를 잡는다."
		"불붙이기":
			return "불을 붙인다. 지금 단계에는 위험할 수 있다."
	return "손작업을 이어간다."


func _tool_craft_quality_grade(quality: int) -> String:
	if quality >= 80:
		return "careful"
	if quality >= 55:
		return "stable"
	if quality >= 35:
		return "rough"
	return "failed"


func _tool_craft_quality_text(quality: int) -> String:
	if quality >= 80:
		return "정교함"
	if quality >= 55:
		return "안정적"
	if quality >= 35:
		return "거칠지만 완성"
	return "흐트러짐"


func _on_place_item_pressed(item_id: String) -> void:
	var result := BaseManager.place_item(item_id)
	_append_log(String(result.get("text", "")))
	_refresh_all()


func _on_save_pressed() -> void:
	_on_save_slot_pressed(1)


func _on_load_pressed() -> void:
	_on_load_slot_pressed(1)


func _on_save_slot_pressed(slot: int) -> void:
	if SaveManager.save_game(slot):
		_refresh_all()
		if active_tool_menu != "":
			_refresh_tool_menu(active_tool_menu)
			_fit_tool_menu_panel()


func _on_load_slot_pressed(slot: int) -> void:
	if SaveManager.load_game(slot):
		if starting_item_panel != null:
			starting_item_panel.visible = false
		_refresh_all()
		if active_tool_menu != "":
			_refresh_tool_menu(active_tool_menu)
			_fit_tool_menu_panel()


func _on_new_game_pressed() -> void:
	GameState.reset_state()
	InventoryManager.reset_state()
	CharacterManager.reset_state()
	WorldManager.reset_state()
	BaseManager.reset_state()
	EventManager.reset_state()
	CraftingManager.load_recipes()
	action_together_enabled = false
	active_tool_menu = ""
	shown_game_over_reason = ""
	log_lines.clear()
	_hide_tool_menu()
	_hide_map_context_menu()
	_hide_base_view()
	if action_result_panel != null:
		action_result_panel.visible = false
	_append_log("새 게임을 시작했다. 난파 직전 붙잡을 물건을 하나 고르자.")
	_refresh_all()
	_show_starting_item_selection_if_needed()


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _show_starting_item_selection_if_needed() -> void:
	if starting_item_panel == null:
		return
	if GameState.has_flag(STARTING_ITEM_SELECTED_FLAG):
		starting_item_panel.visible = false
		return
	_hide_tool_menu()
	_hide_map_context_menu()
	if event_panel != null:
		event_panel.visible = false
	if status_detail_panel != null:
		status_detail_panel.visible = false
	starting_item_panel.visible = true
	_fit_center_overlay(starting_item_panel, STARTING_ITEM_DESIRED_SIZE)
	_raise_root_overlay(starting_item_panel, Z_ROOT_EVENT + 8)


func _on_starting_item_choice_pressed(item_id: String) -> void:
	if GameState.has_flag(STARTING_ITEM_SELECTED_FLAG):
		if starting_item_panel != null:
			starting_item_panel.visible = false
		return
	var result := InventoryManager.apply_starting_item_choice(item_id)
	if not bool(result.get("ok", false)):
		_append_log(String(result.get("text", "초기 물품을 선택할 수 없다.")))
		return
	var display_name := String(result.get("display_name", item_id))
	GameState.set_flag(STARTING_ITEM_SELECTED_FLAG, true)
	GameState.set_flag(STARTING_ITEM_CHOICE_FLAG, item_id)
	if starting_item_panel != null:
		starting_item_panel.visible = false
	_append_log("난파 직전 %s을/를 붙잡았다." % display_name)
	_append_log("가방 안에는 생존 가이드가 남아 있다. 현재 위치를 조사하고, 물과 먹을 것을 확보한 뒤 해가 지기 전 쉴 곳을 찾자.")
	_refresh_all()
	_show_sensory_toast("actions/new_game", "%s을/를 움켜쥐고 해변에서 일어섰다." % display_name, Color(0.88, 0.74, 0.36))
	_maybe_show_early_survival_nudge("start")


func _play_event_intro(ready_callback: Callable) -> void:
	if event_intro_layer == null:
		if ready_callback.is_valid():
			ready_callback.call()
		return
	_prepare_event_intro_context()
	if event_intro_tween != null and event_intro_tween.is_valid():
		event_intro_tween.kill()
	event_intro_layer.visible = true
	event_intro_layer.modulate = Color(1, 1, 1, 1)
	_raise_root_overlay(event_intro_layer, Z_ROOT_EVENT_INTRO)
	if event_intro_blackout != null:
		event_intro_blackout.color = Color(0.0, 0.0, 0.0, 0.0)
	if event_intro_badge != null:
		event_intro_badge.visible = true
		event_intro_badge.modulate = Color(1, 1, 1, 0)
		event_intro_badge.scale = Vector2(0.72, 0.72)
	event_intro_tween = create_tween()
	if event_intro_badge != null:
		event_intro_tween.tween_property(event_intro_badge, "modulate", Color(1, 1, 1, 1), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		event_intro_tween.parallel().tween_property(event_intro_badge, "scale", Vector2(1.12, 1.12), 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		event_intro_tween.tween_property(event_intro_badge, "scale", Vector2(1.0, 1.0), 0.09).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	event_intro_tween.tween_interval(0.14)
	if event_intro_blackout != null:
		event_intro_tween.tween_property(event_intro_blackout, "color:a", 0.82, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	if event_intro_badge != null:
		event_intro_tween.parallel().tween_property(event_intro_badge, "modulate", Color(1, 1, 1, 0), 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		event_intro_tween.parallel().tween_property(event_intro_badge, "scale", Vector2(1.24, 1.24), 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	event_intro_tween.tween_callback(func() -> void:
		if ready_callback.is_valid():
			ready_callback.call()
	)
	event_intro_tween.tween_interval(0.04)
	if event_intro_blackout != null:
		event_intro_tween.tween_property(event_intro_blackout, "color:a", 0.0, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	event_intro_tween.tween_callback(func() -> void:
		if event_intro_layer != null:
			event_intro_layer.visible = false
			event_intro_layer.modulate = Color(1, 1, 1, 1)
		if event_intro_badge != null:
			event_intro_badge.scale = Vector2.ONE
	)


func _prepare_event_intro_context() -> void:
	if tool_menu_panel != null and tool_menu_panel.visible:
		_hide_tool_menu()
	if map_context_panel != null and map_context_panel.visible:
		_hide_map_context_menu()
	if item_action_panel != null:
		item_action_panel.visible = false
	if status_detail_panel != null:
		status_detail_panel.visible = false
	if action_cutin_layer != null:
		action_cutin_layer.visible = false
	if screen_flash_overlay != null:
		screen_flash_overlay.visible = false


func _show_event(event_data) -> void:
	if event_data == null:
		return
	_play_event_intro(Callable(self, "_show_event_after_intro").bind(event_data))


func _show_event_after_intro(event_data) -> void:
	if event_data == null:
		return
	var steps := EventManager.get_event_cutscene_steps(String(event_data.id))
	if event_data.cutscene_autoplay and not steps.is_empty():
		_play_cutscene(steps, Callable(self, "_show_event_panel").bind(event_data))
		return
	_show_event_panel(event_data)


func _show_event_panel(event_data) -> void:
	if event_data == null:
		return
	event_panel.visible = true
	_fit_center_overlay(event_panel, EVENT_DESIRED_SIZE)
	_raise_root_overlay(event_panel, Z_ROOT_EVENT)
	event_title_label.text = event_data.display_name
	event_body_label.text = _join_lines(event_data.dialogue_lines, "\n")
	_clear_children(event_choices_box)
	for index in range(event_data.choices.size()):
		var choice = event_data.choices[index]
		var button := _make_button(String(choice.get("text", "계속")), Callable(self, "_resolve_event_choice").bind(event_data.id, index))
		event_choices_box.add_child(button)
	_animate_event_panel_in()


func _animate_event_panel_in() -> void:
	if event_panel == null:
		return
	event_panel.pivot_offset = event_panel.size * 0.5
	event_panel.modulate = Color(1, 1, 1, 0)
	event_panel.scale = Vector2(0.97, 0.97)
	var tween := create_tween()
	tween.tween_property(event_panel, "modulate", Color(1, 1, 1, 1), 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(event_panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _resolve_event_choice(event_id: String, choice_index: int) -> void:
	var choice_cutscene_steps := EventManager.get_choice_cutscene_steps(event_id, choice_index)
	var result_text := EventManager.apply_event_choice(event_id, choice_index)
	_append_log(result_text)
	event_panel.visible = false
	_refresh_all()
	if not choice_cutscene_steps.is_empty():
		var resolved_steps := _inject_result_text_into_cutscene(choice_cutscene_steps, result_text)
		_play_event_intro(Callable(self, "_play_cutscene").bind(resolved_steps, Callable(self, "_refresh_all")))


func _play_cutscene(steps: Array, finished_callback: Callable = Callable()) -> void:
	if steps.is_empty():
		if finished_callback.is_valid():
			finished_callback.call()
		return
	active_cutscene_steps = steps.duplicate(true)
	active_cutscene_index = -1
	active_cutscene_finished = finished_callback
	cutscene_finishing = false
	if event_panel != null:
		event_panel.visible = false
	if tool_menu_panel != null and tool_menu_panel.visible:
		_hide_tool_menu()
	if map_context_panel != null and map_context_panel.visible:
		_hide_map_context_menu()
	if action_cutin_layer != null:
		action_cutin_layer.visible = false
	cutscene_layer.visible = true
	cutscene_layer.modulate = Color(1, 1, 1, 1)
	_raise_root_overlay(cutscene_layer, Z_ROOT_CUTSCENE)
	if cutscene_tween != null and cutscene_tween.is_valid():
		cutscene_tween.kill()
	_advance_cutscene()


func _is_cutscene_active() -> bool:
	return cutscene_layer != null and cutscene_layer.visible


func _advance_cutscene() -> void:
	if cutscene_layer == null:
		return
	if cutscene_finishing:
		return
	active_cutscene_index += 1
	if active_cutscene_index >= active_cutscene_steps.size():
		_finish_cutscene()
		return
	var step: Dictionary = active_cutscene_steps[active_cutscene_index]
	_apply_cutscene_step(step)


func _finish_cutscene() -> void:
	if cutscene_layer == null or not cutscene_layer.visible:
		return
	if cutscene_finishing:
		return
	cutscene_finishing = true
	var callback := active_cutscene_finished
	active_cutscene_steps = []
	active_cutscene_index = -1
	active_cutscene_finished = Callable()
	if cutscene_tween != null and cutscene_tween.is_valid():
		cutscene_tween.kill()
	cutscene_tween = create_tween()
	cutscene_tween.tween_property(cutscene_layer, "modulate", Color(1, 1, 1, 0), 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	cutscene_tween.tween_callback(func() -> void:
		if cutscene_layer != null:
			cutscene_layer.visible = false
		cutscene_finishing = false
		if callback.is_valid():
			callback.call()
	)


func _apply_cutscene_step(step: Dictionary) -> void:
	var tone := String(step.get("tone", "neutral"))
	var tone_color := _cutscene_tone_color(tone)
	var background_ref := String(step.get("background", "current_tile"))
	var background_texture = _cutscene_texture_for_ref(background_ref)
	if background_texture != null:
		cutscene_background.texture = background_texture
	cutscene_background.modulate = Color(0.78, 0.82, 0.82, float(step.get("background_alpha", 0.82)))
	cutscene_scrim.color = _cutscene_scrim_color(tone)
	_apply_cutscene_portrait(cutscene_left_image, String(step.get("left_image", "")), String(step.get("focus", "")) == "left")
	_apply_cutscene_portrait(cutscene_right_image, String(step.get("right_image", "")), String(step.get("focus", "")) == "right")
	cutscene_speaker_label.text = String(step.get("speaker", ""))
	cutscene_speaker_label.add_theme_color_override("font_color", tone_color.lightened(0.18))
	cutscene_body_label.text = String(step.get("text", ""))
	cutscene_body_label.add_theme_color_override("font_color", Color(0.90, 0.93, 0.88))
	cutscene_step_label.text = "%d / %d" % [active_cutscene_index + 1, active_cutscene_steps.size()]
	cutscene_text_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.030, 0.045, 0.046, 0.94), tone_color, 6))
	_animate_cutscene_step(step, tone_color)


func _apply_cutscene_portrait(target: TextureRect, image_ref: String, focused: bool) -> void:
	if target == null:
		return
	if image_ref == "":
		target.texture = null
		target.modulate = Color(1, 1, 1, 0)
		return
	var texture = _cutscene_texture_for_ref(image_ref)
	target.texture = texture
	if texture == null:
		target.modulate = Color(1, 1, 1, 0)
		return
	target.modulate = Color(1, 1, 1, 1.0 if focused else 0.52)
	target.scale = Vector2(1.02, 1.02) if focused else Vector2(0.98, 0.98)


func _animate_cutscene_step(step: Dictionary, tone_color: Color) -> void:
	if cutscene_tween != null and cutscene_tween.is_valid():
		cutscene_tween.kill()
	cutscene_tween = create_tween()
	cutscene_tween.set_parallel(true)
	cutscene_text_panel.modulate = Color(1, 1, 1, 0)
	cutscene_text_panel.position = Vector2(0, 12)
	cutscene_body_label.visible_ratio = 0.0
	cutscene_tween.tween_property(cutscene_text_panel, "modulate", Color(1, 1, 1, 1), 0.14)
	cutscene_tween.tween_property(cutscene_text_panel, "position", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_animate_cutscene_portrait_entry(cutscene_left_image, Vector2(-18.0, 0.0))
	_animate_cutscene_portrait_entry(cutscene_right_image, Vector2(18.0, 0.0))
	var text_time := clampf(float(cutscene_body_label.text.length()) / 46.0, 0.22, 1.15)
	cutscene_tween.tween_property(cutscene_body_label, "visible_ratio", 1.0, text_time)
	if bool(step.get("flash", false)):
		_play_screen_flash(tone_color, 0.16, 0.22)
	if bool(step.get("shake", false)):
		_play_screen_shake(4.0, 0.20)


func _animate_cutscene_portrait_entry(target: TextureRect, from_offset: Vector2) -> void:
	if target == null or cutscene_tween == null:
		return
	var target_modulate := target.modulate
	var target_position := Vector2.ZERO
	target.position = from_offset
	target.modulate = Color(target_modulate.r, target_modulate.g, target_modulate.b, 0.0)
	cutscene_tween.tween_property(target, "position", target_position, 0.24).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	cutscene_tween.tween_property(target, "modulate", target_modulate, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _cutscene_texture_for_ref(ref_id: String):
	match ref_id:
		"", "none":
			return null
		"player":
			return _texture_from_path("res://assets/sprites/characters/player_cowboy_shot.png")
		"partner":
			return _texture_from_path("res://assets/sprites/characters/partner_cowboy_shot.png")
		"pair":
			return _texture_from_path("res://assets/sprites/characters/survivor_pair_teens.png")
		"current_tile":
			var tile = WorldManager.get_current_tile()
			if tile != null:
				return _texture_from_path(String(tile.get("image_path", "")))
			return null
		"world_map":
			return _texture_from_path("res://assets/maps/island_world_map.png")
	if ref_id.begins_with("tile:"):
		var tile_id := ref_id.substr(5)
		var tile = WorldManager.get_tile(tile_id)
		if tile != null:
			return _texture_from_path(String(tile.get("image_path", "")))
	if ref_id.begins_with("res://"):
		return _texture_from_path(ref_id)
	return _icon_texture(ref_id)


func _cutscene_tone_color(tone: String) -> Color:
	match tone:
		"warm":
			return Color(0.95, 0.72, 0.36)
		"danger":
			return Color(0.86, 0.28, 0.22)
		"rain":
			return Color(0.44, 0.62, 0.78)
		"mystery":
			return Color(0.62, 0.54, 0.92)
		"relief":
			return Color(0.62, 0.82, 0.50)
	return Color(0.78, 0.70, 0.42)


func _cutscene_scrim_color(tone: String) -> Color:
	match tone:
		"danger":
			return Color(0.09, 0.02, 0.02, 0.56)
		"rain":
			return Color(0.02, 0.06, 0.10, 0.58)
		"mystery":
			return Color(0.04, 0.03, 0.10, 0.60)
		"relief":
			return Color(0.02, 0.06, 0.04, 0.46)
	return Color(0.015, 0.020, 0.022, 0.50)


func _inject_result_text_into_cutscene(steps: Array, result_text: String) -> Array:
	var result: Array = []
	for raw_step in steps:
		var step: Dictionary = raw_step.duplicate(true) if raw_step is Dictionary else {}
		if String(step.get("text", "")) == "{result_text}":
			step["text"] = result_text
		result.append(step)
	return result


func _on_game_over(reason: String) -> void:
	_append_log("게임 오버: %s" % reason)
	_show_game_over_panel(reason)
	_refresh_all()


func _check_zero_hp_game_over() -> void:
	if GameState.is_game_over:
		if GameState.game_over_reason != "" and shown_game_over_reason != GameState.game_over_reason:
			call_deferred("_show_game_over_panel", GameState.game_over_reason)
		return
	if CharacterManager.player_status != null and CharacterManager.player_status.hp <= 0:
		GameState.trigger_game_over("플레이어의 체력이 0이 되었다.")
		return
	if CharacterManager.partner_joined and CharacterManager.partner_status != null and CharacterManager.partner_status.hp <= 0:
		GameState.trigger_game_over("파트너의 체력이 0이 되었다.")


func _show_game_over_panel(reason: String) -> void:
	if action_result_panel == null:
		return
	shown_game_over_reason = reason
	_hide_map_context_menu()
	if tool_menu_panel != null and tool_menu_panel.visible:
		_hide_tool_menu()
	action_result_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.080, 0.035, 0.035, 0.98), Color(0.86, 0.26, 0.20, 0.92), 8))
	if action_result_icon != null:
		var texture = _icon_texture("status/hp")
		if texture != null:
			action_result_icon.texture = texture
	if action_result_title_label != null:
		action_result_title_label.text = "게임 오버"
	if action_result_body_label != null:
		action_result_body_label.text = "%s\n체력이 0이 되어 더 이상 생존을 이어갈 수 없습니다." % reason
	if action_result_delta_label != null:
		action_result_delta_label.text = "새 게임을 시작하거나 저장된 게임을 불러와 다시 진행할 수 있습니다."
	if action_result_items_box != null:
		_clear_children(action_result_items_box)
	action_result_panel.visible = true
	_fit_center_overlay(action_result_panel, ACTION_RESULT_DESIRED_SIZE)
	_raise_root_overlay(action_result_panel, Z_ROOT_MODAL)


func _create_vertical_character_image(title: String, active: bool) -> Control:
	var frame := Control.new()
	frame.custom_minimum_size = Vector2(0, 240)
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.clip_contents = true

	var bg := PanelContainer.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.add_theme_stylebox_override("panel", _make_panel_style(Color(0.06, 0.08, 0.08), Color(0.28, 0.35, 0.33), 5))
	frame.add_child(bg)

	var texture_rect := TextureRect.new()
	texture_rect.name = "CharacterTexture"
	texture_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var texture_path := "res://assets/sprites/characters/player_cowboy_shot.png" if title == "플레이어" else "res://assets/sprites/characters/partner_cowboy_shot.png"
	var texture = _texture_from_path(texture_path)
	if texture == null and ResourceLoader.exists("res://assets/sprites/characters/survivor_pair_teens.png"):
		texture = load("res://assets/sprites/characters/survivor_pair_teens.png")
	texture_rect.texture = texture
	frame.add_child(texture_rect)

	var character_glow := TextureRect.new()
	character_glow.name = "CharacterGlow"
	character_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	character_glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	character_glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	character_glow.stretch_mode = TextureRect.STRETCH_SCALE
	var glow_texture = _texture_from_path("res://assets/ui/character_panel_glow.png")
	if glow_texture != null:
		character_glow.texture = glow_texture
	character_glow.modulate = Color(1.0, 0.92, 0.72, 0.62 if active else 0.18)
	frame.add_child(character_glow)

	var tint := ColorRect.new()
	tint.name = "InactiveTint"
	tint.color = Color(0.02, 0.025, 0.025, 0.18 if active else 0.68)
	tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.add_child(tint)

	var emotion_tint := ColorRect.new()
	emotion_tint.name = "EmotionTint"
	emotion_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	emotion_tint.color = Color(0.0, 0.0, 0.0, 0.0)
	emotion_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.add_child(emotion_tint)

	var danger_overlay := TextureRect.new()
	danger_overlay.name = "DangerOverlay"
	danger_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	danger_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	danger_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	danger_overlay.stretch_mode = TextureRect.STRETCH_SCALE
	danger_overlay.visible = false
	var danger_texture = _texture_from_path("res://assets/ui/character_effects/danger_overlay.png")
	if danger_texture != null:
		danger_overlay.texture = danger_texture
	danger_overlay.modulate = Color(1.0, 1.0, 1.0, 0.0)
	frame.add_child(danger_overlay)

	var label := Label.new()
	label.name = "ImageLabel"
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.offset_left = 10
	label.offset_top = 8
	label.offset_right = -10
	label.offset_bottom = 32
	label.text = title
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.98, 0.93, 0.78))
	frame.add_child(label)

	var expression := PanelContainer.new()
	expression.name = "ExpressionBadge"
	expression.anchor_left = 0.0
	expression.anchor_right = 1.0
	expression.anchor_top = 1.0
	expression.anchor_bottom = 1.0
	expression.offset_left = 10
	expression.offset_top = -48
	expression.offset_right = -10
	expression.offset_bottom = -10
	expression.add_theme_stylebox_override("panel", _make_panel_style(Color(0.03, 0.04, 0.04, 0.72), Color(0.92, 0.82, 0.46, 0.55), 5))
	frame.add_child(expression)

	var expression_label := Label.new()
	expression_label.name = "ExpressionText"
	expression_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	expression_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	expression_label.add_theme_font_size_override("font_size", 12)
	expression_label.add_theme_color_override("font_color", Color(0.98, 0.93, 0.78))
	expression.add_child(expression_label)

	var state_layer := HBoxContainer.new()
	state_layer.name = "StateIconLayer"
	state_layer.anchor_left = 1.0
	state_layer.anchor_right = 1.0
	state_layer.offset_left = -112
	state_layer.offset_top = 8
	state_layer.offset_right = -10
	state_layer.offset_bottom = 34
	state_layer.alignment = BoxContainer.ALIGNMENT_END
	state_layer.add_theme_constant_override("separation", 4)
	frame.add_child(state_layer)

	var detail_badge := PanelContainer.new()
	detail_badge.name = "DetailBadge"
	detail_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_badge.anchor_left = 0.0
	detail_badge.anchor_right = 0.0
	detail_badge.offset_left = 10
	detail_badge.offset_top = 36
	detail_badge.offset_right = 78
	detail_badge.offset_bottom = 62
	detail_badge.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.035, 0.033, 0.76), Color(0.92, 0.82, 0.46, 0.62), 5))
	frame.add_child(detail_badge)

	var detail_margin := MarginContainer.new()
	detail_margin.add_theme_constant_override("margin_left", 5)
	detail_margin.add_theme_constant_override("margin_top", 4)
	detail_margin.add_theme_constant_override("margin_right", 5)
	detail_margin.add_theme_constant_override("margin_bottom", 4)
	detail_badge.add_child(detail_margin)

	var detail_row := HBoxContainer.new()
	detail_row.alignment = BoxContainer.ALIGNMENT_CENTER
	detail_row.add_theme_constant_override("separation", 3)
	detail_margin.add_child(detail_row)

	var detail_icon := TextureRect.new()
	detail_icon.custom_minimum_size = Vector2(14, 14)
	detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	detail_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var detail_texture = _icon_texture("status/stable")
	if detail_texture != null:
		detail_icon.texture = detail_texture
	detail_row.add_child(detail_icon)

	var detail_label := Label.new()
	detail_label.text = "상세"
	detail_label.add_theme_font_size_override("font_size", 10)
	detail_label.add_theme_color_override("font_color", Color(0.98, 0.93, 0.78))
	detail_row.add_child(detail_label)

	var detail_button := Button.new()
	detail_button.name = "ImageDetailButton"
	detail_button.text = ""
	detail_button.flat = true
	detail_button.focus_mode = Control.FOCUS_NONE
	detail_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	detail_button.tooltip_text = "상세정보"
	detail_button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var empty_style := StyleBoxEmpty.new()
	detail_button.add_theme_stylebox_override("normal", empty_style)
	detail_button.add_theme_stylebox_override("hover", empty_style)
	detail_button.add_theme_stylebox_override("pressed", empty_style)
	detail_button.add_theme_stylebox_override("focus", empty_style)
	detail_button.pressed.connect(Callable(self, "_show_status_detail").bind("player" if active else "partner"))
	frame.add_child(detail_button)
	return frame


func _set_character_image_state(frame: Control, active: bool, status = null, is_partner: bool = false) -> void:
	if frame == null:
		return
	var character_texture = frame.get_node_or_null("CharacterTexture")
	if character_texture != null:
		var image_path := _character_image_path(status, active, is_partner)
		var image_texture = _texture_from_path(image_path)
		if image_texture != null:
			character_texture.texture = image_texture
	var tint = frame.get_node_or_null("InactiveTint")
	if tint != null:
		tint.color = Color(0.02, 0.025, 0.025, 0.18 if active else 0.68)
	var emotion_tint = frame.get_node_or_null("EmotionTint")
	if emotion_tint != null:
		emotion_tint.color = _character_expression_tint(status, active)
	var character_glow = frame.get_node_or_null("CharacterGlow")
	if character_glow != null:
		character_glow.modulate = _character_glow_modulate(status, active)
	var danger_overlay = frame.get_node_or_null("DangerOverlay")
	if danger_overlay != null:
		var danger_active := _is_character_danger_state(status, active)
		danger_overlay.visible = danger_active
		danger_overlay.modulate = _character_danger_overlay_modulate(status) if danger_active else Color(1.0, 1.0, 1.0, 0.0)
	var label = frame.get_node_or_null("ImageLabel")
	if label != null:
		if is_partner:
			label.text = "동행자" if active else "동행자 없음"
		else:
			label.text = "플레이어"
	var expression_label = frame.get_node_or_null("ExpressionBadge/ExpressionText")
	if expression_label != null:
		expression_label.text = _character_expression_text(status, active, is_partner)
	var expression_badge = frame.get_node_or_null("ExpressionBadge")
	if expression_badge != null:
		expression_badge.visible = active
		expression_badge.add_theme_stylebox_override("panel", _make_panel_style(_character_expression_panel_color(status, active), _character_expression_border_color(status, active), 5))
	var detail_badge = frame.get_node_or_null("DetailBadge")
	if detail_badge != null:
		detail_badge.visible = active
	_refresh_character_state_icons(frame, active, status)


func _character_image_path(status, active: bool, is_partner: bool) -> String:
	if is_partner:
		if not active or status == null:
			return "res://assets/sprites/characters/partner_cowboy_shot.png"
		if status.has_state("wound") or status.has_state("infection_risk") or status.hp <= 35:
			return "res://assets/sprites/characters/partner_states/partner_injured.png"
		if status.has_state("thirst_risk") or status.has_state("hunger_risk") or status.thirst <= 30 or status.hunger <= 30:
			return "res://assets/sprites/characters/partner_states/partner_hungry_thirsty.png"
		if status.has_state("fear") or status.has_state("anxiety") or status.has_state("loneliness"):
			return "res://assets/sprites/characters/partner_states/partner_fear.png"
		if status.has_state("fatigue") or status.has_state("wet") or status.stamina <= 35:
			return "res://assets/sprites/characters/partner_states/partner_tired.png"
		return "res://assets/sprites/characters/partner_cowboy_shot.png"
	if not active or status == null:
		return "res://assets/sprites/characters/player_cowboy_shot.png"
	if status.has_state("wound") or status.has_state("infection_risk") or status.hp <= 35:
		return "res://assets/sprites/characters/player_states/player_injured.png"
	if status.has_state("thirst_risk") or status.has_state("hunger_risk") or status.thirst <= 30 or status.hunger <= 30:
		return "res://assets/sprites/characters/player_states/player_hungry_thirsty.png"
	if status.has_state("fear") or status.has_state("anxiety") or status.has_state("loneliness"):
		return "res://assets/sprites/characters/player_states/player_fear.png"
	if status.has_state("fatigue") or status.has_state("wet") or status.stamina <= 35:
		return "res://assets/sprites/characters/player_states/player_tired.png"
	return "res://assets/sprites/characters/player_cowboy_shot.png"


func _is_character_danger_state(status, active: bool) -> bool:
	if not active or status == null:
		return false
	return _character_danger_severity(status) >= 0.25


func _character_danger_overlay_modulate(status) -> Color:
	var severity := _character_danger_severity(status)
	return Color(1.0, 1.0, 1.0, clampf(0.36 + severity * 0.42, 0.0, 0.82))


func _character_danger_severity(status) -> float:
	if status == null:
		return 0.0
	var severity := 0.0
	severity = max(severity, clampf((45.0 - float(status.hp)) / 45.0, 0.0, 1.0))
	severity = max(severity, clampf((36.0 - float(status.hunger)) / 36.0, 0.0, 1.0))
	severity = max(severity, clampf((36.0 - float(status.thirst)) / 36.0, 0.0, 1.0))
	severity = max(severity, clampf((26.0 - float(status.stamina)) / 26.0, 0.0, 1.0))
	if status.has_state("wound"):
		severity = max(severity, 0.68)
	if status.has_state("infection_risk"):
		severity = max(severity, 0.82)
	if status.has_state("hunger_risk") or status.has_state("thirst_risk"):
		severity = max(severity, 0.58)
	if status.has_state("fear"):
		severity = max(severity, 0.50)
	return severity


func _refresh_character_state_icons(frame: Control, active: bool, status) -> void:
	var layer = frame.get_node_or_null("StateIconLayer")
	if layer == null:
		return
	_clear_children(layer)
	layer.visible = active and status != null and not status.states.is_empty()
	if not layer.visible:
		return
	var priority: Array[String] = ["wound", "infection_risk", "thirst_risk", "hunger_risk", "fear", "poor_hygiene", "wet", "fatigue", "anxiety", "loneliness"]
	var added: Dictionary = {}
	for state_id in priority:
		if status.has_state(state_id):
			layer.add_child(_make_image_state_icon(state_id))
			added[state_id] = true
			if layer.get_child_count() >= 4:
				return
	for raw_state in status.states:
		var state_id := String(raw_state)
		if added.has(state_id):
			continue
		layer.add_child(_make_image_state_icon(state_id))
		if layer.get_child_count() >= 4:
			return


func _make_image_state_icon(state_id: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(26, 26)
	panel.tooltip_text = _state_display_name(state_id)
	panel.add_theme_stylebox_override("panel", _make_panel_style(_state_living_color(state_id).darkened(0.38), _state_living_color(state_id), 6))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(_state_icon_id(state_id))
	if texture != null:
		icon.texture = texture
	margin.add_child(icon)
	return panel


func _add_status_card(parent: VBoxContainer, title: String, status, show_trust: bool) -> void:
	parent.add_child(_small_title(title))
	if status == null:
		var missing := _create_body_label()
		missing.text = "상태 정보 없음"
		parent.add_child(missing)
		return
	var mood_line := Label.new()
	mood_line.text = _living_status_sentence(status, show_trust)
	mood_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mood_line.clip_text = true
	mood_line.max_lines_visible = 2
	mood_line.add_theme_font_size_override("font_size", 12)
	mood_line.add_theme_color_override("font_color", _living_status_color(status))
	parent.add_child(mood_line)
	parent.add_child(_make_body_sense_line(status))

	var chip_grid := GridContainer.new()
	chip_grid.columns = 2
	chip_grid.add_theme_constant_override("h_separation", 5)
	chip_grid.add_theme_constant_override("v_separation", 5)
	var chips := _living_status_chips(status, show_trust)
	for index in range(mini(chips.size(), 3)):
		chip_grid.add_child(_make_living_status_chip(chips[index]))
	parent.add_child(chip_grid)

	parent.add_child(_make_survival_meter_grid(status))
	if show_trust:
		parent.add_child(_make_relationship_hint(status))


func _add_inventory_summary(parent: VBoxContainer, owner_id: String = "player", compact: bool = false) -> void:
	if compact:
		parent.add_child(_make_inventory_drop_summary(owner_id))
		return
	var title := _small_title("소지품" if owner_id == "player" else "파트너 소지품")
	title.add_theme_font_size_override("font_size", 13)
	parent.add_child(title)
	var enabled := owner_id == "player" or InventoryManager.can_access_partner_inventory()
	parent.add_child(_make_item_drop_zone(
		"inventory_%s" % owner_id,
		WorldManager.current_tile_id,
		["field", "inventory", "base_storage"],
		_make_quick_card_grid(owner_id, "all", 9, owner_id),
		"필드/상대 → %s" % InventoryManager.get_owner_display_name(owner_id),
		enabled
	))


func _make_inventory_drop_summary(owner_id: String = "player") -> PanelContainer:
	var enabled := owner_id == "player" or InventoryManager.can_access_partner_inventory()
	var tools := _inventory_summary_text(true, 1, owner_id)
	var supplies := _inventory_summary_text(false, 2, owner_id)
	var summary := Label.new()
	summary.text = "도구 %s · 물품 %s" % [tools, supplies]
	summary.clip_text = true
	summary.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	summary.add_theme_font_size_override("font_size", 10)
	summary.add_theme_color_override("font_color", Color(0.78, 0.84, 0.76))
	_prepare_single_line_label(summary, 120)
	var zone := _make_item_drop_zone(
		"inventory_%s" % owner_id,
		WorldManager.current_tile_id,
		["field", "inventory", "base_storage"],
		summary,
		"드래그 수납 · 인벤토리 메뉴에서 전체 %s 확인" % InventoryManager.get_owner_display_name(owner_id),
		enabled
	)
	zone.clip_contents = true
	zone.custom_minimum_size = Vector2(0, 52)
	zone.tooltip_text = "소지품 요약\n도구: %s\n물품: %s\n전체 목록은 인벤토리 메뉴에서 확인한다." % [tools, supplies]
	if not enabled:
		zone.tooltip_text = "파트너가 같은 타일에 있어야 소지품을 주고받을 수 있다."
	return zone


func _make_carry_weight_panel(compact: bool = false, owner_id: String = "player") -> PanelContainer:
	var current_weight := InventoryManager.get_current_weight(owner_id)
	var capacity := InventoryManager.get_carry_capacity(owner_id)
	var ratio := InventoryManager.get_weight_ratio(owner_id)
	var color := Color(0.52, 0.68, 0.44)
	if ratio >= 1.0:
		color = Color(0.86, 0.25, 0.18)
	elif ratio >= 0.85:
		color = Color(0.90, 0.58, 0.22)
	elif ratio >= 0.65:
		color = Color(0.82, 0.70, 0.30)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 48 if compact else 62)
	panel.tooltip_text = "%s 짐 %.1f / %.1f\n필드에 물건을 내려놓거나 서로 나눠 들면 다시 가벼워진다." % [InventoryManager.get_owner_display_name(owner_id), current_weight, capacity]
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.047, 0.90), color.darkened(0.15), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	box.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(17, 17)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("items/storage_box")
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = "짐 %s  %.1f/%.1f" % [InventoryManager.get_carry_state_text(owner_id), current_weight, capacity]
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 11 if compact else 13)
	label.add_theme_color_override("font_color", color.lightened(0.30))
	row.add_child(label)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 7)
	bar.max_value = 100
	bar.value = clampf(ratio * 100.0, 0.0, 100.0)
	bar.show_percentage = false
	bar.add_theme_stylebox_override("background", _make_panel_style(Color(0.015, 0.022, 0.022, 0.92), Color(0.02, 0.03, 0.03, 0.0), 3))
	bar.add_theme_stylebox_override("fill", _make_panel_style(color, color.lightened(0.10), 3))
	box.add_child(bar)
	return panel


func _add_partner_summary(parent: VBoxContainer, compact: bool = false) -> void:
	var title := _small_title("분담 정보")
	title.add_theme_font_size_override("font_size", 13)
	parent.add_child(title)
	if CharacterManager.partner_joined:
		parent.add_child(_make_partner_mode_panel())
		if not compact:
			parent.add_child(_make_relationship_memory_panel())
	else:
		var body := _create_body_label()
		body.add_theme_font_size_override("font_size", 11)
		body.text = "합류 전\n동행 보조 비활성"
		parent.add_child(body)
	if CharacterManager.partner_joined and not compact:
		parent.add_child(_make_quick_card_grid("partner", "usable", 6, "partner"))


func _make_relationship_memory_panel() -> PanelContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture("actions/talk")
	if texture != null:
		icon.texture = texture
	header.add_child(icon)
	var title := Label.new()
	title.text = "기억"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(0.98, 0.92, 0.70))
	header.add_child(title)
	box.add_child(header)
	var memories := CharacterManager.get_relationship_memories(3)
	if memories.is_empty():
		var empty := _create_body_label()
		empty.add_theme_font_size_override("font_size", 10)
		empty.text = "아직 둘 사이에 오래 남은 사건은 없다."
		box.add_child(empty)
	else:
		for memory in memories:
			box.add_child(_make_memory_line(memory))
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.045, 0.052, 0.050, 0.90), Color(0.70, 0.62, 0.36), 8))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 7)
	panel.add_child(margin)
	margin.add_child(box)
	return panel


func _make_memory_line(memory: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(memory.get("icon", "actions/talk")))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = String(memory.get("text", ""))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.88, 0.86, 0.74))
	row.add_child(label)
	return row


func _make_partner_mode_panel() -> PanelContainer:
	var partner_tile_id := CharacterManager.get_partner_tile_id(WorldManager.current_tile_id)
	var location_label := _tile_label(partner_tile_id) if partner_tile_id != "" else "알 수 없음"
	var mode_id := CharacterManager.get_partner_mode_id()
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(_partner_mode_icon(mode_id))
	if texture != null:
		icon.texture = texture
	header.add_child(icon)

	var mode_label := Label.new()
	mode_label.text = CharacterManager.get_partner_mode_short_text()
	mode_label.clip_text = true
	mode_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	mode_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mode_label.add_theme_font_size_override("font_size", 12)
	mode_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.70))
	header.add_child(mode_label)
	box.add_child(header)

	box.add_child(_make_side_summary_line("위치", location_label, "actions/move"))
	box.add_child(_make_side_summary_line("역할", _partner_mode_role_note(mode_id), _partner_mode_icon(mode_id)))

	var detail := _create_body_label()
	detail.add_theme_font_size_override("font_size", 10)
	detail.text = _partner_mode_ui_note(mode_id)
	box.add_child(detail)

	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(_partner_mode_color(mode_id, 0.58), _partner_mode_border_color(mode_id), 8))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 7)
	panel.add_child(margin)
	margin.add_child(box)
	return panel


func _partner_mode_role_note(mode_id: String) -> String:
	match mode_id:
		"together":
			return "행동 보조 가능"
		"assigned":
			return CharacterManager.get_partner_task_label()
		"separate":
			return "혼자 행동 중"
	return "확인 전"


func _partner_mode_ui_note(mode_id: String) -> String:
	match mode_id:
		"together":
			return "위험을 나누지만, 기력과 허기도 함께 닳는다."
		"assigned":
			return CharacterManager.get_partner_task_detail()
		"separate":
			return "같은 타일에서 말을 걸면 다시 동행하거나 일을 맡길 수 있다."
	return "파트너와 아직 합류하지 않았다."


func _partner_mode_icon(mode_id: String) -> String:
	match mode_id:
		"together":
			return "actions/assist"
		"assigned":
			return "actions/place"
		"separate":
			return "actions/move"
	return "status/stable"


func _partner_task_icon(task_id: String) -> String:
	for task in CharacterManager.get_partner_available_tasks():
		if String(task.get("id", "")) == task_id:
			return String(task.get("icon", "actions/rest"))
	return "actions/rest"


func _partner_mode_color(mode_id: String, alpha: float) -> Color:
	match mode_id:
		"together":
			return Color(0.050, 0.100, 0.070, alpha)
		"assigned":
			return Color(0.120, 0.085, 0.040, alpha)
		"separate":
			return Color(0.055, 0.070, 0.085, alpha)
	return Color(0.04, 0.05, 0.05, alpha)


func _partner_mode_border_color(mode_id: String) -> Color:
	match mode_id:
		"together":
			return Color(0.62, 0.82, 0.42, 0.72)
		"assigned":
			return Color(0.92, 0.66, 0.30, 0.72)
		"separate":
			return Color(0.44, 0.62, 0.76, 0.68)
	return Color(0.54, 0.58, 0.54, 0.50)


func _make_side_summary_line(label_text: String, value_text: String, icon_id: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(34, 0)
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.82, 0.88, 0.86))
	row.add_child(label)

	var value := Label.new()
	value.text = value_text
	value.clip_text = true
	value.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value.add_theme_font_size_override("font_size", 11)
	value.add_theme_color_override("font_color", Color(0.88, 0.92, 0.88))
	row.add_child(value)
	return row


func _inventory_summary_text(tool_like: bool, limit: int, owner_id: String = "player") -> String:
	var parts: Array[String] = []
	var hidden_count := 0
	var target_items := InventoryManager.get_items(owner_id)
	var keys := target_items.keys()
	keys.sort()
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var item = InventoryManager.get_item_data(item_id)
		if item == null:
			continue
		if _is_tool_like_item(item) != tool_like:
			continue
		if parts.size() < limit:
			parts.append("%s %d" % [item.display_name, int(target_items[item_id])])
		else:
			hidden_count += 1
	if parts.is_empty():
		return "없음"
	if hidden_count > 0:
		parts.append("외 %d" % hidden_count)
	return _join_lines(parts, ", ")


func _is_tool_like_item(item) -> bool:
	return item.category == "tool" or item.tags.has("tool") or item.tags.has("placeable")


func _make_quick_card_grid(target_id: String, filter: String, limit: int, owner_id: String = "player") -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 5)
	grid.add_theme_constant_override("v_separation", 5)
	var target_items := InventoryManager.get_items(owner_id)
	for item_id in _inventory_card_ids(limit, filter, owner_id):
		grid.add_child(_make_item_card(item_id, int(target_items[item_id]), target_id, true, owner_id))
	if grid.get_child_count() == 0:
		var empty := _create_body_label()
		empty.text = "소지품 없음"
		empty.add_theme_font_size_override("font_size", 11)
		grid.add_child(empty)
	return grid


func _inventory_card_ids(limit: int, filter: String = "all", owner_id: String = "player") -> Array[String]:
	var target_items := InventoryManager.get_items(owner_id)
	var ids: Array[String] = []
	for raw_item_id in InventoryManager.get_ordered_item_ids(owner_id, inventory_sort_mode):
		var item_id := String(raw_item_id)
		var item = InventoryManager.get_item_data(item_id)
		if item == null:
			continue
		if filter == "usable" and not _item_is_directly_usable(item):
			continue
		if not target_items.has(item_id):
			continue
		ids.append(item_id)
		if ids.size() >= limit:
			break
	return ids


func _living_status_sentence(status, show_trust: bool) -> String:
	if status == null:
		return "상태를 읽을 수 없다."
	if status.hp <= 30:
		return "몸을 제대로 가누기 힘들어 보인다."
	if status.stamina <= 25:
		return "말수가 줄고 걸음이 무거워졌다."
	if status.thirst <= 25:
		return "입술이 말라 자주 물을 찾는다."
	if status.hunger <= 25:
		return "허기가 행동을 방해하고 있다."
	if status.mood <= 35:
		return "섬의 공기가 둘 사이를 조금 눌러놓는다."
	if show_trust:
		return CharacterManager.get_relationship_cue_text()
	return "아직은 버틸 만한 호흡을 유지하고 있다."


func _living_status_chips(status, show_trust: bool) -> Array[Dictionary]:
	var chips: Array[Dictionary] = []
	if status.stamina <= 25:
		chips.append(_status_chip_data("status/fatigue", "몹시 피곤함", Color(0.68, 0.48, 0.28)))
	elif status.stamina <= 55:
		chips.append(_status_chip_data("status/stamina", "약간 피곤함", Color(0.78, 0.62, 0.32)))
	if status.hunger <= 25:
		chips.append(_status_chip_data("status/hunger", "배고픔", Color(0.70, 0.50, 0.28)))
	elif status.hunger <= 50:
		chips.append(_status_chip_data("status/hunger", "출출함", Color(0.58, 0.68, 0.34)))
	if status.thirst <= 25:
		chips.append(_status_chip_data("status/thirst", "목마름", Color(0.30, 0.52, 0.72)))
	elif status.thirst <= 50:
		chips.append(_status_chip_data("status/thirst", "물을 아낌", Color(0.34, 0.62, 0.74)))
	if status.mood <= 35:
		chips.append(_status_chip_data("status/mood", "불안함", Color(0.58, 0.38, 0.62)))
	elif status.mood >= 75:
		chips.append(_status_chip_data("status/stable", "마음이 놓임", Color(0.45, 0.68, 0.48)))
	if status.hygiene <= 35:
		chips.append(_status_chip_data("status/fatigue", "찝찝함", Color(0.42, 0.58, 0.56)))
	for raw_state in status.states:
		var state_id := String(raw_state)
		if ["fatigue", "fear", "loneliness", "wet", "wound", "anxiety", "poor_hygiene", "hunger_risk", "thirst_risk", "infection_risk"].has(state_id):
			chips.append(_status_chip_data(_state_icon_id(state_id), _state_living_text(state_id), _state_living_color(state_id)))
	if show_trust:
		chips.append(_status_chip_data("status/trust", CharacterManager.get_relationship_state_label(), CharacterManager.get_relationship_state_color()))
	if chips.is_empty():
		chips.append(_status_chip_data("status/stable", "차분함", Color(0.45, 0.64, 0.46)))
	return chips.slice(0, mini(chips.size(), 4))


func _status_chip_data(icon_id: String, text: String, color: Color) -> Dictionary:
	return {"icon": icon_id, "text": text, "color": color}


func _make_living_status_chip(chip_data: Dictionary) -> PanelContainer:
	var color: Color = chip_data.get("color", Color(0.45, 0.55, 0.48))
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 28)
	panel.add_theme_stylebox_override("panel", _make_panel_style(color.darkened(0.42), color, 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(chip_data.get("icon", "")))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = String(chip_data.get("text", ""))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.96, 0.94, 0.84))
	row.add_child(label)
	return panel


func _make_body_sense_line(status) -> PanelContainer:
	var cue := _body_sense_cue(status)
	var color: Color = cue.get("color", Color(0.50, 0.58, 0.44))
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 28)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.025, 0.035, 0.034, 0.84), color.darkened(0.10), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 7)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 7)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(String(cue.get("icon", "status/stable")))
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = String(cue.get("text", "몸 상태를 가늠한다."))
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", color.lightened(0.34))
	row.add_child(label)
	return panel


func _body_sense_cue(status) -> Dictionary:
	if status == null:
		return {"text": "몸의 신호가 흐릿하다.", "icon": "status/stable", "color": Color(0.50, 0.58, 0.44)}
	if status.hp <= 25:
		return {"text": "몸이 휘청이고 시야가 좁다.", "icon": "status/hp", "color": Color(0.86, 0.24, 0.20)}
	if status.thirst <= 30:
		return {"text": "입술이 갈라지고 목이 붙는다.", "icon": "status/thirst", "color": Color(0.36, 0.62, 0.86)}
	if status.hunger <= 30:
		return {"text": "속이 비어 손끝이 떨린다.", "icon": "status/hunger", "color": Color(0.84, 0.52, 0.22)}
	if status.stamina <= 30:
		return {"text": "숨이 짧고 어깨가 무겁다.", "icon": "status/stamina", "color": Color(0.84, 0.64, 0.28)}
	if status.has_state("fear"):
		return {"text": "등 뒤가 자꾸 신경 쓰인다.", "icon": "status/fear", "color": Color(0.64, 0.42, 0.76)}
	if status.hygiene <= 35:
		return {"text": "피부에 모래와 땀이 말라붙었다.", "icon": "status/fatigue", "color": Color(0.46, 0.60, 0.48)}
	if status.mood <= 35:
		return {"text": "말을 아끼게 되고 표정이 굳는다.", "icon": "status/mood", "color": Color(0.64, 0.46, 0.72)}
	return {"text": "아직 움직일 만한 온기가 남아 있다.", "icon": "status/stable", "color": Color(0.54, 0.66, 0.42)}


func _make_survival_meter_grid(status) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 5)
	grid.add_theme_constant_override("v_separation", 5)
	grid.add_child(_make_survival_meter("status/hp", "체력", status.hp, Color(0.78, 0.25, 0.23)))
	grid.add_child(_make_survival_meter("status/stamina", "기력", status.stamina, Color(0.84, 0.62, 0.24)))
	grid.add_child(_make_survival_meter("status/hunger", "허기", status.hunger, Color(0.74, 0.45, 0.20)))
	grid.add_child(_make_survival_meter("status/thirst", "수분", status.thirst, Color(0.28, 0.56, 0.78)))
	return grid


func _make_survival_hint_grid(status) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 5)
	grid.add_theme_constant_override("v_separation", 4)
	grid.add_child(_make_vital_hint("status/hp", "몸", status.hp, Color(0.70, 0.26, 0.24)))
	grid.add_child(_make_vital_hint("status/stamina", "숨", status.stamina, Color(0.82, 0.62, 0.28)))
	grid.add_child(_make_vital_hint("status/hunger", "허기", status.hunger, Color(0.74, 0.45, 0.20)))
	grid.add_child(_make_vital_hint("status/thirst", "수분", status.thirst, Color(0.28, 0.56, 0.78)))
	return grid


func _make_survival_meter(icon_id: String, label_text: String, value: int, color: Color) -> PanelContainer:
	var safe_value := clampi(value, 0, 100)
	var severity_color := _survival_meter_color(safe_value, color)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 46)
	panel.tooltip_text = "%s %d/100 - %s" % [label_text, safe_value, _survival_warning_text(safe_value)]
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.048, 0.88), severity_color.darkened(0.12), 4))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	margin.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 2)
	row.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 3)
	box.add_child(header)

	var name_label := Label.new()
	name_label.text = label_text
	name_label.add_theme_font_size_override("font_size", 9)
	name_label.add_theme_color_override("font_color", Color(0.84, 0.89, 0.85))
	header.add_child(name_label)

	var number_label := Label.new()
	number_label.text = "%d" % safe_value
	number_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	number_label.add_theme_font_size_override("font_size", 10)
	number_label.add_theme_color_override("font_color", severity_color.lightened(0.26))
	header.add_child(number_label)

	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 7)
	bar.max_value = 100
	bar.value = safe_value
	bar.show_percentage = false
	bar.add_theme_stylebox_override("background", _make_panel_style(Color(0.015, 0.022, 0.022, 0.92), Color(0.02, 0.03, 0.03, 0.0), 3))
	bar.add_theme_stylebox_override("fill", _make_panel_style(severity_color, severity_color.lightened(0.10), 3))
	box.add_child(bar)
	return panel


func _survival_meter_color(value: int, base_color: Color) -> Color:
	if value <= 20:
		return Color(0.95, 0.20, 0.16)
	if value <= 40:
		return Color(0.95, 0.58, 0.20)
	return base_color


func _survival_warning_text(value: int) -> String:
	if value <= 20:
		return "위험"
	if value <= 40:
		return "주의"
	if value <= 70:
		return "보통"
	return "안정"


func _make_vital_hint_row(status) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	row.add_child(_make_vital_hint("status/hp", "몸", status.hp, Color(0.70, 0.26, 0.24)))
	row.add_child(_make_vital_hint("status/stamina", "숨", status.stamina, Color(0.82, 0.62, 0.28)))
	return row


func _make_vital_hint(icon_id: String, label_text: String, value: int, color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.tooltip_text = "%s %d/100" % [label_text, value]
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.050, 0.048, 0.82), Color(0.18, 0.24, 0.22), 4))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 3)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 3)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	margin.add_child(row)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(14, 14)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	row.add_child(icon)
	var label := Label.new()
	label.text = "%s %s" % [label_text, _value_band(value)]
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", color.lightened(0.30))
	row.add_child(label)
	return panel


func _make_relationship_hint(status) -> Label:
	var label := _create_body_label()
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.86, 0.82, 0.66))
	label.text = _relationship_cue_text(status)
	return label


func _relationship_cue_text(status) -> String:
	if status == CharacterManager.partner_status and CharacterManager.partner_joined:
		return CharacterManager.get_relationship_cue_text()
	if status.trust >= 75 and status.mood >= 55:
		return "작게 고개를 끄덕이며 먼저 움직이려 한다."
	if status.trust <= 35:
		return "대답이 조금 늦고 시선을 자주 피한다."
	if status.mood <= 35:
		return "말은 하지만 목소리에 힘이 없다."
	return "부르면 바로 돌아보고 다음 행동을 기다린다."


func _value_band(value: int) -> String:
	if value >= 75:
		return "좋음"
	if value >= 45:
		return "보통"
	if value >= 25:
		return "낮음"
	return "위험"


func _living_status_color(status) -> Color:
	if status == null:
		return Color(0.80, 0.84, 0.80)
	if status.hp <= 30 or status.stamina <= 25 or status.hunger <= 25 or status.thirst <= 25:
		return Color(0.96, 0.70, 0.50)
	if status.mood <= 35:
		return Color(0.86, 0.72, 0.94)
	return Color(0.86, 0.90, 0.78)


func _state_living_text(state_id: String) -> String:
	match state_id:
		"fatigue":
			return "지침"
		"fear":
			return "두려움"
		"loneliness":
			return "외로움"
		"wet":
			return "젖음"
		"wound":
			return "상처"
		"anxiety":
			return "불안함"
		"poor_hygiene":
			return "불쾌함"
		"hunger_risk":
			return "허기 위험"
		"thirst_risk":
			return "탈수 위험"
		"infection_risk":
			return "감염 위험"
	return _state_display_name(state_id)


func _state_living_color(state_id: String) -> Color:
	match state_id:
		"fear", "anxiety":
			return Color(0.60, 0.38, 0.68)
		"wet":
			return Color(0.34, 0.56, 0.72)
		"wound":
			return Color(0.72, 0.28, 0.24)
		"infection_risk":
			return Color(0.76, 0.36, 0.28)
		"hunger_risk":
			return Color(0.70, 0.46, 0.24)
		"thirst_risk":
			return Color(0.26, 0.50, 0.74)
		"loneliness":
			return Color(0.44, 0.50, 0.68)
		"poor_hygiene":
			return Color(0.42, 0.56, 0.48)
	return Color(0.70, 0.50, 0.30)


func _character_expression_text(status, active: bool, is_partner: bool) -> String:
	if not active:
		return "아직 곁에 없다"
	if status == null:
		return "표정을 읽기 어렵다"
	if status.hp <= 30:
		return "창백한 얼굴"
	if status.stamina <= 25:
		return "눈꺼풀이 무거움"
	if status.hunger <= 25:
		return "허기를 참고 있음"
	if status.thirst <= 25:
		return "목이 말라 보임"
	if status.mood <= 35:
		return "불안한 표정"
	if is_partner and status.trust >= 70:
		return "믿고 있다는 눈빛"
	if status.mood >= 75:
		return "조금 편안함"
	return "긴장을 유지함"


func _character_expression_tint(status, active: bool) -> Color:
	if not active:
		return Color(0.0, 0.0, 0.0, 0.24)
	if status == null:
		return Color(0.0, 0.0, 0.0, 0.0)
	if status.hp <= 30:
		return Color(0.36, 0.06, 0.05, 0.24)
	if status.stamina <= 25:
		return Color(0.35, 0.24, 0.08, 0.18)
	if status.mood <= 35:
		return Color(0.18, 0.08, 0.32, 0.20)
	if status.mood >= 75:
		return Color(0.20, 0.28, 0.10, 0.10)
	return Color(0.0, 0.0, 0.0, 0.0)


func _character_glow_modulate(status, active: bool) -> Color:
	if not active:
		return Color(0.56, 0.62, 0.66, 0.18)
	if status == null:
		return Color(1.0, 0.92, 0.74, 0.54)
	if status.hp <= 30 or status.has_state("wound"):
		return Color(1.0, 0.42, 0.34, 0.58)
	if status.thirst <= 25 or status.has_state("wet"):
		return Color(0.54, 0.76, 1.0, 0.48)
	if status.stamina <= 25 or status.has_state("fatigue"):
		return Color(0.94, 0.70, 0.38, 0.52)
	if status.mood <= 35 or status.has_state("fear") or status.has_state("anxiety"):
		return Color(0.70, 0.50, 1.0, 0.48)
	if status.mood >= 75:
		return Color(0.86, 1.0, 0.58, 0.48)
	return Color(1.0, 0.92, 0.74, 0.54)


func _character_expression_panel_color(status, active: bool) -> Color:
	if not active:
		return Color(0.02, 0.03, 0.03, 0.72)
	if status == null:
		return Color(0.03, 0.04, 0.04, 0.72)
	return _living_status_color(status).darkened(0.48)


func _character_expression_border_color(status, active: bool) -> Color:
	if not active or status == null:
		return Color(0.30, 0.34, 0.32, 0.55)
	return _living_status_color(status)


func _add_meter(parent: VBoxContainer, label_text: String, value: int, color: Color) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	parent.add_child(row)

	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var icon_texture = _icon_texture(_status_icon_id(label_text))
	if icon_texture != null:
		icon.texture = icon_texture
	row.add_child(icon)

	var label := Label.new()
	label.custom_minimum_size = Vector2(34, 0)
	label.text = label_text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.82, 0.88, 0.86))
	row.add_child(label)

	var bar := ProgressBar.new()
	bar.min_value = 0
	bar.max_value = 100
	bar.value = clampi(value, 0, 100)
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 13)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_theme_stylebox_override("background", _make_panel_style(Color(0.04, 0.055, 0.055), Color(0.13, 0.16, 0.16), 3))
	bar.add_theme_stylebox_override("fill", _make_panel_style(color, color, 3))
	row.add_child(bar)

	var value_label := Label.new()
	value_label.custom_minimum_size = Vector2(28, 0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.text = str(clampi(value, 0, 100))
	value_label.add_theme_font_size_override("font_size", 12)
	value_label.add_theme_color_override("font_color", Color(0.82, 0.88, 0.86))
	row.add_child(value_label)


func _make_state_row(states: Array) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	var title := Label.new()
	title.text = "상태"
	title.custom_minimum_size = Vector2(38, 0)
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(0.82, 0.88, 0.86))
	row.add_child(title)
	if states.is_empty():
		var label := _create_body_label()
		label.text = "없음"
		label.add_theme_font_size_override("font_size", 12)
		row.add_child(label)
		return row
	for raw_state in states:
		var state_id := String(raw_state)
		var icon := TextureRect.new()
		icon.custom_minimum_size = Vector2(18, 18)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var texture = _icon_texture(_state_icon_id(state_id))
		if texture != null:
			icon.texture = texture
		icon.tooltip_text = _state_display_name(state_id)
		row.add_child(icon)
	return row


func _make_tool_menu_button(label_text: String, tooltip: String, icon_id: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = TOOL_MENU_BUTTON_SIZE
	button.tooltip_text = tooltip
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.pressed.connect(callback)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.045, 0.062, 0.056, 0.92), Color(0.36, 0.46, 0.40, 0.76), 6))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.075, 0.105, 0.090, 0.96), Color(0.92, 0.78, 0.36, 0.94), 6))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.86, 0.72, 0.34, 0.96), Color(1.0, 0.88, 0.48, 1.0), 6))
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	button.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 1)
	margin.add_child(box)

	var icon := TextureRect.new()
	icon.name = "MenuIcon"
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(TOOL_MENU_BUTTON_ICON_SIZE, TOOL_MENU_BUTTON_ICON_SIZE)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _icon_texture(icon_id)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)

	var label := Label.new()
	label.name = "MenuLabel"
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.custom_minimum_size = Vector2(46, 14)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.96, 0.92, 0.72))
	_prepare_single_line_label(label, 46)
	box.add_child(label)
	button.mouse_entered.connect(Callable(self, "_on_tool_menu_button_hovered").bind(button, true))
	button.mouse_exited.connect(Callable(self, "_on_tool_menu_button_hovered").bind(button, false))
	return button


func _on_tool_menu_button_hovered(button: Button, hovered: bool) -> void:
	if button == null or not is_instance_valid(button):
		return
	var icon = button.get_node_or_null("MarginContainer/VBoxContainer/MenuIcon")
	var label = button.get_node_or_null("MarginContainer/VBoxContainer/MenuLabel")
	var existing = button.get_meta("tool_menu_hover_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	var tween := create_tween()
	button.set_meta("tool_menu_hover_tween", tween)
	tween.set_parallel(true)
	if icon != null:
		var icon_control := icon as Control
		icon_control.pivot_offset = Vector2(TOOL_MENU_BUTTON_ICON_SIZE, TOOL_MENU_BUTTON_ICON_SIZE) * 0.5
		tween.tween_property(icon_control, "scale", Vector2(1.14, 1.14) if hovered else Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK if hovered else Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(icon_control, "position:y", -2.0 if hovered else 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(icon_control, "modulate", Color(1.08, 1.03, 0.82, 1.0) if hovered else Color.WHITE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if label != null:
		var label_control := label as Control
		tween.tween_property(label_control, "modulate", Color(1.0, 0.88, 0.48, 1.0) if hovered else Color.WHITE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _set_button_reaction_mode(button: Button, mode: String) -> void:
	if button == null:
		return
	button.set_meta("button_reaction_mode", mode)
	_ensure_button_hover_highlight(button, _button_reaction_highlight_radius(mode), _button_reaction_highlight_width(mode))


func _bind_button_reaction(button: Button, mode: String = "button") -> void:
	if button == null:
		return
	button.set_meta("button_reaction_mode", mode)
	_ensure_button_hover_highlight(button, _button_reaction_highlight_radius(mode), _button_reaction_highlight_width(mode))
	if button.has_meta("button_reaction_bound"):
		return
	button.set_meta("button_reaction_bound", true)
	button.set_meta("button_reaction_hovered", false)
	button.set_meta("button_reaction_pressed", false)
	button.mouse_entered.connect(Callable(self, "_on_button_reaction_hovered").bind(button, true))
	button.mouse_exited.connect(Callable(self, "_on_button_reaction_hovered").bind(button, false))
	button.button_down.connect(Callable(self, "_on_button_reaction_pressed").bind(button, true))
	button.button_up.connect(Callable(self, "_on_button_reaction_pressed").bind(button, false))


func _on_button_reaction_hovered(button: Button, hovered: bool) -> void:
	if button == null or not is_instance_valid(button):
		return
	button.set_meta("button_reaction_hovered", hovered)
	_animate_button_reaction(button)


func _on_button_reaction_pressed(button: Button, pressed: bool) -> void:
	if button == null or not is_instance_valid(button):
		return
	button.set_meta("button_reaction_pressed", pressed)
	_animate_button_reaction(button)


func _animate_button_reaction(button: Button) -> void:
	if button == null or not is_instance_valid(button):
		return
	var existing = button.get_meta("button_reaction_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	var mode := String(button.get_meta("button_reaction_mode", "button"))
	var hovered := bool(button.get_meta("button_reaction_hovered", false))
	var pressed := bool(button.get_meta("button_reaction_pressed", false))
	var target_scale := Vector2.ONE
	var target_modulate := Color.WHITE
	var highlight_alpha := 0.0
	if not button.disabled:
		if pressed:
			target_scale = _button_reaction_press_scale(mode)
			target_modulate = Color(1.10, 1.04, 0.82, 1.0)
			highlight_alpha = _button_reaction_highlight_alpha(mode, true)
		elif hovered:
			target_scale = _button_reaction_hover_scale(mode)
			target_modulate = Color(1.06, 1.03, 0.90, 1.0)
			highlight_alpha = _button_reaction_highlight_alpha(mode, false)
	button.pivot_offset = button.size * 0.5
	var highlight = button.get_node_or_null("HoverHighlight")
	var tween := create_tween()
	button.set_meta("button_reaction_tween", tween)
	tween.set_parallel(true)
	tween.tween_property(button, "scale", target_scale, 0.085 if pressed else 0.13).set_trans(Tween.TRANS_SINE if pressed else Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "modulate", target_modulate, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if highlight != null:
		tween.tween_property(highlight, "modulate:a", highlight_alpha, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _ensure_button_hover_highlight(button: Button, radius: int = 6, border_width: int = 1) -> PanelContainer:
	var highlight = button.get_node_or_null("HoverHighlight")
	if highlight == null:
		highlight = PanelContainer.new()
		highlight.name = "HoverHighlight"
		highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
		highlight.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		highlight.modulate = Color(1, 1, 1, 0)
		button.add_child(highlight)
	var panel := highlight as PanelContainer
	panel.add_theme_stylebox_override("panel", _make_button_hover_highlight_style(radius, border_width))
	return panel


func _make_button_hover_highlight_style(radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.86, 0.34, 0.055)
	style.border_color = Color(1.0, 0.86, 0.34, 0.92)
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	return style


func _button_reaction_hover_scale(mode: String) -> Vector2:
	match mode:
		"icon":
			return Vector2(1.045, 1.045)
		"tab":
			return Vector2(1.030, 1.030)
		"choice":
			return Vector2(1.018, 1.018)
		"compact":
			return Vector2(1.020, 1.020)
	return Vector2(1.018, 1.018)


func _button_reaction_press_scale(mode: String) -> Vector2:
	match mode:
		"icon":
			return Vector2(0.94, 0.94)
		"tab":
			return Vector2(0.965, 0.965)
		"choice":
			return Vector2(0.970, 0.970)
		"compact":
			return Vector2(0.970, 0.970)
	return Vector2(0.975, 0.975)


func _button_reaction_highlight_radius(mode: String) -> int:
	match mode:
		"icon":
			return 5
		"tab":
			return 5
		"choice":
			return 7
		"compact":
			return 5
	return 6


func _button_reaction_highlight_width(mode: String) -> int:
	match mode:
		"choice":
			return 2
	return 1


func _button_reaction_highlight_alpha(mode: String, pressed: bool) -> float:
	if pressed:
		return 0.48 if mode == "choice" else 0.40
	match mode:
		"tab":
			return 0.30
		"choice":
			return 0.34
		"icon":
			return 0.26
		"compact":
			return 0.24
	return 0.26


func _bind_context_button_reaction(button: Button) -> void:
	if button == null or button.has_meta("context_button_reaction_bound"):
		return
	_ensure_button_hover_highlight(button, 16, 1)
	button.set_meta("context_button_reaction_bound", true)
	button.set_meta("context_button_hovered", false)
	button.set_meta("context_button_pressed", false)
	button.mouse_entered.connect(Callable(self, "_on_context_button_reaction_hovered").bind(button, true))
	button.mouse_exited.connect(Callable(self, "_on_context_button_reaction_hovered").bind(button, false))
	button.button_down.connect(Callable(self, "_on_context_button_reaction_pressed").bind(button, true))
	button.button_up.connect(Callable(self, "_on_context_button_reaction_pressed").bind(button, false))


func _on_context_button_reaction_hovered(button: Button, hovered: bool) -> void:
	if button == null or not is_instance_valid(button):
		return
	button.set_meta("context_button_hovered", hovered)
	_animate_context_button_reaction(button)


func _on_context_button_reaction_pressed(button: Button, pressed: bool) -> void:
	if button == null or not is_instance_valid(button):
		return
	button.set_meta("context_button_pressed", pressed)
	_animate_context_button_reaction(button)


func _animate_context_button_reaction(button: Button) -> void:
	if button == null or not is_instance_valid(button):
		return
	var content = button.get_node_or_null("Content")
	var icon = button.get_node_or_null("Content/ActionIcon")
	var title = button.get_node_or_null("Content/TextBox/Title")
	var detail = button.get_node_or_null("Content/TextBox/Detail")
	var description = button.get_node_or_null("Content/TextBox/Description")
	var highlight = button.get_node_or_null("HoverHighlight")
	var existing = button.get_meta("context_button_reaction_tween", null)
	if existing is Tween and existing.is_valid():
		existing.kill()
	var hovered := bool(button.get_meta("context_button_hovered", false))
	var pressed := bool(button.get_meta("context_button_pressed", false))
	var tint := Color.WHITE
	var icon_scale := Vector2.ONE
	var text_tint := Color.WHITE
	var highlight_alpha := 0.0
	if not button.disabled:
		if pressed:
			tint = Color(1.08, 1.02, 0.78, 1.0)
			icon_scale = Vector2(0.92, 0.92)
			text_tint = Color(1.0, 0.88, 0.48, 1.0)
			highlight_alpha = 0.42
		elif hovered:
			tint = Color(1.06, 1.04, 0.90, 1.0)
			icon_scale = Vector2(1.14, 1.14)
			text_tint = Color(1.0, 0.94, 0.64, 1.0)
			highlight_alpha = 0.28
	var tween := create_tween()
	button.set_meta("context_button_reaction_tween", tween)
	tween.set_parallel(true)
	if content != null:
		tween.tween_property(content, "modulate", tint, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if icon != null:
		var icon_control := icon as Control
		icon_control.pivot_offset = icon_control.size * 0.5
		tween.tween_property(icon_control, "scale", icon_scale, 0.12).set_trans(Tween.TRANS_BACK if hovered and not pressed else Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if title != null:
		tween.tween_property(title, "modulate", text_tint, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if detail != null:
		tween.tween_property(detail, "modulate", Color(1.0, 0.94, 0.72, 1.0) if hovered else Color.WHITE, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if description != null:
		tween.tween_property(description, "modulate", Color(1.0, 0.94, 0.72, 1.0) if hovered else Color.WHITE, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if highlight != null:
		tween.tween_property(highlight, "modulate:a", highlight_alpha, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _make_icon_button(tooltip: String, icon_id: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(TOOL_ICON_BUTTON_SIZE, TOOL_ICON_BUTTON_SIZE)
	button.tooltip_text = tooltip
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(callback)
	button.clip_text = true
	_limit_button_icon(button, DEFAULT_BUTTON_ICON_SIZE)
	var texture = _icon_texture(icon_id)
	if texture != null:
		button.icon = texture
		button.expand_icon = true
	_bind_button_reaction(button, "icon")
	return button


func _make_button(text: String, callback: Callable, icon_id: String = "") -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	button.focus_mode = Control.FOCUS_NONE
	_prepare_button_text(button, 88)
	_limit_button_icon(button, DEFAULT_BUTTON_ICON_SIZE)
	if icon_id != "":
		var texture = _icon_texture(icon_id)
		if texture != null:
			button.icon = texture
			button.expand_icon = false
	_bind_button_reaction(button, "button")
	return button


func _make_compact_button(text: String, callback: Callable, icon_id: String = "", min_size: Vector2 = Vector2(58, 22)) -> Button:
	var button := _make_button(text, callback, icon_id)
	_set_button_reaction_mode(button, "compact")
	button.custom_minimum_size = min_size
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_constant_override("h_separation", 3)
	_limit_button_icon(button, COMPACT_BUTTON_ICON_SIZE)
	return button


func _limit_button_icon(button: Button, max_width: int) -> void:
	button.add_theme_constant_override("icon_max_width", max_width)


func _make_context_button(text: String, callback: Callable, icon_id: String = "") -> Button:
	var button := Button.new()
	button.text = ""
	if callback.is_valid():
		button.pressed.connect(callback)
	button.custom_minimum_size = Vector2(82, 44)
	button.clip_text = true
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_color_override("font_color", Color(0.95, 0.92, 0.78))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.78))
	button.add_theme_color_override("font_pressed_color", Color(0.08, 0.10, 0.08))
	button.add_theme_color_override("font_disabled_color", Color(0.56, 0.60, 0.55))
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.055, 0.075, 0.065, 0.94), Color(0.64, 0.58, 0.34), 16))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.10, 0.14, 0.11, 0.98), Color(0.95, 0.78, 0.36), 16))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.92, 0.78, 0.40), Color(0.98, 0.90, 0.52), 16))
	button.add_theme_stylebox_override("disabled", _make_panel_style(Color(0.045, 0.055, 0.050, 0.78), Color(0.18, 0.20, 0.18), 16))
	button.tooltip_text = text
	button.set_meta("context_text", text)

	var content := HBoxContainer.new()
	content.name = "Content"
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.offset_left = 7
	content.offset_top = 5
	content.offset_right = -7
	content.offset_bottom = -5
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 3)
	button.add_child(content)

	var texture = _icon_texture(icon_id)
	if texture != null:
		var icon := TextureRect.new()
		icon.name = "ActionIcon"
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.custom_minimum_size = Vector2(18, 18)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = texture
		content.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.name = "TextBox"
	text_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.alignment = BoxContainer.ALIGNMENT_CENTER
	text_box.add_theme_constant_override("separation", 0)
	content.add_child(text_box)

	var title_label := Label.new()
	title_label.name = "Title"
	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_label.text = text
	title_label.clip_text = true
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 11)
	title_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.70))
	_prepare_single_line_label(title_label, 36)
	text_box.add_child(title_label)

	var detail_label := Label.new()
	detail_label.name = "Detail"
	detail_label.visible = false
	detail_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_label.text = ""
	detail_label.clip_text = true
	detail_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	detail_label.add_theme_font_size_override("font_size", 9)
	detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.74))
	_prepare_single_line_label(detail_label, 36)
	text_box.add_child(detail_label)

	var desc_label := Label.new()
	desc_label.name = "Description"
	desc_label.visible = false
	desc_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	desc_label.text = ""
	desc_label.clip_text = true
	desc_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	desc_label.add_theme_font_size_override("font_size", 9)
	desc_label.add_theme_color_override("font_color", Color(0.82, 0.83, 0.76))
	_prepare_single_line_label(desc_label, 36)
	text_box.add_child(desc_label)
	_bind_context_button_reaction(button)
	return button


func _make_item_chip(display_name: String, amount: int, icon_path: String, compact: bool = false) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22) if compact else Vector2(26, 26)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if icon_path != "" and ResourceLoader.exists(icon_path):
		icon.texture = load(icon_path)
	row.add_child(icon)
	var label := Label.new()
	label.text = "%s %d" % [display_name, amount]
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.custom_minimum_size = Vector2(88, 0) if compact else Vector2(130, 0)
	label.add_theme_font_size_override("font_size", 11 if compact else 12)
	label.add_theme_color_override("font_color", Color(0.84, 0.90, 0.86))
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if not compact:
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	return row


func _make_item_card(item_id: String, amount: int, target_id: String = "player", compact: bool = true, owner_id: String = "player") -> Button:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var button = DRAGGABLE_ITEM_CARD_SCRIPT.new()
	button.setup_drag("inventory", item_id, amount, WorldManager.current_tile_id, display_name, icon_path, owner_id)
	button.text = ""
	button.custom_minimum_size = Vector2(52, 64) if compact else Vector2(76, 66)
	button.focus_mode = Control.FOCUS_NONE
	var sensory_hint := _item_sensory_hint(item)
	var stack_weight := InventoryManager.get_stack_weight(item_id, amount)
	button.tooltip_text = "%s x%d\n%s 소지 / 무게 %.1f\n%s\n%s\n드래그하면 필드나 상대 소지품으로 옮긴다." % [display_name, amount, InventoryManager.get_owner_display_name(owner_id), stack_weight, _item_card_status_text(item, owner_id), sensory_hint]
	button.pressed.connect(Callable(self, "_on_item_card_pressed").bind(item_id, target_id, owner_id))
	button.mouse_entered.connect(Callable(self, "_on_item_card_mouse_entered").bind(button))
	button.mouse_exited.connect(Callable(self, "_on_item_card_mouse_exited").bind(button))
	button.disabled = (target_id == "partner" or owner_id == "partner") and not InventoryManager.can_access_partner_inventory()
	if target_id != owner_id and owner_id != "player":
		button.setup_drag("", "", 0, "", "", "")
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.075, 0.095, 0.088), Color(0.24, 0.32, 0.29), 5))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.11, 0.145, 0.13), Color(0.88, 0.76, 0.38), 5))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.90, 0.76, 0.38), Color(0.98, 0.90, 0.52), 5))

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 4)
	button.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 2)
	margin.add_child(box)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(24, 24) if compact else Vector2(26, 26)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)

	var name_label := Label.new()
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label.text = display_name
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 9 if compact else 10)
	name_label.add_theme_color_override("font_color", Color(0.93, 0.90, 0.76))
	box.add_child(name_label)

	var status_label := Label.new()
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_label.text = InventoryManager.get_tool_condition_text(item_id, owner_id) if item != null and _is_tool_like_item(item) else "x%d · %.1f" % [amount, stack_weight]
	status_label.clip_text = true
	status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 8)
	status_label.add_theme_color_override("font_color", Color(0.70, 0.80, 0.74))
	box.add_child(status_label)
	return button


func _on_item_card_mouse_entered(button: Button) -> void:
	if button == null or button.disabled:
		return
	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.04, 1.04), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_item_card_mouse_exited(button: Button) -> void:
	if button == null:
		return
	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _item_short_sense(item) -> String:
	if item == null:
		return "?"
	if item.effects.has("thirst") and not item.effects.has("hunger"):
		return "목"
	if item.effects.has("hunger"):
		return "배"
	if item.effects.has("hygiene"):
		return "씻김"
	if item.tags.has("placeable"):
		return "자리"
	if _is_tool_like_item(item):
		return "손맛"
	return _item_card_status_text(item)


func _item_sensory_hint(item) -> String:
	if item == null:
		return "손에 잡히는 감각이 희미하다."
	if item.tags.has("guide"):
		return "다음 행동을 잊지 않게 붙잡아 주는 얇은 책이다."
	if item.effects.has("thirst") and not item.effects.has("hunger"):
		return "마시면 목의 건조함이 조금 풀린다."
	if item.effects.has("hunger"):
		return "먹으면 빈속이 잠깐 따뜻해진다."
	if item.effects.has("hygiene"):
		return "몸에 남은 땀과 모래를 씻어낼 수 있다."
	if item.tags.has("placeable"):
		return "거점에 놓으면 생활의 흔적이 남는다."
	if _is_tool_like_item(item):
		return "손에 쥐면 작업이 조금 덜 막막해진다. %s" % InventoryManager.get_tool_effect_summary(item.id)
	match String(item.category):
		"material":
			return "거칠고 가벼운 재료감이 손에 남는다."
		"food":
			return "먹을 수 있는 냄새가 희미하게 난다."
	return "섬에서 주워 온 물건의 무게가 느껴진다."


func _make_field_item_card(tile_id: String, item_id: String, amount: int) -> Button:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var button = DRAGGABLE_ITEM_CARD_SCRIPT.new()
	button.setup_drag("field", item_id, amount, tile_id, display_name, icon_path)
	button.text = ""
	button.custom_minimum_size = BOTTOM_FIELD_SLOT_SIZE
	button.focus_mode = Control.FOCUS_NONE
	button.tooltip_text = "%s x%d\n이 타일에 내려놓은 물건\n클릭하거나 소지품 영역으로 드래그하면 줍는다." % [display_name, amount]
	button.disabled = tile_id != WorldManager.current_tile_id
	button.pressed.connect(Callable(self, "_on_pickup_field_item_pressed").bind(tile_id, item_id, -1))
	button.mouse_entered.connect(Callable(self, "_on_item_card_mouse_entered").bind(button))
	button.mouse_exited.connect(Callable(self, "_on_item_card_mouse_exited").bind(button))
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.095, 0.082, 0.048), Color(0.76, 0.60, 0.28), 5))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.13, 0.11, 0.065), Color(0.96, 0.78, 0.34), 5))
	button.add_theme_stylebox_override("disabled", _make_panel_style(Color(0.055, 0.060, 0.055), Color(0.22, 0.24, 0.22), 5))
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 2)
	button.add_child(box)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(26, 26)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)
	var name_label := Label.new()
	name_label.text = display_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.add_theme_font_size_override("font_size", 11)
	name_label.add_theme_color_override("font_color", Color(0.96, 0.89, 0.66))
	_prepare_single_line_label(name_label, 52)
	box.add_child(name_label)
	var status_label := Label.new()
	status_label.text = "바닥 x%d" % amount
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 9)
	status_label.add_theme_color_override("font_color", Color(0.88, 0.76, 0.46))
	_prepare_single_line_label(status_label, 48)
	box.add_child(status_label)
	return button


func _make_base_storage_item_card(item_id: String, amount: int) -> Button:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var button = DRAGGABLE_ITEM_CARD_SCRIPT.new()
	button.setup_drag("base_storage", item_id, amount, WorldManager.current_tile_id, display_name, icon_path)
	button.text = ""
	button.custom_minimum_size = Vector2(66, 48)
	button.focus_mode = Control.FOCUS_NONE
	button.tooltip_text = "%s x%d\n거점에 내려놓은 물건\n인벤토리 영역으로 드래그하면 꺼낸다." % [display_name, amount]
	button.mouse_entered.connect(Callable(self, "_on_item_card_mouse_entered").bind(button))
	button.mouse_exited.connect(Callable(self, "_on_item_card_mouse_exited").bind(button))
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.080, 0.072, 0.050), Color(0.70, 0.58, 0.30), 5))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.12, 0.105, 0.065), Color(0.96, 0.78, 0.34), 5))
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 1)
	button.add_child(box)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)
	var count_label := Label.new()
	count_label.text = "x%d" % amount
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count_label.add_theme_font_size_override("font_size", 9)
	count_label.add_theme_color_override("font_color", Color(0.94, 0.86, 0.62))
	box.add_child(count_label)
	return button


func _make_resource_card(item_id: String, amount: int) -> PanelContainer:
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	var icon_path := ""
	if item != null:
		display_name = item.display_name
		icon_path = item.icon_path
	var panel := PanelContainer.new()
	panel.custom_minimum_size = BOTTOM_FIELD_SLOT_SIZE
	panel.tooltip_text = "현재 타일에서 확인된 자원"
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.055, 0.078, 0.070), Color(0.22, 0.32, 0.26), 5))
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 2)
	panel.add_child(box)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(26, 26)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var texture = _texture_from_path(icon_path)
	if texture != null:
		icon.texture = texture
	box.add_child(icon)
	var name_label := Label.new()
	name_label.text = display_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.add_theme_font_size_override("font_size", 11)
	name_label.add_theme_color_override("font_color", Color(0.88, 0.93, 0.82))
	_prepare_single_line_label(name_label, 52)
	box.add_child(name_label)
	var status_label := Label.new()
	status_label.text = "필드 · %s" % _amount_band(amount)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 9)
	status_label.add_theme_color_override("font_color", Color(0.70, 0.82, 0.70))
	_prepare_single_line_label(status_label, 48)
	box.add_child(status_label)
	return panel


func _on_item_card_pressed(item_id: String, target_id: String, owner_id: String = "player") -> void:
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		_append_log("알 수 없는 아이템이다.")
		return
	if owner_id == "partner" and not InventoryManager.can_access_partner_inventory():
		_append_log("파트너가 같은 타일에 없어 소지품을 확인할 수 없다.")
		return
	if item.tags.has("guide"):
		_show_survival_guide()
		return
	if _item_is_directly_usable(item):
		_on_use_item_pressed(item_id, target_id, owner_id)
		return
	if item.tags.has("placeable") and BaseManager.is_at_base():
		_toggle_tool_menu("base")
		return
	if _is_tool_like_item(item):
		_toggle_tool_menu("tools")
	else:
		_toggle_tool_menu("inventory")


func _on_drop_item_pressed(item_id: String, amount: int = 1, owner_id: String = "player") -> void:
	if owner_id == "partner" and not InventoryManager.can_access_partner_inventory():
		_append_log("파트너가 같은 타일에 없어 물건을 내려놓을 수 없다.")
		return
	var result := WorldManager.drop_item_on_current_tile(item_id, amount, owner_id)
	_append_log(String(result.get("text", "")))
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_sensory_toast("actions/place", "물건을 이곳에 내려두었다.", Color(0.80, 0.68, 0.34))


func _on_transfer_item_pressed(item_id: String, amount: int, from_owner: String, to_owner: String) -> void:
	if not InventoryManager.can_access_partner_inventory():
		_append_log("파트너가 같은 타일에 없어 소지품을 나눌 수 없다.")
		return
	var result := InventoryManager.transfer_item(item_id, amount, from_owner, to_owner)
	_append_log(String(result.get("text", "")))
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_sensory_toast("actions/assist", "짐을 나눠 들었다.", Color(0.72, 0.82, 0.46))


func _open_item_direct_action_menu(data: Dictionary, target_id: String, tile_id: String) -> void:
	var item_id := String(data.get("item_id", ""))
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		_show_sensory_toast("items/storage_box", "알 수 없는 물건이다.", Color(0.76, 0.52, 0.24))
		return
	var actions := _build_item_direct_actions(data, target_id, tile_id)
	if actions.is_empty():
		_show_sensory_toast("items/storage_box", "지금은 쓸 방법이 떠오르지 않는다.", Color(0.76, 0.52, 0.24))
		return
	_clear_children(item_action_buttons_box)
	item_action_title_label.text = "%s x%d" % [item.display_name, int(data.get("amount", 1))]
	item_action_body_label.text = _item_direct_action_target_text(target_id, tile_id, data)
	for action in actions:
		item_action_buttons_box.add_child(_make_item_direct_action_button(action, data, target_id, tile_id))
	item_action_panel.visible = true
	_fit_center_overlay(item_action_panel, ITEM_ACTION_DESIRED_SIZE)
	_raise_root_overlay(item_action_panel, Z_ROOT_MODAL + 1)


func _hide_item_action_panel() -> void:
	if item_action_panel != null:
		item_action_panel.visible = false


func _build_item_direct_actions(data: Dictionary, target_id: String, tile_id: String) -> Array[Dictionary]:
	var actions: Array[Dictionary] = []
	var source := String(data.get("source", ""))
	var item_id := String(data.get("item_id", ""))
	var source_owner := String(data.get("owner_id", "player"))
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		return actions
	if item.tags.has("guide"):
		actions.append({"id": "read", "label": "읽기", "icon": "actions/investigate", "enabled": true, "hint": "생존 가이드를 펼쳐 현재 목표를 확인한다."})
	if target_id == "field" or target_id == "base_direct":
		if _item_is_directly_usable(item):
			var use_target := source_owner
			actions.append({"id": "use", "label": _direct_use_label_for_item(item, use_target), "icon": _item_primary_icon(item, "items/berry"), "enabled": true, "target_owner": use_target, "hint": "%s에게 바로 사용한다." % InventoryManager.get_owner_display_name(use_target)})
		if item_id == "snare_trap":
			var can_set := source_owner == "player" and target_id == "field" and tile_id == WorldManager.current_tile_id and WorldManager.can_set_trap_on_tile(tile_id)
			actions.append({"id": "set_trap", "label": "덫 설치", "icon": "items/snare_trap", "enabled": can_set, "hint": "조사 완료된 동물 흔적 타일에 올가미를 숨긴다."})
		if BaseManager.is_at_base() and item.tags.has("placeable"):
			var can_place := source_owner == "player" and BaseManager.can_place_item(item_id)
			actions.append({"id": "place_base", "label": "거점 배치", "icon": "actions/place", "enabled": can_place, "hint": "동굴 거점에 설치해 생활 효과를 얻는다."})
		if BaseManager.is_at_base() and item_id == "raw_meat":
			var recipe = CraftingManager.get_recipe("cooked_meat")
			var can_cook := recipe != null and CraftingManager.is_recipe_unlocked("cooked_meat") and _can_attempt_recipe(recipe, false)
			actions.append({"id": "cook_meat", "label": "굽기", "icon": "items/cooked_meat", "enabled": can_cook, "hint": "모닥불에서 날고기를 굽는다."})
		if source == "inventory":
			actions.append({"id": "drop", "label": "내려놓기", "icon": "actions/place", "enabled": target_id == "field" and tile_id == WorldManager.current_tile_id, "hint": "현재 타일의 필드 물품으로 내려놓는다."})
	if target_id.begins_with("inventory_"):
		var target_owner := target_id.trim_prefix("inventory_")
		if source == "inventory" and source_owner != target_owner:
			actions.append({"id": "transfer", "label": "건네기", "icon": "actions/assist", "enabled": InventoryManager.can_access_partner_inventory(), "target_owner": target_owner, "hint": "%s에게 물건을 건넨다." % InventoryManager.get_owner_display_name(target_owner)})
			if _item_is_directly_usable(item):
				actions.append({"id": "use", "label": _direct_use_label_for_item(item, target_owner), "icon": _item_primary_icon(item, "items/berry"), "enabled": InventoryManager.can_access_partner_inventory(), "target_owner": target_owner, "hint": "%s에게 바로 사용한다." % InventoryManager.get_owner_display_name(target_owner)})
		elif source == "field":
			actions.append({"id": "pickup", "label": "줍기", "icon": "items/storage_box", "enabled": true, "target_owner": target_owner, "hint": "%s의 소지품으로 넣는다." % InventoryManager.get_owner_display_name(target_owner)})
	return actions


func _make_item_direct_action_button(action: Dictionary, data: Dictionary, target_id: String, tile_id: String) -> Button:
	var label := String(action.get("label", "사용"))
	var icon_id := String(action.get("icon", "actions/place"))
	var button := _make_button(label, Callable(self, "_perform_item_direct_action").bind(String(action.get("id", "")), action, data, target_id, tile_id), icon_id)
	button.disabled = not bool(action.get("enabled", true))
	button.tooltip_text = String(action.get("hint", label))
	button.custom_minimum_size = Vector2(0, 34)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return button


func _perform_item_direct_action(action_id: String, action: Dictionary, data: Dictionary, target_id: String, tile_id: String) -> void:
	_hide_item_action_panel()
	var item_id := String(data.get("item_id", ""))
	var amount := maxi(1, int(data.get("amount", 1)))
	var source_owner := String(data.get("owner_id", "player"))
	match action_id:
		"read":
			_show_survival_guide()
		"use":
			_on_use_item_pressed(item_id, String(action.get("target_owner", source_owner)), source_owner)
		"drop":
			_on_drop_item_pressed(item_id, amount, source_owner)
		"transfer":
			_on_transfer_item_pressed(item_id, amount, source_owner, String(action.get("target_owner", "partner")))
		"pickup":
			_on_pickup_field_item_pressed(String(data.get("tile_id", tile_id)), item_id, amount, String(action.get("target_owner", "player")))
		"set_trap":
			_perform_tile_action("set_trap", {})
		"place_base":
			_on_place_item_pressed(item_id)
		"cook_meat":
			_complete_craft("cooked_meat", false)
		_:
			_show_sensory_toast("items/storage_box", "지금은 쓸 방법이 떠오르지 않는다.", Color(0.76, 0.52, 0.24))


func _item_direct_action_target_text(target_id: String, tile_id: String, data: Dictionary) -> String:
	var item_name := String(data.get("display_name", data.get("item_id", "")))
	if target_id == "base_direct":
		return "%s을/를 거점에서 어떻게 쓸지 고른다." % item_name
	if target_id == "field":
		return "%s에 %s을/를 어떻게 쓸지 고른다." % [_tile_label(tile_id), item_name]
	if target_id.begins_with("inventory_"):
		var target_owner := target_id.trim_prefix("inventory_")
		return "%s에게 %s을/를 어떻게 넘길지 고른다." % [InventoryManager.get_owner_display_name(target_owner), item_name]
	return "%s을/를 어떻게 쓸지 고른다." % item_name


func _direct_use_label_for_item(item, target_owner: String) -> String:
	if item == null:
		return "사용"
	var target_label := "파트너" if target_owner == "partner" else "사용"
	if item.effects.has("thirst") and not item.effects.has("hunger"):
		return "마시기" if target_owner == "player" else "마시게 하기"
	if item.effects.has("hunger"):
		return "먹기" if target_owner == "player" else "먹이기"
	return target_label


func _item_primary_icon(item, fallback: String) -> String:
	if item != null and String(item.icon_path) != "":
		return String(item.icon_path)
	return fallback


func _on_item_drop_requested(data: Dictionary, target_id: String, tile_id: String) -> void:
	var source := String(data.get("source", ""))
	var item_id := String(data.get("item_id", ""))
	var amount := maxi(1, int(data.get("amount", 1)))
	var source_owner := String(data.get("owner_id", "player"))
	if item_id == "":
		return
	var start_position := _item_drag_global_to_root(data.get("drag_global_position", Vector2.ZERO))
	var end_position := _item_drag_global_to_root(data.get("drop_global_position", Vector2.ZERO))
	if target_id == "field" and source == "inventory":
		if tile_id != WorldManager.current_tile_id:
			_show_sensory_toast("actions/place", "현재 서 있는 타일에만 내려놓을 수 있다.", Color(0.86, 0.36, 0.24))
			return
		var drop_result := WorldManager.drop_item_on_current_tile(item_id, amount, source_owner)
		_finish_direct_item_move(drop_result, item_id, amount, start_position, end_position, "actions/place")
		return
	if target_id == "base_direct" and source == "inventory":
		if not BaseManager.is_at_base():
			_show_sensory_toast("actions/place", "거점 안에서만 사용할 수 있다.", Color(0.86, 0.36, 0.24))
			return
		var base_result := _move_inventory_item_to_base(item_id, amount, source_owner)
		_finish_direct_item_move(base_result, item_id, amount, start_position, end_position, "actions/place")
		return
	if target_id.begins_with("inventory_"):
		var target_owner := target_id.trim_prefix("inventory_")
		if target_owner == "partner" and not InventoryManager.can_access_partner_inventory():
			_show_sensory_toast("actions/assist", "파트너가 같은 타일에 있어야 나눌 수 있다.", Color(0.86, 0.36, 0.24))
			return
		if source == "field":
			var source_tile_id := String(data.get("tile_id", tile_id))
			var pickup_result := WorldManager.pick_up_field_item(source_tile_id, item_id, amount, target_owner)
			_finish_direct_item_move(pickup_result, item_id, amount, start_position, end_position, "items/storage_box")
			return
		if source == "base_storage":
			var take_result := BaseManager.take_stored_item(item_id, amount, target_owner)
			_finish_direct_item_move(take_result, item_id, amount, start_position, end_position, "items/storage_box")
			return
		if source == "inventory":
			if source_owner == target_owner:
				return
			var transfer_result := InventoryManager.transfer_item(item_id, amount, source_owner, target_owner)
			_finish_direct_item_move(transfer_result, item_id, amount, start_position, end_position, "actions/assist")
			return
	if target_id == "inventory" and source == "field":
		var source_tile_id := String(data.get("tile_id", tile_id))
		var field_pickup_result := WorldManager.pick_up_field_item(source_tile_id, item_id, amount, "player")
		_finish_direct_item_move(field_pickup_result, item_id, amount, start_position, end_position, "items/storage_box")
		return
	if target_id == "inventory" and source == "base_storage":
		var stored_pickup_result := BaseManager.take_stored_item(item_id, amount, "player")
		_finish_direct_item_move(stored_pickup_result, item_id, amount, start_position, end_position, "items/storage_box")
		return
	_show_sensory_toast("items/storage_box", "그 방향으로는 옮길 수 없다.", Color(0.76, 0.52, 0.24))


func _move_inventory_item_to_base(item_id: String, amount: int, owner_id: String) -> Dictionary:
	var item = InventoryManager.get_item_data(item_id)
	if item != null and item.tags.has("placeable"):
		if owner_id != "player":
			return {"ok": false, "text": "거점 배치는 플레이어가 들고 있는 물건만 바로 놓을 수 있다."}
		var placed_result := BaseManager.place_item(item_id)
		if bool(placed_result.get("ok", false)):
			placed_result["amount"] = 1
		return placed_result
	return BaseManager.store_item(item_id, amount, owner_id)


func _finish_direct_item_move(result: Dictionary, item_id: String, requested_amount: int, start_position: Vector2, end_position: Vector2, fallback_icon: String) -> void:
	var text := String(result.get("text", ""))
	if not bool(result.get("ok", false)):
		_show_item_move_failure(text if text != "" else "옮길 수 없다.", fallback_icon)
		return
	if text != "":
		_append_log(text)
	var moved_amount := requested_amount
	if result.has("amount"):
		moved_amount = maxi(1, int(result.get("amount", requested_amount)))
	elif result.has("items"):
		var items: Dictionary = result.get("items", {})
		moved_amount = maxi(1, int(items.get(item_id, requested_amount)))
	_refresh_all()
	_play_item_transfer_animation(item_id, moved_amount, start_position, end_position)


func _show_item_move_failure(text: String, icon_id: String) -> void:
	var message := text if text != "" else "옮길 수 없다."
	_append_log(message)
	_show_sensory_toast(icon_id, message, Color(0.86, 0.36, 0.24))


func _item_drag_global_to_root(value) -> Vector2:
	if value is Vector2:
		var global_position := value as Vector2
		if global_position != Vector2.ZERO:
			return get_global_transform().affine_inverse() * global_position
	return size * 0.5


func _on_pickup_field_item_pressed(tile_id: String, item_id: String, amount: int = -1, owner_id: String = "player") -> void:
	if owner_id == "partner" and not InventoryManager.can_access_partner_inventory():
		_append_log("파트너가 같은 타일에 없어 물건을 건넬 수 없다.")
		return
	var result := WorldManager.pick_up_field_item(tile_id, item_id, amount, owner_id)
	_append_log(String(result.get("text", "")))
	_refresh_all()
	if bool(result.get("ok", false)):
		_show_item_toast_from_result(result)
	else:
		_show_sensory_toast("items/storage_box", "짐이 너무 무겁다.", Color(0.86, 0.36, 0.24))


func _item_card_status_text(item, owner_id: String = "player") -> String:
	if item == null:
		return "미확인"
	if item.tags.has("guide"):
		return "읽기"
	if _item_is_directly_usable(item):
		if item.effects.has("thirst") and not item.effects.has("hunger"):
			return "마시기"
		if item.effects.has("hunger"):
			return "먹기"
		return "사용"
	if item.tags.has("placeable"):
		return "배치"
	if _is_tool_like_item(item):
		return InventoryManager.get_tool_condition_text(item.id, owner_id)
	match String(item.category):
		"food":
			return "식량"
		"consumable":
			return "소모품"
		"resource":
			return "재료"
		"component":
			return "부품"
		"facility":
			return "시설"
		"furniture":
			return "가구"
	return "소지품"


func _amount_band(amount: int) -> String:
	if amount <= 0:
		return "없음"
	if amount <= 2:
		return "적음"
	if amount <= 5:
		return "보통"
	if amount <= 10:
		return "많음"
	return "매우 많음"


func _make_overlay_content_panel(child: Control) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.02, 0.03, 0.03, 0.66), Color(0.84, 0.89, 0.78, 0.26), 5))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)
	margin.add_child(child)
	return panel


func _create_body_label() -> Label:
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(140, 0)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.set_meta("allow_multiline_text", true)
	label.add_theme_color_override("font_color", Color(0.86, 0.90, 0.88))
	return label


func _small_title(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.73))
	label.add_theme_font_size_override("font_size", 14)
	_prepare_single_line_label(label, 72)
	return label


func _prepare_single_line_label(label: Label, min_width: float = 0.0) -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	if min_width > 0.0:
		label.custom_minimum_size.x = maxf(label.custom_minimum_size.x, min_width)


func _prepare_button_text(button: Button, min_width: float = 0.0) -> void:
	button.clip_text = true
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if min_width > 0.0:
		button.custom_minimum_size.x = maxf(button.custom_minimum_size.x, min_width)


func _action_cost_text(cost: Dictionary) -> String:
	var time_cost := int(cost.get("time", 0))
	var stamina_cost := int(cost.get("stamina", 0))
	if time_cost == 0 and stamina_cost == 0:
		return ""
	var effective_stamina := CharacterManager.get_effective_stamina_cost_preview(stamina_cost, "player")
	if effective_stamina > stamina_cost:
		return "시간 %d분 / 기력 %d(+%d)" % [time_cost * GameState.MINUTES_PER_ACTION_SLOT, effective_stamina, effective_stamina - stamina_cost]
	return "시간 %d분 / 기력 %d" % [time_cost * GameState.MINUTES_PER_ACTION_SLOT, stamina_cost]


func _action_cost_brief(cost: Dictionary) -> String:
	var time_cost := int(cost.get("time", 0)) * GameState.MINUTES_PER_ACTION_SLOT
	var stamina_cost := int(cost.get("stamina", 0))
	if time_cost == 0 and stamina_cost == 0:
		return "즉시 / 부담 적음"
	if stamina_cost <= 0:
		return "시간 +%d분 / 쉼" % time_cost
	var effective_stamina := CharacterManager.get_effective_stamina_cost_preview(stamina_cost, "player")
	if effective_stamina > stamina_cost:
		return "시간 +%d분 / 기력 -%d(+%d)" % [time_cost, effective_stamina, effective_stamina - stamina_cost]
	return "시간 +%d분 / 기력 -%d" % [time_cost, stamina_cost]


func _action_life_description(action_id: String) -> String:
	match action_id:
		"move":
			return "둘러보며 길을 옮긴다"
		"investigate":
			return "주변을 자세히 살펴본다"
		"gather":
			return "쓸 만한 것을 주워 모은다"
		"fish":
			return "물가에 집중한다"
		"hunt":
			return "흔적을 따라가며 숨을 죽인다"
		"set_trap":
			return "짐승이 지나는 길목에 덫을 숨긴다"
		"check_trap":
			return "숨겨 둔 덫을 조심스럽게 확인한다"
		"develop":
			return "머물기 좋게 손본다"
		"wash":
			return "물과 천으로 땀과 오염을 닦아낸다"
		"rest":
			return "잠시 숨을 고른다"
		"enter_base":
			return "거점 안으로 들어간다"
		"sleep":
			return "몸을 눕힐 시간을 정한다"
	return "행동한다"


func _tile_context_action_label(action_id: String, tile_id: String) -> String:
	if action_id == "investigate" and WorldManager.is_tile_investigated(tile_id):
		return "정밀조사"
	if action_id == "set_trap":
		return "함정설치"
	if action_id == "check_trap":
		return "함정확인"
	return _action_display_name(action_id)


func _tile_action_life_description(action_id: String, tile_id: String) -> String:
	if action_id == "investigate" and WorldManager.is_tile_investigated(tile_id):
		return "남은 흔적을 더 살피고 숨은 채취 대상을 찾는다"
	return _action_life_description(action_id)


func _can_perform_action_with_tools(action_id: String) -> bool:
	if GameState.can_perform_action_now(action_id):
		return true
	if action_id == "investigate" and InventoryManager.has_usable_tool_with_effect("night_investigate"):
		return true
	return false


func _action_restriction_text_with_tools(action_id: String) -> String:
	if GameState.can_perform_action_now(action_id):
		return GameState.get_action_restriction_text(action_id)
	if action_id == "investigate" and InventoryManager.has_usable_tool_with_effect("night_investigate"):
		return "횃불 조사"
	return GameState.get_action_restriction_text(action_id)


func _can_fish_selected_tile() -> bool:
	var tile = WorldManager.get_tile(selected_tile_id)
	if tile == null:
		return false
	if not Array(tile.get("allowed_actions", [])).has("fish"):
		return false
	var resources: Dictionary = tile.get("resources", {})
	if int(resources.get("fish", 0)) <= 0:
		return false
	return InventoryManager.has_usable_tool_with_effect("fish_action")


func _can_start_action(action_id: String, cost: Dictionary) -> bool:
	if not _can_perform_action_with_tools(action_id):
		return false
	if action_id == "investigate" and not WorldManager.can_investigate_tile(selected_tile_id):
		return false
	if action_id == "fish" and not _can_fish_selected_tile():
		return false
	var time_cost := int(cost.get("time", 0))
	var stamina_cost := int(cost.get("stamina", 0))
	var together := CharacterManager.is_partner_following() and _can_use_partner_mode_for_action(action_id)
	if action_id == "develop" and not InventoryManager.has_items(WorldManager.get_tile_development_requirements(selected_tile_id)):
		return false
	if action_id == "hunt":
		var tile = WorldManager.get_current_tile()
		if tile == null or not WorldManager.is_tile_investigated(WorldManager.current_tile_id) or int(tile.get("animals", 0)) <= 0:
			return false
		if not InventoryManager.has_usable_tool_with_effect("hunt_action"):
			return false
	if action_id == "set_trap":
		if not WorldManager.can_set_trap_on_tile(selected_tile_id):
			return false
		if InventoryManager.get_count("snare_trap") <= 0:
			return false
	if action_id == "check_trap" and not WorldManager.has_tile_traps(selected_tile_id):
		return false
	if action_id == "wash":
		var tile = WorldManager.get_current_tile()
		if tile == null or not Array(tile.get("allowed_actions", [])).has("wash"):
			return false
	if action_id == "rest":
		return GameState.can_spend_minutes(15) and CharacterManager.can_spend_stamina(stamina_cost, together)
	return GameState.can_spend_action_points(time_cost) and CharacterManager.can_spend_stamina(stamina_cost, together)


func _can_start_resource_object_gather(tile_id: String, object_id: String, cost: Dictionary) -> bool:
	if tile_id != WorldManager.current_tile_id:
		return false
	if not _can_perform_action_with_tools("gather"):
		return false
	var object := WorldManager.get_resource_object(tile_id, object_id)
	if object.is_empty() or int(object.get("remaining", 0)) <= 0:
		return false
	var time_cost := int(cost.get("time", 0))
	var stamina_cost := int(cost.get("stamina", 0))
	var together := CharacterManager.is_partner_following()
	return GameState.can_spend_action_points(time_cost) and CharacterManager.can_spend_stamina(stamina_cost, together)


func _can_talk_to_partner() -> bool:
	if not CharacterManager.partner_joined:
		return false
	return CharacterManager.is_partner_following() or CharacterManager.get_partner_tile_id(WorldManager.current_tile_id) == WorldManager.current_tile_id


func _can_use_partner_mode_for_action(action_id: String) -> bool:
	return ["investigate", "gather", "fish", "hunt", "set_trap", "check_trap", "develop", "wash", "rest"].has(action_id)


func _item_is_directly_usable(item) -> bool:
	for key in item.effects.keys():
		if ["hp", "stamina", "hunger", "thirst", "hygiene", "mood", "trust", "affection"].has(String(key)):
			return true
	return false


func _can_attempt_recipe(recipe, partner_assist: bool = false) -> bool:
	if partner_assist and not CharacterManager.is_partner_following():
		return false
	if recipe == null or not CraftingManager.is_recipe_unlocked(String(recipe.id)):
		return false
	if not GameState.can_perform_action_now("craft"):
		return false
	if recipe.required_station != "" and not BaseManager.can_use_station(recipe.required_station):
		return false
	var adjusted_cost := GameState.get_adjusted_action_cost("craft", {"time": recipe.time_cost, "stamina": recipe.stamina_cost})
	var stamina_cost := int(adjusted_cost.get("stamina", recipe.stamina_cost))
	if partner_assist:
		stamina_cost = max(1, int(ceil(float(stamina_cost) * 0.75)))
	return InventoryManager.has_items(recipe.required_items) \
		and GameState.can_spend_action_points(int(adjusted_cost.get("time", recipe.time_cost))) \
		and CharacterManager.can_spend_stamina(stamina_cost, partner_assist)


func _format_requirements(required_items: Dictionary) -> String:
	var parts: Array[String] = []
	for item_id in required_items.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		parts.append("%s %d" % [display_name, int(required_items[item_id])])
	return _join_lines(parts, ", ")


func _format_items(items: Dictionary) -> String:
	var parts: Array[String] = []
	for item_id in items.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		parts.append("%s %d" % [display_name, int(items[item_id])])
	if parts.is_empty():
		return "없음"
	return _join_lines(parts, ", ")


func _recipe_result_icon_path(recipe) -> String:
	for item_id in recipe.result_items.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		if item != null:
			return item.icon_path
	return ""


func _minutes_label(minutes: int) -> String:
	var wrapped := posmod(minutes, GameState.MINUTES_PER_DAY)
	return "%02d:%02d" % [int(wrapped / 60), wrapped % 60]


func _top_info_tooltip(info_id: String) -> String:
	match info_id:
		"date":
			return "날짜 상세"
		"time":
			return "시간 상세"
		"weather":
			return "날씨 상세"
	return "상세 정보"


func _date_detail_text() -> String:
	var lines: Array[String] = []
	lines.append("DAY %d" % GameState.day)
	lines.append("시기: %s" % GameState.season)
	lines.append("일출: %s / 일몰: %s" % [_minutes_label(GameState.get_sunrise_minutes()), _minutes_label(GameState.get_sunset_minutes())])
	lines.append("오늘 날씨: %s" % GameState.weather)
	lines.append("내일 예보: %s" % GameState.next_weather)
	return _join_lines(lines, "\n")


func _time_detail_text() -> String:
	var lines: Array[String] = []
	lines.append("현재: %s" % GameState.get_time_label())
	lines.append("시간대: %s" % _time_phase_name(_time_phase_id()))
	lines.append("행동 가능 칸: %d" % GameState.action_points)
	lines.append("일광 상태: %s" % ("보통" if GameState.is_daylight_time() else "야간 제한"))
	lines.append("일출: %s / 일몰: %s" % [_minutes_label(GameState.get_sunrise_minutes()), _minutes_label(GameState.get_sunset_minutes())])
	lines.append("밤에는 조사와 제작이 막히거나, 일부 행동의 시간과 기력 부담이 커진다.")
	return _join_lines(lines, "\n")


func _weather_detail_text() -> String:
	var lines: Array[String] = []
	lines.append("현재 날씨: %s" % GameState.weather)
	lines.append("다음 날씨: %s" % GameState.next_weather)
	lines.append(_weather_play_note(GameState.weather))
	return _join_lines(lines, "\n")


func _weather_play_note(weather_text: String) -> String:
	if weather_text.contains("폭풍") or weather_text.contains("태풍"):
		return "강한 바람과 비 때문에 이동, 낚시, 야외 행동의 부담이 크게 오른다."
	if weather_text.contains("폭우"):
		return "비가 거세져 시야와 체온 관리가 나빠지고 일부 야외 행동이 불안정해진다."
	if weather_text.contains("비"):
		return "비는 물 확보에 도움을 주지만 젖음과 피로가 쌓이기 쉽다."
	if weather_text.contains("흐림"):
		return "햇빛은 약하지만 야외 활동 부담은 비교적 안정적이다."
	return "맑은 날은 시야와 움직임이 안정적이다. 해가 지기 전 필요한 행동을 진행하기 좋다."


func _weather_icon_id(weather_text: String) -> String:
	if weather_text.contains("폭풍") or weather_text.contains("태풍"):
		return "weather/storm"
	if weather_text.contains("폭우") or weather_text.contains("비"):
		return "weather/rain"
	if weather_text.contains("흐림"):
		return "weather/cloud"
	return "weather/sun"


func _time_flow_text() -> String:
	var daylight_text := "보통" if GameState.is_daylight_time() else "제한"
	return "DAY %d  %s %s  날씨 %s -> %s  %s / 남은 %d칸" % [
		GameState.day,
		_time_phase_name(_time_phase_id()),
		GameState.get_time_label(),
		GameState.weather,
		GameState.next_weather,
		daylight_text,
		GameState.action_points
	]


func _apply_time_flow_visuals(animated: bool = true) -> void:
	var phase_id := _time_phase_id()
	var phase_color := _time_phase_color(phase_id)
	if time_flow_panel != null:
		time_flow_panel.add_theme_stylebox_override("panel", _make_panel_style(_time_phase_panel_color(phase_id), phase_color.darkened(0.35), 5))
	if time_compact_panel != null:
		time_compact_panel.add_theme_stylebox_override("panel", _make_panel_style(phase_color, phase_color.lightened(0.35), 10))
		time_compact_panel.tooltip_text = _time_flow_text()
	if time_compact_icon_label != null:
		time_compact_icon_label.text = _time_phase_symbol(phase_id)
		time_compact_icon_label.add_theme_color_override("font_color", _time_phase_text_color(phase_id))
	if time_flow_label != null:
		time_flow_label.text = "아침 → 낮 → 저녁 → 밤 → 새벽   현재 %s" % _time_phase_name(phase_id)
		time_flow_label.add_theme_color_override("font_color", _time_phase_text_color(phase_id))
	if time_phase_clock_label != null:
		time_phase_clock_label.text = GameState.get_time_label()
		time_phase_clock_label.add_theme_color_override("font_color", _time_phase_text_color(phase_id))
	if time_phase_marker_icon != null:
		time_phase_marker_icon.text = _time_phase_symbol(phase_id)
	if time_phase_marker != null:
		time_phase_marker.add_theme_stylebox_override("panel", _make_panel_style(phase_color, phase_color.lightened(0.35), 10))
	for raw_phase_id in time_flow_phase_labels.keys():
		var label = time_flow_phase_labels[raw_phase_id]
		if label == null:
			continue
		var label_color := _time_phase_color(String(raw_phase_id)) if String(raw_phase_id) == phase_id else _time_phase_text_color(phase_id).darkened(0.28)
		label.add_theme_color_override("font_color", label_color)
	if time_flow_track == null or time_phase_marker == null:
		_apply_map_light(false)
		return
	var track_width := time_flow_track.size.x
	if track_width <= 0.0:
		call_deferred("_apply_time_flow_visuals", false)
		_apply_map_light(false)
		return
	var progress := _time_flow_progress()
	var should_reveal_time_bar := animated and last_time_flow_progress >= 0.0 and (absf(last_time_flow_progress - progress) > 0.001 or last_time_phase_id != phase_id)
	var marker_width := maxf(34.0, time_phase_marker.size.x)
	var target_position := Vector2(clampf(progress * maxf(1.0, track_width - marker_width), 0.0, maxf(1.0, track_width - marker_width)), -2.0)
	var target_light := _time_phase_map_light_color(phase_id)
	var target_fog := _fog_phase_modulate_color(phase_id)
	var can_animate := animated and last_time_flow_progress >= 0.0 and absf(last_time_flow_progress - progress) < 0.5
	if time_visual_tween != null and time_visual_tween.is_valid():
		time_visual_tween.kill()
	if can_animate:
		time_visual_tween = create_tween()
		time_visual_tween.set_parallel(true)
		time_visual_tween.tween_property(time_phase_marker, "position", target_position, 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		if map_light_overlay != null:
			time_visual_tween.tween_property(map_light_overlay, "color", target_light, 0.58).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_apply_tile_fog_visuals(target_fog, time_visual_tween)
	else:
		time_phase_marker.position = target_position
		if map_light_overlay != null:
			map_light_overlay.color = target_light
		_apply_tile_fog_visuals(target_fog)
	if should_reveal_time_bar:
		_set_time_flow_detail_visible(true, true, true)
	var transition_key := "%s:%s" % [phase_id, GameState.weather]
	if animated and last_time_transition_key != "" and last_time_transition_key != transition_key:
		_show_time_transition_banner(phase_id)
	last_time_transition_key = transition_key
	last_time_flow_progress = progress
	last_time_phase_id = phase_id


func _show_time_transition_banner(phase_id: String) -> void:
	if time_transition_panel == null or time_transition_visual == null:
		return
	var visual_path := _time_transition_visual_path(phase_id)
	var texture = _texture_from_path(visual_path)
	if texture == null:
		return
	time_transition_visual.texture = texture
	var phase_color := _time_phase_color(phase_id)
	time_transition_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.035, 0.045, 0.042, 0.88), phase_color.lightened(0.18), 7))
	if time_transition_title_label != null:
		time_transition_title_label.text = _time_transition_title(phase_id)
		time_transition_title_label.add_theme_color_override("font_color", phase_color.lightened(0.42))
	if time_transition_body_label != null:
		time_transition_body_label.text = _time_transition_body(phase_id)
	if time_transition_tween != null and time_transition_tween.is_valid():
		time_transition_tween.kill()
	time_transition_panel.visible = true
	time_transition_panel.move_to_front()
	time_transition_panel.modulate = Color(1, 1, 1, 0)
	time_transition_panel.position = Vector2(0, -8)
	time_transition_tween = create_tween()
	time_transition_tween.set_parallel(true)
	time_transition_tween.tween_property(time_transition_panel, "modulate", Color(1, 1, 1, 1), 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	time_transition_tween.tween_property(time_transition_panel, "position", Vector2.ZERO, 0.20).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	time_transition_tween.chain().tween_interval(1.20)
	time_transition_tween.chain().tween_property(time_transition_panel, "modulate", Color(1, 1, 1, 0), 0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	time_transition_tween.chain().tween_callback(func() -> void:
		if time_transition_panel != null:
			time_transition_panel.visible = false
			time_transition_panel.position = Vector2.ZERO
	)


func _time_transition_visual_path(phase_id: String) -> String:
	if _weather_mood_id() == "rain" and phase_id == "night":
		return _generated_ui_asset_path("time_weather", "night_storm")
	match phase_id:
		"dawn", "morning":
			return _generated_transition_asset_path("time_shift")
		"day":
			return _generated_ui_asset_path("time_weather", "noon_heat")
		"evening":
			return _generated_ui_asset_path("time_weather", "dusk")
		"night":
			return _generated_ui_asset_path("time_weather", "night_storm")
	return _generated_transition_asset_path("time_shift")


func _time_transition_title(phase_id: String) -> String:
	match phase_id:
		"dawn":
			return "새벽으로 접어든다"
		"morning":
			return "아침이 밝는다"
		"day":
			return "낮의 열기가 오른다"
		"evening":
			return "해가 기운다"
		"night":
			return "밤이 내려온다"
	return _time_phase_name(phase_id)


func _time_transition_body(phase_id: String) -> String:
	var daylight_text := "주간 행동" if GameState.is_daylight_time() else "야간 행동 제한"
	return "%s  /  날씨 %s  /  행동 %d칸" % [daylight_text, GameState.weather, GameState.action_points]


func _apply_map_light(animated: bool) -> void:
	if map_light_overlay == null:
		return
	var target_light := _time_phase_map_light_color(_time_phase_id())
	if animated:
		var tween := create_tween()
		tween.tween_property(map_light_overlay, "color", target_light, 0.45)
	else:
		map_light_overlay.color = target_light


func _apply_tile_fog_visuals(target_color: Color, tween: Tween = null) -> void:
	if map_grid == null:
		return
	for tile_node in map_grid.get_children():
		for child in tile_node.get_children():
			if child is TextureRect and bool(child.get_meta("time_fog", false)):
				if tween != null:
					tween.tween_property(child, "modulate", target_color, 0.58).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				else:
					child.modulate = target_color


func _refresh_map_atmosphere_visibility() -> void:
	var phase_id := _time_phase_id()
	var weather_id := _weather_mood_id()
	if map_wind_layer != null:
		map_wind_layer.modulate = Color(1.0, 1.0, 1.0, 0.16 if phase_id != "night" else 0.10)
	if map_moving_fog_layer != null:
		var fog_alpha := 0.055
		if phase_id == "night":
			fog_alpha = 0.10
		elif phase_id == "morning" or phase_id == "dawn":
			fog_alpha = 0.08
		if weather_id == "rain":
			fog_alpha += 0.04
		map_moving_fog_layer.modulate = Color(1.0, 1.0, 1.0, fog_alpha)
	if map_weather_layer != null:
		var rain_alpha := 0.0
		if weather_id == "rain":
			rain_alpha = 0.26
		elif weather_id == "cloud":
			rain_alpha = 0.04
		map_weather_layer.modulate = Color(1.0, 1.0, 1.0, rain_alpha)
	if map_sun_ray_overlay != null:
		var ray_alpha := 0.10
		if phase_id == "morning":
			ray_alpha = 0.18
		elif phase_id == "day":
			ray_alpha = 0.10
		elif phase_id == "evening":
			ray_alpha = 0.14
		elif phase_id == "dawn":
			ray_alpha = 0.08
		elif phase_id == "night":
			ray_alpha = 0.0
		if weather_id == "rain":
			ray_alpha *= 0.12
		elif weather_id == "cloud":
			ray_alpha *= 0.30
		map_sun_ray_overlay.modulate = Color(1.0, 0.96, 0.78, ray_alpha)
	if map_vignette_overlay != null:
		var vignette_color := Color(1.0, 1.0, 1.0, 0.20)
		match phase_id:
			"dawn":
				vignette_color = Color(0.74, 0.86, 1.0, 0.24)
			"morning":
				vignette_color = Color(1.0, 0.94, 0.78, 0.18)
			"day":
				vignette_color = Color(0.94, 1.0, 0.92, 0.12)
			"evening":
				vignette_color = Color(1.0, 0.70, 0.42, 0.26)
			"night":
				vignette_color = Color(0.36, 0.46, 0.72, 0.42)
		if weather_id == "rain":
			vignette_color = vignette_color.lerp(Color(0.44, 0.54, 0.64, 0.42), 0.35)
		elif weather_id == "cloud":
			vignette_color = vignette_color.lerp(Color(0.70, 0.76, 0.72, 0.28), 0.22)
		map_vignette_overlay.modulate = vignette_color


func _weather_mood_id() -> String:
	var text := String(GameState.weather)
	if text.contains("비") or text.contains("폭우") or text.contains("태풍") or text.contains("鍮") or text.contains("슦") or text.contains("뭾"):
		return "rain"
	if text.contains("흐") or text.contains("구름") or text.contains("먮"):
		return "cloud"
	return "clear"


func _time_phase_order() -> Array[String]:
	var order: Array[String] = ["morning", "day", "evening", "night", "dawn"]
	return order


func _time_phase_id() -> String:
	var minutes := posmod(GameState.current_minutes, GameState.MINUTES_PER_DAY)
	var sunrise := GameState.get_sunrise_minutes()
	var sunset := GameState.get_sunset_minutes()
	if minutes < sunrise:
		return "dawn"
	if minutes < 10 * 60:
		return "morning"
	if minutes < 17 * 60:
		return "day"
	if minutes < sunset:
		return "evening"
	return "night"


func _time_flow_progress() -> float:
	var phase_id := _time_phase_id()
	var order := _time_phase_order()
	var phase_index := order.find(phase_id)
	if phase_index < 0:
		phase_index = 0
	return clampf((float(phase_index) + _time_phase_ratio(phase_id)) / float(order.size()), 0.0, 1.0)


func _time_phase_ratio(phase_id: String) -> float:
	var bounds := _time_phase_bounds(phase_id)
	var start := int(bounds.get("start", 0))
	var end := int(bounds.get("end", start + 1))
	var minutes := posmod(GameState.current_minutes, GameState.MINUTES_PER_DAY)
	if end <= start:
		end = start + 1
	return clampf(float(minutes - start) / float(end - start), 0.0, 1.0)


func _time_phase_bounds(phase_id: String) -> Dictionary:
	var sunrise := GameState.get_sunrise_minutes()
	var sunset := GameState.get_sunset_minutes()
	match phase_id:
		"morning":
			return {"start": sunrise, "end": 10 * 60}
		"day":
			return {"start": 10 * 60, "end": 17 * 60}
		"evening":
			return {"start": 17 * 60, "end": maxi(sunset, 18 * 60)}
		"night":
			return {"start": sunset, "end": GameState.MINUTES_PER_DAY}
		"dawn":
			return {"start": 0, "end": sunrise}
	return {"start": 0, "end": GameState.MINUTES_PER_DAY}


func _time_phase_name(phase_id: String) -> String:
	match phase_id:
		"morning":
			return "아침"
		"day":
			return "낮"
		"evening":
			return "저녁"
		"night":
			return "밤"
		"dawn":
			return "새벽"
	return phase_id


func _time_phase_symbol(phase_id: String) -> String:
	match phase_id:
		"morning", "day":
			return "☀"
		"evening":
			return "◐"
	return "☾"


func _time_phase_color(phase_id: String) -> Color:
	match phase_id:
		"morning":
			return Color(1.00, 0.70, 0.28)
		"day":
			return Color(0.98, 0.88, 0.36)
		"evening":
			return Color(0.95, 0.42, 0.22)
		"night":
			return Color(0.35, 0.50, 0.86)
		"dawn":
			return Color(0.55, 0.58, 0.86)
	return Color(0.90, 0.84, 0.48)


func _time_phase_panel_color(phase_id: String) -> Color:
	match phase_id:
		"morning":
			return Color(0.95, 0.76, 0.42, 0.92)
		"day":
			return Color(0.92, 0.88, 0.62, 0.92)
		"evening":
			return Color(0.42, 0.20, 0.13, 0.92)
		"night":
			return Color(0.08, 0.12, 0.22, 0.92)
		"dawn":
			return Color(0.18, 0.22, 0.35, 0.92)
	return Color(0.90, 0.86, 0.72, 0.92)


func _time_phase_text_color(phase_id: String) -> Color:
	if ["night", "dawn", "evening"].has(phase_id):
		return Color(0.94, 0.94, 0.86)
	return Color(0.08, 0.10, 0.08)


func _time_phase_map_light_color(phase_id: String) -> Color:
	match phase_id:
		"morning":
			return Color(1.0, 0.72, 0.38, 0.055)
		"day":
			return Color(1.0, 0.96, 0.72, 0.015)
		"evening":
			return Color(1.0, 0.42, 0.18, 0.10)
		"night":
			return Color(0.02, 0.05, 0.17, 0.30)
		"dawn":
			return Color(0.15, 0.22, 0.45, 0.16)
	return Color(0.0, 0.0, 0.0, 0.0)


func _fog_phase_modulate_color(phase_id: String) -> Color:
	match phase_id:
		"morning":
			return Color(1.0, 0.88, 0.72, 1.0)
		"day":
			return Color(1.0, 1.0, 0.94, 1.0)
		"evening":
			return Color(0.95, 0.66, 0.62, 1.0)
		"night":
			return Color(0.42, 0.50, 0.72, 1.0)
		"dawn":
			return Color(0.66, 0.70, 0.90, 1.0)
	return Color.WHITE


func _tile_label(tile_id: String) -> String:
	var tile = WorldManager.get_tile(tile_id)
	if tile == null:
		return tile_id
	return "%s(%d,%d)" % [String(tile.get("display_name", "타일")), int(tile.get("x", 0)), int(tile.get("y", 0))]


func _action_display_name(action_id: String) -> String:
	match action_id:
		"move":
			return "이동"
		"investigate":
			return "조사"
		"gather":
			return "채집"
		"fish":
			return "낚시"
		"hunt":
			return "사냥"
		"set_trap":
			return "함정설치"
		"check_trap":
			return "함정확인"
		"develop":
			return "개발"
		"wash":
			return "씻기"
		"rest":
			return "휴식"
		"craft":
			return "제작"
		"partner_check":
			return "상태 묻기"
		"partner_comfort":
			return "안심시키기"
		"partner_plan":
			return "계획 의논"
		"partner_care":
			return "돌봄"
		"enter_base":
			return "거점 진입"
		"end_day":
			return "수면"
		"sleep":
			return "수면"
		"talk":
			return "대화"
		"gift":
			return "선물"
	return action_id


func _action_icon_id(action_id: String) -> String:
	match action_id:
		"move":
			return "actions/move"
		"investigate":
			return "actions/investigate"
		"gather":
			return "actions/gather"
		"fish":
			return "actions/fish"
		"hunt":
			return "items/wooden_spear"
		"set_trap":
			return "items/snare_trap"
		"check_trap":
			return "items/snare_trap"
		"develop":
			return "actions/develop"
		"wash":
			return "items/water"
		"rest":
			return "actions/rest"
		"craft":
			return "actions/craft"
		"enter_base":
			return "actions/place"
		"end_day":
			return "actions/end_day"
		"sleep":
			return "actions/rest"
		"talk":
			return "actions/talk"
		"gift":
			return "actions/gift"
		"partner_check":
			return "status/mood"
		"partner_comfort":
			return "status/stable"
		"partner_plan":
			return "actions/investigate"
		"partner_care":
			return "actions/gift"
	return ""


func _stat_display_name(stat_id: String) -> String:
	match stat_id:
		"hp":
			return "체력"
		"stamina":
			return "기력"
		"hunger":
			return "허기"
		"thirst":
			return "수분"
		"hygiene":
			return "위생"
		"mood":
			return "감정"
		"trust":
			return "신뢰"
	return stat_id


func _signed_int(value: int) -> String:
	if value > 0:
		return "+%d" % value
	return str(value)


func _status_icon_id(label_text: String) -> String:
	match label_text:
		"체력":
			return "status/hp"
		"기력":
			return "status/stamina"
		"허기":
			return "status/hunger"
		"수분":
			return "status/thirst"
		"위생":
			return "status/stable"
		"감정":
			return "status/mood"
		"신뢰":
			return "status/trust"
	return ""


func _state_icon_id(state_id: String) -> String:
	match state_id:
		"fatigue":
			return "status/fatigue"
		"fear":
			return "status/fear"
		"loneliness":
			return "status/loneliness"
		"stable":
			return "status/stable"
		"wet":
			return "status/thirst"
		"wound":
			return "status/hp"
		"anxiety":
			return "status/mood"
		"poor_hygiene":
			return "status/fatigue"
		"hunger_risk":
			return "status/hunger"
		"thirst_risk":
			return "status/thirst"
		"infection_risk":
			return "status/hp"
	return "status/stable"


func _mood_stage(value: int) -> String:
	if value >= 80:
		return "매우 좋음"
	if value >= 60:
		return "좋음"
	if value >= 40:
		return "보통"
	if value >= 20:
		return "나쁨"
	return "매우 나쁨"


func _hygiene_stage(value: int) -> String:
	if value >= 75:
		return "양호"
	if value >= 55:
		return "보통"
	if value >= 30:
		return "나쁨"
	return "위험"


func _state_display_name(state_id: String) -> String:
	match state_id:
		"fatigue":
			return "피로"
		"fear":
			return "공포"
		"loneliness":
			return "외로움"
		"stable":
			return "안정"
		"wet":
			return "젖음"
		"wound":
			return "상처"
		"anxiety":
			return "불안"
		"poor_hygiene":
			return "위생불량"
		"hunger_risk":
			return "허기 위험"
		"thirst_risk":
			return "수분 위험"
		"infection_risk":
			return "감염 위험"
	return state_id


func _icon_texture(icon_id: String):
	var path := ""
	if icon_id.begins_with("res://"):
		path = icon_id
	elif icon_id.begins_with("items/"):
		path = "res://assets/icons/%s.png" % icon_id
	elif icon_id.begins_with("status/"):
		path = "res://assets/icons/%s.png" % icon_id
	elif icon_id.begins_with("actions/"):
		path = "res://assets/icons/%s.png" % icon_id
	elif icon_id.begins_with("weather/"):
		path = "res://assets/icons/%s.png" % icon_id
	if path != "":
		return _texture_from_path(path)
	return null


func _texture_from_path(path: String):
	if path == "":
		return null
	if runtime_texture_cache.has(path):
		return runtime_texture_cache[path]
	if ResourceLoader.exists(path):
		var imported_texture = load(path)
		runtime_texture_cache[path] = imported_texture
		return imported_texture
	var file_path := path
	if path.begins_with("res://"):
		file_path = ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(file_path):
		return null
	var image := Image.new()
	if image.load(file_path) != OK:
		return null
	var texture := ImageTexture.create_from_image(image)
	runtime_texture_cache[path] = texture
	return texture


func _make_panel_style(bg_color: Color, border_color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.22)
	style.shadow_size = 3
	style.shadow_offset = Vector2(0, 1)
	return style


func _append_log(text: String) -> void:
	if text == "":
		return
	log_lines.append(text)
	while log_lines.size() > 80:
		log_lines.pop_front()
	_refresh_top_log_summary()


func _refresh_top_log_summary() -> void:
	if top_log_button == null:
		return
	top_log_button.text = "기록"
	top_log_button.tooltip_text = "최근 기록 열기\n%s" % _latest_log_summary()


func _latest_log_summary() -> String:
	if log_lines.is_empty():
		return "기록 없음"
	var text := String(log_lines[log_lines.size() - 1]).replace("\n", " / ")
	return text


func _log_popup_text() -> String:
	if log_lines.is_empty():
		return "기록 없음"
	var lines: Array[String] = []
	var start_index := maxi(0, log_lines.size() - 80)
	for index in range(start_index, log_lines.size()):
		lines.append(String(log_lines[index]))
	return _join_lines(lines, "\n\n")


func _clear_children(container: Node) -> void:
	if container == null:
		return
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()


func _join_lines(lines: Array, separator: String) -> String:
	var text := ""
	for index in range(lines.size()):
		if index > 0:
			text += separator
		text += String(lines[index])
	return text
