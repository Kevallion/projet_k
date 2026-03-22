extends Panel
@onready var button = %TractorButton
var crafted = false

var tooltip_scene := preload("res://scenes/ui/skills_tooltip.tscn")
var tooltip: SkillsTooltip

func _ready() -> void:
	button.disabled = true

func _on_tractor_button_mouse_entered() -> void:
	var title = "Rayon Tracteur"
	var description = "Un gagdget qui vous permet de vous tracter vers un objet de l'espace ou de tracter l'élément vers vous. appuyé sur espace pour changer le mode"
	if !crafted:
		title += " (Verrouillé)"
		description += "\n\nFabrication :\n- Canon à Ion\n- Aimant supraconducteur"
		
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("Interface").get_node("CanvasLayer").add_child(tooltip)
	tooltip.set_options(title, description)
	tooltip.global_position = get_global_mouse_position()+Vector2(10,200)
	
func _on_tractor_button_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
