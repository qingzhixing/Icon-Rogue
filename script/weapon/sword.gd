extends RigidBody2D

@onready var entity_data: EntityData = $EntityData

@export_category("Weapon")
@export var knockback = 30
@export var interval_sec = 0.3;

# var _entered_entity: Array;
# var _last_attack_tick = -100

func _ready() -> void:
	linear_velocity.x = entity_data.speed;

# @warning_ignore("unused_parameter")
# func _process(delta: float) -> void:
# 	var current_tick = Time.get_ticks_msec();
# 	if current_tick - _last_attack_tick < interval_sec * 1000:
# 		return
# 	_last_attack_tick = current_tick;
	
# 	for fish in _entered_entity:
# 		fish.entity_data.take_damage(entity_data.attack, entity_data);
# 		fish.linear_velocity.x = max(0, fish.linear_velocity.x);
# 		fish.linear_velocity.x += knockback;
	

func on_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity is Fish:
		var fish = entity as Fish
		# _entered_entity.push_back(fish);
		fish.entity_data.take_damage(entity_data.attack, entity_data);
		fish.linear_velocity.x = max(0, fish.linear_velocity.x);
		fish.linear_velocity.x += knockback;
		queue_free();


# func on_area_exited(area: Area2D) -> void:
# 	var entity = area.get_parent()
# 	if entity is Fish:
# 		var fish = entity as Fish
# 		var index = _entered_entity.find(fish);
# 		if index != -1:
# 			_entered_entity.remove_at(index);
