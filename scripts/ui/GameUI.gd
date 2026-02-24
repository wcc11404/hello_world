extends Control

# 预加载模块
const AlchemyModule = preload("res://scripts/ui/modules/AlchemyModule.gd")
const SettingsModule = preload("res://scripts/ui/modules/SettingsModule.gd")
const DongfuModule = preload("res://scripts/ui/modules/DongfuModule.gd")
const ChunaModule = preload("res://scripts/ui/modules/ChunaModule.gd")
const SpellModule = preload("res://scripts/ui/modules/SpellModule.gd")
const NeishiModule = preload("res://scripts/ui/modules/NeishiModule.gd")
const CultivationModule = preload("res://scripts/ui/modules/CultivationModule.gd")

var player: Node = null
var inventory: Node = null
var spell_system: Node = null

# 炼丹系统引用
var alchemy_system: Node = null
var recipe_data: Node = null
var alchemy_module = null

# 设置模块
var settings_module = null

# 洞府模块
var dongfu_module = null

# 储纳模块
var chuna_module = null

# 术法模块
var spell_module = null

# 内视模块（新增）
var neishi_module = null

# 修炼突破模块（新增）
var cultivation_module = null

# 境界背景素材配置
const REALM_FRAME_TEXTURES = {
	"炼气期": "res://assets/realm_frames/realm_frame_qi_refining.png",
	"筑基期": "res://assets/realm_frames/realm_frame_foundation.png",
	"金丹期": "res://assets/realm_frames/realm_frame_golden_core.png",
	"元婴期": "res://assets/realm_frames/realm_frame_nascent_soul.png",
	"化神期": "res://assets/realm_frames/realm_frame_spirit_separation.png",
	"炼虚期": "res://assets/realm_frames/realm_frame_void_refining.png",
	"合体期": "res://assets/realm_frames/realm_frame_body_integration.png",
	"大乘期": "res://assets/realm_frames/realm_frame_mahayana.png",
	"渡劫期": "res://assets/realm_frames/realm_frame_tribulation.png"
}

@onready var player_name_label_top: Label = $VBoxContainer/TopBar/TopBarContent/PlayerInfo/PlayerNameLabel
@onready var avatar_texture: TextureRect = $VBoxContainer/TopBar/TopBarContent/PlayerInfo/AvatarContainer/AvatarTexture
@onready var top_bar_background: TextureRect = $VBoxContainer/TopBar/TopBarBackground
@onready var realm_label: Label = $VBoxContainer/TopBar/TopBarContent/RealmContainer/RealmLabel
@onready var spirit_stone_label: Label = $VBoxContainer/TopBar/TopBarContent/SpiritStoneContainer/SpiritStoneLabel

@onready var status_label: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationVisual/CultivationStatusLabel
@onready var health_bar: ProgressBar = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/HealthRow/HealthBar
@onready var health_value: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/HealthRow/HealthValue

# 灵气条
@onready var spirit_bar: ProgressBar = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/SpiritRow/SpiritBar
@onready var spirit_value: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/SpiritRow/SpiritValue

# 属性标签
@onready var attack_label: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/StatsRow/AttackLabel
@onready var defense_label: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/StatsRow/DefenseLabel
@onready var speed_label: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/StatsRow/SpeedLabel
@onready var spirit_gain_label: Label = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/StatusArea/PlayerDataContainer/VBoxContainer/SpiritGainLabel

# 灵气进度条现在在 CultivationContainer 中
#@onready var spirit_progress_bar: Control = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/SpiritProgressBar

# 修炼小人素材
@onready var cultivation_figure: TextureRect = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationVisual/CultivationFigure
@onready var cultivation_figure_particles: TextureRect = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationVisual/CultivationFigureParticles
@onready var cultivation_visual: Control = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationVisual

@onready var log_text: RichTextLabel = $VBoxContainer/LogArea/LogText
@onready var cultivate_button: Button = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationBottomBar/CultivateButton
@onready var breakthrough_button: Button = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationBottomBar/BreakthroughButton
@onready var bottom_bar: HBoxContainer = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer/CultivationBottomBar

@onready var tab_neishi: Button = $VBoxContainer/TabBar/NeishiButton
@onready var tab_chuna: Button = $VBoxContainer/TabBar/ChunaButton
@onready var tab_dongfu: Button = get_node_or_null("VBoxContainer/TabBar/DongfuButton")
@onready var tab_lianli: Button = $VBoxContainer/TabBar/BattleButton
@onready var tab_settings: Button = $VBoxContainer/TabBar/SettingsButton

@onready var neishi_panel: Control = $VBoxContainer/ContentPanel/NeishiPanel
@onready var chuna_panel: Control = $VBoxContainer/ContentPanel/ChunaPanel
@onready var dongfu_panel: Control = get_node_or_null("VBoxContainer/ContentPanel/DongfuPanel")
@onready var lianli_panel: Control = $VBoxContainer/ContentPanel/LianliPanel
@onready var settings_panel: Control = $VBoxContainer/ContentPanel/SettingsPanel

# 内室子Tab
@onready var cultivation_tab: Button = $VBoxContainer/ContentPanel/NeishiPanel/NeishiTabBar/CultivationTab
@onready var meridian_tab: Button = $VBoxContainer/ContentPanel/NeishiPanel/NeishiTabBar/MeridianTab
@onready var spell_tab: Button = $VBoxContainer/ContentPanel/NeishiPanel/NeishiTabBar/SpellTab

@onready var cultivation_panel: Control = $VBoxContainer/ContentPanel/NeishiPanel/CultivationContainer
@onready var meridian_panel: Control = $VBoxContainer/ContentPanel/NeishiPanel/MeridianPanel
@onready var spell_panel: Control = $VBoxContainer/ContentPanel/NeishiPanel/SpellPanel

@onready var save_button: Button = $VBoxContainer/ContentPanel/SettingsPanel/VBoxContainer/SaveButton
@onready var load_button: Button = $VBoxContainer/ContentPanel/SettingsPanel/VBoxContainer/LoadButton

@onready var lianli_select_panel: Control = $VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel
@onready var lianli_scene_panel: Control = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel

@onready var inventory_grid: GridContainer = $VBoxContainer/ContentPanel/ChunaPanel/ScrollContainer/InventoryGrid
@onready var capacity_label: Label = $VBoxContainer/ContentPanel/ChunaPanel/TopBar/CapacityLabel
@onready var expand_button: Button = $VBoxContainer/ContentPanel/ChunaPanel/TopBar/ExpandButton
@onready var sort_button: Button = $VBoxContainer/ContentPanel/ChunaPanel/TopBar/SortButton
@onready var item_detail_panel: Panel = $VBoxContainer/ContentPanel/ChunaPanel/ItemDetailPanel
# 查看按钮（可选）
var view_button: Button = null
@onready var use_button: Button = $VBoxContainer/ContentPanel/ChunaPanel/ItemDetailPanel/VBoxContainer/ButtonContainer/UseButton
@onready var discard_button: Button = $VBoxContainer/ContentPanel/ChunaPanel/ItemDetailPanel/VBoxContainer/ButtonContainer/DiscardButton

@onready var lianli_area_1_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/Area1Button")
@onready var lianli_area_2_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/Area2Button")
@onready var lianli_area_3_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/Area3Button")
@onready var lianli_area_4_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/Area4Button")
@onready var lianli_area_5_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/Area5Button")
@onready var endless_tower_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliSelectPanel/VBoxContainer/EndlessTowerButton")

# 炼丹房UI节点
@onready var alchemy_room_button: Button = get_node_or_null("VBoxContainer/ContentPanel/DongfuPanel/VBoxContainer/AlchemyRoomButton")
@onready var alchemy_room_panel: Control = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel")
@onready var recipe_list_container: VBoxContainer = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/RecipeListPanel/RecipeListVBox/RecipeScroll/RecipeListContainer")
@onready var recipe_name_label: Label = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/RecipeNameLabel")
@onready var success_rate_label: Label = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/SuccessRateLabel")
@onready var craft_time_label: Label = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CraftTimeLabel")
@onready var materials_container: VBoxContainer = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/MaterialsContainer")
@onready var craft_button: Button = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CraftButton")
@onready var count_1_button: Button = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CountHBox/Count1Button")
@onready var count_10_button: Button = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CountHBox/Count10Button")
@onready var count_100_button: Button = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CountHBox/Count100Button")
@onready var count_max_button: Button = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/MainHBox/CraftPanel/CraftVBox/CountHBox/CountMaxButton")
@onready var alchemy_info_label: Label = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/BottomPanel/BottomHBox/AlchemyInfoLabel")
@onready var furnace_info_label: Label = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/BottomPanel/BottomHBox/FurnaceInfoLabel")
@onready var alchemy_log_label: RichTextLabel = get_node_or_null("VBoxContainer/ContentPanel/AlchemyRoomPanel/VBoxContainer/LogPanel/LogLabel")

# 区域按钮列表
var lianli_area_buttons: Array = []
var lianli_area_ids: Array = []

# 无尽塔相关
var endless_tower_data: Node = null

@onready var player_name_label: Label = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/PlayerInfo/PlayerNameLabel
@onready var player_health_bar_lianli: ProgressBar = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/PlayerInfo/PlayerHealthBar
@onready var player_health_value_lianli: Label = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/PlayerInfo/PlayerHealthValue
@onready var enemy_name_label: Label = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/EnemyInfo/EnemyNameLabel
@onready var enemy_health_bar: ProgressBar = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/EnemyInfo/EnemyHealthBar
@onready var enemy_health_value: Label = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/EnemyInfo/EnemyHealthValue
@onready var lianli_status_label: Label = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/LianliStatusLabel

# BattleInfo UI控件
@onready var area_name_label: Label = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleInfo/AreaNameLabel")
@onready var reward_info_label: Label = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleInfo/RewardInfoLabel")

# BattleButtonContainer UI控件
@onready var continuous_checkbox: CheckBox = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleButtonContainer/ContinuousCheckBox")
@onready var continue_button: Button = get_node_or_null("VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleButtonContainer/ContinueButton")
@onready var lianli_speed_button: Button = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleButtonContainer/SpeedExitContainer/LianliSpeedButton
@onready var exit_lianli_button: Button = $VBoxContainer/ContentPanel/LianliPanel/LianliScenePanel/VBoxContainer/BattleButtonContainer/SpeedExitContainer/ExitLianliButton

var log_manager: LogManager = null
var lianli_signals_connected: bool = false

const GRID_COLS = 5

var item_data_ref: Node = null
var spell_data_ref: Node = null
var lianli_system: Node = null
var lianli_area_data: Node = null
var enemy_data: Node = null

var current_lianli_area_id: String = ""
var current_lianli_speed_index: int = 0
const LIANLI_SPEEDS = [1.0, 1.5, 2.0]

func _ready():
	# 安全获取可选节点
	_setup_optional_nodes()
	
	await get_tree().process_frame
	
	setup_log_manager()
	setup_button_connections()
	setup_alchemy_module()
	setup_settings_module()
	setup_dongfu_module()
	setup_chuna_module()
	setup_spell_module()
	setup_neishi_module()
	
	# 在log_manager初始化后添加欢迎消息
	add_log("欢迎来到修仙世界！")
	add_log("点击下方按钮开始修炼")

func _setup_optional_nodes():
	view_button = get_node_or_null("VBoxContainer/ContentPanel/ChunaPanel/ItemDetailPanel/VBoxContainer/ButtonContainer/ViewButton")

	# 监听屏幕大小变化
	get_viewport().size_changed.connect(_on_viewport_size_changed)

	show_neishi_tab()

	# 立即加载游戏数据，去掉0.5秒延迟
	load_game_data()

func _on_viewport_size_changed():
	update_font_sizes()

func update_font_sizes():
	var screen_width = get_viewport().get_visible_rect().size.x
	var scale_factor = screen_width / 720.0
	
	# 更新主要标签字体大小
	var base_font_sizes = {
		"player_name": 26,
		"realm": 24,
		"spirit_stone": 20,
		"status": 20,
		"health_value": 16,
		"log": 14,
		"button": 18
	}
	
	if player_name_label_top:
		player_name_label_top.add_theme_font_size_override("font_size", int(base_font_sizes["player_name"] * scale_factor))
	if realm_label:
		realm_label.add_theme_font_size_override("font_size", int(base_font_sizes["realm"] * scale_factor))
	if spirit_stone_label:
		spirit_stone_label.add_theme_font_size_override("font_size", int(base_font_sizes["spirit_stone"] * scale_factor))
	if status_label:
		status_label.add_theme_font_size_override("font_size", int(base_font_sizes["status"] * scale_factor))
	if health_value:
		health_value.add_theme_font_size_override("font_size", int(base_font_sizes["health_value"] * scale_factor))
	if log_text:
		log_text.add_theme_font_size_override("normal_font_size", int(base_font_sizes["log"] * scale_factor))
	
	# 更新按钮字体
	var buttons = [cultivate_button, breakthrough_button, tab_neishi, tab_chuna, tab_lianli, tab_settings]
	for button in buttons:
		if button:
			button.add_theme_font_size_override("font_size", int(base_font_sizes["button"] * scale_factor))

func _process(delta: float):
	# 更新UI
	if player:
		update_ui()

func setup_log_manager():
	log_manager = LogManager.new()
	log_manager.name = "LogManager"
	add_child(log_manager)
	log_manager.set_rich_text_label(log_text)

func setup_button_connections():
	# [已迁移到CultivationModule] 修炼和突破按钮
	# if cultivate_button:
	# 	cultivate_button.pressed.connect(_on_cultivate_button_pressed)
	# if breakthrough_button:
	# 	breakthrough_button.pressed.connect(_on_breakthrough_button_pressed)
	
	# 使用新模块连接
	if cultivate_button and cultivation_module:
		cultivate_button.pressed.connect(cultivation_module.on_cultivate_button_pressed)
	if breakthrough_button and cultivation_module:
		breakthrough_button.pressed.connect(cultivation_module.on_breakthrough_button_pressed)
	
	if tab_neishi:
		tab_neishi.pressed.connect(_on_tab_neishi_pressed)
	if tab_chuna:
		tab_chuna.pressed.connect(_on_tab_chuna_pressed)
	if tab_dongfu:
		tab_dongfu.pressed.connect(_on_tab_dongfu_pressed)
	if tab_lianli:
		tab_lianli.pressed.connect(_on_tab_lianli_pressed)
	if tab_settings:
		tab_settings.pressed.connect(_on_tab_settings_pressed)
	
	# [已迁移到NeishiModule] 内室子Tab连接
	# if cultivation_tab:
	# 	cultivation_tab.pressed.connect(_on_cultivation_tab_pressed)
	# if meridian_tab:
	# 	meridian_tab.pressed.connect(_on_meridian_tab_pressed)
	# if spell_tab:
	# 	spell_tab.pressed.connect(_on_spell_tab_pressed)
	
	# 使用新模块连接
	if cultivation_tab and neishi_module:
		cultivation_tab.pressed.connect(neishi_module.on_cultivation_tab_pressed)
	if meridian_tab and neishi_module:
		meridian_tab.pressed.connect(neishi_module.on_meridian_tab_pressed)
	if spell_tab and neishi_module:
		spell_tab.pressed.connect(neishi_module.on_spell_tab_pressed)
	
	# 初始化历练区域按钮
	_init_lianli_area_buttons()
	
	# 初始化无尽塔按钮
	_init_endless_tower_button()
	
	# 连接战斗按钮控件信号
	if continuous_checkbox:
		continuous_checkbox.toggled.connect(_on_continuous_toggled)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
	
	if lianli_speed_button:
		lianli_speed_button.pressed.connect(_on_lianli_speed_pressed)
	if exit_lianli_button:
		exit_lianli_button.pressed.connect(_on_exit_lianli_pressed)

func setup_alchemy_module():
	# 创建炼丹模块
	alchemy_module = AlchemyModule.new()
	alchemy_module.name = "AlchemyModule"
	add_child(alchemy_module)
	
	# 设置UI节点引用
	alchemy_module.alchemy_room_panel = alchemy_room_panel
	alchemy_module.recipe_list_container = recipe_list_container
	alchemy_module.recipe_name_label = recipe_name_label
	alchemy_module.success_rate_label = success_rate_label
	alchemy_module.craft_time_label = craft_time_label
	alchemy_module.materials_container = materials_container
	alchemy_module.craft_button = craft_button
	alchemy_module.alchemy_info_label = alchemy_info_label
	alchemy_module.furnace_info_label = furnace_info_label
	alchemy_module.log_label = alchemy_log_label

	# 连接数量选择按钮
	if count_1_button:
		count_1_button.pressed.connect(func(): _on_craft_count_changed(1))
	if count_10_button:
		count_10_button.pressed.connect(func(): _on_craft_count_changed(10))
	if count_100_button:
		count_100_button.pressed.connect(func(): _on_craft_count_changed(100))
	if count_max_button:
		count_max_button.pressed.connect(_on_craft_count_max)

func setup_settings_module():
	# 创建设置模块
	settings_module = SettingsModule.new()
	settings_module.name = "SettingsModule"
	add_child(settings_module)
	
	# 设置UI节点引用
	settings_module.settings_panel = settings_panel
	settings_module.save_button = save_button
	settings_module.load_button = load_button
	
	# 初始化模块
	settings_module.initialize(self, player, null)

func setup_dongfu_module():
	# 创建洞府模块
	dongfu_module = DongfuModule.new()
	dongfu_module.name = "DongfuModule"
	add_child(dongfu_module)
	
	# 设置UI节点引用
	dongfu_module.dongfu_panel = dongfu_panel
	dongfu_module.alchemy_room_button = alchemy_room_button
	
	# 初始化模块
	dongfu_module.initialize(self, player, alchemy_module)

func setup_chuna_module():
	# 创建储纳模块
	chuna_module = ChunaModule.new()
	chuna_module.name = "ChunaModule"
	add_child(chuna_module)
	
	# 设置UI节点引用
	chuna_module.chuna_panel = chuna_panel
	chuna_module.inventory_grid = inventory_grid
	chuna_module.capacity_label = capacity_label
	chuna_module.item_detail_panel = item_detail_panel
	chuna_module.view_button = view_button
	chuna_module.use_button = use_button
	chuna_module.discard_button = discard_button
	chuna_module.expand_button = expand_button
	chuna_module.sort_button = sort_button
	
	# 初始化模块
	chuna_module.initialize(self, player, inventory, item_data_ref, spell_system, spell_data_ref)

func setup_spell_module():
	spell_module = SpellModule.new()
	spell_module.name = "SpellModule"
	add_child(spell_module)
	
	# 设置UI节点引用
	spell_module.spell_panel = spell_panel
	spell_module.spell_tab = spell_tab
	
	# 初始化模块
	spell_module.initialize(self, player, spell_system, spell_data_ref)

func setup_neishi_module():
	# 创建修炼突破模块
	cultivation_module = CultivationModule.new()
	cultivation_module.name = "CultivationModule"
	add_child(cultivation_module)
	
	# 设置UI节点引用
	cultivation_module.cultivation_panel = cultivation_panel
	cultivation_module.cultivate_button = cultivate_button
	cultivation_module.breakthrough_button = breakthrough_button
	
	# 初始化模块
	var game_manager = get_node("/root/GameManager")
	var cult_system = game_manager.get_cultivation_system() if game_manager else null
	var lianli_sys = game_manager.get_lianli_system() if game_manager else null
	cultivation_module.initialize(self, player, cult_system, lianli_sys, item_data_ref)
	
	# 连接信号
	cultivation_module.log_message.connect(_on_cultivation_module_log)
	
	# 创建内视模块
	neishi_module = NeishiModule.new()
	neishi_module.name = "NeishiModule"
	add_child(neishi_module)
	
	# 设置UI节点引用
	neishi_module.neishi_panel = neishi_panel
	neishi_module.cultivation_panel = cultivation_panel
	neishi_module.meridian_panel = meridian_panel
	neishi_module.spell_panel = spell_panel
	neishi_module.cultivation_tab = cultivation_tab
	neishi_module.meridian_tab = meridian_tab
	neishi_module.spell_tab = spell_tab
	
	# 初始化模块
	neishi_module.initialize(self, player)
	
	# 设置子模块
	neishi_module.set_cultivation_module(cultivation_module)
	neishi_module.set_spell_module(spell_module)
	
	# 连接信号
	neishi_module.log_message.connect(_on_neishi_module_log)

func _on_cultivation_module_log(message: String):
	add_log(message)

func _on_neishi_module_log(message: String):
	add_log(message)

func load_game_data():
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		item_data_ref = game_manager.get_item_data()
		spell_data_ref = game_manager.get_spell_data()
		lianli_system = game_manager.get_lianli_system()
		lianli_area_data = game_manager.get_lianli_area_data()
		enemy_data = game_manager.get_enemy_data()
		endless_tower_data = game_manager.get_endless_tower_data()
		set_spell_system(game_manager.get_spell_system())
		
		# 初始化炼丹系统
		set_alchemy_system(game_manager.get_alchemy_system())
		set_recipe_data(game_manager.get_recipe_data())
		set_item_data(game_manager.get_item_data())
		
		if game_manager.get_player():
			set_player(game_manager.get_player())
			add_log("游戏数据加载完成")
		if game_manager.get_inventory():
			set_inventory(game_manager.get_inventory())
		connect_lianli_signals(game_manager.get_lianli_system())
		
		game_manager.offline_reward_received.connect(_on_offline_reward_received)
		game_manager.account_logged_in.connect(_on_account_logged_in)
		
		# 加载当前账号信息
		update_account_ui()

func connect_lianli_signals(battle_sys: Node):
	if battle_sys and not lianli_signals_connected:
		# 历练相关信号
		if battle_sys.has_signal("lianli_started"):
			battle_sys.lianli_started.connect(_on_lianli_started)
		if battle_sys.has_signal("lianli_ended"):
			battle_sys.lianli_ended.connect(_on_lianli_ended)
		if battle_sys.has_signal("lianli_waiting"):
			battle_sys.lianli_waiting.connect(_on_lianli_waiting)
		if battle_sys.has_signal("lianli_action_log"):
			battle_sys.lianli_action_log.connect(_on_lianli_action_log)
		if battle_sys.has_signal("lianli_reward"):
			battle_sys.lianli_reward.connect(_on_lianli_reward)
		
		# 战斗相关信号（新架构）
		if battle_sys.has_signal("battle_started"):
			battle_sys.battle_started.connect(_on_battle_started)
		if battle_sys.has_signal("battle_updated"):
			battle_sys.battle_updated.connect(_on_battle_updated)
		if battle_sys.has_signal("battle_ended"):
			battle_sys.battle_ended.connect(_on_battle_ended)
		if battle_sys.has_signal("battle_action_executed"):
			battle_sys.battle_action_executed.connect(_on_battle_action_executed)
		
		# 兼容旧信号
		if battle_sys.has_signal("lianli_round"):
			battle_sys.lianli_round.connect(_on_lianli_round)
		if battle_sys.has_signal("lianli_win"):
			battle_sys.lianli_win.connect(_on_lianli_win)
		if battle_sys.has_signal("lianli_lose"):
			battle_sys.lianli_lose.connect(_on_lianli_lose)
		
		lianli_signals_connected = true

func set_player(player_node: Node):
	player = player_node
	# 初始化炼丹模块的玩家引用
	if alchemy_module:
		alchemy_module.player = player

func set_spell_system(spell_system_node: Node):
	spell_system = spell_system_node
	# 连接术法使用信号，实现使用次数实时更新
	if spell_system:
		spell_system.spell_used.connect(_on_spell_used)
	# 初始化炼丹模块的术法系统引用
	if alchemy_module:
		alchemy_module.spell_system = spell_system
	# 初始化术法模块的术法系统引用
	if spell_module:
		spell_module.spell_system = spell_system

func set_alchemy_system(alchemy_system_node: Node):
	alchemy_system = alchemy_system_node
	# 初始化炼丹模块的炼丹系统引用
	if alchemy_module:
		alchemy_module.alchemy_system = alchemy_system

func set_recipe_data(recipe_data_node: Node):
	recipe_data = recipe_data_node
	# 初始化炼丹模块的丹方数据引用
	if alchemy_module:
		alchemy_module.recipe_data = recipe_data

func set_item_data(item_data_node: Node):
	# 初始化炼丹模块的物品数据引用
	if alchemy_module:
		alchemy_module.item_data = item_data_node

func _on_spell_used(spell_id: String):
	# 通知术法模块更新使用次数
	if spell_module:
		spell_module.on_spell_used(spell_id)

func set_inventory(inventory_node: Node):
	inventory = inventory_node
	inventory.item_added.connect(_on_item_added)
	# 设置inventory后初始化储纳模块
	if chuna_module:
		chuna_module.setup_inventory_grid()
		chuna_module.update_inventory_ui()

func _on_item_added(item_id: String, count: int):
	if chuna_module:
		chuna_module.update_inventory_ui()
	update_ui()  # 更新灵石数量显示
	add_log("获得物品: " + item_data_ref.get_item_name(item_id) + " x" + str(count))

func show_neishi_tab():
	neishi_panel.visible = true
	chuna_panel.visible = false
	if dongfu_panel:
		dongfu_panel.visible = false
	lianli_panel.visible = false
	settings_panel.visible = false
	# 隐藏炼丹房
	if alchemy_module:
		alchemy_module.hide_alchemy_room()
	# 隐藏储纳Tab
	if chuna_module:
		chuna_module.hide_tab()
	tab_neishi.disabled = true
	tab_chuna.disabled = false
	if tab_dongfu:
		tab_dongfu.disabled = false
	tab_lianli.disabled = false
	tab_settings.disabled = false

	# [已迁移到NeishiModule] 初始化内室子Tab，默认显示修炼页面
	# _show_neishi_sub_panel(cultivation_panel)
	
	# 使用新模块
	if neishi_module:
		neishi_module.show_tab()

func show_chuna_tab():
	neishi_panel.visible = false
	chuna_panel.visible = true
	if dongfu_panel:
		dongfu_panel.visible = false
	lianli_panel.visible = false
	settings_panel.visible = false
	# 隐藏炼丹房
	if alchemy_module:
		alchemy_module.hide_alchemy_room()
	# 显示储纳Tab
	if chuna_module:
		chuna_module.show_tab()
	tab_neishi.disabled = false
	tab_chuna.disabled = true
	if tab_dongfu:
		tab_dongfu.disabled = false
	tab_lianli.disabled = false
	tab_settings.disabled = false
	# 确保面板可见
	if item_detail_panel:
		item_detail_panel.visible = true

func show_dongfu_tab():
	neishi_panel.visible = false
	chuna_panel.visible = false
	if dongfu_panel:
		dongfu_panel.visible = true
	lianli_panel.visible = false
	settings_panel.visible = false
	# 隐藏炼丹房
	if alchemy_module:
		alchemy_module.hide_alchemy_room()
	# 显示洞府Tab
	if dongfu_module:
		dongfu_module.show_tab()
	tab_neishi.disabled = false
	tab_chuna.disabled = false
	if tab_dongfu:
		tab_dongfu.disabled = true
	tab_lianli.disabled = false
	tab_settings.disabled = false

func show_lianli_tab():
	neishi_panel.visible = false
	chuna_panel.visible = false
	if dongfu_panel:
		dongfu_panel.visible = false
	lianli_panel.visible = true
	settings_panel.visible = false
	# 隐藏炼丹房
	if alchemy_module:
		alchemy_module.hide_alchemy_room()
	tab_neishi.disabled = false
	tab_chuna.disabled = false
	if tab_dongfu:
		tab_dongfu.disabled = false
	tab_lianli.disabled = true
	tab_settings.disabled = false

	# 检查是否处于历练中（战斗中或等待中）
	if lianli_system and (lianli_system.is_in_battle or lianli_system.is_waiting or lianli_system.is_in_lianli):
		# 还在历练中，显示战斗场景
		show_lianli_scene_panel()
	else:
		# 历练已结束或未开始，显示选择面板
		show_lianli_select_panel()

func show_settings_tab():
	neishi_panel.visible = false
	chuna_panel.visible = false
	if dongfu_panel:
		dongfu_panel.visible = false
	lianli_panel.visible = false
	settings_panel.visible = true
	# 隐藏炼丹房
	if alchemy_module:
		alchemy_module.hide_alchemy_room()
	# 显示设置Tab
	if settings_module:
		settings_module.show_tab()
	tab_neishi.disabled = false
	tab_chuna.disabled = false
	if tab_dongfu:
		tab_dongfu.disabled = false
	tab_lianli.disabled = false
	tab_settings.disabled = true

func show_lianli_select_panel():
	lianli_select_panel.visible = true
	lianli_scene_panel.visible = false

func show_lianli_scene_panel():
	lianli_select_panel.visible = false
	lianli_scene_panel.visible = true
	
	# 更新战斗信息UI
	_update_battle_info()
	_update_button_container()

# 显示/隐藏无尽塔UI
func _show_tower_ui(show: bool):
	# 无尽塔使用统一的BattleInfo和BattleButtonContainer，不需要特殊处理
	pass

func _on_tab_neishi_pressed():
	show_neishi_tab()

func _on_tab_chuna_pressed():
	show_chuna_tab()

func _on_tab_dongfu_pressed():
	show_dongfu_tab()

func _on_tab_lianli_pressed():
	show_lianli_tab()

func _on_tab_settings_pressed():
	show_settings_tab()

# 初始化历练区域按钮
func _init_lianli_area_buttons():
	lianli_area_buttons = []
	lianli_area_ids = []
	
	# 收集所有按钮（前4个是普通区域，第5个是特殊区域）
	if lianli_area_1_button:
		lianli_area_buttons.append(lianli_area_1_button)
	if lianli_area_2_button:
		lianli_area_buttons.append(lianli_area_2_button)
	if lianli_area_3_button:
		lianli_area_buttons.append(lianli_area_3_button)
	if lianli_area_4_button:
		lianli_area_buttons.append(lianli_area_4_button)
	if lianli_area_5_button:
		lianli_area_buttons.append(lianli_area_5_button)
	
	# 获取普通区域和特殊区域ID
	var normal_area_ids = []
	var special_area_ids = []
	
	if lianli_area_data:
		normal_area_ids = lianli_area_data.get_normal_area_ids()
		special_area_ids = lianli_area_data.get_special_area_ids()
	else:
		# 默认区域ID
		normal_area_ids = ["qi_refining_outer", "qi_refining_inner", "foundation_outer", "foundation_inner"]
		special_area_ids = ["foundation_herb_cave"]
	
	# 合并区域ID：先普通区域，后特殊区域
	lianli_area_ids = normal_area_ids + special_area_ids
	
	# 更新按钮文本和连接信号
	for i in range(lianli_area_buttons.size()):
		var button = lianli_area_buttons[i]
		if i < lianli_area_ids.size():
			var area_id = lianli_area_ids[i]
			var area_name = lianli_area_data.get_area_name(area_id) if lianli_area_data else area_id
			button.text = area_name
			button.visible = true
			# 断开之前的连接（避免重复连接）
			var connections = button.get_signal_connection_list("pressed")
			for conn in connections:
				button.pressed.disconnect(conn.callable)
			# 使用闭包连接信号
			button.pressed.connect(_on_lianli_area_pressed.bind(area_id))
		else:
			button.visible = false

# 统一的区域按钮处理函数
func _on_lianli_area_pressed(area_id: String):
	current_lianli_area_id = area_id
	start_lianli_in_area(current_lianli_area_id)

# ==================== 无尽塔功能 ====================

# 初始化无尽塔按钮
func _init_endless_tower_button():
	if endless_tower_button:
		endless_tower_button.pressed.connect(_on_endless_tower_pressed)
		_update_endless_tower_button_text()

# 更新无尽塔按钮文本
func _update_endless_tower_button_text():
	if not endless_tower_button:
		return
	
	var tower_name = "无尽塔"
	var current_floor = 1
	var max_floor = 51
	
	if endless_tower_data:
		tower_name = endless_tower_data.get_tower_name()
		max_floor = endless_tower_data.get_max_floor()
	
	if player:
		current_floor = min(player.tower_highest_floor + 1, max_floor)
	
	endless_tower_button.text = tower_name + " (第" + str(current_floor) + "层)"

# 无尽塔按钮点击处理
func _on_endless_tower_pressed():
	if not lianli_system:
		add_log("错误: lianli_system 未初始化")
		return
	if not player:
		add_log("错误: player 未初始化")
		return
	
	# 检测气血值
	if player.health <= 0:
		add_log("气血值不足，无法进入无尽塔！请先修炼恢复气血值。")
		return
	
	# 如果正在修炼，先停止修炼
	if player.get_is_cultivating():
		var game_manager = get_node("/root/GameManager")
		var cult_system = game_manager.get_cultivation_system()
		player.stop_cultivation()
		cult_system.stop_cultivation()
		cultivate_button.text = "修炼"
		add_log("已停止修炼")
	
	# 开始无尽塔
	var result = lianli_system.start_endless_tower()
	if result:
		show_lianli_scene_panel()
		_update_battle_info()
		_update_button_container()
		# 设置连续战斗默认值（无尽塔默认不勾选）
		_set_continuous_default()
	else:
		add_log("无尽塔挑战开始失败")

# 更新战斗信息UI显示
func _update_battle_info():
	if not lianli_system:
		return
	
	# 更新区域名称
	if area_name_label:
		if lianli_system.is_in_endless_tower():
			area_name_label.text = "无尽塔 - 第 " + str(lianli_system.get_current_tower_floor()) + " 层"
		elif current_lianli_area_id != "":
			area_name_label.text = lianli_area_data.get_area_name(current_lianli_area_id)
		else:
			area_name_label.text = ""
	
	# 更新奖励信息
	if reward_info_label:
		if lianli_system.is_in_endless_tower():
			# 无尽塔显示距离奖励层数
			if endless_tower_data:
				var current_floor = lianli_system.get_current_tower_floor()
				var next_reward_floor = endless_tower_data.get_next_reward_floor(current_floor)
				if next_reward_floor > 0:
					var floors_to_reward = next_reward_floor - current_floor
					var reward_desc = endless_tower_data.get_reward_description(next_reward_floor)
					reward_info_label.text = "再挑战 " + str(floors_to_reward) + " 层获得 " + reward_desc
				else:
					reward_info_label.text = "已达到最高奖励层"
		else:
			# 普通区域显示敌人掉落
			reward_info_label.text = _get_area_reward_text()

# 获取区域奖励文本
func _get_area_reward_text() -> String:
	if not lianli_area_data or current_lianli_area_id == "":
		return ""
	
	# 检查是否是特殊区域
	if lianli_area_data.is_special_area(current_lianli_area_id):
		# 特殊区域使用 special_drops 配置
		var special_drops = lianli_area_data.get_special_drops(current_lianli_area_id)
		if special_drops.is_empty():
			return ""
		
		var drops_text = []
		for item_id in special_drops.keys():
			var amount = special_drops[item_id]
			if item_id == "spirit_stone":
				drops_text.append(str(amount) + " 灵石")
			else:
				# 其他物品显示数量和名称
				var item_name = item_id
				if item_data_ref:
					item_name = item_data_ref.get_item_name(item_id)
				drops_text.append(str(amount) + "x " + item_name)
		return "通关奖励: " + ", ".join(drops_text) if drops_text.size() > 0 else ""
	else:
		# 普通区域显示当前敌人的灵石掉落
		if not lianli_system:
			return ""
		
		var drops = lianli_system.get_current_enemy_drops()
		if drops.has("spirit_stone"):
			var stone_drop = drops["spirit_stone"]
			var min_amount = stone_drop.get("min", 0)
			var max_amount = stone_drop.get("max", 0)
			return "掉落: " + str(min_amount) + "-" + str(max_amount) + " 灵石"
		return ""

# 更新按钮容器显示（只控制可见性，不修改勾选状态）
func _update_button_container():
	if not lianli_system:
		return
	
	var is_tower = lianli_system.is_in_endless_tower()
	# 无尽塔不是特殊区域，普通区域才需要检查是否是特殊区域
	var is_special = not is_tower and lianli_area_data and lianli_area_data.is_special_area(current_lianli_area_id)
	
	# 连续战斗复选框
	if continuous_checkbox:
		if is_special:
			# 破境草洞穴隐藏连续战斗
			continuous_checkbox.visible = false
		else:
			continuous_checkbox.visible = true
			# 不修改勾选状态，保持用户的选择
	
	# 继续战斗按钮
	if continue_button:
		if is_special:
			# 破境草洞穴隐藏继续战斗
			continue_button.visible = false
		else:
			continue_button.visible = true
			# 默认禁用，战斗胜利后启用
			continue_button.disabled = true
	
	# 确保倍速和退出按钮始终可见
	if lianli_speed_button:
		lianli_speed_button.visible = true
	if exit_lianli_button:
		exit_lianli_button.visible = true

# 设置连续战斗默认值（只在进入区域时调用一次）
func _set_continuous_default():
	if not lianli_system:
		return
	
	var is_tower = lianli_system.is_in_endless_tower()
	var is_special = lianli_area_data and lianli_area_data.is_special_area(current_lianli_area_id)
	
	if continuous_checkbox and not is_special:
		if is_tower:
			# 无尽塔默认不勾选
			continuous_checkbox.button_pressed = false
		else:
			# 普通区域默认勾选
			continuous_checkbox.button_pressed = true

# 继续战斗按钮点击
func _on_continue_pressed():
	if not lianli_system:
		return
	
	# 如果正在战斗中或准备中，不响应
	if lianli_system.is_in_battle:
		return
	
	# 如果正在等待中，不响应（等待会自动开始下一场）
	if lianli_system.is_waiting:
		return
	
	# 开始等待下一场战斗
	if lianli_system.start_wait_for_next_battle():
		continue_button.disabled = true
		_update_battle_info()

# 连续战斗复选框切换
func _on_continuous_toggled(enabled: bool):
	# 连续战斗勾选只是一个状态，不直接控制逻辑
	# 逻辑在战斗结束时根据此状态决定
	pass

# 启用继续战斗按钮（战斗胜利后调用）
func _enable_continue_button():
	if continue_button and continue_button.visible:
		continue_button.disabled = false

# 检查是否勾选了连续战斗
func _is_continuous_checked() -> bool:
	if continuous_checkbox and continuous_checkbox.visible:
		return continuous_checkbox.button_pressed
	return false

# ==================== 普通历练功能 ====================

func start_lianli_in_area(area_id: String):
	if not lianli_system:
		add_log("错误: lianli_system 未初始化")
		return
	if not player:
		add_log("错误: player 未初始化")
		return
	# 检测气血值，小于等于0时不能进入历练区域
	if player.health <= 0:
		add_log("气血值不足，无法进入历练区域！请先修炼恢复气血值。")
		return
	
	# 如果正在修炼，先停止修炼
	if player.get_is_cultivating():
		var game_manager = get_node("/root/GameManager")
		var cult_system = game_manager.get_cultivation_system()
		player.stop_cultivation()
		cult_system.stop_cultivation()
		cultivate_button.text = "修炼"
		add_log("已停止修炼")
	
	# 如果正在无尽塔中，先退出
	if lianli_system.is_in_endless_tower():
		lianli_system.exit_tower()
	
	lianli_system.set_current_area(area_id)
	var result = lianli_system.start_lianli_in_area(area_id)
	if result:
		show_lianli_scene_panel()
		# 设置连续战斗默认值
		_set_continuous_default()
	else:
		add_log("历练开始失败")

func _on_lianli_speed_pressed():
	current_lianli_speed_index = (current_lianli_speed_index + 1) % LIANLI_SPEEDS.size()
	var new_speed = LIANLI_SPEEDS[current_lianli_speed_index]
	if lianli_system:
		lianli_system.set_lianli_speed(new_speed)
	lianli_speed_button.text = "历练速度: " + str(new_speed) + "x"

func _on_exit_lianli_pressed():
	if lianli_system:
		lianli_system.end_lianli()
	show_lianli_select_panel()

func _on_craft_count_changed(count: int):
	if alchemy_module:
		alchemy_module.set_craft_count(count)

# 炼制数量Max
func _on_craft_count_max():
	if alchemy_module:
		var max_count = alchemy_module.get_max_craft_count()
		alchemy_module.set_craft_count(max_count)

func update_ui():
	if not player:
		return
	
	var status = player.get_status_dict()
	
	# 根据境界和层数显示不同的文本（使用RealmSystem查表）
	var game_manager = get_node_or_null("/root/GameManager")
	var realm_system = game_manager.get_realm_system() if game_manager else null
	var level_name = ""
	if realm_system:
		level_name = realm_system.get_level_name(status.realm, status.realm_level)
	else:
		# 备用逻辑：如果无法获取realm_system，使用默认格式
		if status.realm_level == 10:
			level_name = "大圆满"
		else:
			level_name = "第" + str(status.realm_level) + "层"
	realm_label.text = status.realm + " " + level_name
	
	# 更新境界背景图片
	update_realm_background(status.realm)
	
	var stone_count = 0
	if inventory:
		stone_count = inventory.get_item_count("spirit_stone")
	spirit_stone_label.text = "灵石: " + UIUtils.format_number(stone_count)
	
	# 使用最终属性更新显示
	if player:
		var final_max_health = player.get_final_max_health()
		health_bar.max_value = final_max_health
		health_bar.value = status.health
		health_value.text = AttributeCalculator.format_health_spirit(status.health) + "/" + AttributeCalculator.format_health_spirit(final_max_health)
	else:
		health_bar.max_value = status.max_health
		health_bar.value = status.health
		health_value.text = str(status.health) + "/" + str(status.max_health)

	# 更新灵气条
	if spirit_bar:
		if player:
			spirit_bar.max_value = player.get_final_max_spirit_energy()
		else:
			spirit_bar.max_value = status.max_spirit_energy
		spirit_bar.value = status.spirit_energy
	if spirit_value:
		if player:
			spirit_value.text = AttributeCalculator.format_health_spirit(status.spirit_energy) + "/" + AttributeCalculator.format_health_spirit(player.get_final_max_spirit_energy())
		else:
			spirit_value.text = AttributeCalculator.format_health_spirit(status.spirit_energy) + "/" + AttributeCalculator.format_health_spirit(status.max_spirit_energy)
	
	# 更新属性显示
	if player:
		if attack_label:
			attack_label.text = "攻击: " + AttributeCalculator.format_attack_defense(player.get_final_attack())
		if defense_label:
			defense_label.text = "防御: " + AttributeCalculator.format_attack_defense(player.get_final_defense())
		if speed_label:
			speed_label.text = "速度: " + AttributeCalculator.format_speed(player.get_final_speed())
		if spirit_gain_label:
			spirit_gain_label.text = "灵气获取: " + AttributeCalculator.format_spirit_gain_speed(player.get_final_spirit_gain_speed()) + "/秒"
	
	if status.is_cultivating:
		status_label.text = "修炼中..."
		status_label.modulate = Color.GREEN
		# 修炼时：隐藏基础小人，显示特效小人
		if cultivation_figure:
			cultivation_figure.visible = false
		if cultivation_figure_particles:
			cultivation_figure_particles.visible = true
	else:
		status_label.text = "未修炼"
		status_label.modulate = Color.GRAY
		# 停止修炼时：显示基础小人，隐藏特效小人
		if cultivation_figure:
			cultivation_figure.visible = true
		if cultivation_figure_particles:
			cultivation_figure_particles.visible = false
	
	# 突破按钮一直可用，根据状态显示不同文本
	var breakthrough_info = status.get("can_breakthrough", {})
	breakthrough_button.disabled = false
	if breakthrough_info.get("type") == "realm":
		breakthrough_button.text = "破境"
	else:
		breakthrough_button.text = "突破"

func update_realm_background(realm_name: String):
	if not top_bar_background:
		return

	var texture_path = REALM_FRAME_TEXTURES.get(realm_name, REALM_FRAME_TEXTURES["筑基期"])
	var texture = load(texture_path)
	if texture:
		top_bar_background.texture = texture

# [已迁移到CultivationModule] 修炼按钮处理
# func _on_cultivate_button_pressed():
# 	if not player:
# 		return
# 	
# 	var game_manager = get_node("/root/GameManager")
# 	var cult_system = game_manager.get_cultivation_system()
# 	
# 	if player.get_is_cultivating():
# 		player.stop_cultivation()
# 		cult_system.stop_cultivation()
# 		cultivate_button.text = "修炼"
# 		add_log("停止修炼")
# 	else:
# 		# 如果正在历练或等待中，先停止历练
# 		if lianli_system and (lianli_system.is_in_lianli or lianli_system.is_waiting):
# 			lianli_system.end_lianli()
# 			add_log("已退出历练区域，停止历练")
# 			show_neishi_tab()
# 		
# 		player.start_cultivation()
# 		cult_system.start_cultivation()
# 		cultivate_button.text = "停止修炼"
# 		add_log("开始修炼")

# 新模块会处理修炼按钮，这里保留空函数占位
func _on_cultivate_button_pressed():
	pass

func _on_lianli_started(area_id: String):
	# 历练开始（进入历练区域）
	var area_name = ""
	if lianli_area_data:
		area_name = lianli_area_data.get_area_name(area_id)
	if area_name.is_empty():
		area_name = "历练区域"
	lianli_status_label.text = "进入" + area_name + "..."
	lianli_status_label.modulate = Color.YELLOW

func _on_battle_started(enemy_name: String, is_elite: bool, enemy_max_health: int, enemy_level: int, player_max_health: int = 0):
	# 战斗开始（单场对决）
	var elite_tag = " [精英]" if is_elite else ""
	enemy_name_label.text = enemy_name + " Lv." + str(enemy_level) + elite_tag
	enemy_name_label.modulate = Color.RED if is_elite else Color.WHITE
	lianli_status_label.text = "战斗中..."
	lianli_status_label.modulate = Color.YELLOW
	
	# 初始化血条
	enemy_health_bar.max_value = enemy_max_health
	enemy_health_bar.value = enemy_max_health
	enemy_health_value.text = str(enemy_max_health) + "/" + str(enemy_max_health)
	
	# 立即加载并显示敌人和玩家的满血状态
	enemy_health_bar.max_value = enemy_max_health
	enemy_health_bar.value = enemy_max_health
	enemy_health_value.text = str(enemy_max_health) + "/" + str(enemy_max_health)
	
	# 显示玩家当前生命值（使用战斗中的最大气血）
	if player:
		# 如果没有传入player_max_health，则使用player.get_combat_max_health()
		var combat_max_health = player_max_health if player_max_health > 0 else player.get_combat_max_health()
		player_health_bar_lianli.max_value = combat_max_health
		player_health_bar_lianli.value = player.health
		player_health_value_lianli.text = str(player.health) + "/" + str(combat_max_health)
	
	# 更新战斗信息UI
	_update_battle_info()
	_update_button_container()
	
	if log_manager:
		log_manager.add_battle_log("遭遇敌人: " + enemy_name + elite_tag)
	else:
		add_log("遭遇敌人: " + enemy_name + elite_tag)

func _on_lianli_round(_damage_to_enemy: int, damage_to_player: int, enemy_health: int, player_health: int):
	# 第一回合开始时更新状态文本
	if lianli_status_label.text == "准备历练...":
		lianli_status_label.text = "历练中..."
	
	# 使用信号参数更新敌人血条
	enemy_health_bar.value = max(0, enemy_health)
	enemy_health_value.text = str(max(0, enemy_health)) + "/" + str(int(enemy_health_bar.max_value))
	
	# 更新玩家生命条（使用战斗中的最大气血）
	if player:
		var combat_max_health = player.get_combat_max_health()
		player_health_bar_lianli.max_value = combat_max_health
		player_health_bar_lianli.value = max(0, player_health)
		player_health_value_lianli.text = str(max(0, player_health)) + "/" + str(combat_max_health)

func _on_battle_updated(player_atb: float, enemy_atb: float, player_health: int, enemy_health: int, player_max_health: int, enemy_max_health: int):
	# ATB满值行动后更新UI（血条、ATB条等）
	
	# 更新敌人血条
	enemy_health_bar.max_value = enemy_max_health
	enemy_health_bar.value = max(0, enemy_health)
	enemy_health_value.text = str(max(0, enemy_health)) + "/" + str(enemy_max_health)
	
	# 更新玩家生命条
	player_health_bar_lianli.max_value = player_max_health
	player_health_bar_lianli.value = max(0, player_health)
	player_health_value_lianli.text = str(max(0, player_health)) + "/" + str(player_max_health)
	
	# TODO: 更新ATB条（如果有ATB进度条的话）
	# player_atb_bar.value = player_atb
	# enemy_atb_bar.value = enemy_atb

func _on_lianli_ended(victory: bool):
	# 历练结束（完全退出历练区域）
	if victory:
		lianli_status_label.text = "历练完成"
		lianli_status_label.modulate = Color.GREEN
	else:
		lianli_status_label.text = "历练结束"
		lianli_status_label.modulate = Color.YELLOW
	
	# 更新无尽塔按钮文本（层数可能已更新）
	_update_endless_tower_button_text()

func _on_battle_ended(victory: bool, loot: Array, enemy_name: String):
	# 单场战斗结束
	# 注意：物品掉落通过 lianli_reward 信号处理，由 Inventory 系统负责提示
	# 历练系统不再在富文本框中提示物品获取
	if victory:
		# 检查是否勾选了连续战斗
		if _is_continuous_checked():
			# 勾选了连续战斗，自动开始等待下一场
			if lianli_system.start_wait_for_next_battle():
				# 连续战斗开始，按钮保持禁用
				pass
		else:
			# 没有勾选连续战斗，启用继续战斗按钮
			_enable_continue_button()
	else:
		# 战斗失败
		lianli_status_label.text = "战斗失败..."
		lianli_status_label.modulate = Color.RED

func _on_battle_action_executed(is_player: bool, damage: int, is_spell: bool, spell_name: String):
	# 战斗行动执行（可用于显示战斗动画等）
	pass

# 兼容旧信号
func _on_lianli_win(_loot: Array, _enemy_name: String):
	var area_name = ""
	if lianli_area_data and current_lianli_area_id:
		area_name = lianli_area_data.get_area_name(current_lianli_area_id)
	
	if area_name.is_empty():
		area_name = "历练区域"
	
	# 判断是否是普通历练场
	var is_common_area = (current_lianli_area_id == "qi_refining_outer" or current_lianli_area_id == "qi_refining_inner" or current_lianli_area_id == "foundation_outer" or current_lianli_area_id == "foundation_inner")
	
	# 只有特殊历练场才显示通关提示
	if not is_common_area:
		lianli_status_label.text = "通关" + area_name + "！"
		lianli_status_label.modulate = Color.GREEN
		if log_manager:
			log_manager.add_battle_log("通关" + area_name + "！")

func _on_lianli_reward(item_id: String, amount: int, _source: String):
	if inventory:
		inventory.add_item(item_id, amount)
		if chuna_module:
			chuna_module.update_inventory_ui()

func _on_lianli_lose():
	lianli_status_label.text = "历练失败..."
	lianli_status_label.modulate = Color.RED
	if log_manager:
		log_manager.add_battle_log("历练失败，已自动退出历练区域")
	else:
		add_log("历练失败，已自动退出历练区域")
	show_lianli_select_panel()

## 刷新储纳UI
func refresh_inventory_ui():
	if chuna_module:
		chuna_module.update_inventory_ui()

func _on_lianli_waiting(time_remaining: float):
	lianli_status_label.text = "等待下一场历练... (" + str(ceil(time_remaining)) + "秒)"
	lianli_status_label.modulate = Color.GRAY

func _on_lianli_action_log(message: String):
	# 战斗日志使用 add_battle_log
	if log_manager:
		log_manager.add_battle_log(message)
	else:
		add_log(message)

# [已迁移到CultivationModule] 突破按钮处理
# func _on_breakthrough_button_pressed():
# 	if not player:
# 		return
# 	
# 	var result = player.attempt_breakthrough()
# 	if result.get("success", false):
# 		# 突破成功后恢复生命值到满
# 		player.health = player.max_health
# 		var stone_cost = result.get("stone_cost", 0)
# 		var energy_cost = result.get("energy_cost", 0)
# 		var materials = result.get("materials", {})
# 		var type = result.get("type", "level")
# 		
# 		if type == "level":
# 			var new_level = result.get("new_level", 1)
# 			var success_msg = build_breakthrough_message(stone_cost, energy_cost, materials, "突破成功！")
# 			add_log(success_msg)
# 			add_log("升至第" + str(new_level) + "层！气血值已恢复满！")
# 		else:
# 			var new_realm = result.get("new_realm", "")
# 			var success_msg = build_breakthrough_message(stone_cost, energy_cost, materials, "晋升成功！")
# 			add_log(success_msg)
# 			add_log("进入" + new_realm + "！气血值已恢复满！")
# 	else:
# 		var reason = result.get("reason", "突破失败")
# 		var stone_cost = result.get("stone_cost", 0)
# 		var energy_cost = result.get("energy_cost", 0)
# 		var stone_current = result.get("stone_current", 0)
# 		var energy_current = result.get("energy_current", 0)
# 		var materials = result.get("materials", {})
# 		
# 		if reason == "灵气不足":
# 			add_log("突破失败：灵气不足 (" + str(energy_current) + "/" + str(energy_cost) + ")")
# 		elif reason == "灵石不足":
# 			add_log("突破失败：灵石不足 (" + str(stone_current) + "/" + str(stone_cost) + ")")
# 		elif reason.ends_with("不足"):
# 			# 材料不足提示
# 			for material_id in materials.keys():
# 				var material_info = materials[material_id]
# 				if not material_info.get("enough", true):
# 					var material_name = item_data_ref.get_item_name(material_id)
# 					var current = material_info.get("current", 0)
# 					var required = material_info.get("required", 0)
# 					add_log("突破失败：" + material_name + "不足 (" + str(current) + "/" + str(required) + ")")
# 					break
# 		else:
# 			add_log("突破失败：" + reason)

# 新模块会处理突破按钮，这里保留空函数占位
func _on_breakthrough_button_pressed():
	pass

# [已迁移到CultivationModule] 构建突破消息
# func build_breakthrough_message(stone_cost: int, energy_cost: int, materials: Dictionary, suffix: String) -> String:
# 	var msg = "消耗灵石" + str(stone_cost) + "、灵气" + str(energy_cost)
# 	
# 	for material_id in materials.keys():
# 		var material_info = materials[material_id]
# 		var required_count = material_info.get("required", 0)
# 		if required_count > 0:
# 			var material_name = item_data_ref.get_item_name(material_id)
# 			msg += "、" + material_name + str(required_count)
# 	
# 	msg += "，" + suffix
# 	return msg

func add_log(message: String):
	if log_manager:
		log_manager.add_log(message)

func _on_offline_reward_received(rewards: Dictionary):
	if rewards and rewards.get("offline_hours", 0) > 0:
		var offline_seconds = rewards.get("offline_seconds", 0)
		var spirit_energy = rewards["spirit_energy"]
		var spirit_stone = rewards["spirit_stone"]
		
		# 计算小时和分钟
		var total_minutes = int(offline_seconds / 60)
		var hours = int(total_minutes / 60)
		var minutes = total_minutes % 60
		
		# 始终显示小时和分钟，即使为0
		var time_str = str(hours) + "小时" + str(minutes) + "分钟"
		
		add_log("===================================")
		add_log("离线总计时间: " + time_str)
		add_log("获得奖励：")
		add_log("  - 灵气: " + str(int(spirit_energy)))
		add_log("  - 灵石: " + str(spirit_stone))
		add_log("===================================")

func _on_account_logged_in(account_info: Dictionary):
	update_account_ui()

func update_account_ui():
	var game_manager = get_node("/root/GameManager")
	if not game_manager:
		return
	
	var account_system = game_manager.get_account_system()
	if not account_system:
		return
	
	var account_info = account_system.get_current_account()
	if account_info.is_empty():
		return
	
	# 更新昵称显示
	var nickname = account_info.get("nickname", "hsams")
	if player_name_label_top:
		player_name_label_top.text = nickname
	
	# 更新头像显示
	var avatar_file = account_info.get("avatar", "avatar_abstract.png")
	if avatar_texture:
		var avatar_path = "res://assets/avatars/" + avatar_file
		var texture = load(avatar_path)
		if texture:
			avatar_texture.texture = texture
			add_log("头像加载成功: " + avatar_file)
		else:
			add_log("头像加载失败: " + avatar_path)

# [已迁移到NeishiModule] 更新内视Tab按钮状态
# func _update_neishi_tab_buttons(active_panel: Control):
# 	# 更新按钮视觉状态（通过modulate颜色区分）
# 	if cultivation_tab:
# 		cultivation_tab.modulate = Color(0.5, 0.5, 0.5) if active_panel == cultivation_panel else Color(1, 1, 1)
# 	if meridian_tab:
# 		meridian_tab.modulate = Color(0.5, 0.5, 0.5) if active_panel == meridian_panel else Color(1, 1, 1)
# 	if spell_tab:
# 		spell_tab.modulate = Color(0.5, 0.5, 0.5) if active_panel == spell_panel else Color(1, 1, 1)

# [已迁移到NeishiModule] 内室子Tab切换函数
# func _on_cultivation_tab_pressed():
# 	_show_neishi_sub_panel(cultivation_panel)

# func _on_meridian_tab_pressed():
# 	_show_neishi_sub_panel(meridian_panel)

# func _on_spell_tab_pressed():
# 	_show_neishi_sub_panel(spell_panel)
# 	if spell_module:
# 		spell_module.show_tab()

# 新模块会处理Tab切换，这里保留空函数占位
func _on_cultivation_tab_pressed():
	pass

func _on_meridian_tab_pressed():
	pass

func _on_spell_tab_pressed():
	pass

# [已迁移到NeishiModule] 显示内视子面板
# func _show_neishi_sub_panel(active_panel: Control):
# 	# 隐藏所有子面板
# 	if cultivation_panel:
# 		cultivation_panel.visible = false
# 	if meridian_panel:
# 		meridian_panel.visible = false
# 	if spell_panel:
# 		spell_panel.visible = false
# 	
# 	# 显示选中的面板
# 	if active_panel:
# 		active_panel.visible = true
# 	
# 	# 更新按钮状态
# 	_update_neishi_tab_buttons(active_panel)
