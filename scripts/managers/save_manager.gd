extends Node

signal saved(path: String)
signal loaded(path: String)
signal save_failed(reason: String)

const SAVE_SLOT_COUNT := 3
const SAVE_PATH_TEMPLATE := "user://save_%02d.json"


func save_game(slot: int = 1) -> bool:
	var safe_slot := _normalize_slot(slot)
	var data := {
		"version": 1,
		"slot": safe_slot,
		"saved_at": Time.get_datetime_string_from_system(false, true),
		"game_state": GameState.get_save_data(),
		"characters": CharacterManager.get_save_data(),
		"inventory": InventoryManager.get_save_data(),
		"world": WorldManager.get_save_data(),
		"base": BaseManager.get_save_data(),
		"events": EventManager.get_save_data(),
		"crafting": CraftingManager.get_save_data()
	}
	var path := get_slot_path(safe_slot)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		emit_signal("save_failed", "저장 파일을 열 수 없다.")
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	emit_signal("saved", path)
	return true


func load_game(slot: int = 1) -> bool:
	var safe_slot := _normalize_slot(slot)
	var path := get_slot_path(safe_slot)
	if not FileAccess.file_exists(path):
		emit_signal("save_failed", "저장 파일이 없다.")
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		emit_signal("save_failed", "저장 파일을 읽을 수 없다.")
		return false
	var text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		emit_signal("save_failed", "저장 데이터 형식이 올바르지 않다.")
		return false
	var data: Dictionary = parsed
	GameState.load_save_data(data.get("game_state", {}))
	CharacterManager.load_save_data(data.get("characters", {}))
	InventoryManager.load_save_data(data.get("inventory", {}))
	WorldManager.load_save_data(data.get("world", {}))
	BaseManager.load_save_data(data.get("base", {}))
	EventManager.load_save_data(data.get("events", {}))
	CraftingManager.load_save_data(data.get("crafting", {}))
	emit_signal("loaded", path)
	return true


func has_save(slot: int = 1) -> bool:
	return FileAccess.file_exists(get_slot_path(_normalize_slot(slot)))


func get_slot_path(slot: int) -> String:
	return SAVE_PATH_TEMPLATE % _normalize_slot(slot)


func get_slot_summary(slot: int) -> Dictionary:
	var safe_slot := _normalize_slot(slot)
	var path := get_slot_path(safe_slot)
	var summary := {
		"slot": safe_slot,
		"path": path,
		"exists": FileAccess.file_exists(path)
	}
	if not bool(summary.get("exists", false)):
		return summary
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		summary["broken"] = true
		return summary
	var text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		summary["broken"] = true
		return summary
	var data: Dictionary = parsed
	var game_state: Dictionary = data.get("game_state", {})
	summary["version"] = int(data.get("version", 0))
	summary["saved_at"] = String(data.get("saved_at", ""))
	summary["day"] = int(game_state.get("day", 1))
	summary["season"] = String(game_state.get("season", ""))
	summary["weather"] = String(game_state.get("weather", ""))
	summary["time"] = _minutes_to_label(int(game_state.get("current_minutes", 360)))
	return summary


func _normalize_slot(slot: int) -> int:
	return clampi(slot, 1, SAVE_SLOT_COUNT)


func _minutes_to_label(minutes: int) -> String:
	var safe_minutes := clampi(minutes, 0, 1439)
	return "%02d:%02d" % [int(safe_minutes / 60), safe_minutes % 60]
