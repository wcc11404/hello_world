class_name TestBase extends Node

# 测试基类 - 所有测试用例继承此类

func get_test_name() -> String:
	return "BaseTest"

func run_tests() -> Dictionary:
	# 子类需要重写此方法
	return {
		"total": 0,
		"passed": 0,
		"failed": 0,
		"tests": []
	}

# 辅助方法：创建测试结果
func create_test_result(name: String, passed: bool, message: String = "") -> Dictionary:
	return {
		"name": name,
		"passed": passed,
		"message": message
	}
