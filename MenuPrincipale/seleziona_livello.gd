extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tutorial_livello_0_pressed():
	GlobalVar.reset_richiesto = true
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn") #fa partire il tutorial


func _on_livello_1_pressed():
	GlobalVar.reset_richiesto = true
	get_tree().change_scene_to_file("res://Scenes/FirstLevel.tscn") #fa partire il primo livello


func _on_indietro_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn") #torna indietro al menu principale
