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
	var config: Config
	
	func _init(its: Array[IT]):
		_its = its
		config = Config.new()

	func reverse(value: bool = true) -> Animatable:
		config.reverse = value
		return self
		
	func loop(value: bool = true) -> Animatable:
		config.loop = value
		return self

	func play() -> Runtime.Process.Modifier:
		return Gist.RUNTIME.dispatch(_its, config.reverse)



	class Config:
		var loop: bool = false
		var reverse: bool = false