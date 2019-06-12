extends "res://src/Player/SkillsHFSM/Skill.gd"


const HOOK_MAX_SPEED: = 1600.0

var target_global_position: = Vector2(INF, INF)
var velocity: = Vector2.ZERO


func physics_process(delta: float) -> void:
	var to_target: = target_global_position - _player.global_position
	var distance: = to_target.length()
	
	velocity = Steering.arrive_to(velocity, _player.global_position, target_global_position, HOOK_MAX_SPEED)
	velocity = _player.move_and_slide(velocity, _player.FLOOR_NORMAL)
	if distance < velocity.length() * delta:
		# Dampen the character's velocity upon reaching the target so it doesn't go flying way above the hook
		# The transition is harsh right now, the arrival behavior may be better
		velocity = velocity.normalized() * 400.0
		_player.transition_to("Move/Air", {velocity = velocity})


func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v


func exit() -> void:
	target_global_position = Vector2(INF, INF)
	velocity = Vector2.ZERO