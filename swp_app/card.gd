extends TextureRect

const card_helper = preload("res://util/card_helper.gd")

signal button_select_card_clicked()

var card

func _ready():
	pass

func on_attached():
	$text_card_name.text = str(card["id"])
	$text_card_description.text = card["description"]
	var icon = card_helper.load_card_icon(str(card["id"]))
	print("texture", icon)
	$texture_card_icon.texture = icon


func _on_button_card_ghost_pressed():
	emit_signal(
		"button_select_card_clicked"
	)
