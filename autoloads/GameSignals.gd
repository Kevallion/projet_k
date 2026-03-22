extends Node

@warning_ignore("unused_signal")
signal gadgetAssigned(slot_index: int, gadget: Gadget, key: String)
@warning_ignore("unused_signal")
signal gadgetActivated(slot_index: int, isActive: bool)
@warning_ignore("unused_signal")
signal request_equip_gadget(gadget_name: String)
