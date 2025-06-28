extends Node2D
class_name Explode

@onready var entity_data: EntityData = $EntityData
@onready var explosion_particle: GPUParticles2D = $"Explosion Particle"
@onready var explode_timer: Timer = $"Explode Timer"
@onready var visual_timer: Timer = $"Visual Timer"

var explode_from: EntityData = null;

var exploding: bool = false;
var exploded: bool = false;
var entered_entity: Array = [];

func _ready() -> void:
	exploding = false;

func do_explode(from: EntityData = entity_data):
	explode_from = from;
	exploding = true;
	explosion_particle.emitting = true;
	explode_timer.start();
	visual_timer.start();
	SoundPlayer.play_sfx("explode/Explosion" + str(randi() % 5 + 1) + ".ogg");
	pass


func on_area_entered(area: Area2D) -> void:
	if !exploding:
		return
	var parent = area.get_parent()
	if parent is PlayerController:
		var player = parent as PlayerController
		if explode_from == null:
			explode_from = entity_data;
		player.entity_data.take_damage(entity_data.attack, explode_from)

func on_end_explosion() -> void:
	exploding = false;

func on_end_vision() -> void:
	queue_free();
