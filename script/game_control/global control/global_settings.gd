extends Node

# 音频总线配置
enum AudioBus {MASTER, SFX, BGM}

# 默认设置
var _settings = {
	"audio": {
		"master_volume": 1.0,
		"sfx_volume": 1.0,
		"bgm_volume": 1.0,
		"master_mute": false,
		"sfx_mute": false,
		"bgm_mute": false
	},
	"video": {
		"fullscreen": false,
		"resolution": Vector2(1280, 720), # 默认分辨率
	}
}

# 总线名称映射
var bus_names = {
	AudioBus.MASTER: "Master",
	AudioBus.SFX: "SFX",
	AudioBus.BGM: "BGM"
}

func _ready():
	# 加载设置
	load_settings()
	
	# 应用设置
	apply_all_settings()

	print_settings();
	
	# 连接窗口大小改变信号
	get_viewport().size_changed.connect(_on_viewport_size_changed);

# 应用所有设置（音频和视频）
# 此函数会依次调用音频设置应用函数和视频设置应用函数，确保所有设置生效
func apply_all_settings():
	apply_audio_settings()
	apply_video_settings()

# 音频设置部分 ------------------------------------------------------------

# 设置指定音频总线的音量
# bus: 音频总线枚举值，指定要设置的音频总线
# volume: 音量值，范围在 0.0 到 1.0 之间
func set_bus_volume(bus: int, volume: float):
	# 生成对应总线音量设置的键名
	var key = bus_names[bus].to_lower() + "_volume"
	# 将音量值限制在 0.0 到 1.0 之间，并更新设置
	_settings["audio"][key] = clamp(volume, 0.0, 1.0)
	# 应用音频设置使更改生效
	apply_audio_settings()

# 通过百分比设置指定音频总线的音量
# bus: 音频总线枚举值，指定要设置的音频总线
# percent: 音量百分比，范围在 0 到 100 之间
func set_bus_volume_percent(bus: int, percent: float):
	# 将百分比转换为 0.0 到 1.0 之间的值，并调用 set_bus_volume 函数
	set_bus_volume(bus, percent / 100.0)

# 获取指定音频总线的音量百分比
# bus: 音频总线枚举值，指定要获取音量的音频总线
# 返回值: 音频总线的音量百分比，范围在 0 到 100 之间
func get_bus_volume_percent(bus: int) -> float:
	# 生成对应总线音量设置的键名
	var key = bus_names[bus].to_lower() + "_volume"
	# 将音量值转换为百分比并返回
	return _settings["audio"][key] * 100.0

# 切换指定音频总线的静音状态
# bus: 音频总线枚举值，指定要切换静音状态的音频总线
# 返回值: 切换后的静音状态，true 表示静音，false 表示未静音
func toggle_bus_mute(bus: int):
	# 生成对应总线静音设置的键名
	var key = bus_names[bus].to_lower() + "_mute"
	# 切换静音状态
	_settings["audio"][key] = !_settings["audio"][key]
	# 应用音频设置使更改生效
	apply_audio_settings()
	return _settings["audio"][key]

# 设置指定音频总线的静音状态
# bus: 音频总线枚举值，指定要设置静音状态的音频总线
# mute: 静音状态，true 表示静音，false 表示未静音
func set_bus_mute(bus: int, mute: bool):
	# 生成对应总线静音设置的键名
	var key = bus_names[bus].to_lower() + "_mute"
	# 设置静音状态
	_settings["audio"][key] = mute
	# 应用音频设置使更改生效
	apply_audio_settings()

func is_bus_muted(bus: int) -> bool:
	var key = bus_names[bus].to_lower() + "_mute"
	return _settings["audio"][key]

func apply_audio_settings():
	for bus in AudioBus.values():
		var bus_name = bus_names[bus]
		var bus_index = AudioServer.get_bus_index(bus_name)
		
		if bus_index >= 0:
			var volume_key = bus_name.to_lower() + "_volume"
			var mute_key = bus_name.to_lower() + "_mute"
			
			var volume = _settings["audio"][volume_key]
			var db = linear_to_db(volume)
			
			AudioServer.set_bus_volume_db(bus_index, db)
			AudioServer.set_bus_mute(bus_index, _settings["audio"][mute_key])

# 视频设置部分 ------------------------------------------------------------

# 设置全屏状态
func set_fullscreen(enabled: bool):
	_settings["video"]["fullscreen"] = enabled
	apply_video_settings()

# 切换全屏状态
func toggle_fullscreen():
	_settings["video"]["fullscreen"] = !_settings["video"]["fullscreen"]
	apply_video_settings()
	return _settings["video"]["fullscreen"]

# 获取当前全屏状态
func is_fullscreen() -> bool:
	return _settings["video"]["fullscreen"]

# 设置分辨率
func set_resolution(width: int, height: int):
	# 确保最小分辨率
	width = max(width, 800)
	height = max(height, 600)
	
	_settings["video"]["resolution"] = Vector2(width, height)
	apply_video_settings()

# 获取当前分辨率
func get_resolution() -> Vector2:
	return _settings["video"]["resolution"]

# 应用视频设置
func apply_video_settings():
	var window = get_window()
	
	# 设置全屏状态
	if _settings["video"]["fullscreen"]:
		window.mode = Window.MODE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
		
		# 设置窗口大小
		var resolution = _settings["video"]["resolution"]
		window.size = resolution
		
		# 确保窗口不会超出屏幕
		var screen_size = DisplayServer.screen_get_size()
		var max_width = min(screen_size.x * 0.95, resolution.x)
		var max_height = min(screen_size.y * 0.95, resolution.y)
		window.size = Vector2(max_width, max_height)
		
		# 居中窗口
		window.position = (screen_size - window.size) / 2

# 窗口大小改变时更新分辨率设置
func _on_viewport_size_changed():
	if _settings["video"]["fullscreen"]:
		# 在全屏模式下，我们不需要保存分辨率
		return
	
	# 只有在窗口模式下才保存分辨率
	if get_window().mode == Window.MODE_WINDOWED:
		var new_size = get_window().size
		# 确保最小分辨率
		if new_size.x >= 800 and new_size.y >= 600:
			_settings["video"]["resolution"] = new_size
			save_settings()

# 设置持久化 ------------------------------------------------------------

# 保存所有设置
func save_settings():
	var config = ConfigFile.new()
	
	# 保存音频设置
	for key in _settings["audio"]:
		config.set_value("Audio", key, _settings["audio"][key])
	
	# 保存视频设置
	for key in _settings["video"]:
		# Vector2需要特殊处理
		if key == "resolution":
			var res = _settings["video"][key]
			config.set_value("Video", "resolution_x", res.x)
			config.set_value("Video", "resolution_y", res.y)
		else:
			config.set_value("Video", key, _settings["video"][key])
	
	# 保存到文件
	var err = config.save("user://global_settings.cfg")
	if err == OK:
		print("全局设置已保存")
	else:
		push_error("保存全局设置失败: " + str(err))

# 加载所有设置
func load_settings():
	print("用户数据目录: ", OS.get_user_data_dir())
	var config = ConfigFile.new()
	var err = config.load("user://global_settings.cfg")
	
	if err == OK:
		# 加载音频设置
		for key in _settings["audio"]:
			var value = config.get_value("Audio", key, _settings["audio"][key])
			_settings["audio"][key] = value
		
		# 加载视频设置
		for key in _settings["video"]:
			if key == "resolution":
				var x = config.get_value("Video", "resolution_x", _settings["video"]["resolution"].x)
				var y = config.get_value("Video", "resolution_y", _settings["video"]["resolution"].y)
				_settings["video"]["resolution"] = Vector2(x, y)
			else:
				var value = config.get_value("Video", key, _settings["video"][key])
				_settings["video"][key] = value
		
		print("全局设置已加载")
		return true
	else:
		print("无法加载全局设置，使用默认值")
		return false

# 打印当前设置
func print_settings():
	print("===== 全局设置 =====")
	
	# 音频设置
	print("音频设置:")
	print("  Master音量: %d%% (%s)" % [
		_settings["audio"]["master_volume"] * 100,
		"静音" if _settings["audio"]["master_mute"] else "启用"
	])
	print("  SFX音量: %d%% (%s)" % [
		_settings["audio"]["sfx_volume"] * 100,
		"静音" if _settings["audio"]["sfx_mute"] else "启用"
	])
	print("  BGM音量: %d%% (%s)" % [
		_settings["audio"]["bgm_volume"] * 100,
		"静音" if _settings["audio"]["bgm_mute"] else "启用"
	])
	
	# 视频设置
	print("视频设置:")
	print("  全屏: %s" % ("是" if _settings["video"]["fullscreen"] else "否"))
	print("  分辨率: %d x %d" % [
		_settings["video"]["resolution"].x,
		_settings["video"]["resolution"].y
	])
	print("====================")


# 清空所有设置并重置为默认值
func clear_all_settings():
	# 1. 重置内存中的设置
	reset_to_default_settings()
	
	# 2. 删除配置文件
	delete_settings_file()
	
	# 3. 应用默认设置
	apply_all_settings()
	
	# 4. 保存新的默认设置
	save_settings()
	
	# 5. 通知所有监听器
	emit_signal("settings_cleared")
	
	return true

# 重置为默认设置（不删除文件）
func reset_to_default_settings():
	# 创建默认设置模板
	var default_settings = {
		"audio": {
			"master_volume": 1.0,
			"sfx_volume": 1.0,
			"bgm_volume": 1.0,
			"master_mute": false,
			"sfx_mute": false,
			"bgm_mute": false
		},
		"video": {
			"fullscreen": false,
			"resolution": Vector2(1280, 720),
			"vsync": true,
			"fps_limit": 0
		}
	}
	
	# 应用默认设置
	_settings = default_settings.duplicate(true)
	print("设置已重置为默认值")

# 删除配置文件
func delete_settings_file():
	var dir = DirAccess.open("user://")
	if dir.file_exists("global_settings.cfg"):
		dir.remove("global_settings.cfg")
		print("已删除配置文件")
		return true
	else:
		print("配置文件不存在")
		return false

# 在类顶部添加信号定义
signal settings_cleared
