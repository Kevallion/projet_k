class_name SpaceObject extends CharacterBody2D

##plus la mass augmente plus les forces exterieus qui s'applique sont réduite.
@export var mass := 1.0
@export var bounciness := 0.5
@export var forceDrag := 5.0

##savoir si l'objet est en orbit autour d'un astre
var isOrbitAround := false

##l'objet autour duquel il doit touner en orbit
var orbitTarget : Node2D
##la vitesse de rotation en orbit
var orbitalSpeed := 0.0
##la  direction de la gravité de l'objet vers l'astre
var orbitalDirectionGravity : Vector2
##la direction à suivre par rapport à l'astre
var orbitalDirectionTengente : Vector2
##la force de gravité
var orbitalGravityStrength : float

#force qui peuvent s'appliquer sur l'objet
var externalForce : Vector2


func _physics_process(delta: float) -> void:
	#on réduit les force exterieur à zero 
	externalForce = externalForce.lerp(Vector2.ZERO, forceDrag * delta)
	
	#si un élément autour d'un astre
	if orbitTarget:
		orbitalDirectionGravity = global_position.direction_to(orbitTarget.global_position)
		velocity += orbitalDirectionGravity * orbitalGravityStrength * delta
		
	#aplique toujours les force exterieur
	velocity += externalForce * delta
	move_and_slide()
	
## focntion pour calculer la force qui s'applique à l'objet en fonction de sa mass
func add_force(force: Vector2) -> void:
	externalForce = force / mass

## fonction pour qu'un objet tourne autour d'un autre objet
func orbitAround(target: Node2D, speed: float, gravityStrength: float) -> void:
	isOrbitAround = true
	orbitTarget = target
	orbitalSpeed = speed
	orbitalGravityStrength = gravityStrength
	orbitalDirectionGravity = global_position.direction_to(orbitTarget.global_position)
	orbitalDirectionTengente =  orbitalDirectionGravity.rotated(PI/2).normalized()
	velocity += orbitalDirectionTengente * speed
