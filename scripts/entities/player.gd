extends CharacterBody2D

@onready var forward = $Direction

var gas = 1000.0;
var maxGas = 1000.0;
var depenseGas = 1;

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		rotate(0.01 *  Input.get_axis("ui_left", "ui_right"))
		var forward_vector = forward.global_position - global_position
		var normalized_vector = forward_vector.normalized()
		velocity += normalized_vector * 2
		consume_gas()
	move_and_slide()

func consume_gas():
	gas -= depenseGas
	
