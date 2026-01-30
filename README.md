# Gist
A tiny, type-safe, declarative 2D animation library for Godot.

### GDScript

```gdscript
extends Gist
class_name BasicExample

var TEST: Animatable = Of(
	IT(
		func(bob: Sprite2D): return bob.scale.x,
		func(bob: Sprite2D, v: float): bob.scale.x = v
	)
		.by(5.0).over(1.0)
		.then()
		.to(10.0).over(2.0)
		.end()
) \
.reverse(true)

func _ready():
	TEST.play([$Bob])
```