extends Node

@onready var root: Node2D = globals.root
@onready var minion: MinionFollow = get_parent()
@export var attack_damage: int = 1

@onready var attacking: bool = minion.attacking
var bodies: Dictionary[Node2D, int]
var closest: Node2D
var dist: float = -1

func _on_attack_timer_timeout() -> void:
	print(bodies)
	print(closest)
	var target = closest
	if not is_instance_valid(target):
		target = null
		return 
	
	if target == null:
		return
	
	# Find health component and attack
	
	var health_comp = target.get_node("HealthComponent") as HealthComponent
	if health_comp == null:
		return
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	health_comp.take_damage(attack)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemy"):
		return
	bodies[body] = 0
	
	var target = body
	
	if dist == -1 or minion.position.distance_to(target.position) < dist:
		closest = target
		dist = minion.position.distance_to(target.position)
		attacking = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body.is_in_group("enemy"):
		return
	
	bodies.erase(body)
	if closest == body:
		closest = null
		dist = -1
		attacking = true
