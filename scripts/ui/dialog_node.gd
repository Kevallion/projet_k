extends Control

@onready var questLabel = %RichTextLabel
@onready var questPanel = $CanvasLayer/QuestPanel

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
	
func open_current_dialog():
	if get_dialog(actId, chapterId):
		chapterId += 1
		dialogPanel.visible = true
		currentDialogPos = 0
		update_dialog(currentDialogPos)
		dialogOpen = true

func open_specific_dialog(_actId, _dialogId):
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
si il se vide avant qu'on n'ait atteint la station, on va être dans une merde intersidérale, et c'est pas une figure de style donc vas y molo ou je recrute un autre pilote fissa"],
			]
				2:
					currentDialogArray = [
						[1, "Fais gaffe, des [color=white]débris[/color] flottants droit devant!
Approche toi doucement on va les ramasser"],
				[1, "Ça nous fera des matériaux pour [color=79ff6e][b]Réparer[/b][/color] les [color=f93533]dégâts[/color] sur la coque, ça sera très utile tu verras..."],
			]
				3:
					currentDialogArray = [
						[1, "Aller fini de jouer, on va faire un tour à la [color=white]Station[/color]"],
						[1, "Tu vois le cadran sur ta gauche ? C'est le [color=white][b]Radar[/b][/color]
Je te préviens c'est un vieux modèle,"],
						[1, "Il n'indique pas la direction mais
la [color=white]Distance[/color] de la [color=white]Station[/color] ou la [color=white]Planète[/color] la [color=white]plus proche[/color],
Ça coute une blinde à remplacer mais on s'y habitue à la longue, t'inquiète pas"],
						[1, "Prends vers la droite, en direction de cette étoile, on devrait trouver la station pas loin
Penses bien à garder un oeil sur le radar"],
						[1, "Le chiffre apparait en bleu tant qu'on est en approche"],
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
						[2, "Eglagipouak flexi plarp sibadi walbat !"],
						[1, "Haha arrète tu vas me faire rougir !\nMoi aussi ça me fait plaisir de te voir\nT'aurais pas des infos croustillantes pour moi par hasard ?"],
						[2, "Vitakrit mo pilorgalep justrij bu daxlopmeta"],
						[1, "Ah ? Je vais aller voir ça, merci !\n A tout à l'heure sans doute"],
					]
		2:
			match _chapterId:
				0:
					currentDialogArray = [
						[0, "..."],
						[1, "... ?!"],
						[0, "Il a dit quoi ?"],
						[1, "Ah mais tu comprends pas le Skrolbuk ? Tu débarques d'où toi ?\n Vas y continues sur la droite et surveilles bien le radar"],
						[1, "Au moment où le chiffre se remet à descendre ça veut dire qu'on a capté un nouveau signal"]
					]
				1:
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
						[1, "Non rien de ce genre, je te ferai signe si j'en trouve un.\nTu n'aurais pas un [color=white]Convertisseur d'énèrgie[/color] sous la main par hasard ?"],
						[2, "Wispalak mitervistop prit, klap Pascal fouet\nBret la cirak zep"],
						[1, "Ok, je lui passerai le bonjour de ta part, merci Shplok !"]
					]
		4:
			match _chapterId:
				0:
					currentDialogArray = [
						[0, "..."],
						[1, "Je vais pas te faire la traduction à chaque fois,\nça va vite me gonfler.\nRegarde juste le panneau de quête comme tout le monde"],
						[0, "..."]
					]
				1:
					currentDialogArray = [
						[1, "Salut, Pascal ! Tu as le bonjour de Shplok !\n Il paraît que t'as un [color=white]Convertisseur d'énèrgie[/color] en sock ?"],
						[3, "Osdroenae subsederat extimas partes, novum parumque aliquando temptatum commentum"],
						[1, "Ok, marché conclu, on va te trouver ça"]
					]
		5:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Et voila, 10 pièces détachées en échange du\n[color=white]Convertisseur d'énèrgie[/color] et un demi plein !"],
						[3, "Proinde concepta rabie saeviore,\nquam desperatio incendebat et fames,\namplificatis viribus ardore incohibili\nin excidium urbium matris"],
						[1, "Merci Pascal, toujours un plaisir de faire affaire"]
					]
		6:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Parfait ! Ça va nous permettre d'aller faire un tour à Gnolbark"],
						[1, "Le [color=white]Bouclier[/color] nous protègera des [i]radiations[/i]"],
						[1, "Mais ça consomme aussi de l'[color=yellow]Énergie[/color]\nDonc utilise le avec parcimonie"],
					]
		7:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Ah mais c'est pas un [color=white]Canon à Ion[/color] ce que je vois là ?"],
						[1, "Ça pourrait interesser Shplok, retournons le voir"]
					]
		8:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "C'est encore nous, regarde ce que j'ai là !"],
						[2, "Grep la blazor ! Egrikblok mes li crapouet !\nBet miskra patina gos baloup"],
						[1, "Reçu 5/5"],
					]
		9:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Plus qu'à installer ça"],
					]
		10:
			match _chapterId:
				0:
					currentDialogArray = [
						[1, "Super, qu'est ce qu'on fait maintenant ?"],
					]
			
	return currentDialogArray

func close_dialog():
	dialogPanel.visible = false
	get_tree().paused = false
	dialogOpen = false
	update_quest()

func _on_tuto_area_body_entered(_body: Node2D) -> void:
	if actId == 0:
		open_current_dialog()

func _on_station_area_body_entered(_body: Node2D) -> void:
	if actId == 1 and chapterId == 0:
		open_current_dialog()

func _on_station_area_body_exited(_body: Node2D) -> void:
	if actId == 2 and chapterId == 0:
		open_current_dialog()
	if actId == 4 and chapterId == 0:
		open_current_dialog()
	
func update_quest():
	if questLabel:
		questLabel.text = get_quest_text(actId, chapterId)
	
func get_quest_text(_actId, _chapterId):
	var questText = "Objectif :\n"
	questText+= "Acte : "+str(actId) + " Chapitre : " + str(chapterId)

	#questPanel.visible = true
	match _actId:
		1:
			questPanel.visible = true
			questText += "\nVa à la station\nen suivant le radar"
		2:
			if chapterId == 0:
				questText += "\nSpwila krit \nner lo daxlopmeta"
			else:
				questText += "\nTrouve la planète\nà droite de la station"
		3:
			questText += "\nRetourne à la Station"
		4:
			if chapterId == 0:
				questText += "\nGleps Pascal\nla cirak zep"
			else :
				questText += "\nTrouve Pascal\nau Nord Ouest de la station"
		5:
			questText += "\nRamener 10 débris\nà Pascal"
		6:
			questText += "\nFabriquer le Bouclier"
		7:
			questText += "\nExplorer Gnolbark\nau Sud de la Station"
		8:
			questText += "\nParler à Shplok\nà la Station"
		9:
			questText += "\nTrouver l'aimant\nPour fabriquer\nle Rayon Tracteur"
		10:
			questText += "\nFabriquer le\nRayon Tracteur"
		11:
			questText += "\nAutre chose"
	return questText

func finish_act():
	actId += 1
	chapterId = 0

func _on_tuto_ending_body_exited(_body: Node2D) -> void:
	if actId == 0:
		open_specific_dialog(0,3)
		finish_act()

		
