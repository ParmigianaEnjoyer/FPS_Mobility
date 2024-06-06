extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_controlli_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/Remap.tscn") #va al menu di remap


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/audio.tscn") #va al menu dell'audio


func _on_indietro_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn") #cambia a menu principale
