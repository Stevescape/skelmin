class_name HurtboxComponent
extends Node2D

@export var health_comp: HealthComponent

func damage(attack: Attack):
	if health_comp:
		health_comp.take_damage(attack)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
