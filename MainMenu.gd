extends Node2D

func _ready():
	get_node("PlayVsAi").set_position(Vector2(get_viewport().size.x/3,100))
	pass

func _on_PlayVsAi_pressed():
	get_tree().change_scene("res://BarzakhWoldScene.tscn")
	pass

func _on_Quit_pressed():
	get_tree().quit()
	pass

func _on_Amstudyo_pressed():
	OS.shell_open('https://amstudyo.com')
	pass
