class_name AttributeCalculator

# 属性计算器 - 统一管理所有能力值的计算
# 提供静态最终能力值和战斗最终能力值的计算

# ==================== 数值格式化工具函数 ====================

## 格式化速度显示（保留两位小数，去除尾0）
static func format_speed(value: float) -> String:
	var result = "%.2f" % value
	# 去除末尾的0
	while result.ends_with("0") and result.find(".") != -1:
		result = result.substr(0, result.length() - 1)
	# 如果以小数点结尾，也去掉
	if result.ends_with("."):
		result = result.substr(0, result.length() - 1)
	return result

## 格式化灵气获取速度显示（保留两位小数，去除尾0）
static func format_spirit_gain_speed(value: float) -> String:
	return format_speed(value)

## 格式化攻击/防御显示（大于1000保留整数，否则保留一位小数，去除尾0）
static func format_attack_defense(value: float) -> String:
	# 大于1000时显示整数
	if value > 1000.0:
		return str(int(round(value)))
	
	# 否则保留一位小数
	var result = "%.1f" % value
	# 去除末尾的0
	if result.ends_with(".0"):
		result = result.substr(0, result.length() - 2)
	return result

## 格式化生命/灵气显示（保留整数）
static func format_health_spirit(value: float) -> String:
	return str(int(round(value)))

# ==================== 静态最终能力值计算（返回float） ====================
# 静态最终能力值 = 基础值 + 境界加成 + 术法加成 + 装备加成 + 功法加成 + 丹药加成

## 计算最终攻击力（静态，返回float）
static func calculate_final_attack(player: Node) -> float:
	if not player:
		return 0.0
	
	var base_attack = float(player.attack)
	
	# 术法加成（乘法）
	var spell_bonuses = _get_spell_bonuses(player)
	base_attack *= spell_bonuses.get("attack", 1.0)
	
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_attack

## 计算最终防御力（静态，返回float）
static func calculate_final_defense(player: Node) -> float:
	if not player:
		return 0.0
	
	var base_defense = float(player.defense)
	
	# 术法加成（乘法）
	var spell_bonuses = _get_spell_bonuses(player)
	base_defense *= spell_bonuses.get("defense", 1.0)
	
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_defense

## 计算最终速度（静态，返回float）
static func calculate_final_speed(player: Node) -> float:
	if not player:
		return 0.0
	
	var base_speed = float(player.speed)
	
	# 术法加成（加法）
	var spell_bonuses = _get_spell_bonuses(player)
	base_speed += spell_bonuses.get("speed", 0.0)
	
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_speed

## 计算最终最大气血（静态，返回float）
static func calculate_final_max_health(player: Node) -> float:
	if not player:
		return 0.0
	
	var base_max_health = float(player.max_health)
	
	# 术法加成（乘法）
	var spell_bonuses = _get_spell_bonuses(player)
	base_max_health *= spell_bonuses.get("health", 1.0)
	
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_max_health

## 计算最终最大灵气（静态，返回float）
static func calculate_final_max_spirit_energy(player: Node) -> float:
	if not player:
		return 0.0
	
	var base_max_spirit = float(player.max_spirit_energy)
	
	# TODO: 术法加成
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_max_spirit

## 计算最终灵气获取速度（静态，返回float）
static func calculate_final_spirit_gain_speed(player: Node) -> float:
	if not player:
		return 1.0
	
	var base_speed = _get_base_spirit_gain_speed(player)
	
	# 术法加成（乘法）
	var spell_bonuses = _get_spell_bonuses(player)
	base_speed *= spell_bonuses.get("spirit_gain", 1.0)
	
	# TODO: 装备加成
	# TODO: 功法加成
	# TODO: 丹药加成
	
	return base_speed

# ==================== 战斗最终能力值计算 ====================
# 战斗最终能力值 = 静态最终能力值 + 战斗临时Buff
# 除了speed用float，其他都用int(round())

## 计算战斗中的攻击力（返回int）
static func calculate_combat_attack(player: Node, combat_buffs: Dictionary) -> int:
	var final_attack = calculate_final_attack(player)
	
	if combat_buffs.is_empty():
		return int(round(final_attack))
	
	# 应用战斗Buff（百分比加成）
	var attack_percent = combat_buffs.get("attack_percent", 0.0)
	return int(round(final_attack * (1.0 + attack_percent)))

## 计算战斗中的防御力（返回int）
static func calculate_combat_defense(player: Node, combat_buffs: Dictionary) -> int:
	var final_defense = calculate_final_defense(player)
	
	if combat_buffs.is_empty():
		return int(round(final_defense))
	
	# 应用战斗Buff（百分比加成）
	var defense_percent = combat_buffs.get("defense_percent", 0.0)
	return int(round(final_defense * (1.0 + defense_percent)))

## 计算战斗中的速度（返回float）
static func calculate_combat_speed(player: Node, combat_buffs: Dictionary) -> float:
	var final_speed = calculate_final_speed(player)
	
	if combat_buffs.is_empty():
		return final_speed
	
	# 应用战斗Buff（固定值加成）
	var speed_bonus = combat_buffs.get("speed_bonus", 0.0)
	return final_speed + speed_bonus

## 计算战斗中的最大气血（返回int）
static func calculate_combat_max_health(player: Node, combat_buffs: Dictionary) -> int:
	var final_max_health = calculate_final_max_health(player)
	
	if combat_buffs.is_empty():
		return int(round(final_max_health))
	
	# 应用战斗Buff（固定值加成）
	var health_bonus = combat_buffs.get("health_bonus", 0.0)
	return int(round(final_max_health + health_bonus))

# ==================== 伤害计算 ====================

## 计算最终伤害
# attacker_attack: 攻击方的战斗攻击力（int）
# defender_defense: 防御方的战斗防御力（int）
# damage_percent: 伤害百分比（默认100%，即1.0）
static func calculate_damage(attacker_attack: int, defender_defense: int, damage_percent: float = 1.0) -> int:
	var base_damage = float(attacker_attack) - float(defender_defense)
	var final_damage = int(round(base_damage * damage_percent))
	return max(1, final_damage)  # 最小伤害为1

## 计算玩家对敌人的伤害
static func calculate_player_damage(player: Node, enemy: Dictionary, combat_buffs: Dictionary = {}, damage_percent: float = 1.0) -> int:
	var player_attack = calculate_combat_attack(player, combat_buffs)
	var enemy_defense = enemy.get("defense", 0)
	return calculate_damage(player_attack, enemy_defense, damage_percent)

## 计算敌人对玩家的伤害
static func calculate_enemy_damage(enemy: Dictionary, player: Node, combat_buffs: Dictionary = {}) -> int:
	var enemy_attack = enemy.get("attack", 0)
	var player_defense = calculate_combat_defense(player, combat_buffs)
	return calculate_damage(enemy_attack, player_defense)

# ==================== 辅助函数 ====================

## 获取术法属性加成
static func _get_spell_bonuses(player: Node) -> Dictionary:
	var default_bonuses = {
		"attack": 1.0,
		"defense": 1.0,
		"health": 1.0,
		"spirit_gain": 1.0,
		"speed": 0.0
	}
	
	if not player:
		return default_bonuses
	
	# 通过玩家的术法系统获取加成
	var spell_system = _get_spell_system(player)
	if spell_system and spell_system.has_method("get_attribute_bonuses"):
		return spell_system.get_attribute_bonuses()
	
	return default_bonuses

## 获取基础灵气获取速度
static func _get_base_spirit_gain_speed(player: Node) -> float:
	if not player:
		return 1.0
	
	# 从 RealmSystem 获取灵气获取速度
	var game_manager = _get_game_manager()
	if game_manager:
		var realm_system = game_manager.get_realm_system() if game_manager.has_method("get_realm_system") else null
		if realm_system and player.has_method("get_realm"):
			return realm_system.get_spirit_gain_speed(player.get_realm())
	
	return 1.0

## 获取术法系统
static func _get_spell_system(player: Node) -> Node:
	if not player:
		return null
	
	# 优先从玩家获取
	if player.has_method("get_spell_system"):
		return player.get_spell_system()
	
	# 从 GameManager 获取
	var game_manager = _get_game_manager()
	if game_manager and game_manager.has_method("get_spell_system"):
		return game_manager.get_spell_system()
	
	return null

## 获取 GameManager
static func _get_game_manager() -> Node:
	return Engine.get_main_loop().root.get_node_or_null("GameManager")

# ==================== 便捷接口（供PlayerData调用） ====================
# 这些接口与PlayerData中的方法签名一致，便于PlayerData委托调用

static func get_final_attack_for(player: Node) -> float:
	return calculate_final_attack(player)

static func get_final_defense_for(player: Node) -> float:
	return calculate_final_defense(player)

static func get_final_speed_for(player: Node) -> float:
	return calculate_final_speed(player)

static func get_final_max_health_for(player: Node) -> float:
	return calculate_final_max_health(player)

static func get_final_max_spirit_energy_for(player: Node) -> float:
	return calculate_final_max_spirit_energy(player)

static func get_final_spirit_gain_speed_for(player: Node) -> float:
	return calculate_final_spirit_gain_speed(player)
