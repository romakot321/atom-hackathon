extends Control

signal button_win_start_clicked()


func _ready():
	pass 



func _on_button_win_play_again_pressed():
	emit_signal(
		"button_win_start_clicked"
	)
