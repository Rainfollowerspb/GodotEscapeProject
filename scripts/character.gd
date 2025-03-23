class_name CharacterPhys
extends CharacterBody2D

@export var maxspeed = 10.0

var destination: Vector2
var characterCollider: KinematicCollision2D

# character state machine
enum characterStates {IDLE, MOVE}
var state: characterStates = characterStates.IDLE


signal character_starts_moving
signal collision_happened(Vector2)

var tile_map_layer: TileMapLayer

var step_height = 1

func _ready() -> void:
	tile_map_layer = get_parent().get_node("TileMapLayer")
	pass


func _physics_process(delta: float) -> void:
	if state == characterStates.MOVE:
		position += move(destination)
	pass


func setDestination(movementVector: Vector2) -> void:
	destination = movementVector
	setMoveState(destination)
	emit_signal("character_starts_moving")


func setMoveState(movementVector: Vector2) -> void:
	var localstate = state
	localstate = characterStates.IDLE
	if movementVector:
		localstate = characterStates.MOVE
	state = localstate


#called every frame to calculate next iteration of movement
func move(movementVector: Vector2):
	var increment = movementVector.normalized() * maxspeed
	if increment.abs() > movementVector.abs():
		increment = movementVector
	setDestination(movementVector - increment)
	increment = check_collision(increment)
	return increment


# checks for collision and reacts to it by 
# a) stopping the character
# b) calling message
func check_collision(increment):
	characterCollider = move_and_collide(increment, true)
	if characterCollider:
		var returnedCollider = characterCollider.get_collider()
		var cellData = tile_map_layer.get_step_height(characterCollider.get_position() - characterCollider.get_normal())
		if cellData > step_height:
			increment = characterCollider.get_travel()
			setDestination(Vector2.ZERO)
			emit_signal("collision_happened", position)
	return increment
