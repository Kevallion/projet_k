class_name SpatialRespawn extends SpatialStation

@export var isDiscovered := false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		isDiscovered = true
		print("You discover a new station")
