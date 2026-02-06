class_name PropertyAccessor

var target: Object
var property: String

func _init(builder: Builder):
	target = builder.target
	property = builder.property

func setter(value):
	target.set(property, value)

func getter():
	return target.get(property)

class Builder:
	var target: Object
	var property: String

	func _init(_target: Object, _property: String):
		target = _target
		property = _property

	func _get(_property: StringName):
		property += str(_property)
		return self