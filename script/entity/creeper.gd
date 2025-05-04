class_name Creeper extends Enemy


func on_death() -> void:
	GlobalSoundPlayer.play_sfx("enemy/creeper/death.ogg");
	queue_free()


func on_damaged(damage: int, source: EntityData) -> void:
	GlobalSoundPlayer.play_sfx("enemy/creeper/say" + str(randi() % 4 + 1) + ".ogg");
