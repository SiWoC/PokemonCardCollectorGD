extends Node2D

var cardFactory = CardFactory.new()

func _ready():
	print("getting ready")
	$TextureRect.texture = cardFactory.get_back_texture(Corners.ROUNDED)
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
#	var http_error = $HTTPRequest.request("https://images.pokemontcg.io/ecard3/151_hires.png")
#	if http_error != OK:
#		print("An error occurred in the HTTP request.")
#	print("ready")



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("completed")
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)

	# Assign to the child TextureRect node
	$TextureRect.texture = texture
