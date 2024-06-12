extends Node3D


const Garagamels_lines: Array[String] = [
	"We, wewewewee, wewe. We, wewewewee, wewe. We, wewewewee, wewe. We, wewewewee, wewe. We, wewewewee, wewe.
	We, wewewewee, wewe.
	We, wewewewee, wewe.We, wewewewee, wewe.
	We, wewewewee, wewe.",
	"Che vuoi!!",
	"Non so che cosa scrivere mannaggia alla madonna!",
	"Non so che cosa scrivere mannaggia alla madonna! Forse puoi darmi una mano..."
] 


enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET,
	HAMMER
}

func _ready():
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
	
	
	DialogueManager.start_dialog(Garagamels_lines)

