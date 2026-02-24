class_name EndlessTowerData extends Node

const MAX_FLOOR = 51  # 无尽塔上限

const TOWER_CONFIG = {
	"name": "无尽塔",
	"description": "挑战无尽层数，每5层获得奖励，测试你的实力极限",
	"templates": ["wolf", "snake", "boar"],  # 随机选择的模板
	"reward_floors": [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
	"rewards": {
		5: {"spirit_stone": 10, "health_pill": 1},
		10: {"spirit_stone": 15, "spell_basic_breathing": 1},
		15: {"spirit_stone": 20, "health_pill": 3},
		20: {"spirit_stone": 30, "foundation_pill": 1},
		25: {"spirit_stone": 40, "health_pill": 5},
		30: {"spirit_stone": 55, "spell_basic_steps": 1},
		35: {"spirit_stone": 75},
		40: {"spirit_stone": 100},
		45: {"spirit_stone": 130},
		50: {"spirit_stone": 170}
	}
}

const TOWER_AREA_ID = "endless_tower"

# 获取最大层数
func get_max_floor() -> int:
	return MAX_FLOOR

# 获取无尽塔名称
func get_tower_name() -> String:
	return TOWER_CONFIG.get("name", "无尽塔")

# 获取无尽塔描述
func get_tower_description() -> String:
	return TOWER_CONFIG.get("description", "")

# 获取所有奖励层数
func get_reward_floors() -> Array:
	return TOWER_CONFIG.get("reward_floors", [])

# 检查指定层是否是奖励层
func is_reward_floor(floor: int) -> bool:
	var reward_floors = get_reward_floors()
	return floor in reward_floors

# 获取指定层的奖励
func get_reward_for_floor(floor: int) -> Dictionary:
	var rewards = TOWER_CONFIG.get("rewards", {})
	# 如果超过50层，返回50层的奖励
	if floor > 50:
		return rewards.get(50, {})
	return rewards.get(floor, {})

# 获取指定层奖励的描述文本
func get_reward_description(floor: int) -> String:
	var reward = get_reward_for_floor(floor)
	if reward.is_empty():
		return ""
	
	var descriptions = []
	for item_id in reward.keys():
		var amount = reward[item_id]
		# 使用 ItemData 获取物品中文名称
		var item_name = _get_item_name(item_id)
		descriptions.append(str(amount) + item_name)
	
	return "、".join(descriptions)

# 获取物品中文名称
func _get_item_name(item_id: String) -> String:
	# 尝试通过 GameManager 获取 ItemData
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var item_data = game_manager.get_item_data()
		if item_data:
			var name = item_data.get_item_name(item_id)
			if name != item_id:  # 如果找到了有效名称
				return name
	
	# 未找到，返回未知物品
	return "未知物品"

# 获取下一奖励层
func get_next_reward_floor(current_floor: int) -> int:
	var reward_floors = get_reward_floors()
	for floor in reward_floors:
		if floor > current_floor:
			return floor
	return -1  # 没有更多奖励层（超过50层）

# 获取距离下一奖励层还有几层
func get_floors_to_next_reward(current_floor: int) -> int:
	var next_reward = get_next_reward_floor(current_floor)
	if next_reward == -1:
		return 0
	return next_reward - current_floor

# 随机获取一个敌人模板ID
func get_random_template() -> String:
	var templates = TOWER_CONFIG.get("templates", ["wolf"])
	return templates[randi() % templates.size()]

# 获取区域ID
func get_area_id() -> String:
	return TOWER_AREA_ID
