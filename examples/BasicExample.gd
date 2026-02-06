extends Gist
class_name BasicExample

@onready var TEST: Animatable = Of(
	IT(skeleton.Bob.position.x)
		.by(5.0).over(1.0)
		.then()
		.to(10.0).over(2.0)
		.end()
)

func _ready():
	TEST.play()