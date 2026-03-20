class_name SpatialStation extends SpaceObject

@onready var interaction_area: InteractionArea = %InteractionArea
@export var carburantToGive := 50.0



func _on_interaction_area_interaction(body: Player) -> void:
	body.refill_gas()
