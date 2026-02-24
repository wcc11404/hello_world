extends Node

var test_results: Array = []
var passed_count: int = 0
var failed_count: int = 0
var test_count: int = 0

func record_test(module: String, test_name: String, passed: bool, detail: String):
	var result = {
		"module": module,
		"test_name": test_name,
		"passed": passed,
		"detail": detail
	}
	test_results.append(result)
	test_count += 1
	
	if passed:
		passed_count += 1
		print("✓ " + module + " - " + test_name)
	else:
		failed_count += 1
		print("✗ " + module + " - " + test_name + " | " + detail)

func assert_true(condition: bool, module: String, test_name: String, detail: String = ""):
	test_count += 1
	if condition:
		passed_count += 1
		print("✓ " + module + " - " + test_name)
	else:
		failed_count += 1
		print("✗ " + module + " - " + test_name + " | " + detail)

func assert_eq(actual, expected, module: String, test_name: String):
	test_count += 1
	if actual == expected:
		passed_count += 1
		print("✓ " + module + " - " + test_name)
	else:
		failed_count += 1
		print("✗ " + module + " - " + test_name + " (实际: " + str(actual) + ", 期望: " + str(expected) + ")")

func print_test_summary():
	print("\n========================================")
	print("测试总结")
	print("========================================")
	print("总计: " + str(test_count) + " 项")
	print("通过: " + str(passed_count) + " 项")
	print("失败: " + str(failed_count) + " 项")
	if test_count > 0:
		print("覆盖率: " + str(snapped((float(passed_count) / float(test_count) * 100), 0.1)) + "%")
	
	if failed_count > 0:
		print("\n失败测试详情:")
		for result in test_results:
			if not result.passed:
				print("  - " + result.module + ": " + result.test_name)
				if result.detail:
					print("    " + result.detail)
	
	print("========================================")

func reset_stats():
	test_results = []
	passed_count = 0
	failed_count = 0
	test_count = 0
