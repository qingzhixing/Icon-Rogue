class_name Fish extends RigidBody2D

@onready var entity_data: EntityData = $EntityData

func on_area_entered(area: Area2D):
	if area.get_parent() is Player:
		var player = area.get_parent() as Player
		# Take damage to player
		var player_entity = player.entity_data;
		player_entity.take_damage(entity_data.attack, entity_data);

	
func _ready() -> void:
	add_constant_force(Vector2(-entity_data.speed, 0));
	pass

@warning_ignore("unused_parameter")
func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("enemy/enemy_injured.ogg");


func on_death() -> void:
	GlobalSoundPlayer.play_sfx("enemy/fish/fish_died" + str(randi() % 2 + 1) + ".ogg");
	queue_free();
	pass # Replace with function body.
