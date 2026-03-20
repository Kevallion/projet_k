extends Camera2D

var ZoomFactor := Vector2(0.15, 0.15)
var ZoomMax := 10.0
var ZoomMin := 0.7

var ScreenSize : Vector2
var Largeur : float
var Hauteur : float
var MovePower : float

#Nouvelles variables pour l'amélioration
@export var LookAheadFactor := 0.2
@export var DynamicZoomSpeed := 0.001
@onready var PlayerNode = get_parent()

# On stocke le zoom choisi par le joueur ici
var BaseZoom := 1.0 
var ShakeIntensity := 0.0

func _physics_process(_delta: float) -> void:
	ScreenSize = get_viewport().size
	Largeur = ScreenSize.x / zoom.x
	Hauteur = ScreenSize.y / zoom.y
	MovePower = 20.0 / zoom.x
	
	move_camera()
	zooming_process()

func _process(_delta: float) -> void:
	if ShakeIntensity > 0:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * ShakeIntensity
		ShakeIntensity = lerp(ShakeIntensity, 0.0, 0.1)
	else:
		offset = Vector2.ZERO
		
func zooming_process():
	# 1. On gère l'entrée du joueur (Molette) sur le BaseZoom
	if Input.is_action_just_pressed("molette_down"):
		BaseZoom -= ZoomFactor.x
	elif Input.is_action_just_pressed("molette_up"):
		BaseZoom += ZoomFactor.x
	
	BaseZoom = clamp(BaseZoom, ZoomMin, ZoomMax)

	# 2. On calcule le zoom dynamique (vitesse)
	var TargetZoomVal = BaseZoom
	if not get_tree().paused:
		var SpeedFactor = PlayerNode.velocity.length() * DynamicZoomSpeed
		# On réduit la valeur de zoom cible selon la vitesse
		TargetZoomVal = clamp(BaseZoom - SpeedFactor, ZoomMin, ZoomMax)
	
	# 3. Application fluide
	zoom = zoom.lerp(Vector2(TargetZoomVal, TargetZoomVal), 0.05)
		
	# 4. Limites de l'écran 
	if (global_position.x - (Largeur/2)) < limit_left:
		global_position.x = limit_left + (Largeur/2)
	if (global_position.x + (Largeur/2)) > limit_right:
		global_position.x = limit_right - (Largeur/2)
	if (global_position.y - (Hauteur/2)) < limit_top:
		global_position.y = limit_top + (Hauteur/2)
	if (global_position.y + (Hauteur/2)) > limit_bottom:
		global_position.y = limit_bottom - (Hauteur/2)

func move_camera():
	if get_tree().paused:
		# Mouvement manuel en pause
		if Input.is_action_pressed("ui_down") and (global_position.y + (Hauteur/2)) < limit_bottom:
			position.y += MovePower
		if Input.is_action_pressed("ui_up") and (global_position.y - (Hauteur/2)) > limit_top:
			position.y -= MovePower
		if Input.is_action_pressed("ui_left") and (global_position.x - (Largeur/2)) > limit_left:
			position.x -= MovePower
		if Input.is_action_pressed("ui_right") and (global_position.x + (Largeur/2)) < limit_right:
			position.x += MovePower
	else:
		# Suivi avec anticipation (Look Ahead)
		var TargetPos = PlayerNode.velocity * LookAheadFactor
		position = position.lerp(TargetPos, 0.1)
	
func _on_camera_area_changed(AreaShape: CollisionShape2D):
	var Marge = 20
	limit_left = (AreaShape.global_position.x - AreaShape.shape.size.x / 2) - Marge
	limit_right = (AreaShape.global_position.x + AreaShape.shape.size.x / 2) + Marge
	limit_bottom = (AreaShape.global_position.y + AreaShape.shape.size.y / 2) + Marge
	limit_top = (AreaShape.global_position.y - AreaShape.shape.size.y / 2) - Marge

func add_shake(Intensity: float):
	ShakeIntensity = Intensity
