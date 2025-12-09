class_name HealthComponent
extends Node2D

@export var max_health: int

var current_hp: float
signal health_updated(current_hp: int)

func take_damage(attack: Attack) -> void:
	current_hp -= attack.attack_damage
	health_updated.emit(current_hp)
	
	if current_hp <= 0:
		get_parent().queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
