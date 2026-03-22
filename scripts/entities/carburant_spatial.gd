extends SpatialStation
@onready var dialogNode = %DialogNode
var firstInteract = true
#@export var carburantToGive := 50.0

func _on_interaction_area_interaction(body: Player) -> void:
	body.refill_gas()
	if firstInteract:
		dialogNode.open_dialog(1, 1)
		firstInteract = false
