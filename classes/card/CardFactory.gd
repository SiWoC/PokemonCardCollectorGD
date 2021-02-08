class_name CardFactory

extends Node2D

var numberOfGenerations = 3
var cards = {}
var cardScene

export var CARD_SIZE = Vector2(600,824)
const BACK_FILE_ROUNDED = "res://assets/card/back_734x1024_rounded.png"
const BACK_FILE_SQUARE = "res://assets/card/back_734x1024_square.png"

var back_texture_rounded
var back_texture_square

func _ready():
	for i in range(1, numberOfGenerations + 1):
		addCardsFromFile("gen" + String(i) + "-rare")
		addCardsFromFile("gen" + String(i) + "-common")

func addCardsFromFile(cardResourceName):
	var file = File.new()
	file.open("res://resources/" + cardResourceName + ".json", file.READ)
	var card = JSON.parse(file.get_as_text()).result
	print(card[0].id)
	cards[cardResourceName] = card
	file.close()
		

func createCardScene(card):
	var cardScene = load("res://scenes/card/Card.tscn").instance()
	cardScene.id = card.id
	cardScene.hiResUrl = card.imageUrlHiRes
	if card.setCode.begins_with("base"):
		cardScene.corners = Corners.SQUARE
	else:
		cardScene.corners = Corners.ROUNDED
	return cardScene

func get_back_texture(corners): 
	if corners == Corners.ROUNDED:
		if back_texture_rounded == null:
			#var image = Image.new()
			#image.load(BACK_FILE_ROUNDED)
			var image = load(BACK_FILE_ROUNDED)
			back_texture_rounded = ImageTexture.new()
			back_texture_rounded.create_from_image(image)
			back_texture_rounded.set_size_override(CARD_SIZE)
		return back_texture_rounded
	elif corners == Corners.SQUARE:
		if back_texture_square == null:
			# var image = Image.new()
			#image.load(BACK_FILE_SQUARE)
			var image = load(BACK_FILE_SQUARE)
			back_texture_square = ImageTexture.new()
			back_texture_square.create_from_image(image)
			back_texture_square.set_size_override(CARD_SIZE)
		return back_texture_square

func get_card_size_texture(base):
	var image
	var it = ImageTexture.new()
	if base is Texture:
		image = base.get_data()
	else:
		image = Image.new()
		image.load(base)
	it.create_from_image(image)
	it.set_size_override(CARD_SIZE)
	return it

func _on_Button_pressed():
	randomize()
	var cardResourceName = "gen" + String($Generation.value) + "-" + $Rarity.get_item_text($Rarity.selected)
	var index = randi() % cards[cardResourceName].size()
	print(index)
	$card_id.text = cards[cardResourceName][index].id
	if cardScene != null:
		$Container.remove_child(cardScene)
	cardScene = createCardScene(cards[cardResourceName][index])
	$Container.add_child(cardScene)
	# $HTTPRequest.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")
	# $HTTPRequest.request("https://api.pokemontcg.io/v1/sets")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var setList = JSON.parse(body.get_string_from_utf8()).result
	print(setList.sets[0].code)


func _on_GetImageRequest_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error == OK:
		return image
	else:
		print("An error occurred while trying to display the image.")
		
