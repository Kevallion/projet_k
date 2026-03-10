extends CharacterBody2D

@onready var forward = $Direction
@onready var camera =  $Camera2D

var gas = 1000.0;
var maxGas = 1000.0;
var gasExpense = 1;

var speed = 1
var rotationForce = 0.01
var leftReactorActif = false
var centerReactorActif = false
var rightReactorActif = false

func _physics_process(_delta: float) -> void:
	basic_mouvements()
	move_and_slide()
	
func basic_mouvements():
	## Vecteur de direction en face du Player
	var forward_vector = forward.global_position - global_position
	var normalized_vector = forward_vector.normalized()
	
	## Activation / Désactivation des moteurs
	if Input.is_action_just_pressed("ui_left"):
		leftReactorActif = !leftReactorActif
	if Input.is_action_just_pressed("ui_right"):
		rightReactorActif = !rightReactorActif
	if Input.is_action_just_pressed("ui_up"):
		centerReactorActif = !centerReactorActif
	
	## Indique la direction dans laquelle tourne le vaisseau
	var rotationDirection = 0
	## Facteur de puissance. + 1 par moteur actif
	var reactorPower = 0
	## définition du facteur de rotation, de la vitesse et de la dépense de carburant
	if leftReactorActif:
		rotationDirection += 1
		reactorPower += speed
		consume_gas(gasExpense)
	if rightReactorActif:
		rotationDirection -= 1
		reactorPower += speed
		consume_gas(gasExpense)
	if centerReactorActif:
		reactorPower += speed
		consume_gas(gasExpense)
	
	# Applique la rotation
	rotate(rotationForce * rotationDirection)
	# Applique la vélocité
	velocity += normalized_vector * reactorPower
		
	## Frein ##
	if Input.is_action_pressed("ui_down"):
		# Désactive tous les moteurs
		leftReactorActif = false
		centerReactorActif = false
		rightReactorActif = false
		rotationDirection = 0
		reactorPower = 0
		velocity *= 0.99
		consume_gas(gasExpense)

func consume_gas(spent):
	gas -= spent
	
