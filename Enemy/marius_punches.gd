extends Node3D

var SPEED = 20.0

@onready var animation = $AnimatedSprite3D
@onready var lifetime = $Timer

var is_special_attack = false
var damage = 25
var bullet_range = 25
var x = 0.0
var z = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime.start(calculate_bullet_lifetime(bullet_range))
	animation.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_special_attack:
		position += transform.basis * Vector3(0, 0, -SPEED) * delta
	else: 
		position += transform.basis * Vector3(x * SPEED, 0, z * SPEED) * delta
	#ray.force_raycast_update()
#
	#if ray.is_colliding() and ray.get_collider().is_in_group("player"):
		#animation.visible = false
		##ray.get_collider().player_health -= damage
		#ray.get_collider().take_damage(damage)
		#queue_free()



func _on_timer_timeout():
	queue_free()


func calculate_bullet_lifetime(the_bullet_range):
	if SPEED != 0:
		return the_bullet_range / SPEED


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()