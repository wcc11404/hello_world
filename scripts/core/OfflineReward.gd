class_name OfflineReward extends Node

signal offline_reward_calculated(rewards: Dictionary)

const MAX_OFFLINE_HOURS: float = 4.0
const MIN_OFFLINE_MINUTES: float = 1.0

func calculate_offline_reward(player_data: Node, last_save_time: float) -> Dictionary:
	var current_time = Time.get_unix_time_from_system()
	var offline_seconds: float = 0
	
	if last_save_time > 0:
		offline_seconds = current_time - last_save_time
	else:
		offline_seconds = 0
	
	var offline_minutes = offline_seconds / 60.0
	
	# 限制最小离线时间（1分钟）
	if offline_minutes < MIN_OFFLINE_MINUTES:
		return {
			"offline_seconds": 0,
			"offline_hours": 0.0,
			"efficiency": 1.0,
			"spirit_energy": 0,
			"spirit_stone": 0
		}
	
	# 限制最大离线时间（4小时）
	if offline_minutes > MAX_OFFLINE_HOURS * 60.0:
		offline_minutes = MAX_OFFLINE_HOURS * 60.0
		offline_seconds = MAX_OFFLINE_HOURS * 3600.0
	
	# 效率固定为1.0（取消衰减）
	var efficiency = 1.0
	
	# 灵气获取速度：取玩家修炼时的灵气获取速度（每秒）
	var spirit_per_second = 1.0
	if player_data.has_method("get_spirit_gain_speed"):
		spirit_per_second = float(player_data.get_spirit_gain_speed())
	
	# 灵石获取速度：固定1每分钟，向下取整
	var stone_per_minute = 1.0
	var total_minutes = int(offline_minutes)
	
	var total_spirit = spirit_per_second * offline_seconds * efficiency
	var total_stone = int(stone_per_minute * total_minutes)
	
	# 灵气上限：最大灵气值 × 60
	var max_spirit = player_data.get_final_max_spirit_energy() * 60
	total_spirit = min(total_spirit, max_spirit)
	
	var rewards = {
		"offline_seconds": int(offline_seconds),
		"offline_hours": offline_seconds / 3600.0,
		"efficiency": efficiency,
		"spirit_energy": total_spirit,
		"spirit_stone": total_stone
	}
	
	offline_reward_calculated.emit(rewards)
	return rewards

func apply_offline_reward(player_data: Node, rewards: Dictionary):
	if rewards.get("spirit_energy", 0) > 0:
		player_data.add_spirit_energy(rewards["spirit_energy"])
	
	if rewards.get("spirit_stone", 0) > 0:
		var game_manager = get_node_or_null("/root/GameManager")
		var inventory = game_manager.get_inventory() if game_manager else null
		if inventory:
			inventory.add_item("spirit_stone", rewards["spirit_stone"])

func get_realm_system():
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		return game_manager.get_realm_system()
	return null
