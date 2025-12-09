extends ProgressBar

@onready var hp: HealthComponent = get_parent().get_node("HealthComponent")
@onready var hp_updated = hp.health_updated

func _ready() -> void:
	max_value = hp.max_health
	hp_updated.connect(_update_hp_bar)
	
func _update_hp_bar(updated_hp: int) -> void:
	value = updated_hp

func _process(delta: float) -> void:
	if value < max_value:
		show()
	else:
		hide()
