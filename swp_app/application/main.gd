extends Application


const card_helper = preload("res://util/card_helper.gd")
const config = preload("res://util/config.gd")

signal health_changed(health)
signal exp_changed(experience, maxExp)
signal level_changed(level)

signal time_changed(minutes, seconds)

var wasDisconnected = false
var scene_current = null
var scene_current_tag = ""



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
var list_used_skills = [
	{
		"id": 1,
		"name": "shot default",
		"tag": "shot",
		"type": "skill",
		"description": ""
	}
]




var health = config.START_HEALTH
var level = 1
var experience = 0
var maxExperience = config.LEVEL_EXP_COST[0]

var seconds = 0
var minutes = 3


func _ready() -> void:	
	create_start_scene()
	init_ar_engine()
	


func init_ar_engine():
	api('connect_to_hud_app', {
		'target_node' : self,
		'on_message' : 'on_message',
		'on_error' : 'on_error',
		'on_connected' : 'on_connected',
		'on_disconnected' : 'on_disconnected',
	})
	api('connect_to_input', {
		'target_node' : self,
		'on_input' : 'on_input'
	})
	
func on_connected():
	print("Connected to HUD!")
	if wasDisconnected:
		create_start_scene()

func on_disconnected():
	print("Disconnected from HUD!")
	wasDisconnected = true
	
func on_error(error_text:String):
	print("Error in HUD connection: " + error_text)
	
func on_input(type, state):
	pass
	

	
	
func create_start_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_start: PackedScene = load("res://start.tscn")
	var scene_start_inst: Control = scene_start.instance()
	scene_start_inst.connect("button_start_clicked", self, "on_button_start_clicked")
	scene_start_inst.connect("button_info_clicked", self, "on_button_info_clicked")
	$scene_placeholder.add_child(scene_start_inst)
	scene_current = scene_start_inst
	scene_current_tag = config.SCENE_TAG_START
	$timer.start()
	
func create_info_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_info: PackedScene = load("res://info.tscn")
	var scene_info_inst: Control = scene_info.instance()
	scene_info_inst.connect("button_back_clicked", self, "on_button_back_clicked")
	$scene_placeholder.add_child(scene_info_inst)
	scene_current = scene_info_inst
	scene_current_tag = config.SCENE_TAG_INFO

func create_pause_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_pause: PackedScene = load("res://pause.tscn")
	var scene_pause_inst: Control = scene_pause.instance()
	scene_pause_inst.connect("button_resume_clicked", self, "on_button_resume_clicked")
	$scene_placeholder.add_child(scene_pause_inst)
	scene_current = scene_pause_inst
	scene_current_tag = config.SCENE_TAG_PAUSE
	
func create_game_scene():
	
	print("game scene is created!")
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_game: PackedScene = load("res://game.tscn")
	var scene_game_inst: Control = scene_game.instance()
	scene_game_inst.scene_main = self
	scene_game_inst.connect("button_pause_clicked", self, "on_button_pause_clicked")
	scene_game_inst.connect("button_attack_clicked", self, "on_button_attack_clicked")
	$scene_placeholder.add_child(scene_game_inst)
	scene_current = scene_game_inst
	scene_current_tag = config.SCENE_TAG_GAME
	emit_signal("health_changed", health)
	emit_signal("level_changed", level)
	emit_signal("time_changed", minutes, seconds)
	
func init_game_scene_vars():
	seconds = 0
	minutes = 3
	list_avaliable_card_ids = [
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
	list_used_skills = [
		{
			"id": 1,
			"name": "shot default",
			"tag": "shot",
			"type": "skill",
			"description": ""
		}
	]
	health = config.START_HEALTH
	level = 1
	experience = 0
	maxExperience = config.LEVEL_EXP_COST[0]
	emit_signal("health_changed", config.START_HEALTH)
	emit_signal("level_changed", level)
	
func create_win_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_win: PackedScene = load("res://win.tscn")
	var scene_win_inst: Control = scene_win.instance()
	scene_win_inst.connect("button_win_start_clicked", self, "on_button_win_start_clicked")
	$scene_placeholder.add_child(scene_win_inst)
	scene_current = scene_win_inst
	scene_current_tag = config.SCENE_TAG_WIN
	
func create_lose_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_lose: PackedScene = load("res://lose.tscn")
	var scene_lose_inst: Control = scene_lose.instance()
	scene_lose_inst.connect("button_lose_play_again_clicked", self, "on_button_lose_play_again_clicked")
	$scene_placeholder.add_child(scene_lose_inst)
	scene_current = scene_lose_inst
	scene_current_tag = config.SCENE_TAG_LOSE
	
func create_cards_scene():
	if scene_current != null:
		$scene_placeholder.remove_child(scene_current)
	var scene_cards: PackedScene = load("res://cards.tscn")
	var scene_cards_inst: Control = scene_cards.instance()
	
	var cards = generate_card_hand()
	scene_cards_inst.card1 = cards[0]
	scene_cards_inst.card2 = cards[1]
	scene_cards_inst.card3 = cards[2]
	
	scene_cards_inst.connect("card_first_selected", self, "on_card_first_selected")
	scene_cards_inst.connect("card_second_selected", self, "on_card_second_selected")
	scene_cards_inst.connect("card_third_selected", self, "on_card_third_selected")
	$scene_placeholder.add_child(scene_cards_inst)
	scene_current = scene_cards_inst
	scene_current_tag = config.SCENE_TAG_CARDS
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'pause'
	})
	

func on_button_back_clicked():
	$audio_button.play()
	create_start_scene()
	

func on_button_pause_clicked():
	$audio_button.play()
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'pause'
	})
	create_pause_scene()
	
func on_button_resume_clicked():
	$audio_button.play()
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'resume'
	})
	create_game_scene()


func on_button_start_clicked():
	$audio_button.play()
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'start'
	})
	init_game_scene_vars()
	create_game_scene()
	emit_signal("health_changed", config.START_HEALTH)
	
func on_button_win_start_clicked():
	$audio_button.play()
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'start'
	})
	init_game_scene_vars()
	create_game_scene()
	
func on_button_info_clicked():
	$audio_button.play()
	create_info_scene()
	
func on_button_lose_play_again_clicked():
	$audio_button.play()
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'start'
	})
	init_game_scene_vars()
	create_game_scene()
	
func on_card_first_selected(card1):
	$audio_card.play()
	use_card(card1)
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : str(card1["id"])
	})
	create_game_scene()
	
	
func on_card_second_selected(card2):
	$audio_card.play()
	use_card(card2)
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : str(card2["id"])
	})
	create_game_scene()
	
	
func on_card_third_selected(card3):
	$audio_card.play()
	use_card(card3)
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : str(card3["id"])
	})
	create_game_scene()
	

func on_button_attack_clicked():
	api('send_to_hud_app', {
		'type' : 'attack',
		'value': 0
	})
	
	
	
func handle_message_win(message):
	if message["type"] == "boss_win":
		if level == config.MAX_LEVEL:
			create_win_scene()
	
	
func handle_message_exp(message):
	if message["type"] == "exp":
		experience = int(message["value"])
		$audio_enemy_died.play()
		if experience >= config.LEVEL_EXP_COST[level-1]:
			level += 1
			$audio_levelup.play()
			if level == config.MAX_LEVEL:
				#wait till boss_win message
				pass
			else:
				experience = 0
				maxExperience = config.LEVEL_EXP_COST[level-1]
				create_cards_scene()
		else:
			print("we are emitting signal of exp!!!!!!!!!!!!!!!!!!!!!!!1")
			emit_signal("exp_changed", experience, maxExperience)
	
func handle_message_health(message):
	if message["type"] == "health":
		health = int(message["value"])
		if health<=0:
			create_lose_scene()
			pass
		else:
			print("emitting health changed")
			emit_signal("health_changed", health)
#
	
func on_message(message):
	print("scene_current_tag: ", scene_current_tag)
	print("on_message(): ", message)
	if scene_current_tag == config.SCENE_TAG_GAME:
		handle_message_exp(message)
		handle_message_health(message)
		handle_message_win(message)
		

func use_card(card):
	list_avaliable_card_ids.remove(list_avaliable_card_ids.find(card["id"]))
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
					print("card 1 generated")
					break
		else:
			can_take = true
			hand.push_back(card)
			print("card 1 generated")
			
	
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
					print("card 2 generated")
					break
		else:
			can_take = true
			hand.push_back(card)
			print("card 2 generated")
			
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
					print("card 3 generated")
					hand.push_back(card)
					break
		else:
			can_take = true
			hand.push_back(card)
			print("card 3 generated")
		print(hand)
		print(" ")
		print(" ")
		if hand.size()==2:
			card = card_helper.load_card("900")
			hand.push_back(card)
		return hand
		
		


func _on_timer_timeout():
	print('timer')
	if scene_current_tag == config.SCENE_TAG_GAME:
		seconds -= 1
		if seconds==-1:
			minutes -= 1
			seconds = 59
			if minutes==-1:
				$timer.stop()
				create_lose_scene()
				return
		emit_signal("time_changed", minutes, seconds)
