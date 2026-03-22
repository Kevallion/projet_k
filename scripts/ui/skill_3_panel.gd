extends Panel
@onready var button = %PortalButton
var crafted = false

var tooltip_scene := preload("res://scenes/ui/skills_tooltip.tscn")
var tooltip: SkillsTooltip

func _ready() -> void:
	button.disabled = true

func _on_portal_button_mouse_entered() -> void:
	var title = "Portal"
	var description = "Ce gadget permet de poser des portails, pour placer un portails appuyer sur espace, puis viser la zone du deuxieme portail."
	if !crafted:
		title += " (Verrouillé)"
		description += "\n\nFabrication :\n- Canon à particule\n- Découpeur cosmique"
		
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("Interface").get_node("CanvasLayer").add_child(tooltip)
	tooltip.set_options(title, description)
	tooltip.global_position = get_global_mouse_position()+Vector2(10,200)

func _on_portal_button_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
