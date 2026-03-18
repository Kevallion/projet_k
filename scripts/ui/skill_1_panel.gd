extends Panel
@onready var descriptionLabel =  %GadgetDescription
var crafted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	descriptionLabel.text = "Le bouclier protège des chocs \net des zones de radioactivité"
	if !crafted:
		descriptionLabel.text += "\n\nNecessite :\n- Truc\n- Machin\n- Bidule\nPour être fabriqué"
		
	

func _on_mouse_exited() -> void:
	descriptionLabel.text = ""
