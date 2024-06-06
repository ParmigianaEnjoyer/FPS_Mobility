extends Control


func _on_riprova_pressed():
	GlobalVar.player_health = 100
	if GlobalVar.livello == 0:
		get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	else: if GlobalVar.livello == 1:
		get_tree().change_scene_to_file("res://Scenes/FirstLevel.tscn")


func _on_indietro_pressed():
	GlobalVar.player_health = 100
	get_tree().change_scene_to_file("res://MenuPrincipale/menu.tscn")
