class_name CultivationModule extends Node

## 修炼突破模块 - 管理修炼和突破功能
## 对应内视页面的修炼子面板

# 信号
signal cultivation_started
signal cultivation_stopped
signal breakthrough_succeeded(result: Dictionary)
signal breakthrough_failed(result: Dictionary)
signal log_message(message: String)

# 引用
var game_ui: Node = null
var player: Node = null
var cultivation_system: Node = null
var lianli_system: Node = null
var item_data: Node = null

# UI节点引用（由GameUI设置）
var cultivation_panel: Control = null
var cultivate_button: Button = null
var breakthrough_button: Button = null

# 状态
var _is_initialized: bool = false

func _ready():
	pass

func initialize(ui: Node, player_node: Node, cult_sys: Node, lianli_sys: Node = null, item_data_ref: Node = null):
	game_ui = ui
	player = player_node
	cultivation_system = cult_sys
	lianli_system = lianli_sys
	item_data = item_data_ref
	_is_initialized = true

# 显示修炼面板
func show_panel():
	if cultivation_panel:
		cultivation_panel.visible = true
	_update_cultivate_button_state()

# 隐藏修炼面板
func hide_panel():
	if cultivation_panel:
		cultivation_panel.visible = false

# 更新修炼按钮状态
func update_cultivate_button_state():
	_update_cultivate_button_state()

func _update_cultivate_button_state():
	if not cultivate_button or not player:
		return
	
	if player.get_is_cultivating():
		cultivate_button.text = "停止修炼"
	else:
		cultivate_button.text = "修炼"

# 修炼按钮按下
func on_cultivate_button_pressed():
	if not player or not cultivation_system:
		return
	
	if player.get_is_cultivating():
		# 停止修炼
		player.stop_cultivation()
		cultivation_system.stop_cultivation()
		cultivate_button.text = "修炼"
		log_message.emit("停止修炼")
		cultivation_stopped.emit()
	else:
		# 如果正在历练或等待中，先停止历练
		if lianli_system and (lianli_system.is_in_lianli or lianli_system.is_waiting):
			lianli_system.end_lianli()
			log_message.emit("已退出历练区域，停止历练")
			# 通知GameUI切换回内视页面
			if game_ui and game_ui.has_method("show_neishi_tab"):
				game_ui.show_neishi_tab()
		
		# 开始修炼
		player.start_cultivation()
		cultivation_system.start_cultivation()
		cultivate_button.text = "停止修炼"
		log_message.emit("开始修炼，灵气积累中...")
		cultivation_started.emit()

# 突破按钮按下
func on_breakthrough_button_pressed():
	if not player:
		return
	
	var result = player.attempt_breakthrough()
	if result.get("success", false):
		_handle_breakthrough_success(result)
	else:
		_handle_breakthrough_failure(result)

# 处理突破成功
func _handle_breakthrough_success(result: Dictionary):
	# 突破成功后恢复生命值到满
	player.set_health(player.get_final_max_health())
	
	var stone_cost = result.get("stone_cost", 0)
	var energy_cost = result.get("energy_cost", 0)
	var materials = result.get("materials", {})
	var type = result.get("type", "level")
	
	if type == "level":
		var new_level = result.get("new_level", 1)
		var success_msg = _build_breakthrough_message(stone_cost, energy_cost, materials, "突破成功！")
		log_message.emit(success_msg)
		log_message.emit("升至第" + str(new_level) + "层！气血值已恢复满！")
	else:
		var new_realm = result.get("new_realm", "")
		var success_msg = _build_breakthrough_message(stone_cost, energy_cost, materials, "晋升成功！")
		log_message.emit(success_msg)
		log_message.emit("进入" + new_realm + "！气血值已恢复满！")
	
	breakthrough_succeeded.emit(result)

# 处理突破失败
func _handle_breakthrough_failure(result: Dictionary):
	var reason = result.get("reason", "突破失败")
	var stone_cost = result.get("stone_cost", 0)
	var energy_cost = result.get("energy_cost", 0)
	var stone_current = result.get("stone_current", 0)
	var energy_current = result.get("energy_current", 0)
	var materials = result.get("materials", {})
	
	if reason == "灵气不足":
		log_message.emit("突破失败：灵气不足 (" + str(energy_current) + "/" + str(energy_cost) + ")")
	elif reason == "灵石不足":
		log_message.emit("突破失败：灵石不足 (" + str(stone_current) + "/" + str(stone_cost) + ")")
	elif reason.ends_with("不足"):
		# 材料不足提示
		for material_id in materials.keys():
			var material_info = materials[material_id]
			if not material_info.get("enough", true):
				var material_name = item_data.get_item_name(material_id) if item_data else material_id
				var current = material_info.get("current", 0)
				var required = material_info.get("required", 0)
				log_message.emit("突破失败：" + material_name + "不足 (" + str(current) + "/" + str(required) + ")")
				break
	else:
		log_message.emit("突破失败：" + reason)
	
	breakthrough_failed.emit(result)

# 构建突破消息
func _build_breakthrough_message(stone_cost: int, energy_cost: int, materials: Dictionary, suffix: String) -> String:
	var msg = "消耗灵石" + str(stone_cost) + "、灵气" + str(energy_cost)
	
	for material_id in materials.keys():
		var material_info = materials[material_id]
		var required_count = material_info.get("required", 0)
		if required_count > 0:
			var material_name = item_data.get_item_name(material_id) if item_data else material_id
			msg += "、" + material_name + str(required_count)
	
	msg += "，" + suffix
	return msg

# 清理
func cleanup():
	_is_initialized = false
