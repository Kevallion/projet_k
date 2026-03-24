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

@export_group("Physique")
@export var mass := 1.0
@export var forceDrag := 5.0
@export var maxSpeed := 300.0


@export_group("Stats")
@export var maxGas := 3000.0
@export var maxHealth := 1000.0
@export var maxEnergy := 300.0
@export var inventory: Inv

@export var graveBody = preload("res://scenes/entities/grave_body.tscn")
var unlocked_gadgets : Array[String] = []

var gas := 3000.0
var health := 900.0
var energy := 300.0
var gasExpense := 1.0
var hasShield := false

#Etat du vaisseau
var externalForce := Vector2.ZERO
var rotationDirection := 0.0
var rotationForce := 0.01
var holdingTime := 0
var speedPower := 1.0
var isReactorActive := false
#sound
@export_group("SOUND")
@export var sndCrash : AudioStream = preload("res://assets/audio/sfx/Crash (Death).ogg")
@export var sndHitImpacts : Array[AudioStream] = [preload("res://assets/audio/sfx/Hit Impact 1.ogg"),
									preload("res://assets/audio/sfx/Hit Impact 2.ogg"),
									preload("res://assets/audio/sfx/Hit Impact 3.ogg"), 
									preload("res://assets/audio/sfx/Hit Impact 4.ogg")]
@export var sndReactorUp : AudioStream = preload("res://assets/audio/sfx/Engage 1.ogg")
@export var sndReactorOn : AudioStream = preload("res://assets/audio/sfx/SFX_REACTORS_IDLE_SPACESHIP(L).ogg")
@export var sndReactorDown : AudioStream = preload("res://assets/audio/sfx/Engage 3.ogg")
@export var sndRepairs : Array[AudioStream] = [preload("res://assets/audio/sfx/Repair or Craft 1.ogg"),preload("res://assets/audio/sfx/Repair or Craft 2.ogg")]
@export var shieldHitsounds : Array[AudioStream] = [preload("res://assets/audio/sfx/Shield Hit 1.ogg"),preload("res://assets/audio/sfx/Shield Hit 2.ogg")]

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
	_check_vitals()

func _handleMovements():
	var forwardVector = (forward.global_position - global_position).normalized()
	
	var leftActive = Input.is_action_pressed("ui_left")
	var rightActive = Input.is_action_pressed("ui_right")
	var centerActive = Input.is_action_pressed("ui_up")
	var braking = Input.is_action_pressed("ui_down")
	
	#savoir si le moteur est allumé
	var currentlyActive = leftActive or rightActive or centerActive or braking
	
	#gestion des sons du reacteur
	if currentlyActive and not isReactorActive:
		#AudioManager.play(sndReactorUp, &"SFX",-5.,0.5)
		AudioManager.play(sndReactorOn, &"SFX",2.0,0.2)
		isReactorActive = true
	elif not currentlyActive and isReactorActive:
		AudioManager.stop(sndReactorOn)
		#AudioManager.play(sndReactorDown, &"SFX",-5.0,0.5)
		isReactorActive = false
		
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


func _check_vitals():
	if gas <= 0:
		drop_stuff()
		trigger_respawn()
	if health > maxHealth:
		health = maxHealth
	if health <= 0:
		AudioManager.play(sndCrash,&"SFX")
		drop_stuff()
		trigger_respawn()
		return

#fonction pour appeler le respaw
func trigger_respawn():
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
			AudioManager.play(shieldHitsounds.pick_random(),&"SFX")
			return
			
		health -= damage
		AudioManager.play(sndHitImpacts.pick_random(),&"SFX")
		if mainCamera.has_method("add_shake"):
			mainCamera.add_shake(10.0)
		$Sprite2D/HitFrames.play("hit")
		$InvulFrames.start()

func add_force(force: Vector2) -> void:
	externalForce += force / mass

func _consumeGas(spent):
	gas -= spent
	energy += 0.01

func refill_gas():
	gas = maxGas
	
func recharge_energy():
	energy = maxEnergy

func collect(item, amount):
	if inventory: inventory.insert(item, amount)

func can_repair():
	if !health < maxHealth:
		return false
	for slot in inventory.slots:
		if slot.item:
			if slot.item.name == "fragment":
				return true
	return false
	
func repair():
	AudioManager.play(sndRepairs.pick_random(),&"SFX")
	health += 50
	inventory.remove("fragment", 1)
				
func can_craft():
	var ingredientList = []
	for slot in inventory.slots:
		if slot.item:
			if slot.item.name == "fragment":
				ingredientList.append(true)
			else: 
				ingredientList.append(false)
	return ingredientList
	
func find_compo(compo, amount):
	for slot in inventory.slots:
		if slot.item:
			if slot.item.name == compo and slot.amount >= amount :
				return slot.item
	return null

func delete_compo(compo):
	for slot in inventory.slots:
		if slot.item:
			if slot.item.name == compo:
				slot.item = null
				return true
	return false
	
func find_and_delete(compo, amount):
	if find_compo(compo, amount):
		inventory.remove(compo, amount)
		return true
	
func drop_stuff():
	if !inventory.is_empty():
		var grave = graveBody.instantiate()
		get_tree().current_scene.find_child("Player").get_parent().add_child(grave)
		grave.global_position = global_position
		grave.temp_inv.insert_all(inventory.slots)
		inventory.empty()
	
func unlock_skill_slot(comp: String) -> void:
	if not unlocked_gadgets.has(comp):
		unlocked_gadgets.append(comp)
	
