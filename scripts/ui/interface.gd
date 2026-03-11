extends Control

@onready var fuel = $CanvasLayer/FuelBar
@onready var life = $CanvasLayer/LifeBar
@onready var player = get_parent().get_node("Player")
@onready var ghostPlayer = $CanvasLayer/Player

@onready var ghost = $CanvasLayer/Ghost
@onready var char = $CanvasLayer/CharacterBody2D

func _ready():
	ghosting()
 
func _physics_process(delta: float) -> void:
	fuel.value = player.gas
	fuel.max_value = player.maxGas
	
	life.value = player.health
	life.max_value = player.maxHealth
	
	ghostPlayer.position = Vector2(80, 600)
	ghostPlayer.sprite.rotation = player.sprite.rotation
	
func set_property(tx_pos, tx_scale ):
	ghost.position = tx_pos
	ghost.scale = tx_scale
 
func ghosting():
	var tween_fade = get_tree().create_tween()
 
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 0), 0.25 )
	await tween_fade.finished
	
