extends Control

const card_helper = preload("res://util/card_helper.gd")

signal card_first_selected(card)
signal card_second_selected(card)
signal card_third_selected(card)


var card1

var card2

var card3

func _ready():
	$texture_card1.connect("button_select_card_clicked", self, "_on_button_card1_pressed")
	$texture_card1.card = card1
	$texture_card1.on_attached()
	
	$texture_card2.connect("button_select_card_clicked", self, "_on_button_card2_pressed")
	$texture_card2.card = card2
	$texture_card2.on_attached()
	
	$texture_card3.connect("button_select_card_clicked", self, "_on_button_card3_pressed")
	$texture_card3.card = card3
	$texture_card3.on_attached()



func _on_button_card1_pressed():
	print("cards listened")
	emit_signal("card_first_selected", card1)
	

func _on_button_card3_pressed():
	emit_signal("card_third_selected", card3)


func _on_button_card2_pressed():
	emit_signal("card_second_selected", card2)

