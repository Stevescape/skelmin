class_name Attack
extends Node2D

@export var attack_damage: int

@onready var slime: Slime = get_parent()
@onready var tree: AnimationTree = slime.get_node("AnimationTree")
@onready var sprite: Sprite2D = slime.get_node("Sprite2D")
@onready var attack_signal = slime.enemy_reached
signal attack_frame_reached
var attack_frame = 20

func attack(health_comp: HealthComponent):
	pass

func jump_attack() -> void:
	tree.set("parameters/AnimationNodeStateMachine/conditions/attacking", true)
	$hit_area.show()
	await attack_frame_reached
	
	$hit_area.hide()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_signal.connect(jump_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite.frame == 20:
		attack_frame_reached.emit()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
