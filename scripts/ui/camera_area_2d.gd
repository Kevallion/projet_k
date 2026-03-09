extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.respawnPosition = body.position
		body.camera._on_camera_area_changed($CollisionShape2D)
		body.orientation = body.sprite.rotation
		body.outOfBound.stop()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.outOfBound.start()
	
