extends ProgressBar

@onready var timer = $Timer


const RAGE_POINT = 2 #20
const RAGE_TIMER = 20.0

func _ready():
	init_points()


func _process(_delta):
	$".".value = GlobalVar.enemy_killed_count
	var somma_munizioni = GlobalVar.ammo_storage_total[GlobalVar.ammo_type.PISTOL_BULLET] + GlobalVar.ammo_storage_total[GlobalVar.ammo_type.MACHINEGUN_BULLET] + GlobalVar.ammo_storage_total[GlobalVar.ammo_type.SHOTGUN_BULLET]
	
	print(somma_munizioni)
	
	if reached_rage_point() and !GlobalVar.rage_mode:
		timer.start(RAGE_TIMER)
		GlobalVar.rage_mode = true
		$AnimatedSprite2D.play("animated")
		
	if somma_munizioni == 0:
		timer.stop()
		init_points()


func init_points():
	GlobalVar.rage_mode = false
	GlobalVar.enemy_killed_count = 0
	$".".value = 0
	$".".max_value = RAGE_POINT
	$AnimatedSprite2D.play("default")
	


func reached_rage_point():
	var answer = false
	
	if $".".value == RAGE_POINT:
		answer = true
	else:
		answer = false	
	
	return answer


func _on_timer_timeout():
	init_points()
