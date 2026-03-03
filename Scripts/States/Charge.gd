class_name Charge
extends State

@export var target_system : TargetSystem
@export var move_speed : float
@export var sprite_renderer : Sprite2D

const AFTER_IMAGE_PARTICLES = preload("uid://dh3vpxv1wlets")
var instantiated_particle_system : GPUParticles2D

func _ready() -> void:
	instantiated_particle_system = AFTER_IMAGE_PARTICLES.instantiate()
	get_tree().current_scene.add_child(instantiated_particle_system)
	instantiated_particle_system.position = Vector2(0, 0)
	instantiated_particle_system.texture = sprite_renderer.texture
	
	instantiated_particle_system.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _state_update(delta: float) -> void:
	if target_system.get_target():
		var speed = delta * move_speed
		
		unit.global_position = unit.global_position.move_toward(target_system.get_target().global_position, speed)

func _enter_state() -> void:
	instantiated_particle_system.emitting = true

func _exit_state() -> void:
	instantiated_particle_system.emitting = false

func _process(delta: float) -> void:
	instantiated_particle_system.global_position = unit.global_position
