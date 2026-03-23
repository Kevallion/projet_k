extends SpatialStation
@onready var dialogNode = %DialogNode
var firstInteract = true

func _on_interaction_area_interaction(body: Player) -> void:
	body.refill_gas()
	body.recharge_energy()
	if firstInteract:
		dialogNode.open_dialog(1, 1)
		dialogNode.actId = 2
		dialogNode.chapterId = 0
		firstInteract = false
	if dialogNode.actId == 3:
		dialogNode.open_dialog(3, 0)
		dialogNode.actId = 4
		dialogNode.chapterId = 0
