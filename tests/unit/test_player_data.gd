extends Node

var helper: Node = null
var test_player: Node = null

func _ready():
	helper = load("res://tests/test_helper.gd").new()
	add_child(helper)

func run_tests():
	print("\n=== PlayerData 单元测试 ===")
	helper.reset_stats()
	
	test_player = load("res://scripts/core/PlayerData.gd").new()
	add_child(test_player)
	
	test_initialization()
	test_spirit_energy()
	test_spirit_stone()
	test_health()
	test_realm()
	test_cultivation()
	test_save_data()
	
	return helper.failed_count == 0

func test_initialization():
	helper.assert_true(test_player != null, "PlayerData", "模块初始化")
	helper.assert_eq(test_player.realm, "炼气期", "PlayerData", "初始境界")
	helper.assert_eq(test_player.realm_level, 1, "PlayerData", "初始境界等级")
	helper.assert_eq(test_player.health, 50, "PlayerData", "初始生命")
	helper.assert_eq(test_player.attack, 5, "PlayerData", "初始攻击")
	helper.assert_eq(test_player.defense, 2, "PlayerData", "初始防御")

func test_spirit_energy():
	test_player.spirit_energy = 0
	test_player.max_spirit_energy = 100  # 设置测试用的灵气上限
	
	test_player.add_spirit_energy(50)
	helper.assert_eq(test_player.spirit_energy, 50, "PlayerData", "添加灵气")
	
	test_player.add_spirit_energy(100)
	helper.assert_eq(test_player.spirit_energy, 100, "PlayerData", "灵气上限")

func test_spirit_stone():
	# spirit_stone 现在由 Inventory 系统管理，PlayerData 中已移除该字段
	# 此测试保留用于兼容性，但不再测试 PlayerData 中的 spirit_stone
	pass

func test_health():
	test_player.health = 50
	test_player.max_health = 50
	
	test_player.health -= 10
	helper.assert_eq(test_player.health, 40, "PlayerData", "受到伤害")
	
	test_player.health = min(test_player.health + 5, test_player.max_health)
	helper.assert_eq(test_player.health, 45, "PlayerData", "治疗")

func test_realm():
	test_player.realm = "炼气期"
	test_player.realm_level = 5
	test_player.apply_realm_stats()
	helper.assert_eq(test_player.realm, "炼气期", "PlayerData", "设置境界")
	helper.assert_eq(test_player.realm_level, 5, "PlayerData", "设置境界等级")
	helper.assert_eq(test_player.max_health, 76, "PlayerData", "境界属性生效")

func test_cultivation():
	test_player.start_cultivation()
	helper.assert_true(test_player.cultivation_active == true, "PlayerData", "开始修炼")
	
	test_player.stop_cultivation()
	helper.assert_true(test_player.cultivation_active == false, "PlayerData", "停止修炼")

func test_save_data():
	var status = test_player.get_status_dict()
	helper.assert_true(status.has("realm"), "PlayerData", "状态字典-包含realm")
	helper.assert_true(status.has("health"), "PlayerData", "状态字典-包含health")
	# spirit_stone 由 Inventory 系统管理，不再在 PlayerData 存档中
	# helper.assert_true(status.has("spirit_stone"), "PlayerData", "状态字典-包含spirit_stone")
	
	var save_data = test_player.get_save_data()
	helper.assert_true(save_data.has("realm"), "PlayerData", "存档数据-realm")
	helper.assert_true(save_data.has("spirit_energy"), "PlayerData", "存档数据-spirit_energy")
	# spirit_stone 由 Inventory 系统管理，不再在 PlayerData 存档中
	# helper.assert_true(save_data.has("spirit_stone"), "PlayerData", "存档数据-spirit_stone")
