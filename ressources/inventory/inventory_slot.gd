extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Sprite2D2
@onready var amount_text: Label = $CenterContainer/Panel/Label
var item_title
var item_description

var tooltip_scene := preload("res://scenes/ui/skills_tooltip.tscn")
var tooltip: SkillsTooltip
func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		item_title = slot.item.name
		item_description = slot.item.description
		if slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(slot.amount)
		else:
			amount_text.visible = false

func _on_mouse_entered() -> void:
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("Interface").get_node("CanvasLayer").add_child(tooltip)
	if item_title:
		tooltip.set_options(item_title, item_description)
	tooltip.global_position = get_global_mouse_position()+Vector2(10,200)

func _on_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
