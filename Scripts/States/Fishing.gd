class_name FishingState
extends State

const STATUS_LABEL = preload("uid://h4oue6vyv86b")

@export var sprite_renderer : Sprite2D

@export var fishing_sprite : Texture

@export var evil_karp : PackedScene

@export var evil_karp_targeting : TargetSystem

@export var health_karp_targeting : TargetSystem

var default_sprite : Texture

@export var fishing_time : int
@export var fishing_deviation : float
var fishing_value : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_sprite = sprite_renderer.texture
	
func _enter_state() -> void:
	fishing_time + (((randf() * 2) - 1) * fishing_deviation)
	sprite_renderer.texture = fishing_sprite

func _exit_state() -> void:
	sprite_renderer.texture = default_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _state_update(delta: float) -> void:
	if GameStateManager.current_state != GameStateManager.GAMESTATE.BATTLE:
		return
		
	health_karp_targeting.get_new_target()
	evil_karp_targeting.get_new_target()
	
	fishing_value -= delta
	
	if fishing_value <= 0:
		spawn_fish()
		fishing_value = fishing_time + (((randf() * 2) - 1) * fishing_deviation)

func spawn_fish():
	match randi_range(0, 3):
		0:
			var projectile_instance = evil_karp.instantiate()
			
			projectile_instance.targeting_system = evil_karp_targeting
			projectile_instance.global_position = unit.global_position
			projectile_instance.source_unit = unit
			
			get_tree().current_scene.add_child(projectile_instance)
			
			do_label("[color=#ff00ff]Evil Fish")
		1:
			var target = health_karp_targeting.get_target()
			
			if not target:
				return
			
			target.heal(15, unit)
			
			do_label("[img=24]res://Assets/Fish/health-karp.png[/img][color=#0f0]Heal Fish")
		2:
			GameEvents.gold_karp_fished.emit(self)
			do_label("[img=24]res://Assets/Fish/gold-karp.png[/img][color=#FFCC00]Gold Karp")

func do_label(text : String):
	var label_instance = STATUS_LABEL.instantiate()
	get_tree().current_scene.add_child(label_instance)
	label_instance.global_position = unit.global_position
	label_instance.text = text
