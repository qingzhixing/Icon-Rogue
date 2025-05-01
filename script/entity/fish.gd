class_name Fish extends RigidBody2D

@export_category("Entity Data")
@export var speed = 300.0
	
func _ready() -> void:
	add_constant_force(Vector2(-speed, 0));
	pass
	
func _process(delta: float) -> void:
	pass
