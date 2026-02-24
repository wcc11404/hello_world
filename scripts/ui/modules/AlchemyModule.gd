class_name AlchemyModule extends Node

# 炼丹模块 - 处理炼丹房逻辑

# 信号
signal recipe_selected(recipe_id: String)
signal crafting_started(recipe_id: String, count: int)
signal crafting_finished(success_count: int, fail_count: int)
signal crafting_log(message: String)
signal back_to_dongfu_requested

# 引用
var game_ui: Node = null
var player: Node = null
var alchemy_system: Node = null
var recipe_data: Node = null
var item_data: Node = null

# UI节点引用
var alchemy_room_panel: Control = null
var recipe_list_container: VBoxContainer = null
var recipe_name_label: Label = null
var success_rate_label: Label = null
var craft_time_label: Label = null
var materials_container: VBoxContainer = null
var craft_button: Button = null
var alchemy_info_label: Label = null
var furnace_info_label: Label = null
var log_label: RichTextLabel = null

# 当前选中的丹方
var selected_recipe: String = ""
var selected_count: int = 1

func _ready():
	pass

func initialize(ui: Node, player_node: Node, alchemy_sys: Node, recipe_data_node: Node, item_data_node: Node):
	game_ui = ui
	player = player_node
	alchemy_system = alchemy_sys
	recipe_data = recipe_data_node
	item_data = item_data_node
	_setup_signals()

func _setup_signals():
	# 连接按钮信号
	if craft_button:
		craft_button.pressed.connect(_on_craft_pressed)

# 显示炼丹房
func show_alchemy_room():
	if alchemy_room_panel:
		alchemy_room_panel.visible = true
	_update_recipe_list()
	_update_alchemy_info()
	_clear_craft_panel()

# 隐藏炼丹房
func hide_alchemy_room():
	if alchemy_room_panel:
		alchemy_room_panel.visible = false

# 更新丹方列表
func _update_recipe_list():
	if not recipe_list_container or not player:
		return
	
	# 清空列表
	for child in recipe_list_container.get_children():
		child.queue_free()
	
	# 添加已学会的丹方
	for recipe_id in player.learned_recipes:
		var recipe_info = recipe_data.get_recipe_data(recipe_id)
		if recipe_info.is_empty():
			continue
		
		var button = Button.new()
		button.text = recipe_info.get("recipe_name", "未知丹方")
		button.custom_minimum_size = Vector2(0, 40)
		button.pressed.connect(func(): _select_recipe(recipe_id))
		recipe_list_container.add_child(button)
	
	# 如果没有学会任何丹方
	if player.learned_recipes.is_empty():
		var label = Label.new()
		label.text = "暂无学会的丹方"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		recipe_list_container.add_child(label)

# 选择丹方
func _select_recipe(recipe_id: String):
	selected_recipe = recipe_id
	selected_count = 1
	_update_craft_panel()
	recipe_selected.emit(recipe_id)

# 更新炼丹信息显示
func _update_alchemy_info():
	if not alchemy_info_label or not furnace_info_label or not alchemy_system:
		return
	
	# 更新炼丹术信息
	var alchemy_bonus = alchemy_system.get_alchemy_bonus()
	var success_bonus = alchemy_bonus.get("success_bonus", 0)
	var speed_bonus = alchemy_bonus.get("speed_bonus", 0.0)
	
	if success_bonus > 0:
		alchemy_info_label.text = "炼丹术: LV.%d (+%d成功值, +%.0f%%速度)" % [
			int(speed_bonus * 10), success_bonus, speed_bonus * 100
		]
	else:
		alchemy_info_label.text = "炼丹术: 未学习"
	
	# 更新丹炉信息
	var furnace_bonus = alchemy_system.get_furnace_bonus()
	var furnace_success = furnace_bonus.get("success_bonus", 0)
	var furnace_speed = furnace_bonus.get("speed_bonus", 0.0)
	
	if furnace_success > 0:
		furnace_info_label.text = "丹炉: 初级丹炉 (+%d成功值, +%.0f%%速度)" % [
			furnace_success, furnace_speed * 100
		]
	else:
		furnace_info_label.text = "丹炉: 无"

# 清空炼制面板
func _clear_craft_panel():
	selected_recipe = ""
	selected_count = 1
	
	if recipe_name_label:
		recipe_name_label.text = "请选择丹方"
	if success_rate_label:
		success_rate_label.text = "成功率: -"
	if craft_time_label:
		craft_time_label.text = "耗时: -"
	if craft_button:
		craft_button.disabled = true
	
	# 清空材料显示
	if materials_container:
		for child in materials_container.get_children():
			child.queue_free()

# 更新炼制面板
func _update_craft_panel():
	if not selected_recipe or not alchemy_system:
		return
	
	var preview = alchemy_system.get_craft_preview(selected_recipe, selected_count)
	
	# 更新丹方名称
	if recipe_name_label:
		recipe_name_label.text = preview.get("recipe_name", "未知丹方")
	
	# 更新成功率
	if success_rate_label:
		success_rate_label.text = "成功率: %d%%" % preview.get("success_rate", 0)
	
	# 更新耗时
	if craft_time_label:
		var total_time = preview.get("total_time", 0.0)
		craft_time_label.text = "耗时: %.1f秒" % total_time
	
	# 更新材料显示
	_update_materials_display(preview.get("materials", {}))
	
	# 更新炼制按钮状态
	if craft_button:
		craft_button.disabled = not preview.get("can_craft", false)

# 更新材料显示
func _update_materials_display(materials_data: Dictionary):
	if not materials_container:
		return
	
	# 清空
	for child in materials_container.get_children():
		child.queue_free()
	
	# 添加材料标签
	for material_id in materials_data.keys():
		var material_info = materials_data[material_id]
		var has = material_info.get("has", 0)
		var required = material_info.get("required", 0)
		
		var item_name = item_data.get_item_name(material_id) if item_data else material_id
		
		var label = Label.new()
		label.text = "%s: %d/%d" % [item_name, has, required]
		
		# 材料不足时标红
		if has < required:
			label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))
		
		materials_container.add_child(label)

# 设置炼制数量
func set_craft_count(count: int):
	selected_count = max(1, count)
	if selected_recipe:
		_update_craft_panel()

# 获取最大可炼制数量
func get_max_craft_count() -> int:
	if not selected_recipe or not alchemy_system:
		return 0
	
	var materials = recipe_data.get_recipe_materials(selected_recipe)
	if materials.is_empty():
		return 0
	
	var max_count = 999999
	for material_id in materials.keys():
		var required_per = materials[material_id]
		var has = alchemy_system.inventory.get_item_count(material_id) if alchemy_system.inventory else 0
		var can_craft = has / required_per
		max_count = min(max_count, can_craft)
	
	return max_count

# 开始炼制按钮按下
func _on_craft_pressed():
	if not selected_recipe or not alchemy_system:
		return
	
	var result = alchemy_system.start_crafting(selected_recipe, selected_count)
	
	if result.get("success", false):
		crafting_started.emit(selected_recipe, selected_count)
		_add_log("开始炼制 %s ×%d" % [
			recipe_data.get_recipe_name(selected_recipe),
			selected_count
		])
		
		# 炼制完成后更新UI
		_update_recipe_list()
		_update_craft_panel()
		_update_alchemy_info()
	else:
		_add_log("炼制失败: " + result.get("reason", "未知错误"))

# 添加日志
func _add_log(message: String):
	if log_label:
		var time_str = Time.get_time_string_from_system()
		log_label.text += "[%s] %s\n" % [time_str, message]
		crafting_log.emit(message)

# 清空日志
func clear_log():
	if log_label:
		log_label.text = ""
