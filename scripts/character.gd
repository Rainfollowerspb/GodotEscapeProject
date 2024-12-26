class_name CharacterPhys
extends CharacterBody2D

@export var maxspeed = 10.0

var currentMovementVector: Vector2
var characterCollider: KinematicCollision2D

# character state machine
enum characterStates {IDLE, MOVE}
var state: characterStates = characterStates.IDLE


signal character_starts_moving
signal collision_happened(Vector2)


func _ready() -> void:
	pass
	#width = $CharacterSprite.get_rect().size.x


func _physics_process(delta: float) -> void:
	if state == characterStates.MOVE:
		position += move(currentMovementVector)
	pass


func setMoveState(movementVector: Vector2, fromInput = false):
	var localstate = state
	localstate = characterStates.IDLE
	if fromInput:
		emit_signal("character_starts_moving")
		#movementVector = check_collision(movementVector)
	if movementVector:
		currentMovementVector = movementVector
		localstate = characterStates.MOVE
	state = localstate


#called every frame to calculate next iteration of movement
func move(movementVector: Vector2):
	var increment = movementVector.normalized() * maxspeed
	if increment.abs() > movementVector.abs():
		increment = movementVector
	movementVector -= increment
	setMoveState(movementVector) # switches state when remaiing destance is 0
	increment = check_collision(increment)
	return increment


# checks for collision and reacts to it by 
# a) stopping the character
# b) calling message
func check_collision(increment):
	characterCollider = move_and_collide(increment, true)
	if characterCollider:
		increment = characterCollider.get_travel()
		currentMovementVector = increment
		emit_signal("collision_happened", position)
	return increment
