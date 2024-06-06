extends Area3D

@onready var sprite = $Sprite3D

enum ammo_type {
	PISTOL_BULLET, 
	SHOTGUN_BULLET,
	MACHINEGUN_BULLET
}

const AMMO_AMOUNT := {
	ammo_type.PISTOL_BULLET: 15,
	ammo_type.SHOTGUN_BULLET: 3,
	ammo_type.MACHINEGUN_BULLET: 25
}

var type: int


#_______________________________________________________________________________________________________________#


func _ready():
	randomize()
	set_ammo_type()
	#


func _on_body_entered(body):
	
	if body.is_in_group("player"):
		if GlobalVar.ammo_storage_total[type] <= (GlobalVar.AMMO_MAX_STORAGE[type] - AMMO_AMOUNT[type]):
			GlobalVar.ammo_storage_total[type] += AMMO_AMOUNT[type]
		else: 
			GlobalVar.ammo_storage_total[type] = GlobalVar.AMMO_MAX_STORAGE[type]
		
	queue_free()


func set_ammo_type():
	var probabilita = calcola_probabilita()
	var random_number = randf()  # Genera un numero casuale tra 0 e 2
	
	print(probabilita)
	print(random_number)
	if probabilita[0]==0 and probabilita[1]==0 and probabilita[2]==0:
		queue_free()
	else:
		if random_number < probabilita[2]:
			type = ammo_type.PISTOL_BULLET
			sprite.texture = load("res://Pistol/ammo_pistol.png")
			
		elif random_number < probabilita[1]:
			type = ammo_type.MACHINEGUN_BULLET
			sprite.texture = load("res://Machinegun/ammo_machinegun.png")
			
		else:
			type = ammo_type.SHOTGUN_BULLET
			sprite.texture = load("res://Shotgun/ammo_shotgun.png")


func calcola_probabilita():
	var percentuale_shotgun = float(GlobalVar.ammo_storage_total[ammo_type.SHOTGUN_BULLET]) / float(GlobalVar.AMMO_MAX_STORAGE[ammo_type.SHOTGUN_BULLET] / 2.0)
	var percentuale_pistol = float(GlobalVar.ammo_storage_total[ammo_type.PISTOL_BULLET]) / float(GlobalVar.AMMO_MAX_STORAGE[ammo_type.PISTOL_BULLET] / 2.0)
	var percentuale_machinegun = float(GlobalVar.ammo_storage_total[ammo_type.MACHINEGUN_BULLET]) / float(GlobalVar.AMMO_MAX_STORAGE[ammo_type.MACHINEGUN_BULLET] / 2.0)
	
	var prob_shotgun = 1.0 - percentuale_shotgun
	if prob_shotgun < 0:
		prob_shotgun = 0
		
	var prob_pistol = 1.0 - percentuale_pistol	
	if prob_pistol < 0:
		prob_pistol = 0
		
	var prob_machinegun = 1.0 - percentuale_machinegun	
	if prob_machinegun < 0:
		prob_machinegun = 0	
	
	var somma_probabilita = prob_shotgun + prob_machinegun + prob_pistol
	
	if prob_machinegun<=0 and prob_pistol<=0 and prob_shotgun<=0:
		return [0, 0, 0]
	else:
		return [
			prob_shotgun / somma_probabilita,
			prob_machinegun / somma_probabilita,
			prob_pistol / somma_probabilita
	]
