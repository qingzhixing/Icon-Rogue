extends Node2D

@export_category("Spawner")
@export var target_scene: PackedScene = null;
@export var spawn_interval_sec: float = 0.5;
@export var instance_life_time_sec: float = 5;

var _last_spawn_tick: float = -100;

func _process(delta):
	if target_scene == null:
		return ;
	var current_tick = Time.get_ticks_msec() / 1000.0;
	if current_tick - _last_spawn_tick < spawn_interval_sec:
		return ;
	_last_spawn_tick = current_tick;

	# Spawn a new instance of the target scene
	var instance = target_scene.instantiate();
	if instance == null:
		return ;
	if !instance is Node2D:
		return ;
	instance = instance as Node2D;

	get_tree().current_scene.add_child(instance);
	instance.position = position;
	instance.rotation = rotation;

	# Set the life time of the instance
	var timer: Timer = Timer.new();
	timer.set_wait_time(instance_life_time_sec);
	timer.timeout.connect(
		func():
			instance.queue_free();
			timer.queue_free();
	);
	add_child(timer);
	timer.start();
