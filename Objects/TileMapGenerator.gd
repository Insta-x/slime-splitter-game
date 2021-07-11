extends TileMap


export(int) var generation_height := 2
export(int) var generation_width := 2
export(int) var chunk_size := 16

var global_world_seed : int


func update_map(position_origin : Vector2) -> void:
	var position_chunk := world_to_map(position_origin) / chunk_size
	position_chunk = Vector2(int(position_chunk.x), int(position_chunk.y))
	generate_map(position_chunk)


func generate_map(chunk_origin : Vector2) -> void:
	for y in range(chunk_origin.y - generation_height, chunk_origin.y + generation_height + 1):
		for x in range(chunk_origin.x - generation_width, chunk_origin.x + generation_width + 1):
			generate_chunk(Vector2(x, y))
	var tile_origin := chunk_origin * chunk_size
	var chunk_radius := Vector2(generation_width, generation_height) * chunk_size
	update_bitmask_region(tile_origin - chunk_radius, tile_origin + chunk_radius)


func generate_chunk(chunk_coord : Vector2) -> void:
	# Local RNG with local seed for the chunk
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(chunk_coord) ^ global_world_seed
	
	# Generate chunk with local RNG
	var grass_count := rng.randi() % 32 + 1
	for i in range(grass_count):
		var pos := Vector2(rng.randi() % chunk_size, rng.randi() % chunk_size)
		set_cellv(chunk_coord * chunk_size + pos, 0)
	
#	for y in range(chunk_coord.y * chunk_size, (chunk_coord.y + 1) * chunk_size):
#		for x in range(chunk_coord.x * chunk_size, (chunk_coord.x + 1) * chunk_size):
#			set_cell(x, y, -1 if rng.randf() < 0.7 else 0)
