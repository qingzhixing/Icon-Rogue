class_name Creeper extends Enemy

@export var can_explode = true;

var explode_scene: PackedScene = preload("res://assets/sprite/entity/enemy/explode.tscn");

func on_death() -> void:
	GlobalSoundPlayer.play_sfx("enemy/creeper/death.ogg");
	queue_free()

@warning_ignore("unused_parameter")
func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("enemy/creeper/say" + str(randi() % 4 + 1) + ".ogg");


func on_explode_entered(area: Area2D) -> void:
	if !can_explode:
		return
	if !area.get_parent() is PlayerController:
		return
	if explode_scene == null || !explode_scene.can_instantiate():
		return ;
	call_deferred("delay_explode")

func delay_explode():
	var explode = explode_scene.instantiate() as Explode
	get_tree().current_scene.add_child(explode)
	explode.do_explode(entity_data)
	explode.position = position
	GlobalSoundPlayer.play_sfx("enemy/creeper/death.ogg");
	queue_free()
