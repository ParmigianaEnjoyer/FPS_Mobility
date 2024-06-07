extends ProgressBar

@onready var timer = $Timer

var rage_mode = false
const RAGE_POINT = 2 #20

func _ready():
	init_points()


func _process(_delta):
	$".".value = GlobalVar.enemy_killed_count
	
	if reached_rage_point() and !rage_mode:
		timer.start(5.0)
		rage_mode = true
		$AnimatedSprite2D.play("animated")
	
	print(str(timer.time_left))

func init_points():
	rage_mode = false
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
