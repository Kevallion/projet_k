class_name SpaceObject extends CharacterBody2D

##plus la mass augmente plus les forces exterieus qui s'applique sont réduite.
@export var mass := 1.0
@export var bounciness := 0.5
@export var force_drag := 5.0

#force qui peuvent s'appliquer sur l'objet
var external_force : Vector2

func _physics_process(delta: float) -> void:
	external_force = external_force.lerp(Vector2.ZERO, force_drag * delta)

#focntion pour calculer la force qui s'applique à l'objet en fonction de sa mass
func add_force(force: Vector2) -> void:
	external_force = force / mass
