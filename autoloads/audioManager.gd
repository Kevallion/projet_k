# Fichier: audio_manager.gd
# Rôle: Gère la lecture de tous les effets sonores du jeu de manière optimisée.
# Il fonctionne comme un "pool" de lecteurs audio (AudioStreamPlayer).
# Au lieu de créer un nouveau nœud pour chaque son, il réutilise les lecteurs
# qui ont fini de jouer. Si tous les lecteurs sont occupés, il en crée un
# nouveau dynamiquement. Cela évite la création et la suppression constantes de nœuds.

extends Node

## variables qui va contenir tout nos audioStream
var audio_players: Array[AudioStreamPlayer] = []

##nombre d'audioStreamPlayer créer au démarage
var initial_pool_size: int = 8 

func _ready() -> void:
	for i in initial_pool_size:
		_create_new()

## Joue un son avec variation de pitch optionnelle (compris entre entre 0.1 et 0.5 max)
func play(stream: AudioStream, bus_name: StringName = &"Master", volume_db: float = 0.0, pitch_randomness: float = 0.0) -> void:
	var audio_player = _get_available_audio_player()
	audio_player.stream = stream
	audio_player.bus = bus_name
	audio_player.volume_db = volume_db
	
	# Variation aléatoire
	audio_player.pitch_scale = 1.0 + randf_range(-pitch_randomness, pitch_randomness)
	
	audio_player.play()

func _get_available_audio_player() -> AudioStreamPlayer:
	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player
	return _create_new()

func _create_new() -> AudioStreamPlayer:
	var audio_player := AudioStreamPlayer.new()
	add_child(audio_player)
	audio_players.append(audio_player)
	return audio_player
