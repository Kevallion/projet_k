extends Control

@onready var fuel = $CanvasLayer/FuelBar
@onready var life = $CanvasLayer/LifeBar
@onready var radarLabel = $CanvasLayer/RadarLabel
@onready var player = get_parent().get_node("Player")
@onready var energyBar: ProgressBar = %EnergyBar

@onready var ghost = $CanvasLayer/Ghost

var distance: int = 0

@onready var inv: Inv = preload("res://ressources/inventory/player_inventory.tres")
@onready var slots: Array = $CanvasLayer/ColorRect/MarginContainer/NinePatchRect/GridContainer.get_children()

var inventory_is_open = false

func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close_inventory()
 
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		if inventory_is_open:
			close_inventory()
		else:
			open_inventory()
	
	set_interface_values()
	
	set_hologram_property(Vector2(170, 600), Vector2(0.15, 0.15), player)
	
func set_hologram_property(tx_pos, tx_scale, model):
	ghost.position = tx_pos
	ghost.scale = tx_scale
	ghost.rotation = model.sprite.rotation
	
	$CanvasLayer/Ghost/ReactorCenterSprite.visible = model.reactorCenterSprite.visible
	$CanvasLayer/Ghost/ReactorLeftSprite.visible = model.reactorLeftSprite.visible
	$CanvasLayer/Ghost/ReactorRightSprite.visible = model.reactorRightSprite.visible
	$CanvasLayer/Ghost/ReactorFrontLeftSprite.visible = model.reactorFrontLeftSprite.visible
	$CanvasLayer/Ghost/ReactorFrontRightSprite.visible = model.reactorFrontRightSprite.visible
	
func set_interface_values():
	## Barre de carburant ##
	fuel.max_value = player.maxGas
	fuel.value = player.gas
	energyBar.value = player.energy
	energyBar.max_value = player.maxEnergy
	
	## Barre de vie ##
	life.value = player.health
	life.max_value = player.maxHealth
	
	## Radar ##
	distance = 999999999999
	for planet in get_tree().get_nodes_in_group("radar_detection"):
		if distance > player.global_position.distance_to(planet.global_position):
			distance = player.global_position.distance_to(planet.global_position)
	radarLabel.text = str(distance)
	
func close_inventory():
	$CanvasLayer/ColorRect.visible = false
	inventory_is_open = false
	
func open_inventory():
	$CanvasLayer/ColorRect.visible = true
	inventory_is_open = true
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
