extends Node2D


var frameNumber = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		frameNumber = frameNumber + 1
		if frameNumber > 7:
			frameNumber = 0
		$AnimatedSprite.frame = frameNumber
