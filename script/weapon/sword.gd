extends RigidBody2D

@onready var entity_data: EntityData = $EntityData

func _ready() -> void:
	linear_velocity.x = entity_data.speed;

func on_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent();
	if area_parent is Enemy:
		# Apply knock back force to enemy
		var enemy = area_parent as Enemy;
		enemy.entity_data.take_damage(entity_data.attack, entity_data);
		enemy.linear_velocity.x = max(0, enemy.linear_velocity.x);
		enemy.linear_velocity.y = max(0, enemy.linear_velocity.y);
		enemy.linear_velocity += entity_data.knockback_velocity;
		queue_free();
