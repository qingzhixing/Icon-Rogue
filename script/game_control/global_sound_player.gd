extends Node

const SFX_SOUND_PATH_PREFIX = "res://assets/sfx/"

# Plays a sfx
# sfx_path: sfx file path without prefix "res://assets/sfx/"
func play_sfx(sfx_path: String, volume: float = 0.0, bus = "SFX"):
	var audio_player = AudioStreamPlayer.new()
	var audio_stream = load(SFX_SOUND_PATH_PREFIX + sfx_path)
	
	if audio_stream:
		audio_player.stream = audio_stream
		audio_player.volume_db = volume
		audio_player.bus = bus
		add_child(audio_player)
		
		# 确保播放前节点已加入场景树
		if audio_player.is_inside_tree():
			audio_player.play()
		else:
			audio_player.call_deferred("play")
		
		audio_player.connect("finished", audio_player.queue_free)
	else:
		push_error("音频文件未找到: %s" % sfx_path)
