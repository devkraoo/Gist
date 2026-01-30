@abstract
extends RefCounted
class_name Sequence

var config: Sequence.Config

func _init(builder: Sequence.Builder):
	config = builder.config

@abstract
func transform(time: float, start: float) -> float

@abstract
func project(start: float) -> float



@abstract
class Config:
	var duration: float

@abstract
class Builder:
	var config: Sequence.Config
	var builder: IT.Builder
	
	func _init(_builder: IT.Builder):
		builder = _builder
	
	@abstract
	func _build() -> Sequence
	
	func over(value: float) -> Sequence.Builder:
		config.duration = value
		return self
	
	func then() -> IT.Builder:
		var sequence = _build()
		builder.config.sequences.append(sequence)
		
		return builder
	
	func end() -> IT:
		var sequence = _build()
		builder.config.sequences.append(sequence)
		
		return IT.new(builder)
