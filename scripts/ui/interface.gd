extends Control

@onready var fuel = $CanvasLayer/FuelBar
@onready var life = $CanvasLayer/LifeBar
@onready var energy_bar = $CanvasLayer/EnergyBar
@onready var radarLabel = $CanvasLayer/RadarLabel
@onready var player = get_parent().get_node("Player")
@onready var energyBar: TextureProgressBar = $CanvasLayer/EnergyBar
@onready var ghost = $CanvasLayer/Ghost

var distance: int = 0

@onready var inv: Inv = preload("res://ressources/inventory/player_inventory.tres")
@onready var slots: Array = $CanvasLayer/ColorRect/MarginContainer/NinePatchRect/GridContainer.get_children()

var inventory_is_open = false

@onready var repairButton = $CanvasLayer/ColorRect/RepairButton
@onready var shield_button = %ShieldButton
@onready var tractor_button = %TractorButton
@onready var portal_button = %PortalButton
@onready var laser_button = %LaserButton

@export var sndRepairs : Array[AudioStream] = [preload("res://assets/audio/sfx/Repair or Craft 1.ogg"),preload("res://assets/audio/sfx/Repair or Craft 2.ogg")]


func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close_inventory()
 	
func _physics_process(_delta: float) -> void:
	update_slots()
	if inventory_is_open:
		get_tree().paused = true
		
	#get_tree().paused = !get_tree().paused
	if Input.is_action_just_pressed("ui_cancel"):
		if inventory_is_open:
			close_inventory()
		else:
			open_inventory()
			
	set_interface_values()
	
	set_hologram_property(Vector2(136, 606), Vector2(0.15, 0.15), player)
	
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
	
	## Barre de vie ##
	life.value = player.health
	life.max_value = player.maxHealth
	
	## Barre d'energie ##
	energy_bar.value = player.energy
	energy_bar.max_value = player.maxEnergy
	
	## Radar ##
	distance = 999999999999
	for planet in get_tree().get_nodes_in_group("radar_detection"):
		if distance > player.global_position.distance_to(planet.global_position):
			distance = player.global_position.distance_to(planet.global_position)
	radarLabel.text = str(distance)
		
	if player.can_repair():
		repairButton.disabled = false
	else:
		repairButton.disabled = true
	
	## unlock Skills Craft Buttons ##
	if (player.find_compo("shield_compo1",1) and player.find_compo("shield_compo2",1)) or %ShieldButton.get_parent().crafted:
		%ShieldButton.disabled = false
	else:
		%ShieldButton.disabled = true
	if (player.find_compo("tractor_compo1",1) and player.find_compo("tractor_compo2",1)) or %TractorButton.get_parent().crafted:
		%TractorButton.disabled = false
	else:
		%TractorButton.disabled = true
	if (player.find_compo("portal_compo1",1) and player.find_compo("portal_compo2",1)) or %PortalButton.get_parent().crafted:
		%PortalButton.disabled = false
	else:
		%PortalButton.disabled = true
	if (player.find_compo("laser_compo1",1) and player.find_compo("laser_compo2",1)) or %LaserButton.get_parent().crafted:
		%LaserButton.disabled = false
	else:
		%LaserButton.disabled = true
		
func close_inventory():
	if not %DialogNode:
		return
	if !%DialogNode.dialogOpen:
		get_tree().paused = false
	$CanvasLayer/ColorRect.visible = false
	inventory_is_open = false
	
func open_inventory():
	$CanvasLayer/ColorRect.visible = true
	inventory_is_open = true
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _on_repair_button_pressed() -> void:
	player.repair()
	update_slots()

func _on_shield_button_pressed() -> void:
	shield_button.texture_hover = null
	if !shield_button.get_parent().crafted:
		inv.remove("shield_compo1", 1)
		inv.remove("shield_compo2",1)
		shield_button.get_parent().crafted = true
		AudioManager.play(sndRepairs.pick_random(),&"SFX")
		player.unlock_skill_slot("shield")
	GameSignals.request_equip_gadget.emit("shield")
	update_slots()

func _on_tractor_button_pressed() -> void:
	tractor_button.texture_hover = null
	if !tractor_button.get_parent().crafted:
		inv.remove("tractor_compo1",1)
		inv.remove("tractor_compo2",1)
		tractor_button.get_parent().crafted = true
		player.unlock_skill_slot("tractor")
		AudioManager.play(sndRepairs.pick_random(),&"SFX")
	GameSignals.request_equip_gadget.emit("tractor")
	update_slots()

func _on_portal_button_pressed() -> void:
	portal_button.texture_hover = null
	if !portal_button.get_parent().crafted:
		if not player.find_compo("portal_compo1",1) or not player.find_compo("portal_compo2",1):
			return # Annule l'action s'il manque un composant
		inv.remove("portal_compo1",1)
		inv.remove("portal_compo2",1)
		portal_button.get_parent().crafted = true
		AudioManager.play(sndRepairs.pick_random(),&"SFX")
		player.unlock_skill_slot("portal")
	GameSignals.request_equip_gadget.emit("portal")
	update_slots()

func _on_laser_button_pressed() -> void:
	laser_button.texture_hover = null
	if !laser_button.get_parent().crafted:
		if not player.find_compo("laser_compo1",1) or not player.find_compo("laser_compo2",1):
			return # Annule l'action s'il manque un 
		
		inv.remove("laser_compo1",1)
		inv.remove("laser_compo2",1)
		laser_button.get_parent().crafted = true
		AudioManager.play(sndRepairs.pick_random(),&"SFX")
		player.unlock_skill_slot("laser")
	GameSignals.request_equip_gadget.emit("laser")
	update_slots()
