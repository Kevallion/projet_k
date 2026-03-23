extends Control

@onready var questLabel = %RichTextLabel
@onready var dialogPanel = $CanvasLayer/Panel
@onready var dialogLabel = $CanvasLayer/Panel/RichTextLabel

var currentDialogArray
var currentDialogPos = 0
var dialogOpen = false
var actId = 0
var chapterId = 0

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dialogOpen:
		get_tree().paused = true
	if dialogOpen and (Input.is_action_just_pressed("switch_mode") or Input.is_action_just_pressed("left_click")):
		continue_dialog()
	
	
func open_dialog(_actId: int, _dialogId: int):
	if get_dialog(_actId, _dialogId):
		dialogPanel.visible = true
		currentDialogPos = 0
		update_dialog(currentDialogPos)
		dialogOpen = true
	
func update_dialog(_currentDialogPos: int):
	dialogLabel.text = currentDialogArray[_currentDialogPos][1]

func continue_dialog():
	if currentDialogPos+1 < currentDialogArray.size():
		currentDialogPos = currentDialogPos+1
		update_dialog(currentDialogPos)
	else:
		close_dialog()
		chapterId += 1

func get_dialog(_actId: int, _chapterId: int):
	currentDialogArray = null
	match _actId:
		0:
			match _chapterId:
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
						[1, "Prends vers la droite, en direction de cette étoile, on devrait trouver la station pas loin
Penses bien à garder un oeil sur le radar"]
			]
			
		1:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Voila la station, allons remplir le [color=cd7eff][b]Réservoir[/b][/color]"],
					]
				1:
					currentDialogArray = [
						[1, "Salut Shplok ! Tu peux me faire le plein ?"],
						[2, "Eglagipouak flexindr plarp sibadi walbat !"],
						[1, "Haha arrète tu vas me faire rougir !\nMoi aussi ça me fait plaisir de te voir\nT'aurais pas des infos croustillantes pour moi par hasard ?"],
						[2, "Vitakrit mo pilorgalep justrij bu daxlopmeta"],
						[1, "Ah ? Je vais aller voir ça, merci !\n A tout à l'heure sans doute"],
					]
				2:
					currentDialogArray = [
						[0, "..."],
						[1, "... ?!"],
						[0, "Il a dit quoi ?"],
						[1, "Ah mais tu comprends pas le Skrolbuk ? Tu débarques d'où toi ?\n Vas y continues sur la droite et surveilles bien le radar"]
					]
		2:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Oh un [color=white]Générateur[/color] de bouclier ! Le pauvre boug qui l'a perdu là aurait dû mieux s'en servir, \nmais ça sera pas perdu pour tout le monde."],
						[0, "Le [color=white]Convertisseur d'énèrgie[/color] est endommagé, si on en trouve un autre on pourra l'installer sur le vaisseau"],
						[1, "Retournons à la station voir si Shplok peut nous trouver ça"]
					]
		3:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Nous revoila, il y a bien eu un crash, on a trouvé ça !"],
						[2, "Krip shnok lupwelth blator ?"],
						[1, "Non rien d'autre d'interessant, je te ferai signe si j'en vois un. Tu n'aurais pas un [color=white]Convertisseur d'énèrgie[/color] sous la main par hasard ?"],
						[2, "Wispalak mitervistop prit, klap Pascal fouet\nBret la cirak zep"],
						[1, "Ok, je lui passerai le bonjour de ta part, merci Shplok !"]
					]
		4:
			match _chapterId:
				0:
					currentDialogArray = [
						[0, "..."],
						[1, "Je vais pas te faire la traduction à chaque fois, ça va vite me gonfler\nRegarde le panneau de quête au pire"],
						[0, "..."]
					]
				1:
					currentDialogArray = [
						[1, "Salut, c'est toi Pascal ? Shplok m'a dit que t'avais peut être un convertisseur sous la main ?"],
						[3, "Osdroenae subsederat extimas partes, novum parumque aliquando temptatum commentum"],
						[1, "Ok, je devrais pouvoir te trouver ça"]
					]
		5:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Voila ce que tu nous as demandé"],
						[3, "Proinde concepta rabie saeviore, quam desperatio incendebat et fames,\namplificatis viribus ardore incohibili in excidium urbium matris"],
						[1, "Merci Pascal"]
					]
			
	return currentDialogArray

func close_dialog():
	dialogPanel.visible = false
	get_tree().paused = false
	dialogOpen = false
	update_quest()

func _on_tuto_area_body_entered(_body: Node2D) -> void:
	if actId == 0:
		open_dialog(actId, chapterId)

func _on_station_area_body_entered(_body: Node2D) -> void:
	if actId == 1 and chapterId == 0:
		open_dialog(actId,chapterId)

func _on_station_area_body_exited(_body: Node2D) -> void:
	if actId == 1 and chapterId == 2:
		open_dialog(actId,chapterId)
		actId = 2
		chapterId = -1
	if actId == 4:
		open_dialog(actId, chapterId)
		#actId = 4
		#chapterId = -1
	
func update_quest():
	if questLabel:
		questLabel.text = get_quest_text(actId, chapterId)
	
func get_quest_text(_actId, _chapterId):
	var questText = "Objectif :\n"
	questText+= "Acte : "+str(actId) + " Chapitre : " + str(chapterId)

	match _actId:
		1:
			if chapterId < 1:
				questText += "\nVa à la station\nen suivant le radar"
			else :
				questText += "\nSpwila krit \nner lo daxlopmeta"
		2:
			#if chapterId >= 0:
			questText += "\nTrouve la planète\nà droite de la station"
		3:
			questText += "\nRetourne à la Station"
		4:
			if chapterId < 0:
				questText += "\nGleps Pascal\nla cirak zep"
			else :
				questText += "\nTrouve Pascal\nau Nord Ouest de la station"
		5:
			questText += "\nRamener 10 débris\nà Pascal"
	return questText

func _on_tuto_ending_body_exited(_body: Node2D) -> void:
	if actId == 0:
		open_dialog(0,3)
		actId = 1
		chapterId = -1

func _on_planet_area_1_body_entered(_body: Node2D) -> void:
	if actId == 2 and chapterId == 0:
		open_dialog(actId,chapterId)
		actId = 3
		chapterId = -1
		
