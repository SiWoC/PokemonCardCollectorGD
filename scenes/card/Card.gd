extends StaticBody2D

var cardFactory = CardFactory.new()

signal http_image_ready

export var corners = Corners.ROUNDED
export var id = "ex6-1"
export var number = 1
export var rarity = "Rare Holo"
export var setCode = "ex6"
export var hiResUrl = "https://images.pokemontcg.io/g1/8_hires.png"
#var hiResUrl = "https://images.pokemontcg.io/ecard3/151_hires.png"
#var hiResUrl = "res://assets/card/ex6/3.png"
var i = 0

var flipping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$Back.texture = cardFactory.get_back_texture(corners)
	$Back.visible = true
	if hiResUrl.begins_with("http"):
		print("getting " + hiResUrl)
		$GetImageRequest.request(hiResUrl)
		print("yield start")
		yield(self, "http_image_ready")
		print("yield finished")
	else:
		var it = get_card_size_texture(hiResUrl)
		$Front.texture = it
	$Front.visible = false
	flipping = false
	visible = true

func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if not flipping: # don't restart animation when it's not finished
			if $Back.visible:
				$FlipAnimation.play("flip")
			else:
				$FlipAnimation.play_backwards("flip")

func _on_FlipAnimation_animation_started(anim_name):
	flipping = true

func _on_FlipAnimation_animation_finished(anim_name):
	flipping = false

func get_card_size_texture(base):
	var front_image
	var it = ImageTexture.new()
	if base is Texture:
		front_image = base.get_data()
	else:
		front_image = Image.new()
		front_image.load(base)
	it.create_from_image(front_image)
	it.set_size_override(cardFactory.CARD_SIZE)
	return it

func _on_GetImageRequest_request_completed(result, response_code, headers, body):
	var front_image = Image.new()
	var image_error = front_image.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")

	var it = ImageTexture.new()
	it.create_from_image(front_image)
	it.set_size_override(cardFactory.CARD_SIZE)
	$Front.texture = it
	print("http_completed ")
	emit_signal("http_image_ready")
