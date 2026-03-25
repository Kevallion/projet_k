extends SpatialStation
@onready var dialogNode = %DialogNode
@onready var player = $"../Player"
var isDiscovered = false

func _on_interaction_area_interaction(body: Player) -> void:
	isDiscovered = true
	body.refill_gas(body.maxGas)
	#body.recharge_energy()
	if dialogNode.actId == 1:
		dialogNode.open_dialog(1, 1)
		dialogNode.finish_act()
	if dialogNode.actId == 3 and player.find_compo("shield_compo1", 1):
		dialogNode.open_dialog(3, 0)
		dialogNode.finish_act()
	if dialogNode.actId == 8 and player.find_compo("tractor_compo1", 1) :
		dialogNode.open_dialog(8, 0)
		dialogNode.finish_act()
