class_name LianliModule extends Node

# 历练模块 - 处理历练区域、战斗、无尽塔等功能

# 信号
signal area_selected(area_id: String)
signal battle_started(area_id: String)
signal battle_ended(victory: bool)
signal tower_floor_changed(floor: int)

# 引用
var game_ui: Node = null
var player: Node = null
var lianli_system: Node = null
var lianli_area_data: Node = null

# UI节点引用
var lianli_panel: Control = null
var lianli_select_panel: Control = null
var lianli_scene_panel: Control = null

func _ready():
	pass

func initialize(ui: Node, player_node: Node, lianli_sys: Node, area_data: Node):
	game_ui = ui
	player = player_node
	lianli_system = lianli_sys
	lianli_area_data = area_data

# 显示历练Tab
func show_tab():
	if lianli_panel:
		lianli_panel.visible = true
	
	# 检查是否处于历练中
	if lianli_system and (lianli_system.is_in_battle or lianli_system.is_waiting or lianli_system.is_in_lianli):
		_show_scene_panel()
	else:
		_show_select_panel()

# 隐藏历练Tab
func hide_tab():
	if lianli_panel:
		lianli_panel.visible = false

# 显示选择面板
func _show_select_panel():
	if lianli_select_panel:
		lianli_select_panel.visible = true
	if lianli_scene_panel:
		lianli_scene_panel.visible = false

# 显示场景面板
func _show_scene_panel():
	if lianli_select_panel:
		lianli_select_panel.visible = false
	if lianli_scene_panel:
		lianli_scene_panel.visible = true

# 选择历练区域
func select_area(area_id: String):
	area_selected.emit(area_id)

# 开始历练
func start_lianli(area_id: String) -> bool:
	if not lianli_system:
		return false
	
	var result = lianli_system.start_lianli_in_area(area_id)
	if result:
		battle_started.emit(area_id)
		_show_scene_panel()
	
	return result

# 开始无尽塔
func start_tower() -> bool:
	if not lianli_system:
		return false
	
	var result = lianli_system.start_endless_tower()
	if result:
		battle_started.emit("endless_tower")
		_show_scene_panel()
	
	return result

# 退出历练
func exit_lianli():
	if lianli_system:
		lianli_system.exit_lianli()
		_show_select_panel()

# 更新无尽塔按钮文本
func update_tower_button(button: Button):
	if not button or not player:
		return
	
	var floor = player.tower_highest_floor + 1
	button.text = "无尽塔 (第" + str(floor) + "层)"
