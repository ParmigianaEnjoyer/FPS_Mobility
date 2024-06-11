extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5
const AGGRO_RANGE = 100.0
const ATTACK_RANGE = 30.0
const ATTACK_COOLDOWN = 2	#secondi che separano un attacco dall'altro

@export var max_hitpoints := 1000 * GlobalVar.diff	#100
@export var fire_rate = 2.0 		#numero di colpidsparati in un secondo
@export var damage = 10 * GlobalVar.diff

var punches_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var timer = $CooldownTimer
@onready var d_timer = $DamageTimer
@onready var healthbar = $HealthBar

var player
var provoked = false		#l'enemy è stato provocato? 
var attacking = false
var dead = false
var stop = false

var bullet = load("res://Enemy/marius_punches.tscn")
var instance
var ammo = load("res://Drops/ammo_drop.tscn")
var ammo_instance
var heart = load("res://Drops/heart_drop.tscn")
var heart_instance
var prova = 100
var hitpoints = max_hitpoints:
	set(value):
		hitpoints = value
		prova -= 1
		if hitpoints <= 0:
			die()
		provoked = true


func _ready() -> void:
	ray.target_position.z = (ATTACK_RANGE * -1) - 1
	$AnimatedSprite3D.play("default")
	player = get_tree().get_first_node_in_group("player")
	#healthbar.init_health(max_hitpoints)
	$HealthBar/TextureRect.visible = false
	healthbar.init_health(float(max_hitpoints / 10))


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
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var direction = global_position.direction_to(next_position)
		var distance = global_position.distance_to(player.global_position)
		
			
		if distance <= AGGRO_RANGE:
			provoked = true
			
		if (provoked and distance <= float(ATTACK_RANGE * 0.75)) or attacking:
			if ray.is_colliding() and ray.get_collider().is_in_group("player"):
				attacking = true
				attack()
			elif !ray.is_colliding() or (ray.is_colliding() and !ray.get_collider().is_in_group("player")):
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
		timer.start(ATTACK_COOLDOWN)
		
		punches_count += 1
		match punches_count % 2:
			0: $AnimatedSprite3D.play("attack_left")
			1: $AnimatedSprite3D.play("attack_right")
			
		instance = bullet.instantiate()
		instance.position = ray.global_position
		instance.transform.basis = ray.global_transform.basis
		get_parent().add_child(instance)


func take_damage():
	if !dead:
		$Voice.play()
		healthbar.health = float(hitpoints / 10)


func die():
	if !dead:
		dead = true  # Corrected variable scope
		$Voice.play()
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)#disattivo le collisioni così posso attraversarlo quando muore
		GlobalVar.enemy_killed_count += 1
