extends Control

@onready var fuel = $CanvasLayer/FuelBar
@onready var life = $CanvasLayer/LifeBar
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var player : Player = get_parent().get_node("Player")
@onready var ghost = $CanvasLayer/Ghost
 
func _physics_process(_delta: float) -> void:
	fuel.value = player.gas
	fuel.max_value = player.maxGas
	
	life.value = player.health
	life.max_value = player.maxHealth
	
	energy_bar.value = player.energy
	energy_bar.max_value = player.maxEnergy
	set_property(Vector2(170, 600), Vector2(0.2, 0.2), player)
	
func set_property(tx_pos, tx_scale, model):
	ghost.position = tx_pos
	ghost.scale = tx_scale
	ghost.rotation = model.sprite.rotation
	
	$CanvasLayer/Ghost/ReactorCenterSprite.visible = model.reactorCenterSprite.visible
	$CanvasLayer/Ghost/ReactorLeftSprite.visible = model.reactorLeftSprite.visible
	$CanvasLayer/Ghost/ReactorRightSprite.visible = model.reactorRightSprite.visible
	$CanvasLayer/Ghost/ReactorFrontLeftSprite.visible = model.reactorFrontLeftSprite.visible
	$CanvasLayer/Ghost/ReactorFrontRightSprite.visible = model.reactorFrontRightSprite.visible
	
