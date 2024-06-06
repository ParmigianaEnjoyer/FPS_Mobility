extends Area3D


const HEALTL_VALUE = 20.0
const MAX_QUANTITY = 5

var quantity = 0	#mettere globale


func _ready():
	if quantity == MAX_QUANTITY:
		queue_free()
	
	decide_to_drop()



func decide_to_drop():
	var prob_drop = calcola_probabilita()
	var random_number = randf()
	
	if random_number < prob_drop:
		pass
	else:
		queue_free()


func calcola_probabilita():
	var percentuale_salute = float(GlobalVar.player_health) / 100.0
	var prob_drop = 1.0 - percentuale_salute
	
	return prob_drop


func _on_body_entered(body):
	if body.is_in_group("player"):
		if quantity < MAX_QUANTITY:
			quantity += 1
	queue_free()
