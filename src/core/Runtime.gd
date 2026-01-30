extends Node
class_name Runtime

const UTILS = preload("res://src/core/Utils.gd")

var disptaches: Array[Dispatchable] = []

func _process(delta: float):
	if disptaches.is_empty(): return
	
	UTILS.compact(disptaches,
		func(dispatched: Dispatchable):
			return dispatched.process.update(delta)
	)

func dispatch(its: Array[IT], targets: Array[Node2D], reverse: bool) -> Process.Modifier:
	for dispatched in disptaches:
		var has_target = targets.any(
			func(target: Node2D):
				return target in dispatched.targets
		)

		if has_target: dispatched.process.modifier.stop()

	var dispatched = Dispatchable.new(targets, its, reverse)
	disptaches.append(dispatched)

	return dispatched.process.modifier



class Dispatchable:
	var process: Process
	var targets: Array[Node2D]

	func _init(_targets: Array[Node2D], its: Array[IT], reverse: bool):
		targets = _targets
		
		if not targets.size() == its.size(): push_error("Passed in nodes must match track amount.")

		var tracks: Array[Runtime.Track] = []
		for i in its.size():
			tracks.append(Runtime.Track.new(its[i], targets[i], reverse))
		
		process = Runtime.Process.new(tracks)



class Process:
	var _tracks: Array[Runtime.Track]
	var config: Config
	var modifier: Modifier
	
	func _init(tracks: Array[Runtime.Track]):
		_tracks = tracks
		config = Config.new()
		modifier = Modifier.new(config)
	
	func update(delta: float) -> bool:
		if config.pause: return false
		
		UTILS.compact(_tracks,
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
	var target: Node2D
	var config: Config
	var snapshots: Array[Snapshot]
	
	func _init(_it: IT, _target: Node2D, reverse: bool):
		it = _it
		target = _target
		
		config = Config.new(reverse, it.config.sequences)
		snapshots = Snapshot.photo(self)
	
	func reset():
		it.config.setter.call(target, snapshots[0].start)
	
	func step(delta: float) -> bool:
		var sequences = it.config.sequences
		
		var current_sequence = config.current_sequence
		var sequence: Sequence = sequences[current_sequence]
		var snapshot: Snapshot = snapshots[current_sequence]
		
		config.elapsed += delta
		config.start = snapshot.start
		
		var duration = sequence.config.duration
		var time = clampf(config.elapsed / duration, 0.0, 1.0)

		if config.direction == -1:
			time = (1.0 - time)
		
		var transform = sequence.transform(time, config.start)
		it.config.setter.call(target, transform)
		
		var proceed = config.elapsed >= duration
		if proceed: config.refresh()
		
		current_sequence = config.current_sequence
		if current_sequence < 0 or current_sequence >= sequences.size(): return true
		
		return false
	
	
	
	class Config:
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
	
	class Snapshot:
		var start: float
		var end: float
		
		func _init(_start: float, _end: float):
			start = _start
			end = _end
		
		static func photo(track: Track) -> Array[Snapshot]:
			var config = track.it.config
			var snapshots: Array[Snapshot] = []
			
			var current = config.getter.call(track.target)
			for sequence in config.sequences:
				var last = sequence.project(current)
				snapshots.append(
					Snapshot.new(current, last)
				)
				
				current = last
			
			return snapshots
