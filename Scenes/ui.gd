extends CanvasLayer

#CARATTERISTICHE DELL'ARMA
@export var current_weapon = "hammer"		#nome dell'arma utilizata
@export var weapon_damage = 35		#danno di un'arma
@export var fire_rate = 1.0			#numero di volte in cui l'arma spara in un secondo

var shooted_count = 0 		#variabile che conta i colpi sparati

@onready var cooldown_timer = $Weapon/CooldownTimer
var time_since_last_shot = 0.0
var can_shoot = true

#check if radial menu is on or not
var radial_menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	match current_weapon:
#		"shotgun":
#			fire_rate = 5.0
#			$Weapon/Shotgun_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
#			$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_idle")
#		"machinegun":
#			fire_rate = 10.0
#			$Weapon/Machinegun_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
#			$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
#		"pistol":
#			fire_rate = 7.0
#			$Weapon/Pistol_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
#			$Weapon/Pistol_AnimatedSprite2D.play("machinegun_idle")
#		"hammer":
#			fire_rate = 2.0
#			$Weapon/Hammer_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
##			$Weapon/Hammer_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
#			$Weapon/Hammer_AnimatedSprite2D.play("hammer_idle")

#func _on_Machinegun_AnimatedSprite2D_animation_finished():
#	$Weapon/Machinegun_AnimatedSprite2D.play(current_weapon + "_idle")

#func _on_AnimatedSprite2D_animation_finished():
#	$Weapon/Hammer_AnimatedSprite2D.play(current_weapon + "_idle")
	
#func _on_AnimatedSprite2D_animation_finished():
#	$Weapon/Shotgun_AnimatedSprite2D.play(current_weapon + "_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	if !radial_menu:
		
		match current_weapon:
			"hammer":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					$Weapon/Hammer_AnimatedSprite2D.play("hammer_shoot")
					$Shoot.play()
			"pistol":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)	
					$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
					$Shoot.play()
			"shotgun":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_shoot")
					$Shoot.play()
					$Reload.play()
			"machinegun":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					shooted_count += 1
					match shooted_count % 3:
						0:
							$Shoot.stream = preload("res://Machinegun/minigun.ogg")
						1:
							$Shoot.stream = preload("res://Machinegun/minigun2.ogg")
						2:
							$Shoot.stream = preload("res://Machinegun/minigun3.ogg")
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_shoot")
					$Shoot.play()
				if Input.is_action_just_released("shoot") and $Weapon/Machinegun_AnimatedSprite2D.is_playing():
					shooted_count = 0
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
					$Shoot.stop()

		#if Input.is_action_pressed("shoot") and can_shoot and  current_weapon == "shotgun":
			#if !($Shoot.playing or $Reload.playing):
				#$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_shoot")
				#$Shoot.play()
				#$Reload.play()
				#time_since_last_shot = 0.0
		#else: 
			#if Input.is_action_pressed("shoot") and can_shoot and current_weapon == "machinegun":
				#$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_shoot")
				#if !($Shoot.playing):
					#$Shoot.play()
			#if Input.is_action_just_released("shoot") and $Weapon/Machinegun_AnimatedSprite2D.is_playing():
				#$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
				#$Shoot.stop()
				#time_since_last_shot = 0.0
		#if Input.is_action_pressed("shoot") and can_shoot and current_weapon == "pistol":
			#if !$Shoot.playing:
				#$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
				#$Shoot.play()
				#time_since_last_shot = 0.0
		#if Input.is_action_pressed("shoot") and can_shoot and current_weapon == "hammer":
			#if !$Weapon/Hammer_AnimatedSprite2D.is_playing():
				#$Weapon/Hammer_AnimatedSprite2D.play("hammer_shoot")
				#$Shoot.play()
				
				#var collider = $"../Head/Camera3D/RayCast3D".get_collider()
				#if collider is Enemy:
					#collider.hitpoints -= weapon_damage
					#printt(collider.hitpoints, weapon_damage)
					
				#time_since_last_shot = 0.0


func switch_weapon(to):
	#SET PISTOL'S ANIMATION
	if to == 0 and current_weapon != "pistol":
		current_weapon = "pistol"
		fire_rate = 1.8
		$Shoot.volume_db = -20.0
		$Shoot.stream = preload("res://Pistol/gunshot-fast-[AudioTrimmer.com].wav")
		
		if $Weapon/Shotgun_AnimatedSprite2D.visible:
			$Weapon/Shotgun_AnimatedSprite2D.visible = false
			$Weapon/Shotgun_AnimatedSprite2D.stop()
		else: if $Weapon/Machinegun_AnimatedSprite2D.visible:
			$Weapon/Machinegun_AnimatedSprite2D.visible = false
			$Weapon/Machinegun_AnimatedSprite2D.stop()
		else: if $Weapon/Hammer_AnimatedSprite2D.visible:
			$Weapon/Hammer_AnimatedSprite2D.visible = false
			$Weapon/Hammer_AnimatedSprite2D.stop()
		
		$Weapon/Pistol_AnimatedSprite2D.visible = true
		$Weapon/Pistol_AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
		
	#SET MACHINEGUN'S ANIMATION
	else: if to == 2 and current_weapon != "machinegun":
		current_weapon = "machinegun"
		fire_rate = 5
		$Shoot.stream = preload("res://Machinegun/minigun.ogg")
		$Shoot.volume_db = -30.0
		
		if $Weapon/Pistol_AnimatedSprite2D.visible:
			$Weapon/Pistol_AnimatedSprite2D.visible = false
			$Weapon/Pistol_AnimatedSprite2D.stop()
		else: if $Weapon/Shotgun_AnimatedSprite2D.visible:
			$Weapon/Shotgun_AnimatedSprite2D.visible = false
			$Weapon/Shotgun_AnimatedSprite2D.stop()
		else: if $Weapon/Hammer_AnimatedSprite2D.visible:
			$Weapon/Hammer_AnimatedSprite2D.visible = false
			$Weapon/Hammer_AnimatedSprite2D.stop()
			
		$Weapon/Machinegun_AnimatedSprite2D.visible = true
		$Weapon/Machinegun_AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
		
	#SET SHOTGUN'S ANIMATION
	else: if to == 1 and current_weapon != "shotgun":
		current_weapon = "shotgun"
		fire_rate = 0.75
		$Shoot.volume_db = -20.0
		$Shoot.stream = preload("res://Shotgun/shotgun-fx_168bpm.wav")
		
		if $Weapon/Pistol_AnimatedSprite2D.visible:
			$Weapon/Pistol_AnimatedSprite2D.visible = false
			$Weapon/Pistol_AnimatedSprite2D.stop()
		else: if $Weapon/Machinegun_AnimatedSprite2D.visible:
			$Weapon/Machinegun_AnimatedSprite2D.visible = false
			$Weapon/Machinegun_AnimatedSprite2D.stop()
		else: if $Weapon/Hammer_AnimatedSprite2D.visible:
			$Weapon/Hammer_AnimatedSprite2D.visible = false
			$Weapon/Hammer_AnimatedSprite2D.stop()
		
		$Weapon/Shotgun_AnimatedSprite2D.visible = true
		$Weapon/Shotgun_AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
		
	#SET HAMMER'S ANIMATION
	else: if to == 3 and current_weapon != "hammer":
		current_weapon = "hammer"
		fire_rate = 1.0
		$Shoot.volume_db = -20.0
		$Shoot.stream = preload("res://Hammer/classic-double-swoosh_F#_minor-[AudioTrimmer.com].wav")
		
		if $Weapon/Pistol_AnimatedSprite2D.visible:
			$Weapon/Pistol_AnimatedSprite2D.visible = false
			$Weapon/Pistol_AnimatedSprite2D.stop()
		else: if $Weapon/Machinegun_AnimatedSprite2D.visible:
			$Weapon/Machinegun_AnimatedSprite2D.visible = false
			$Weapon/Machinegun_AnimatedSprite2D.stop()
		else: if $Weapon/Shotgun_AnimatedSprite2D.visible:
			$Weapon/Shotgun_AnimatedSprite2D.visible = false
			$Weapon/Shotgun_AnimatedSprite2D.stop()
		
		$Weapon/Hammer_AnimatedSprite2D.visible = true
		$Weapon/Hammer_AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")


func _input(event):
	if event.is_action_pressed("radial_menu"):
		get_node("Weapon/" + capitalizza_prima_lettera(current_weapon) + "_AnimatedSprite2D").play(current_weapon + "_idle")

func capitalizza_prima_lettera(testo):
	if testo.length() == 0:
		return testo  # Restituisce la stringa vuota se il testo è vuoto
	var prima_lettera = testo[0].to_upper()  # Prende la prima lettera e la converte in maiuscolo
	var resto_stringa = testo.substr(1, testo.length() - 1)  # Prende il resto della stringa
	return prima_lettera + resto_stringa  # Concatenazione della prima lettera maiuscola con il resto della stringa
