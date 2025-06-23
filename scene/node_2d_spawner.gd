extends Node2D

@onready var spawn_timer: Timer = $"Spawn Timer"

@export_category("Spawner")
@export var target_scene: PackedScene = null;
@export var spawn_interval_sec: float = 0.5;
@export var infinity_spawn: bool = false;
@export var spawn_amount: int = 10;
@export var enable_life_time: bool = true;
@export var instance_life_time_sec: float = 5;
@export var start_spawn: bool = false;

signal on_finished_spawning();

var _spawn_count: int = 0;

func _ready():
	spawn_timer.wait_time = spawn_interval_sec;
	spawn_timer.one_shot = true;
	spawn_timer.start();
	if start_spawn:
		do_spawn();

func _on_spawn_timer_timeout():
	do_spawn();
	spawn_timer.start();

func do_spawn():
	if !infinity_spawn && _spawn_count >= spawn_amount:
		return ;
	if target_scene == null:
		return ;

	# Spawn a new instance of the target scene
	var instance = target_scene.instantiate();
	if instance == null:
		return ;
	if !instance is Node2D:
		return ;
	instance = instance as Node2D;

	get_tree().current_scene.add_child.call_deferred(instance);
	instance.position = position;
	instance.rotation = rotation;

	# Increase the spawn count
	_spawn_count += 1;
	if _spawn_count >= spawn_amount:
		on_finished_spawning.emit();

	# Set the life time of the instance
	if !enable_life_time:
		return ;
	var _timer: Timer = Timer.new();
	_timer.set_wait_time(instance_life_time_sec);
	var weak_instance = weakref(instance) as Node2D;
	_timer.timeout.connect(
		func():
			if is_instance_valid(weak_instance):
				weak_instance.queue_free();
			_timer.queue_free();
	);
	add_child.call_deferred(_timer);
	_timer.start();
