extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles3D.emitting = true
	look_at(get_tree().get_first_node_in_group("player").global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
