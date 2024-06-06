extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_inizia_pressed():
	get_tree().change_scene_to_file("res://Scenes/schermata_iniziale.tscn") #cambia scena al tutorial


func _on_esci_pressed():
	get_tree().quit() #Chiudi Gioco


func _on_difficoltà_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/difficoltà.tscn") #cambia a menu difficolta


func _on_seleziona_livello_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/seleziona_livello.tscn") #cambia a menu livello


func _on_opzioni_pressed():
	get_tree().change_scene_to_file("res://MenuPrincipale/opzioni.tscn") #cambia a menu opzioni
