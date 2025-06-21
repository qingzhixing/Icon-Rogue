extends Node

var is_game_stopped: bool = false;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func trigger_stop():
	is_game_stopped = !is_game_stopped;

func set_game_stopped(_is_game_stopped: bool):
	is_game_stopped = _is_game_stopped;

func _process(_delta: float) -> void:
	if is_game_stopped:
		get_tree().paused = true;
	else:
		get_tree().paused = false;
