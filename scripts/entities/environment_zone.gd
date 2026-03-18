@tool
class_name EnvironmentZone extends Area2D

var affectedBodies: Array[Node2D] = []
@export var collisionShapeScene : CollisionPolygon2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("add_force") or "health" in body:
		body.externalForce = Vector2.ZERO
		affectedBodies.append(body)

func _on_body_exited(body: Node2D) -> void:
		affectedBodies.erase(body)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	for body in affectedBodies:
		_apply_effect(body, delta)

func _apply_effect(_body: Node2D, _delta: float) -> void:
	pass
