@tool
class_name FlowZone extends EnvironmentZone

@onready var polygon_2d: Polygon2D = %Polygon2D

@export_group("Flow Settings")
@export var direction := Vector2.RIGHT:
	set(value):
		direction = value
		_update_visuals()

@export var force := 20000.0
@export var visual_speed := 100.0

var scrolling_val := 0.0

func _process(delta: float) -> void:
	if not polygon_2d: return
	
	# On fait défiler la valeur sur un seul axe
	scrolling_val -= visual_speed * delta
	# On applique cette valeur à l'offset X de la texture
	# L'axe X sera celui pointé par 'texture_rotation'
	polygon_2d.texture_offset.x = scrolling_val

func _update_visuals():
	if not polygon_2d or not collisionShapeScene: return
	
	polygon_2d.polygon = collisionShapeScene.polygon
	# Aligne la texture avec le vecteur de direction
	if direction == Vector2.UP or direction == Vector2.DOWN:
		polygon_2d.texture_rotation = -direction.angle()
	else:
		polygon_2d.texture_rotation = direction.angle()
