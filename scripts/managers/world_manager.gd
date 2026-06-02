extends Node

signal regions_changed
signal action_resolved(result: Dictionary)

const TILE_MAP_SIZE := 10
const PLAYABLE_MIN := 2
const PLAYABLE_MAX := 7

const RESOURCE_OBJECT_DEFINITIONS := {
	"palm_tree": {
		"display_name": "야자나무",
		"description": "줄기와 잎을 바로 손질해 쓸 수 있는 낮은 야자나무.",
		"icon": "res://assets/icons/objects/palm_tree.png",
		"items": {"palm_frond": 2, "wood": 1},
		"uses": 2,
		"time": 1,
		"stamina": 8
	},
	"coconut_palm": {
		"display_name": "야자 열매",
		"description": "해변 가장자리의 낮은 야자 열매. 목을 조금 축이고 허기를 늦출 수 있다.",
		"icon": "res://assets/icons/objects/coconut_palm.png",
		"items": {"water": 1, "berry": 1},
		"uses": 1,
		"time": 1,
		"stamina": 5
	},
	"wild_potato_patch": {
		"display_name": "야생 감자밭",
		"description": "흙 사이로 작은 덩이줄기가 드러난 곳. 손으로 캐도 먹을거리를 얻을 수 있다.",
		"icon": "res://assets/icons/objects/wild_potato_patch.png",
		"items": {"wild_potato": 2},
		"uses": 1,
		"time": 1,
		"stamina": 7
	},
	"berry_bush": {
		"display_name": "열매 덤불",
		"description": "낮은 가지에 익은 열매가 모여 있다.",
		"icon": "res://assets/icons/objects/berry_bush.png",
		"items": {"berry": 3},
		"uses": 1,
		"time": 1,
		"stamina": 5
	},
	"driftwood_pile": {
		"display_name": "표류목 더미",
		"description": "파도에 밀려온 마른 나무와 끈처럼 쓸 섬유가 얽혀 있다.",
		"icon": "res://assets/icons/objects/driftwood_pile.png",
		"items": {"wood": 2, "fiber": 1},
		"uses": 1,
		"time": 1,
		"stamina": 6
	},
	"fallen_tree": {
		"display_name": "쓰러진 나무",
		"description": "겉껍질이 무른 나무. 힘을 쓰면 땔감으로 쪼갤 수 있다.",
		"icon": "res://assets/icons/objects/fallen_tree.png",
		"items": {"wood": 3},
		"uses": 1,
		"time": 1,
		"stamina": 10
	},
	"vine_thicket": {
		"display_name": "덩굴 군락",
		"description": "얽힌 덩굴 사이에서 끈과 섬유를 건질 수 있다.",
		"icon": "res://assets/icons/objects/vine_thicket.png",
		"items": {"vine": 2, "fiber": 1},
		"uses": 1,
		"time": 1,
		"stamina": 7
	},
	"freshwater_spring": {
		"display_name": "맑은 물웅덩이",
		"description": "바닥이 보일 만큼 맑은 물이 조금 고인 곳.",
		"icon": "res://assets/icons/objects/freshwater_spring.png",
		"items": {"water": 2},
		"uses": 2,
		"time": 1,
		"stamina": 4
	},
	"clay_bank": {
		"display_name": "점토 둔덕",
		"description": "손으로 파내면 질 좋은 점토를 얻을 수 있는 축축한 흙.",
		"icon": "res://assets/icons/objects/clay_bank.png",
		"items": {"clay": 2},
		"uses": 1,
		"time": 1,
		"stamina": 8
	},
	"stone_outcrop": {
		"display_name": "돌무더기",
		"description": "쓸 만한 돌이 드러나 있는 작은 암반.",
		"icon": "res://assets/icons/objects/stone_outcrop.png",
		"items": {"stone": 2},
		"uses": 1,
		"time": 1,
		"stamina": 8
	},
	"reed_patch": {
		"display_name": "갈대밭",
		"description": "마른 줄기와 섬유를 걷어낼 수 있는 얕은 풀밭.",
		"icon": "res://assets/icons/objects/reed_patch.png",
		"items": {"fiber": 2},
		"uses": 1,
		"time": 1,
		"stamina": 5
	}
}

const TERRAIN_RESOURCE_OBJECTS := {
	"beach": ["coconut_palm", "palm_tree", "driftwood_pile", "berry_bush"],
	"meadow": ["wild_potato_patch", "berry_bush", "reed_patch"],
	"forest": ["palm_tree", "vine_thicket", "fallen_tree", "berry_bush"],
	"river": ["freshwater_spring", "clay_bank", "reed_patch"],
	"marsh": ["clay_bank", "reed_patch", "vine_thicket", "freshwater_spring"],
	"cave": ["stone_outcrop", "freshwater_spring"],
	"hill": ["stone_outcrop", "fallen_tree"],
	"ruins": ["stone_outcrop", "clay_bank", "vine_thicket"]
}

var regions: Dictionary = {}
var visited_regions: Dictionary = {}
var tiles: Dictionary = {}
var revealed_tiles: Dictionary = {}
var investigated_tiles: Dictionary = {}
var current_tile_id: String = ""
var pending_world_messages: Array[String] = []


func _ready() -> void:
	reset_state()


func reset_state() -> void:
	load_region_definitions()
	_build_tile_map()
	current_tile_id = _tile_id(2, 7)
	revealed_tiles = {current_tile_id: true}
	investigated_tiles = {}
	pending_world_messages.clear()
	var start_tile = get_tile(current_tile_id)
	visited_regions = {"beach": true}
	if start_tile != null:
		GameState.set_current_region(String(start_tile.get("region_id", "beach")))
	emit_signal("regions_changed")


func load_region_definitions() -> void:
	regions.clear()
	var dir := DirAccess.open("res://data/regions")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var region = load("res://data/regions/%s" % file_name)
			if region != null and region.id != "":
				regions[region.id] = region.duplicate(true)
		file_name = dir.get_next()
	dir.list_dir_end()


func get_region(region_id: String):
	return regions.get(region_id, null)


func get_current_region():
	return get_region(GameState.current_region_id)


func get_connected_regions(region_id: String = "") -> Array[String]:
	var target_id := region_id
	if target_id == "":
		target_id = GameState.current_region_id
	var region = get_region(target_id)
	if region == null:
		return []
	return region.connected_regions.duplicate()


func is_region_visited(region_id: String) -> bool:
	return bool(visited_regions.get(region_id, false))


func mark_region_visited(region_id: String) -> void:
	if region_id == "":
		return
	if bool(visited_regions.get(region_id, false)):
		return
	visited_regions[region_id] = true
	emit_signal("regions_changed")


func get_tile(tile_id: String):
	return tiles.get(tile_id, null)


func get_tile_id(x: int, y: int) -> String:
	return _tile_id(x, y)


func get_tile_rows() -> Array:
	var rows: Array = []
	for y in range(TILE_MAP_SIZE):
		var row: Array = []
		for x in range(TILE_MAP_SIZE):
			row.append(get_tile(_tile_id(x, y)))
		rows.append(row)
	return rows


func get_current_tile():
	return get_tile(current_tile_id)


func is_tile_playable(tile_id: String) -> bool:
	var tile = get_tile(tile_id)
	return tile != null and bool(tile.get("playable", false))


func is_tile_walkable(tile_id: String) -> bool:
	var tile = get_tile(tile_id)
	return tile != null and bool(tile.get("playable", false)) and not bool(tile.get("movement_blocked", false))


func is_tile_revealed(tile_id: String) -> bool:
	return bool(revealed_tiles.get(tile_id, false)) or tile_id == current_tile_id


func is_tile_investigated(tile_id: String) -> bool:
	return bool(investigated_tiles.get(tile_id, false))


func is_tile_adjacent_to_current(tile_id: String) -> bool:
	return get_reachable_adjacent_tile_ids(current_tile_id).has(tile_id)


func is_tile_clickable(tile_id: String) -> bool:
	if not is_tile_playable(tile_id):
		return false
	if not is_tile_revealed(tile_id):
		return false
	if tile_id == current_tile_id:
		return true
	return is_tile_adjacent_to_current(tile_id)


func get_adjacent_tile_ids(tile_id: String) -> Array[String]:
	return get_neighbor_tile_ids(tile_id)


func get_neighbor_tile_ids(tile_id: String) -> Array[String]:
	var tile = get_tile(tile_id)
	var ids: Array[String] = []
	if tile == null:
		return ids
	var x := int(tile.get("x", 0))
	var y := int(tile.get("y", 0))
	var offsets := [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(-1, -1),
		Vector2i(-1, 1)
	]
	if y % 2 == 1:
		offsets = [
			Vector2i(1, 0),
			Vector2i(-1, 0),
			Vector2i(0, -1),
			Vector2i(0, 1),
			Vector2i(1, -1),
			Vector2i(1, 1)
		]
	for offset in offsets:
		var next_id := _tile_id(x + offset.x, y + offset.y)
		if is_tile_playable(next_id):
			ids.append(next_id)
	return ids


func get_reachable_adjacent_tile_ids(tile_id: String) -> Array[String]:
	var ids: Array[String] = []
	for next_id in get_neighbor_tile_ids(tile_id):
		if can_move_between_tiles(tile_id, next_id):
			ids.append(next_id)
	return ids


func can_move_between_tiles(from_tile_id: String, to_tile_id: String) -> bool:
	if from_tile_id == to_tile_id:
		return is_tile_walkable(from_tile_id)
	if not is_tile_walkable(from_tile_id) or not is_tile_walkable(to_tile_id):
		return false
	if not get_neighbor_tile_ids(from_tile_id).has(to_tile_id):
		return false
	return _blocked_edge_note(from_tile_id, to_tile_id) == ""


func get_tile_access_note(tile_id: String, from_tile_id: String = "") -> String:
	if not is_tile_playable(tile_id):
		return "외곽 지역"
	if bool(get_tile(tile_id).get("movement_blocked", false)):
		return String(get_tile(tile_id).get("access_note", "막힌 지형"))
	if from_tile_id != "":
		var edge_note := _blocked_edge_note(from_tile_id, tile_id)
		if edge_note != "":
			return edge_note
	return ""


func get_blocked_edge_note(first_tile_id: String, second_tile_id: String) -> String:
	if first_tile_id == "" or second_tile_id == "":
		return ""
	if not is_tile_playable(first_tile_id) or not is_tile_playable(second_tile_id):
		return ""
	if not get_neighbor_tile_ids(first_tile_id).has(second_tile_id):
		return ""
	return _blocked_edge_note(first_tile_id, second_tile_id)


func reveal_adjacent_tiles(tile_id: String) -> Array[String]:
	var revealed_now: Array[String] = []
	for adjacent_id in get_neighbor_tile_ids(tile_id):
		if not can_move_between_tiles(tile_id, adjacent_id):
			continue
		if not bool(revealed_tiles.get(adjacent_id, false)):
			revealed_tiles[adjacent_id] = true
			revealed_now.append(adjacent_id)
	return revealed_now


func get_tile_action_cost(action_id: String) -> Dictionary:
	return get_action_cost(action_id)


func get_tile_hunting_summary(tile_id: String = "") -> String:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return ""
	if not is_tile_investigated(target_id):
		return "미확인"
	var animals := int(tile.get("animals", 0))
	var traps: Dictionary = tile.get("traps", {})
	var parts: Array[String] = []
	if animals <= 0:
		parts.append("흔적 없음")
	elif animals <= 1:
		parts.append("흔적 적음")
	elif animals <= 3:
		parts.append("흔적 있음")
	else:
		parts.append("흔적 많음")
	if not traps.is_empty():
		var caught := 0
		for trap in traps.values():
			if String(Dictionary(trap).get("state", "set")) == "caught":
				caught += 1
		parts.append("덫 %d" % traps.size())
		if caught > 0:
			parts.append("걸림 %d" % caught)
	return _join_strings(parts, " / ")


func has_tile_traps(tile_id: String = "") -> bool:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return false
	var traps: Dictionary = tile.get("traps", {})
	return not traps.is_empty()


func can_set_trap_on_tile(tile_id: String = "") -> bool:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return false
	if target_id != current_tile_id:
		return false
	if not is_tile_investigated(target_id):
		return false
	if not Array(tile.get("allowed_actions", [])).has("set_trap"):
		return false
	if int(tile.get("animals", 0)) <= 0:
		return false
	var traps: Dictionary = tile.get("traps", {})
	return traps.size() < _tile_trap_limit(tile)


func can_investigate_tile(tile_id: String = "") -> bool:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return false
	if not Array(tile.get("allowed_actions", [])).has("investigate"):
		return false
	return int(tile.get("investigation", 0)) < 100


func get_tile_development_requirements(tile_id: String = "") -> Dictionary:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return {}
	return _development_requirements(String(tile.get("terrain", "")), int(tile.get("development", 0)))


func get_tile_field_items(tile_id: String = "") -> Dictionary:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return {}
	return tile.get("field_items", {}).duplicate(true)


func get_tile_memories(tile_id: String = "") -> Array[Dictionary]:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	var result: Array[Dictionary] = []
	if tile == null:
		return result
	_prune_tile_memory_flags(tile)
	var memories: Dictionary = tile.get("memory_flags", {})
	var keys := memories.keys()
	keys.sort()
	for raw_memory_id in keys:
		var memory: Dictionary = memories[raw_memory_id]
		result.append(memory.duplicate(true))
	return result


func get_tile_memory_ids(tile_id: String = "") -> Array[String]:
	var ids: Array[String] = []
	for memory in get_tile_memories(tile_id):
		ids.append(String(memory.get("id", "")))
	return ids


func has_tile_memory(tile_id: String, memory_id: String) -> bool:
	return get_tile_memory_ids(tile_id).has(memory_id)


func add_tile_memory(tile_id: String, memory_id: String, duration_days: int = 0) -> void:
	var tile = get_tile(tile_id)
	if tile == null or memory_id == "":
		return
	_add_tile_memory_to_tile(tile, memory_id, duration_days)
	emit_signal("regions_changed")


func has_tile_field_items(tile_id: String = "") -> bool:
	for amount in get_tile_field_items(tile_id).values():
		if int(amount) > 0:
			return true
	return false


func get_tile_resource_objects(tile_id: String = "", include_depleted: bool = false) -> Array[Dictionary]:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return []
	if not is_tile_investigated(target_id):
		return []
	var objects: Dictionary = tile.get("resource_objects", {})
	var result: Array[Dictionary] = []
	var keys := objects.keys()
	keys.sort()
	for raw_object_id in keys:
		var object_id := String(raw_object_id)
		var object: Dictionary = objects[object_id]
		if not include_depleted and int(object.get("remaining", 0)) <= 0:
			continue
		result.append(object.duplicate(true))
	return result


func get_resource_object(tile_id: String, object_id: String) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null or object_id == "":
		return {}
	var objects: Dictionary = tile.get("resource_objects", {})
	if not objects.has(object_id):
		return {}
	return Dictionary(objects[object_id]).duplicate(true)


func get_resource_object_action_cost(tile_id: String, object_id: String) -> Dictionary:
	var object := get_resource_object(tile_id, object_id)
	if object.is_empty():
		return get_action_cost("gather")
	var base_cost := {
		"stamina": int(object.get("stamina", 8)),
		"time": int(object.get("time", 1))
	}
	return _tool_adjusted_action_cost("gather", GameState.get_adjusted_action_cost("gather", base_cost))


func get_tile_resource_object_summary(tile_id: String, include_depleted: bool = false) -> String:
	var objects := get_tile_resource_objects(tile_id, include_depleted)
	if objects.is_empty():
		return ""
	var parts: Array[String] = []
	for object in objects:
		var label := String(object.get("display_name", object.get("type", "")))
		var remaining := int(object.get("remaining", 0))
		if include_depleted:
			label += " %s" % ("고갈" if remaining <= 0 else "%d회" % remaining)
		parts.append(label)
	return _join_strings(parts, ", ")


func gather_resource_object(tile_id: String, object_id: String, together: bool = false) -> Dictionary:
	var use_partner := together and CharacterManager.is_partner_following()
	if not _has_reached_base():
		return _emit_action_result(_fail(_pre_base_restriction_text("gather")), use_partner)
	var tile = get_tile(tile_id)
	if tile == null:
		return _emit_action_result(_fail("채취할 대상을 찾을 수 없다."), use_partner)
	if tile_id != current_tile_id:
		return _emit_action_result(_fail("현재 서 있는 타일의 대상만 채취할 수 있다."), use_partner)
	if not is_tile_investigated(tile_id):
		return _emit_action_result(_fail("먼저 이 지역을 조사해야 채취 대상을 알아볼 수 있다."), use_partner)
	var objects: Dictionary = tile.get("resource_objects", {})
	if not objects.has(object_id):
		return _emit_action_result(_fail("이미 사라졌거나 찾을 수 없는 채취 대상이다."), use_partner)
	var object: Dictionary = objects[object_id]
	if int(object.get("remaining", 0)) <= 0:
		return _emit_action_result(_fail("%s에서 더 얻을 수 있는 것이 없다." % String(object.get("display_name", "대상"))), use_partner)
	if not _pay_cost(int(object.get("stamina", 8)), int(object.get("time", 1)), use_partner, "gather"):
		return _emit_action_result(_fail("채취할 기력 또는 시간이 부족하다."), use_partner)
	var items: Dictionary = object.get("items", {})
	var gathered: Dictionary = {}
	var field_leftovers: Dictionary = {}
	for raw_item_id in items.keys():
		var item_id := String(raw_item_id)
		var amount := int(items[raw_item_id])
		if amount <= 0:
			continue
		var carried := InventoryManager.add_item_to_party(item_id, amount, use_partner)
		if carried > 0:
			gathered[item_id] = int(gathered.get(item_id, 0)) + carried
		var leftover := amount - carried
		if leftover > 0:
			_add_field_item_to_tile(tile, item_id, leftover)
			field_leftovers[item_id] = int(field_leftovers.get(item_id, 0)) + leftover
	_consume_tile_resource_pool(tile, items)
	object["remaining"] = maxi(0, int(object.get("remaining", 0)) - 1)
	objects[object_id] = object
	tile["resource_objects"] = objects
	emit_signal("regions_changed")
	var object_name := String(object.get("display_name", "채취 대상"))
	var text := "%s에서 %s을 얻었다." % [object_name, _format_items(items)]
	if not field_leftovers.is_empty():
		text += "\n짐이 무거워 %s은/는 타일에 내려놓았다." % _format_items(field_leftovers)
	if int(object.get("remaining", 0)) <= 0:
		text += "\n%s은 더 이상 얻을 것이 없어 보인다." % object_name
	var result := _finish_tile_action(tile, text, "gather", gathered, use_partner)
	result["resource_object_id"] = object_id
	return _emit_action_result(result, use_partner)


func get_tile_field_weight(tile_id: String = "") -> float:
	var total := 0.0
	var field_items := get_tile_field_items(tile_id)
	for raw_item_id in field_items.keys():
		total += InventoryManager.get_stack_weight(String(raw_item_id), int(field_items[raw_item_id]))
	return total


func get_tile_mark(tile_id: String = "") -> String:
	var target_id := tile_id
	if target_id == "":
		target_id = current_tile_id
	var tile = get_tile(target_id)
	if tile == null:
		return ""
	return String(tile.get("map_mark", ""))


func set_tile_mark(tile_id: String, mark_id: String) -> bool:
	var tile = get_tile(tile_id)
	if tile == null:
		return false
	if int(tile.get("development", 0)) < 100:
		return false
	tile["map_mark"] = mark_id
	emit_signal("regions_changed")
	return true


func drop_item_on_current_tile(item_id: String, amount: int = 1, owner_id: String = "player") -> Dictionary:
	if not _has_reached_base():
		return _fail("지금은 물건을 정리할 때가 아니다. 먼저 해가 지기 전에 쉴 곳을 찾아야 한다.")
	var tile = get_current_tile()
	if tile == null:
		return _fail("물건을 내려놓을 타일을 찾을 수 없다.")
	var owned_amount := InventoryManager.get_count(item_id, owner_id)
	if owned_amount <= 0:
		return _fail("내려놓을 물건이 없다.")
	var safe_amount := clampi(amount, 1, owned_amount)
	var item = InventoryManager.get_item_data(item_id)
	if item == null:
		return _fail("알 수 없는 물건이다.")
	if not InventoryManager.remove_item(item_id, safe_amount, owner_id):
		return _fail("내려놓을 물건이 부족하다.")
	_add_field_item_to_tile(tile, item_id, safe_amount)
	emit_signal("regions_changed")
	var result := _ok("%s x%d을/를 현재 타일에 내려놓았다. (%s)" % [item.display_name, safe_amount, InventoryManager.get_owner_display_name(owner_id)], "drop", {})
	result["tile_id"] = current_tile_id
	emit_signal("action_resolved", result)
	return result


func pick_up_field_item(tile_id: String, item_id: String, amount: int = -1, owner_id: String = "player") -> Dictionary:
	if not _has_reached_base():
		return _fail(_pre_base_restriction_text("gather"))
	if tile_id != current_tile_id:
		return _fail("현재 서 있는 타일의 물건만 주울 수 있다.")
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("물건을 주울 타일을 찾을 수 없다.")
	var field_items: Dictionary = tile.get("field_items", {})
	var stored_amount := int(field_items.get(item_id, 0))
	if stored_amount <= 0:
		return _fail("그 물건은 이 타일에 남아 있지 않다.")
	var requested_amount := stored_amount if amount <= 0 else mini(amount, stored_amount)
	var addable := InventoryManager.get_addable_amount(item_id, requested_amount, owner_id)
	if addable <= 0:
		return _fail("%s의 짐이 너무 무거워 더 들 수 없다." % InventoryManager.get_owner_display_name(owner_id))
	var added := InventoryManager.add_item(item_id, addable, owner_id)
	if added <= 0:
		return _fail("%s의 짐이 너무 무거워 더 들 수 없다." % InventoryManager.get_owner_display_name(owner_id))
	_remove_field_item_from_tile(tile, item_id, added)
	emit_signal("regions_changed")
	var item = InventoryManager.get_item_data(item_id)
	var display_name := item_id
	if item != null:
		display_name = item.display_name
	var result := _ok("%s x%d을/를 주웠다. (%s)" % [display_name, added, InventoryManager.get_owner_display_name(owner_id)], "pickup", {item_id: added})
	result["tile_id"] = tile_id
	emit_signal("action_resolved", result)
	return result


func get_region_development_requirements(region_id: String = "") -> Dictionary:
	var target_id := region_id
	if target_id == "":
		target_id = GameState.current_region_id
	var region = get_region(target_id)
	if region == null:
		return {}
	return _development_requirements(region.region_type, region.development)


func _has_reached_base() -> bool:
	return GameState.has_flag("entered_base")


func _can_use_tile_action_before_base(action_id: String) -> bool:
	if _has_reached_base():
		return true
	return ["move", "investigate", "enter_base"].has(action_id)


func _pre_base_restriction_text(action_id: String) -> String:
	match action_id:
		"gather":
			return "자원은 눈에 들어오지만 지금 짐을 늘리면 밤을 버틸 곳을 찾기 어렵다. 먼저 쉴 만한 동굴을 찾아야 한다."
		"fish", "hunt", "set_trap":
			return "먹을 것을 노리기엔 아직 몸을 맡길 곳이 없다. 오늘은 조사하고 이동해서 피난처를 찾는 게 우선이다."
		"rest":
			return "노출된 바닷가에서 쉬면 더 지친다. 바람을 막아 줄 쉴 곳을 먼저 찾아야 한다."
		"develop", "wash":
			return "정비할 곳을 고르기 전에 몸을 숨길 거점을 찾아야 한다."
	return "지금은 조사와 이동에 집중해야 한다. 해가 지기 전에 쉴 곳을 찾아야 한다."


func _pre_base_shelter_hint(action_id: String, tile: Dictionary) -> String:
	if _has_reached_base() or not ["move", "investigate"].has(action_id):
		return ""
	if tile == null:
		return "바람이 차다. 해가 지기 전에 몸을 숨길 곳을 찾아야 한다."
	var tile_id := String(tile.get("id", current_tile_id))
	if tile_id == _tile_id(2, 7):
		return "뒤쪽은 막혔다. 자원보다 먼저, 해변을 따라 쉴 곳으로 이어지는 길을 찾아야 한다."
	if String(tile.get("terrain", "")) == "cave":
		return "동굴 안쪽이면 밤바람은 피할 수 있다. 안으로 들어가 거점으로 삼을지 확인하자."
	if GameState.current_minutes >= 12 * 60:
		return "낮이 기울기 시작한다. 여기서 오래 머물면 밤을 밖에서 맞게 된다."
	return "주변엔 쓸 만한 자원이 많지만, 먼저 바람과 비를 피할 쉴 곳이 필요하다."


func execute_tile_action(action_id: String, args: Dictionary = {}) -> Dictionary:
	var result: Dictionary
	var together := _uses_partner(args)
	var method_id := String(args.get("method_id", ""))
	var minigame_result: Dictionary = args.get("minigame_result", {})
	if not _can_use_tile_action_before_base(action_id):
		result = _fail(_pre_base_restriction_text(action_id))
		emit_signal("action_resolved", result)
		return result
	match action_id:
		"move":
			result = _move_to_tile(String(args.get("target_tile_id", "")))
		"investigate":
			result = _investigate_tile(current_tile_id, together)
		"gather":
			result = _gather_tile(current_tile_id, together, method_id)
		"fish":
			result = _fish_tile(current_tile_id, together, method_id, minigame_result)
		"hunt":
			result = _hunt_tile(current_tile_id, together, method_id, minigame_result)
		"set_trap":
			result = _set_trap_tile(current_tile_id, together, method_id)
		"check_trap":
			result = _check_trap_tile(current_tile_id, together)
		"develop":
			result = _develop_tile(current_tile_id, together)
		"wash":
			result = _wash_tile(current_tile_id, together)
		"rest":
			result = _rest_region(together, int(args.get("rest_minutes", 30)))
		"enter_base":
			result = _enter_base_tile()
		_:
			result = _fail("알 수 없는 타일 행동이다.")
	if bool(result.get("ok", false)):
		result["together"] = together
		if method_id != "":
			result["method_id"] = _normalized_action_method(action_id, method_id)
	emit_signal("action_resolved", result)
	return result


func get_action_cost(action_id: String) -> Dictionary:
	return _tool_adjusted_action_cost(action_id, GameState.get_adjusted_action_cost(action_id, get_base_action_cost(action_id)))


func get_tile_action_method_cost(action_id: String, method_id: String) -> Dictionary:
	var base_cost := _action_method_base_cost(action_id, method_id, get_base_action_cost(action_id))
	return _tool_adjusted_action_cost(action_id, GameState.get_adjusted_action_cost(action_id, base_cost))


func get_base_action_cost(action_id: String) -> Dictionary:
	match action_id:
		"move":
			return {"stamina": 6, "time": 1}
		"investigate":
			return {"stamina": 12, "time": 2}
		"gather":
			return {"stamina": 16, "time": 2}
		"fish":
			return {"stamina": 14, "time": 2}
		"hunt":
			return {"stamina": 26, "time": 4}
		"set_trap":
			return {"stamina": 8, "time": 1}
		"check_trap":
			return {"stamina": 4, "time": 1}
		"develop":
			return {"stamina": 24, "time": 4}
		"wash":
			return {"stamina": 4, "time": 1}
		"rest":
			return {"stamina": 0, "time": 1}
		"enter_base":
			return {"stamina": 0, "time": 0}
	return {"stamina": 0, "time": 1}


func execute_action(action_id: String, args: Dictionary = {}) -> Dictionary:
	var result: Dictionary
	var together := _uses_partner(args)
	if not _can_use_tile_action_before_base(action_id):
		result = _fail(_pre_base_restriction_text(action_id))
		emit_signal("action_resolved", result)
		return result
	match action_id:
		"move":
			result = _move_to_region(String(args.get("target_region_id", "")))
		"investigate":
			result = _investigate_region(GameState.current_region_id, together)
		"gather":
			result = _gather_region(GameState.current_region_id, together)
		"fish":
			result = _fish_region(GameState.current_region_id, together)
		"rest":
			result = _rest_region(together, int(args.get("rest_minutes", 30)))
		"develop":
			result = _develop_region(GameState.current_region_id, together)
		"wash":
			result = _wash_tile(current_tile_id, together)
		_:
			result = _fail("알 수 없는 행동이다.")
	if bool(result.get("ok", false)):
		result["together"] = together
	emit_signal("action_resolved", result)
	return result


func consume_world_messages() -> Array[String]:
	var messages: Array[String] = []
	for message in pending_world_messages:
		messages.append(String(message))
	pending_world_messages.clear()
	return messages


func recover_daily_resources(weather_text: String = "") -> void:
	var daily_weather := weather_text
	if daily_weather == "":
		daily_weather = GameState.weather
	var changed_tiles := 0
	var extra_water_tiles := 0
	var storm_debris_tiles := 0
	var storm_depleted_tiles := 0
	var washed_item_count := 0
	var damaged_trap_count := 0
	for region in regions.values():
		for item_id in region.resource_maximums.keys():
			var max_amount := int(region.resource_maximums[item_id])
			var current := int(region.resource_capacity.get(item_id, 0))
			if current < max_amount:
				region.resource_capacity[item_id] = mini(max_amount, current + 1)
	for tile in tiles.values():
		if not bool(tile.get("playable", false)):
			continue
		var resources: Dictionary = tile.get("resources", {})
		var maximums: Dictionary = tile.get("resource_maximums", {})
		for item_id in maximums.keys():
			var tile_max_amount := int(maximums[item_id])
			var tile_current := int(resources.get(item_id, 0))
			if tile_current < tile_max_amount:
				resources[item_id] = mini(tile_max_amount, tile_current + 1)
				changed_tiles += 1
		tile["resources"] = resources
		var animal_maximums := int(tile.get("animal_maximums", 0))
		var animals := int(tile.get("animals", 0))
		if animals < animal_maximums:
			tile["animals"] = mini(animal_maximums, animals + 1)
		_resolve_tile_traps_daily(tile)
		_prune_tile_memory_flags(tile)
		var weather_result := _apply_daily_weather_to_tile(tile, daily_weather)
		extra_water_tiles += int(weather_result.get("extra_water", 0))
		storm_debris_tiles += int(weather_result.get("storm_debris", 0))
		storm_depleted_tiles += int(weather_result.get("storm_depleted", 0))
		washed_item_count += int(weather_result.get("washed_items", 0))
		damaged_trap_count += int(weather_result.get("damaged_traps", 0))
		if _weather_is_rainy(daily_weather):
			_add_tile_memory_to_tile(tile, "wet_ground", 1)
	if changed_tiles > 0:
		pending_world_messages.append("밤사이 섬의 자원이 조금 되살아났다.")
	if extra_water_tiles > 0:
		pending_world_messages.append("비가 고인 곳이 생겨 물을 찾기 쉬워졌다. (%d곳)" % extra_water_tiles)
	if storm_debris_tiles > 0:
		pending_world_messages.append("거센 파도가 표류물을 밀어 올렸다. (%d곳)" % storm_debris_tiles)
	if storm_depleted_tiles > 0:
		pending_world_messages.append("폭풍이 얕은 채집지를 쓸고 지나가 필드 자원이 줄었다. (%d곳)" % storm_depleted_tiles)
	if washed_item_count > 0:
		pending_world_messages.append("물살에 현장에 둔 물건 일부가 쓸려갔다. (%d개)" % washed_item_count)
	if damaged_trap_count > 0:
		pending_world_messages.append("나쁜 날씨에 덫 일부가 망가졌다. (%d개)" % damaged_trap_count)
	emit_signal("regions_changed")


func describe_region(region_id: String) -> String:
	var region = get_region(region_id)
	if region == null:
		return "알 수 없는 지역"
	var resource_parts: Array[String] = []
	for item_id in region.resource_capacity.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		resource_parts.append("%s %d" % [display_name, int(region.resource_capacity[item_id])])
	if resource_parts.is_empty():
		resource_parts.append("남은 자원 없음")
	return "%s\n%s\n조사도 %d / 개발도 %d / 위험도 %d\n남은 자원: %s" % [
		region.display_name,
		region.description,
		region.investigation,
		region.development,
		region.danger_level,
		_join_strings(resource_parts, ", ")
	]


func get_save_data() -> Dictionary:
	var region_data := {}
	for region_id in regions.keys():
		region_data[region_id] = regions[region_id].to_dictionary()
	var tile_data := {}
	for tile_id in tiles.keys():
		var tile: Dictionary = tiles[tile_id]
		if bool(tile.get("playable", false)):
			tile_data[tile_id] = {
				"investigation": int(tile.get("investigation", 0)),
				"development": int(tile.get("development", 0)),
				"resources": tile.get("resources", {}).duplicate(true),
				"field_items": tile.get("field_items", {}).duplicate(true),
				"resource_objects": tile.get("resource_objects", {}).duplicate(true),
				"animals": int(tile.get("animals", 0)),
				"traps": tile.get("traps", {}).duplicate(true),
				"map_mark": String(tile.get("map_mark", "")),
				"memory_flags": tile.get("memory_flags", {}).duplicate(true)
			}
	return {
		"regions": region_data,
		"visited_regions": visited_regions.duplicate(true),
		"tiles": tile_data,
		"revealed_tiles": revealed_tiles.duplicate(true),
		"investigated_tiles": investigated_tiles.duplicate(true),
		"current_tile_id": current_tile_id
	}


func load_save_data(data: Dictionary) -> void:
	reset_state()
	var stored_regions: Dictionary = data.get("regions", {})
	for region_id in stored_regions.keys():
		var region = get_region(String(region_id))
		if region != null:
			region.apply_dictionary(stored_regions[region_id])
	visited_regions = data.get("visited_regions", {"beach": true}).duplicate(true)
	visited_regions[GameState.current_region_id] = true
	var stored_tiles: Dictionary = data.get("tiles", {})
	for tile_id in stored_tiles.keys():
		var tile = get_tile(String(tile_id))
		if tile == null:
			continue
		var stored: Dictionary = stored_tiles[tile_id]
		tile["investigation"] = int(stored.get("investigation", tile.get("investigation", 0)))
		tile["development"] = int(stored.get("development", tile.get("development", 0)))
		tile["resources"] = stored.get("resources", tile.get("resources", {})).duplicate(true)
		tile["field_items"] = stored.get("field_items", tile.get("field_items", {})).duplicate(true)
		tile["resource_objects"] = stored.get("resource_objects", tile.get("resource_objects", {})).duplicate(true)
		tile["animals"] = int(stored.get("animals", tile.get("animals", 0)))
		tile["traps"] = stored.get("traps", tile.get("traps", {})).duplicate(true)
		tile["map_mark"] = String(stored.get("map_mark", tile.get("map_mark", "")))
		tile["memory_flags"] = stored.get("memory_flags", tile.get("memory_flags", {})).duplicate(true)
	revealed_tiles = data.get("revealed_tiles", revealed_tiles).duplicate(true)
	investigated_tiles = data.get("investigated_tiles", investigated_tiles).duplicate(true)
	for tile_id in investigated_tiles.keys():
		var investigated_tile = get_tile(String(tile_id))
		if investigated_tile != null and Dictionary(investigated_tile.get("resource_objects", {})).is_empty():
			_discover_tile_resource_objects(investigated_tile)
	current_tile_id = String(data.get("current_tile_id", current_tile_id))
	var current_tile = get_tile(current_tile_id)
	if current_tile != null:
		GameState.set_current_region(String(current_tile.get("region_id", "beach")))
	emit_signal("regions_changed")


func _build_tile_map() -> void:
	tiles.clear()
	var terrain_layout := [
		["ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean"],
		["ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean"],
		["ocean", "ocean", "cave", "hill", "forest", "forest", "ruins", "hill", "ocean", "ocean"],
		["ocean", "ocean", "hill", "forest", "forest", "meadow", "ruins", "river", "ocean", "ocean"],
		["ocean", "ocean", "meadow", "meadow", "forest", "meadow", "river", "river", "ocean", "ocean"],
		["ocean", "ocean", "beach", "meadow", "meadow", "forest", "river", "marsh", "ocean", "ocean"],
		["ocean", "ocean", "beach", "cave", "meadow", "forest", "meadow", "marsh", "ocean", "ocean"],
		["ocean", "ocean", "beach", "beach", "meadow", "meadow", "forest", "river", "ocean", "ocean"],
		["ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean"],
		["ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean", "ocean"]
	]
	for y in range(TILE_MAP_SIZE):
		for x in range(TILE_MAP_SIZE):
			var terrain := String(terrain_layout[y][x])
			var playable := x >= PLAYABLE_MIN and x <= PLAYABLE_MAX and y >= PLAYABLE_MIN and y <= PLAYABLE_MAX
			tiles[_tile_id(x, y)] = _make_tile(x, y, terrain, playable)


func _make_tile(x: int, y: int, terrain: String, playable: bool) -> Dictionary:
	var tile := {
		"id": _tile_id(x, y),
		"x": x,
		"y": y,
		"terrain": terrain,
		"playable": playable,
		"region_id": _terrain_region_id(terrain),
		"display_name": _terrain_display_name(terrain),
		"description": _terrain_description(terrain),
		"image_path": "res://assets/tiles/region_hex/tile_%d_%d.png" % [x, y],
		"fog_path": "res://assets/tiles/region_hex/fog_tile.png",
		"danger": _terrain_danger(terrain),
		"investigation": 0,
		"development": 0,
		"resources": _terrain_resources(terrain),
		"resource_maximums": _terrain_resources(terrain),
		"field_items": {},
		"resource_objects": {},
		"animals": _terrain_animals(terrain),
		"animal_maximums": _terrain_animals(terrain),
		"traps": {},
		"map_mark": "",
		"memory_flags": {},
		"allowed_actions": _terrain_actions(terrain),
		"is_base": terrain == "cave" and x == 3 and y == 6,
		"movement_blocked": _tile_blocked_note(x, y, terrain) != "",
		"access_note": _tile_blocked_note(x, y, terrain)
	}
	if bool(tile.get("movement_blocked", false)):
		tile["allowed_actions"] = []
	if bool(tile.get("is_base", false)):
		var actions: Array = tile.get("allowed_actions", [])
		if not actions.has("wash"):
			actions.append("wash")
		tile["allowed_actions"] = actions
		tile["field_items"] = {"wood": 2, "palm_frond": 1}
	return tile


func _move_to_tile(target_tile_id: String) -> Dictionary:
	if target_tile_id == "":
		return _fail("이동할 타일을 선택해야 한다.")
	if not is_tile_clickable(target_tile_id):
		var access_note := get_tile_access_note(target_tile_id, current_tile_id)
		if access_note != "":
			return _fail(access_note)
		return _fail("아직 조작할 수 없는 타일이다.")
	if target_tile_id != current_tile_id and not is_tile_adjacent_to_current(target_tile_id):
		return _fail("인접한 타일로만 이동할 수 있다.")
	if target_tile_id == current_tile_id:
		return _fail("이미 이 타일에 있다.")
	if not _pay_cost(6, 1, false, "move"):
		return _fail("이동할 기력 또는 시간이 부족하다.")
	current_tile_id = target_tile_id
	revealed_tiles[current_tile_id] = true
	CharacterManager.sync_partner_tile(current_tile_id)
	var tile = get_tile(current_tile_id)
	if tile != null:
		GameState.set_current_region(String(tile.get("region_id", "beach")))
		mark_region_visited(String(tile.get("region_id", "beach")))
		emit_signal("regions_changed")
		return _finish_tile_action(tile, "%s 타일로 이동했다." % String(tile.get("display_name", "지역")), "move", {}, false)
	return _fail("이동한 타일 정보를 찾을 수 없다.")


func _investigate_tile(tile_id: String, together: bool) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("조사할 타일을 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("investigate"):
		return _fail("이 타일은 조사할 수 없다.")
	if not can_investigate_tile(tile_id):
		return _fail("이 지역은 이미 충분히 살펴봤다.")
	if not _pay_cost(12, 2, together, "investigate"):
		return _fail("조사할 기력 또는 시간이 부족하다.")
	var first_investigation := not is_tile_investigated(tile_id)
	var gain := randi_range(10, 16) + CharacterManager.get_partner_action_bonus("investigate", together)
	tile["investigation"] = clampi(int(tile.get("investigation", 0)) + gain, 0, 100)
	investigated_tiles[tile_id] = true
	var revealed_now := reveal_adjacent_tiles(tile_id) if first_investigation else []
	var discovery_target := 2 if first_investigation else _target_resource_object_count_for_investigation(tile)
	var discovered_objects := _discover_tile_resource_objects(tile, discovery_target)
	if first_investigation:
		_add_tile_memory_to_tile(tile, "first_survey", 0)
	if not discovered_objects.is_empty():
		_add_tile_memory_to_tile(tile, "found_objects", 0)
	emit_signal("regions_changed")
	var action_name := "조사" if first_investigation else "정밀조사"
	var text := "%s 타일을 %s했다. 조사도 +%d" % [String(tile.get("display_name", "지역")), action_name, gain]
	if first_investigation:
		if revealed_now.is_empty():
			text += "\n새로 걷힌 안개는 없다."
		else:
			text += "\n인접한 타일 %d곳의 안개가 걷혔다." % revealed_now.size()
	elif discovered_objects.is_empty():
		text += "\n지형과 흔적을 더 정확히 파악했다. 이후 채집 성과가 조금 안정된다."
	if not discovered_objects.is_empty():
		text += "\n발견: %s" % _join_strings(discovered_objects, ", ")
	if int(tile.get("investigation", 0)) >= 100:
		_add_tile_memory_to_tile(tile, "fully_surveyed", 0)
		text += "\n이 지역은 충분히 파악했다."
	return _finish_tile_action(tile, text, "investigate", {}, together)


func _gather_tile(tile_id: String, together: bool, method_id: String = "") -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("채집할 타일을 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("gather"):
		return _fail("이 타일에서는 채집할 수 없다.")
	var resources: Dictionary = tile.get("resources", {})
	var available: Array[String] = []
	for item_id in resources.keys():
		if item_id != "fish" and int(resources[item_id]) > 0:
			available.append(String(item_id))
	if available.is_empty():
		return _fail("남은 채집 자원이 없다.")
	var method := _normalized_action_method("gather", method_id)
	var cost := _action_method_base_cost("gather", method, {"stamina": 16, "time": 2})
	if not _pay_cost(int(cost.get("stamina", 16)), int(cost.get("time", 2)), together, "gather"):
		return _fail("채집할 기력 또는 시간이 부족하다.")
	var gathered: Dictionary = {}
	var field_leftovers: Dictionary = {}
	var attempts := _gather_attempt_count(
		int(tile.get("investigation", 0)),
		int(tile.get("development", 0)),
		String(tile.get("terrain", "")),
		together
	)
	attempts = maxi(1, attempts + _action_method_attempt_delta("gather", method))
	for index in range(attempts):
		if available.is_empty():
			break
		var item_id := _pick_gather_item(available, String(tile.get("terrain", "")))
		var amount := _resource_yield_amount(
			item_id,
			int(tile.get("investigation", 0)),
			int(tile.get("development", 0)),
			String(tile.get("terrain", "")),
			together
		)
		amount = mini(amount, int(resources[item_id]))
		resources[item_id] = int(resources[item_id]) - amount
		if int(resources[item_id]) <= 0:
			available.erase(item_id)
		var carried := InventoryManager.add_item_to_party(item_id, amount, together)
		if carried > 0:
			gathered[item_id] = int(gathered.get(item_id, 0)) + carried
		var leftover := amount - carried
		if leftover > 0:
			_add_field_item_to_tile(tile, item_id, leftover)
			field_leftovers[item_id] = int(field_leftovers.get(item_id, 0)) + leftover
	tile["resources"] = resources
	if not gathered.is_empty() or not field_leftovers.is_empty():
		_add_tile_memory_to_tile(tile, "fresh_gather", 1)
	if available.is_empty():
		_add_tile_memory_to_tile(tile, "picked_over", 1)
	emit_signal("regions_changed")
	var note := _gather_note_for_tile(tile, gathered)
	note += _action_method_result_note("gather", method)
	if not field_leftovers.is_empty():
		note += "\n짐이 무거워 %s은/는 이 타일에 내려두었다." % _format_items(field_leftovers)
	return _finish_tile_action(tile, "채집 결과: %s%s" % [_format_items(gathered), note], "gather", gathered, together)


func _fish_tile(tile_id: String, together: bool, method_id: String = "", minigame_result: Dictionary = {}) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("낚시할 타일을 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("fish"):
		return _fail("이 타일에서는 낚시할 수 없다.")
	var resources: Dictionary = tile.get("resources", {})
	if int(resources.get("fish", 0)) <= 0:
		return _fail("잡을 수 있는 물고기가 보이지 않는다.")
	if not InventoryManager.has_usable_tool_with_effect("fish_action"):
		return _fail("낚시하려면 낚싯대가 필요하다.")
	var method := _normalized_action_method("fish", method_id)
	var cost := _action_method_base_cost("fish", method, {"stamina": 14, "time": 2})
	if not _pay_cost(int(cost.get("stamina", 14)), int(cost.get("time", 2)), together, "fish"):
		return _fail("낚시할 기력 또는 시간이 부족하다.")
	InventoryManager.apply_best_tool_wear("fish_action", 1)
	var chance := 52 + int(tile.get("investigation", 0)) / 3
	chance += InventoryManager.get_item_effect_max("fish_action") * 8
	if together:
		chance += 10
	chance += BaseManager.get_fishing_bonus()
	if GameState.weather == "비":
		chance += 8
	elif GameState.weather == "폭우":
		chance -= 8
	elif GameState.weather == "폭풍":
		chance -= 20
	chance += _action_method_chance_delta("fish", method)
	var minigame_score := _action_minigame_score(minigame_result)
	chance += _action_minigame_chance_delta(minigame_score)
	if minigame_score < 25:
		chance -= 12
	chance = clampi(chance, 15, 90)
	var caught := 0
	if randi_range(1, 100) <= chance:
		caught = 1
		if together and randi_range(1, 100) <= 35:
			caught += 1
		if BaseManager.get_fishing_bonus() > 0 and randi_range(1, 100) <= 45:
			caught += 1
		if minigame_score >= 85 and randi_range(1, 100) <= 45:
			caught += 1
	caught = mini(caught, int(resources.get("fish", 0)))
	var gathered: Dictionary = {}
	var text := "낚싯줄을 드리웠지만 빈손으로 돌아왔다."
	if caught > 0:
		resources["fish"] = int(resources.get("fish", 0)) - caught
		tile["resources"] = resources
		var carried := InventoryManager.add_item_to_party("fish", caught, together)
		if carried > 0:
			gathered["fish"] = carried
		var leftover := caught - carried
		if leftover > 0:
			_add_field_item_to_tile(tile, "fish", leftover)
		text = "낚시 결과: 생선 x%d" % caught
		if leftover > 0:
			text += "\n짐이 무거워 생선 x%d은/는 이 타일에 내려두었다." % leftover
	if caught > 0:
		_add_tile_memory_to_tile(tile, "fishing_spot", 2)
	emit_signal("regions_changed")
	text += _action_method_result_note("fish", method)
	text += _action_minigame_result_note("fish", minigame_result)
	var result := _finish_tile_action(tile, text, "fish", gathered, together)
	return _attach_action_minigame_result(result, "fish", minigame_result)


func _hunt_tile(tile_id: String, together: bool, method_id: String = "", minigame_result: Dictionary = {}) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("사냥할 타일을 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("hunt"):
		return _fail("이 타일에서는 사냥할 만한 흔적이 없다.")
	if not is_tile_investigated(tile_id):
		return _fail("먼저 지역을 조사해 동물 흔적을 파악해야 한다.")
	if int(tile.get("animals", 0)) <= 0:
		return _fail("오늘은 쫓을 만한 흔적이 보이지 않는다.")
	if not InventoryManager.has_usable_tool_with_effect("hunt_action"):
		return _fail("사냥하려면 창이나 활 같은 사냥 도구가 필요하다.")
	var method := _normalized_action_method("hunt", method_id)
	var cost := _action_method_base_cost("hunt", method, {"stamina": 26, "time": 4})
	if not _pay_cost(int(cost.get("stamina", 26)), int(cost.get("time", 4)), together, "hunt"):
		return _fail("사냥할 기력 또는 시간이 부족하다.")
	InventoryManager.apply_best_tool_wear("hunt_action", 2 if method == "drive" else 1)
	var chance := _hunt_success_chance(tile, together) + _action_method_chance_delta("hunt", method)
	chance += InventoryManager.get_item_effect_max("hunt_action") * 9
	var minigame_score := _action_minigame_score(minigame_result)
	chance += _action_minigame_chance_delta(minigame_score)
	if minigame_score < 25:
		chance -= 15
	chance = clampi(chance, 5, 92)
	var gathered: Dictionary = {}
	var text := "숨을 죽이고 흔적을 쫓았지만 잡을 수 있는 거리를 놓쳤다."
	if randi_range(1, 100) <= chance:
		var meat := 1
		if int(tile.get("investigation", 0)) >= 60:
			meat += 1
		if together and randi_range(1, 100) <= 35:
			meat += 1
		if method == "drive" and randi_range(1, 100) <= 45:
			meat += 1
		if minigame_score >= 85 and randi_range(1, 100) <= 35:
			meat += 1
		tile["animals"] = maxi(0, int(tile.get("animals", 0)) - 1)
		var hide_chance := 35
		if minigame_score >= 85:
			hide_chance += 20
		elif minigame_score < 35:
			hide_chance -= 15
		gathered = _add_hunted_items_to_party(tile, {"raw_meat": meat, "animal_hide": 1 if randi_range(1, 100) <= hide_chance else 0}, together)
		text = "흔적을 따라가 작은 짐승을 잡았다: %s" % _format_items(gathered)
	else:
		var scare_chance := 12 if method == "track" else 25
		if method == "drive":
			scare_chance = 40
		if minigame_score < 35:
			scare_chance += 18
		if randi_range(1, 100) <= scare_chance:
			tile["animals"] = maxi(0, int(tile.get("animals", 0)) - 1)
	if not gathered.is_empty():
		_add_tile_memory_to_tile(tile, "hunt_success", 2)
	else:
		_add_tile_memory_to_tile(tile, "animal_tracks", 1)
	emit_signal("regions_changed")
	text += _action_method_result_note("hunt", method)
	text += _action_minigame_result_note("hunt", minigame_result)
	var result := _finish_tile_action(tile, text, "hunt", gathered, together)
	return _attach_action_minigame_result(result, "hunt", minigame_result)


func _set_trap_tile(tile_id: String, together: bool, method_id: String = "") -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("덫을 놓을 타일을 찾을 수 없다.")
	if not can_set_trap_on_tile(tile_id):
		return _fail("이곳에는 지금 덫을 놓기 어렵다.")
	if InventoryManager.get_count("snare_trap") <= 0:
		return _fail("설치할 덫이 없다.")
	var method := _normalized_action_method("set_trap", method_id)
	var cost := _action_method_base_cost("set_trap", method, {"stamina": 8, "time": 1})
	if not _pay_cost(int(cost.get("stamina", 8)), int(cost.get("time", 1)), together, "set_trap"):
		return _fail("덫을 놓을 기력 또는 시간이 부족하다.")
	if not InventoryManager.remove_item("snare_trap", 1):
		return _fail("설치할 덫이 없다.")
	var traps: Dictionary = tile.get("traps", {})
	var trap_id := "snare_%d_%d" % [GameState.day, traps.size()]
	traps[trap_id] = {
		"id": trap_id,
		"item_id": "snare_trap",
		"placed_day": GameState.day,
		"state": "set",
		"caught_items": {},
		"checks": 0,
		"method_id": method,
		"catch_bonus": _trap_method_catch_bonus(method)
	}
	tile["traps"] = traps
	_add_tile_memory_to_tile(tile, "trap_set", 0)
	emit_signal("regions_changed")
	var text := "동물 흔적이 지나는 길목에 덫을 숨겨 두었다. 하루가 지나면 확인해볼 수 있다.%s" % _action_method_result_note("set_trap", method)
	return _finish_tile_action(tile, text, "set_trap", {}, together)


func _check_trap_tile(tile_id: String, together: bool) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("확인할 덫을 찾을 수 없다.")
	var traps: Dictionary = tile.get("traps", {})
	if traps.is_empty():
		return _fail("이 타일에는 확인할 덫이 없다.")
	if not _pay_cost(4, 1, together, "check_trap"):
		return _fail("덫을 확인할 기력 또는 시간이 부족하다.")
	_resolve_tile_traps_daily(tile)
	traps = tile.get("traps", {})
	var gathered: Dictionary = {}
	var checked := 0
	var caught_count := 0
	for trap_id in traps.keys():
		var trap: Dictionary = traps[trap_id]
		checked += 1
		trap["checks"] = int(trap.get("checks", 0)) + 1
		if String(trap.get("state", "set")) == "caught":
			var caught_items: Dictionary = trap.get("caught_items", {})
			var added := _add_hunted_items_to_party(tile, caught_items, together)
			for item_id in added.keys():
				gathered[item_id] = int(gathered.get(item_id, 0)) + int(added[item_id])
			trap["state"] = "set"
			trap["caught_items"] = {}
			trap["placed_day"] = GameState.day
			caught_count += 1
		traps[trap_id] = trap
	tile["traps"] = traps
	if caught_count > 0:
		_add_tile_memory_to_tile(tile, "trap_catch", 1)
	emit_signal("regions_changed")
	var text := "덫 %d개를 확인했다." % checked
	if caught_count > 0:
		text += "\n걸린 먹잇감에서 %s을 얻었다." % _format_items(gathered)
	else:
		text += "\n아직 걸린 것은 없었다. 덫은 그대로 다시 숨겨 두었다."
	return _finish_tile_action(tile, text, "check_trap", gathered, together)


func _develop_tile(tile_id: String, together: bool) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("개발할 타일을 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("develop"):
		return _fail("이 타일은 개발할 수 없다.")
	var requirements := get_tile_development_requirements(tile_id)
	if not InventoryManager.has_items(requirements):
		return _fail("정비 재료가 부족하다. 필요: %s" % _format_items(requirements))
	if not _pay_cost(24, 4, together, "develop"):
		return _fail("개발할 기력 또는 시간이 부족하다.")
	InventoryManager.consume_items(requirements)
	var gain := randi_range(8, 12)
	if together:
		gain += 3
	tile["development"] = clampi(int(tile.get("development", 0)) + gain, 0, 100)
	_add_tile_memory_to_tile(tile, "worked_ground", 2)
	if int(tile.get("development", 0)) >= 100:
		_add_tile_memory_to_tile(tile, "developed", 0)
	emit_signal("regions_changed")
	return _finish_tile_action(tile, "%s 타일의 개발도 +%d\n소모: %s" % [String(tile.get("display_name", "지역")), gain, _format_items(requirements)], "develop", {}, together)


func _wash_tile(tile_id: String, together: bool) -> Dictionary:
	var tile = get_tile(tile_id)
	if tile == null:
		return _fail("씻을 장소를 찾을 수 없다.")
	if not Array(tile.get("allowed_actions", [])).has("wash"):
		return _fail("이 타일에서는 몸을 씻기 어렵다.")
	if not _pay_cost(4, 1, together, "wash"):
		return _fail("씻을 기력 또는 시간이 부족하다.")
	var metabolism_messages := CharacterManager.consume_status_messages()
	var terrain := String(tile.get("terrain", ""))
	var source_label := "물가"
	var hygiene_gain := 18
	if terrain == "river":
		source_label = "강가"
		hygiene_gain = 24
	elif terrain == "beach":
		source_label = "해변 물가"
		hygiene_gain = 16
	elif terrain == "marsh":
		source_label = "얕은 습지"
		hygiene_gain = 14
	elif bool(tile.get("is_base", false)):
		source_label = "거점의 물"
		hygiene_gain = 18 + int(BaseManager.stats.get("hygiene", 0)) * 3 + int(BaseManager.stats.get("water_supply", 0)) * 2
	var text := CharacterManager.wash_up(together, source_label, hygiene_gain)
	if not metabolism_messages.is_empty():
		text += "\n" + _join_strings(metabolism_messages, "\n")
	var result := _ok(text, "wash", {})
	result["tile_id"] = String(tile.get("id", current_tile_id))
	return result


func _enter_base_tile() -> Dictionary:
	var tile = get_current_tile()
	if tile != null and bool(tile.get("is_base", false)):
		GameState.set_flag("entered_base", true)
	if tile == null or not bool(tile.get("is_base", false)):
		return _fail("이 타일에는 진입할 수 있는 거점이 없다.")
	return _ok("동굴 거점으로 진입했다.", "enter_base")


func _finish_tile_action(tile: Dictionary, base_text: String, action_id: String, items: Dictionary = {}, together: bool = false) -> Dictionary:
	var text := base_text
	_apply_result_tool_wear(action_id, items)
	var status_messages := CharacterManager.consume_status_messages()
	if not status_messages.is_empty():
		text += "\n" + _join_strings(status_messages, "\n")
	var item_messages := InventoryManager.consume_item_messages()
	if not item_messages.is_empty():
		text += "\n" + _join_strings(item_messages, "\n")
	var aftereffects := CharacterManager.apply_action_aftereffects(
		action_id,
		String(tile.get("display_name", "지역")),
		int(tile.get("danger", 0)),
		GameState.weather,
		together
	)
	if not aftereffects.is_empty():
		text += "\n" + _join_strings(aftereffects, "\n")
	var shelter_hint := _pre_base_shelter_hint(action_id, tile)
	if shelter_hint != "":
		text += "\n" + shelter_hint
	var result := _ok(text, action_id, items)
	result["tile_id"] = String(tile.get("id", current_tile_id))
	return result


func _move_to_region(target_region_id: String) -> Dictionary:
	if target_region_id == "":
		return _fail("이동할 지역을 선택해야 한다.")
	var current = get_current_region()
	if current == null:
		return _fail("현재 지역 정보를 찾을 수 없다.")
	if not current.connected_regions.has(target_region_id):
		return _fail("인접한 지역으로만 이동할 수 있다.")
	if not _pay_cost(6, 1, false, "move"):
		return _fail("이동할 기력 또는 시간이 부족하다.")
	GameState.set_current_region(target_region_id)
	mark_region_visited(target_region_id)
	var target = get_region(target_region_id)
	return _finish_action(target, "%s으로 이동했다." % target.display_name, "move", {}, false)


func _investigate_region(region_id: String, together: bool) -> Dictionary:
	var region = get_region(region_id)
	if region == null:
		return _fail("조사할 지역을 찾을 수 없다.")
	if not region.allowed_actions.has("investigate"):
		return _fail("이 지역에서는 조사할 수 없다.")
	if not _pay_cost(12, 2, together, "investigate"):
		return _fail("조사할 기력 또는 시간이 부족하다.")
	var gain := randi_range(8, 14)
	if together and CharacterManager.partner_status.trust >= 10:
		gain += 2
	gain += CharacterManager.get_partner_action_bonus("investigate", together)
	region.investigation = clampi(region.investigation + gain, 0, 100)
	emit_signal("regions_changed")
	return _finish_action(region, "%s을/를 조사했다. 조사도 +%d" % [region.display_name, gain], "investigate", {}, together)


func _gather_region(region_id: String, together: bool) -> Dictionary:
	var region = get_region(region_id)
	if region == null:
		return _fail("채집할 지역을 찾을 수 없다.")
	if not region.allowed_actions.has("gather"):
		return _fail("이 지역에서는 채집할 수 없다.")
	var available: Array[String] = []
	for item_id in region.resource_capacity.keys():
		if int(region.resource_capacity[item_id]) > 0:
			available.append(String(item_id))
	if available.is_empty():
		return _fail("남은 자원이 거의 없다. 하루가 지나면 조금 회복된다.")
	if not _pay_cost(16, 2, together, "gather"):
		return _fail("채집할 기력 또는 시간이 부족하다.")
	var gathered: Dictionary = {}
	var attempts := _gather_attempt_count(region.investigation, region.development, region.region_type, together)
	for index in range(attempts):
		if available.is_empty():
			break
		var item_id: String = _pick_gather_item(available, region.region_type)
		var amount := _resource_yield_amount(
			item_id,
			region.investigation,
			region.development,
			region.region_type,
			together
		)
		amount = mini(amount, int(region.resource_capacity[item_id]))
		region.resource_capacity[item_id] = int(region.resource_capacity[item_id]) - amount
		if int(region.resource_capacity[item_id]) <= 0:
			available.erase(item_id)
		var carried := InventoryManager.add_item_to_party(item_id, amount, together)
		if carried > 0:
			gathered[item_id] = int(gathered.get(item_id, 0)) + carried
		var leftover := amount - carried
		if leftover > 0:
			region.resource_capacity[item_id] = int(region.resource_capacity.get(item_id, 0)) + leftover
	emit_signal("regions_changed")
	var parts: Array[String] = []
	for item_id in gathered.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		parts.append("%s x%d" % [display_name, int(gathered[item_id])])
	return _finish_action(region, "채집 결과: %s%s" % [_join_strings(parts, ", "), _gather_note_for_values(region.investigation, region.development)], "gather", gathered, together)


func _fish_region(region_id: String, together: bool) -> Dictionary:
	var region = get_region(region_id)
	if region == null:
		return _fail("낚시할 지역을 찾을 수 없다.")
	if not region.allowed_actions.has("fish"):
		return _fail("이 지역에서는 낚시할 수 없다.")
	if int(region.resource_capacity.get("fish", 0)) <= 0:
		return _fail("오늘은 잡을 수 있는 물고기가 거의 보이지 않는다.")
	if not InventoryManager.has_usable_tool_with_effect("fish_action"):
		return _fail("낚시하려면 낚싯대가 필요하다.")
	if not _pay_cost(14, 2, together, "fish"):
		return _fail("낚시할 기력 또는 시간이 부족하다.")
	InventoryManager.apply_best_tool_wear("fish_action", 1)
	var chance := 55 + int(region.investigation / 3)
	chance += InventoryManager.get_item_effect_max("fish_action") * 8
	if together:
		chance += 10
	chance += BaseManager.get_fishing_bonus()
	if GameState.weather == "비":
		chance += 8
	elif GameState.weather == "폭우":
		chance -= 8
	elif GameState.weather == "폭풍":
		chance -= 20
	chance = clampi(chance, 15, 90)
	var caught := 0
	if randi_range(1, 100) <= chance:
		caught = 1
		if together and randi_range(1, 100) <= 35:
			caught += 1
		if BaseManager.get_fishing_bonus() > 0 and randi_range(1, 100) <= 45:
			caught += 1
	caught = mini(caught, int(region.resource_capacity.get("fish", 0)))
	var gathered: Dictionary = {}
	var message := "낚싯줄을 드리웠지만 빈손으로 돌아왔다."
	if caught > 0:
		region.resource_capacity["fish"] = int(region.resource_capacity.get("fish", 0)) - caught
		var carried := InventoryManager.add_item_to_party("fish", caught, together)
		if carried > 0:
			gathered["fish"] = carried
		var leftover := caught - carried
		if leftover > 0:
			region.resource_capacity["fish"] = int(region.resource_capacity.get("fish", 0)) + leftover
		message = "낚시 결과: 생선 x%d" % caught
	emit_signal("regions_changed")
	return _finish_action(region, message, "fish", gathered, together)


func _rest_region(together: bool, minutes: int = 30) -> Dictionary:
	var rest_minutes := clampi(minutes, 15, 120)
	rest_minutes = clampi(int(round(float(rest_minutes) / 15.0)) * 15, 15, 120)
	if not GameState.can_spend_minutes(rest_minutes):
		return _fail("오늘은 더 행동할 시간이 없다.")
	if not GameState.spend_minutes(rest_minutes):
		return _fail("쉴 시간이 부족하다.")
	var metabolism_slots := maxi(1, int(ceil(float(rest_minutes) / float(GameState.MINUTES_PER_ACTION_SLOT))))
	CharacterManager.apply_action_metabolism("rest", metabolism_slots, 0, false)
	var metabolism_messages := CharacterManager.consume_status_messages()
	var message := CharacterManager.recover_rest(together, rest_minutes)
	if not metabolism_messages.is_empty():
		message += "\n" + _join_strings(metabolism_messages, "\n")
	var result := _ok(message, "rest")
	result["rest_minutes"] = rest_minutes
	return result


func _develop_region(region_id: String, together: bool) -> Dictionary:
	var region = get_region(region_id)
	if region == null:
		return _fail("개발할 지역을 찾을 수 없다.")
	if not region.allowed_actions.has("develop"):
		return _fail("이 지역은 아직 개발할 수 없다.")
	var requirements := get_region_development_requirements(region_id)
	if not InventoryManager.has_items(requirements):
		return _fail("정비 재료가 부족하다. 필요: %s" % _format_items(requirements))
	if not _pay_cost(24, 4, together, "develop"):
		return _fail("개발할 기력 또는 시간이 부족하다.")
	InventoryManager.consume_items(requirements)
	var gain := randi_range(8, 12)
	if together:
		gain += 3
	region.development = clampi(region.development + gain, 0, 100)
	emit_signal("regions_changed")
	return _finish_action(region, "%s의 개발도 +%d\n소모: %s" % [region.display_name, gain, _format_items(requirements)], "develop", {}, together)


func _action_minigame_score(minigame_result: Dictionary) -> int:
	if minigame_result.is_empty():
		return 50
	return clampi(int(minigame_result.get("score", 50)), 0, 100)


func _action_minigame_chance_delta(score: int) -> int:
	return int(round(float(score - 50) * 0.55))


func _action_minigame_result_note(action_id: String, minigame_result: Dictionary) -> String:
	if minigame_result.is_empty():
		return ""
	var score := _action_minigame_score(minigame_result)
	var grade_text := String(minigame_result.get("grade_text", "보통"))
	var mistakes := int(minigame_result.get("mistakes", 0))
	var state_text := String(minigame_result.get("state_text", ""))
	if state_text != "":
		state_text = " / %s" % state_text
	if action_id == "fish":
		return "\n낚시 집중: %s (%d, 실수 %d%s)" % [grade_text, score, mistakes, state_text]
	if action_id == "hunt":
		return "\n사냥 집중: %s (%d, 실수 %d%s)" % [grade_text, score, mistakes, state_text]
	return "\n집중 판정: %s (%d, 실수 %d%s)" % [grade_text, score, mistakes, state_text]


func _attach_action_minigame_result(result: Dictionary, action_id: String, minigame_result: Dictionary) -> Dictionary:
	if minigame_result.is_empty():
		return result
	var score := _action_minigame_score(minigame_result)
	var grade_text := String(minigame_result.get("grade_text", "보통"))
	result["minigame_score"] = score
	result["minigame_grade"] = String(minigame_result.get("grade", "normal"))
	result["minigame_grade_text"] = grade_text
	result["minigame_mistakes"] = int(minigame_result.get("mistakes", 0))
	result["cutin_text"] = "%s 집중: %s" % ["낚시" if action_id == "fish" else "사냥", grade_text]
	return result


func _normalized_action_method(action_id: String, method_id: String) -> String:
	var options := {
		"gather": ["careful", "wide", "quick"],
		"fish": ["patient", "quick", "quiet"],
		"hunt": ["track", "drive", "cautious"],
		"set_trap": ["hidden", "quick", "sturdy"]
	}
	var available: Array = options.get(action_id, [])
	if available.has(method_id):
		return method_id
	if available.is_empty():
		return ""
	return String(available[0])


func _action_method_base_cost(action_id: String, method_id: String, base_cost: Dictionary) -> Dictionary:
	var cost := base_cost.duplicate(true)
	var stamina := int(cost.get("stamina", 0))
	var time := int(cost.get("time", 0))
	match action_id:
		"gather":
			match method_id:
				"careful":
					stamina = maxi(1, stamina - 4)
					time += 1
				"wide":
					stamina += 5
					time += 1
				"quick":
					stamina += 3
					time = maxi(1, time - 1)
		"fish":
			match method_id:
				"patient":
					time += 1
				"quick":
					stamina += 3
					time = maxi(1, time - 1)
				"quiet":
					stamina = maxi(1, stamina - 3)
		"hunt":
			match method_id:
				"track":
					stamina += 4
					time += 1
				"drive":
					stamina += 8
				"cautious":
					stamina = maxi(1, stamina - 5)
					time += 1
		"set_trap":
			match method_id:
				"hidden":
					time += 1
				"quick":
					stamina = maxi(1, stamina - 3)
				"sturdy":
					stamina += 3
					time += 1
	cost["stamina"] = stamina
	cost["time"] = time
	return cost


func _action_method_attempt_delta(action_id: String, method_id: String) -> int:
	if action_id == "gather":
		match method_id:
			"wide":
				return 1
			"quick":
				return -1
	return 0


func _action_method_chance_delta(action_id: String, method_id: String) -> int:
	match action_id:
		"fish":
			match method_id:
				"patient":
					return 18
				"quick":
					return -18
				"quiet":
					return 6
		"hunt":
			match method_id:
				"track":
					return 14
				"drive":
					return 6
				"cautious":
					return -6
	return 0


func _trap_method_catch_bonus(method_id: String) -> int:
	match method_id:
		"hidden":
			return 14
		"quick":
			return -10
		"sturdy":
			return 6
	return 0


func _action_method_result_note(action_id: String, method_id: String) -> String:
	if method_id == "":
		return ""
	match action_id:
		"gather":
			match method_id:
				"careful":
					return "\n방식: 발밑을 살피며 필요한 것만 골랐다."
				"wide":
					return "\n방식: 주변을 넓게 훑어 더 많은 흔적을 찾았다."
				"quick":
					return "\n방식: 서둘러 챙기느라 놓친 것이 있을 수 있다."
		"fish":
			match method_id:
				"patient":
					return "\n방식: 물결이 잦아들 때까지 기다렸다."
				"quick":
					return "\n방식: 짧게 던지고 바로 거두었다."
				"quiet":
					return "\n방식: 기척을 낮추고 얕은 물가를 살폈다."
		"hunt":
			match method_id:
				"track":
					return "\n방식: 흔적을 따라가며 거리를 좁혔다."
				"drive":
					return "\n방식: 몰아붙여 큰 성과를 노렸다."
				"cautious":
					return "\n방식: 무리하지 않고 빠질 길을 남겼다."
		"set_trap":
			match method_id:
				"hidden":
					return "\n방식: 잎과 흙으로 덫 냄새를 숨겼다."
				"quick":
					return "\n방식: 오래 머물지 않고 빠르게 설치했다."
				"sturdy":
					return "\n방식: 고정점을 단단히 묶어 쉽게 풀리지 않게 했다."
	return ""


func _pay_cost(stamina_cost: int, time_cost: int, include_partner: bool = false, action_id: String = "") -> bool:
	if action_id != "" and not _can_perform_action_with_tools(action_id):
		return false
	var adjusted_cost := _tool_adjusted_action_cost(action_id, GameState.get_adjusted_action_cost(action_id, {"stamina": stamina_cost, "time": time_cost}))
	var adjusted_time := int(adjusted_cost.get("time", time_cost))
	var adjusted_stamina := int(adjusted_cost.get("stamina", stamina_cost))
	if not GameState.can_spend_action_points(adjusted_time):
		return false
	if not CharacterManager.can_spend_stamina(adjusted_stamina, include_partner):
		return false
	GameState.spend_action_points(adjusted_time)
	CharacterManager.spend_stamina(adjusted_stamina, include_partner)
	CharacterManager.apply_action_metabolism(action_id, adjusted_time, adjusted_stamina, include_partner)
	_apply_passive_tool_wear(action_id)
	return true


func _ok(text: String, action_id: String, items: Dictionary = {}) -> Dictionary:
	return {
		"ok": true,
		"action_id": action_id,
		"text": text,
		"items": items
	}


func _emit_action_result(result: Dictionary, together: bool = false) -> Dictionary:
	if bool(result.get("ok", false)):
		result["together"] = together
	emit_signal("action_resolved", result)
	return result


func _finish_action(region, base_text: String, action_id: String, items: Dictionary = {}, together: bool = false) -> Dictionary:
	var text := base_text
	_apply_result_tool_wear(action_id, items)
	var status_messages := CharacterManager.consume_status_messages()
	if not status_messages.is_empty():
		text += "\n" + _join_strings(status_messages, "\n")
	var item_messages := InventoryManager.consume_item_messages()
	if not item_messages.is_empty():
		text += "\n" + _join_strings(item_messages, "\n")
	if region != null:
		var aftereffects := CharacterManager.apply_action_aftereffects(action_id, region.display_name, region.danger_level, GameState.weather, together)
		if not aftereffects.is_empty():
			text += "\n" + _join_strings(aftereffects, "\n")
	return _ok(text, action_id, items)


func _uses_partner(args: Dictionary) -> bool:
	return bool(args.get("together", false)) and CharacterManager.is_partner_following()


func _can_perform_action_with_tools(action_id: String) -> bool:
	if GameState.can_perform_action_now(action_id):
		return true
	if action_id == "investigate" and InventoryManager.has_usable_tool_with_effect("night_investigate"):
		return true
	return false


func _tool_adjusted_action_cost(action_id: String, cost: Dictionary) -> Dictionary:
	var adjusted := cost.duplicate(true)
	if action_id == "investigate" and not GameState.is_daylight_time() and InventoryManager.has_usable_tool_with_effect("night_investigate"):
		adjusted["time"] = int(adjusted.get("time", 0)) + 1
		adjusted["stamina"] = int(adjusted.get("stamina", 0)) + 4
	return adjusted


func _apply_passive_tool_wear(action_id: String) -> void:
	if action_id == "investigate" and not GameState.is_daylight_time():
		InventoryManager.apply_best_tool_wear("night_investigate", 1)


func _apply_result_tool_wear(action_id: String, result_items: Dictionary) -> void:
	if action_id != "gather":
		return
	var used_effects: Dictionary = {}
	for raw_item_id in result_items.keys():
		var effect_id := _tool_effect_for_resource(String(raw_item_id))
		if effect_id != "":
			used_effects[effect_id] = true
	for effect_id in used_effects.keys():
		InventoryManager.apply_best_tool_wear(String(effect_id), 1)


func _tool_effect_for_resource(item_id: String) -> String:
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


func _fail(text: String) -> Dictionary:
	return {
		"ok": false,
		"text": text
	}


func _tile_id(x: int, y: int) -> String:
	return "tile_%d_%d" % [x, y]


func _tile_distance(first_tile_id: String, second_tile_id: String) -> int:
	var first = get_tile(first_tile_id)
	var second = get_tile(second_tile_id)
	if first == null or second == null:
		return 999
	var first_cube := _offset_to_cube(int(first.get("x", 0)), int(first.get("y", 0)))
	var second_cube := _offset_to_cube(int(second.get("x", 0)), int(second.get("y", 0)))
	return maxi(
		abs(int(first_cube.x) - int(second_cube.x)),
		maxi(abs(int(first_cube.y) - int(second_cube.y)), abs(int(first_cube.z) - int(second_cube.z)))
	)


func _offset_to_cube(x: int, y: int) -> Vector3i:
	var cube_x := x - int((y - (y & 1)) / 2)
	var cube_z := y
	var cube_y := -cube_x - cube_z
	return Vector3i(cube_x, cube_y, cube_z)


func _edge_key(first_tile_id: String, second_tile_id: String) -> String:
	if first_tile_id < second_tile_id:
		return "%s|%s" % [first_tile_id, second_tile_id]
	return "%s|%s" % [second_tile_id, first_tile_id]


func _blocked_edge_note(first_tile_id: String, second_tile_id: String) -> String:
	match _edge_key(first_tile_id, second_tile_id):
		"tile_2_6|tile_2_7":
			return "뒤쪽 바위와 밀림이 막혀 있다. 지금은 해변을 따라 나가는 길밖에 없다."
		"tile_2_7|tile_3_6":
			return "바위가 해변과 동굴 사이를 끊고 있어 돌아가야 한다."
		"tile_3_6|tile_4_6":
			return "동굴 앞 암반이 갈라져 곧장 지나가기 어렵다."
		"tile_3_3|tile_3_4":
			return "가파른 경사와 덤불이 길을 막는다."
		"tile_4_3|tile_5_4":
			return "숲과 초원 사이에 쓰러진 나무가 엉켜 있다."
		"tile_5_4|tile_6_4":
			return "강가의 물길이 깊어 바로 건널 수 없다."
		"tile_6_4|tile_6_5":
			return "젖은 둑이 무너져 발을 디딜 곳이 없다."
		"tile_3_7|tile_4_7":
			return "해변 절벽 때문에 바로 오를 수 없다."
		"tile_4_4|tile_4_5":
			return "숲이 너무 빽빽해 길을 낼 필요가 있다."
		"tile_5_5|tile_6_5":
			return "강둑이 급해서 건널 수 없다."
		"tile_6_6|tile_7_6":
			return "습지가 깊어 우회해야 한다."
		"tile_7_4|tile_7_5":
			return "물길과 진흙이 이어져 발을 디디기 어렵다."
	return ""


func _tile_blocked_note(x: int, y: int, terrain: String) -> String:
	var tile_id := _tile_id(x, y)
	match tile_id:
		"tile_4_2":
			return "쓰러진 나무와 덩굴이 촘촘히 얽혀 있다."
		"tile_5_2":
			return "가시덤불이 너무 빽빽해 들어갈 수 없다."
		"tile_7_3":
			return "강 절벽 아래로 땅이 끊겨 있다."
		"tile_7_7":
			return "강 하구가 깊어 지금은 건널 수 없다."
		"tile_2_3":
			return "가파른 바위벽이라 오를 수 없다."
		"tile_6_2", "tile_6_3":
			return "무너진 유적 잔해가 길을 막고 있다."
		"tile_7_2":
			return "절벽 끝이라 접근할 수 없다."
		"tile_7_6":
			return "발이 깊게 빠지는 습지다."
	if terrain == "ocean":
		return "바다라 걸어서 들어갈 수 없다."
	return ""


func _terrain_region_id(terrain: String) -> String:
	match terrain:
		"beach":
			return "beach"
		"meadow":
			return "meadow"
		"forest":
			return "forest"
		"river":
			return "river"
		"marsh":
			return "river"
		"cave":
			return "cave"
		"hill":
			return "cave"
		"ruins":
			return "cave"
	return "beach"


func _terrain_display_name(terrain: String) -> String:
	match terrain:
		"ocean":
			return "외곽 해역"
		"beach":
			return "해변"
		"meadow":
			return "초원"
		"forest":
			return "숲"
		"river":
			return "강가"
		"marsh":
			return "습지"
		"cave":
			return "동굴"
		"hill":
			return "바위 언덕"
		"ruins":
			return "유적"
	return "지역"


func _terrain_description(terrain: String) -> String:
	match terrain:
		"ocean":
			return "지형 밖의 해역이다."
		"beach":
			return "모래와 표류물이 쌓인 해변 타일."
		"meadow":
			return "열매와 섬유를 찾기 쉬운 풀밭 타일."
		"forest":
			return "목재와 열매가 많지만 위험도 있는 숲 타일."
		"river":
			return "식수와 물고기를 기대할 수 있는 강가 타일."
		"marsh":
			return "젖은 섬유와 물을 얻을 수 있지만 지치기 쉬운 습지 타일."
		"cave":
			return "비바람을 피할 수 있는 동굴 타일."
		"hill":
			return "돌과 광물 흔적이 많은 바위 언덕 타일."
		"ruins":
			return "낡은 문양과 단서가 숨어 있는 유적 타일."
	return "정체를 알 수 없는 타일."


func _terrain_danger(terrain: String) -> int:
	match terrain:
		"beach":
			return 1
		"meadow":
			return 1
		"river":
			return 2
		"cave":
			return 2
		"marsh":
			return 3
		"forest":
			return 3
		"hill":
			return 3
		"ruins":
			return 4
	return 0


func _terrain_resources(terrain: String) -> Dictionary:
	match terrain:
		"beach":
			return {"berry": 3, "water": 2, "wood": 3, "palm_frond": 4, "fiber": 2, "stone": 1, "fish": 1}
		"meadow":
			return {"berry": 5, "water": 1, "fiber": 3, "palm_frond": 2, "stone": 1}
		"forest":
			return {"wood": 4, "berry": 2, "fiber": 2, "vine": 2, "palm_frond": 1}
		"river":
			return {"water": 5, "berry": 1, "fish": 3, "stone": 1, "clay": 2, "vine": 1}
		"marsh":
			return {"water": 3, "fiber": 3, "fish": 1, "clay": 3, "vine": 2}
		"cave":
			return {"stone": 3, "water": 2, "clay": 1}
		"hill":
			return {"stone": 4, "wood": 1, "clay": 1}
		"ruins":
			return {"stone": 2, "fiber": 1, "clay": 1}
	return {}


func _terrain_animals(terrain: String) -> int:
	match terrain:
		"beach":
			return 1
		"meadow":
			return 3
		"forest":
			return 4
		"river":
			return 2
		"marsh":
			return 2
		"cave":
			return 1
		"hill":
			return 3
		"ruins":
			return 1
	return 0


func _terrain_actions(terrain: String) -> Array[String]:
	match terrain:
		"ocean":
			return []
		"river", "marsh", "beach":
			return ["investigate", "gather", "fish", "hunt", "set_trap", "wash", "rest", "develop"]
		"cave", "hill", "ruins":
			return ["investigate", "gather", "hunt", "set_trap", "rest", "develop"]
	return ["investigate", "gather", "hunt", "set_trap", "rest", "develop"]


func _hunt_success_chance(tile: Dictionary, together: bool) -> int:
	var chance := 30 + int(tile.get("investigation", 0)) / 2
	var animals := int(tile.get("animals", 0))
	chance += animals * 5
	if together:
		chance += 10
	match String(tile.get("terrain", "")):
		"forest", "meadow":
			chance += 8
		"hill":
			chance += 4
		"beach", "ruins", "cave":
			chance -= 8
	if GameState.weather == "비":
		chance -= 5
	elif GameState.weather == "폭우":
		chance -= 15
	elif GameState.weather == "폭풍":
		chance -= 30
	if not GameState.is_daylight_time():
		chance -= 12
	return clampi(chance, 8, 82)


func _trap_catch_chance(tile: Dictionary) -> int:
	var chance := 22 + int(tile.get("investigation", 0)) / 4 + int(tile.get("animals", 0)) * 6
	match String(tile.get("terrain", "")):
		"forest", "meadow":
			chance += 8
		"hill", "marsh":
			chance += 4
		"beach", "cave", "ruins":
			chance -= 4
	if GameState.weather == "폭우":
		chance -= 8
	elif GameState.weather == "폭풍":
		chance -= 18
	return clampi(chance, 10, 78)


func _tile_trap_limit(tile: Dictionary) -> int:
	if int(tile.get("development", 0)) >= 50:
		return 2
	return 1


func _resolve_tile_traps_daily(tile: Dictionary) -> void:
	var traps: Dictionary = tile.get("traps", {})
	if traps.is_empty():
		return
	for trap_id in traps.keys():
		var trap: Dictionary = traps[trap_id]
		if String(trap.get("state", "set")) != "set":
			continue
		if GameState.day <= int(trap.get("placed_day", GameState.day)):
			continue
		if int(tile.get("animals", 0)) <= 0:
			continue
		var catch_chance := clampi(_trap_catch_chance(tile) + int(trap.get("catch_bonus", 0)), 0, 95)
		if randi_range(1, 100) <= catch_chance:
			tile["animals"] = maxi(0, int(tile.get("animals", 0)) - 1)
			trap["state"] = "caught"
			trap["caught_items"] = {"raw_meat": 1, "animal_hide": 1 if randi_range(1, 100) <= 25 else 0}
		trap["placed_day"] = GameState.day
		traps[trap_id] = trap
	tile["traps"] = traps


func _add_tile_memory_to_tile(tile: Dictionary, memory_id: String, duration_days: int = 0) -> void:
	if memory_id == "":
		return
	_prune_tile_memory_flags(tile)
	var memories: Dictionary = tile.get("memory_flags", {})
	memories[memory_id] = {
		"id": memory_id,
		"day": GameState.day,
		"expires_day": GameState.day + duration_days if duration_days > 0 else 0
	}
	tile["memory_flags"] = memories


func _prune_tile_memory_flags(tile: Dictionary) -> void:
	var memories: Dictionary = tile.get("memory_flags", {})
	if memories.is_empty():
		tile["memory_flags"] = memories
		return
	var changed := false
	for raw_memory_id in memories.keys():
		var memory: Dictionary = memories[raw_memory_id]
		var expires_day := int(memory.get("expires_day", 0))
		if expires_day > 0 and GameState.day > expires_day:
			memories.erase(raw_memory_id)
			changed = true
	if changed:
		tile["memory_flags"] = memories


func _weather_is_rainy(weather_text: String) -> bool:
	return weather_text.find("비") >= 0 or weather_text.find("폭") >= 0


func _apply_daily_weather_to_tile(tile: Dictionary, weather_text: String) -> Dictionary:
	var result := {
		"extra_water": 0,
		"storm_debris": 0,
		"storm_depleted": 0,
		"washed_items": 0,
		"damaged_traps": 0
	}
	var terrain := String(tile.get("terrain", ""))
	if weather_text == "비" or weather_text == "폭우" or weather_text == "폭풍":
		var resources: Dictionary = tile.get("resources", {})
		var maximums: Dictionary = tile.get("resource_maximums", {})
		if maximums.has("water") and int(resources.get("water", 0)) < int(maximums.get("water", 0)):
			resources["water"] = mini(int(maximums.get("water", 0)), int(resources.get("water", 0)) + 1)
			tile["resources"] = resources
			result["extra_water"] = 1
			_add_tile_memory_to_tile(tile, "rain_puddle", 1)

	if weather_text == "폭우" or weather_text == "폭풍":
		result["washed_items"] = _wash_field_items_from_tile(tile, 45 if weather_text == "폭풍" else 24)
		result["damaged_traps"] = _damage_tile_traps_by_weather(tile, 22 if weather_text == "폭풍" else 10)
		result["storm_depleted"] = _sweep_tile_resources_by_storm(tile, weather_text == "폭풍")

	var debris_chance := 0
	if terrain == "beach":
		debris_chance = 85 if weather_text == "폭풍" else 38 if weather_text == "폭우" else 0
	if debris_chance > 0 and randi_range(1, 100) <= debris_chance:
		_add_field_item_to_tile(tile, "wood", 1 + (1 if weather_text == "폭풍" and randi_range(1, 100) <= 35 else 0))
		if randi_range(1, 100) <= 55:
			_add_field_item_to_tile(tile, "fiber", 1)
		if weather_text == "폭풍" and randi_range(1, 100) <= 45:
			_add_field_item_to_tile(tile, "palm_frond", 1)
		_add_tile_memory_to_tile(tile, "storm_debris", 2)
		result["storm_debris"] = 1
	return result


func _sweep_tile_resources_by_storm(tile: Dictionary, is_large_storm: bool) -> int:
	var terrain := String(tile.get("terrain", ""))
	if not ["beach", "meadow", "river", "marsh"].has(terrain):
		return 0
	var resources: Dictionary = tile.get("resources", {})
	if resources.is_empty():
		return 0
	var changed := false
	var reduction_ratio := 0.55 if is_large_storm else 0.25
	if ["beach", "river", "marsh"].has(terrain):
		reduction_ratio += 0.15 if is_large_storm else 0.05
	for raw_item_id in resources.keys():
		var item_id := String(raw_item_id)
		if item_id == "water":
			continue
		var current := int(resources[item_id])
		if current <= 0:
			continue
		var removed := maxi(1, int(ceil(float(current) * reduction_ratio)))
		resources[item_id] = maxi(0, current - removed)
		changed = true
	if changed:
		tile["resources"] = resources
		_add_tile_memory_to_tile(tile, "washed_away", 2)
	return 1 if changed else 0


func _wash_field_items_from_tile(tile: Dictionary, chance_percent: int) -> int:
	var terrain := String(tile.get("terrain", ""))
	if not ["beach", "river", "marsh"].has(terrain):
		return 0
	var field_items: Dictionary = tile.get("field_items", {})
	if field_items.is_empty() or randi_range(1, 100) > chance_percent:
		return 0
	var keys := field_items.keys()
	keys.sort()
	var selected_item_id := String(keys[randi_range(0, keys.size() - 1)])
	field_items[selected_item_id] = int(field_items.get(selected_item_id, 0)) - 1
	if int(field_items.get(selected_item_id, 0)) <= 0:
		field_items.erase(selected_item_id)
	tile["field_items"] = field_items
	_add_tile_memory_to_tile(tile, "washed_away", 1)
	return 1


func _damage_tile_traps_by_weather(tile: Dictionary, chance_percent: int) -> int:
	var traps: Dictionary = tile.get("traps", {})
	if traps.is_empty():
		return 0
	var damaged := 0
	for raw_trap_id in traps.keys():
		if randi_range(1, 100) <= chance_percent:
			traps.erase(raw_trap_id)
			damaged += 1
	tile["traps"] = traps
	if damaged > 0:
		_add_tile_memory_to_tile(tile, "damaged_trap", 1)
	return damaged


func _add_hunted_items_to_party(tile: Dictionary, items: Dictionary, together: bool) -> Dictionary:
	var gathered: Dictionary = {}
	for raw_item_id in items.keys():
		var item_id := String(raw_item_id)
		var amount := int(items[raw_item_id])
		if amount <= 0:
			continue
		var carried := InventoryManager.add_item_to_party(item_id, amount, together)
		if carried > 0:
			gathered[item_id] = int(gathered.get(item_id, 0)) + carried
		var leftover := amount - carried
		if leftover > 0:
			_add_field_item_to_tile(tile, item_id, leftover)
	return gathered


func _target_resource_object_count_for_investigation(tile: Dictionary) -> int:
	var terrain := String(tile.get("terrain", ""))
	var candidates: Array = TERRAIN_RESOURCE_OBJECTS.get(terrain, [])
	if candidates.is_empty():
		return 0
	var target_count := 2
	if int(tile.get("investigation", 0)) >= 60:
		target_count = 3
	return mini(target_count, candidates.size())


func _discover_tile_resource_objects(tile: Dictionary, target_count: int = 2) -> Array[String]:
	if tile == null or not bool(tile.get("playable", false)):
		return []
	var terrain := String(tile.get("terrain", ""))
	var candidates: Array = TERRAIN_RESOURCE_OBJECTS.get(terrain, [])
	if candidates.is_empty():
		tile["resource_objects"] = {}
		return []
	var objects: Dictionary = Dictionary(tile.get("resource_objects", {})).duplicate(true)
	var safe_target_count := mini(maxi(0, target_count), candidates.size())
	if objects.size() >= safe_target_count:
		return []
	var discovered_names: Array[String] = []
	var used_types: Dictionary = {}
	for existing_object in objects.values():
		var existing_type := String(Dictionary(existing_object).get("type", ""))
		if existing_type != "":
			used_types[existing_type] = true
	var seed := int(tile.get("x", 0)) * 17 + int(tile.get("y", 0)) * 31 + int(tile.get("danger", 0)) * 5
	var attempts := candidates.size() * 3
	for index in range(attempts):
		if objects.size() >= safe_target_count:
			break
		var type_id := String(candidates[posmod(seed + index, candidates.size())])
		if used_types.has(type_id):
			continue
		var definition: Dictionary = RESOURCE_OBJECT_DEFINITIONS.get(type_id, {})
		if definition.is_empty():
			continue
		used_types[type_id] = true
		var object := definition.duplicate(true)
		var object_id := "%s_%d" % [type_id, objects.size()]
		object["id"] = object_id
		object["type"] = type_id
		object["remaining"] = int(definition.get("uses", 1))
		object["max_uses"] = int(definition.get("uses", 1))
		objects[object_id] = object
		discovered_names.append(String(object.get("display_name", type_id)))
	tile["resource_objects"] = objects
	return discovered_names


func _consume_tile_resource_pool(tile: Dictionary, items_to_consume: Dictionary) -> void:
	var resources: Dictionary = tile.get("resources", {})
	if resources.is_empty():
		return
	for raw_item_id in items_to_consume.keys():
		var item_id := String(raw_item_id)
		if not resources.has(item_id):
			continue
		var current := int(resources.get(item_id, 0))
		if current <= 0:
			continue
		resources[item_id] = maxi(0, current - int(items_to_consume[raw_item_id]))
	tile["resources"] = resources


func describe_tile_resources(tile_id: String) -> String:
	var tile = get_tile(tile_id)
	if tile == null:
		return ""
	var resources: Dictionary = tile.get("resources", {})
	if resources.is_empty():
		return "확인된 자원 없음"
	var parts: Array[String] = []
	var keys := resources.keys()
	keys.sort()
	for raw_item_id in keys:
		var item_id := String(raw_item_id)
		var amount := int(resources[item_id])
		if amount <= 0:
			continue
		var item = InventoryManager.get_item_data(item_id)
		var display_name := item_id
		if item != null:
			display_name = item.display_name
		if is_tile_investigated(tile_id):
			parts.append("%s %d" % [display_name, amount])
		else:
			parts.append(display_name)
	if is_tile_investigated(tile_id):
		var object_summary := get_tile_resource_object_summary(tile_id)
		if object_summary != "":
			parts.append("채취 대상: %s" % object_summary)
	if parts.is_empty():
		return "남은 자원 없음"
	return _join_strings(parts, ", ")


func _resource_yield_amount(item_id: String, investigation: int, development: int, terrain: String, together: bool) -> int:
	var amount := 1
	if ["berry", "water"].has(item_id):
		amount += 1
	if ["beach", "meadow", "river"].has(terrain) and ["berry", "water"].has(item_id):
		amount += 1
	if item_id != "water" and investigation >= 30:
		amount += 1
	if item_id != "water" and development >= 50:
		amount += 1
	amount += _resource_tool_bonus(item_id)
	amount += BaseManager.get_gather_bonus(item_id)
	if together and ["wood", "fiber", "vine", "palm_frond", "stone", "clay"].has(item_id) and randi_range(1, 100) <= 35:
		amount += 1
	if item_id == "water":
		if GameState.weather == "비":
			amount += 1
		elif GameState.weather == "폭우" or GameState.weather == "폭풍":
			amount += 2
	if item_id == "wood" and (GameState.weather == "폭우" or GameState.weather == "폭풍"):
		amount -= 1
	if terrain == "marsh" and item_id == "clay":
		amount += 1
	return maxi(1, amount)


func _gather_attempt_count(investigation: int, development: int, terrain: String, together: bool) -> int:
	var attempts := 1
	if ["beach", "meadow", "river"].has(terrain):
		attempts += 1
	if investigation >= 30:
		attempts += 1
	if together:
		attempts += 1
	if development >= 50:
		attempts += 1
	return attempts


func _pick_gather_item(available: Array[String], terrain: String) -> String:
	var weighted: Array[String] = []
	for item_id in available:
		var weight := _gather_item_weight(item_id, terrain)
		for index in range(weight):
			weighted.append(item_id)
	if weighted.is_empty():
		return String(available.pick_random())
	return String(weighted.pick_random())


func _gather_item_weight(item_id: String, terrain: String) -> int:
	var weight := 1
	if ["berry", "water"].has(item_id):
		weight += 3
	if terrain == "beach" and ["berry", "water", "palm_frond"].has(item_id):
		weight += 2
	elif terrain == "meadow" and item_id == "berry":
		weight += 2
	elif terrain == "river" and item_id == "water":
		weight += 2
	if CharacterManager.player_status != null:
		if item_id == "berry" and CharacterManager.player_status.hunger <= 60:
			weight += 4
		if item_id == "water" and CharacterManager.player_status.thirst <= 60:
			weight += 4
	return weight


func _resource_tool_bonus(item_id: String) -> int:
	match item_id:
		"wood":
			return InventoryManager.get_item_effect_max("gather_wood_bonus")
		"fiber", "vine", "palm_frond":
			return InventoryManager.get_item_effect_max("gather_fiber_bonus")
		"stone":
			return InventoryManager.get_item_effect_max("gather_stone_bonus")
		"clay":
			return InventoryManager.get_item_effect_max("gather_clay_bonus")
		"water":
			return InventoryManager.get_item_effect_max("gather_water_bonus")
	return 0


func _development_requirements(terrain: String, development: int) -> Dictionary:
	var tier := 1 + int(development / 50)
	match terrain:
		"beach":
			return {"wood": tier, "palm_frond": tier}
		"meadow":
			return {"wood": tier, "fiber": tier}
		"forest":
			return {"wood": tier + 1, "fiber": tier}
		"river":
			return {"wood": tier, "stone": tier, "fiber": tier}
		"marsh":
			return {"wood": tier, "clay": tier + 1, "palm_frond": tier}
		"cave":
			return {"stone": tier + 1, "clay": tier}
		"hill":
			return {"stone": tier + 2, "wood": tier}
		"ruins":
			return {"stone": tier + 1, "clay": tier, "fiber": tier}
	return {"wood": tier, "fiber": tier}


func _gather_note_for_tile(tile: Dictionary, gathered: Dictionary) -> String:
	var notes: Array[String] = []
	if int(tile.get("investigation", 0)) >= 30:
		notes.append("조사 보정")
	if int(tile.get("development", 0)) >= 50:
		notes.append("정비 보정")
	if not gathered.is_empty() and _has_gather_tool_bonus(gathered):
		notes.append("도구 보정")
	var base_note := _gather_note_for_values(int(tile.get("investigation", 0)), int(tile.get("development", 0)))
	if base_note != "":
		return base_note
	if notes.is_empty():
		return ""
	return "\n적용: %s" % _join_strings(notes, ", ")


func _gather_note_for_values(investigation: int, development: int) -> String:
	var notes: Array[String] = []
	if investigation >= 30:
		notes.append("조사 보정")
	if development >= 50:
		notes.append("정비 보정")
	if InventoryManager.get_item_effect_max("gather_wood_bonus") > 0 \
		or InventoryManager.get_item_effect_max("gather_fiber_bonus") > 0 \
		or InventoryManager.get_item_effect_max("gather_stone_bonus") > 0 \
		or InventoryManager.get_item_effect_max("gather_clay_bonus") > 0 \
		or InventoryManager.get_item_effect_max("gather_water_bonus") > 0:
		notes.append("도구 보정")
	if BaseManager.has_any_gather_bonus():
		notes.append("거점 보정")
	if notes.is_empty():
		return ""
	return "\n적용: %s" % _join_strings(notes, ", ")


func _has_gather_tool_bonus(gathered: Dictionary) -> bool:
	for item_id in gathered.keys():
		if _resource_tool_bonus(String(item_id)) > 0:
			return true
	return false


func _add_field_item_to_tile(tile: Dictionary, item_id: String, amount: int) -> void:
	if amount <= 0:
		return
	var field_items: Dictionary = tile.get("field_items", {})
	field_items[item_id] = int(field_items.get(item_id, 0)) + amount
	tile["field_items"] = field_items


func _remove_field_item_from_tile(tile: Dictionary, item_id: String, amount: int) -> void:
	if amount <= 0:
		return
	var field_items: Dictionary = tile.get("field_items", {})
	field_items[item_id] = int(field_items.get(item_id, 0)) - amount
	if int(field_items.get(item_id, 0)) <= 0:
		field_items.erase(item_id)
	tile["field_items"] = field_items


func _format_items(items: Dictionary) -> String:
	if items.is_empty():
		return "획득 없음"
	var parts: Array[String] = []
	for item_id in items.keys():
		var item = InventoryManager.get_item_data(String(item_id))
		var display_name := String(item_id)
		if item != null:
			display_name = item.display_name
		parts.append("%s x%d" % [display_name, int(items[item_id])])
	return _join_strings(parts, ", ")


func _join_strings(parts: Array[String], separator: String) -> String:
	var text := ""
	for index in range(parts.size()):
		if index > 0:
			text += separator
		text += parts[index]
	return text
