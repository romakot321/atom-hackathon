const CARDS_PATH_TEMPLATE = "res://assets/cards/json/card"

const LIST_ALL_CARDS = [
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
]

static func load_card(id):
	var path = CARDS_PATH_TEMPLATE + id + ".json"
	
	var file = File.new()
	if file.open(path, File.READ) == OK:
		var jsonStr = file.get_as_text()
		file.close()
		
		var jsonData = JSON.parse(jsonStr)
		# q_data = jsonData
		if jsonData != null and jsonData.error==OK:
			return jsonData.result
		else:
			print("Failed to parse JSON data.")
			return null
	else:
		print("Failed to open file for reading.")
		return null
		
static func load_card_icon(cardId):
	var texture = ImageTexture.new()
	var image = Image.new()
	var imagePath = "res://assets/cards/icons/icon" + str(cardId) + ".png"
	image.load(imagePath)
	texture.create_from_image(image)
	return texture
	
static func get_random_array_value(array):
	var random = RandomNumberGenerator.new()
	random.randomize()
	return array[random.randi() % array.size()]


