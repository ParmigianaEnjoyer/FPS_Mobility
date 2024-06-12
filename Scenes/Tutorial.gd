extends Node3D


const DIALOGO_1: Array[String] = [
	#"Mooshy...",
	#"Mooshy...",
	#"MOOSHY !!!",
	#"Sei vivo, non posso crederci!
	#Ehm...cioè, certo che posso crederci, dopotutto sono stato io a darti vita.",
	#"Non c'è tempo per parlare, presto!
	#L'armata dei cinghiali è riuscita a sfondare la grande porta. Saranno qui a momenti!",
	"Riesci a muoverti? Sai come si fa?"
]
var dialogo_1_finito = false

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


func _process(delta):
	print(dialogo_1_finito)
	if !dialogo_1_finito:
		tutorial_movimento()
	else:
		if !message_on_screen:
			DialogueManager.show_command_label("Premi W, A, S, D, MAIUSC e SPACE per muoverti, correre e saltare.")
			message_on_screen = true
		
		if Input.is_action_pressed("down") || Input.is_action_pressed("sprint") ||Input.is_action_pressed("jump") ||Input.is_action_pressed("up") ||Input.is_action_pressed("right") ||Input.is_action_pressed("left"): 
			GlobalVar.movimento_sbloccato = true


func tutorial_movimento():
	if !DialogueManager.is_dialogue_finished:
		DialogueManager.start_dialog(DIALOGO_1)
	else:
		dialogo_1_finito = true
