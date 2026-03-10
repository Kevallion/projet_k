extends CanvasLayer

@onready var start_texture: TextureRect = %startTexture

#passer le joueur pour faire défilé les étoile en fonction du player
@export var target_node : Player

var StartOffsetVelocity := Vector2.ZERO
func _process(delta: float) -> void:
	if target_node:
		var shipVelocity := target_node.velocity
		StartOffsetVelocity += shipVelocity * delta
		start_texture.material.set_shader_parameter("offset", StartOffsetVelocity)
		
		
