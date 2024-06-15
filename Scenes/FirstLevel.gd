extends Node3D

@onready var soldier_scene = preload("res://Enemy/enemy.tscn")
@onready var tank_scene = preload("res://Enemy/tank_enemy.tscn")
@onready var minion_scene = preload("res://Enemy/minion_enemy.tscn")
@onready var heart_scene = preload("res://Drops/heart_drop.tscn")
@onready var ammo_scene = preload("res://Drops/ammo_drop.tscn")
@onready var marius_scene = preload("res://Enemy/boss_marius.tscn")
@onready var player = $Player

var message_on_screen: bool
var risorse_spawnate: bool
var area_attraversata: bool

const DIALOGO_1: Array[String] = [
	"Mooshy! sei arrivato?",
	"Ti starai chiedendo come faccia a parlarti anche se non ci sono...
	Telepatia, ovvio.",
	"Ti trovi all'ingresso dell'Antica Foresta, segui il sentiero, più avanti troverai un piccolo accampamento pieno di soldati nemici.",
	"FALLI FUORI!!
	E sta attento a non farti mangaire.",
	"Eh eh...",
]

var dialogo_1_finito: bool
var parte1_finita: bool
var parte2_finita: bool
var parte3_finita: bool
var parte4_finita: bool
var orda1_spawnata: bool
var orda2_spawnata: bool
var orda3_spawnata: bool
var parte5_finita: bool
var parte6_finita: bool
var marius_spawnato: bool
var marius

const DIALOGO_2: Array[String] = [
	"Ben fatto Mooshy!",
	"Ehi guarda. 
	Erano accampati proprio qui, ci sono delle tende e un fuoco.",
	"...",
	"Questa zona sembra troppo piccola per essere il loro campo base, continua a seguire il sentiero.
	Il resto di loro si trova sicuramente lì",
	"VAI MOOSHY, AMMAZZALI!",
	"Ah, ma prima... controlla se ci sono risorse vicino alle tende, magari sei un fungo fortunato."
]

const DIALOGO_3: Array[String] = [
	"MOOSHY!! 
	ATTENTO!!",
	"È UNA TRAPPOLA!!",
	"Annientali..."
]

const DIALOGO_4: Array[String] = [
	"CAVOLO MOOSHY!!!
	CHE STRAGE!",
	"Occhi aperti, ne arriva uno grosso!
	Fagli pentire di essere nato. Eh eh..."
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
	
	$StaccionataBoss/Staccionata3.disattiva()
	$StaccionataBoss/Staccionata4.disattiva()
	$StaccionataBoss/Staccionata5.disattiva()
	$StaccionataBoss/Staccionata6.disattiva()
	$StaccionataBoss/Staccionata7.disattiva()
	
	message_on_screen = false
	risorse_spawnate = false
	dialogo_1_finito = false
	parte1_finita = false
	parte2_finita = false
	parte3_finita = false
	area_attraversata = false
	parte4_finita = false
	parte5_finita = false
	parte6_finita = false
	orda1_spawnata = false
	orda2_spawnata = false
	orda3_spawnata = false
	if marius_spawnato:
		marius.queue_free()
		marius_spawnato = false
	
	DialogueManager.restart()
	GlobalVar.num_nemici_morti_nel_livello = 0
	GlobalVar.livello = 1
	GlobalVar.player_health = 100
	GlobalVar.ammo_storage_total = {
		GlobalVar.ammo_type.PISTOL_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.PISTOL_BULLET],		#50,
		GlobalVar.ammo_type.SHOTGUN_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.SHOTGUN_BULLET],		#15
		GlobalVar.ammo_type.MACHINEGUN_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.MACHINEGUN_BULLET]		#75
	}
	GlobalVar.ammo_magazine = {
		GlobalVar.ammo_type.PISTOL_BULLET: GlobalVar.AMMO_MAX_MAGAZINE[GlobalVar.ammo_type.PISTOL_BULLET],
		GlobalVar.ammo_type.SHOTGUN_BULLET: GlobalVar.AMMO_MAX_MAGAZINE[GlobalVar.ammo_type.SHOTGUN_BULLET],
		GlobalVar.ammo_type.MACHINEGUN_BULLET: GlobalVar.AMMO_MAX_MAGAZINE[GlobalVar.ammo_type.MACHINEGUN_BULLET]
	}
	GlobalVar.current_bullet_type = ammo_type.HAMMER
	GlobalVar.heart_inventory = 0



func _process(delta):
	parte1_finita = true
	parte2_finita = true
	parte3_finita = true
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
				spawn_risorse_su_tronchi()
				$Staccionata.disattiva()
				$Staccionata2.disattiva()
				DialogueManager.end_command_label()
				message_on_screen = false
				parte2_finita = true
				DialogueManager.is_dialogue_finished = false
	
	if parte2_finita and area_attraversata and !parte3_finita:
		$Staccionata.attiva()
		$Staccionata2.attiva()
		if !parte3_finita:
			if !message_on_screen: 
				DialogueManager.show_command_label("Premi Q per proseguire...")
				message_on_screen = true
				
				if !DialogueManager.is_dialogue_finished:
					DialogueManager.start_dialog(DIALOGO_3)

			if DialogueManager.is_dialogue_finished:
				DialogueManager.end_command_label()
				message_on_screen = false
				parte3_finita = true
				DialogueManager.is_dialogue_finished = false
	
	if parte3_finita and !parte4_finita:
		#if !orda1_spawnata:
			#_spawn_orda(1)
		#if orda1_spawnata and !orda2_spawnata and GlobalVar.num_nemici_morti_nel_livello == 34:
			#_spawn_orda(2)
		#if orda2_spawnata and !orda3_spawnata and GlobalVar.num_nemici_morti_nel_livello == 53:
			#_spawn_orda(3)
			parte4_finita = true
			GlobalVar.num_nemici_morti_nel_livello = 72
	
	if parte4_finita and !parte5_finita and GlobalVar.num_nemici_morti_nel_livello == 72:
		
		#Il player viene teletrasportato
		player.position = $Player_TP.position
		
		#Vengono attivate le "mura" del boss
		$StaccionataBoss/Staccionata3.attiva()
		$StaccionataBoss/Staccionata4.attiva()
		$StaccionataBoss/Staccionata5.attiva()
		$StaccionataBoss/Staccionata6.attiva()
		$StaccionataBoss/Staccionata7.attiva()

		if !message_on_screen:
			$AnimationPlayer.play("addio_monumento")
			if !$AnimationPlayer.is_playing():
				$Map/NavigationRegion3D/FirstLevel/Monument.queue_free()
				$Map/NavigationRegion3D.bake_navigation_mesh()
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_4)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte5_finita = true
			DialogueManager.is_dialogue_finished = false

	if parte5_finita and !parte6_finita:
		if !marius_spawnato:
			#Viene spawnato Marius
			marius = marius_scene.instantiate()
			var spawn_position = $Marius_spawn.position
			marius.position = spawn_position
			add_child(marius)
			marius_spawnato = true
		
		#FAR SPAWNARE MUNIZIONI E CURE (OPPURE MINIONS)
		
		if marius_spawnato and marius.max_hitpoints <= 0:
			parte6_finita = true
	
	if parte6_finita:
		if !message_on_screen:
			DialogueManager.show_command_label("CONGRATULAZIONI, HAI COMPLETATO LA DEMO DI MOOSHnGUN")
			message_on_screen = true
			
			await wait(5.0)
			
			DialogueManager.end_command_label()
			message_on_screen = false
			get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn")



func spawn_risorse_su_tronchi():
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
	if body.is_in_group("player"):
		area_attraversata = true
		$Map/NavigationRegion3D/FirstLevel/Area_InizioOrde.queue_free()


func _spawn_orda(n_orda):
	match n_orda:
		1:
			for i in range(20):
				if i < 10:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
				elif i < 20:
					var minion = minion_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					minion.position = spawn_position
					add_child(minion)
					
			orda1_spawnata = true
			
		2:
			for i in range(20):
				if i < 2:
					var tank = tank_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					tank.position = spawn_position
					add_child(tank)
				elif i < 6:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
				elif i == 6:
					var tank = tank_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					tank.position = spawn_position
					add_child(tank)
				elif i > 6 and i < 12:
					var minion = minion_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					minion.position = spawn_position
					add_child(minion)
				elif i < 16:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
				elif i < 19:
					var minion = minion_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					minion.position = spawn_position
					add_child(minion)
				elif i == 20:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
			orda2_spawnata = true
			
		3:
			for i in range(20):
				if i < 3:
					var tank = tank_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					tank.position = spawn_position
					add_child(tank)
				elif i < 6:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
				elif i < 12:
					var minion = minion_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					minion.position = spawn_position
					add_child(minion)
				elif i < 19:
					var soldier = soldier_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					soldier.position = spawn_position
					add_child(soldier)
				elif i == 20:
					var tank = tank_scene.instantiate()
					var spawn_position = $SpawnHolder.get_child(i).position
					tank.position = spawn_position
					add_child(tank)
					
			orda3_spawnata = true


func wait(param):
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(param)
	await timer.timeout
	timer.queue_free()
