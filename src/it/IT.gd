extends RefCounted
class_name IT

var config: IT.Config

func _init(builder: IT.Builder):
	config = builder.config

class Config:
	var accessor: PropertyAccessor
	var sequences: Array[Sequence] = []

class Builder:
	var config: IT.Config
	
	func _init(builder: PropertyAccessor.Builder):
		config = IT.Config.new()
		config.accessor = PropertyAccessor.new(builder)
		config.sequences = []
	
	func by(value: float) -> RelativeSequence.Builder:
		return RelativeSequence.Builder.new(self, value)
	
	func to(value: float) -> AbsoluteSequence.Builder:
		return AbsoluteSequence.Builder.new(self, value)
