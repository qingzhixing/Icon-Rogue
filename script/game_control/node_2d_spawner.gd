extends Node2D

@export_category("Spawner")
@export var target_scene: PackedScene = null;
@export var spawn_interval_sec: float = 0.5;
@export var infinity_spawn: bool = false;
@export var spawn_amount: int = 10;
@export var enable_life_time: bool = true;
@export var instance_life_time_sec: float = 5;

signal on_finished_spawning();

var _last_spawn_tick: float = -100;
var _spawn_count: int = 0;

func _process(delta):
	if !infinity_spawn && _spawn_count >= spawn_amount:
		return ;
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

	# Increase the spawn count
	_spawn_count += 1;
	if _spawn_count >= spawn_amount:
		on_finished_spawning.emit();

	# Set the life time of the instance
	if !enable_life_time:
		return ;
	var timer: Timer = Timer.new();
	timer.set_wait_time(instance_life_time_sec);
	var weak_instance = weakref(instance) as Node2D;
	timer.timeout.connect(
		func():
			if is_instance_valid(weak_instance):
				weak_instance.queue_free();
			timer.queue_free();
	);
	add_child(timer);
	timer.start();
