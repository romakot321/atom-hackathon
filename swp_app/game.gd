extends Control


signal button_pause_clicked()

signal button_attack_clicked()

var scene_main

func _ready():
	scene_main.connect("health_changed", self, "_on_health_changed")
	scene_main.connect("exp_changed", self, "_on_exp_changed")
	scene_main.connect("level_changed", self, "_on_level_changed")
	scene_main.connect("time_changed", self, "_on_time_changed")
	$text_time_red.visible = false
	$text_time.visible = true
	
	

func _on_health_changed(health):
	print("_on_health_changed()!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	$text_health.text = "HP: " + str(health)	

	
func _on_exp_changed(experience, maxExp):
	print("_on_exp_changed()!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	$progress_exp.value = experience
	$progress_exp.max_value = maxExp
	
func _on_level_changed(level):
	$text_level.text = "LVL: " + str(level)


func _on_button_pause_pressed():
	emit_signal("button_pause_clicked")


func _on_button_attack_pressed():
	emit_signal("button_attack_clicked")
	
func _on_time_changed(minutes, seconds):
	var fminutes = str(minutes)
	var fseconds = str(seconds)
	if len(str(minutes))==1:
		fminutes = "0" + str(minutes)
	if len(str(seconds))==1:
		fseconds = "0" + str(seconds)
		
	var c1 = minutes == 2 and seconds >= 0 and seconds <= 10
	var c2 = minutes == 1 and seconds >= 0 and seconds <= 10
	var c3 = minutes == 0 and seconds >= 0 and seconds <= 10
	if c1 or c2 or c3:
		if seconds%2==0:
			$text_time_red.visible = true
			$text_time.visible = false
			$text_time_red.text = fminutes + ":" + fseconds
		else:
			$text_time_red.visible = false
			$text_time.visible = true
			$text_time.text = fminutes + ":" + fseconds
	else:
		$text_time_red.visible = false
		$text_time.visible = true
		$text_time.text = fminutes + ":" + fseconds
