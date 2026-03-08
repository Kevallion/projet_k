extends Camera2D

@export var characterToFollow : Node2D

var zoom_speed = 100
var zoom_margin = 0.3

var zoom_factor = Vector2(0.15, 0.15)

var zoom_in
var zoom_out

var screensize
var largeur
var hauteur
var move_power

func _physics_process(_delta: float) -> void:
	global_position = characterToFollow.global_position
	screensize = get_viewport().size
	largeur = screensize.x/zoom.x
	hauteur = screensize.y/zoom.y
	move_power = 20 /zoom.x
	
	#move_camera()
	
	zooming_process()

func zooming_process():
	if Input.is_action_just_pressed("molette_down"):
		zoom_out = true
	elif Input.is_action_just_pressed("molette_up"):
		zoom_in = true
	else:
		zoom_out = false
		zoom_in = false
	if zoom_out:
		set_zoom(zoom * (Vector2.ONE - zoom_factor))
	elif zoom_in:
		set_zoom(zoom * (Vector2.ONE + zoom_factor))
		
	if (global_position.x - (largeur/2)) < limit_left:
		global_position.x=limit_left+(largeur/2)
	if (global_position.x + (largeur/2)) > limit_right:
		global_position.x=limit_right-(largeur/2)
	if (global_position.y - (hauteur/2)) < limit_top:
		global_position.y=limit_top+(hauteur/2)
	if (global_position.y + (hauteur/2)) > limit_bottom:
		global_position.y=limit_bottom-(hauteur/2)

func move_camera():
	if get_tree().paused:
		if Input.is_action_pressed("RightJoypad_down"):
			if (global_position.y + (hauteur/2)) < limit_bottom:
				position.y+=move_power
		if Input.is_action_pressed("RightJoypad_up"):
			if (global_position.y - (hauteur/2)) > limit_top:
				position.y-=move_power
		if Input.is_action_pressed("RightJoypad_left"):
			if (global_position.x - (largeur/2)) > limit_left:
				position.x-=move_power
		if Input.is_action_pressed("RightJoypad_right"):
			if (global_position.x + (largeur/2)) < limit_right:
				position.x+=move_power
	else:
		position.x = 0
		position.y = 0

func defineCameraLimits(left: int,top: int,right: int,bottom: int):
	limit_top = top
	limit_bottom = bottom
	limit_left = left
	limit_right = right
	
func _on_camera_area_changed(areaShape: CollisionShape2D):
	limit_left = (areaShape.global_position.x - areaShape.shape.size.x / 2) - 40
	limit_right = (areaShape.global_position.x + areaShape.shape.size.x / 2) + 40
	limit_bottom = (areaShape.global_position.y + areaShape.shape.size.y / 2) + 40
	limit_top = (areaShape.global_position.y - areaShape.shape.size.y / 2) - 40
