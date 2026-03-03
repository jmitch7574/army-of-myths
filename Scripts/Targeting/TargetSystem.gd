class_name TargetSystem
extends Node2D

@export var parent : Unit
var current_target : Unit = null

func _process(delta: float) -> void:
	if (current_target):
		if (current_target.global_position.x < global_position.x):
			parent.scale.x = -abs(parent.scale.x)
		else:
			parent.scale.x = abs(parent.scale.x)

func get_target() -> Unit:
	if current_target == null or current_target.health <= 0:
		get_new_target()
		
	return current_target

func find_target() -> Unit:
	return null

func get_new_target():
	current_target = find_target()
