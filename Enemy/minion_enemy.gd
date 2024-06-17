extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
var AGGRO_RANGE = 50.0
const ATTACK_RANGE = 3.0
const ATTACK_COOLDOWN = 1	#secondi che separano un attacco dall'altro
const WAIT_BEFORE_FOLLOW_AGAIN = 1.5 		#tempo che il nemico aspetta se il player si allontana prima di seguirlo nuovamente

@export var max_hitpoints := 50 * GlobalVar.diff	#100
@export var fire_rate = 2.0 		#numero di colpidsparati in un secondo
@export var damage = 1 * GlobalVar.diff


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var timer = $CooldownTimer
@onready var d_timer = $DamageTimer
@onready var move_again_timer = $MoveAgainTimer

var player
var provoked = false		#l'enemy è stato provocato? 
var attacking = false
var dead = false
var stop = false

var bullet = load("res://Enemy/bullet.tscn")
var instance
var ammo = load("res://Drops/ammo_drop.tscn")
var ammo_instance
var heart = load("res://Drops/heart_drop.tscn")
var heart_instance

var hitpoints = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			die()
		provoked = true


func _ready() -> void:
	ray.target_position.z = (ATTACK_RANGE * -1) - 1
	$AnimatedSprite3D.play("default")
	player = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if !dead and provoked and !attacking:
		$AnimatedSprite3D.play("walk")
		$Walk.play()
		navigation_agent_3d.target_position = player.global_position
	elif dead:
		if !stop:
			$AnimatedSprite3D.play("die")
			$Walk.stop()
			stop = true
	
	if !move_again_timer.is_stopped() and !attacking and !dead:
		$AnimatedSprite3D.play("default")


func _physics_process(delta):
		
	if !dead:
		var next_position = navigation_agent_3d.get_next_path_position()
		
		ray.look_at(player.global_position)
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
			
		if distance > ATTACK_RANGE:
			attacking = false
		
		if (provoked and distance <= float(ATTACK_RANGE * 0.75)) or attacking:
			attacking = true
			if ray.is_colliding() and ray.get_collider().is_in_group("player"):
				attacking = true
				attack()
				move_again_timer.start(WAIT_BEFORE_FOLLOW_AGAIN)
			elif !ray.is_colliding() or (ray.is_colliding() and !ray.get_collider().is_in_group("player")):
				attacking = false
		#else:
			#attacking = false
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if GlobalVar.is_boss_dead:
			die()
		
		if !attacking and move_again_timer.is_stopped(): 
			move_and_slide()


func attack():
	if timer.is_stopped():
		timer.start(ATTACK_COOLDOWN)
		$AnimatedSprite3D.play("shoot")
		$Walk.stop()
		$Shoot.play()
		instance = bullet.instantiate()
		instance.damage = damage
		instance.SPEED = 10
		instance.position = ray.global_position
		instance.transform.basis = ray.global_transform.basis
		get_parent().add_child(instance)


func take_damage():
	if !dead:
		$Hit.play()


func die():
	if !dead:
		dead = true  # Corrected variable scope
		$Die.play()
		$Walk.stop()
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)#disattivo le collisioni così posso attraversarlo quando muore
		GlobalVar.enemy_killed_count += 1
		GlobalVar.num_nemici_morti_nel_livello += 1
		if GlobalVar.enemy_in_bossfight > 0:
			GlobalVar.enemy_in_bossfight -= 1 
	decide_what_to_drop()


func ammo_drop():
	#DROP DELLE MUNIZIONI
	ammo_instance = ammo.instantiate() 
	ammo_instance.position = ray.global_position
	#instance.transform.basis = ray.global_transform.basis
	get_parent().add_child(ammo_instance)


func heart_drop():
	#DROP DEL CUORE (CURA)
	heart_instance = heart.instantiate()
	heart_instance.position = ray.global_position
	#instance.transform.basis = ray.global_transform.basis
	get_parent().add_child(heart_instance)	


func decide_what_to_drop():
	var probabilita = calcola_prob()
	var random_number = randf()
	
	if probabilita[0] == 0 and probabilita[1] == 0:
		pass
	else: 
		if random_number < probabilita[0]:
			ammo_drop()
		else:
			heart_drop()


func calcola_prob():
	var count_munizioni_totali_attuali = GlobalVar.ammo_storage_total[GlobalVar.ammo_type.PISTOL_BULLET] + GlobalVar.ammo_storage_total[GlobalVar.ammo_type.MACHINEGUN_BULLET] + GlobalVar.ammo_storage_total[GlobalVar.ammo_type.SHOTGUN_BULLET]
	const COUNT_MUNIZIONI_TOTALI_MAX = GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.PISTOL_BULLET] + GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.MACHINEGUN_BULLET] + GlobalVar.AMMO_MAX_STORAGE[GlobalVar.ammo_type.SHOTGUN_BULLET]
	
	var perc_ammo = float(count_munizioni_totali_attuali) / float(COUNT_MUNIZIONI_TOTALI_MAX)
	var perc_heart = float(GlobalVar.player_health) / 100.0
	
	var prob_ammo = 1.0 - perc_ammo
	var prob_heart = 1.0 - perc_heart
	
	return [prob_ammo, prob_heart]
