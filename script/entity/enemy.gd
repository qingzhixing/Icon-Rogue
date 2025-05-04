class_name Enemy extends RigidBody2D
@onready var entity_data: EntityData = $EntityData

func _ready() -> void:
	add_constant_force(Vector2(-entity_data.speed, 0))
