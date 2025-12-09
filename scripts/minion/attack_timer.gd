extends Node

@onready var root: Node2D = globals.root
@onready var minion: MinionFollow = get_parent()
@export var attack_damage: int = 1

var bodies: Dictionary[Node2D, int]
func _on_attack_timer_timeout() -> void:
	for target in bodies.keys():
		if not target.is_in_group("enemy"):
			continue
		
		# Find health component and attack
		var health_comp = target.get_node("HealthComponent") as HealthComponent
		if health_comp == null:
			return
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		health_comp.take_damage(attack)


func _on_area_2d_body_entered(body: Node2D) -> void:
	bodies[body] = 0

func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies.erase(body)
