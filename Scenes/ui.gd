extends CanvasLayer

var time_since_last_shot = 0.0
var fire_rate = 10.0
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
	$AnimatedSprite2D.play("shotgun_idle")

func _on_AnimatedSprite2D_animation_finished():
	$AnimatedSprite2D.play("shotgun_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	if Input.is_action_pressed("shoot") and can_shoot and $AnimatedSprite2D.is_playing():
		#$Shoot.stream = preload("res://Shotgun/shotgun-fx_168bpm.wav")
		#$Reload.stream = preload("res://Shotgun/old-school-shotgun-reload.wav")
		if !($Shoot.playing or $Reload.playing):
			$AnimatedSprite2D.play("shotgun_shoot")
			$Shoot.play()
			$Reload.play()
			time_since_last_shot = 0.0
	else:
		if Input.is_action_pressed("shoot") and $machinegun_ui.is_playing():
			$machinegun_ui.play("machinegun_shoot")
			if !($Shoot.playing):
				$Shoot.play()
		if Input.is_action_just_released("shoot"):
			$machinegun_ui.play("machinegun_idle")
			time_since_last_shot = 0.0
	
	if Input.is_action_just_pressed("select_machinegun"):
		$Shoot.stream = preload("res://Machinegun/ak47-machine-gun-spray-fx_D_major.wav")
		$AnimatedSprite2D.visible = false
		$AnimatedSprite2D.stop()
		$machinegun_ui.visible = true
		$machinegun_ui.play("machinegun_idle")
		$weapon_crosshair.play("machinegun_crosshair")
