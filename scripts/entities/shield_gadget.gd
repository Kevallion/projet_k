class_name ShieldGadget extends Gadget

@onready var area_2d: Area2D = %Area2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


signal shieldStateChanged(bool) 

# --- Méthodes à surcharger dans les classes
## Logique d'arrêt (ex: masquer les particules, couper le son)
func stop_gadget() -> void:
	sprite_2d.visible = false
	animation_player.play("off_shield")
	area_2d.monitorable = false
	area_2d.monitoring = false
	shieldStateChanged.emit(false)

## Logique de démarrage (ex: instancier un projectile, appliquer un buff)
func start_gadget() -> void:
	animation_player.play("on_shield")
	area_2d.monitorable = true
	area_2d.monitoring = true
	shieldStateChanged.emit(true)
	
