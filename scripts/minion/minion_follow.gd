class_name  MinionFollow
extends CharacterBody2D

@export var speed: int = 75
@export var og_dist: int = 40
@onready var root = globals.root
@onready var target: Node2D = root.get_node("Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var rng = globals.rng
var min_distance: int = og_dist 



func _ready() -> void:
	var nav_map = root.get_node("NavMap").get_navigation_map()
	nav_agent.set_navigation_map(nav_map)

func _physics_process(delta: float) -> void:
	
	var dest = nav_agent.get_next_path_position()
	
	if dest.distance_to(self.global_position) < 5:
		velocity *= 0
		return
		
	var dir = to_local(dest).normalized()
	var new_velocity = dir * speed
	
	nav_agent.set_velocity(new_velocity)

func makepath() -> void:
	if not is_instance_valid(target):
		target = root.get_node("Player")
		min_distance = og_dist
	
	var dir = self.global_position.direction_to(target.global_position)
	var dist = self.global_position.distance_to(target.global_position)
	
	if dist > min_distance:
		nav_agent.target_position = (target.global_position - dir * min_distance)
	elif dist <= min_distance:
		nav_agent.target_position = (self.global_position - (dir) * (min_distance - dist))
	else:
		nav_agent.target_position = self.global_position
	
func _on_timer_timeout() -> void:
	makepath()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
