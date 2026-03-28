extends StaticBody2D

@onready var dialogNode = %DialogNode
var shield_compo_crafted = false

func spawn_converter(_body)-> bool:
	if !shield_compo_crafted and _body.has_method("find_and_delete"):
		if _body.find_and_delete("fragment", 10):
			$ShieldCompoBody2.visible = true
			$ShieldCompoBody2.collectable()
			shield_compo_crafted = true
			return true
	return false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		## refill de gas pour 10 débris ##
		#if shield_compo_crafted and body.has_method("find_and_delete"):
			#if body.find_and_delete("fragment", 10):
				#body.refill_gas(1000)
		if dialogNode.actId == 4:
			dialogNode.open_current_dialog()
			dialogNode.finish_act()
		if dialogNode.actId == 5:
			if spawn_converter(body):
				dialogNode.open_current_dialog()
				body.refill_gas(1000)
				dialogNode.finish_act()
		
