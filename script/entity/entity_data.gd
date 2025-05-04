extends Node
class_name EntityData
@export var entity_type: String = "Entity"
@export var max_health: int = 100
@export var health: int = 100
@export var attack: int = 10
@export var defense: int = 10
@export_enum("right", "left") var moving_direction = "left"
@export var max_velocity_x_abs: int = 40
@export var constant_force_x_abs = 10;
@export var knockback_velocity: Vector2 = Vector2(30, 0)

func _ready() -> void:
	health = max_health;

signal on_death()
signal on_damaged(damage: int, source: EntityData)

func get_constant_force_x() -> float:
	var times = 1;
	if moving_direction == "left":
		times = -1;
		
	return constant_force_x_abs * times;

# 请在physics_process中调用
func standarlize_velocity_x(velocity_x: float) -> float:
	if moving_direction == "left":
		velocity_x = max(velocity_x, -max_velocity_x_abs);
	else:
		velocity_x = min(velocity_x, max_velocity_x_abs);
	return velocity_x;

func get_max_velocity_x() -> float:
	var times = 1;
	if moving_direction == "left":
		times = -1;
	return max_velocity_x_abs * times;

func take_damage(damage: int, source: EntityData) -> void:
	if health <= 0:
		return ;
	health -= damage
	on_damaged.emit(damage, source)
	if health <= 0:
		health = 0
		on_death.emit()
