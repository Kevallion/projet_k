##Ce node est conçu pour placer des astéroid sur la map
@tool
class_name Asteroid extends SpaceObject

## la texture de l'asterpod
@export var asteroidTexture : Texture2D = preload("res://ressources/default_asteroid_texture.tres") : set = set_sprite_asteroid

##la shape de colision de l'asterpod
@export_range(0.0,200.0) var collisionRange := 46.5 : set = set_collision_range


##veiller à bien definir la taille de collision en fonction [br]
##de la taille du sprite
@onready var colisionShape := _create_colisionShape_2d()
@onready var sprite2d := create_sprite_2d()

#zone de collision pour repouser le vaisseau
@onready var pushZone: Area2D = %pushZone

@export var max_health := 100.0
var current_health := max_health



@export_range(10.0, 1000.0) var pushZoneRange := 0.0 : set = set_pushZone_range
			
func set_pushZone_range(new_value : float) -> void:
	pushZoneRange = new_value
	if pushZone:
		pushZone.get_node("CollisionShape2D").shape.radius = new_value

@export_group("Animation")
##savoir si l'asteroid à une animation de rotation
@export var is_animate_rotation := true :
	set(new_bool):
		is_animate_rotation = new_bool
		animate_turn_meteor()				

##vitesse de l'animation
@export_range(1.0,15.0) var speedTurnAnimaton := 5.0 : 
	set(new_value):
		speedTurnAnimaton = new_value
		animate_turn_meteor()

var tween_rotation : Tween 
func create_sprite_2d() -> Sprite2D:
	var sprite_2d := Sprite2D.new()
	if asteroidTexture:
		sprite_2d.texture= asteroidTexture
	return sprite_2d
	
func set_collision_range(new_value) -> void:
	collisionRange = new_value
	if colisionShape:
		colisionShape.shape.radius = new_value

func set_sprite_asteroid(new_sprite) -> void:
	asteroidTexture = new_sprite
	if sprite2d:
		sprite2d.texture = asteroidTexture
		
func _create_colisionShape_2d() -> CollisionShape2D:
	var collisionShape := CollisionShape2D.new()
	collisionShape.shape = CircleShape2D.new()
	collisionShape.shape.radius = collisionRange
	return collisionShape

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_child(sprite2d)
	add_child(colisionShape)
	set_sprite_asteroid(asteroidTexture)
	set_pushZone_range(pushZoneRange)
	set_collision_range(collisionRange)
	
	
	
	if Engine.is_editor_hint():
		return
		
	animate_turn_meteor()	
	pushZone.body_entered.connect(_on_body_entered)
	
func animate_turn_meteor() -> void:
	if not sprite2d :
		return

	if tween_rotation != null:
		tween_rotation.kill()
		if not is_animate_rotation:
			return
		
	var duration := randf_range(340.0, 380.0)
	duration *= speedTurnAnimaton
	tween_rotation = create_tween()
	tween_rotation.tween_property(sprite2d,"rotation",360.0,duration)

##function pour repousser le vaisseau
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_force") and body is Player:
		if body.hasShield:
			var push_direction := global_position.direction_to(body.global_position)
			var impact_power := 3000.0
			body.add_force(push_direction * impact_power)
		else:
			print("hit")
			body.health = 0.0
		
func _get_configuration_warnings() -> PackedStringArray:
	if not asteroidTexture:
		return["Attention il faut mettre une texture dans le paramètre exporté"]
	if not collisionRange:
		return["Attention il faut paramètrer la range de collision"]
	update_configuration_warnings()
	return[]
	
func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0:
		destroy()

func destroy() -> void:
	queue_free()
