extends Node
class_name InjuredEffect
@onready var animation_timer: Timer = $"Animation Timer"

@export var target: Node2D;

const max_effect_rate = 0.5;
const effect_lasts_time = 0.15;

var original_target_self_modulate: Color = Color.WHITE;

func _ready() -> void:
	if !target:
		target = self.get_node("..");
	original_target_self_modulate = target.self_modulate;
	animation_timer.wait_time = effect_lasts_time;

func calculate_animation_process() -> float:
	return 1 - animation_timer.time_left / animation_timer.wait_time;

func display_effect() -> void:
	if !animation_timer.is_stopped():
		return ;
	target.self_modulate = lerp(original_target_self_modulate, Color.FIREBRICK, min(max_effect_rate, calculate_animation_process()));
	animation_timer.start();

func _on_animation_timer_timeout() -> void:
	target.self_modulate = original_target_self_modulate;
