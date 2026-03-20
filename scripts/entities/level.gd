class_name Level extends Node2D

##fonction à appeler quand un niveau est completer
signal levelCompleted()
@export var musicToPlay : AudioStream
@export var ambianceMusicToPlay : AudioStream

func _ready() -> void:
	levelCompleted.connect(_on_level_completed)
	if musicToPlay:
		AudioManager.play(musicToPlay,&"Music")
	if ambianceMusicToPlay:
		AudioManager.play(ambianceMusicToPlay,&"Ambiance")

func _on_level_completed() -> void:
	pass
