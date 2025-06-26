class_name Fish extends Enemy

@onready var injured_effect: InjuredEffect = $"Injured Effect"

func on_damaged(_damage: int, _source: EntityData) -> void:
	SoundPlayer.play_sfx("enemy/enemy_injured.ogg");
	injured_effect.display_effect();


func on_death() -> void:
	SoundPlayer.play_sfx("enemy/fish/fish_died" + str(randi() % 2 + 1) + ".ogg");
	queue_free();
	pass # Replace with function body.
