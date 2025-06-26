extends Node2D
class_name ParticleExplosion
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func play_effect() -> void:
	cpu_particles_2d.emitting = true
