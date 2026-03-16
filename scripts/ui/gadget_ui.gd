@tool
## UI représentant un slot de gadget.
## Affiche l'icône du gadget, son cooldown et la touche associée.
class_name GadgetUI extends PanelContainer

## Valeur interne utilisée pour l'animation du cooldown
var value: float

## Durée du cooldown (information locale si nécessaire)
var cooldown : float

## Barre de progression affichant le cooldown
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar

## Gadget actuellement lié à ce slot UI
var linkedGadget : Gadget

## Valeur maximale utilisée pour l'animation de la barre
var maxValue = 1000.0

## Index du slot dans le container UI
var slotIndex : int 

## Label affichant la touche associée au gadget
@onready var label: Label = %Label


## Texture affichée sous la barre (icône du gadget)
@export var texture_under : Texture2D : set = set_texture_under

## Met à jour la texture dans l'éditeur et en jeu
func set_texture_under(new_value) -> void:
	texture_under = new_value
	
	if texture_progress_bar:
		texture_progress_bar.texture_under = new_value


## Texture de progression par défaut
@export var texture_progress := preload("res://assets/sprites/icons/black_icon.png")


## Initialisation de l'UI
func _ready() -> void:
	
	# applique la texture configurée
	set_texture_under(texture_under)
	
	# si on est dans l'éditeur, on ne connecte pas les signaux gameplay
	if Engine.is_editor_hint():
		return
	
	# récupère la texture existante si elle est déjà configurée
	if texture_progress_bar.texture_under:
		texture_under = texture_progress_bar.texture_under
	
	# connexion au signal envoyé par le GadgetManager
	GameSignals.gadgetAssigned.connect(_on_gadget_assigned)
	
	# index du slot dans l'UI
	slotIndex = get_index()
	
	# configuration de la barre de cooldown
	texture_progress_bar.value = 0.0
	texture_progress_bar.max_value = maxValue


## Lance l'animation du cooldown dans l'UI
func use_ability() -> void:
	
	var tween := create_tween()
	
	# remplit la barre pendant la durée du cooldown
	tween.tween_property(texture_progress_bar, "value", maxValue, linkedGadget.cooldown)
	
	# reset de la barre une fois l'animation terminée
	tween.finished.connect(func() -> void:
		texture_progress_bar.value = 0.0
	)


## Associe un gadget à ce slot UI
func setup(gadget: Gadget) -> void:
	
	linkedGadget = gadget
	
	# affiche l'icône du gadget
	texture_progress_bar.texture_under = gadget.icon
	
	# déclenche l'animation lorsque le gadget est utilisé
	gadget.used.connect(use_ability)


## Réagit lorsque le manager assigne un gadget à un slot
func _on_gadget_assigned(index: int, gadget: Gadget, key: String) -> void:
	
	# vérifie si le gadget correspond à ce slot
	if index == slotIndex:
		setup(gadget)
		
		# affiche la touche associée dans l'UI
		label.text = key
