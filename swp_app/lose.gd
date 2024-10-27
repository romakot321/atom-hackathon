extends Control

signal button_lose_play_again_clicked()


func _ready():
	pass 



func _on_button_play_again_pressed():
	emit_signal("button_lose_play_again_clicked")
