extends RigidBody2D
class_name PlayerController

@onready var entity_data: EntityData = $EntityData
@onready var ui: UIController = %UI

func _ready():
	ui.update_player_health_display(entity_data);

func on_area_entered(area: Area2D):
	if !area.get_collision_layer_value(3): # 仅伤害Enemy
		return
	var area_parent = area.get_parent();
	if area_parent is Enemy:
		# Apply knock back force to enemy
		var enemy = area_parent as Enemy;
		# print("Enemy Entered: ",enemy.name)
		# Knock Back
		enemy.linear_velocity.x = max(0, enemy.linear_velocity.x);
		enemy.linear_velocity.y = max(0, enemy.linear_velocity.y);
		enemy.linear_velocity += entity_data.knockback_velocity;
		# Take damage to enemy
		var enemy_entity = enemy.entity_data;
		enemy_entity.take_damage(entity_data.attack, entity_data);


@warning_ignore("unused_parameter")
func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("injured/hurt" + str(randi() % 2 + 1) + ".ogg", 0.5);
	ui.update_player_health_display(entity_data);


func on_death() -> void:
	ui.update_player_health_display(entity_data);
	print("Player Died!");
	# Sound Effect
	GlobalSoundPlayer.play_sfx("game_state/Lose.ogg");
	# respawn
	entity_data.health = entity_data.max_health;
	ui.update_player_health_display(entity_data);
	ui.on_player_died();
