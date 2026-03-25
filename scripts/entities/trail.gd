extends Line2D
 
var queue : Array
@export var MAX_LENGTH : int
var point = Vector2()
 
func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	
	point = get_parent().global_position
	add_point(point)
	while get_point_count() > MAX_LENGTH:
		remove_point(0)
