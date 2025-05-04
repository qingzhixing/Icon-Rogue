class_name Fish extends Enemy

@warning_ignore("unused_parameter")
func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("enemy/enemy_injured.ogg");


func on_death() -> void:
	GlobalSoundPlayer.play_sfx("enemy/fish/fish_died" + str(randi() % 2 + 1) + ".ogg");
	queue_free();
	pass # Replace with function body.
