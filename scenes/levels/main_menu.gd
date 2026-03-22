class_name MainMenu extends Node2D

@export var firstLevelScene : PackedScene

@onready var btn_new_game: Button = %btn_newGame
@onready var btn_exit: Button = %btn_exit
@export_file("*level.tscn") var first_level_to_lauch
@onready var snd_button: AudioStreamPlayer = %snd_button
@onready var v_box_container: VBoxContainer = %VBoxContainer
@export var sndMenu : AudioStream
func _ready() -> void:
	if sndMenu:
		AudioManager.play(sndMenu,&"Music")
	
	btn_exit.pressed.connect(func() -> void:
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.location.reload();")
		else:
			get_tree().quit())
	
	for button: Button in v_box_container.get_children():
		button.mouse_entered.connect(func() -> void:
			snd_button.play()
			
		)
		button.pressed.connect(func() -> void:
			AudioManager.stop(sndMenu)
			snd_button.play()
			_change_to_next_level()
		)

func _change_to_next_level() -> void:
	if first_level_to_lauch.is_empty():
		get_tree().quit()
		return 
	
	var result := get_tree().change_scene_to_packed(firstLevelScene)
	if result != OK:
		push_error("Failed to load level: " + first_level_to_lauch + ". Quitting the game")
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.location.reload();")
		else:
			get_tree().quit()
