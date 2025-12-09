extends Node
signal player_clicked_on_this(target: CharacterBody2D)


@onready var root: Node2D = get_tree().get_root().get_node("Node2D")
var minion_count: int = 0
var rng = RandomNumberGenerator.new()
