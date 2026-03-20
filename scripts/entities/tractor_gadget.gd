class_name TractorGadget extends Gadget

@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var line_2d: Line2D = %Line2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


@export var pullForceToward: float = 4.0
@export var pushForceMe : float = 100.0
var cible : Node2D

enum attractionMode  {TOWARD_TARGET, TOWARD_ME}
var current_mode := attractionMode.TOWARD_TARGET

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if ship:
		self.rotation = ship.sprite.rotation
	
	if ray_cast_2d.is_colliding():
		var collider := ray_cast_2d.get_collider()
		if collider is SpaceObject:
			cible = collider
		elif not collider or not collider is SpaceObject:
			cible = null
			
	if is_active and cible:
		match current_mode:
			attractionMode.TOWARD_TARGET:
				var direction_to_pull := ship.global_position.direction_to(cible.global_position)
				ship.add_force(direction_to_pull * pullForceToward)
			attractionMode.TOWARD_ME:
				var direction_to_pull := cible.global_position.direction_to(ship.global_position)
				cible.add_force(direction_to_pull * pushForceMe)
		
## Logique de démarrage du gadget (ex: tirer un projectile, activer un buff)
func start_gadget() -> void:
	animation_player.play("on_tractor")
	
## Logique d'arrêt du gadget (ex: arrêter particules, son, effets)
func stop_gadget() -> void:
	animation_player.play("off_tractor")
	cible = null
	
func _input(event: InputEvent) -> void:
	if not is_active:
		return
	if event.is_action_pressed("switch_mode"):
		if current_mode == attractionMode.TOWARD_TARGET:
			current_mode = attractionMode.TOWARD_ME
		else:
			current_mode = attractionMode.TOWARD_TARGET
