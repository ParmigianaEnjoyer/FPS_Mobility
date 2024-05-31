extends Node3D

const SPEED = 100.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
var damage = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	ray.force_raycast_update()

	if ray.is_colliding() and ray.get_collider() is Player:
		mesh.visible = false
		ray.get_collider().player_health -= damage
		ray.get_collider().take_damage()
		print(ray.get_collider().player_health)
		queue_free()


func _on_timer_timeout():
	queue_free()
