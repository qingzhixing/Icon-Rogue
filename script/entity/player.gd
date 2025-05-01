extends RigidBody2D
class_name Player

@export_category("Player Data")
@export var knock_back_velocity = 300

@onready var entity_data: EntityData = $EntityData

func on_area_entered(area: Area2D):
	if area.get_parent() is Fish:
		# Apply knock back force to fish
		var fish = area.get_parent() as Fish;
		fish.linear_velocity = Vector2(knock_back_velocity, fish.linear_velocity.y)
		# Take damage to fish
		var fish_entity = fish.entity_data;
		fish_entity.take_damage(entity_data.attack, entity_data);


func on_damaged(damage: int, source: EntityData) -> void:
	print("Player Get Damaged from:", source.get_parent().name, " with damage:", damage);
	pass # Replace with function body.
