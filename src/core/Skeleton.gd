extends Node
class_name Skeleton

var bones = {} #Dictionary<String, Node>

func _init():
	for node in get_children(): bones[node.name] = Bone.new(node)

func _get(property) -> Bone:
	return bones[property]

class Bone:
	var node: Node

	func _init(_node: Node):
		node = _node
	
	func _get(property) -> PropertyAccessor.Builder:
		return PropertyAccessor.Builder.new(node, property)