extends PointLight2D
var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta
	
	if position.x > 500:
		speed *= -1
	if position.x < 50:
			speed *= -1
