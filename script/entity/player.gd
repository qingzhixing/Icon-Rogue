extends RigidBody2D

@export_category("Player Data")
@export var knock_back = 300

func on_area_entered(area: Area2D):
	print("Area Entered:", area.name)
	print("Area Parent:", area.get_parent())
	if area.get_parent() is Fish:
		print("Fish knocked back!")
		var fish = area.get_parent() as Fish;
		fish.linear_velocity = Vector2(knock_back, fish.linear_velocity.y)
