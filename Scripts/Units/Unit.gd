class_name Unit
extends Node2D

enum EFFECTS
{
	WEBBED,
	ATHENA_PROTECT
}

@export var unit_resource : UnitResource
@export var max_health : float
var health : float

var grid_coords

var is_loki_clone = false

@export var player_owner : PlayerStats.PLAYER

var audio_player : AudioStreamPlayer2D

var effects : Array[EFFECTS] = []

func _ready() -> void:
	audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	
	if player_owner == PlayerStats.PLAYER.PANDORA:
		max_health += GameStateManager.round * 2
	
	health = max_health
	GameEvents.buy_time_begin.connect(on_round_end)
	
	if (player_owner == PlayerStats.PLAYER.PANDORA):
		var valid_coord = false
		
		var coord = Vector2(0, 0)
		
		while not valid_coord:
			valid_coord = true
			coord = Vector2(randi_range(5, 9), randi_range(0, 6))
			for node in get_tree().get_nodes_in_group("Units"):
				if node is Unit:
					if node == self:
						continue
					if node.grid_coords == coord:
						valid_coord = false
		
		grid_coords = coord
		global_position = FocusManager.START_POSITION + (grid_coords * 102)
		
		return
	
	var taken_grid_coords : Array[Vector2] = []
	for node in get_tree().get_nodes_in_group("Units"):
		if node is Unit:
			if node == self:
				continue
			taken_grid_coords.append(node.grid_coords)
	
	
	for x in range(0, 4):
		for y in range(0, 7):
			var coord = Vector2(x, y) if player_owner == PlayerStats.PLAYER.ONE else Vector2(9 - x, y)
			
			if taken_grid_coords.has(coord):
				continue
			grid_coords = coord
			global_position = FocusManager.START_POSITION + (grid_coords * 102)
			return
	
	grid_coords = Vector2(0, 0)

func take_damage(damage : float, source : Unit) -> void:
	if effects.has(EFFECTS.ATHENA_PROTECT):
		damage *= 0.5
	
	health -= damage
	GameEvents.unit_health_changed.emit(self, source, -damage, health)
	
	if health <= 0:
		var reward = unit_resource.unit_cost if player_owner == PlayerStats.PLAYER.PANDORA else 0
		GameEvents.unit_killed.emit(self, source, reward)
	
	if player_owner == PlayerStats.PLAYER.PANDORA and health <= 0:
		queue_free()

func heal(amount : float, source : Unit) -> void:
	## Don't resurrect dead allies, lol
	if health <= 0:
		return

	health = min(health + amount, max_health)
	
	GameEvents.unit_health_changed.emit(self, source, amount, health)

func on_round_end() -> void:
	if player_owner == PlayerStats.PLAYER.PANDORA or is_loki_clone:
		queue_free()

	health = max_health
	global_position = FocusManager.START_POSITION + (grid_coords * 102)
	effects = []
