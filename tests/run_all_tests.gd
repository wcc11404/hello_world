extends Node

enum TestMode { UNIT, INTEGRATION, ALL }

var helper: Node = null
var total_passed: int = 0
var total_failed: int = 0
var total_tests: int = 0

func _ready():
	print("========================================")
	print("修仙挂机游戏 - 全系统测试")
	print("========================================")
	
	helper = load("res://tests/test_helper.gd").new()
	add_child(helper)
	
	await get_tree().create_timer(0.5).timeout
	
	await run_tests(TestMode.ALL)
	
	print_final_summary()
	get_tree().quit(0 if total_failed == 0 else 1)

func run_tests(mode: TestMode):
	if mode == TestMode.UNIT or mode == TestMode.ALL:
		print("\n\n========================================")
		print("开始运行单元测试...")
		print("========================================")
		await run_unit_tests()
	
	if mode == TestMode.INTEGRATION or mode == TestMode.ALL:
		print("\n\n========================================")
		print("开始运行集成测试...")
		print("========================================")
		await run_integration_tests()

func run_unit_tests():
	var unit_tests = [
		"test_item_data",
		"test_inventory",
		"test_player_data",
		"test_realm_system",
		"test_cultivation_system",
		"test_lianli_system",
		"test_offline_reward",
		"test_save_manager",
		"test_log_manager",
		"test_lianli_area_data",
		"test_enemy_data"
	]
	
	for test_name in unit_tests:
		var test_script = load("res://tests/unit/" + test_name + ".gd")
		if not test_script:
			print("✗ 无法加载测试: " + test_name)
			continue
		
		var test_node = test_script.new()
		add_child(test_node)
		
		await get_tree().process_frame
		
		var success = test_node.run_tests()
		var test_helper = test_node.helper
		
		total_passed += test_helper.passed_count
		total_failed += test_helper.failed_count
		total_tests += test_helper.test_count
		
		test_node.queue_free()

func run_integration_tests():
	var test_script = load("res://tests/integration/test_all_systems.gd")
	if not test_script:
		print("✗ 无法加载集成测试")
		return
	
	var test_node = test_script.new()
	add_child(test_node)
	
	await get_tree().process_frame
	
	var success = await test_node.run_tests()
	var test_helper = test_node.helper
	
	total_passed += test_helper.passed_count
	total_failed += test_helper.failed_count
	total_tests += test_helper.test_count
	
	test_node.queue_free()

func print_final_summary():
	print("\n\n")
	print("========================================")
	print("最终测试总结")
	print("========================================")
	print("总计: " + str(total_tests) + " 项")
	print("通过: " + str(total_passed) + " 项")
	print("失败: " + str(total_failed) + " 项")
	if total_tests > 0:
		print("覆盖率: " + str(snapped((float(total_passed) / float(total_tests) * 100), 0.1)) + "%")
	print("========================================")
