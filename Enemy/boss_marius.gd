extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5
const AGGRO_RANGE = 100.0
const ATTACK_RANGE = 30.0
const ATTACK_COOLDOWN = 2.0	#secondi che separano un attacco dall'altro
const SPECIAL_ATTACK_COOLDOWN = 0.5

@export var max_hitpoints := 2000 * GlobalVar.diff	#100
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
@onready var specialtimer = $Timers/SpecialAttackTimer
@onready var punchtimer = $Timers/PunchTimer
@onready var voice = $Voice

var is_special_attack = false
var player
var provoked = false		#l'enemy è stato provocato? 
var attacking = false
var dead = false
var stop = false
var count = 0
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
var special1 = false
var special2 = false
var special3 = false
var special4 = false


func _ready() -> void:
	$Intro.play()
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
			$Walk.stop()
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
		
		if ((provoked and distance <= float(ATTACK_RANGE * 0.75)) or attacking) and !is_special_attack:
			if ray.is_colliding() and ray.get_collider().is_in_group("player"):
				attacking = true
				attack()
			elif !ray.is_colliding() or (ray.is_colliding() and !ray.get_collider().is_in_group("player")):
				attacking = false
		
		check_special()
		
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
		$Walk.stop()
		$Shoot.play()
		instance = bullet.instantiate()
		instance.position = ray.global_position
		instance.transform.basis = ray.global_transform.basis
		get_parent().add_child(instance)


func special_attack():
		if specialtimer.is_stopped() and count <= 5:
			specialtimer.start(SPECIAL_ATTACK_COOLDOWN)
			count += 1
			
			$AnimatedSprite3D.play("attack_fury")
			$Walk.stop()
			$Shoot.play()
			#punches_count += 1
			#match punches_count % 2:
				#0: $AnimatedSprite3D.play("attack_left")
				#1: $AnimatedSprite3D.play("attack_right")
			
			for i in range(0, 9, 1):
				var x = 1
				var z = 1
				match i:
					0: 
						x = 0
						z = -1
					1: 
						x = -1
						z = -1
					2: 
						x = -1
						z = 0
					3: 
						x = -1
						z = +1
					4: 
						x = 0
						z = +1
					5: 
						x = +1
						z = +1
					6: 
						x = +1
						z = 0
					7: 
						x = +1
						z = -1
				instance = bullet.instantiate()
				instance.is_special_attack = true
				instance.x = x
				instance.z = z
				instance.position = ray.global_position
				instance.transform.basis = ray.global_transform.basis
				get_parent().add_child(instance)


func check_special():
	if healthbar.value <= 75 and !special1:
		is_special_attack = true
		special_attack()
		
		if count == 5:
			special1 = true
		
	if healthbar.value <= 50 and !special2:
		is_special_attack = true
		special_attack()
		
		if count == 5:
			special2 = true
		
	if healthbar.value <= 25 and !special3:
		is_special_attack = true
		special_attack()
		
		if count == 5:
			special3 = true
		
	if healthbar.value <= 10 and !special4:
		is_special_attack = true
		special_attack()
		
		if count == 5:
			special4 = true
		
	if count == 5:
		count = 0
		is_special_attack = false


func take_damage():
	if !dead:
		$Hit.play()
		healthbar.health = float(hitpoints / 20)


func die():
	if !dead:
		dead = true  # Corrected variable scope
		$Die.play()
		$Walk.stop()
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)#disattivo le collisioni così posso attraversarlo quando muore
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		GlobalVar.enemy_killed_count += 1
