extends Node

var item_data: Dictionary = {
	"spirit_stone": {
		"id": "spirit_stone",
		"name": "灵石",
		"type": 0,
		"quality": 0,
		"max_stack": 9999999,
		"description": "修仙界的通用货币",
		"icon": "res://assets/items/spirit_stone.png"
	},
	"mat_iron": {
		"id": "mat_iron",
		"name": "玄铁",
		"type": 1,
		"quality": 0,
		"max_stack": 99,
		"description": "用于装备强化的基础材料",
		"icon": "res://assets/items/mat_iron.png"
	},
	"mat_herb": {
		"id": "mat_herb",
		"name": "灵草",
		"type": 1,
		"quality": 1,
		"max_stack": 99,
		"description": "用于装备强化的珍稀草药",
		"icon": "res://assets/items/mat_herb.png"
	},
	"mat_crystal": {
		"id": "mat_crystal",
		"name": "灵石髓",
		"type": 1,
		"quality": 2,
		"max_stack": 99,
		"description": "用于装备精炼的稀有矿物",
		"icon": "res://assets/items/mat_crystal.png"
	},
	"mat_jade": {
		"id": "mat_jade",
		"name": "翡翠",
		"type": 1,
		"quality": 3,
		"max_stack": 99,
		"description": "用于装备进阶的珍稀玉石",
		"icon": "res://assets/items/mat_jade.png"
	},
	"mat_dragon": {
		"id": "mat_dragon",
		"name": "龙晶",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于装备觉醒的神级材料",
		"icon": "res://assets/items/mat_dragon.png"
	},
	"bug_pill": {
		"id": "bug_pill",
		"name": "bug丹",
		"type": 3,
		"quality": 4,
		"max_stack": 99,
		"description": "神奇的丹药，可补充1亿点灵气和10000点气血值",
		"icon": "res://assets/items/bug_pill.png",
		"effect": {
			"type": "add_spirit_and_health",
			"spirit_amount": 100000000,
			"health_amount": 10000
		}
	},
	"health_pill": {
		"id": "health_pill",
		"name": "补血丹",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "普通丹药，可回复100点气血值",
		"icon": "res://assets/items/health_pill.png",
		"effect": {
			"type": "add_health",
			"amount": 100
		}
	},
	"spirit_pill": {
		"id": "spirit_pill",
		"name": "补气丹",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "普通丹药，可补充50点灵气",
		"icon": "res://assets/items/spirit_pill.png",
		"effect": {
			"type": "add_spirit_energy",
			"amount": 50
		}
	},
	"spell_basic_breathing": {
		"id": "spell_basic_breathing",
		"name": "基础吐纳",
		"type": 3,
		"quality": 0,
		"max_stack": 99,
		"description": "使用后可解锁基础吐纳术法",
		"icon": "res://assets/items/spell_basic_breathing.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "basic_breathing"
		}
	},
	"spell_basic_boxing_techniques": {
		"id": "spell_basic_boxing_techniques",
		"name": "基础拳法",
		"type": 3,
		"quality": 0,
		"max_stack": 99,
		"description": "使用后可解锁基础拳法术法",
		"icon": "res://assets/items/spell_fire_ball.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "basic_boxing_techniques"
		}
	},
	"spell_thunder_strike": {
		"id": "spell_thunder_strike",
		"name": "雷击术",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "使用后可解锁雷击术",
		"icon": "res://assets/items/spell_thunder_strike.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "thunder_strike"
		}
	},
	"spell_basic_defense": {
		"id": "spell_basic_defense",
		"name": "基础防御",
		"type": 3,
		"quality": 0,
		"max_stack": 99,
		"description": "使用后可解锁基础防御术法",
		"icon": "res://assets/items/spell_iron_body.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "basic_defense"
		}
	},
	"spell_basic_steps": {
		"id": "spell_basic_steps",
		"name": "基础步法",
		"type": 3,
		"quality": 0,
		"max_stack": 99,
		"description": "使用后可解锁基础步法术法",
		"icon": "res://assets/items/spell_swift_step.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "basic_steps"
		}
	},
	"spell_basic_health": {
		"id": "spell_basic_health",
		"name": "基础气血",
		"type": 3,
		"quality": 0,
		"max_stack": 99,
		"description": "使用后可解锁基础气血术法",
		"icon": "res://assets/items/spell_shield_spell.png",
		"effect": {
			"type": "unlock_spell",
			"spell_id": "basic_health"
		}
	},
	"foundation_pill": {
		"id": "foundation_pill",
		"name": "筑基丹",
		"type": 1,
		"quality": 2,
		"max_stack": 99,
		"description": "用于炼气期突破到筑基期的珍贵丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"golden_core_pill": {
		"id": "golden_core_pill",
		"name": "金丹丹",
		"type": 1,
		"quality": 3,
		"max_stack": 99,
		"description": "用于筑基期突破到金丹期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"nascent_soul_pill": {
		"id": "nascent_soul_pill",
		"name": "元婴丹",
		"type": 1,
		"quality": 3,
		"max_stack": 99,
		"description": "用于金丹期突破到元婴期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"spirit_separation_pill": {
		"id": "spirit_separation_pill",
		"name": "化神丹",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于元婴期突破到化神期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"void_refining_pill": {
		"id": "void_refining_pill",
		"name": "炼虚丹",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于化神期突破到炼虚期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"body_integration_pill": {
		"id": "body_integration_pill",
		"name": "合体丹",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于炼虚期突破到合体期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"mahayana_pill": {
		"id": "mahayana_pill",
		"name": "大乘丹",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于合体期突破到大乘期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"tribulation_pill": {
		"id": "tribulation_pill",
		"name": "渡劫丹",
		"type": 1,
		"quality": 4,
		"max_stack": 99,
		"description": "用于大乘期突破到渡劫期的必备丹药",
		"icon": "res://assets/items/foundation_pill.png"
	},
	"recipe_health_pill": {
		"id": "recipe_health_pill",
		"name": "补血丹丹方",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "记载补血丹炼制方法的丹方，使用后学会炼制补血丹",
		"icon": "res://assets/items/health_pill.png",
		"effect": {
			"type": "learn_recipe",
			"recipe_id": "health_pill"
		}
	},
	"recipe_spirit_pill": {
		"id": "recipe_spirit_pill",
		"name": "补气丹丹方",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "记载补气丹炼制方法的丹方，使用后学会炼制补气丹",
		"icon": "res://assets/items/spirit_pill.png",
		"effect": {
			"type": "learn_recipe",
			"recipe_id": "spirit_pill"
		}
	},
	"recipe_foundation_pill": {
		"id": "recipe_foundation_pill",
		"name": "筑基丹丹方",
		"type": 3,
		"quality": 2,
		"max_stack": 99,
		"description": "记载筑基丹炼制方法的珍贵丹方，使用后学会炼制筑基丹",
		"icon": "res://assets/items/foundation_pill.png",
		"effect": {
			"type": "learn_recipe",
			"recipe_id": "foundation_pill"
		}
	},
	"recipe_golden_core_pill": {
		"id": "recipe_golden_core_pill",
		"name": "金丹丹丹方",
		"type": 3,
		"quality": 3,
		"max_stack": 99,
		"description": "记载金丹丹炼制方法的稀有丹方，使用后学会炼制金丹丹",
		"icon": "res://assets/items/foundation_pill.png",
		"effect": {
			"type": "learn_recipe",
			"recipe_id": "golden_core_pill"
		}
	},
	"alchemy_furnace": {
		"id": "alchemy_furnace",
		"name": "初级丹炉",
		"type": 1,
		"quality": 2,
		"max_stack": 1,
		"description": "炼丹的基础工具，可提升炼丹成功率和速度",
		"icon": "res://assets/items/mat_crystal.png"
	},
	"starter_pack": {
		"id": "starter_pack",
		"name": "新手礼包",
		"type": 3,
		"quality": 1,
		"max_stack": 99,
		"description": "打开后可获得25灵石、5个补血丹、基础拳法",
		"icon": "res://assets/items/starter_pack.png",
		"content": {
			"spirit_stone": 25,
			"health_pill": 5,
			"spell_basic_boxing_techniques": 1
		}
	},
	"test_pack": {
		"id": "test_pack",
		"name": "测试礼包",
		"type": 3,
		"quality": 4,
		"max_stack": 99,
		"description": "打开后可获得1亿灵石、bug丹、补血丹、补气丹、所有术法解锁道具、所有突破丹药各10个",
		"icon": "res://assets/items/starter_pack.png",
		"content": {
			"spirit_stone": 100000000,
			"bug_pill": 5,
			"health_pill": 5,
			"spirit_pill": 5,
			"foundation_pill": 10,
			"golden_core_pill": 10,
			"nascent_soul_pill": 10,
			"spirit_separation_pill": 10,
			"void_refining_pill": 10,
			"body_integration_pill": 10,
			"mahayana_pill": 10,
			"tribulation_pill": 10,
			"spell_basic_breathing": 1,
			"spell_basic_boxing_techniques": 1,
			"spell_thunder_strike": 1,
			"spell_basic_defense": 1,
			"spell_basic_steps": 1,
			"spell_basic_health": 1
		}
	}
}

const QUALITY_COLORS: Array = [
	Color.GRAY,
	Color.GREEN,
	Color.DODGER_BLUE,
	Color.MAGENTA,
	Color.ORANGE
]

func _ready():
	pass

func get_item_data(item_id: String) -> Dictionary:
	return item_data.get(item_id, {})

func get_item_name(item_id: String) -> String:
	var data = get_item_data(item_id)
	return data.get("name", "未知物品")

func get_item_quality_color(quality: int) -> Color:
	if quality >= 0 and quality < QUALITY_COLORS.size():
		return QUALITY_COLORS[quality]
	return Color.WHITE

func can_stack(item_id: String) -> bool:
	var data = get_item_data(item_id)
	return data.get("max_stack", 1) > 1

func get_max_stack(item_id: String) -> int:
	var data = get_item_data(item_id)
	return data.get("max_stack", 1)
