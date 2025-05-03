extends Node
class_name EntityData
@export var entity_type: String = "Entity"
@export var max_health: int = 100
@export var health: int = 100
@export var attack: int = 10
@export var defense: int = 10
@export var speed: int = 10

func _ready() -> void:
	health = max_health;

signal on_death()
signal on_damaged(damage: int, source: EntityData)

func take_damage(damage: int, source: EntityData) -> void:
	if health <= 0:
		return;
	health -= damage
	on_damaged.emit(damage, source)
	if health <= 0:
		health = 0
		on_death.emit()
