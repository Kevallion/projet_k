extends StaticBody2D

@onready var dialogNode = %DialogNode
var shield_compo_crafted = false

func spawn_converter():
	$ShieldCompoBody2.visible = true
	$ShieldCompoBody2.collectable()
	shield_compo_crafted = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if dialogNode.actId == 4:
		dialogNode.open_dialog(dialogNode.actId, dialogNode.chapterId)
		dialogNode.finish_act()
		
	if !shield_compo_crafted and body.has_method("find_and_delete"):
		if body.find_and_delete("fragment", 10):
			spawn_converter()
			body.refill_gas(1000)
	if dialogNode.actId == 5:
		dialogNode.open_dialog(dialogNode.actId, dialogNode.chapterId)
		body.refill_gas(1000)
		dialogNode.finish_act()
