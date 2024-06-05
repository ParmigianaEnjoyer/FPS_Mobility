extends Control
 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_facile_pressed():
	GlobalVar.diff = 0.5  #imposta difficoltà a facile (1)


func _on_medio_pressed():
	GlobalVar.diff = 1  #imposta difficoltà a medio (2)


func _on_difficile_pressed():
	GlobalVar.diff = 1.5  #imposta difficoltà a difficile (3)


func _on_indietro_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn") #torna indietro al menu principale
