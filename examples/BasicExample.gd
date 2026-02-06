extends Gist
class_name BasicExample

@export var Bob: Skeleton

func _ready():
	BasicExample.TEST(Bob).play()

# In another file
static func TEST(skeleton: Skeleton) -> Gist.Animatable:
	return Gist.Of(
		Gist.IT(skeleton.Bob.scale.x)
			.by(5.0).over(1.0)
			.then()
			.to(10.0).over(2.0)
			.end()
	)