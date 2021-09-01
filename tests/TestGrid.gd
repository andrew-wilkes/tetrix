extends Grid

func _ready():
	run_tests()

func run_tests():
	size = Vector2(10, 20)
	clear()
	test_clear()
	test_get_grid_index()
	test_cell_full()
	test_get_full_rows()
	test_ok_to_move()
	test_add_shape_to_grid()
	test_remove_rows()
	print("Done")

func test_clear():
	assert(grid.size() == size.x * size. y)

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

func test_remove_rows():
	clear()
	# Add row at top of grid
	for idx in size.x:
		grid[idx] = true
	remove_rows([0])
	var n = 0
	for idx in size.x:
		n += int(grid[idx] == true)
	assert(n == 0)
	# Add 3 rows at top of grid
	for idx in size.x * 3:
		grid[idx] = true
	remove_rows([1, 2])
	# Now only row 3 should contain true values
	n = 0
	for idx in size.x:
		n += int(grid[idx] == true)
	assert(n == 0)
	for idx in size.x:
		n += int(grid[idx + size.x] == true)
	assert(n == 0)
	for idx in size.x:
		n += int(grid[idx + size.x * 2] == false)
	assert(n == 0)
