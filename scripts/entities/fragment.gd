extends RigidBody2D

@export var item: InvItem
var player = null
@onready var sprite = $FragmentSprite
@onready var frames = sprite.texture.get_width() / sprite.region_rect.size.x
var rotation_force = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_index = randi_range(0, frames - 1)
	sprite.region_rect.position.x = random_index * sprite.region_rect.size.x
	rotation_force.randomize()
	rotation_force = rotation_force.randi_range(-3, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if rotation_force == 0:
		rotation += 0.015
	else:
		rotation += ((float(rotation_force))) / 100

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect(item)
		self.queue_free()
