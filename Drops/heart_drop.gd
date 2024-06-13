extends Area3D


const HEALTL_VALUE = 20.0
const MAX_QUANTITY = 5


func _ready():
	if GlobalVar.heart_inventory == MAX_QUANTITY:
		queue_free()
	else:
		decide_to_drop()


func decide_to_drop():
	var prob_drop = calcola_probabilita()
	var random_number = randf()
	
	if !GlobalVar.curarsi_sbloccato:
		pass
	elif random_number < prob_drop:
		pass
	else:
		queue_free()


func calcola_probabilita():
	var percentuale_salute = float(GlobalVar.player_health) / 100.0
	var prob_drop = 1.0 - percentuale_salute
	
	return prob_drop


func _on_body_entered(body):
	if body.is_in_group("player"):
		
		if GlobalVar.heart_inventory < MAX_QUANTITY:
			GlobalVar.heart_inventory += 1
	queue_free()
