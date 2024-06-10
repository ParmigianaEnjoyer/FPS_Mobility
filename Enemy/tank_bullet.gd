extends Node3D

const SPEED = 30.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var lifetime = $Timer

var damage = 10
var bullet_range = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime.start(calculate_bullet_lifetime(bullet_range))
	mesh.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	ray.force_raycast_update()

	if ray.is_colliding() and ray.get_collider().is_in_group("player"):
		mesh.visible = false
		ray.get_collider().take_damage(damage)
		queue_free()


func calculate_bullet_lifetime(the_bullet_range):
	if SPEED != 0:
		return float(the_bullet_range / SPEED)


func _on_timer_timeout():
	queue_free()
