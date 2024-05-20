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
			$machinegun_ui.animation_finished.connect(_on_machinegun_ui_animation_finished)
			$machinegun_ui.play("machinegun_idle")

func _on_machinegun_ui_animation_finished():
	$machinegun_ui.play(current_weapon + "_idle")

func _on_AnimatedSprite2D_animation_finished():
	$AnimatedSprite2D.play(current_weapon + "_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	if !radial_menu:
		if Input.is_action_pressed("shoot") and can_shoot and  current_weapon == "shotgun":
			#$Shoot.stream = preload("res://Shotgun/shotgun-fx_168bpm.wav")
			#$Reload.stream = preload("res://Shotgun/old-school-shotgun-reload.wav")
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


func switch_weapon(to):
	if to == 1:
		current_weapon = "machinegun"
		$Shoot.stream = preload("res://Machinegun/ak47-machine-gun-spray-fx_D_major.wav")
		$AnimatedSprite2D.visible = false
		$AnimatedSprite2D.stop()
		$machinegun_ui.visible = true
		$machinegun_ui.play(current_weapon + "_idle")
		$weapon_crosshair.play(current_weapon + "_crosshair")
	else: if to == 0:
		current_weapon = "shotgun"
		$Shoot.stream = preload("res://Shotgun/shotgun-fx_168bpm.wav")
		$machinegun_ui.visible = false
		$machinegun_ui.stop()
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play(current_weapon + "_idle")
		$weapon_crosshair.play(current_weapon + "_crosshair")
