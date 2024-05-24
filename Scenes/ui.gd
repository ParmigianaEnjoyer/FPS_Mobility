extends CanvasLayer

var current_weapon = "shotgun"
var time_since_last_shot = 0.0
var fire_rate = 10.0
var can_shoot = true

#check if radial menu is on or not
var radial_menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	match current_weapon:
		"shotgun":
			fire_rate = 5.0
			$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
			$AnimatedSprite2D.play("shotgun_idle")
		"machinegun":
			fire_rate = 10.0
			$machinegun_ui.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
			$machinegun_ui.play("machinegun_idle")
		"pistol":
			fire_rate = 7.0
			$Weapon/Pistol_AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished())
			$Weapon/Pistol_AnimatedSprite2D.play("machinegun_idle")

#func _on_machinegun_ui_animation_finished():
#	$machinegun_ui.play(current_weapon + "_idle")

func _on_AnimatedSprite2D_animation_finished():
	$AnimatedSprite2D.play(current_weapon + "_idle")
	
#func _on_AnimatedSprite2D_animation_finished():
#	$AnimatedSprite2D.play(current_weapon + "_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	if !radial_menu:
		if Input.is_action_pressed("shoot") and can_shoot and  current_weapon == "shotgun":
			if !($Shoot.playing or $Reload.playing):
				$AnimatedSprite2D.play("shotgun_shoot")
				$Shoot.play()
				$Reload.play()
				time_since_last_shot = 0.0
		else: 
			if Input.is_action_pressed("shoot") and can_shoot and current_weapon == "machinegun":
				$machinegun_ui.play("machinegun_shoot")
				if !($Shoot.playing):
					$Shoot.play()
			if Input.is_action_just_released("shoot") and $machinegun_ui.is_playing():
				$machinegun_ui.play("machinegun_idle")
				$Shoot.stop()
				time_since_last_shot = 0.0
		if Input.is_action_pressed("shoot") and can_shoot and current_weapon == "pistol":
			if !$Shoot.playing:
				$Weapon/Pistol_AnimatedSprite2D.play("pistol_shoot")
				$Shoot.play()
				time_since_last_shot = 0.0


func switch_weapon(to):
	#Pistol animation on
	if to == 0 and current_weapon != "pistol":
		current_weapon = "pistol"
		$Shoot.stream = preload("res://Pistol/gunshot-fast-[AudioTrimmer.com].wav")
		
		if $AnimatedSprite2D.visible:
			$AnimatedSprite2D.visible = false
			$AnimatedSprite2D.stop()
		else: if $machinegun_ui.visible:
			$machinegun_ui.visible = false
			$machinegun_ui.stop()
		else: if $Stick_AnimatedSprite2D.visible:
			$Stick_AnimatedSprite2D.visible = true
			$Stick_AnimatedSprite2D.stop()
		
		$Weapon/Pistol_AnimatedSprite2D.visible = true
		$Weapon/Pistol_AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
		
	#Machinegun animation on
	else: if to == 2 and current_weapon != "machinegun":
		current_weapon = "machinegun"
		$Shoot.stream = preload("res://Machinegun/ak47-machine-gun-spray-fx_D_major.wav")
		
		if $Weapon/Pistol_AnimatedSprite2D.visible:
			$Weapon/Pistol_AnimatedSprite2D.visible = false
			$Weapon/Pistol_AnimatedSprite2D.stop()
		else: if $AnimatedSprite2D.visible:
			$AnimatedSprite2D.visible = false
			$AnimatedSprite2D.stop()
		else: if $Stick_AnimatedSprite2D.visible:
			$Stick_AnimatedSprite2D.visible = true
			$Stick_AnimatedSprite2D.stop()
			
		$machinegun_ui.visible = true
		$machinegun_ui.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
		
	#Shotgun animation on
	else: if to == 1 and current_weapon != "shotgun":
		current_weapon = "shotgun"
		$Shoot.stream = preload("res://Shotgun/shotgun-fx_168bpm.wav")
		
		if $Weapon/Pistol_AnimatedSprite2D.visible:
			$Weapon/Pistol_AnimatedSprite2D.visible = false
			$Weapon/Pistol_AnimatedSprite2D.stop()
		else: if $machinegun_ui.visible:
			$machinegun_ui.visible = false
			$machinegun_ui.stop()
		else: if $Stidddck_AnimatedSprite2D.visible:
			$Stick_AnimatedSprite2D.visible = true
			$Stick_AnimatedSprite2D.stop()
		
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play(current_weapon + "_idle")
		$Crosshair/weapon_crosshair.play(current_weapon + "_crosshair")
