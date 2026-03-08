class_name EngineVisual extends Node2D

@onready var reactor_front: Sprite2D = %reactor_front
@onready var reactor_right: Sprite2D = %reactor_right
@onready var reactor_left: Sprite2D = %reactor_left

func _ready() -> void:
	for child: Node2D in get_children():
		child.visible = false
	
func on_reactor_front(value: bool) -> void:
	reactor_front.visible = value

func on_reactor_right(value: bool) -> void:
	reactor_right.visible = value

func on_reactor_left(value: bool) -> void:
	reactor_left.visible = value

func on_reactor_up(value: bool) -> void:
	reactor_right.visible = value
	reactor_left.visible = value
