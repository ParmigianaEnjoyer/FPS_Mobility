extends Node3D

@onready var soldier_scene = preload("res://Enemy/enemy.tscn")
@onready var tank_scene = preload("res://Enemy/tank_enemy.tscn")
@onready var minion_scene = preload("res://Enemy/minion_enemy.tscn")
@onready var heart_scene = preload("res://Drops/heart_drop.tscn")
@onready var ammo_scene = preload("res://Drops/ammo_drop.tscn")

var message_on_screen: bool
var risorse_spawnate: bool
var area_attraversata: bool

const DIALOGO_1: Array[String] = [
	#"Mooshy! sei arrivato?",
	#"Ti starai chiedendo come faccia a parlarti anche se non ci sono...
	#Telepatia, ovvio.",
	#"Ti trovi all'ingresso dell'Antica Foresta, segui il sentiero, più avanti troverai un piccolo accampamento pieno di soldati nemici.",
	#"FALLI FUORI!!
	#E sta attento a non farti mangaire.",
	"Eh eh...",
]

var dialogo_1_finito: bool
var parte1_finita: bool
var parte2_finita: bool
var parte3_finita: bool

const DIALOGO_2: Array[String] = [
	#"Ben fatto Mooshy!",
	#"Ehi guarda. 
	#Erano accampati proprio qui, ci sono delle tende e un fuoco.",
	#"...",
	#"Questa zona sembra troppo piccola per essere il loro campo base, continua a seguire il sentiero.
	#Il resto di loro si trova sicuramente lì",
	#"VAI MOOSHY, AMMAZZALI!",
	"Ah, ma prima... controlla se ci sono risorse vicino alle tende, magari sei un fungo fortunato."
]

const DIALOGO_3: Array[String] = [
	"MOOSHY!! 
	ATTENTO!!",
	"È UNA TRAPPOLA!!",
	"Annientali..."
]


enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET,
	HAMMER
}

func _ready():
	
	$Staccionata.attiva()
	$Staccionata2.attiva()
	
	message_on_screen = false
	risorse_spawnate = false
	dialogo_1_finito = false
	parte1_finita = false
	parte2_finita = false
	parte3_finita = false
	area_attraversata = false
	
	DialogueManager.restart()
	GlobalVar.num_nemici_morti_nel_livello = 0
	GlobalVar.livello = 1
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
	if !dialogo_1_finito:
		
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
				DialogueManager.is_dialogue_finished = false
			
		if parte1_finita and !parte2_finita:
			if GlobalVar.num_nemici_morti_nel_livello == 14:
				
				if !message_on_screen: 
					DialogueManager.show_command_label("Premi Q per proseguire...")
					message_on_screen = true
					
					if !DialogueManager.is_dialogue_finished:
						DialogueManager.start_dialog(DIALOGO_2)
					
				if DialogueManager.is_dialogue_finished:
					sawn_risorse_su_tronchi()
					$Staccionata.disattiva()
					$Staccionata2.disattiva()
					DialogueManager.end_command_label()
					message_on_screen = false
					parte2_finita = true
					DialogueManager.is_dialogue_finished = false
		
		if parte2_finita and area_attraversata and !parte3_finita:
			if !parte3_finita:
				if !message_on_screen: 
					DialogueManager.show_command_label("Premi Q per proseguire...")
					message_on_screen = true
					
					if !DialogueManager.is_dialogue_finished:
						DialogueManager.start_dialog(DIALOGO_1)

				if DialogueManager.is_dialogue_finished:
					DialogueManager.end_command_label()
					message_on_screen = false
					parte3_finita = true
					DialogueManager.is_dialogue_finished = false



func sawn_risorse_su_tronchi():
	if !risorse_spawnate:
		for i in range(6):
			if i < 2:
				var heart = heart_scene.instantiate()
				var spawn_position = $Risorse_sui_tronchi.get_child(i).position
				heart.position = spawn_position
				add_child(heart)
			elif i < 6:
				var ammo = ammo_scene.instantiate()
				var spawn_position = $Risorse_sui_tronchi.get_child(i).position
				ammo.position = spawn_position
				add_child(ammo)
			
		risorse_spawnate = true


func _on_area_3d_body_entered(body):
	area_attraversata = true
	$Map/NavigationRegion3D/FirstLevel/Area_InizioOrde.queue_free()
