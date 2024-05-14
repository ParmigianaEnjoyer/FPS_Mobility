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
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		if !($Shoot.playing or $Reload.playing):
			$AnimatedSprite2D.play("shotgun_shoot")
			$Shoot.play()
			$Reload.play()
			time_since_last_shot = 0.0
	
