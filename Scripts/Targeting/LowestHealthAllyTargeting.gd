extends TargetSystem


func find_target() -> Unit:
	var lowest_unit = null
	var highest_diff = 0
	
	for node in get_tree().get_nodes_in_group("Units"):
		var target_node := node as Unit
		if target_node:
			if (target_node.max_health - target_node.health) >= highest_diff and target_node.player_owner == parent.player_owner:
				lowest_unit = target_node
				highest_diff = target_node.max_health - target_node.health
	
	return lowest_unit
