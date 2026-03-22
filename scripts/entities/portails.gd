extends Area2D

var exit_portal : Node2D = null
var is_cooldown := false # Évite le ping-pong infini

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and exit_portal and not is_cooldown:
		# On active le cooldown de la sortie pour ne pas être renvoyé direct
		exit_portal.start_cooldown()
		
		# On déplace le vaisseau
		body.global_position = exit_portal.global_position


func start_cooldown() -> void:
	is_cooldown = true
	await get_tree().create_timer(0.2).timeout # Temps très court pour laisser sortir le vaisseau
	is_cooldown = false
