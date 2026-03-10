class_name Player extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var forward = $AnimatedSprite2D/Direction
@onready var camera =  $Camera2D
@onready var reactorCenterSprite = $AnimatedSprite2D/ReactorCenterSprite
@onready var reactorLeftSprite = $AnimatedSprite2D/ReactorLeftSprite
@onready var reactorRightSprite = $AnimatedSprite2D/ReactorRightSprite
@onready var reactorFrontLeftSprite = $AnimatedSprite2D/ReactorFrontLeftSprite
@onready var reactorFrontRightSprite = $AnimatedSprite2D/ReactorFrontRightSprite
@onready var outOfBound = $OutOfBound

@export_group("custom physique")
@export var mass := 1.0
@export var forceDrag := 5.0
var externalForce := Vector2.ZERO


## vitesse maximal du vaisseau
@export var maxSpeed := 300.0

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
var respawnRotation
var holdingTime = 0

func _physics_process(_delta: float) -> void:
	#on réduit les forces externe
	externalForce = externalForce.lerp(Vector2.ZERO, forceDrag * _delta)
	basic_mouvements()
	velocity += externalForce * _delta
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
	## Facteur de rotation
	rotationForce = 0.01
	
	## définition du facteur de rotation, de la vitesse et de la dépense de carburant
	if leftReactorActif:
		rotationDirection -= 0.1
		reactorPower += speed
		consume_gas(gasExpense)
	if rightReactorActif:
		rotationDirection += 0.1
		reactorPower += speed
		consume_gas(gasExpense)
	# Affichage des sprite
	reactorRightSprite.visible = leftReactorActif
	reactorFrontLeftSprite.visible = leftReactorActif
	reactorLeftSprite.visible = rightReactorActif
	reactorFrontRightSprite.visible = rightReactorActif
	
	### Frein / Stabilisateur ##
	if Input.is_action_pressed("ui_down"):
		## Permet de se retourner plus rapidement
		if leftReactorActif or rightReactorActif:
			rotationForce = 0.03
		# afficher les sprites
		reactorFrontLeftSprite.visible = true
		reactorFrontRightSprite.visible = true
		if !rightReactorActif:
			reactorRightSprite.visible = true
		if !leftReactorActif:
			reactorLeftSprite.visible = true
		rightReactorActif = false
		leftReactorActif = false
		# Stabilisation #
		rotationDirection *= 0.9
		reactorPower = 0
		velocity *= 0.9
		consume_gas(gasExpense)
	
	if Input.is_action_just_pressed("ui_up"):
		holdingTime = 0
	if centerReactorActif:
		holdingTime += 1
		reactorPower += speed
		if holdingTime > 75:
			reactorPower += speed * 2
			reactorLeftSprite.visible = true
			reactorRightSprite.visible = true
		reactorCenterSprite.visible = true
		consume_gas(gasExpense)
	else:
		reactorCenterSprite.visible = false
	
	if rightReactorActif and leftReactorActif:
		reactorCenterSprite.visible = true
		reactorFrontLeftSprite.visible = false
		reactorFrontRightSprite.visible = false
		
	# Applique la rotation
	sprite.rotate(rotationForce * rotationDirection)
	# Applique la vélocité
	velocity += normalized_vector * reactorPower
	
	##clamp la vitesse maximal
	velocity.x = clampf(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clampf(velocity.y, -maxSpeed, maxSpeed)



func add_force(force: Vector2) -> void:
	externalForce = force / mass

func consume_gas(spent):
	gas -= spent
	
func death():
	position = respawnPosition
	sprite.rotation = respawnRotation
	velocity = Vector2.ZERO
	rotationDirection = 0
	externalForce = Vector2.ZERO
	
func _on_out_of_bound_timeout() -> void:
	death()
