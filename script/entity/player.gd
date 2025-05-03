extends RigidBody2D
class_name Player

@export_category("Player Data")
@export var knock_back_velocity = 300

@onready var entity_data: EntityData = $EntityData

signal update_player_health_display(health: int);

func _ready():
	update_player_health_display.emit(entity_data.health);

func on_area_entered(area: Area2D):
	if area.get_parent() is Fish:
		# Apply knock back force to fish
		var fish = area.get_parent() as Fish;
		# Knock Back
		fish.linear_velocity.x = max(0, fish.linear_velocity.x);
		fish.linear_velocity.x += knock_back_velocity;
		# Take damage to fish
		var fish_entity = fish.entity_data;
		fish_entity.take_damage(entity_data.attack, entity_data);


func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("injured/hurt" + str(randi() % 2 + 1) + ".ogg", 0.5);
	update_player_health_display.emit(entity_data.health);
	pass # Replace with function body.


func on_death() -> void:
	update_player_health_display.emit(entity_data.health);
	print("Player Died!");
	# Sound Effect
	GlobalSoundPlayer.play_sfx("game_state/Lose.ogg");
	# respawn
	entity_data.health = entity_data.max_health;
	update_player_health_display.emit(entity_data.health);
	pass # Replace with function body.
