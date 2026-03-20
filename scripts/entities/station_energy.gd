extends SpatialStation

@export var EnergytToGive := 50.0


func _on_interaction_area_interaction(body: Player) -> void:
	body.energy += 50.0
