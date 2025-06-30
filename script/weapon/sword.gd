extends RigidBody2D

@onready var entity_data: EntityData = $EntityData
@onready var disapear_timer: Timer = $"Disapear Timer"
@onready var sword_fly_particle: GPUParticles2D = $"Sword Fly Particle"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_area_collision_shape: CollisionShape2D = $"Attack Area/Attack Area Collision Shape"

var _disapearing: bool = false;

func _ready() -> void:
	sword_fly_particle.emitting = true;
	linear_velocity.x = entity_data.get_max_velocity_x();

func _physics_process(_delta: float) -> void:
	if _disapearing:
		attack_area_collision_shape.disabled = true;

func on_area_entered(area: Area2D) -> void:
	if _disapearing:
		return ;
	if !area.get_collision_layer_value(3): # 仅伤害Enemy
		return
	var area_parent = area.get_parent();
	if area_parent is Enemy:
		# Apply knock back force to enemy
		var enemy = area_parent as Enemy;
		enemy.entity_data.take_damage(entity_data.attack, entity_data);
		enemy.linear_velocity.x = max(0, enemy.linear_velocity.x);
		enemy.linear_velocity.y = max(0, enemy.linear_velocity.y);
		enemy.linear_velocity += entity_data.knockback_velocity;
		_disapearing = true;
		sprite_2d.visible = false;
		sword_fly_particle.emitting = false;
		disapear_timer.start();
