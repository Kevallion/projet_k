##cette classe permet d'affichier des touches dans la scene de jeu
class_name VisualShowKey extends Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var defaultTexture : Texture2D
@export var pressedTexture : Texture2D

##function qui se lance quand le joueur appuie sur la touche
func play_animation_pressed() -> void:
	animation_player.stop()
	if pressedTexture:
		self.texture = pressedTexture

##function pour annimer le popping
func play_animation_popping() -> void:
	animation_player.play("popping")

##function pour cacher le sprite à appuyer
func hide_key() -> void:
	visible = false 

##function pour afficher le sprite de touche à appuyer
func show_key() -> void:
	play_animation_popping()
	visible = true
	self.texture = defaultTexture

func _ready() -> void:
	visible = false
	if defaultTexture:
		self.texture = defaultTexture
	else:
		defaultTexture = self.texture
