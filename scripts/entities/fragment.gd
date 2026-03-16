extends RigidBody2D

@export var item: InvItem
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect(item)
		self.queue_free()
