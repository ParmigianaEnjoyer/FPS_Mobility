extends CanvasLayer

#CARATTERISTICHE DELL'ARMA
@export var current_weapon = "hammer"		#nome dell'arma utilizata
@export var weapon_damage = 50		#danno dell'arma
@export var fire_rate = 1.0			#numero di volte in cui l'arma spara in un secondo
@export var fire_range = -2.0			#range dell'arma

@onready var ray_container = $"../Head/Camera3D/RayContainer"
@onready var ray = $"../Head/Camera3D/RayCast3D"
@onready var projectile_particles = $"../Head/Camera3D/ProjectileParticles"
@onready var cooldown_timer = $Weapon/CooldownTimer
@onready var reload_time = $Weapon/ReloadTime
@onready var ammo_magazine_label = $HUI_ammo/ammo_magazine
@onready var ammo_storage_label = $HUI_ammo/ammo_stroage_total
@onready var healthbar = $HealthBar
@onready var ragebar = $RageBar

var blood_particles = load("res://Scenes/blood.tscn")
var sparks_particles = load("res://Scenes/sparks.tscn")

var shooted_count = 0 		#variabile che conta i colpi sparati
var radial_menu = false		#check if radial menu is on or not

var rage_mode_on = false	#variabile che serve a far capire alla assalto che è finita la rage e reimpostare la giusta animazione

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()


func reset():
	GlobalVar.player_health = 100
	randomize()
	switch_weapon(3)		#all'inizio viene impostato il martello come arma
	healthbar.init_health(GlobalVar.player_health)
	GlobalVar.reset_richiesto = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if GlobalVar.reset_richiesto == true:
		reset()
	
	if !GlobalVar.sparare_sbloccato:
		$HUI_ammo.visible = false
	else:
		$HUI_ammo.visible = true
	
	if !GlobalVar.curarsi_sbloccato:
		$HUI_hearts.visible = false
	else:
		$HUI_hearts.visible = true
		
	set_HUI_ammo(GlobalVar.current_bullet_type)
	update_heart_label()
	
	if DialogueManager.is_dialogue_active || !GlobalVar.sparare_sbloccato:
		$Weapon.visible = false
	elif !radial_menu:
		$Weapon.visible = true
	
	if !radial_menu and !DialogueManager.is_dialogue_active:
		
		rage_mode()
		heal()
		
		match current_weapon:
			"hammer":
				if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped() and GlobalVar.sparare_sbloccato:
						cooldown_timer.start(1.0 / fire_rate)
						$Weapon/Hammer_AnimatedSprite2D.play("hammer_shoot")
						$Shoot.play()
						shoot(current_weapon)
				
			"pistol":
				if Input.is_action_pressed("shoot") and GlobalVar.sparare_sbloccato:
					if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
						no_ammo_animation()
						$Weapon/Shotgun_AnimatedSprite2D.play("pistol_idle")
					else:
						if cooldown_timer.is_stopped() and reload_time.is_stopped():
							if magazine_has_ammo(GlobalVar.current_bullet_type):
								use_ammo(GlobalVar.current_bullet_type)
								cooldown_timer.start(1.0 / fire_rate)	
								$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
								$Shoot.play()
								shoot(current_weapon)
							else:
								reload(GlobalVar.current_bullet_type, $Weapon/Pistol_AnimatedSprite2D)
					
			"shotgun":
				if Input.is_action_pressed("shoot") and GlobalVar.sparare_sbloccato:
					if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
						no_ammo_animation()
						$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_idle")
					else:
						if cooldown_timer.is_stopped():
							use_ammo(GlobalVar.current_bullet_type)
							cooldown_timer.start(1.0 / fire_rate)
							$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_shoot")
							$Shoot.play()
							shoot(current_weapon)
							$Reload.play()
							reload(GlobalVar.current_bullet_type, $Weapon/Shotgun_AnimatedSprite2D)
					
			"machinegun":
				if Input.is_action_pressed("shoot") and GlobalVar.sparare_sbloccato:
					if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
						no_ammo_animation()
						$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
					else:
						if cooldown_timer.is_stopped() and reload_time.is_stopped():
							if magazine_has_ammo(GlobalVar.current_bullet_type):
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
								use_ammo(GlobalVar.current_bullet_type)
							else:
								reload(GlobalVar.current_bullet_type, $Weapon/Machinegun_AnimatedSprite2D)
				if Input.is_action_just_released("shoot") and $Weapon/Machinegun_AnimatedSprite2D.is_playing() and GlobalVar.sparare_sbloccato:
					shooted_count = 0
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
				if !DialogueManager.is_dialogue_active and !Input.is_action_pressed("shoot"):
					shooted_count = 0
					$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")


func switch_weapon(to):
	#SET PISTOL'S ANIMATION
	if to == 0 and current_weapon != "pistol":
		
		current_weapon = "pistol"
		fire_rate = 1.8
		fire_range = -20.0
		weapon_damage = 10.0
		GlobalVar.current_bullet_type = GlobalVar.ammo_type.PISTOL_BULLET
		
		set_projectile_particles(0.35, -0.35, 1.0, 0.015, 0.015, 0.0, fire_range, calculate_bullet_lifetime(fire_range, 100), 100.0, 100.0, 0.0)
		
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
		GlobalVar.current_bullet_type = GlobalVar.ammo_type.MACHINEGUN_BULLET
		set_projectile_particles(0.0, -0.35, 1.0, 0.015, 0.0, 0.0, fire_range, calculate_bullet_lifetime(fire_range, 100), 100.0, 100.0, 0.0)
		
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
		GlobalVar.current_bullet_type = GlobalVar.ammo_type.SHOTGUN_BULLET
		
		set_projectile_particles(0.0, -0.35, 0.0, 0.015, 0.0, 0.0, fire_range, calculate_bullet_lifetime(fire_range, 100.0) , 100.0, 100.0, 5.0)
		
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
		GlobalVar.current_bullet_type = GlobalVar.ammo_type.HAMMER
		
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
			if r.is_colliding():
				collider = r.get_collider()
				if collider.is_in_group("enemy"):		#Se l'oggetto collisionato è un nemico allora gli togli vita
					collider.hitpoints -= weapon_damage
					collider.take_damage()
					enemy_hit = true
					show_blood(r)
				else:
					show_sparks(r)
	else:
		ray.force_raycast_update()
		if ray.is_colliding():
			collider = ray.get_collider()
			if collider.is_in_group("enemy"):		#Se l'oggetto collisionato è un nemico allora gli togli vita
				collider.hitpoints -= weapon_damage
				collider.take_damage()
				enemy_hit = true
				show_blood(ray)
			else:
				show_sparks(ray)
	
	
	if enemy_hit:
		$Crosshair/weapon_crosshair.play(_weapon + "_crosshair_hit")


func show_blood(raycast):
	var collision_point = raycast.get_collision_point()
	var blood = blood_particles.instantiate()
	blood.position = collision_point
	blood.rotation.y = -1 * (get_node("..").rotation.y)
	add_child(blood)


func show_sparks(raycast):
	var collision_point = raycast.get_collision_point()
	var sparks = sparks_particles.instantiate()
	sparks.position = collision_point
	add_child(sparks)


func calculate_bullet_lifetime(the_range, velocity):		#funzione che calcola il tempo di vita del proiettile
	if velocity != 0:
		return float(-1 * float(the_range) / float(velocity))



#GESTIONE DELLE MUNIZIONI-----------------------------------------------------------------------------------------
func storage_has_ammo(type):
	return GlobalVar.ammo_storage_total[type] > 0

func magazine_has_ammo(type):
	return GlobalVar.ammo_magazine[type] > 0
	
func use_ammo(type):
	if magazine_has_ammo(type):
		GlobalVar.ammo_magazine[type] -= 1
	#else:
		#reload(type, animation)
		
func reload(type, animation: AnimatedSprite2D):
	if storage_has_ammo(type):
		
		if GlobalVar.ammo_storage_total[type] >= GlobalVar.AMMO_MAX_MAGAZINE[type]:
			GlobalVar.ammo_magazine[type] += GlobalVar.AMMO_MAX_MAGAZINE[type]
			GlobalVar.ammo_storage_total[type] -= GlobalVar.AMMO_MAX_MAGAZINE[type]
			
		if GlobalVar.ammo_storage_total[type] < GlobalVar.AMMO_MAX_MAGAZINE[type] and GlobalVar.ammo_storage_total[type] > 0:
			GlobalVar.ammo_magazine[type] += GlobalVar.ammo_storage_total[type]
			GlobalVar.ammo_storage_total[type] = 0
			
		if type != GlobalVar.ammo_type.SHOTGUN_BULLET:
			$Reload.play()
			reload_time.start(1.5)
			reload_animation(current_weapon, animation)
	else:
		$NoAmmo.play()

func reload_animation(weapon, animation: AnimatedSprite2D):
	animation.play(weapon + "_idle")
	$AnimationPlayer.play(weapon + "_reload")

func no_ammo_animation():
	if !$NoAmmo.is_playing():
		$NoAmmo.play()

func set_HUI_ammo(type):
	match type:
		GlobalVar.ammo_type.PISTOL_BULLET:
			$HUI_ammo/pistol_icon.visible = true;
			$HUI_ammo/machinegun_icon.visible = false;
			$HUI_ammo/shotgun_icon.visible = false;
			$HUI_ammo/stick_icon.visible = false;
			
		GlobalVar.ammo_type.MACHINEGUN_BULLET:
			$HUI_ammo/pistol_icon.visible = false;
			$HUI_ammo/machinegun_icon.visible = true;
			$HUI_ammo/shotgun_icon.visible = false;
			$HUI_ammo/stick_icon.visible = false;
			
		GlobalVar.ammo_type.SHOTGUN_BULLET:
			$HUI_ammo/pistol_icon.visible = false;
			$HUI_ammo/machinegun_icon.visible = false;
			$HUI_ammo/shotgun_icon.visible = true;
			$HUI_ammo/stick_icon.visible = false;
			
		GlobalVar.ammo_type.HAMMER:
			$HUI_ammo/pistol_icon.visible = false;
			$HUI_ammo/machinegun_icon.visible = false;
			$HUI_ammo/shotgun_icon.visible = false;
			$HUI_ammo/stick_icon.visible = true;
			
	if current_weapon != "hammer":
		ammo_magazine_label.text = str(GlobalVar.ammo_magazine[type])
		ammo_storage_label.text = str(GlobalVar.ammo_storage_total[type])
		$HUI_ammo/ammo_icon.visible = true
		$HUI_ammo/ammo_icon.texture = load("res://" + capitalizza_prima_lettera(current_weapon) + "/ammo_" + current_weapon + ".png")
	else:
		ammo_magazine_label.text = "\u221E"
		ammo_storage_label.text = ""
		$HUI_ammo/ammo_icon.visible = false



#GESTIONE DELLA SALUTE -------------------------------------------------------------------------------------------------#
func update_heart_label():
	$HUI_hearts/hearts_counter.text = str(GlobalVar.heart_inventory)


func heal():
	const HEALING_AMOUNT = 20
	
	if Input.is_action_just_pressed("heal") and GlobalVar.player_health < 100 and GlobalVar.heart_inventory > 0 and GlobalVar.curarsi_sbloccato:
		GlobalVar.heart_inventory -= 1
		
		if GlobalVar.player_health <= 100-HEALING_AMOUNT:
			GlobalVar.player_health += HEALING_AMOUNT
		else:
			GlobalVar.player_health = 100
		healthbar.health = GlobalVar.player_health
	
	else:
		pass



#GESTIONE DELLA RAGE MODE --------------------------------------------------------------------------------------------------#
func rage_mode():
	if GlobalVar.rage_mode:
		rage_mode_on = true
		
		match current_weapon:
			"hammer":
				switch_weapon_randomly(current_weapon)
			"pistol":
				if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
					switch_weapon_randomly(current_weapon)
				else:
					if cooldown_timer.is_stopped() and reload_time.is_stopped():
						if magazine_has_ammo(GlobalVar.current_bullet_type):
							use_ammo(GlobalVar.current_bullet_type)
							cooldown_timer.start(1.0 / fire_rate)	
							$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
							$Shoot.play()
							shoot(current_weapon)
						else:
							reload(GlobalVar.current_bullet_type, $Weapon/Pistol_AnimatedSprite2D)
					
			"shotgun":
				if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
					switch_weapon_randomly(current_weapon)
				else:
					if cooldown_timer.is_stopped():
						use_ammo(GlobalVar.current_bullet_type)
						cooldown_timer.start(1.0 / fire_rate)
						$Weapon/Shotgun_AnimatedSprite2D.play("shotgun_shoot")
						$Shoot.play()
						shoot(current_weapon)
						$Reload.play()
						reload(GlobalVar.current_bullet_type, $Weapon/Shotgun_AnimatedSprite2D)
					
			"machinegun":
				if storage_has_ammo(GlobalVar.current_bullet_type) == false and magazine_has_ammo(GlobalVar.current_bullet_type) == false:
					switch_weapon_randomly(current_weapon)
				else:
					if cooldown_timer.is_stopped() and reload_time.is_stopped():
						if magazine_has_ammo(GlobalVar.current_bullet_type):
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
							use_ammo(GlobalVar.current_bullet_type)
						else:
							reload(GlobalVar.current_bullet_type, $Weapon/Machinegun_AnimatedSprite2D)
							
	elif current_weapon == "machinegun" and $Weapon/Machinegun_AnimatedSprite2D.is_playing() and rage_mode_on:
		shooted_count = 0
		$Weapon/Machinegun_AnimatedSprite2D.play("machinegun_idle")
		rage_mode_on = false


func switch_weapon_randomly(actual_weapon):
	var number = randi() % 3
	var next_weapon = ""
	
	match number:
		0:
			next_weapon = "pistol"
		1:
			next_weapon = "shotgun"
		2:
			next_weapon = "machinegun"
	
	if next_weapon == actual_weapon:
		switch_weapon_randomly(actual_weapon)
	else:
		switch_weapon(number)
