extends SpaceObject

@onready var engine_visual: EngineVisual = %EngineVisuals

@onready var forward = $Direction
#@onready var camera =  $Camera2D

## vitesse maximal du vaisseau
@export var maxSpeed := 300.0
## vitesse d'acceleration dans l'espace
@export var space_acceleration := 1000
## vitesse à laquelle le vaisseau va ralentir si le moteur est eteint
@export var space_deceleration := 10.0

var gas := 1000.0;
var maxGas := 1000.0;
var gasExpense = 1;

var rotationForce := 0.01

var leftReactorActif := false 
var centerReactorActif := false 
var rightReactorActif := false
var frontReactorActif := false

##Permet de savoir si une des touche du moteur est appuyé
var hasEngineInput := false

##Contient la nouvelle vélocité qu'on souhaite en fonction des moteur allumé
var desired_velocity : Vector2

## stepPowerReactor
var reactorPowerStep := 1.0

## la puissance actuelle du moteur
var currentReactorPower := 0.0 : 
	set(new_reactorPower):
		currentReactorPower = clampf(new_reactorPower,0.0,400)



func _physics_process(_delta: float) -> void:
	#appliqué la physique du parent
	super._physics_process(_delta)
	
	basic_mouvements(_delta)
	velocity += external_force
	move_and_slide()

	
	var collision := get_last_slide_collision()
	if collision:
		var normal := collision.get_normal()
		var bounce_vector = velocity.bounce(normal) * bounciness
		add_force(bounce_vector)
		
	#met à ajout les visuel du moteurs
	update_reactor_visual()
	
func basic_mouvements(_delta):
	## Vecteur de direction en face du Player
	var forward_vector = forward.global_position - global_position
	var normalized_vector = forward_vector.normalized()
	
	# test Action / Desaction des moteurs si on appuie plus
	leftReactorActif = Input.is_action_pressed("ui_left")
	rightReactorActif = Input.is_action_pressed("ui_right")
	centerReactorActif = Input.is_action_pressed("ui_up")
	frontReactorActif = Input.is_action_pressed("ui_down")
	
	#on check si une des touches de moteurs est appuyé
	hasEngineInput = leftReactorActif or rightReactorActif or centerReactorActif
	
	## Indique la direction dans laquelle tourne le vaisseau
	var rotationDirection = 0
	
	## définition du facteur de rotation, de la vitesse et de la dépense de carburant
	if leftReactorActif:
		rotationDirection += 1
		currentReactorPower += reactorPowerStep
		consume_gas(gasExpense)
	if rightReactorActif:
		rotationDirection -= 1
		currentReactorPower += reactorPowerStep
		consume_gas(gasExpense)
	if centerReactorActif:
		currentReactorPower += reactorPowerStep
		consume_gas(gasExpense)

	# Applique la rotation
	rotate(rotationForce * rotationDirection)
	
	desired_velocity = normalized_vector * currentReactorPower
	
	# Applique la vélocité, differement si moteur allumé
	if hasEngineInput:
		velocity = velocity.move_toward(desired_velocity, space_acceleration * _delta )
	
		## Frein ##
	elif frontReactorActif:
		# Désactive tous les moteurs
		leftReactorActif = false
		centerReactorActif = false
		rightReactorActif = false
		rotationDirection = 0
		
		#abaisse progressivement la puissance des moteurs
		currentReactorPower = lerpf(currentReactorPower,0.0, 15.0 * _delta)
		
		#abaisse progressivement la vélocité
		velocity = velocity.move_toward(Vector2.ZERO, (space_deceleration * 1.2) * _delta)
		consume_gas(gasExpense)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, space_deceleration * _delta)
		#abaisse la puissance des moteur
		currentReactorPower = lerpf(currentReactorPower,0.0, 0.4 * _delta)
		desired_velocity = velocity.move_toward(Vector2.ZERO, space_deceleration * _delta)
		

	##clamp la vitesse maximal
	velocity.x = clampf(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clampf(velocity.y, -maxSpeed, maxSpeed)
	
	#print("nouvelle velocité", desired_velocity)
	#print("velocity :", velocity)
	#print("reactorPower: ", currentReactorPower)
	

##function pour pour mettre à jour le visuel des reacteur
func update_reactor_visual():
	if not engine_visual:
		return
	engine_visual.on_reactor_front(frontReactorActif)
	if centerReactorActif:
		engine_visual.on_reactor_up(centerReactorActif)
	else:
		engine_visual.on_reactor_left(leftReactorActif)
		engine_visual.on_reactor_right(rightReactorActif)
		
func consume_gas(spent):
	gas -= spent
