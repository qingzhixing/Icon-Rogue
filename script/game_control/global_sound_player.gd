extends Node

const SFX_SOUND_PATH_PREFIX = "res://assets/sfx/"
const BGM_SOUND_PATH_PREFIX = "res://assets/bgm/"

var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()
var bgm_stream: AudioStream = null

var bgm_paths: Array = [
	"Pixel Rogue Anthem_1.mp3",
	"Pixel Rogue Anthem_2.mp3",
	"Pixel Wanderer_1.mp3",
	"Pixel Wanderer_2.mp3",
]

var current_bgm_index: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	bgm_player.autoplay = false
	bgm_player.bus = "BGM"
	add_child(bgm_player);
	current_bgm_index = randi() % bgm_paths.size();
	play_bgm(bgm_paths[current_bgm_index]);
	bgm_player.finished.connect(on_bgm_finished);

func on_bgm_finished():
	current_bgm_index += 1;
	current_bgm_index %= bgm_paths.size();
	play_bgm(bgm_paths[current_bgm_index], 100.0)

func play_bgm(bgm_path: String, volume: float = 0.0):
	bgm_stream = load(BGM_SOUND_PATH_PREFIX + bgm_path)
	if bgm_stream:
		bgm_player.stream = bgm_stream
		bgm_player.volume_db = volume
		bgm_player.play();
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
