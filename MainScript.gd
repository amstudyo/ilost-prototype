extends Node2D

func _ready():
	var ViewPortSize = get_viewport().size
	get_node("MidWorld").set_size(ViewPortSize)
	get_node("Thunder").set_size(ViewPortSize)
	pass

#GAME OVER
func _on_I_Lost_pressed():
	get_tree().quit()
	pass

#Kheir Ability: Hide 
func _on_Ability_Hide_pressed():
	get_node("Ability_Hide/Ability_Hide_timer").start()
	get_node("Kheir").visible = false
	pass
func _on_Ability_Hide_timer_timeout():
	get_node("Kheir").visible = true
	pass

#Kheir Abilit: Thunder
func _on_Ability_Thunder_pressed():
	get_node("Ability_Thunder/Ability_Thunder_Timer").start()
	get_node("Thunder").visible = true
	pass
func _on_Ability_Thunder_Timer_timeout():
	get_node("Thunder").visible = false
	pass

#Kheir Ability: LightEffect
func _on_Ability_LightEffect_pressed():
	get_node("LightEffect").visible = true
	get_node("LightEffect/LightEffect_Timer").start()
	pass
func _on_LightEffect_Timer_timeout():
	var LightEffectPos = get_node("LightEffect").get_position()
	get_node("LightEffect").set_position(LightEffectPos + Vector2(30,0))
	pass
func _on_LightEffect_Distroy_timeout():
	get_node("LightEffect").set_position()
	get_node("LightEffect/LightEffect_Timer").stop()
	pass

#Shar AI
