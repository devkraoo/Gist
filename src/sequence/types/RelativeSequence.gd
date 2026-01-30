extends Sequence
class_name RelativeSequence

func transform(time: float, start: float) -> float:
	return start + (config.target_amount * time)

func project(start: float) -> float:
	return start + config.target_amount



class Config extends Sequence.Config:
	var target_amount: float

class Builder extends Sequence.Builder:
	func _init(_builder: IT.Builder, target_amount: float):
		config = RelativeSequence.Config.new()
		config.target_amount = target_amount
		
		super(_builder)
	
	func _build() -> RelativeSequence:
		return RelativeSequence.new(self)
	
	func over(value: float) -> RelativeSequence.Builder:
		return super(value)
