extends Node2D

var size = Vector2(10, 20)

var grid: Array
var nodes: Array

func _ready():
	clear()

func clear():
	grid = []
	nodes = nodes
	grid.resize(size.x * size.y)
	nodes.resize(size.x * size.y)

func cell_full(x: int, y: int):
	return grid[get_grid_index(x, y)] == true

func get_grid_index(x: int, y: int):
	return x + size.x * y

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

func add_shape_to_grid(shape: TShape, xo: int, yo: int):
	var tile_idx = 0
	for y in shape.tsize:
		for x in shape.tsize:
			if shape.tile_map[y][x]:
				var idx = x + xo + (y + yo) * size.x
				grid[idx] = true
				nodes[idx] = shape.get_child(tile_idx)
				tile_idx += 1

func remove_rows(rows: Array):
	# Get lowest row
	# Move above to here
	var num_rows_in_block = 0
	var row1 = rows.pop_front()
	while row1 != null:
		num_rows_in_block += 1
		var row2 = rows.pop_front()
		if row2 == null or row2 > row1 + 1:
			move_rows(row1, num_rows_in_block)
			num_rows_in_block = 0
		row1 = row2

func move_rows(to, n):
	var idx
	# Scan the rows to be moved from `to` to 0
	for row in range(to, -1, -1):
		for x in size.x:
			var v = false
			var node = null
			if row - n >= 0:
				idx = (row - n) * size.x + x
				v = grid[idx]
				node = nodes[idx]
			idx = row * size.x + x
			grid[idx] = v
			nodes[idx] = node
