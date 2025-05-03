class_name Fish extends RigidBody2D

@onready var entity_data: EntityData = $EntityData

func on_area_entered(area: Area2D):
	if area.get_parent() is Player:
		GlobalSoundPlayer.play_sfx("enemy/fish/fish" + str(randi() % 2 + 1) + ".ogg");
		var player = area.get_parent() as Player
		# Take damage to player
		var player_entity = player.entity_data;
		player_entity.take_damage(entity_data.attack, entity_data);

	
func _ready() -> void:
	add_constant_force(Vector2(-entity_data.speed, 0));
	pass


func on_damaged(damage: int, source: EntityData) -> void:
	print("Fish Get Damaged from: ", source.get_parent().name, " with damage:", damage);
	pass # Replace with function body.
