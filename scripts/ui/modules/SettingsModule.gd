class_name SettingsModule extends Node

# 设置模块 - 处理游戏设置、存档等功能

# 信号
signal save_requested
signal load_requested

# 引用
var game_ui: Node = null
var player: Node = null
var save_manager: Node = null

# UI节点引用
var settings_panel: Control = null
var save_button: Button = null
var load_button: Button = null

func initialize(ui: Node, player_node: Node, save_mgr: Node):
	game_ui = ui
	player = player_node
	save_manager = save_mgr
	_setup_signals()

func _setup_signals():
	# 连接按钮信号
	if save_button:
		save_button.pressed.connect(_on_save_pressed)
	if load_button:
		load_button.pressed.connect(_on_load_pressed)

# 显示设置Tab
func show_tab():
	if settings_panel:
		settings_panel.visible = true

# 隐藏设置Tab
func hide_tab():
	if settings_panel:
		settings_panel.visible = false

# 保存按钮按下
func _on_save_pressed():
	save_requested.emit()
	
	# 从GameManager获取save_manager
	if not save_manager:
		var game_manager = get_node_or_null("/root/GameManager")
		if game_manager:
			save_manager = game_manager.get_save_manager()
	
	if save_manager:
		var result = save_manager.save_game()
		if game_ui and game_ui.log_manager:
			if result:
				game_ui.log_manager.add_system_log("存档成功！")
			else:
				game_ui.log_manager.add_system_log("存档失败...")
		return result
	return false

# 加载按钮按下
func _on_load_pressed():
	load_requested.emit()
	
	# 从GameManager获取save_manager
	if not save_manager:
		var game_manager = get_node_or_null("/root/GameManager")
		if game_manager:
			save_manager = game_manager.get_save_manager()
	
	# 使用GameManager的load_game来触发离线奖励计算
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var result = game_manager.load_game()
		if game_ui and game_ui.log_manager:
			if result:
				game_ui.log_manager.add_system_log("读档成功！")
				# 刷新UI
				if game_ui.has_method("update_ui"):
					game_ui.update_ui()
				if game_ui.has_method("refresh_inventory_ui"):
					game_ui.refresh_inventory_ui()
			else:
				game_ui.log_manager.add_system_log("读档失败...")
		return result
	return false

# 保存游戏
func save_game() -> bool:
	save_requested.emit()
	if save_manager:
		return save_manager.save_game()
	return false

# 加载游戏
func load_game() -> bool:
	load_requested.emit()
	if save_manager:
		return save_manager.load_game()
	return false
