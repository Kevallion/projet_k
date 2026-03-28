class_name Level extends Node2D

##fonction à appeler quand un niveau est completer
signal levelCompleted()
@export var musicToPlay : AudioStream
@export var ambianceMusicToPlay : AudioStream
@onready var dialogNode = %DialogNode
@onready var player = $Player

func _physics_process(_delta: float) -> void:
	script_progression()

func _ready() -> void:
	levelCompleted.connect(_on_level_completed)
	if musicToPlay:
		AudioManager.play(musicToPlay,&"Music")
	if ambianceMusicToPlay:
		AudioManager.play(ambianceMusicToPlay,&"Ambiance")

func _on_level_completed() -> void:
	pass
	
func script_progression():
	if dialogNode.actId == 2 and dialogNode.chapterId == 1 and player.find_compo("shield_compo1", 1):
		dialogNode.open_current_dialog()
		dialogNode.finish_act()
	if dialogNode.actId == 7 and dialogNode.chapterId == 0 and player.find_compo("tractor_compo1", 1):
		dialogNode.open_current_dialog()
		dialogNode.finish_act()
	if dialogNode.actId == 9 and dialogNode.chapterId == 0 and player.find_compo("tractor_compo1", 1) and player.find_compo("tractor_compo2", 1):
		dialogNode.open_current_dialog()
		dialogNode.finish_act()
