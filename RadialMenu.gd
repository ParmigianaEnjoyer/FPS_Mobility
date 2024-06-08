extends Control

@onready var cam = get_parent()
@onready var ragebar = $"../ui/Ragebar"

var time_scale_target = 1.0
var interpolation = 1.0

var current_item = -1

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("radial_menu") and !get_tree().paused and !GlobalVar.rage_mode:
		$AnimationPlayer.play("zoom")
		get_node("../ui/Weapon").visible = false
		
		time_scale_target = 0.0
		interpolation = 0.0
		
		get_node("../ui").radial_menu = true
		cam.set_process_input(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().paused = true
		show()
		
	if event.is_action_released("radial_menu"):
		get_node("../ui/Weapon").visible = true
		radial_menu_off()


func radial_menu_off():
	$AnimationPlayer.play_backwards("zoom")
	$AnimationPlayer.seek(0)
	
	time_scale_target = 1.0
	Engine.time_scale = 1.0
	
	get_node("../ui").radial_menu = false
	cam.set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	
	if current_item != -1:
		get_node("../ui").switch_weapon(current_item)


func _physics_process(delta):
	if interpolation <= 1.0:
		interpolation += delta
	
	#Engine.time_scale = 1
	Engine.time_scale = lerp(Engine.time_scale, time_scale_target, interpolation)
