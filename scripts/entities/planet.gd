@tool
class_name Planet extends CharacterBody2D

## la texture de la planet
@export var planetTexture : Texture2D = preload("uid://blx2yg2hr7ojl") : set = set_sprite_planet

##la shape de colision de l'asterpod
@export_range(0.0,2000.0) var collisionRange := 46.5 : set = set_collision_range
@onready var attraction_area: Area2D = %attraction_area

##veiller à bien definir la taille de collision en fonctin [br]
##de la taille du sprite
@onready var colisionShape := _create_colisionShape_2d()
@onready var sprite2d := create_sprite_2d()



var tween_rotation : Tween 
func create_sprite_2d() -> Sprite2D:
	var sprite_2d := Sprite2D.new()
	if planetTexture:
		sprite_2d.texture= planetTexture
	return sprite_2d
	
func set_collision_range(new_value) -> void:
	collisionRange = new_value
	if colisionShape:
		colisionShape.shape.radius = new_value

func set_sprite_planet(new_sprite) -> void:
	planetTexture = new_sprite
	if sprite2d:
		sprite2d.texture = planetTexture
		
func _create_colisionShape_2d() -> CollisionShape2D:
	var collisionShape := CollisionShape2D.new()
	collisionShape.shape = CircleShape2D.new()
	collisionShape.shape.radius = collisionRange
	return collisionShape

func _ready() -> void:
	add_child(sprite2d)
	add_child(colisionShape)
	set_sprite_planet(planetTexture)
	attraction_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("space_object"):
		print(body)
		body = body as SpaceObject
		body.orbitAround(self,100.0,10.0)
		

func _get_configuration_warnings() -> PackedStringArray:
	if not planetTexture:
		return["Attention il faut mettre une texture dans le paramètre exporté"]
	if not collisionRange:
		return["Attention il faut paramètrer la range de collision"]
	update_configuration_warnings()
	return[]
