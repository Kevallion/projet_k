class_name GadgetManager extends Node2D

@onready var ship = get_parent()

## Liste des gadgets actifs configurés dans l'inspecteur (optionnel, pour le démarrage)
@export var gadgetActives : Array[Gadget]

const input_names = ["gadget_1", "gadget_2", "gadget_3"]
const key_slots = ["1", "2", "3"]
var slotIndex = 0

const LASER_GADGET = preload("res://scenes/entities/laser_gadget.tscn")
const PORTAL_GADGET = preload("res://scenes/entities/portal_gadget.tscn")
const SHIELD_GADGET = preload("res://scenes/entities/shield_gadget.tscn")
const TRACTOR_GADGET = preload("res://scenes/entities/tractor_gadget.tscn")


class Slot:
	var input_name : String
	var key : String
	var gadget : Gadget = null

var slots : Array[Slot] = []

func _ready() -> void:
	if owner:
		await owner.ready
	
	#initialisation des 3 slots, vides par défaut
	for i in range(input_names.size()):
		var slot = Slot.new()
		slot.input_name = input_names[i]
		slot.key = key_slots[i]
		slots.append(slot)
	
	#si des gadget sont parametrer dans l'inspecteur on les charge utile pour test
	for i in range(min(gadgetActives.size(), slots.size())):
		if gadgetActives[i]:
			assign_gadget_to_slot(gadgetActives[i], i)
	
	GameSignals.request_equip_gadget.connect(_on_request_equip)
	
func _on_request_equip(gadget_name: String) -> void:
	var newGadget: Gadget = null
	
	match gadget_name:
		"shield" : newGadget = SHIELD_GADGET.instantiate()
		"tractor" : newGadget = TRACTOR_GADGET.instantiate()
		"portal" : newGadget = PORTAL_GADGET.instantiate()
		"laser" : newGadget = LASER_GADGET.instantiate()
	
	if newGadget:
		var equipped = add_gadget_to_free_slot(newGadget)
		if not equipped:
			newGadget.queue_free()
## function pour assigner un gadget à un slot spécifique (0, 1 ou 2)
func assign_gadget_to_slot(new_gadget: Gadget, slot_index: int) -> void:
	if slot_index < 0 or slot_index >= slots.size():
		return
		
	var slot = slots[slot_index]
	
	# Si un gadget existait déjà dans ce slot, on le supprime
	if slot.gadget and slot.gadget != new_gadget:
		slot.gadget.queue_free()
		
	# Assigner le nouveau gadget
	slot.gadget = new_gadget
	
	if new_gadget:
		new_gadget.ship = ship
		new_gadget.unlock = true
		# Ajoute le gadget à la scène s'il n'y est pas encore
		if not new_gadget.is_inside_tree():
			add_child(new_gadget)
			
	# Mettre à jour l'UI
	GameSignals.gadgetAssigned.emit(slot_index, new_gadget, slot.key)

## Ajoute un gadget dans le premier slot libre
func add_gadget_to_free_slot(new_gadget: Gadget) -> bool:
	for i in range(slots.size()):
		if slots[i].gadget == null:
			assign_gadget_to_slot(new_gadget, i)
			return true
	# Si aucun slot libre, on insert dans l'ordre
	if slotIndex > 2:
		slotIndex = 0
	assign_gadget_to_slot(new_gadget, slotIndex)
	slotIndex += 1
	return false # Retourne false si aucun slot n'est libre

func _unhandled_input(event: InputEvent) -> void:
	for slot in slots:
		# Vérifier que le slot contient un gadget
		if slot.gadget != null and event.is_action_pressed(slot.input_name):
			
			# Éteindre les autres gadgets actifs
			for other_slot in slots:
				var other_g = other_slot.gadget
				if other_g and other_g != slot.gadget and other_g.is_active:
					other_g.stop_gadget()
					other_g.is_active = false
					
			# Utiliser le gadget
			if slot.gadget.unlock:
				slot.gadget.try_use(ship)
			break
