extends Node3D

@onready var soldier_scene = preload("res://Enemy/enemy.tscn")
@onready var tank_scene = preload("res://Enemy/tank_enemy.tscn")
@onready var minion_scene = preload("res://Enemy/minion_enemy.tscn")
@onready var dead_enemies = 0

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
	#Che sia davvero tu l'unica speranza di MooshValley?",
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


const DIALOGO_4: Array[String] = [
	#"Fantastico Mooshy!! Impari in fretta.",
	#"Usa quelle armi contro i soldati nemici, e ricorda di dosare bene le munizioni.
	#Ma tranquillo, se dovessi averne bisogno, potrai raccoglierne altre dai nemici che sconfiggi.",
	#"...",
	#"MOOSHY!! PRESTO!!",
	"I soldati di DentiFieri sono arrivati fino a qui.
	Avanti!! Falli fuori."
]
const DIALOGO_5: Array[String] = [
	"Ben fatto Mosshy!! Li hai fatti fuori entrambi.",
	"I cinghiali potranno anche essere creature spregevoli, ma hanno anche loro un cuore.",
	"...",
	"Strappalo dal loro cadavere e assorbi la linfa vitale racchiusa al proprio interno per curarti quando ne avrai bisogno.",
	"Dopotutto, sei un fungo!! Eh eh..."
]
var dialogo_4_finito = false
var parte8_finita = false
var parte9_finita = false
var parte10_finita = false
var spawnati = false
var parte11_finita = false



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
	elif !dialogo_4_finito:
		tutorial_cura()
	else:
		pass


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
			await wait()
			
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
			await wait()
			
			DialogueManager.end_command_label()
			message_on_screen = false
			parte7_finita = true
			DialogueManager.is_dialogue_finished = false
			dialogo_3_finito = true


func tutorial_cura():
	if !parte8_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_4)
			
		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte8_finita = true
	
	if parte8_finita and !parte9_finita:
		if !spawnati:
			_spawn_primi_nemici()
		
		if !message_on_screen:
			DialogueManager.show_command_label("Elimina i soldati nemici che hanno invaso MooshValley.")
			message_on_screen = true
		
		if GlobalVar.enemy_killed_count == 2:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte9_finita = true
			DialogueManager.is_dialogue_finished = false
			
	if parte9_finita and !parte10_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_5)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte10_finita = true
		
	if parte10_finita and !parte11_finita:
		GlobalVar.curarsi_sbloccato = true
		
		if GlobalVar.player_health == 100:
			get_tree().get_first_node_in_group("player").take_damage(10)
		
		if !message_on_screen and GlobalVar.heart_inventory == 0:
			DialogueManager.show_command_label("Raccogli i cuori dai cadaveri dei cinghiali e premi 'E' per curarti.")
			message_on_screen = true
		elif !message_on_screen and GlobalVar.heart_inventory > 0:
			DialogueManager.show_command_label("Premi 'E' per curarti.")
			message_on_screen = true
		
		if Input.is_action_pressed("heal"):	
			DialogueManager.end_command_label()
			message_on_screen = false
			parte11_finita = true
			DialogueManager.is_dialogue_finished = false
			dialogo_4_finito = true


func wait():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1.5)
	await timer.timeout
	timer.queue_free()


func _spawn_primi_nemici():
	for i in range(2):
		var soldier = soldier_scene.instantiate()
		var spawn_position = $SpawnHolder.get_child(i).position
		
		soldier.position = spawn_position
		add_child(soldier)
	spawnati = true
