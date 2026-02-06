class_name PropertyAccessor

var target: Object
var property: String

func _init(builder: Builder):
	target = builder.target
	property = ":".join(builder.properties)

func setter(value):
	target.set_indexed(property, value)

func getter():
	return target.get_indexed(property)

class Builder:
	var target: Object
	var properties: Array[String] = []

	func _init(_target: Object, _property: StringName):
		target = _target
		properties.append(str(_property))

	func _get(_property: StringName):
		properties.append(str(_property))
		return self