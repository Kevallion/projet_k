## Gadget permettant de placer deux portails reliés entre eux.
## Le joueur place d'abord le portail A puis le portail B, dans une distance maximale.
class_name PortalGadget extends Gadget

## Distance de placement du portail A devant le vaisseau
@export var spawnDistance : float = 100.0

## Distance de placement du portail B devant le vaisseau
@export var spawbDistancePortalB : float = 700.0

## Références vers les portails créés
var portal_a: Node2D
var portal_b: Node2D

## Scène des portails
var portalScene := preload("res://scenes/entities/portails.tscn")

## Scène du placeholder affiché pendant le placement
var portalPlaceholderScene := preload("res://scenes/ui/portails_placeholder.tscn")

## Instance du placeholder
var portalPlaceholder : Node2D

## États possibles du gadget pendant le placement
enum State {PLACING_A, PLACING_B, ACTIVE}
var currentState := State.PLACING_A

## Distance maximale autorisée entre les deux portails
@export var maxPortalDistance : float = 1500.0


## Met à jour la position du placeholder pendant le placement
func _physics_process(_delta: float) -> void:
	if portalPlaceholder:
		
		# placement du portail A devant le vaisseau
		if currentState == State.PLACING_A:
			portalPlaceholder.global_position = ship.forward.global_position
		
		# placement du portail B à une distance fixe dans la direction du vaisseau
		elif currentState == State.PLACING_B:
			var direction : Vector2 = ship.global_position.direction_to(ship.forward.global_position)
			var newPosition = ship.global_position + (direction.normalized() * spawbDistancePortalB)
			portalPlaceholder.global_position = newPosition
		
	# vérifie si la distance entre A et le placeholder est valide
	if currentState == State.PLACING_B and portal_a:
		var dist = portal_a.global_position.distance_to(portalPlaceholder.global_position)
		
		# feedback visuel : blanc si valide, rouge si trop loin
		portalPlaceholder.modulate = Color(1,1,1,0.5) if dist <= maxPortalDistance else Color(1,0,0,0.5)


## Activation du gadget : crée le placeholder de placement
func start_gadget() -> void:
	if portalPlaceholder == null:
		portalPlaceholder = portalPlaceholderScene.instantiate()
		get_tree().current_scene.add_child(portalPlaceholder)
	
	portalPlaceholder.global_position = ship.forward.global_position
	currentState = State.PLACING_A


## Désactivation du gadget : nettoie les éléments temporaires
func stop_gadget() -> void:
	
	# supprime le placeholder
	if portalPlaceholder:
		portalPlaceholder.queue_free()
		portalPlaceholder = null
	
	# supprime le portail A si aucun portail B n'est connecté
	if portal_a:
		if not portal_a.exit_portal:
			portal_a.queue_free()
			portal_a = null


## Instancie un portail à une position donnée
func spawn_portal(pos: Vector2) -> Node2D:
	var new_portal : Node2D = portalScene.instantiate()
	new_portal.global_position = pos
	
	get_tree().current_scene.add_child(new_portal)
	
	return new_portal


## Confirme le placement du portail courant
func confirm_placement() -> void:
	var spawn_pos = calculate_spawn_position()
	
	# placement du portail A
	if currentState == State.PLACING_A:
		portal_a = spawn_portal(spawn_pos)
		currentState = State.PLACING_B
	
	# tentative de placement du portail B
	elif currentState == State.PLACING_B:
		var dist = portal_a.global_position.distance_to(spawn_pos)
		
		if dist <= maxPortalDistance:
			portal_b = spawn_portal(spawn_pos)
			
			# relie les deux portails
			portal_a.exit_portal = portal_b
			portal_b.exit_portal = portal_a
			
			currentState = State.ACTIVE
			
			portalPlaceholder.queue_free()
			stop_gadget()
		else:
			print("trop loin")


## Calcule la position actuelle de placement
func calculate_spawn_position() -> Vector2:
	if portalPlaceholder:
		return portalPlaceholder.global_position
	
	return Vector2.ZERO


## Gestion de l'input pour confirmer le placement
func _input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed("place_portal"):
		confirm_placement()
