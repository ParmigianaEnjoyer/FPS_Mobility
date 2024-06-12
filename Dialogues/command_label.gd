extends Control

@onready var label = $Label

var stringa = ""

func _ready():
	pass


func _process(_delta):
	label.text = stringa



func end():
	queue_free()
