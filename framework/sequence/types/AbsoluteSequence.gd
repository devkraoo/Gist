extends Sequence
class_name AbsoluteSequence

func transform(time: float, start: float) -> float:
	if not config.from: config.from = start
	return lerp(config.from, config.to, time)

func project(_start: float) -> float:
	return config.to



class Config extends Sequence.Config:
	var to: float
	var from: float

class Builder extends Sequence.Builder:
	func _init(_builder: IT.Builder, to: float):
		config = AbsoluteSequence.Config.new()
		config.to = to
		
		super(_builder)
	
	func _build() -> AbsoluteSequence:
		return AbsoluteSequence.new(config)
	
	func from(value: float) -> AbsoluteSequence.Builder:
		config.from = value
		return self
	
	func over(value: float) -> AbsoluteSequence.Builder:
		return super(value)
