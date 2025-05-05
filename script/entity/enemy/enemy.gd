class_name Enemy extends RigidBody2D
@onready var entity_data: EntityData = $EntityData

func _ready() -> void:
	add_constant_force(Vector2(entity_data.get_constant_force_x(),0))
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	linear_velocity.x = entity_data.standarlize_velocity_x(linear_velocity.x)
