extends TargetSystem

@export_range(0, 100, 1) var target_hp_percentage : int

func find_target() -> Unit:
	for node in get_tree().get_nodes_in_group("Units"):
		var target_node := node as Unit
		if target_node:
			if target_node.player_owner != parent.player_owner and (target_node.health / target_node.max_health) <= target_hp_percentage / 100.0:
				return target_node
	
	return null
