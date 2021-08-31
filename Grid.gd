extends Node2D

export var size = Vector2(10, 20)

var grid: Array

func _ready():
	clear()
	run_tests()

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


### Tests ###

func run_tests():
	assert(grid.size() == size.x * size. y)
	test_get_grid_index()
	test_cell_full()
	test_get_full_rows()
	test_ok_to_move()
	test_add_shape_to_grid()
	print("Done")

func test_cell_full():
	grid[0] = false
	assert(not cell_full(0, 0))
	grid[0] = true
	assert(cell_full(0, 0))
	grid[0] = null
	assert(not cell_full(0, 0))
	
func test_get_grid_index():
	for n in grid.size():
		assert(n == get_grid_index(n % 10, n / 10))

func test_get_full_rows():
	clear()
	# No rows
	var rows = get_full_rows()
	assert(rows.size() == 0)
	# 4 rows
	for n in 40:
		grid[n] = true
	rows = get_full_rows()
	assert(rows == [0, 1, 2, 3])
	# spaced rows
	clear()
	for n in 20:
		grid[n] = true
		grid[n + 50] = true
	rows = get_full_rows()
	assert(rows == [0, 1, 5, 6])

func test_ok_to_move():
	clear()
	var tshape = TShape.new()
	tshape.tsize = 2
	tshape.tile_map = [[true, true], [true, true]]
	assert(ok_to_move(tshape, 0, 0))
	assert(ok_to_move(tshape, 8, 18))
	assert(not ok_to_move(tshape, -1, 0))
	assert(not ok_to_move(tshape, 0, -1))
	assert(not ok_to_move(tshape, 9, 0))
	assert(not ok_to_move(tshape, 0, 19))
	assert(not ok_to_move(tshape, -1, 18))
	assert(not ok_to_move(tshape, -6, -6))
	grid[11] = true
	assert(not ok_to_move(tshape, 0, 0))
	assert(ok_to_move(tshape, 1, 2))

func test_add_shape_to_grid():
	var tshape = TShape.new()
	tshape.tsize = 2
	tshape.tile_map = [[true, true], [true, true]]
	add_shape_to_grid(tshape, 1, 1)
	var sum = 0
	for idx in grid.size():
		if grid[idx]:
			sum += idx
	assert(sum == 11 + 12 + 21 + 22)
