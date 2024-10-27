extends Application

const card_helper = preload("res://util/card_helper.gd")

var list_avaliable_card_ids = [
	"101",
	"102",
	"105",
	"106",
	"109",
	"110",
	"200",
	"201",
	"202",
	"204",
	"205",
	"300",
	"301",
	"302",
	"304",
	"305",
	"600",
	"601",
	"602",
	"700",
	"701",
	"702",
	"800",
	"801",
	"802",
	"900",
	"901",
	"902",
]

var list_used_cards = [
	
]
var list_used_skills = [
	
]

var card1
var card2 
var card3

func _ready():
	api('connect_to_input', {
		'target_node' : self,
		'on_input' : 'on_input'
	})
	
func on_input(type, state):
	pass
	
func use_card(card):
	list_avaliable_card_ids.remove(list_avaliable_card_ids.find(card["id"]))
	list_used_cards.push_back(card)
	if card["type"] == "skill":
		list_used_skills.push_back(card)
	
func generate_card_hand():
	var hand = []
	
	var can_take = false
	while not can_take:
		var cardId = card_helper.get_random_array_value(list_avaliable_card_ids)
		var card = card_helper.load_card(cardId)
		if card["type"]=="upgrade":
			for used_skill in list_used_skills:
				if card["tag"]==used_skill["tag"]:
					can_take = true
					hand.push_back(card)
					break
		else:
			can_take = true
			hand.push_back(card)
			
	
	can_take = false
	while not can_take:
		var cardId = card_helper.get_random_array_value(list_avaliable_card_ids)
		var card = card_helper.load_card(cardId)
		
		var is_same_tag = false
		for card_in_hand in hand:
			if card_in_hand["tag"] == card["tag"]:
				is_same_tag = true
				break
		if is_same_tag:
			continue
				
		if card["type"]=="upgrade":
			for used_skill in list_used_skills:
				if card["tag"]==used_skill["tag"]:
					can_take = true
					hand.push_back(card)
					break
		else:
			can_take = true
			hand.push_back(card)
			
	can_take = false
	while not can_take:
		var cardId = card_helper.get_random_array_value(list_avaliable_card_ids)
		var card = card_helper.load_card(cardId)
		
		var is_same_tag = false
		for card_in_hand in hand:
			if card_in_hand["tag"] == card["tag"]:
				is_same_tag = true
				break
		if is_same_tag:
			continue
				
		if card["type"]=="upgrade":
			for used_skill in list_used_skills:
				if card["tag"]==used_skill["tag"]:
					can_take = true
					hand.push_back(card)
					break
		else:
			can_take = true
			hand.push_back(card)
		
		return hand




func _on_button_test_pressed():
	var cards = generate_card_hand()
	print(cards)
	card1 = cards[0]
	card2 = cards[1]
	card3 = cards[2]



func _on_button_card1_pressed():
	use_card(card1)


func _on_button_card2_pressed():
	use_card(card2)


func _on_button_card3_pressed():
	use_card(card3)
