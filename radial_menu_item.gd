extends Control


#func _on_texture_button_pressed():
#	get_node("../../../ui/").switch_weapon(name.to_int())
#	get_node("../../").radial_menu_off()


func _on_texture_button_mouse_entered():
	get_node("../../").current_item = name.to_int()
	if Input.is_action_just_released("radial_menu"):
		get_node("../../").radial_menu_off()


#func _on_texture_button_mouse_exited():
	#get_node("../../").current_item = -1
