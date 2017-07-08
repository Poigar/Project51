extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("CenterContainer/Panel/menu").connect("pressed",self,"_toMenu")
	
	set_process_input(true)

func _input(event):
	
	if Input.is_action_pressed("ui_cancel"):
		if is_visible():
			hide()
		else:
			show()

func _toMenu():
	get_tree().change_scene("res://scenes/main_menu.tscn")