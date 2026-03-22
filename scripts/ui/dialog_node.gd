extends Node2D

var currentDialogArray
var currentDialogPos = 0
var dialogOpen = false
var dialogId = 0
@onready var rich_text_label: RichTextLabel = %RichTextLabel

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dialogOpen:
		get_tree().paused = true
	if dialogOpen and (Input.is_action_just_pressed("action") or Input.is_action_just_pressed("left_click")):
		continue_dialog()
	
	if rich_text_label:
		print("tuto")
func _on_tuto_area_body_entered(_body: Node2D) -> void:
	open_dialog(dialogId)
	dialogId += 1
	
func open_dialog(_dialogId: int):
	if get_dialog(_dialogId):
		$CanvasLayer/Panel.visible = true
		currentDialogPos = 0
		update_dialog(currentDialogPos)
		dialogOpen = true
	
func update_dialog(_currentDialogPos: int):
	$CanvasLayer/Panel/RichTextLabel.text = currentDialogArray[_currentDialogPos][1]

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
				[1, "Voici le poste de pilotage :
Les [color=white][b]flèches[/b][/color] ou [b][color=white]ZQSD[/color][/b]
pour activer les réacteurs.
Le levier vers le [color=white]Bas[/color] pour freiner et stabiliser le vaisseau."]
			]
		1:
			currentDialogArray = [ 
				[1, "La jauge à gauche sur le tableau de bord c'est le [color=cd7eff][b]Réservoir[/b][/color]
si il se vide avant qu'on n'ait atteint la station, on va être dans une merde intersidérale, et c'est pas une figure de style donc vas y molo où je recrute un autre pilote fissa"],
			]
		2:
			currentDialogArray = [
				[1, "Fais gaffe, des [color=white]débris[/color] flottants droit devant!
Approche toi doucement on va les ramasser"],
				[1, "Ça nous fera des materiaux pour [color=79ff6e][b]Réparer[/b][/color] les [color=f93533]dégats[/color] sur la coque, ça sera très utile tu verras..."],
			]
		3:
			currentDialogArray = [
				[1, "Aller fini de jouer, on va faire un tour à la station"],
				[1, "Tu vois le cadran sur ta gauche ? C'est le [color=white][b]Radar[/b][/color]
Je te préviens c'est un vieux modèle,"],
				[1, "Il n'indique pas la direction mais
la [color=white]Distance[/color] de la [color=white]Station[/color] ou la [color=white]Planète[/color] la [color=white]plus proche[/color],
Ça coute une blinde à remplacer mais on s'y habitue à la longue, t'inquiète pas"],
				[1, "Prends vers la droite, on devrait trouver la station pas loin
Penses bien à garder un oeil sur le radar"]
			]
		4:
			currentDialogArray = [
				[1, "Voila la station, allons remplir le [color=cd7eff][b]Réservoir[/b][/color]"]
			]
	return currentDialogArray

func close_dialog():
	$CanvasLayer/Panel.visible = false
	get_tree().paused = false
	dialogOpen = false
