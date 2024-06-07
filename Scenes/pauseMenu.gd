extends Control

func _ready():
	hide()

func resume():
	$AnimationPlayer.play_backwards("blur")
	get_tree().paused = false
	
func pause():
	$AnimationPlayer.play("blur")
	get_tree().paused = true
	
func _input(event):
	if event.is_action_pressed("exit") and !get_tree().paused:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause()
	elif event.is_action_pressed("exit") and get_tree().paused:
		resume()
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_riprendi_pressed():
	resume()
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_ricomincia_pressed():
	resume()
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()

func _on_esci_pressed():
	resume()
	hide()
	get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn")
	

