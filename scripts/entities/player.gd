class_name Player extends CharacterBody2D

#Nodes
@onready var sprite = $Sprite2D
@onready var forward = $Sprite2D/Direction
@onready var mainCamera = $Camera2D
@onready var outOfBoundTimer = $OutOfBound

#Sprites des réacteurs
@onready var reactorCenterSprite = $Sprite2D/ReactorCenterSprite
@onready var reactorLeftSprite = $Sprite2D/ReactorLeftSprite
@onready var reactorRightSprite = $Sprite2D/ReactorRightSprite
@onready var reactorFrontLeftSprite = $Sprite2D/ReactorFrontLeftSprite
@onready var reactorFrontRightSprite = $Sprite2D/ReactorFrontRightSprite

#Paramètres physiq
@export_group("Physique")
@export var mass := 1.0
@export var forceDrag := 5.0
@export var maxSpeed := 300.0

#Stats
@export_group("Stats")
@export var maxGas := 2000.0
@export var maxHealth := 1000.0
@export var maxEnergy := 300.0
@export var inventory: Inv

var gas := 2000.0
var health := 1000.0
var energy := 300.0
var gasExpense := 1.0
var hasShield := false

#Etat du vaisseau
var externalForce := Vector2.ZERO
var rotationDirection := 0.0
var rotationForce := 0.01
var holdingTime := 0
var speedPower := 1.0

func _physics_process(delta: float) -> void:
	externalForce = externalForce.lerp(Vector2.ZERO, forceDrag * delta)
	
	_handleMovements()

	velocity += externalForce * delta
	move_and_slide()
	
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		velocity = velocity.bounce(collisionInfo.get_normal()) * 0.6
		take_hit(50.0) # Dégât de choc
	
	# 5. Check Vitals
	_checkVitals()

func _handleMovements():
	var forwardVector = (forward.global_position - global_position).normalized()
	
	var leftActive = Input.is_action_pressed("ui_left")
	var rightActive = Input.is_action_pressed("ui_right")
	var centerActive = Input.is_action_pressed("ui_up")
	var braking = Input.is_action_pressed("ui_down")
	
	var reactorPower = 0.0
	rotationForce = 0.01
	
	if leftActive:
		rotationDirection -= 0.1
		reactorPower += speedPower
		_consumeGas(gasExpense)
	if rightActive:
		rotationDirection += 0.1
		reactorPower += speedPower
		_consumeGas(gasExpense)
	
	# Visuels
	reactorRightSprite.visible = leftActive
	reactorFrontLeftSprite.visible = leftActive
	reactorLeftSprite.visible = rightActive
	reactorFrontRightSprite.visible = rightActive
	
	if braking:
		if leftActive or rightActive: rotationForce = 0.03
		reactorFrontLeftSprite.visible = true
		reactorFrontRightSprite.visible = true
		if !rightActive: reactorRightSprite.visible = true
		if !leftActive: reactorLeftSprite.visible = true
		
		rotationDirection *= 0.9
		velocity *= 0.9
		reactorPower = 0
		_consumeGas(gasExpense)
	
	if Input.is_action_just_pressed("ui_up"): holdingTime = 0
	
	if centerActive:
		holdingTime += 1
		reactorPower += speedPower
		if holdingTime > 75: 
			reactorPower += speedPower * 2
			reactorLeftSprite.visible = true
			reactorRightSprite.visible = true
		reactorCenterSprite.visible = true
		_consumeGas(gasExpense)
	else:
		reactorCenterSprite.visible = false
	
	if rightActive and leftActive:
		reactorCenterSprite.visible = true
		reactorFrontLeftSprite.visible = false
		reactorFrontRightSprite.visible = false
		
	sprite.rotate(rotationForce * rotationDirection)
	velocity += forwardVector * reactorPower
	
	velocity.x = clampf(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clampf(velocity.y, -maxSpeed, maxSpeed)


func _checkVitals():
	if health <= 0 or gas <= 0:
		triggerRespawn()
		return
	
	var marge = 50
	if position.x + marge < mainCamera.limit_left or position.x - marge > mainCamera.limit_right or \
	   position.y - marge > mainCamera.limit_bottom or position.y + marge < mainCamera.limit_top:
		if outOfBoundTimer.is_stopped():
			outOfBoundTimer.start()

#fonction pour appeler le respaw
func triggerRespawn():
	var targetPos = _getNearestStationPos()
	global_position = targetPos
	velocity = Vector2.ZERO
	externalForce = Vector2.ZERO
	rotationDirection = 0
	if sprite: sprite.rotation = 0
	
	# Reset Stats
	health = maxHealth
	gas = maxGas
	energy = maxEnergy
	hasShield = false # On perd le bouclier au respawn

#fonction qui va renvoyer la station de spawn la plus proche
func _getNearestStationPos() -> Vector2:
	var stations = get_tree().get_nodes_in_group("Station_spawn")
	if stations.size() == 0: return Vector2.ZERO
	
	var closest = null
	var minDist = INF
	
	for s in stations:
		
		if not s.isDiscovered:
			continue
		var dist = global_position.distance_to(s.global_position)
		if dist < minDist:
			minDist = dist
			closest = s
	if closest != null:
		return closest.global_position
	return Vector2.ZERO



func take_hit(damage := 100.0):
	if $InvulFrames.is_stopped():
		# Si on a un bouclier, il absorbe les dégâts
		if hasShield:
			return
			
		health -= damage
		if mainCamera.has_method("add_shake"):
			mainCamera.add_shake(10.0)
		$Sprite2D/HitFrames.play("hit")
		$InvulFrames.start()

func add_force(force: Vector2) -> void:
	externalForce += force / mass

func _consumeGas(spent):
	gas -= spent

func refill_gas():
	gas = maxGas

func _on_out_of_bound_timeout() -> void:
	triggerRespawn()

func collect(item):
	if inventory: inventory.insert(item)
