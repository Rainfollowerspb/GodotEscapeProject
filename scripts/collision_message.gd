extends Node2D


var movementDistance = 32.0
var entryTime = 0.3
var waitTime = 0.8
var leaveTime = 0.1
var wait = false
var remaining_distance


enum states {ENTRY, WAIT, LEAVE}
var state = states.ENTRY


func _ready() -> void:
	$MsgFrame/MsgPlaque.position.y = movementDistance
	$Timer.wait_time = entryTime
	$Timer.start()
	remaining_distance = movementDistance
	#get_parent().character_starts_moving.connect(_on_character_starts_movement)
	# DEBUG
	#$MsgFrame.set_clip_children_mode(0)


func _process(delta: float) -> void:
	$MsgFrame/MsgPlaque.position.y -= get_movement_speed() * delta
	pass


func get_movement_speed():
	if not wait:
		return movementDistance / $Timer.wait_time
	else:
		return 0


func _on_timer_timeout() -> void:
	$Timer.stop()
	if state == states.ENTRY:
		state = states.WAIT
		wait = true
		$Timer.wait_time = waitTime
		$Timer.start()
	elif state == states.WAIT:
		state = states.LEAVE
		wait = false
		$Timer.wait_time = leaveTime
		$Timer.start()
	else:
		wait = true
		set_process(false)


func _on_character_starts_movement() -> void:
	queue_free()
