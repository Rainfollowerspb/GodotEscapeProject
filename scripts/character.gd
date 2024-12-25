class_name CharacterPhys
extends CharacterBody2D

@export var maxspeed = 10.0

var currentMovementVector: Vector2
var characterCollider: KinematicCollision2D

# character state machine
enum characterStates {IDLE, MOVE}
var state: characterStates = characterStates.IDLE

var collisionMessageScene = preload("res://scenes/collisionMessage.tscn")
var collisionMsg

signal character_starts_moving

var width


func _ready() -> void:
	width = $CharacterSprite.get_rect().size.x


func _physics_process(delta: float) -> void:
	if state == characterStates.MOVE:
		position += move(currentMovementVector)
	pass


func setMoveState(movementVector: Vector2, fromInput = false):
	var localstate = state
	localstate = characterStates.IDLE
	if movementVector:
		currentMovementVector = movementVector
		localstate = characterStates.MOVE
	if fromInput:
		emit_signal("character_starts_moving")
	state = localstate


#called every frame to calculate next iteration of movement
func move(movementVector: Vector2):
	var increment = movementVector.normalized() * maxspeed
	if increment.abs() > movementVector.abs():
		increment = movementVector
	movementVector -= increment
	increment = check_collision(increment)
	setMoveState(movementVector) # switches state when remaiing destance is 0
	return increment


# checks for collision and reacts to it by 
# a) stopping the character
# b) calling message
func check_collision(increment):
	characterCollider = move_and_collide(increment, true)
	if characterCollider:
		var collisionIncrement = characterCollider.get_travel()
		if increment.abs() > collisionIncrement.abs():
			increment = collisionIncrement
			call_message()
	return increment


func call_message():
	collisionMsg = collisionMessageScene.instantiate()
	add_child(collisionMsg)
	#connect("character_starts_moving", collisionMsg)
	collisionMsg.position = Vector2(width/2, 0.0)
