extends Node2D

@export var minion: PackedScene
@onready var player: CharacterBody2D = get_parent()
@onready var root = globals.root
@onready var marker: PackedScene = preload("res://instances/marker.tscn")

var minions: Array[CharacterBody2D]
var selected_minion: int = 0
var rng = globals.rng
var _temp_targets: Array[Node2D]
var enemy_clicked_sig = globals.player_clicked_on_this

func _ready() -> void:
	enemy_clicked_sig.connect(target_enemy)

func spawn_minion():
	var m = minion.instantiate()
	m.position = player.global_position + Vector2(rng.randi_range(-16, 16), rng.randi_range(-16, 16))
	root.add_child(m)
	minions.append(m)

func command_minion():
	var mouse_pos = get_global_mouse_position()
	_update_minion_target_single(_spawn_marker(mouse_pos))
		

func command_all_minions():
	var mouse_pos = get_global_mouse_position()
	_update_minion_target_all(_spawn_marker(mouse_pos))
	
func recall_minion():
	_update_minion_target_all(player)
	_clear_temp_targets()
	
func target_enemy(enemy: CharacterBody2D):
	var mouse_pos = get_global_mouse_position()
	_spawn_marker(mouse_pos)
	_update_minion_target_single(enemy)

func _clear_temp_targets():
	if len(_temp_targets) != 0:
		for i in _temp_targets:
			i.queue_free()
		_temp_targets.clear()

func _update_minion_target_all(target: Node2D):
	for i in minions:
		var script = i as MinionFollow
		var min_distance: int
		
		# We offset from player or enemy, but not marker
		if target == player:
			min_distance = script.og_dist
		else:
			min_distance = 0
		
		script.target = target
		script.min_distance = min_distance
		script.attacking = false

func _update_minion_target_single(target: Node2D):
	if len(minions) <= 0:
		return
	
	var script = minions[selected_minion] as MinionFollow
	var min_distance: int
	
	# We offset from player or enemy, but not marker
	if target == player:
		min_distance = script.og_dist
	else:
		min_distance = 0
	
	script.target = target
	script.min_distance = min_distance
	script.attacking = false
	selected_minion = (selected_minion + 1) % len(minions)

func _spawn_marker(mouse_pos: Vector2) -> AnimatedSprite2D:
	var _temp_target = marker.instantiate() as AnimatedSprite2D
	_temp_target.position = _temp_target.to_local(mouse_pos)
	root.get_node("MarkerSpot").add_child(_temp_target)
	_temp_target.play_backwards()
	_temp_targets.append(_temp_target)
	return _temp_target

func _physics_process(delta: float) -> void:
	globals.minion_count = len(minions)
	# Spawn minion code
	if Input.is_action_just_pressed("summon"):
		spawn_minion()
	
	if Input.is_action_just_pressed("click"):
		command_all_minions()
		
	if Input.is_action_just_pressed("recall"):
		recall_minion()
