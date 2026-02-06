extends Node
class_name Gist

static var RUNTIME: Runtime = Runtime.new()

func _init():
	add_child(Gist.RUNTIME)



static func Of(..._its) -> Gist.Animatable:
	var its: Array[IT] = []
	for it in _its: its.append(it)
	
	var animatable = Gist.Animatable.new(its)
	return animatable

static func IT(builder: PropertyAccessor.Builder) -> IT.Builder:
	var IT_class := preload("res://src/core/IT.gd")
	
	var accessor = PropertyAccessor.new(builder)
	return IT_class.Builder.new(accessor)



class Animatable:
	var _its: Array[IT]
	var _reverse: bool = false
	var _modifier: Runtime.Process.Modifier
	
	func _init(its: Array[IT]):
		_its = its
	
	func reverse(value: bool) -> Animatable:
		_reverse = value
		return self
	
	func play() -> Runtime.Process.Modifier:
		if _modifier: _modifier.stop()

		_modifier = Gist.RUNTIME.dispatch(_its, _reverse)
		return _modifier