extends Node2D

var size = Vector2(10, 20)

var grid: Array
var tiles: Array
var step_size

func _ready():
	clear()

func clear():
	grid = []
	tiles = []
	grid.resize(size.x * size.y)
	tiles.resize(size.x * size.y)

func get_full_rows():
	var rows = []
	var idx = 0
	for row in size.y:
		var full = true
		for x in size.x:
			if grid[idx] != true:
				idx += size.x - x
				full = false
				break
			else:
				idx += 1
		if full:
			rows.append(row)
	return rows

func ok_to_move(shape: TShape, xo: int, yo: int):
	for y in shape.tsize:
		for x in shape.tsize:
			if shape.tile_map[y][x]: # Tile exists
				if x + xo < 0 or x + xo >= size.x: # Off side of grid
					return false
				if y + yo >= size.y: # Off bottom of grid
					return false
				var idx = x + xo + (y + yo) * size.x
				if idx > 0 and grid[idx]:
					return false # Occupied cell
	return true

func add_shape_to_grid(shape: TShape):
	step_size = shape.step_size # Useful place to set this value
	var tile_idx = 0
	for y in shape.tsize:
		for x in shape.tsize:
			if shape.tile_map[y][x]:
				var idx = x + shape.xpos + (y + shape.ypos) * size.x
				grid[idx] = true
				tiles[idx] = shape.get_child(tile_idx)
				tile_idx += 1

func remove_rows(rows: Array):
	# Get lowest row
	# Move rows above to here
	var num_rows_in_block = 0
	var row1 = rows.pop_front()
	while row1 != null:
		num_rows_in_block += 1
		var row2 = rows.pop_front()
		if row2 == null or row2 > row1 + 1:
			move_rows(row1, num_rows_in_block)
			num_rows_in_block = 0
		row1 = row2

var not_testing = true

func move_rows(to, n):
	var idx
	# Scan the rows to be moved to from `to` to 0
	for row in range(to, -1, -1):
		for x in size.x:
			var v = false
			var tile: Sprite = null
			if row - n >= 0:
				idx = (row - n) * size.x + x
				v = grid[idx]
				tile = tiles[idx]
			idx = row * size.x + x
			grid[idx] = v
			if to - row < n and not_testing:
				tiles[idx].queue_free() # Delete tile to be removed
			tiles[idx] = tile
			if tile != null:
				tile.position.y += step_size * n
