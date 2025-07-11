@tool
extends Node2D
class_name Node2DSpawner
@onready var spawn_timer: Timer = $"Spawn Timer"

var target_scene: PackedScene
var manually_spawn: bool = false:
	set(value):
		manually_spawn = value
		notify_property_list_changed()

var spawn_interval_sec: float = 0.5
var start_spawn: bool = false
var spawn_amount: int = 10
var infinity_spawn: bool = false:
	set(value):
		infinity_spawn = value
		notify_property_list_changed()
var enable_life_time: bool = true:
	set(value):
		enable_life_time = value
		notify_property_list_changed()
var instance_life_time_sec: float = 5

func _get_property_list() -> Array:
	return [
		{"name": "Spawner", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		
		{"name": "target_scene", "type": TYPE_OBJECT, "usage": PROPERTY_USAGE_DEFAULT, "hint": PROPERTY_HINT_RESOURCE_TYPE, "hint_string": "PackedScene"},
		
		{"name": "Spawn Args", "type": TYPE_NIL, "usage": PROPERTY_USAGE_CATEGORY},
		
		{"name": "manually_spawn", "type": TYPE_BOOL},
		{"name": "spawn_interval_sec", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT if not manually_spawn else PROPERTY_USAGE_NO_EDITOR},
		{"name": "start_spawn", "type": TYPE_BOOL, "usage": PROPERTY_USAGE_DEFAULT if not manually_spawn else PROPERTY_USAGE_NO_EDITOR},
		
		{"name": "infinity_spawn", "type": TYPE_BOOL},
		{"name": "spawn_amount", "type": TYPE_INT, "usage": PROPERTY_USAGE_DEFAULT if not infinity_spawn else PROPERTY_USAGE_NO_EDITOR},
		
		{"name": "enable_life_time", "type": TYPE_BOOL},
		{"name": "instance_life_time_sec", "type": TYPE_FLOAT, "usage": PROPERTY_USAGE_DEFAULT if enable_life_time else PROPERTY_USAGE_NO_EDITOR},
	]

signal on_finished_spawning();

var _spawn_count: int = 0;

func _ready():
	if Engine.is_editor_hint():
		return

	spawn_timer.wait_time = spawn_interval_sec;
	spawn_timer.one_shot = true;

	if !manually_spawn:
		spawn_timer.start();
		if start_spawn:
			spawn_instance();
			
func _process(_delta: float) -> void:
	spawn_timer.wait_time = spawn_interval_sec;

func _on_spawn_timer_timeout() -> void:
	if Engine.is_editor_hint():
		return

	if manually_spawn:
		return ;
	spawn_instance();
	spawn_timer.start();

func spawn_instance() -> Node2D:
	if Engine.is_editor_hint():
		return null;

	if !infinity_spawn && _spawn_count >= spawn_amount:
		return null;
	if target_scene == null:
		return null;

	# Spawn a new instance of the target scene
	var instance = target_scene.instantiate();
	if instance == null:
		return null;
	if !instance is Node2D:
		return null;
	instance = instance as Node2D;

	# Add to scene(as parent's child)
	instance.position = position;
	instance.rotation = rotation;
	get_parent().add_child.call_deferred(instance);

	# Increase the spawn count
	_spawn_count += 1;
	if _spawn_count >= spawn_amount:
		on_finished_spawning.emit();
		return instance;

	# Set the life time of the instance
	if !enable_life_time:
		return instance;

	var _timer: Timer = Timer.new();
	_timer.set_wait_time(instance_life_time_sec);
	_timer.timeout.connect(
		func():
			instance.queue_free();
			_timer.queue_free();
	);
	add_child.call_deferred(_timer);
	_timer.start.call_deferred();

	return instance;
