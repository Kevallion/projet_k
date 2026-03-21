extends Node2D

var currentDialogArray
var currentDialogPos = 0
var dialogOpen = false
var dialogId = 0

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dialogOpen:
		get_tree().paused = true
	if dialogOpen and (Input.is_action_just_pressed("action") or Input.is_action_just_pressed("left_click")):
		continue_dialog()

func _on_tuto_area_body_entered(body: Node2D) -> void:
	open_dialog(dialogId)
	dialogId += 1
	
func open_dialog(dialogId: int):
	if get_dialog(dialogId):
		$CanvasLayer/Panel.visible = true
		currentDialogPos = 0
		update_dialog(currentDialogPos)
		dialogOpen = true
	
func update_dialog(currentDialogPos: int):
	$CanvasLayer/Panel/RichTextLabel.text = currentDialogArray[currentDialogPos][1]

func continue_dialog():
	if currentDialogPos+1 < currentDialogArray.size():
		currentDialogPos = currentDialogPos+1
		update_dialog(currentDialogPos)
	else:
		close_dialog()

func get_dialog(scriptId: int):
	currentDialogPos += 1
	currentDialogArray = null
	match scriptId:
		0:
			currentDialogArray = [
				[1, "[i][b]Capitaine:[/b][/i] Bienvenue à bord du [i]Sweetgum[/i] !"],
				[1, "Suis moi je vais te montrer le poste de pilotage"],
				[1, "Les commandes de direction sont :\n
- Les [color=white][b]flèches[/b][/color] à ta droite ou
- [b][color=white]ZQSD[/color][/b] si t’es de la vieille école..."],
				[1, "Et tu baisses le levier pour stabiliser le vaisseau."], 
				[1, "Je te laisse prendre en main la bête, mais vas y doucement, si la [color=purple]jauge de carburant[/color] à gauche sur le tableau de bord se vide, ça va chauffer pour ton matricule.
Il faudra qu'on passe à la station sans tarder."],
			]
		1:
			currentDialogArray = [
				[1, "Attention, des débris flottants, ralentis !"],
				[1, "On va faire d'une pierre deux coups, nettoyer l'espace et se faire des materiaux pour réparer les dégats sur la coque au passage"],
				[1, "Approche toi doucement pour les ramasser"],
			]
			
		2:
			currentDialogArray = [
				[1, "Aller fini de jouer, on va faire le plein à la station"],
				[1, "Tu vois le cadran sur ta gauche ?"],
				[1, "C'est le système de radar, par contre il est un peu pété,"],
				[1, "il indique toujours la station ou la planète la plus proche et il nous donne que la distance, pas la direction"],
				[1, "Mais ça coute une blinde à faire réparer. T'inqiète pas on s'y habitue à la longue"],
				[1, "Prends va la droite, on devrait trouver la station pas loin"]
			]
	return currentDialogArray

func close_dialog():
	$CanvasLayer/Panel.visible = false
	get_tree().paused = false
	dialogOpen = false
