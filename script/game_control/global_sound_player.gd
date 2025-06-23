extends Node

const SFX_SOUND_PATH_PREFIX = "res://assets/sfx/"
const BGM_SOUND_PATH_PREFIX = "res://assets/bgm/"

var bgm_player: AudioStreamPlayer;

var bgm_paths: Array = [
	"Pixel Rogue Anthem_1.mp3",
	"Pixel Rogue Anthem_2.mp3",
	"Pixel Wanderer_1.mp3",
	"Pixel Wanderer_2.mp3",
]

var current_bgm_index: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;

	current_bgm_index = randi() % bgm_paths.size();
	play_bgm(bgm_paths[current_bgm_index]);
	

func on_bgm_finished():
	current_bgm_index += 1;
	current_bgm_index %= bgm_paths.size();
	bgm_player.volume_db = -80;
	bgm_player.stop();
	bgm_player.queue_free();
	play_bgm(bgm_paths[current_bgm_index], 100.0)

func pause_bgm():
	bgm_player.volume_db = -80;
	bgm_player.stop();
	bgm_player.pause();

func resume_bgm():
	bgm_player.volume_db = 0;
	bgm_player.play();

# Plays a bgm
# bgm_path: bgm file path without prefix "res://assets/bgm/"
func play_bgm(bgm_path: String, volume: float = 0.0):
	if bgm_player:
		bgm_player.stop();
		bgm_player.queue_free();

	bgm_player = AudioStreamPlayer.new()
	bgm_player.autoplay = false
	bgm_player.bus = "BGM"
	add_child.call_deferred(bgm_player);
	bgm_player.finished.connect(on_bgm_finished);
		
	print("Playing BGM: %s" % bgm_path);
	var bgm_stream = load(BGM_SOUND_PATH_PREFIX + bgm_path)
	if bgm_stream:
		bgm_player.stream = bgm_stream
		bgm_player.volume_db = volume
		bgm_player.play.call_deferred();
	else:
		print("BGM file not found: %s" % bgm_path)

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
