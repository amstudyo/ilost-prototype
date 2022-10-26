extends Node2D

var damage_done = 0
var damage_received = 0
var kheir_shield = 0
var shar_shield = 0
var child1_bounded = 0
var child2_bounded = 0
const SAVE_DIR = 'user://saves'
var save_path = SAVE_DIR + "save.dat"

func _ready():
	var ViewPortSize = get_viewport().size
	var ViewPortSizeXshar = get_viewport().size.x-(get_viewport().size.x/4)
	var ViewPortSizeX = get_viewport().size.x - 300
	var ViewPortSizeY = get_viewport().size.y - 160
	get_node("MidWorld").set_size(ViewPortSize)
	get_node("Thunder").set_size(ViewPortSize)
	#set responsive positions
	get_node("I_Lost").set_position(Vector2(ViewPortSizeX,50))
	get_node("Ability_Hide").set_position(Vector2(50,ViewPortSizeY))
	get_node("Ability_LightEffect").set_position(Vector2(200,ViewPortSizeY))
	get_node("Ability_Thunder").set_position(Vector2(ViewPortSizeX+100,ViewPortSizeY))
	get_node("Unbound_Child1").set_position(Vector2(ViewPortSizeX,ViewPortSizeY))
	get_node("Unbound_Child2").set_position(Vector2(ViewPortSizeX-80,ViewPortSizeY))
	get_node("Kheir").set_position(Vector2(get_viewport().size.x/4,get_viewport().size.y/2-20))
	get_node("LightEffect").set_position(Vector2(get_viewport().size.x/4,get_viewport().size.y/2-20))
	get_node("Shar").set_position(Vector2(ViewPortSizeXshar,get_viewport().size.y/2-20))
	get_node("DarkWood").set_position(Vector2(get_viewport().size.x/4,get_viewport().size.y/2+30))
	get_node("Fire").set_position(Vector2(get_viewport().size.x/4,get_viewport().size.y/2+50))
	#AI
	get_node("Shar/Random_Ability_Timer").start()
	pass

#GAME OVER
func _on_I_Lost_pressed():
	var highscore = 0
	highscore = int(get_node("Damage_Done").text) - int(get_node("Damage_Recevied").text)
	if highscore <= 0:
		highscore = 0
	
	#load to compare old and new score
	var file = File.new()
	if file.file_exists(save_path):
		var file_error_check = file.open(save_path,File.READ)
		var player_data = file.get_var()
		file.close()
		if highscore <= player_data:
			highscore = player_data
	#load comparing ends here
	
	var data = highscore
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file2 = File.new()
	var file_error_check = file2.open(save_path,File.WRITE)
	if file_error_check == OK:
		file2.store_var(data)
		file2.close()
	get_tree().change_scene("res://MainMenu.tscn")
	pass

#Kheir Ability: Hide 
func _on_Ability_Hide_pressed():
	get_node("Ability_Hide/Ability_Hide_timer").start()
	get_node("Ability_Hide/Ability_hide_usable_timer").start()
	get_node("Kheir").visible = false
	get_node("Ability_Hide").visible = false
	kheir_shield = 1
	get_node("Kheir/hide_audio").play()
	pass
func _on_Ability_Hide_timer_timeout():
	get_node("Kheir").visible = true
	kheir_shield = 0
	pass
func _on_Ability_hide_usable_timer_timeout():
	get_node("Ability_Hide").visible = true
	get_node("Ability_Hide/Ability_Hide_timer").stop()
	get_node("Ability_Hide/Ability_hide_usable_timer").stop()
	get_node("Kheir/thunder_audio").stop()
	pass

#Kheir Ability: Thunder
func _on_Ability_Thunder_pressed():
	get_node("Ability_Thunder/Ability_Thunder_Timer").start()
	get_node("Ability_Thunder/Ability_Thunder_btn_Timer").start()
	get_node("Thunder").visible = true
	get_node("Ability_Thunder").visible = false
	if shar_shield == 0:
		Kheir_dmg()
	get_node("Kheir/thunder_audio").play()
	pass
func _on_Ability_Thunder_Timer_timeout():
	get_node("Thunder").visible = false
	pass
func _on_Ability_Thunder_btn_Timer_timeout():
	get_node("Ability_Thunder/Ability_Thunder_Timer").stop()
	get_node("Ability_Thunder/Ability_Thunder_btn_Timer").stop()
	get_node("Ability_Thunder").visible = true
	get_node("Kheir/thunder_audio").stop()
	pass
#Kheir Ability: LightEffect
func _on_Ability_LightEffect_pressed():
	if shar_shield == 0:
		Kheir_dmg()
	get_node("Damage_Done").text = str(damage_done)
	get_node("LightEffect").visible = true
	get_node("Ability_LightEffect").visible = false
	get_node("LightEffect/LightEffect_Timer").start()
	get_node("LightEffect/LE_destroyer_timer").start()
	get_node("Kheir/Wind_audio").play()
	pass
func _on_LightEffect_Timer_timeout():
	var LightEffectPos = get_node("LightEffect").get_position()
	get_node("LightEffect").set_position(LightEffectPos + Vector2(50,0))
	pass
func _on_LE_destroyer_timer_timeout():
	get_node("LightEffect").set_position(get_node("Kheir").get_position())
	get_node("LightEffect/LightEffect_Timer").stop()
	get_node("LightEffect/LE_destroyer_timer").stop()
	get_node("LightEffect").visible = false
	get_node("Ability_LightEffect").visible = true
	get_node("Kheir/Wind_audio").stop()
	pass

#Kheir Ability: Unbound Child1
func _on_Unbound_Child1_pressed():
	get_node("Unbound_Child1").visible = false
	get_node("Kheir/Kheir_Child1").set_position(Vector2(93.507,187.013))
	child1_bounded = 0
	pass

#Kheir Ability: Unbound Child2
func _on_Unbound_Child2_pressed():
	get_node("Unbound_Child2").visible = false
	get_node("Kheir/Kheir_Child2").set_position(Vector2(243.117,187.013))
	child2_bounded = 0
	pass

func Kheir_dmg():
	if child1_bounded == 1 and child2_bounded == 0:
		damage_done = damage_done + 2
	elif child1_bounded == 0 and child2_bounded == 1:
		damage_done = damage_done + 2
	elif child1_bounded == 1 and child2_bounded == 1:
		damage_done = damage_done + 1
	else:
		damage_done = damage_done + 3
	get_node("Damage_Done").text = str(damage_done)
	pass

#Shar AI
func _on_Random_Ability_Timer_timeout():
	var randomize_attack_gen = RandomNumberGenerator.new()
	randomize_attack_gen.randomize()
	var randomize_attack = randomize_attack_gen.randf_range(0.0, 50.0)
	if randomize_attack <= 10:
		Shar_Fire()
	elif randomize_attack <= 20:
		Shar_DarkWood()
	elif randomize_attack <= 30:
		Shar_Invert()
	elif randomize_attack <= 40:
		Shar_Thief_Child1()
	else:
		Shar_Thief_Child2()
	pass
func Shar_Fire():
	get_node("Fire").visible = true
	get_node("Fire/Fire_Destroy_Timer").start()
	if kheir_shield == 0:
		damage_received = damage_received + 3
		get_node("Damage_Recevied").text = str(damage_received)
	get_node("Shar/fire_audio").play()
	pass
func _on_Fire_Destroy_Timer_timeout():
	get_node("Fire").visible = false
	get_node("Fire/Fire_Destroy_Timer").stop()
	get_node("Shar/fire_audio").stop()
	pass
func Shar_DarkWood():
	get_node("DarkWood").visible = true
	get_node("DarkWood/DarkWood_Destroy_Timer").start()
	if kheir_shield == 0:
		damage_received = damage_received + 3
		get_node("Damage_Recevied").text = str(damage_received)
	get_node("Shar/Wood_audio").play()
	pass
func _on_DarkWood_Destroy_Timer_timeout():
	get_node("DarkWood").visible = false
	get_node("DarkWood/DarkWood_Destroy_Timer").stop()
	get_node("Shar/invert_audio").stop()
	pass
func Shar_Invert():
	get_node("Shar").flip_v = true
	get_node("Shar").set_position(Vector2(get_viewport().size.x - 300,get_viewport().size.y/5))
	shar_shield = 1
	get_node("Shar/Shar_Invert_Timer").start()
	get_node("Shar/invert_audio").play()
	pass
func _on_Shar_Invert_Timer_timeout():
	var ViewPortSizeXshar = get_viewport().size.x-(get_viewport().size.x/4)
	get_node("Shar").flip_v = false
	get_node("Shar").set_position(Vector2(ViewPortSizeXshar,get_viewport().size.y/2-20))
	shar_shield = 0
	get_node("Shar/Shar_Invert_Timer").stop()
	get_node("Shar/invert_audio").stop()
	pass
func Shar_Thief_Child1():
	get_node("Kheir/Kheir_Child1").set_position(Vector2(get_viewport().size.x/2,get_viewport().size.y/2-20))
	child1_bounded = 1
	get_node("Unbound_Child1").visible = true
	pass
func Shar_Thief_Child2():
	get_node("Kheir/Kheir_Child2").set_position(Vector2(get_viewport().size.x/2 + 150,get_viewport().size.y/2-20))
	child2_bounded = 1
	get_node("Unbound_Child2").visible = true
	pass
