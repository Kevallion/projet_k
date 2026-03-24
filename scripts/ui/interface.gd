extends Control

@onready var fuel = $CanvasLayer/FuelBar
@onready var life = $CanvasLayer/LifeBar
@onready var energy_bar = $CanvasLayer/EnergyBar
@onready var radar_label = $CanvasLayer/RadarLabel
@onready var player = get_parent().get_node("Player")
@onready var ghost = $CanvasLayer/Ghost
@onready var dialogNode = %DialogNode

var distance: int = 0

@onready var inv: Inv = preload("res://ressources/inventory/player_inventory.tres")
@onready var slots: Array = $CanvasLayer/ColorRect/MarginContainer/NinePatchRect/GridContainer.get_children()

var inventory_is_open = false

@onready var repair_button = $CanvasLayer/ColorRect/RepairButton
@onready var shield_button = %ShieldButton
@onready var tractor_button = %TractorButton
@onready var portal_button = %PortalButton
@onready var laser_button = %LaserButton

@export var sndRepairs : Array[AudioStream] = [preload("res://assets/audio/sfx/Repair or Craft 1.ogg"),preload("res://assets/audio/sfx/Repair or Craft 2.ogg")]


func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close_inventory()
	energy_bar.visible = false
 	
func _physics_process(_delta: float) -> void:
	update_slots()
	if inventory_is_open:
		get_tree().paused = true
		
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
	radar_label.text = str(distance)
		
	# Bouton de réparation
	if player.can_repair():
		repair_button.disabled = false
	else:
		repair_button.disabled = true
	
	## unlock Skills Craft Buttons ##
	set_gadget_button(shield_button, "shield_compo1", "shield_compo2")
	set_gadget_button(tractor_button, "tractor_compo1", "tractor_compo2")
	set_gadget_button(portal_button, "portal_compo1", "portal_compo2")
	set_gadget_button(laser_button, "laser_compo1", "laser_compo2")
		
func set_gadget_button(gadget_button, gadget_compo1, gadget_compo2) -> void:
	if (player.find_compo(gadget_compo1,1) and player.find_compo(gadget_compo2,1)) or gadget_button.get_parent().crafted:
		gadget_button.disabled = false
	else:
		gadget_button.disabled = true
		
func close_inventory():
	if not dialogNode:
		return
	if !dialogNode.dialogOpen:
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
	equip_gadget(shield_button, "shield_compo1", "shield_compo2", "shield")
	if dialogNode.actId == 6:
		dialogNode.open_dialog(dialogNode.actId, dialogNode.chapterId)
	dialogNode.finish_act()

func _on_tractor_button_pressed() -> void:
	equip_gadget(tractor_button, "tractor_compo1", "tractor_compo2", "tractor")

func _on_portal_button_pressed() -> void:
	equip_gadget(portal_button, "portal_compo1", "portal_compo2", "portal")

func _on_laser_button_pressed() -> void:
	equip_gadget(laser_button, "laser_compo1", "laser_compo2", "laser")

func equip_gadget(gadget_button, gadget_compo1, gadget_compo2, gadget_name) -> void:
	energy_bar.visible = true
	gadget_button.texture_hover = null
	if !gadget_button.get_parent().crafted:
		inv.remove(gadget_compo1,1)
		inv.remove(gadget_compo2,1)
		gadget_button.get_parent().crafted = true
		AudioManager.play(sndRepairs.pick_random(),&"SFX")
		player.unlock_skill_slot(gadget_name)
	GameSignals.request_equip_gadget.emit(gadget_name)
	update_slots()
