extends CharacterBody3D
class_name Enemy

@export var max_hitpoints := 100
@export var attack_range = 10.0

const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const AGGRO_RANGE = 40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d = $NavigationAgent3D

var player
var provoked = false		#l'enemy è stato provocato? 
var attacking = false
var hitpoints = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free()
		provoked = true

func _ready() -> void:
	$AnimatedSprite3D.play("default")
	player = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if provoked and !attacking:
		$AnimatedSprite3D.play("walk")
		navigation_agent_3d.target_position = player.global_position
	else: if attacking:
		$AnimatedSprite3D.play("shoot")


func _physics_process(delta):
	var next_position = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= AGGRO_RANGE:
		provoked = true
		
	if provoked and distance <= attack_range:
		attacking = true
		attack()
	else:
		attacking = false
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if !attacking: 
		move_and_slide()


func attack():
	#print("enemy attack!")
	$AnimatedSprite3D.play("shoot")
