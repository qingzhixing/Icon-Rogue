class_name Creeper extends Enemy

@onready var injured_effect: InjuredEffect = $"Injured Effect"

@export var can_explode = true;

@export var explode_scene: PackedScene;

@onready var entity_data: EntityData = $EntityData

func _ready() -> void:
	add_constant_force(Vector2(entity_data.get_constant_force_x(), 0))
	
func _physics_process(_delta: float) -> void:
	linear_velocity.x = entity_data.standarlize_velocity_x(linear_velocity.x)


func on_death() -> void:
	SoundPlayer.play_sfx("enemy/creeper/death.ogg");
	queue_free()

func on_damaged(_damage: int, _source: EntityData) -> void:
	SoundPlayer.play_sfx("enemy/creeper/say" + str(randi() % 4 + 1) + ".ogg");
	injured_effect.display_effect();


func on_explode_entered(area: Area2D) -> void:
	if !can_explode:
		return
	if !area.get_parent() is PlayerController:
		return
	if explode_scene == null || !explode_scene.can_instantiate():
		return ;
	delay_explode.call_deferred();

func delay_explode():
	var explode = explode_scene.instantiate() as Explode
	get_parent().add_child(explode)
	explode.do_explode(entity_data)
	explode.position = position
	SoundPlayer.play_sfx("enemy/creeper/death.ogg");
	queue_free()
