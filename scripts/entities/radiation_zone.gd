@tool
class_name RadiationZone extends EnvironmentZone

@export_group("Radiation Settings")
## Dégâts par seconde infligés au vaisseau
@export var damage_per_second: float = 50.0


func _ready() -> void:
	super._ready()

func _apply_effect(body: Node2D, delta: float) -> void:
	# On vérifie si l'objet a une propriété 'health'
	if "health" in body:
		if body.hasShield:
			return
			
		body.health -= damage_per_second * delta
		
		# déclenche l'effet de hit visuel si disponible
		if body.has_method("take_hit") and Engine.get_frames_drawn() % 10 == 0:
			var sprite_hit = body.get_node_or_null("Sprite2D/HitFrames")
			if sprite_hit: sprite_hit.play("hit")
