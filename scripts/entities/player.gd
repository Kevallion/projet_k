extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var forward = $AnimatedSprite2D/Direction
@onready var camera =  $Camera2D
@onready var reactorCenterSprite = $AnimatedSprite2D/ReactorCenterSprite
@onready var reactorLeftSprite = $AnimatedSprite2D/ReactorLeftSprite
@onready var reactorRightSprite = $AnimatedSprite2D/ReactorRightSprite
@onready var reactorFrontLeftSprite = $AnimatedSprite2D/ReactorFrontLeftSprite
@onready var reactorFrontRightSprite = $AnimatedSprite2D/ReactorFrontRightSprite
@onready var outOfBound = $OutOfBound

var gas = 1000.0;
var maxGas = 1000.0;
var gasExpense = 1;

var speed = 1
var rotationForce = 0.01
var rotationDirection = 0
var leftReactorActif = false
var centerReactorActif = false
var rightReactorActif = false

var respawnPosition = Vector2.ZERO
var orientation

func _physics_process(_delta: float) -> void:
	basic_mouvements()
	move_and_slide()
	
func basic_mouvements():
	## Vecteur de direction en face du Player
	var forward_vector = forward.global_position - global_position
	var normalized_vector = forward_vector.normalized()
		
	## Appuyer pour avancer
	leftReactorActif = Input.is_action_pressed("ui_left")
	rightReactorActif = Input.is_action_pressed("ui_right")
	centerReactorActif = Input.is_action_pressed("ui_up")
	
	## Facteur de puissance. + 1 par moteur actif
	var reactorPower = 0
	## définition du facteur de rotation, de la vitesse et de la dépense de carburant
	if leftReactorActif:
		rotationDirection -= 0.1
		reactorPower += speed
		reactorRightSprite.visible = true
		reactorFrontLeftSprite.visible = true
		consume_gas(gasExpense)
	else:
		reactorRightSprite.visible = false
		reactorFrontLeftSprite.visible = false
	if rightReactorActif:
		rotationDirection += 0.1
		reactorPower += speed
		reactorLeftSprite.visible = true
		reactorFrontRightSprite.visible = true
		consume_gas(gasExpense)
	else:
		reactorLeftSprite.visible = false
		reactorFrontRightSprite.visible = false
	if centerReactorActif:
		reactorPower += speed
		reactorCenterSprite.visible = true
		consume_gas(gasExpense)
	else:
		reactorCenterSprite.visible = false
	if rightReactorActif and leftReactorActif:
		reactorLeftSprite.visible = true
		reactorRightSprite.visible = true
		reactorCenterSprite.visible = true
		reactorFrontLeftSprite.visible = false
		reactorFrontRightSprite.visible = false
		consume_gas(gasExpense)
	
	## Frein / Stabilisateur ##
	if Input.is_action_pressed("ui_down"):
		# Désactive tous les moteurs
		leftReactorActif = false
		centerReactorActif = false
		rightReactorActif = false
		# afficher les sprites
		reactorFrontLeftSprite.visible = true
		reactorFrontRightSprite.visible = true
		reactorRightSprite.visible = true
		reactorLeftSprite.visible = true
		# Stabilisation #
		rotationDirection *= 0.9
		reactorPower = 0
		velocity *= 0.9
		consume_gas(gasExpense)

	# Applique la rotation
	sprite.rotate(rotationForce * rotationDirection)
	# Applique la vélocité
	velocity += normalized_vector * reactorPower
	
func consume_gas(spent):
	gas -= spent
	
func death():
	position = respawnPosition
	sprite.rotation = orientation
	velocity = Vector2.ZERO
	rotationDirection = 0

func _on_out_of_bound_timeout() -> void:
	death()
