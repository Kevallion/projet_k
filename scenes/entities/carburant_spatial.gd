extends SpatialStation

@export var carburantToGive := 50.0



func _on_interaction_area_interaction(body: Player) -> void:
	body.refill_gas()
