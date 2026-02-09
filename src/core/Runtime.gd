extends Node
class_name Runtime

var disptaches: Array[Process] = []

func _process(delta: float):
	if disptaches.is_empty(): return
	
	ArrayUtils.compact(disptaches,
		func(dispatched: Process):
			return dispatched.update(delta)
	)

func dispatch(its: Array[IT], reverse: bool) -> Process.Modifier:
	var dispatched = Process.new(its, reverse)
	disptaches.append(dispatched)

	return dispatched.modifier



class Process:
	var _tracks: Array[Runtime.Track] = []
	var config: Config
	var modifier: Modifier
	
	func _init(its: Array[IT], reverse: bool):
		for i in its.size():
			_tracks.append(Runtime.Track.new(its[i], reverse))
		
		config = Config.new()
		modifier = Modifier.new(config)
	
	func update(delta: float) -> bool:
		if config.pause: return false
		
		ArrayUtils.compact(_tracks,
			func(track: Runtime.Track):
				if config.stop:
					track.reset()
					return true
				
				return track.step(delta * config.speed)
		)
		
		if _tracks.is_empty(): return true
		return false
	
	
	
	class Config:
		var stop: bool = false
		var pause: bool = false
		var speed: float = 1.0:
			set(value):
				if value <= 0.0: return
				speed = value
	
	class Modifier:
		var _config: Process.Config
		
		func _init(config: Process.Config):
			_config = config
		
		func speed(value: float) -> Modifier:
			_config.speed = value
			return self
		
		func pause(value: bool) -> Modifier:
			_config.pause = value
			return self
		
		func stop() -> Modifier:
			_config.stop = true
			return self

class Track:
	var it: IT
	var state: State
	
	func _init(_it: IT, reverse: bool):
		it = _it
		state = State.new(reverse, it.config.sequences)
	
	func reset():
		var config = it.config

		var accessor = config.accessor
		var snapshots = config.snapshots

		accessor.setter(snapshots[0].start)
	
	func step(delta: float) -> bool:
		var sequences = it.config.sequences
		var snapshots = it.config.snapshots

		var current_sequence = state.current_sequence
		var sequence: Sequence = sequences[current_sequence]
		var snapshot: IT.Snapshot = snapshots[current_sequence]
		
		state.elapsed += delta
		state.start = snapshot.start
		
		var duration = sequence.config.duration
		var time = clampf(state.elapsed / duration, 0.0, 1.0)

		if state.direction == -1:
			time = (1.0 - time)
		
		var transform = sequence.transform(time, state.start)
		it.config.accessor.setter(transform)
		
		var proceed = state.elapsed >= duration
		if proceed: state.refresh()
		
		current_sequence = state.current_sequence
		if current_sequence < 0 or current_sequence >= sequences.size(): return true
		
		return false
	
	
	
	class State:
		var elapsed: float = 0.0
		var start: float
		var direction: int = 1
		var current_sequence: int = 0
		
		func _init(reverse: bool, sequences: Array[Sequence]):
			if not reverse: return
			
			direction = -1
			current_sequence = (sequences.size() - 1)
		
		func refresh():
			elapsed = 0.0
			current_sequence += direction
