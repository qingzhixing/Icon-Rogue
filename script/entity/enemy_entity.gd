class_name EnemyEntity extends Node

@onready var entity_data: EntityData = $"../EntityData"

func on_area_entered(area: Area2D):
	#print("Player Entered Enemy Area")
	var area_parent = area.get_parent()
	if area_parent is PlayerController:
		var player = area_parent as PlayerController
		# Take damage to player
		var player_entity = player.entity_data
		player_entity.take_damage(entity_data.attack, entity_data)
