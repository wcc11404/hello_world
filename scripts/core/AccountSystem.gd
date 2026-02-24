class_name AccountSystem extends Node

signal account_created(username: String)
signal login_success(username: String)
signal login_failed(reason: String)
signal logout()

const ACCOUNTS_FILE = "user://accounts.json"
const DEFAULT_USERNAME = "test"
const DEFAULT_PASSWORD = "test_password"
const DEFAULT_NICKNAME = "hsams"
const DEFAULT_AVATAR = "avatar_abstract.png"

var current_account: Dictionary = {}
var accounts: Dictionary = {}

func _ready():
	load_accounts()
	# 如果没有账号，创建默认账号
	if accounts.is_empty():
		create_default_account()

func load_accounts():
	if FileAccess.file_exists(ACCOUNTS_FILE):
		var file = FileAccess.open(ACCOUNTS_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var result = json.parse(json_string)
			if result == OK:
				accounts = json.get_data()
				if typeof(accounts) != TYPE_DICTIONARY:
					accounts = {}

func save_accounts():
	var file = FileAccess.open(ACCOUNTS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(accounts, "\t"))
		file.close()

func create_default_account():
	create_account(DEFAULT_USERNAME, DEFAULT_PASSWORD, DEFAULT_NICKNAME, DEFAULT_AVATAR)

func create_account(username: String, password: String, nickname: String, avatar: String) -> bool:
	if accounts.has(username):
		return false
	
	accounts[username] = {
		"password": password,
		"nickname": nickname,
		"avatar": avatar,
		"created_at": Time.get_unix_time_from_system()
	}
	
	save_accounts()
	account_created.emit(username)
	return true

func login(username: String, password: String) -> bool:
	if not accounts.has(username):
		login_failed.emit("用户名不存在")
		return false
	
	var account = accounts[username]
	if account["password"] != password:
		login_failed.emit("密码错误")
		return false
	
	current_account = {
		"username": username,
		"nickname": account["nickname"],
		"avatar": account["avatar"]
	}
	
	login_success.emit(username)
	return true

func logout_account():
	current_account = {}
	logout.emit()

func is_logged_in() -> bool:
	return not current_account.is_empty()

func get_current_account() -> Dictionary:
	return current_account.duplicate()

func get_nickname() -> String:
	return current_account.get("nickname", DEFAULT_NICKNAME)

func get_avatar() -> String:
	return current_account.get("avatar", DEFAULT_AVATAR)

func get_username() -> String:
	return current_account.get("username", DEFAULT_USERNAME)

func update_profile(nickname: String = "", avatar: String = "") -> bool:
	if not is_logged_in():
		return false
	
	var username = current_account["username"]
	if not accounts.has(username):
		return false
	
	if not nickname.is_empty():
		accounts[username]["nickname"] = nickname
		current_account["nickname"] = nickname
	
	if not avatar.is_empty():
		accounts[username]["avatar"] = avatar
		current_account["avatar"] = avatar
	
	save_accounts()
	return true

func change_password(old_password: String, new_password: String) -> bool:
	if not is_logged_in():
		return false
	
	var username = current_account["username"]
	if not accounts.has(username):
		return false
	
	if accounts[username]["password"] != old_password:
		return false
	
	accounts[username]["password"] = new_password
	save_accounts()
	return true
