@abstract
extends Node
class_name Skeleton

var bones: Dictionary[String, Bone] = {}

func _ready():
	for node in get_children(): 
		bones[node.name] = Bone.new(node)
	
	_validate()
	_populate()

func _validate():
	var bone_variables = get_property_list() \
		.filter(func(prop): return \
			prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE \
			and prop.type == TYPE_OBJECT
		) \
		.map(func(prop): return prop.name)

	var missing = bones.keys() \
		.filter(func(bone): return not bone in bone_variables)

	var suggestions = missing.map(
		func(bone):
			var min_similarity = 0.6
			var match = bone_variables \
				.filter(func(prop): return bone.similarity(prop) > min_similarity)
			
			var suggestion = ("Did you mean 'var %s: Bone'?" % match[0]) if match else ("var %s: Bone" % bone)
			return "  Node '%s' → %s" % [bone, suggestion]
	)
	
	assert(
		missing.is_empty(), 
		"""
		Skeleton '%s' has nodes without bone variables:
		%s

		Add these to your class or rename the nodes.
		""" % [name, "\n".join(suggestions)]
	)

func _populate():
	for bone in bones: set(bone, bones[bone])

func _get(property: StringName) -> Bone:
	return bones[property]



class Bone:
	var node: Node

	func _init(_node: Node):
		node = _node
	
	func _get(property: StringName) -> PropertyAccessor.Builder:
		return PropertyAccessor.Builder.new(node, property)
