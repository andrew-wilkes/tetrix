extends Node2D

class_name Grid

export var size = Vector2(10, 20)

var grid: Array

func _ready():
	clear()

func clear():
	grid = []
	grid.resize(size.x * size.y)

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
				if y + yo < 0 or y + yo >= size.y: # Off top/bottom of grid
					return false
				if grid[x + xo + (y + yo) * size.x]:
					return false # Occupied cell
	return true

func add_shape_to_grid(shape: TShape, xo: int, yo: int):
	for y in shape.tsize:
		for x in shape.tsize:
			if shape.tile_map[y][x]:
				grid[x + xo + (y + yo) * size.x] = true

func remove_rows(rows: Array):
	# Get lowest row
	# Move above to here
	var num_rows_in_block = 0
	var row1 = rows.pop_front()
	while row1 != null:
		num_rows_in_block += 1
		var row2 = rows.pop_front()
		if row2 == null or row2 > row1 + 1:
			move_rows(row1 - num_rows_in_block, row1)
			num_rows_in_block = 0
		row1 = row2

func move_rows(from, to):
	for row in range(from, to):
		for x in size.x:
			var v = false if row < 0 else grid[from * size.x + x]
			grid[to * size.x + x] = v
