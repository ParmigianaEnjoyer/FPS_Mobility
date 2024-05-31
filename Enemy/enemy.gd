extends CharacterBody3D
class_name Enemy

@export var max_hitpoints := 100
@export var fire_rate = 2.0 		#numero di colpi sparati in un secondo
@export var attack_range = 10.0
@export var damage = 10

const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const AGGRO_RANGE = 40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var timer = $CooldownTimer
@onready var d_timer = $DamageTimer
@onready var projectile_particles = $Enemy_ProjectileParticles

var player
var provoked = false		#l'enemy è stato provocato? 
var attacking = false
var dead = false
var stop = false

var bullet = load("res://Enemy/bullet.tscn")
var instance

var hitpoints = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			die()
		provoked = true


func _ready() -> void:
	$AnimatedSprite3D.play("default")
	player = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if !dead and provoked and !attacking:
		$AnimatedSprite3D.play("walk")
		navigation_agent_3d.target_position = player.global_position
	else: if dead:
		if !stop:
			$AnimatedSprite3D.play("die")
			stop = true


func _physics_process(delta):
		
	if !dead:
		var next_position = navigation_agent_3d.get_next_path_position()
		ray.look_at(player.global_position)
		projectile_particles.look_at(player.global_position)
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
			
		## Handle jump.
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
		
		var direction = global_position.direction_to(next_position)
		var distance = global_position.distance_to(player.global_position)
		
			
		if distance <= AGGRO_RANGE:
			provoked = true
			
		if provoked and distance <= attack_range:
			attacking = true
			if ray.is_colliding() and ray.get_collider() is Player:
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
	if timer.is_stopped():
		timer.start(1.0)
		$AnimatedSprite3D.play("shoot")
		instance = bullet.instantiate()
		instance.position = ray.global_position
		instance.transform.basis = ray.global_transform.basis
		get_parent().add_child(instance)
		#projectile_particles.restart()		#animazione del proiettile
		#if d_timer.is_stopped():
			#d_timer.start(0.1)
			#ray.force_raycast_update()
			#if ray.is_colliding() and randi() % 100 < 70:	#70% di possibilità di fare danno
				#ray.get_collider().player_health -= damage
				#print(ray.get_collider().player_health)


func take_damage():
	if !dead:
		$Voice.play()


func die():
	if !dead:
		dead = true  # Corrected variable scope
		$Voice.play()
		#$CollisionShape3D.disabled = true		#disattivo le collisioni così posso attraversarlo quando muore
