extends Node2D

class_name TShape

export(String, MULTILINE) var cells
export var color: Color
export var weight = 1.0
export(Texture) var tile_texture

var tile_map: Array
var tsize: int
var step_size
var edge_pos
var coordinate_matrices = [[-1,1], [-1,0,1],[-2,-1,1,2]]
var tile
var xpos = 0
var ypos = 0

func _ready():
	# Parse cells data
	var lines = cells.split("\n")
	for line in lines:
		var row = []
		for ch in line:
			row.append(ch == "x")
		tile_map.append(row)
	tsize = int(max(tile_map.size(), tile_map[0].size()))
	# Evaluate useful vars
	step_size = tile_texture.get_size().x
	edge_pos = step_size * tsize / 2.0
	if get_child_count() == 0:
		# Create Tile
		tile = Sprite.new()
		tile.texture = tile_texture
		tile.modulate = color
		tile.centered = false
		set_tile_positions(true)


func set_tile_positions(add_tiles = false):
	var pos = Vector2.ZERO
	var idx = 0
	for row in tile_map:
		for cell in row:
			if cell:
				if add_tiles:
					tile.position = pos
					add_child(tile.duplicate())
				else:
					get_child(idx).position = pos
					idx += 1
			pos.x += step_size
		pos.x = 0
		pos.y += step_size


func rotate(left = true):
	var rm = coordinate_matrices[tsize - 2]
	var rotated_tiles = tile_map.duplicate(true)
	if left:
		for y in tsize:
			var xx = rm.find(-rm[y])
			for x in tsize:
				rotated_tiles[y][x] = tile_map[x][xx]
	else:
		for x in tsize:
			var yy = rm.find(-rm[x])
			for y in tsize:
				rotated_tiles[y][x] = tile_map[yy][y]
	tile_map = rotated_tiles
	set_tile_positions(false)


func move(dx, dy):
	position += Vector2(dx, dy) * step_size
	xpos += dx
	ypos += dy
	set_tile_visibility()


func move_to(x, y):
	position = Vector2(x, y) * step_size
	xpos = x
	ypos = y
	set_tile_visibility()


# Hide tiles that are above the area
func set_tile_visibility():
	if ypos < 4:
		var hidden_depth = step_size * -ypos
		for node in get_children():
			if node.position.y >= hidden_depth:
				node.visible = true
			else:
				node.visible = false


func reparent_tiles(target_node):
	for t in get_children():
		self.remove_child(t)
		target_node.add_child(t)
		t.set_owner(target_node)
		t.position += self.position
