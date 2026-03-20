## Classe qui gère les gadgets actifs du vaisseau.
## Elle associe chaque gadget à une touche d'entrée et déclenche son utilisation.
class_name GagetManager extends Node2D

## Référence vers le vaisseau (node parent)
@onready var ship = get_parent()

## Liste des gadgets actifs configurés dans l'inspecteur
@export var gadgetActives : Array[Gadget]

## Références vers les slots UI (si utilisés pour afficher les gadgets)
var ui_slots : Array[GadgetUI]

## Actions d'input associées aux gadgets
const input_1 = "gadget_1"
const input_2 = "gadget_2"
const input_3 = "gadget_3"

## Liste des inputs disponibles pour les gadgets
var input_names = [input_1, input_2, input_3]

var i = 0

## Structure représentant un slot de gadget.
## Associe un gadget à un input.
class Slot:
	var input_name : String
	var gadget : Gadget
	var key : String
## Liste des slots utilisés par le manager
var slots : Array[Slot] = []


## Initialisation du manager
func _ready() -> void:
	if owner:
		await owner.ready  # attend que le node owner soit prêt
	
	_initialised_gadget()


## Initialise les gadgets et les associe aux inputs disponibles
func _initialised_gadget() -> void:
	
	# on limite le nombre de gadgets au nombre d'inputs disponibles
	var max_slots : int = min(gadgetActives.size(), input_names.size())
	var keySlots := ["Q", "S", "D"]
	
	for index in max_slots:
		var slot := Slot.new()
		
		# associe l'input correspondant
		slot.input_name = input_names[index]
		
		# assigne le gadgete
		slot.gadget = gadgetActives[index]
		slot.gadget.ship = ship
		slot.key = keySlots[index]
		slots.append(slot)
		
		# informe les autres systèmes (ex : UI)
		GameSignals.gadgetAssigned.emit(index, slot.gadget, slot.key)


## Gestion des inputs pour déclencher les gadgets
func _unhandled_input(event: InputEvent) -> void:
	for slot in slots:
		# vérifie si la touche associée au slot est pressée
		if event.is_action_pressed(slot.input_name):
			#on éteint le gadget qui est allumé
			for gadget in gadgetActives:
				if gadget != slot.gadget and gadget.is_active:
					gadget.stop_gadget()
					gadget.is_active = false
			# utilise le gadget si présent
			if slot.gadget.unlock == true:
				var used :=	slot.gadget.try_use(ship)
			break
			
func update_gadget_assigned(gadget):
	gadgetActives[i] = gadget
	if i < 2:
		i += 1
	else:i = 0
