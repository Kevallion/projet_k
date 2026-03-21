extends Panel
@onready var button = %ShieldButton
var crafted = false

var tooltip_scene := preload("res://scenes/ui/skills_tooltip.tscn")
var tooltip: SkillsTooltip

func _ready() -> void:
	button.disabled = true

func _on_texture_button_mouse_entered() -> void:
	var title = "Bouclier"
	var description = "Le bouclier protège des chocs \net des zones de radioactivité"
	if !crafted:
		title += " (Verrouillé)"
		description += "\n\nFabrication :\n- Générateur\n- Convertisseur d'energie"
		
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("Interface").get_node("CanvasLayer").add_child(tooltip)
	tooltip.set_options(title, description)
	tooltip.global_position = get_global_mouse_position()+Vector2(10,200)
		
func _on_texture_button_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
