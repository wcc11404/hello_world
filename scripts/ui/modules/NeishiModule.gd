class_name NeishiModule extends Node

# 内视模块 - 处理修炼、突破、术法等功能

# 信号
signal cultivation_started
signal breakthrough_requested
signal spell_tab_selected(tab: String)

# 引用
var game_ui: Node = null
var player: Node = null
var cultivation_system: Node = null
var spell_system: Node = null

# UI节点引用（由GameUI设置）
var neishi_panel: Control = null
var cultivation_panel: Control = null
var breakthrough_panel: Control = null
var spell_panel: Control = null

func _ready():
	pass

func initialize(ui: Node, player_node: Node, cult_sys: Node, spell_sys: Node):
	game_ui = ui
	player = player_node
	cultivation_system = cult_sys
	spell_system = spell_sys

# 显示内视Tab
func show_tab():
	if neishi_panel:
		neishi_panel.visible = true
		_show_cultivation_panel()

# 隐藏内视Tab
func hide_tab():
	if neishi_panel:
		neishi_panel.visible = false

# 显示修炼页面
func _show_cultivation_panel():
	if cultivation_panel:
		cultivation_panel.visible = true
	if breakthrough_panel:
		breakthrough_panel.visible = false
	if spell_panel:
		spell_panel.visible = false
	update_cultivation_ui()

# 显示突破页面
func _show_breakthrough_panel():
	if cultivation_panel:
		cultivation_panel.visible = false
	if breakthrough_panel:
		breakthrough_panel.visible = true
	if spell_panel:
		spell_panel.visible = false
	update_breakthrough_ui()

# 显示术法页面
func _show_spell_panel():
	if cultivation_panel:
		cultivation_panel.visible = false
	if breakthrough_panel:
		breakthrough_panel.visible = false
	if spell_panel:
		spell_panel.visible = true
	update_spell_ui()

# 更新修炼UI
func update_cultivation_ui():
	if not player or not cultivation_system:
		return
	
	# 更新修炼相关信息
	# 由GameUI调用具体节点更新

# 更新突破UI
func update_breakthrough_ui():
	if not player:
		return
	
	# 更新突破相关信息
	# 由GameUI调用具体节点更新

# 更新术法UI
func update_spell_ui():
	if not spell_system:
		return
	
	# 更新术法列表
	# 由GameUI调用具体节点更新

# 开始修炼
func start_cultivation():
	if cultivation_system:
		cultivation_system.start_cultivation()
		cultivation_started.emit()

# 停止修炼
func stop_cultivation():
	if cultivation_system:
		cultivation_system.stop_cultivation()

# 尝试突破
func attempt_breakthrough():
	breakthrough_requested.emit()
