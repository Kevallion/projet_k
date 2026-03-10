@tool
## cette classe à pour but de permettre de faire des interaction avec l'input_event
## pour collecter des donnée dans l'espace
## collecter ressource si le joueur est dans la zone
## lancer une bulle d'infos au besoin

class_name InteractableArea  extends Area2D

##signal emis si la possibilité d'interaction change
signal isInteracteChanged(bool)

##la shape de colision de l'asterpod
@export_range(0.0,200.0) var collisionRange := 46.5 : set = set_collision_range

##veiller à bien definir la taille de collision en fonctin [br]
##de la taille du sprite
@onready var colisionShape := _create_colisionShape_2d()

var canInteract := false

func _create_colisionShape_2d() -> CollisionShape2D:
	var collisionShape := CollisionShape2D.new()
	collisionShape.shape = CircleShape2D.new()
	collisionShape.shape.radius = collisionRange
	return collisionShape

	
func set_collision_range(new_value) -> void:
	collisionRange = new_value
	if colisionShape:
		colisionShape.shape.radius = new_value
		
func _ready() -> void:
	add_child(colisionShape)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func try_interact() -> void:
	if canInteract:
		do_interaction()

func do_interaction() -> void:
	pass
	
func _on_body_entered(body) -> void:
	canInteract = true
	isInteracteChanged.emit(canInteract)
	
func _on_body_exited(body) -> void:
	canInteract = false
	isInteracteChanged.emit(canInteract)
	
