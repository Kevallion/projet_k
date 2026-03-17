## Classe parente pour tous les gadgets du vaisseau.
## Gère la consommation d'énergie, le cooldown et l'état d'activation.
class_name Gadget extends Node2D

## Signal émis lorsqu'un gadget est utilisé
signal used

## Coût en énergie par seconde pendant l'activation
@export var energyCost := 10.0     

## Temps de recharge avant une nouvelle utilisation
@export var cooldown := 2.0 : set = set_cooldown

## Icône du gadget (utilisée par l'UI)
@export var icon : Texture2D
@export var name_label : String = ""
@export_multiline var description : String
## Indique si le gadget est actuellement actif
var is_active := false

## Référence au vaisseau qui utilise le gadget
var ship : Node2D                    

## Timer utilisé pour gérer le cooldown
@onready var cooldownTimer : Timer = create_cooldownTimer()


## Met à jour dynamiquement le Timer si le cooldown change
func set_cooldown(new_value) -> void:
	cooldown = new_value
	
	# met à jour le timer si celui-ci existe déjà
	if cooldownTimer:
		cooldownTimer.wait_time = cooldown


## Crée et configure le Timer de cooldown
func create_cooldownTimer() -> Timer:
	var timer := Timer.new()
	timer.wait_time = cooldown
	timer.one_shot = true
	return timer


## Initialisation du gadget
func _ready() -> void:
	set_cooldown(cooldown)
	add_child(cooldownTimer)


## Gestion de la consommation d'énergie pendant l'activation
func _process(delta: float) -> void:
	if is_active:
		
		# consommation d'énergie continue
		ship.energy -= energyCost * delta
		
		# sécurité : arrêt automatique si l'énergie est vide
		if ship.energy <= 0:
			ship.energy = 0
			is_active = false
			stop_gadget()


## Point d'entrée principal pour utiliser un gadget
## Gère l'activation / désactivation et les vérifications nécessaires
func try_use(ship_ref) -> bool:
	
	# si le gadget est déjà actif, on le désactive (comportement toggle)
	if is_active:
		is_active = false
		stop_gadget()
		return true
	
	# tentative d'activation
	else:
		
		# vérifie si le cooldown est terminé
		if not cooldownTimer.is_stopped():
			return false
		
		# vérifie si le vaisseau a assez d'énergie
		if ship_ref.energy < energyCost:
			return false
		
		# initialise l'activation
		self.ship = ship_ref
		is_active = true
		
		start_gadget()
		
		used.emit()
		
		# démarre le cooldown
		cooldownTimer.start()
		
		return true
		
	return false


# --- Méthodes à surcharger dans les classes enfants ---


## Logique d'arrêt du gadget (ex: arrêter particules, son, effets)
func stop_gadget() -> void:
	pass


## Logique de démarrage du gadget (ex: tirer un projectile, activer un buff)
func start_gadget() -> void:
	pass
