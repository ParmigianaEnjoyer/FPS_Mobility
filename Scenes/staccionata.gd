extends Node3D

func disattiva():
	$StaticBody3D.set_collision_layer_value(10, false)
	$StaticBody3D.set_collision_mask_value(10, false)
	$".".visible = false

func attiva():
	$StaticBody3D.set_collision_layer_value(10, true)
	$StaticBody3D.set_collision_mask_value(10, true)
	$".".visible = true
