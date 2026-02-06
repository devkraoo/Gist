# Gist
A tiny, type-safe, declarative 2D animation library for Godot with skeletal animation support.

### GDScript

Define your skeleton:
```gdscript
extends Skeleton
class_name PlayerSkeleton

var Body: Bone
var Weapon: Bone
```

Create reusable animations:
```gdscript
class_name PlayerAnimations

static func JUMP(skeleton: PlayerSkeleton) -> Gist.Animatable:
	return Gist.Of(
		Gist.IT(skeleton.Body.scale.x)
			.by(5.0).over(1.0)
			.then()
			.to(10.0).over(2.0)
			.end()
	)
```

Play animations:
```gdscript
extends Gist
class_name Player

@onready var skeleton: PlayerSkeleton = $PlayerSkeleton

func _ready():
	PlayerAnimations.JUMP(skeleton).play()
```