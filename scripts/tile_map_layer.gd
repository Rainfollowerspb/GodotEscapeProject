extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_step_height(coords: Vector2i):
	coords = to_local(coords)
	coords = local_to_map(coords)
	var cellData = get_cell_tile_data(coords)
	var step_height = 0
	if cellData:
		step_height = cellData.get_custom_data("step_height")
	return step_height
	#return cellData.get_custom_data("step_height")
	#if cellData:
		#return cellData.get_custom_data("step_height")
	#else:
		#return 0
