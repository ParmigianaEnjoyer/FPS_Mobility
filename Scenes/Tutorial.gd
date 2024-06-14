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
var parte1_finita: bool
var parte2_finita: bool

const DIALOGO_2: Array[String] = [
	"Incredibile...",
	"Ehm...cioè, come volevasi dimostrare, riesci a muoverti.
	Dopotitto sono stato io a darti vita.",
	"MOOSHY !!!
	Per combattere l'armata dei cinghiali ti serviranno delle armi...",
	"I cinghiali usano armi da fuoco... Tieni questo martello!
	Certo sarà difficile colpire qualcuno da distanza ravvicinata, ma almeno non dovrai preoccuparti delle munizioni.",
	"Eh eh..."
]
var dialogo_2_finito: bool
var parte3_finita: bool
var parte4_finita: bool

const DIALOGO_3: Array[String] = [
	"EHI!!! ATTENTO CON QUEL COSO!!!",
	"Fantastico Mooshy...sembri più forte di quanto mi aspettassi.
	Che sia davvero tu l'unica speranza di MooshValley?",
	"MOOSHY !!!
	Puoi essere anche fortissimo, ma i cinghiali sono abili soldati...e hanno armi da fuoco...",
	"...",
	"MA TRANQUILLO!!! 
	Tramite la mia magia sono riuscito a rubare loro alcune armi, ma sono troppo pensanti per me...sono uno gnomo ricordi?",
	"Prendile tu!! 
	Avanti... prova a sparare."
]
var dialogo_3_finito: bool
var parte5_finita: bool
var parte6_finita: bool
var parte7_finita: bool


const DIALOGO_4: Array[String] = [
	"Fantastico Mooshy!! Impari in fretta.",
	"Usa quelle armi contro i soldati nemici, e ricorda di dosare bene le munizioni.
	Ma tranquillo, se dovessi averne bisogno, potrai raccoglierne altre dai nemici che sconfiggi.",
	"...",
	"MOOSHY!! PRESTO!!",
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
var dialogo_4_finito: bool
var parte8_finita: bool
var parte9_finita: bool
var parte10_finita: bool
var spawnati: bool
var parte11_finita: bool


const DIALOGO_6: Array[String] = [
	"Perfetto!! Adesso sei pronto per combattere.",
	"...",
	"Mosshy... lascia che ti dica un'ultima cosa.
	Tu sei stato creato dalla magia oscura, il tuo corpo è intrinseco di linfa malvagia...",
	"Ogni volta che eliminerai un nemico, accumulerai sete di sangue, che ti condurrà alla follia e a incontrollabili attacchi di furia sanguinaria.",
	"ADESSO VA!!!",
	"Combatti i soldati di DentiFieri!! Elimina tutti i cinghiali!!
	SALVA MOOSHVALLEY !!"
]
var dialogo_6_finito: bool
var parte12_finita: bool
var parte13_finita: bool
var parte14_finita: bool
var orda_spawnata1: bool
var orda_spawnata2: bool
var orda_spawnata3: bool

var message_on_screen: bool


const DIALOGO_FINALE: Array[String] = [
	"... ... ...
	ehi... li hai ammazzati tutti vero?",
	"Ben fatto Mooshy! Sei davvero fortissimo.",
	"Non pensare che sia finita qui, questo è solo l'inizio.
	Di questo passo, anche col tuo aiuto, non riusciremo a difenderci per sempre... dobbiamo cambiare strategia.",
	"MOOSHY!!
	Non ti ho dato la vita per difendere MooshValley... ma per attaccare i nemici cinghiali ed eliminarli una volta per tutte.",
	"Usciamo dalla città e dirigiamoci verso la vecchia cava, una volta attraversata ci ritroveremo nell'Antica Foresta.
	Proprio al centro di essa, i cinghiali hanno eretto un campo base... sarà il nostro primo obiettivo.",
	"FORZA MOOSHY! ANDIAMO! RIPRENDIAMOCI LA NOSTRA LIBERTÀ!!",
	"..."
]
var dialogo_finale_finito: bool
var finale1: bool
var finale2: bool

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
	GlobalVar.rage_sbloccato = false
	
	dialogo_1_finito = false
	parte1_finita = false
	parte2_finita = false
	
	dialogo_2_finito = false
	parte3_finita = false
	parte4_finita = false
	
	dialogo_3_finito = false
	parte5_finita = false
	parte6_finita = false
	parte7_finita = false
	
	dialogo_4_finito = false
	parte8_finita = false
	parte9_finita = false
	parte10_finita = false
	spawnati = false
	parte11_finita = false
	
	dialogo_6_finito = false
	parte12_finita = false
	parte13_finita = false
	parte14_finita = false
	orda_spawnata1 = false
	orda_spawnata2 = false
	orda_spawnata3 = false
	
	dialogo_finale_finito = false
	finale1 = false
	finale2 = false
	
	DialogueManager.restart()
	
	message_on_screen = false
	
	GlobalVar.num_nemici_morti_nel_livello = 0
	GlobalVar.livello = 0
	GlobalVar.player_health = 100
	GlobalVar.ammo_storage_total = {
		ammo_type.PISTOL_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.PISTOL_BULLET],		#50,
		ammo_type.SHOTGUN_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.SHOTGUN_BULLET],		#15
		ammo_type.MACHINEGUN_BULLET: GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.MACHINEGUN_BULLET]		#75
	}
	GlobalVar.ammo_magazine = {
		ammo_type.PISTOL_BULLET: 15,
		ammo_type.SHOTGUN_BULLET: 1,
		ammo_type.MACHINEGUN_BULLET: 25
	}
	GlobalVar.current_bullet_type = ammo_type.HAMMER
	GlobalVar.heart_inventory = 0



func _process(_delta):

	if !dialogo_1_finito:
		tutorial_movimento()
	elif !dialogo_2_finito:
		tutorial_martello()
	elif !dialogo_3_finito:
		tutorial_armi()
	elif !dialogo_4_finito:
		tutorial_cura()
	elif !dialogo_6_finito:
		orda()
	elif !dialogo_finale_finito:
		parte_finale()
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
			DialogueManager.show_command_label("Premi 'W', 'A', 'S', 'D', 'MAIUSC' e 'SPACE' per muoverti, correre e saltare.")
			message_on_screen = true
		
		if Input.is_action_pressed("down") || Input.is_action_pressed("sprint") ||Input.is_action_pressed("jump") ||Input.is_action_pressed("up") ||Input.is_action_pressed("right") ||Input.is_action_pressed("left"): 
			GlobalVar.movimento_sbloccato = true
			await wait(4.0)
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
			await wait(1.5)
			
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
			await wait(1.5)
			
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
		
		if GlobalVar.num_nemici_morti_nel_livello == 2:
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


func wait(param):
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(param)
	await timer.timeout
	timer.queue_free()


func _spawn_primi_nemici():
	for i in range(2):
		var soldier = soldier_scene.instantiate()
		var spawn_position = $SpawnHolder.get_child(i).position
		soldier.AGGRO_RANGE = 80
		soldier.position = spawn_position
		add_child(soldier)
	spawnati = true


func orda():
	if !parte12_finita:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			GlobalVar.rage_sbloccato = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_6)
			
		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			parte12_finita = true
			
	if parte12_finita and !parte13_finita:
		if !spawnati:
			_spawn_primi_nemici()
		
		if !message_on_screen:
			DialogueManager.show_command_label("Sopravvivi alle orde.")
			message_on_screen = true
			await wait(5.0)
			DialogueManager.end_command_label()
			message_on_screen = false
			parte13_finita = true
			DialogueManager.is_dialogue_finished = false
	
	if parte13_finita and !parte14_finita:
		if !orda_spawnata1:
			_spawn_orda()
		if orda_spawnata1 and !orda_spawnata2 and GlobalVar.num_nemici_morti_nel_livello == 10:
			_spawn_orda_2()
		if orda_spawnata2 and !orda_spawnata3 and GlobalVar.num_nemici_morti_nel_livello == 18:
			_spawn_orda_3()
		
		if GlobalVar.num_nemici_morti_nel_livello == 26:
			parte14_finita = true
			dialogo_6_finito = true



func _spawn_orda():
	for i in range(8):
		if i < 2:
			var soldier = soldier_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			soldier.AGGRO_RANGE = 80
			soldier.position = spawn_position
			add_child(soldier)
		elif i < 6:
			var minion = minion_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			minion.AGGRO_RANGE = 80
			minion.position = spawn_position
			add_child(minion)
		elif i < 8:
			#var tank = tank_scene.instantiate()
			#var spawn_position = $SpawnHolder.get_child(i).position
			
			var soldier = soldier_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			soldier.AGGRO_RANGE = 80
			soldier.position = spawn_position
			add_child(soldier)
			
	orda_spawnata1 = true


func _spawn_orda_2():
	
	for i in range(8):
		if i < 2:
			var minion = minion_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			minion.AGGRO_RANGE = 80
			minion.position = spawn_position
			add_child(minion)
		elif i < 6:
			var soldier = soldier_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			soldier.AGGRO_RANGE = 80
			soldier.position = spawn_position
			add_child(soldier)
		elif i < 8:
			var tank = tank_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			tank.AGGRO_RANGE = 80
			tank.position = spawn_position
			add_child(tank)
	
	orda_spawnata2 = true


func _spawn_orda_3():
	for i in range(8):
		if i < 4:
			var minion = minion_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			minion.AGGRO_RANGE = 80
			minion.position = spawn_position
			add_child(minion)
		elif i < 8:
			var soldier = soldier_scene.instantiate()
			var spawn_position = $SpawnHolder.get_child(i).position
			
			soldier.AGGRO_RANGE = 80
			soldier.position = spawn_position
			add_child(soldier)
		
	orda_spawnata3 = true


func parte_finale():
	if !finale1:
		if !message_on_screen: 
			DialogueManager.show_command_label("Premi Q per proseguire...")
			message_on_screen = true
			
			if !DialogueManager.is_dialogue_finished:
				DialogueManager.start_dialog(DIALOGO_FINALE)

		if DialogueManager.is_dialogue_finished:
			DialogueManager.end_command_label()
			message_on_screen = false
			finale1 = true
	
	if finale1 and !finale2:
		GlobalVar.radial_sbloccato = true
		
		if !message_on_screen:
			DialogueManager.show_command_label("CONGRATULAZIONI, LIVELLO 0 COMPLETATO")
			message_on_screen = true
			
			await wait(5.0)
			
			DialogueManager.end_command_label()
			message_on_screen = false
			finale2 = true
			get_tree().change_scene_to_file("res://Scenes/FirstLevel.tscn")
