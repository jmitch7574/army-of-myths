class_name ClosestTarget
extends TargetSystem

## Get Closest Target
func find_target() -> Unit:
	var closest_unit: Unit = null
	var closest_distance: float = INF
	
	for unit in get_tree().get_nodes_in_group("Units"):
		if unit is Unit:
			if unit == get_parent() or unit.player_owner == parent.player_owner or unit.health <= 0:
				continue
			var distance = global_position.distance_to(unit.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_unit = unit

	return closest_unit
