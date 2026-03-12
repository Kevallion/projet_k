##classe pour gérer le gadget actif.
class_name gagetManager extends Node2D
@onready var ship = get_parent()
@export var gadgetActives : Array[Gadget]

const  input_1 = "gadget_1"
const  input_2 = "gadget_2"
const  input_3 = "gadget_3"

var input_names = [input_1,input_2,input_3]
class Slot:
	var input_name : String
	var gadget : Gadget

var slots : Array[Slot] = []

func _ready() -> void:
	##on verifie qu'on n'a pas plus de 3 gadget.
	var max_slots : int = min(gadgetActives.size(), input_names.size())
	
	for index in max_slots:
		var slot := Slot.new()
		slot.input_name = input_names[index]
		slot.gadget = gadgetActives[index]
		slots.append(slot)
			

func _unhandled_input(event: InputEvent) -> void:
	for slot in slots:
		if event.is_action_pressed(slot.input_name):
			if slot.gadget:
				slot.gadget.try_use(ship)
		
