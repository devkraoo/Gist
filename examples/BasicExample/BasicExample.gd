extends Gist
class_name BasicExample

@onready var bob: Bobert = $Bob

func _ready():
	BasicExample.TEST(bob).play() \
		.speed(1.0)

# In another file
static func TEST(skeleton: Bobert) -> Gist.Animatable: return \
	Gist.Of(
		Gist.IT(skeleton.Body.scale.x)
			.by(20.0).over(0.5)
			.then()
			.to(10.0).over(2.0)
			.end()
	) \
		.reverse(false)