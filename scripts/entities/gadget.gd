## Classe parente pour tous les gadgets du vaisseau. 
## Gère la consommation d'énergie, le cooldown et l'état d'activation.

class_name Gadget extends Node2D

 ## Coût en énergie par seconde (pendant l'activation)
@export var energieCost := 10.0     
@export var cooldown := 2.0 : set = set_cooldown
var is_activate := false
# Référence au vaisseau qui utilise le gadget
var ship : Node2D                    

@onready var cooldownTimer : Timer = create_cooldownTimer()

## Met à jour dynamiquement le Timer si on change le cooldown (via l'inspecteur ou script)
func set_cooldown(new_value) -> void:
	cooldown = new_value
	if cooldownTimer:
		cooldownTimer.wait_time = cooldown
		
func create_cooldownTimer() -> Timer:
	var timer := Timer.new()
	timer.wait_time = cooldown
	timer.one_shot = true
	return timer

func _ready() -> void:
	set_cooldown(cooldown)
	add_child(cooldownTimer)

func _process(delta: float) -> void:
	if is_activate:
		# Consommation d'énergie en continu
		ship.energie -= energieCost * delta
		
		# Sécurité : désactivation automatique si le réservoir est vide
		if ship.energie <= 0:
			ship.energie = 0
			is_activate = false
			stop_gadget()

## Point d'entrée principal pour basculer l'état du gadget (ON/OFF)
func try_use(ship_ref) -> bool:
	# Si déjà actif, on l'éteint manuellement (Toggle)
	if is_activate:
		is_activate = false
		stop_gadget()
		return true
	
	# Tentative d'activation : vérification du cooldown et des ressources
	else:
		if not cooldownTimer.is_stopped():
			return false # Encore en recharge
		if ship_ref.energie < energieCost:
			return false # Pas assez de jus pour démarrer
		
		# Initialisation de l'activation
		self.ship = ship_ref
		is_activate = true
		start_gadget()
		cooldownTimer.start()
		return true
		
	return false

# --- Méthodes à surcharger dans les classes
## Logique d'arrêt (ex: masquer les particules, couper le son)
func stop_gadget() -> void:
	pass

## Logique de démarrage (ex: instancier un projectile, appliquer un buff)
func start_gadget() -> void:
	pass
