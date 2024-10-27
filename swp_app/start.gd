extends Control

signal button_start_clicked()
signal button_info_clicked()


func _ready():
	pass 





func _on_button_start_pressed():
	print("Button start pressed!")
	emit_signal(
		"button_start_clicked"
	)


func _on_button_info_pressed():
	print("Button info pressed!")
	emit_signal(
		"button_info_clicked"
	)
