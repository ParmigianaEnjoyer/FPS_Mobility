extends CanvasLayer

#CARATTERISTICHE DELL'ARMA
@export var current_weapon = "hammer"		#nome dell'arma utilizata
@export var weapon_damage = 50		#danno di un'arma
@export var fire_rate = 1.0			#numero di volte in cui l'arma spara in un secondo
@export var fire_range = -2.0			#range dell'arma

@onready var ray_container = $"../Head/Camera3D/RayContainer"
@onready var ray = $"../Head/Camera3D/RayCast3D"
@onready var projectile_particles = $"../Head/Camera3D/ProjectileParticles"
@onready var cooldown_timer = $Weapon/CooldownTimer

#var time_since_last_shot = 0.0
var shooted_count = 0 		#variabile che conta i colpi sparati
var radial_menu = false		#check if radial menu is on or not


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !radial_menu:
		
		match current_weapon:
			"hammer":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					$Weapon/Hammer_AnimatedSprite2D.play("hammer_shoot")
					$Shoot.play()
					shoot(current_weapon)
			"pistol":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)	
					$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
					$Shoot.play()
					shoot(current_weapon)
			"shotgun":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_shoot")
					$Shoot.play()
					$Reload.play()
					shoot(current_weapon)
			"machinegun":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
					cooldown_timer.start(1.0 / fire_rate)
					shooted_count += 1
					#si alternano tre suoni differenti per la machinegun
					match shooted_count % 3:
						0:
							$Shoot.stream = preload("res://Machinegun/minigun.ogg")
						1:
							$Shoot.stream = preload("res://Machinegun/minigun2.ogg")
						2:
							$Shoot.stream = preload("res://Machinegun/minigun3.ogg")
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_shoot")
					$Shoot.play()
					shoot(current_weapon)
				if Input.is_action_just_released("shoot") and $Weapon/Machinegun_AnimatedSprite2D.is_playing():
					shooted_count = 0
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
					$Shoot.stop()


func switch_weapon(to):
	#SET PISTOL'S ANIMATION
	if to == 0 and current_weapon != "pistol":
		
		current_weapon = "pistol"
		fire_rate = 1.8
		fire_range = -20.0
		weapon_damage = 10.0
		
		set_projectile_particles(0.35, -0.35, 1.0, 0.015, 0.015, 0.0, fire_range, (1 / fire_rate), 100.0, 100.0, 0.0)
		
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
		fire_rate = 5.0
		fire_range = -30.0
		weapon_damage = 10.0
		set_projectile_particles(0.0, -0.35, 1.0, 0.015, 0.0, 0.0, fire_range, (1 / fire_rate), 100.0, 100.0, 0.0)
		
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
		fire_range = -11
		fire_rate = 0.75
		weapon_damage = 7	#danno di un singolo proiettile
		
		set_projectile_particles(0.0, -0.35, 0.0, 0.015, 0.0, 0.0, fire_range, 0.15 , 100.0, 100.0, 5.0)
		
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
		fire_range = -2
		fire_rate = 1.0
		weapon_damage = 50
		$Shoot.volume_db = -20.0
		$Shoot.stream = preload("res://Hammer/classic-double-swoosh_F#_minor-[AudioTrimmer.com].wav")
		projectile_particles.visible = false
		
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
	
	ray.target_position.z = fire_range		#Il range viene modificato in base al range dell'arma attuale


func _input(event):
	if event.is_action_pressed("radial_menu"):
		get_node("Weapon/" + capitalizza_prima_lettera(current_weapon) + "_AnimatedSprite2D").play(current_weapon + "_idle")


func capitalizza_prima_lettera(testo):		#funzione di servizio, mette la prima lettera di una parola in maiusolo
	if testo.length() == 0:
		return testo  # Restituisce la stringa vuota se il testo è vuoto
	var prima_lettera = testo[0].to_upper()  # Prende la prima lettera e la converte in maiuscolo
	var resto_stringa = testo.substr(1, testo.length() - 1)  # Prende il resto della stringa
	return prima_lettera + resto_stringa  # Concatenazione della prima lettera maiuscola con il resto della stringa


func set_projectile_particles(pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, f_range, lifetime, v_min, v_max, spread):
		projectile_particles.visible = true
		projectile_particles.position.x = pos_x
		projectile_particles.position.y = pos_y
		projectile_particles.position.z = pos_z
		projectile_particles.rotation.x = rot_x
		projectile_particles.rotation.y = rot_y
		projectile_particles.rotation.z = rot_z
		projectile_particles.process_material.direction.z = f_range
		projectile_particles.lifetime = lifetime
		projectile_particles.process_material.initial_velocity_min = v_min
		projectile_particles.process_material.initial_velocity_max = v_max
		projectile_particles.process_material.spread = spread


#FUNZIONE CHE GESTISCE IL RAGGIO E IL DANNO DI UN'ARMA QUANDO SPARA E HITTA UN ENEMY
func shoot(_weapon):
	projectile_particles.restart()		#animazione del proiettile
	var collider
	var enemy_hit = false
	
	if _weapon == "shotgun":		#se l'arma selezionata è uno shotgun vengono randomizzati i raycast
		var spread = 1.5
		for r in ray_container.get_children():
			r.target_position.x = randf_range(spread, -spread)
			r.target_position.y = randf_range(spread, -spread)
			r.force_raycast_update()
			collider = r.get_collider()
			if collider is Enemy:		#Se l'oggetto collisionato è un nemico allora gli togli vita
				collider.hitpoints -= weapon_damage
				collider.take_damage()
				enemy_hit = true
	else:
		ray.force_raycast_update()
		collider = ray.get_collider()
		if collider is Enemy:		#Se l'oggetto collisionato è un nemico allora gli togli vita
			collider.hitpoints -= weapon_damage
			collider.take_damage()
			enemy_hit = true
	
	if enemy_hit:
		$Crosshair/weapon_crosshair.play(_weapon + "_crosshair_hit")
