extends StaticBody2D

@onready var dialogNode = %DialogNode

func spawn_converter():
	$ShieldCompoBody2.visible = true
	$ShieldCompoBody2.set_collision_mask_value(1, true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if dialogNode.actId == 5:
		if body.find_and_delete("fragment", 10):
			body.inventory.remove("fragment", 10)
			dialogNode.open_dialog(dialogNode.actId, dialogNode.chapterId)
			spawn_converter()
			dialogNode.actId = 6
		dialogNode.chapterId = -1
	if dialogNode.actId == 4:
		dialogNode.open_dialog(dialogNode.actId, dialogNode.chapterId)
		dialogNode.actId = 5
		dialogNode.chapterId = -1
