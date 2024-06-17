extends Node


var player_health = 100

var key_dialogo = InputMap.action_get_events("advance_dialogue")[0].as_text().replace(' (Physical)','')
var key_avanti = InputMap.action_get_events("up")[0].as_text().replace(' (Physical)','')
var key_indietro = InputMap.action_get_events("down")[0].as_text().replace(' (Physical)','')
var key_sinistra = InputMap.action_get_events("left")[0].as_text().replace(' (Physical)','')
var key_destra = InputMap.action_get_events("right")[0].as_text().replace(' (Physical)','')
var key_salta = InputMap.action_get_events("jump")[0].as_text().replace(' (Physical)','')
var key_corri = InputMap.action_get_events("sprint")[0].as_text().replace(' (Physical)','')
var key_spara = InputMap.action_get_events("shoot")[0].as_text().replace(' (Physical)','')
var key_pausa = InputMap.action_get_events("exit")[0].as_text().replace(' (Physical)','')
var key_inventario = InputMap.action_get_events("radial_menu")[0].as_text().replace(' (Physical)','')
var key_cura = InputMap.action_get_events("heal")[0].as_text().replace(' (Physical)','')

var reset_richiesto = false

var diff := 1.0  #variabile globale difficoltà

var livello := 0 #livello attuale
var heart_inventory := 0	#numero di cuori (cure) nell'inventario

#VARIABILI PER LE MUNIZIONI
#capienza massima delle munizioni totali
const AMMO_MAX_STORAGE := {
	ammo_type.PISTOL_BULLET: 100,	#100
	ammo_type.SHOTGUN_BULLET: 30,	#30
	ammo_type.MACHINEGUN_BULLET: 150,	#150
}

#capienza massima di caricatori
const AMMO_MAX_MAGAZINE := {
	ammo_type.PISTOL_BULLET: 15,
	ammo_type.SHOTGUN_BULLET: 1,
	ammo_type.MACHINEGUN_BULLET: 25
}

enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET,
	HAMMER
}

var current_bullet_type = ammo_type.HAMMER

#Capienza attuale dei caricatori
var ammo_magazine := {
	ammo_type.PISTOL_BULLET: AMMO_MAX_MAGAZINE[ammo_type.PISTOL_BULLET],
	ammo_type.SHOTGUN_BULLET: AMMO_MAX_MAGAZINE[ammo_type.SHOTGUN_BULLET],
	ammo_type.MACHINEGUN_BULLET: AMMO_MAX_MAGAZINE[ammo_type.MACHINEGUN_BULLET]
}

#Capienza attuale delle munizioni totali
var ammo_storage_total := {
	ammo_type.PISTOL_BULLET: 50,		#50,
	ammo_type.SHOTGUN_BULLET: 15,		#15
	ammo_type.MACHINEGUN_BULLET: 75		#75
}

var enemy_killed_count = 0
var num_nemici_morti_nel_livello = 0

var rage_mode

var movimento_sbloccato = true
var radial_sbloccato = true
var sparare_sbloccato = true
var curarsi_sbloccato = true
var rage_sbloccato = true
var enemy_in_bossfight = 0
var is_boss_dead = false
