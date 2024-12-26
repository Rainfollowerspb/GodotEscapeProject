extends Node2D


var collisionMessageScene = preload("res://scenes/collisionMessage.tscn")
var collisionMsg


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("mouseClick"):
		$MainCharacter.setMoveState(get_local_mouse_position() - $MainCharacter.position, true)


func _on_main_character_collision_happened(msgPos: Vector2) -> void:
	collisionMsg = collisionMessageScene.instantiate()
	$MainCharacter.character_starts_moving.connect(collisionMsg._on_character_starts_movement)
	add_child(collisionMsg)
	print(get_child_count())
	# DEBUG
	collisionMsg.position = msgPos
	for i in get_child_count():
		print(get_child(i).name)
