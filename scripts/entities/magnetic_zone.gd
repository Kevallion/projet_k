@tool
class_name MagneticZone extends EnvironmentZone


@export_group("Magnetic Settings")
## Énergie drainée par seconde (Max joueur: 300)
@export var energy_drain := 20.0 

func _ready() -> void:
	super._ready()

func _apply_effect(body: Node2D, delta: float) -> void:
	# 1. Impact sur l'énergie du vaisseau
	if "energy" in body:
		body.energy = max(0.0, body.energy - energy_drain * delta)
	
	# 2. Brouillage du radar via les signaux


func _on_body_exited(body: Node2D) -> void:
	super._on_body_exited(body)
	if body is Player:
		# On arrête le brouillage quand le joueur sort de la zone
		pass
