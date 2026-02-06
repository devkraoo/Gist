class_name PropertyAccessor

var node: Node
var property: String

func _init(_node: Node, _property: String):
	node = _node
	property = _property

func _get(_property: StringName):
	property += str(_property)
	return self

func setter(value):
	node.set(property, value)
		
func getter():
	return node.get(property)