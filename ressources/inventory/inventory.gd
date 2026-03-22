extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem, amount: int):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += amount
	else :
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = amount
	update.emit()
		
func insert_all(_slots: Array[InvSlot]):
	for slot in _slots:
		insert(slot.item, slot.amount)

func remove(itemName: String, itemAmount: int):
	for slot in slots:
		if slot.item:
			if slot.item.name == itemName and slot.amount >= itemAmount:
				slot.amount -= itemAmount
				if slot.amount == 0:
					slot.item = null
				return true
			return false

func empty():
	for slot in slots:
		if slot.item:
			slot.item = null
			slot.amount = 0
			pass

func is_empty():
	for slot in slots:
		if slot.item:
			return false
	return true
	
