class_name EnemyData extends Node

# 敌人模板配置
const ENEMY_TEMPLATES = {
	# 普通模板
	"wolf": {
		"name": "野狼",
		"name_variants": ["野狼", "森林狼"],
		"growth": {
			"health_base": 25,
			"health_growth": 1.1,
			"attack_base": 5,
			"attack_growth": 1.1,
			"defense_base": 2,
			"defense_growth": 1.1,
			"speed_base": 4.5,
			"speed_growth": 0.0001
		}
	},
	"snake": {
		"name": "毒蛇",
		"name_variants": ["五步蛇", "竹叶青"],
		"growth": {
			"health_base": 20,
			"health_growth": 1.1,
			"attack_base": 6,
			"attack_growth": 1.11,
			"defense_base": 1,
			"defense_growth": 1.1,
			"speed_base": 4.9,
			"speed_growth": 0.0002
		}
	},
	"boar": {
		"name": "野猪",
		"name_variants": ["野猪", "獠牙猪"],
		"growth": {
			"health_base": 30,
			"health_growth": 1.11,
			"attack_base": 4,
			"attack_growth": 1.1,
			"defense_base": 3,
			"defense_growth": 1.1,
			"speed_base": 4.5,
			"speed_growth": 0.0001
		}
	},
	
	# 精英模板
	"iron_back_wolf": {
		"name": "铁背狼王",
		"is_elite": true,
		"growth": {
			"health_base": 50,
			"health_growth": 1.11,
			"attack_base": 7,
			"attack_growth": 1.1,
			"defense_base": 4,
			"defense_growth": 1.1,
			"speed_base": 5.5,
			"speed_growth": 0.0002
		}
	},
	"herb_guardian": {
		"name": "破境草看守者",
		"is_elite": true,
		"growth": {
			"health_base": 50,
			"health_growth": 1.11,
			"attack_base": 8,
			"attack_growth": 1.1,
			"defense_base": 5,
			"defense_growth": 1.1,
			"speed_base": 4.5,
			"speed_growth": 0.0
		}
	}
}

# 根据模板和等级生成敌人数据
func generate_enemy(template_id: String, level: int) -> Dictionary:
	var template = ENEMY_TEMPLATES.get(template_id, {})
	if template.is_empty():
		return {}
	
	var growth = template.get("growth", {})
	
	# 计算属性
	var health = int(growth.get("health_base", 20) * pow(growth.get("health_growth", 1.08), level - 1))
	var attack = int(growth.get("attack_base", 4) * pow(growth.get("attack_growth", 1.06), level - 1))
	var defense = int(growth.get("defense_base", 2) * pow(growth.get("defense_growth", 1.04), level - 1))
	var speed = growth.get("speed_base", 5) * (1 + growth.get("speed_growth", 0.01) * (level - 1))
	
	# 选择名称
	var name_variants = template.get("name_variants", [template.get("name", "敌人")])
	var enemy_name = template.get("name", "敌人")
	if name_variants.size() > 0:
		enemy_name = name_variants[randi() % name_variants.size()]
	
	return {
		"template_id": template_id,
		"name": enemy_name,
		"level": level,
		"is_elite": template.get("is_elite", false),
		"stats": {
			"health": health,
			"attack": attack,
			"defense": defense,
			"speed": speed
		}
	}

# 获取模板名称
func get_template_name(template_id: String) -> String:
	var template = ENEMY_TEMPLATES.get(template_id, {})
	return template.get("name", "未知敌人")

# 检查是否是精英模板
func is_elite_template(template_id: String) -> bool:
	var template = ENEMY_TEMPLATES.get(template_id, {})
	return template.get("is_elite", false)

# 获取所有模板ID
func get_all_template_ids() -> Array:
	return ENEMY_TEMPLATES.keys()
