extends CanvasLayer

@onready var start_texture: TextureRect = %startTexture

#passer le joueur pour faire défilé les étoile en fonction du player
@export var target_node : Player
@onready var space_background: TextureRect = %space_background

var startOffsetVelocity := Vector2.ZERO
func _process(delta: float) -> void:
	if target_node:
		var shipVelocity := target_node.velocity
		startOffsetVelocity += shipVelocity * delta
		start_texture.material.set_shader_parameter("offset", startOffsetVelocity)
		var spaceBackgroundVelocity := Vector3(startOffsetVelocity.x,startOffsetVelocity.y,0.0) / 10.0
		space_background.texture.noise.offset = spaceBackgroundVelocity
		
		
