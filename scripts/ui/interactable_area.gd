@tool
## InteractableArea
##
## Zone d'interaction générique basée sur Area2D.
## Permet à un objet du jeu d'être interactif lorsque le joueur entre dans
## une zone donnée.
##
## Fonctionnalités :
## - détecter si le joueur est dans la zone d'interaction
## - afficher une indication visuelle (touche à presser)
## - déclencher une interaction lorsque le joueur appuie sur l'action
##
## Cette classe est pensée pour être héritée.
## La fonction `do_interaction()` doit être surchargée dans les classes enfants.


class_name InteractionArea
extends Area2D



## SIGNALS
## Signal émis lorsque l'état d'interaction change
## true  -> le joueur peut interagir
## false -> le joueur ne peut plus interagir
signal isInteracteChanged(bool)



## Rayon de la zone d'interaction
## Correspond à la taille du cercle de collision utilisé pour détecter
## si le joueur est dans la zone.
@export_range(0.0, 200.0) var collisionRange := 46.5 : set = set_collision_range

## Référence vers le composant visuel affichant la touche d'interaction
## (par exemple : "Press E")
@export var visualShowKey : VisualShowKey


## CollisionShape2D générée automatiquement pour la zone
## La taille dépend de collisionRange
@onready var colisionShape := _create_colisionShape_2d()

## Indique si le joueur est actuellement dans la zone d'interaction
var canInteract := false


## CRÉATION DE LA COLLISION
## Crée dynamiquement une CollisionShape2D avec une forme circulaire
## utilisée pour la détection d'interaction.
func _create_colisionShape_2d() -> CollisionShape2D:
	var collisionShape := CollisionShape2D.new()
	collisionShape.shape = CircleShape2D.new()
	collisionShape.shape.radius = collisionRange
	return collisionShape


## Met à jour dynamiquement le rayon de la collision lorsque la valeur
## change dans l'inspecteur.
func set_collision_range(new_value) -> void:
	collisionRange = new_value
	
	if colisionShape:
		colisionShape.shape.radius = new_value


func _ready() -> void:
	
	## Ajoute la collision à la scène
	add_child(colisionShape)

	## Connexion des signaux pour détecter l'entrée/sortie dans la zone
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)



## INTERACTION
## Tente d'exécuter une interaction.
## L'interaction ne se produit que si le joueur est dans la zone.
func try_interact() -> void:
	
	if canInteract:
		
		## animation visuelle du bouton pressé
		if visualShowKey:
			visualShowKey.play_animation_pressed()
		
		do_interaction()


## Fonction appelée lors d'une interaction réussie.
## Doit être surchargée par les classes qui héritent de InteractableArea.
##
## Exemple :
## - collecter une ressource
## - ouvrir une porte
## - afficher une information
func do_interaction() -> void:
	pass



## DÉTECTION DE PRÉSENCE DANS LA ZONE
## Appelé lorsqu'un body entre dans la zone
func _on_body_entered(body) -> void:
	
	print("true")

	canInteract = true
	
	## notifier les autres systèmes
	isInteracteChanged.emit(canInteract)

	## afficher l'indication visuelle d'interaction
	if visualShowKey:
		visualShowKey.show_key()


## Appelé lorsqu'un body quitte la zone
func _on_body_exited(body) -> void:
	
	canInteract = false
	
	## notifier les autres systèmes
	isInteracteChanged.emit(canInteract)

	## cacher l'indication visuelle
	if visualShowKey:
		visualShowKey.hide_key()



## Gestion de l'input global pour déclencher l'interaction
func _unhandled_input(event: InputEvent) -> void:
	
	## touche d'action pressée
	if event.is_action_pressed("action"):
		try_interact()
	
	## touche relâchée
	elif event.is_action_released("action"):
		visualShowKey.show_key()
