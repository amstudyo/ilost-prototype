extends Node2D

var damage_done = 0

func _ready():
	var ViewPortSize = get_viewport().size
	var ViewPortSizeX = get_viewport().size.x - 300
	var ViewPortSizeY = get_viewport().size.y - 160
	get_node("MidWorld").set_size(ViewPortSize)
	get_node("Thunder").set_size(ViewPortSize)
	#set responsive positions
	get_node("I_Lost").set_position(Vector2(ViewPortSizeX,50))
	get_node("Ability_Hide").set_position(Vector2(50,ViewPortSizeY))
	get_node("Ability_LightEffect").set_position(Vector2(200,ViewPortSizeY))
	get_node("Ability_Thunder").set_position(Vector2(ViewPortSizeX+100,ViewPortSizeY))
	get_node("Kheir").set_position(Vector2(300,get_viewport().size.y/2-20))
	get_node("LightEffect").set_position(Vector2(300,get_viewport().size.y/2-20))
	get_node("Shar").set_position(Vector2(get_viewport().size.x - 300,get_viewport().size.y/2-20))
	pass

#GAME OVER
func _on_I_Lost_pressed():
	get_tree().quit()
	pass

#Kheir Ability: Hide 
func _on_Ability_Hide_pressed():
	get_node("Ability_Hide/Ability_Hide_timer").start()
	get_node("Ability_Hide/Ability_hide_usable_timer").start()
	get_node("Kheir").visible = false
	get_node("Ability_Hide").visible = false
	pass
func _on_Ability_Hide_timer_timeout():
	get_node("Kheir").visible = true
	pass
func _on_Ability_hide_usable_timer_timeout():
	get_node("Ability_Hide").visible = true
	pass

#Kheir Abilit: Thunder
func _on_Ability_Thunder_pressed():
	get_node("Ability_Thunder/Ability_Thunder_Timer").start()
	get_node("Thunder").visible = true
	damage_done = damage_done + 1
	get_node("Damage_Done").text = str(damage_done)
	pass
func _on_Ability_Thunder_Timer_timeout():
	get_node("Thunder").visible = false
	pass

#Kheir Ability: LightEffect
func _on_Ability_LightEffect_pressed():
	get_node("LightEffect").visible = true
	get_node("Ability_LightEffect").visible = false
	get_node("LightEffect/LightEffect_Timer").start()
	get_node("LightEffect/LE_destroyer_timer").start()
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
	pass

#Shar AI
