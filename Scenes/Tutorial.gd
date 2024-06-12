extends Node3D


const DIALOGO_1: Array[String] = [
	#"Mooshy...",
	#"Mooshy...",
	#"MOOSHY !!!",
	#"Sei vivo, non posso crederci!
	#Ehm...cioè, certo che posso crederci, dopotutto sono stato io a darti vita.",
	#Benvenuto al mondo Mooshy! Io sono Garghamel, lo Gnomo Stregone di MooshValley e... bhe... tuo creatore.",
	#"Non c'è tempo per parlare, presto!
	#L'armata dei cinghiali è riuscita a sfondare la grande porta. Saranno qui a momenti!",
	"Riesci a muoverti? Sai come si fa?"
]
var dialogo_1_finito = false
var parte1_finita = false
var parte2_finita = false

const DIALOGO_2: Array[String] = [
	#"Incredibile...",
	#"Ehm...cioè, come volevasi dimostrare, riesci a muoverti.
	#Dopotitto sono stato io a darti vita.",
	#"MOOSHY !!!
	#Per combattere l'armata dei cinghiali ti serviranno delle armi...",
	#"I cinghiali usano armi da fuoco... Tieni questo martello!
	#Certo sarà difficile colpire qualcuno da distanza ravvicinata, ma almeno non dovrai preoccuparti delle munizioni.",
	"Eh eh..."
]
var dialogo_2_finito = false
var parte3_finita = false
var parte4_finita = false

const DIALOGO_3: Array[String] = [
	#"EHI!!! ATTENTO CON QUEL COSO!!!",
	#"Fantastico Mooshy...sembri più forte di quanto mi aspettassi.
	#Che sia davvero tu l'ultima speranza di MooshValley?",
	#"MOOSHY !!!
	#Puoi essere anche fortissimo, ma i cinghiali sono abili soldati...e hanno armi da fuoco...",
	#"...",
	#"MA TRANQUILLO!!! 
	#Tramite la mia magia sono riuscito a rubare loro alcune armi, ma sono troppo pensanti per me...sono uno gnomo ricordi?",
	"Prendile tu!! 
	Avanti... prova a sparare."
]
var dialogo_3_finito = false
var parte5_finita = false
var parte6_finita = false
var parte7_finita = false


var message_on_screen = false

enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET,
	HAMMER
}

func _ready():
	
	GlobalVar.movimento_sbloccato = false
	GlobalVar.sparare_sbloccato = false
	GlobalVar.curarsi_sbloccato = false
	GlobalVar.radial_sbloccato = false
	
	GlobalVar.livello = 0
	GlobalVar.player_health = 100
	GlobalVar.ammo_storage_total = {
		ammo_type.PISTOL_BULLET: 50,		#50,
		ammo_type.SHOTGUN_BULLET: 15,		#15
		ammo_type.MACHINEGUN_BULLET: 75		#75
	}
	GlobalVar.ammo_magazine = {
		ammo_type.PISTOL_BULLET: 15,
		ammo_type.SHOTGUN_BULLET: 1,
		ammo_type.MACHINEGUN_BULLET: 25
	}
	GlobalVar.current_bullet_type = ammo_type.HAMMER
	GlobalVar.heart_inventory = 1



func _process(_delta):
	if !dialogo_1_finito:
		tutorial_movimento()
	elif !dialogo_2_finito:
		tutorial_martello()
	elif !dialogo_3_finito:
		tutorial_armi()


func tutorial_movimento():
	if !parte1_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_1)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte1_finita = true
	
	if parte1_finita and !parte2_finita:
		if !message_on_screen:
			DialogueManager.show_command_label("Premi W, A, S, D, MAIUSC e SPACE per muoverti, correre e saltare.")
			message_on_screen = true
		
		if Input.is_action_pressed("down") || Input.is_action_pressed("sprint") ||Input.is_action_pressed("jump") ||Input.is_action_pressed("up") ||Input.is_action_pressed("right") ||Input.is_action_pressed("left"): 
			GlobalVar.movimento_sbloccato = true
			DialogueManager.end_command_label()
			message_on_screen = false
			parte2_finita = true
			DialogueManager.is_dialogue_finished = false
			dialogo_1_finito = true


func tutorial_martello():
	if !parte3_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_2)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte3_finita = true
	
	if parte3_finita and !parte4_finita:
		GlobalVar.sparare_sbloccato = true
		
		if !message_on_screen:
			DialogueManager.show_command_label("Fai 'click' sul tasto sinistro del mouse per attaccare col martello.")
			message_on_screen = true
		
		if Input.is_action_pressed("shoot"): 
			DialogueManager.end_command_label()
			message_on_screen = false
			parte4_finita = true
			DialogueManager.is_dialogue_finished = false
			dialogo_2_finito = true


func tutorial_armi():
	if !parte5_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_3)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte5_finita = true
	
	if parte5_finita and !parte6_finita:
		GlobalVar.radial_sbloccato = true
		
		if !message_on_screen:
			DialogueManager.show_command_label("Premi il tasto 'TAB⇆' per aprire l'inventario delle armi e cambiare arma.")
			message_on_screen = true
		
		if GlobalVar.current_bullet_type != GlobalVar.ammo_type.HAMMER:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte6_finita = true
			
	if parte6_finita and !parte7_finita:
		GlobalVar.radial_sbloccato = true
		
		if !message_on_screen:
			DialogueManager.show_command_label("Fai 'click' sul tasto sinistro del mouse per sparare.")
			message_on_screen = true
		
		if Input.is_action_pressed("shoot"):
			DialogueManager.end_command_label()
			message_on_screen = false
			parte7_finita = true
			DialogueManager.is_dialogue_finished = false
			dialogo_3_finito = true
