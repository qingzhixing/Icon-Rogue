class_name Explode extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_sprite: Sprite2D = $"Explode Sprite"
@onready var entity_data: EntityData = $EntityData
var explode_from: EntityData = null;

var exploding: bool = false;
var exploded: bool = false;
var entered_entity: Array = [];

func _ready() -> void:
	animation_player.play("RESET");
	#explode_sprite.visible = false;
	exploding = false;

func do_explode(from: EntityData = entity_data):
	#print("Do Explode From:", from.get_parent().name)
	#explode_sprite.visible = true;
	explode_from = from;
	exploding = true;
	animation_player.play("Explode");
	GlobalSoundPlayer.play_sfx("explode/Explosion" + str(randi() % 5 + 1) + ".ogg");
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
	queue_free()
