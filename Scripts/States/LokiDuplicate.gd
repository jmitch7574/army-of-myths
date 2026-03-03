extends State

const LOKI_PROJECTILE_PARTICLES_HIT = preload("uid://levqg6qlcxh6")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_state() -> void:
	if unit.is_loki_clone: 
		self_end_state()
		return
	
	var new_node = unit.unit_resource.unit_scene.instantiate()
	get_tree().current_scene.add_child(new_node)
	new_node.is_loki_clone = true
	new_node.health = 1
	new_node.max_health = 1
	
	await get_tree().process_frame
	
	var instantiated_particles = LOKI_PROJECTILE_PARTICLES_HIT.instantiate()
	get_tree().current_scene.add_child(instantiated_particles)
	instantiated_particles.global_position = new_node.global_position
	
	self_end_state()
