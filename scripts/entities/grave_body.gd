extends StaticBody2D

var inventory: Inv = preload("res://ressources/inventory/grave_inventory.tres")
var temp_inv

func _ready() -> void:
	temp_inv= inventory.duplicate(true)

func _physics_process(_delta: float) -> void:
	$Sprite2D.rotation += 0.05

func _on_interaction_area_interaction(body: Player) -> void:
	if body.has_method("collect"):
		for slot in temp_inv.slots:
			if slot.item:
				body.collect(slot.item, slot.amount)
		temp_inv.empty()
		queue_free()
