extends Node2D

const SAVE_DIR = 'user://saves'
var save_path = SAVE_DIR + "save.dat"
var highscore = 0

func _ready():
	LoadData()
	get_node("PlayVsAi").set_position(Vector2(get_viewport().size.x/3,150))
	pass

func _on_PlayVsAi_pressed():
	get_tree().change_scene("res://BarzakhWoldScene.tscn")
	pass

func _on_Quit_pressed():
	get_tree().quit()
	pass

func _on_Amstudyo_pressed():
	OS.shell_open('https://ilost.amstudyo.com')
	pass

func LoadData():
	var file = File.new()
	if file.file_exists(save_path):
		var file_error_check = file.open(save_path,File.READ)
		var player_data = file.get_var()
		file.close()
		highscore = player_data
	get_node("PlayVsAi/HighScore").text = str(highscore)
	pass
