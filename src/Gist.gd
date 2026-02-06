extends Node
class_name Gist

@export var skeleton: Skeleton



static var RUNTIME: Runtime = Runtime.new()

func _init():
	add_child(Gist.RUNTIME)



var IT_class := preload("res://src/it/IT.gd")

func Of(..._its) -> Gist.Animatable:
	var its: Array[IT] = []
	for it in _its: its.append(it)
	
	var animatable = Gist.Animatable.new(its)
	return animatable

func IT(builder: PropertyAccessor.Builder) -> IT.Builder:
	var accessor = PropertyAccessor.new(builder)
	return IT_class.Builder.new(accessor)



class Animatable:
	var _its: Array[IT]
	var _reverse: bool = false
	
	func _init(its: Array[IT]):
		_its = its
	
	func reverse(value: bool) -> Animatable:
		_reverse = value
		return self
	
	func play() -> Runtime.Process.Modifier:
		return Gist.RUNTIME.dispatch(_its, _reverse)