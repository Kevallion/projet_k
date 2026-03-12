@tool
class_name Planet extends CharacterBody2D

## la texture de la planet
@export var planetTexture : Texture2D = preload("res://assets/sprites/planets/planet00.png") : set = set_sprite_planet

##la shape de colision 
@export_range(0.0,2000.0) var collisionRange := 46.5 : set = set_collision_range

## la shape d'attraction de l'astre
@export_range(500.0,5000.0) var attractionRange := 1000.0 : set = set_attraction_range

##veiller à bien definir la taille de collision en fonctin [br]
##de la taille du sprite
@onready var colisionShape := _create_colisionShape_2d()
@onready var sprite2d := create_sprite_2d()
@onready var attraction_area: Area2D = %AttractionArea




var tween_rotation : Tween 
func create_sprite_2d() -> Sprite2D:
	var sprite_2d := Sprite2D.new()
	if planetTexture:
		sprite_2d.texture= planetTexture
	return sprite_2d

##setter pour modifier la range de la planète
func set_collision_range(new_value) -> void:
	collisionRange = new_value
	if colisionShape:
		colisionShape.shape.radius = new_value

##setter pour modifier la range de la planète
func set_attraction_range(new_value) -> void:
	attractionRange = new_value
	if attraction_area:
		var ownColisionShape := attraction_area.get_node_or_null("CollisionShape2D")
		if ownColisionShape:
			ownColisionShape.shape.radius = new_value
		
	
##setter pour modifier le sprite de la planete
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
	set_attraction_range(attractionRange)
	set_collision_range(collisionRange)
	if Engine.is_editor_hint():
		return
	attraction_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if attraction_area.has_overlapping_bodies():
		for body in attraction_area.get_overlapping_bodies():
			if body is Player:
				body = body as Player
				var attractedDirection := body.global_position.direction_to(global_position)
				var attractedForce := attractedDirection * 2.5
				body.add_force(attractedForce)
	
#fonction appeler pour faire tourner un objet spatial autour d'un astre
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("space_object"):
		body = body as SpaceObject
		body.orbitAround(self,100.0,10.0)
	

func _get_configuration_warnings() -> PackedStringArray:
	if not planetTexture:
		return["Attention il faut mettre une texture dans le paramètre exporté"]
	if not collisionRange:
		return["Attention il faut paramètrer la range de collision"]
	update_configuration_warnings()
	return[]
