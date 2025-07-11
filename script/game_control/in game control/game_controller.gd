extends Node

@onready var hover_ui: UIController = %HoverUI
@onready var player: PlayerController = %Player
@onready var sword_spawner: Node2DSpawner = $"../Sword Spawner"

var _in_dead_process: bool = false;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if _in_dead_process && Input.is_action_just_pressed("respawn_key"):
		_in_dead_process = false;
		do_restart();
	if GameStatistics.dead_enemy_count % 3 == 0 && GameStatistics.dead_enemy_count != 0:
		GameStatistics.dead_enemy_count = 0;
		GameStopper.set_game_stopped(true);
		hover_ui.display_upgrade_menu();

func do_restart():
	GameStopper.set_game_stopped(false);
	do_exit();

func do_exit():
	GameStopper.set_game_stopped(false);
	get_tree().change_scene_to_file("res://scene/start_page.tscn");

func on_player_dead():
	if _in_dead_process:
		return
	_in_dead_process = true;
	GameStopper.set_game_stopped(true);
	print("Player Died!");
	# Sound Effect
	SoundPlayer.play_sfx("game_state/Lose.ogg");
	hover_ui.set_over_overlay_visible(true);

func on_menu_open():
	GameStopper.set_game_stopped(true);

func on_menu_closed():
	if !_in_dead_process:
		GameStopper.set_game_stopped(false);

func _on_restart_button_pressed() -> void:
	do_restart();


func _on_button_exit_pressed() -> void:
	do_exit();

# 0 - Left, 1 - Mid, 2 - Right
func player_upgrade(button_id: int):
	if button_id == 0:
		sword_spawner.spawn_interval_sec *= 0.7;
	elif button_id == 1:
		player.entity_data.max_health += 10;
		player.entity_data.health += 10;
	elif button_id == 2:
		player.invincible_timer.wait_time += 0.05;
	GameStatistics.dead_enemy_count = 0;
	GameStopper.set_game_stopped(false);
