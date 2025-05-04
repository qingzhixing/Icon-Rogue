extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var explode_sprite: Sprite2D = $"Explode Sprite"
@onready var entity_data: EntityData = $EntityData

@onready var explode_from: EntityData = entity_data;

func _ready() -> void:
	animation_player.play("RESET");
	collision_shape_2d.disabled = true;
	explode_sprite.visible = false;

func do_explode():
	animation_player.play("EXPLODE");
	explode_sprite.visible = true;
	collision_shape_2d.disabled = false;
	pass


func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is PlayerController:
		var player = parent as PlayerController
		player.entity_data.take_damage(entity_data.damage, explode_from)
