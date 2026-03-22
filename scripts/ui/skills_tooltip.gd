class_name SkillsTooltip extends Control

@onready var gadget_name: Label = %gadget_name
@onready var rich_text_label: RichTextLabel = %RichTextLabel

func set_gadget(gadget: Gadget) -> void:
	gadget_name.text = gadget.name_label
	rich_text_label.text = gadget.description
	
func set_options(name: String, description: String):
	gadget_name.text = name
	rich_text_label.text = description
