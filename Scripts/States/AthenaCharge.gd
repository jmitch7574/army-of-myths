extends Charge

var current_target : Unit = null

func _enter_state() -> void:
	super()
	if is_instance_valid(current_target):
		current_target.effects.erase(Unit.EFFECTS.ATHENA_PROTECT)

func _state_update(delta: float) -> void:
	target_system.get_new_target()
	super(delta)
	
	if (target_system.get_target().global_position.distance_to(unit.global_position) < 32):
		current_target = target_system.get_target()
		current_target.effects.append(Unit.EFFECTS.ATHENA_PROTECT)
		print("Athena Shielding %s" % current_target.name)
		self_end_state()
