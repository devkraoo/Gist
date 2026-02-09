extends RefCounted
class_name IT

var config: Config

func _init(_config: Config):
	config = _config
	config.photo()

class Config:
	var accessor: PropertyAccessor
	var sequences: Array[Sequence] = []
	var snapshots: Array[Snapshot] = []

	func _init(_accessor: PropertyAccessor):
		accessor = _accessor
	
	func photo():
		snapshots = []

		var current = accessor.getter()
		for sequence in sequences:
			var last = sequence.project(current)
			snapshots.append(
				Snapshot.new(current, last)
			)
				
			current = last
			
		return snapshots

class Builder:
	var config: IT.Config
	
	func _init(accessor: PropertyAccessor):
		config = IT.Config.new(accessor)
	
	func by(value: float) -> RelativeSequence.Builder:
		return RelativeSequence.Builder.new(self, value)
	
	func to(value: float) -> AbsoluteSequence.Builder:
		return AbsoluteSequence.Builder.new(self, value)

class Snapshot:
	var start: float
	var end: float
	
	func _init(_start: float, _end: float):
		start = _start
		end = _end