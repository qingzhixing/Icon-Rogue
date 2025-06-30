class_name Fish extends Enemy

@onready var injured_effect: InjuredEffect = $"Injured Effect"
@onready var water_drop_particle: GPUParticles2D = $"Water Drop Particle"
@onready var queue_free_timer: Timer = $"Queue Free Timer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var entity_area_collision_shape: CollisionShape2D = $"Entity Area/Entity Area Collision Shape"

var _disapearing: bool = false;


func _ready() -> void:
	add_constant_force(Vector2(entity_data.get_constant_force_x(), 0));
	water_drop_particle.emitting = true;
	
func _physics_process(_delta: float) -> void:
	if _disapearing:
		entity_area_collision_shape.disabled = true;
	linear_velocity.x = entity_data.standarlize_velocity_x(linear_velocity.x)

func on_damaged(_damage: int, _source: EntityData) -> void:
	if _disapearing:
		return ;
	SoundPlayer.play_sfx("enemy/enemy_injured.ogg");
	injured_effect.display_effect();


func on_death() -> void:
	SoundPlayer.play_sfx("enemy/fish/fish_died" + str(randi() % 2 + 1) + ".ogg");
	_disapearing = true;
	queue_free_timer.start();
	water_drop_particle.emitting = false;
	sprite_2d.visible = false;
	pass # Replace with function body.
