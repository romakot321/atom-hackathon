extends Control

signal button_resume_clicked()


func _ready():
	pass 





func _on_button_resume_pressed():
	emit_signal(
		"button_resume_clicked"
	)
