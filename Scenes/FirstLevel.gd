extends Node3D

@onready var soldier_scene = preload("res://Enemy/enemy.tscn")
@onready var tank_scene = preload("res://Enemy/tank_enemy.tscn")
@onready var minion_scene = preload("res://Enemy/minion_enemy.tscn")

const DIALOGO_1: Array[String] = [
	"Mooshy...",
	"Mooshy...",
	"MOOSHY !!!",
	"Sei vivo, non posso crederci!
	Ehm...cioè, certo che posso crederci, dopotutto sono stato io a darti vita.",
	"Benvenuto al mondo Mooshy! Io sono Garghamel, lo Gnomo Stregone di MooshValley e... bhe... tuo creatore.",
	"Non c'è tempo per parlare, presto!
	L'armata dei cinghiali è riuscita a sfondare la grande porta. Saranno qui a momenti!",
	"Riesci a muoverti? Sai come si fa?"
]
var dialogo_1_finito: bool


enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET,
	HAMMER
}

func _ready():
	
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
	pass
