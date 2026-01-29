extends Node
class_name Gist

static var RUNTIME: Runtime = Runtime.new()

func _init():
	add_child(Gist.RUNTIME)



var IT_class := preload("res://framework/it/IT.gd")

func Of(..._its) -> Gist.Animatable:
	var its: Array[IT] = []
	for it in _its: its.append(it)
	
	var animatable = Gist.Animatable.new(its)
	return animatable

func IT(getter: Callable, setter: Callable) -> IT.Builder:
	return IT_class.Builder.new(getter, setter)



class Animatable:
	var _its: Array[IT]
	var _reverse: bool = false
	
	func _init(its: Array[IT]):
		_its = its
	
	func reverse(value: bool) -> Animatable:
		_reverse = value
		return self
	
	func play(targets: Array[Node2D]) -> Runtime.Process.Modifier:
		return Gist.RUNTIME.handle(_its, targets, _reverse)
