class_name RealmSystem extends Node

signal breakthrough_success(new_realm: String, new_level: int)
signal breakthrough_failed(reason: String)

# 突破材料配置
# 支持两种配置方式：
# 1. 大境界突破: "炼气期": {"foundation_pill": 1} - 炼气期突破到筑基期需要1个筑基丹
# 2. 小境界突破: "筑基期": {"3": {"foundation_pill": 2}} - 筑基期3层突破到4层需要2个筑基丹
const BREAKTHROUGH_MATERIALS = {
	# 大境界突破配置
	"realm_breakthrough": {
		"炼气期": {"foundation_pill": 1},  # 炼气→筑基需要1个筑基丹
		"筑基期": {"golden_core_pill": 1},  # 筑基→金丹需要1个金丹
		"金丹期": {"nascent_soul_pill": 1},  # 金丹→元婴需要1个元婴丹
		"元婴期": {"spirit_separation_pill": 1}, # 元婴→化神需要1个化神丹
		"化神期": {"void_refining_pill": 1}, # 化神→炼虚需要1个炼虚丹
		"炼虚期": {"body_integration_pill": 1}, # 炼虚→合体需要1个合体丹
		"合体期": {"mahayana_pill": 1},# 合体→大乘需要1个大乘丹
		"大乘期": {"tribulation_pill": 1} # 大乘→渡劫需要1个渡劫丹
	},
	# 小境界突破配置（特定层数突破到下一层）
	"level_breakthrough": {
		"筑基期": {
			"3": {"foundation_pill": 1},  # 筑基期3层→4层需要1个筑基丹
			"6": {"foundation_pill": 1},  # 筑基期6层→7层需要1个筑基丹
			"9": {"foundation_pill": 2}  # 筑基期9层→10层需要2个筑基丹
		},
		"金丹期": {
			"3": {"golden_core_pill": 1},  # 金丹期3层→4层需要1个金丹
			"6": {"golden_core_pill": 1},  # 金丹期6层→7层需要1个金丹
			"9": {"golden_core_pill": 2}   # 金丹期9层→10层需要2个金丹
		},
		"元婴期": {
			"3": {"nascent_soul_pill": 1},  # 元婴期3层→4层需要1个元婴丹
			"6": {"nascent_soul_pill": 1},  # 元婴期6层→7层需要1个元婴丹
			"9": {"nascent_soul_pill": 2}   # 元婴期9层→10层需要2个元婴丹
		},
		"化神期": {
			"3": {"spirit_separation_pill": 1},  # 化神期3层→4层需要1个化神丹
			"6": {"spirit_separation_pill": 1},  # 化神期6层→7层需要1个化神丹
			"9": {"spirit_separation_pill": 2}   # 化神期9层→10层需要2个化神丹
		},
		"炼虚期": {
			"3": {"void_refining_pill": 1},  # 炼虚期3层→4层需要1个炼虚丹
			"6": {"void_refining_pill": 1},  # 炼虚期6层→7层需要1个炼虚丹
			"9": {"void_refining_pill": 2}   # 炼虚期9层→10层需要2个炼虚丹
		},
		"合体期": {
			"3": {"body_integration_pill": 1},  # 合体期3层→4层需要1个合体丹
			"6": {"body_integration_pill": 1},  # 合体期6层→7层需要1个合体丹
			"9": {"body_integration_pill": 2}   # 合体期9层→10层需要2个合体丹
		},
		"大乘期": {
			"3": {"mahayana_pill": 1},  # 大乘期3层→4层需要1个大乘丹
			"6": {"mahayana_pill": 1},  # 大乘期6层→7层需要1个大乘丹
			"9": {"mahayana_pill": 2}   # 大乘期9层→10层需要2个大乘丹
		},
		"渡劫期": {
			"3": {"tribulation_pill": 1},  # 渡劫期3层→4层需要1个渡劫丹
			"6": {"tribulation_pill": 1},  # 渡劫期6层→7层需要1个渡劫丹
			"9": {"tribulation_pill": 2}   # 渡劫期9层→10层需要2个渡劫丹
		}
	}
}

# 境界顺序（用于计算总境界等级）
const REALM_ORDER = [
	"炼气期",
	"筑基期",
	"金丹期",
	"元婴期",
	"化神期",
	"炼虚期",
	"合体期",
	"大乘期",
	"渡劫期"
]

const REALMS = {
	"炼气期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 50, "attack": 5, "defense": 2, "spirit_stone_cost": 4, "spirit_energy_cost": 5, "max_spirit_energy": 5},
			2: {"health": 55, "attack": 6, "defense": 2, "spirit_stone_cost": 6, "spirit_energy_cost": 10, "max_spirit_energy": 10},
			3: {"health": 60, "attack": 7, "defense": 3, "spirit_stone_cost": 8, "spirit_energy_cost": 12, "max_spirit_energy": 12},
			4: {"health": 68, "attack": 8, "defense": 3, "spirit_stone_cost": 10, "spirit_energy_cost": 13, "max_spirit_energy": 13},
			5: {"health": 76, "attack": 9, "defense": 4, "spirit_stone_cost": 12, "spirit_energy_cost": 20, "max_spirit_energy": 20},
			6: {"health": 86, "attack": 10, "defense": 5, "spirit_stone_cost": 15, "spirit_energy_cost": 28, "max_spirit_energy": 28},
			7: {"health": 96, "attack": 12, "defense": 5, "spirit_stone_cost": 17, "spirit_energy_cost": 38, "max_spirit_energy": 38},
			8: {"health": 110, "attack": 14, "defense": 6, "spirit_stone_cost": 19, "spirit_energy_cost": 50, "max_spirit_energy": 50},
			9: {"health": 130, "attack": 16, "defense": 7, "spirit_stone_cost": 21, "spirit_energy_cost": 64, "max_spirit_energy": 64},
			10: {"health": 150, "attack": 20, "defense": 9, "spirit_stone_cost": 24, "spirit_energy_cost": 80, "max_spirit_energy": 80}
		},
		"next_realm": "筑基期",
		"description": "引气入体，修炼入门",
		"spirit_gain_speed": 1,
		"speed": 5
	},
	"筑基期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 250, "attack": 30, "defense": 13, "spirit_stone_cost": 50, "spirit_energy_cost": 100, "max_spirit_energy": 100},
			2: {"health": 275, "attack": 33, "defense": 14, "spirit_stone_cost": 55, "spirit_energy_cost": 110, "max_spirit_energy": 110},
			3: {"health": 302, "attack": 36, "defense": 15, "spirit_stone_cost": 60, "spirit_energy_cost": 121, "max_spirit_energy": 121},
			4: {"health": 332, "attack": 39, "defense": 17, "spirit_stone_cost": 66, "spirit_energy_cost": 133, "max_spirit_energy": 133},
			5: {"health": 366, "attack": 43, "defense": 19, "spirit_stone_cost": 73, "spirit_energy_cost": 146, "max_spirit_energy": 146},
			6: {"health": 402, "attack": 48, "defense": 20, "spirit_stone_cost": 80, "spirit_energy_cost": 161, "max_spirit_energy": 161},
			7: {"health": 442, "attack": 53, "defense": 23, "spirit_stone_cost": 88, "spirit_energy_cost": 177, "max_spirit_energy": 177},
			8: {"health": 487, "attack": 58, "defense": 25, "spirit_stone_cost": 97, "spirit_energy_cost": 195, "max_spirit_energy": 195},
			9: {"health": 535, "attack": 64, "defense": 27, "spirit_stone_cost": 107, "spirit_energy_cost": 214, "max_spirit_energy": 214},
			10: {"health": 589, "attack": 70, "defense": 30, "spirit_stone_cost": 117, "spirit_energy_cost": 236, "max_spirit_energy": 236}
		},
		"next_realm": "金丹期",
		"description": "凝聚道基，初步成仙",
		"spirit_gain_speed": 1.2,
		"speed": 5
	},
	"金丹期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 1250, "attack": 105, "defense": 45, "spirit_stone_cost": 250, "spirit_energy_cost": 500, "max_spirit_energy": 500},
			2: {"health": 1375, "attack": 115, "defense": 49, "spirit_stone_cost": 275, "spirit_energy_cost": 550, "max_spirit_energy": 550},
			3: {"health": 1512, "attack": 127, "defense": 54, "spirit_stone_cost": 302, "spirit_energy_cost": 605, "max_spirit_energy": 605},
			4: {"health": 1663, "attack": 139, "defense": 59, "spirit_stone_cost": 332, "spirit_energy_cost": 665, "max_spirit_energy": 665},
			5: {"health": 1830, "attack": 153, "defense": 65, "spirit_stone_cost": 366, "spirit_energy_cost": 732, "max_spirit_energy": 732},
			6: {"health": 2013, "attack": 169, "defense": 72, "spirit_stone_cost": 402, "spirit_energy_cost": 805, "max_spirit_energy": 805},
			7: {"health": 2214, "attack": 186, "defense": 79, "spirit_stone_cost": 442, "spirit_energy_cost": 885, "max_spirit_energy": 885},
			8: {"health": 2435, "attack": 204, "defense": 87, "spirit_stone_cost": 487, "spirit_energy_cost": 974, "max_spirit_energy": 974},
			9: {"health": 2679, "attack": 225, "defense": 96, "spirit_stone_cost": 535, "spirit_energy_cost": 1071, "max_spirit_energy": 1071},
			10: {"health": 2947, "attack": 247, "defense": 106, "spirit_stone_cost": 589, "spirit_energy_cost": 1178, "max_spirit_energy": 1178}
		},
		"next_realm": "元婴期",
		"description": "凝结金丹，蜕凡成仙",
		"spirit_gain_speed": 1.5,
		"speed": 5
	},
	"元婴期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 6250, "attack": 370, "defense": 159, "spirit_stone_cost": 1250, "spirit_energy_cost": 2500, "max_spirit_energy": 2500},
			2: {"health": 6875, "attack": 407, "defense": 174, "spirit_stone_cost": 1375, "spirit_energy_cost": 2750, "max_spirit_energy": 2750},
			3: {"health": 7562, "attack": 447, "defense": 192, "spirit_stone_cost": 1512, "spirit_energy_cost": 3024, "max_spirit_energy": 3024},
			4: {"health": 8318, "attack": 492, "defense": 211, "spirit_stone_cost": 1663, "spirit_energy_cost": 3327, "max_spirit_energy": 3327},
			5: {"health": 9150, "attack": 541, "defense": 232, "spirit_stone_cost": 1830, "spirit_energy_cost": 3660, "max_spirit_energy": 3660},
			6: {"health": 10065, "attack": 595, "defense": 256, "spirit_stone_cost": 2013, "spirit_energy_cost": 4026, "max_spirit_energy": 4026},
			7: {"health": 11072, "attack": 655, "defense": 281, "spirit_stone_cost": 2214, "spirit_energy_cost": 4428, "max_spirit_energy": 4428},
			8: {"health": 12179, "attack": 721, "defense": 309, "spirit_stone_cost": 2435, "spirit_energy_cost": 4871, "max_spirit_energy": 4871},
			9: {"health": 13397, "attack": 793, "defense": 340, "spirit_stone_cost": 2679, "spirit_energy_cost": 5358, "max_spirit_energy": 5358},
			10: {"health": 14737, "attack": 872, "defense": 374, "spirit_stone_cost": 2947, "spirit_energy_cost": 5894, "max_spirit_energy": 5894}
		},
		"next_realm": "化神期",
		"description": "元婴出窍，神通广大",
		"spirit_gain_speed": 2,
		"speed": 5
	},
	"化神期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 31250, "attack": 1308, "defense": 561, "spirit_stone_cost": 6250, "spirit_energy_cost": 12500, "max_spirit_energy": 12500},
			2: {"health": 34375, "attack": 1438, "defense": 617, "spirit_stone_cost": 6875, "spirit_energy_cost": 13750, "max_spirit_energy": 13750},
			3: {"health": 37812, "attack": 1582, "defense": 678, "spirit_stone_cost": 7562, "spirit_energy_cost": 15124, "max_spirit_energy": 15124},
			4: {"health": 41593, "attack": 1740, "defense": 746, "spirit_stone_cost": 8318, "spirit_energy_cost": 16637, "max_spirit_energy": 16637},
			5: {"health": 45753, "attack": 1915, "defense": 821, "spirit_stone_cost": 9150, "spirit_energy_cost": 18301, "max_spirit_energy": 18301},
			6: {"health": 50328, "attack": 2106, "defense": 903, "spirit_stone_cost": 10065, "spirit_energy_cost": 20131, "max_spirit_energy": 20131},
			7: {"health": 55361, "attack": 2317, "defense": 993, "spirit_stone_cost": 11072, "spirit_energy_cost": 22144, "max_spirit_energy": 22144},
			8: {"health": 60897, "attack": 2548, "defense": 1093, "spirit_stone_cost": 12179, "spirit_energy_cost": 24358, "max_spirit_energy": 24358},
			9: {"health": 66987, "attack": 2803, "defense": 1202, "spirit_stone_cost": 13397, "spirit_energy_cost": 26794, "max_spirit_energy": 26794},
			10: {"health": 73685, "attack": 3084, "defense": 1322, "spirit_stone_cost": 14737, "spirit_energy_cost": 29474, "max_spirit_energy": 29474}
		},
		"next_realm": "炼虚期",
		"description": "返璞归真，化神为虚",
		"spirit_gain_speed": 3,
		"speed": 5
	},
	"炼虚期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 156250, "attack": 4626, "defense": 1983, "spirit_stone_cost": 31250, "spirit_energy_cost": 62500, "max_spirit_energy": 62500},
			2: {"health": 171875, "attack": 5088, "defense": 2181, "spirit_stone_cost": 34375, "spirit_energy_cost": 68750, "max_spirit_energy": 68750},
			3: {"health": 189062, "attack": 5597, "defense": 2399, "spirit_stone_cost": 37812, "spirit_energy_cost": 75624, "max_spirit_energy": 75624},
			4: {"health": 207968, "attack": 6157, "defense": 2639, "spirit_stone_cost": 41593, "spirit_energy_cost": 83187, "max_spirit_energy": 83187},
			5: {"health": 228765, "attack": 6772, "defense": 2903, "spirit_stone_cost": 45753, "spirit_energy_cost": 91506, "max_spirit_energy": 91506},
			6: {"health": 251642, "attack": 7450, "defense": 3193, "spirit_stone_cost": 50328, "spirit_energy_cost": 100656, "max_spirit_energy": 100656},
			7: {"health": 276806, "attack": 8195, "defense": 3513, "spirit_stone_cost": 55361, "spirit_energy_cost": 110722, "max_spirit_energy": 110722},
			8: {"health": 304487, "attack": 9014, "defense": 3864, "spirit_stone_cost": 60897, "spirit_energy_cost": 121794, "max_spirit_energy": 121794},
			9: {"health": 334935, "attack": 9916, "defense": 4250, "spirit_stone_cost": 66987, "spirit_energy_cost": 133974, "max_spirit_energy": 133974},
			10: {"health": 368429, "attack": 10907, "defense": 4675, "spirit_stone_cost": 73685, "spirit_energy_cost": 147371, "max_spirit_energy": 147371}
		},
		"next_realm": "合体期",
		"description": "虚实合一，神通无量",
		"spirit_gain_speed": 5,
		"speed": 5
	},
	"合体期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 781250, "attack": 16360, "defense": 7012, "spirit_stone_cost": 156250, "spirit_energy_cost": 312500, "max_spirit_energy": 312500},
			2: {"health": 859375, "attack": 17996, "defense": 7713, "spirit_stone_cost": 171875, "spirit_energy_cost": 343750, "max_spirit_energy": 343750},
			3: {"health": 945312, "attack": 19795, "defense": 8484, "spirit_stone_cost": 189062, "spirit_energy_cost": 378124, "max_spirit_energy": 378124},
			4: {"health": 1039843, "attack": 21775, "defense": 9332, "spirit_stone_cost": 207968, "spirit_energy_cost": 415937, "max_spirit_energy": 415937},
			5: {"health": 1143828, "attack": 23952, "defense": 10266, "spirit_stone_cost": 228765, "spirit_energy_cost": 457531, "max_spirit_energy": 457531},
			6: {"health": 1258210, "attack": 26347, "defense": 11292, "spirit_stone_cost": 251642, "spirit_energy_cost": 503284, "max_spirit_energy": 503284},
			7: {"health": 1384032, "attack": 28982, "defense": 12422, "spirit_stone_cost": 276806, "spirit_energy_cost": 553612, "max_spirit_energy": 553612},
			8: {"health": 1522435, "attack": 31881, "defense": 13664, "spirit_stone_cost": 304487, "spirit_energy_cost": 608974, "max_spirit_energy": 608974},
			9: {"health": 1674678, "attack": 35069, "defense": 15030, "spirit_stone_cost": 334935, "spirit_energy_cost": 669871, "max_spirit_energy": 669871},
			10: {"health": 1842146, "attack": 38576, "defense": 16533, "spirit_stone_cost": 368429, "spirit_energy_cost": 736858, "max_spirit_energy": 736858}
		},
		"next_realm": "大乘期",
		"description": "天地合一，接近仙人",
		"spirit_gain_speed": 9,
		"speed": 5
	},
	"大乘期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 3906250, "attack": 57864, "defense": 24799, "spirit_stone_cost": 781250, "spirit_energy_cost": 1562500, "max_spirit_energy": 1562500},
			2: {"health": 4296875, "attack": 63650, "defense": 27278, "spirit_stone_cost": 859375, "spirit_energy_cost": 1718750, "max_spirit_energy": 1718750},
			3: {"health": 4726562, "attack": 70015, "defense": 30006, "spirit_stone_cost": 945312, "spirit_energy_cost": 1890624, "max_spirit_energy": 1890624},
			4: {"health": 5199218, "attack": 77016, "defense": 33007, "spirit_stone_cost": 1039843, "spirit_energy_cost": 2079687, "max_spirit_energy": 2079687},
			5: {"health": 5719140, "attack": 84718, "defense": 36308, "spirit_stone_cost": 1143828, "spirit_energy_cost": 2287656, "max_spirit_energy": 2287656},
			6: {"health": 6291054, "attack": 93190, "defense": 39939, "spirit_stone_cost": 1258210, "spirit_energy_cost": 2516421, "max_spirit_energy": 2516421},
			7: {"health": 6920160, "attack": 102509, "defense": 43932, "spirit_stone_cost": 1384032, "spirit_energy_cost": 2768064, "max_spirit_energy": 2768064},
			8: {"health": 7612176, "attack": 112760, "defense": 48326, "spirit_stone_cost": 1522435, "spirit_energy_cost": 3044870, "max_spirit_energy": 3044870},
			9: {"health": 8373393, "attack": 124036, "defense": 53158, "spirit_stone_cost": 1674678, "spirit_energy_cost": 3349357, "max_spirit_energy": 3349357},
			10: {"health": 9210733, "attack": 136440, "defense": 58474, "spirit_stone_cost": 1842146, "spirit_energy_cost": 3684293, "max_spirit_energy": 3684293}
		},
		"next_realm": "渡劫期",
		"description": "功德圆满，渡劫飞升",
		"spirit_gain_speed": 18,
		"speed": 5
	},
	"渡劫期": {
		"max_level": 10,
		"level_names": {1: "一层", 2: "二层", 3: "三层", 4: "四层", 5: "五层", 6: "六层", 7: "七层", 8: "八层", 9: "九层", 10: "大圆满"},
		"levels": {
			1: {"health": 19531250, "attack": 204660, "defense": 87711, "spirit_stone_cost": 3906250, "spirit_energy_cost": 7812500, "max_spirit_energy": 7812500},
			2: {"health": 21484375, "attack": 225126, "defense": 96482, "spirit_stone_cost": 4296875, "spirit_energy_cost": 8593750, "max_spirit_energy": 8593750},
			3: {"health": 23632812, "attack": 247638, "defense": 106130, "spirit_stone_cost": 4726562, "spirit_energy_cost": 9453124, "max_spirit_energy": 9453124},
			4: {"health": 25996093, "attack": 272402, "defense": 116743, "spirit_stone_cost": 5199218, "spirit_energy_cost": 10398437, "max_spirit_energy": 10398437},
			5: {"health": 28595703, "attack": 299642, "defense": 128417, "spirit_stone_cost": 5719140, "spirit_energy_cost": 11438281, "max_spirit_energy": 11438281},
			6: {"health": 31455273, "attack": 329606, "defense": 141259, "spirit_stone_cost": 6291054, "spirit_energy_cost": 12582109, "max_spirit_energy": 12582109},
			7: {"health": 34600800, "attack": 362567, "defense": 155385, "spirit_stone_cost": 6920160, "spirit_energy_cost": 13840320, "max_spirit_energy": 13840320},
			8: {"health": 38060880, "attack": 398824, "defense": 170923, "spirit_stone_cost": 7612176, "spirit_energy_cost": 15224352, "max_spirit_energy": 15224352},
			9: {"health": 41866968, "attack": 438706, "defense": 188016, "spirit_stone_cost": 8373393, "spirit_energy_cost": 16746787, "max_spirit_energy": 16746787},
			10: {"health": 46053665, "attack": 482577, "defense": 206817, "spirit_stone_cost": 9210733, "spirit_energy_cost": 18421466, "max_spirit_energy": 18421466}
		},
		"next_realm": "",
		"description": "历尽天劫，羽化登仙",
		"spirit_gain_speed": 40,
		"speed": 5
	}
}

func get_realm_info(realm_name: String) -> Dictionary:
	return REALMS.get(realm_name, {})

# 获取总境界等级（用于境界限制判断）
# 返回值：炼气1层=1，炼气10层=10，筑基1层=11，筑基5层=15，以此类推
func get_total_realm_level(realm_name: String, level: int) -> int:
	var realm_index = REALM_ORDER.find(realm_name)
	if realm_index < 0:
		return 0
	return realm_index * 10 + level

# 检查是否满足境界要求
# requirement 格式：{"realm_min": 15} 表示需要筑基5层
func check_realm_requirement(realm_name: String, level: int, requirement: Dictionary) -> bool:
	if requirement.is_empty():
		return true
	var realm_min = requirement.get("realm_min", 0)
	var total_level = get_total_realm_level(realm_name, level)
	return total_level >= realm_min

func get_level_info(realm_name: String, level: int) -> Dictionary:
	var realm_info = get_realm_info(realm_name)
	var levels = realm_info.get("levels", {})
	return levels.get(level, {})

func get_level_name(realm_name: String, level: int) -> String:
	var realm_info = get_realm_info(realm_name)
	var names = realm_info.get("level_names", {})
	return names.get(level, str(level) + "段")

# 获取最大灵气量
func get_max_spirit_energy(realm_name: String, level: int) -> int:
	var level_info = get_level_info(realm_name, level)
	return level_info.get("max_spirit_energy", 10)

# 获取突破所需的灵石消耗（使用当前等级配置）
func get_spirit_stone_cost(realm_name: String, current_level: int) -> int:
	var level_info = get_level_info(realm_name, current_level)
	return level_info.get("spirit_stone_cost", 0)

# 获取突破所需的灵气消耗（使用当前等级配置）
func get_spirit_energy_cost(realm_name: String, current_level: int) -> int:
	var level_info = get_level_info(realm_name, current_level)
	return level_info.get("spirit_energy_cost", 0)

# 获取灵气获取速度
func get_spirit_gain_speed(realm_name: String) -> float:
	var realm_info = get_realm_info(realm_name)
	return realm_info.get("spirit_gain_speed", 1.0)

# 获取突破所需材料
# is_realm_breakthrough: 是否是大境界突破
func get_breakthrough_materials(realm_name: String, current_level: int, is_realm_breakthrough: bool = false) -> Dictionary:
	if is_realm_breakthrough:
		# 大境界突破
		var realm_materials = BREAKTHROUGH_MATERIALS["realm_breakthrough"].get(realm_name, {})
		return realm_materials
	else:
		# 小境界突破
		var level_materials = BREAKTHROUGH_MATERIALS["level_breakthrough"].get(realm_name, {})
		var level_key = str(current_level)
		return level_materials.get(level_key, {})

# 检查是否可以突破（同时检查灵石、灵气和材料）
func can_breakthrough(realm_name: String, current_level: int, spirit_stone: int, spirit_energy: int, inventory_items: Dictionary = {}) -> Dictionary:
	var realm_info = get_realm_info(realm_name)
	if realm_info.is_empty():
		return {"can": false, "reason": "未知境界"}
	
	var max_level = realm_info.get("max_level", 0)
	
	# 获取消耗（层数突破或境界晋升都需要消耗）
	var stone_cost = get_spirit_stone_cost(realm_name, current_level)
	var energy_cost = get_spirit_energy_cost(realm_name, current_level)
	
	# 判断是大境界突破还是小境界突破
	var is_realm_breakthrough = (current_level >= max_level)
	
	# 获取所需材料
	var required_materials = get_breakthrough_materials(realm_name, current_level, is_realm_breakthrough)
	
	# 检查材料是否足够
	var material_check = {}
	for material_id in required_materials.keys():
		var required_count = required_materials[material_id]
		var current_count = inventory_items.get(material_id, 0)
		material_check[material_id] = {
			"required": required_count,
			"current": current_count,
			"enough": current_count >= required_count
		}
		if current_count < required_count:
			var material_name = get_material_name(material_id)
			return {
				"can": false, 
				"reason": material_name + "不足", 
				"stone_cost": stone_cost, 
				"energy_cost": energy_cost, 
				"materials": material_check
			}
	
	if current_level >= max_level:
		var next_realm = realm_info.get("next_realm", "")
		if next_realm.is_empty():
			return {"can": false, "reason": "已达到最高境界"}
		else:
			# 晋升大境界也需要检查资源
			# 优先检查灵气
			if spirit_energy < energy_cost:
				return {"can": false, "reason": "灵气不足", "stone_cost": stone_cost, "energy_cost": energy_cost, "energy_current": spirit_energy, "materials": material_check}
			
			if spirit_stone < stone_cost:
				return {"can": false, "reason": "灵石不足", "stone_cost": stone_cost, "stone_current": spirit_stone, "energy_cost": energy_cost, "materials": material_check}
			
			return {"can": true, "type": "realm", "next_realm": next_realm, "stone_cost": stone_cost, "energy_cost": energy_cost, "materials": material_check}
	
	# 优先检查灵气
	if spirit_energy < energy_cost:
		return {"can": false, "reason": "灵气不足", "stone_cost": stone_cost, "energy_cost": energy_cost, "energy_current": spirit_energy, "materials": material_check}
	
	if spirit_stone < stone_cost:
		return {"can": false, "reason": "灵石不足", "stone_cost": stone_cost, "stone_current": spirit_stone, "energy_cost": energy_cost, "materials": material_check}
	
	return {"can": true, "type": "level", "stone_cost": stone_cost, "energy_cost": energy_cost, "materials": material_check}

# 获取材料显示名称（通过ItemData获取中文名称）
func get_material_name(material_id: String) -> String:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var item_data = game_manager.get_item_data()
		if item_data:
			var name = item_data.get_item_name(material_id)
			if name != "未知物品":
				return name
	return material_id

func get_initial_stats() -> Dictionary:
	return get_level_info("炼气期", 1)

func get_realm_display_name(realm_name: String, level: int) -> String:
	var level_name = get_level_name(realm_name, level)
	return realm_name + " " + level_name

func get_all_realms() -> Array:
	return REALMS.keys()
