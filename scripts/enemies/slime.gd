extends CharacterBody2D

@export var speed: int = 30

@onready var tree := $AnimationTree
@onready var nav_agent := $NavigationAgent2D
@onready var area: Area2D = $ChaseDetection

var in_area: Dictionary[Node2D, int]	
signal enemy_reached

func detect_enemy() -> void:
	if len(in_area) == 0:
		return
	
	var closest: Node2D
	var dist: float = -1
	for i in in_area.keys():
		var target_pos = to_local(i.position)
		if position.distance_to(target_pos) > dist:
			closest = i
			dist = position.distance_to(target_pos)
	
	var target_pos = to_local(closest.position)
	if position.distance_to(target_pos) > 5:
		nav_agent.target_position = target_pos 
	else:
		enemy_reached.emit()

func move_towards_enemy() -> void:
	var target = nav_agent.get_next_path_position()
	var dir = to_local(target).normalized()
	
	nav_agent.set_velocity(dir * speed)

func _physics_process(delta: float) -> void:
	detect_enemy()
	move_towards_enemy()
	
	tree.set("parameters/moving/blend_position", velocity.normalized().x)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var player_signal = globals.player_clicked_on_this
	
	if event.is_action_pressed("right_click"):
		player_signal.emit(self)

func _on_chase_detection_body_entered(body: Node2D) -> void:
	in_area[body] = 0

func _on_chase_detection_body_exited(body: Node2D) -> void:
	in_area.erase(body)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
