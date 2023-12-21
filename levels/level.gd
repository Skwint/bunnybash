extends Node3D

var house_res = preload("res://levels/house.tscn")
var bridge_res = preload("res://levels/bridge.tscn")
var broccoli_res = preload("res://entities/broccoli.tscn")
var bunny_res = preload("res://monsters/bunny.tscn")
var nav_wall_res = preload("res://levels/nav_wall.tscn")

enum Carto { EMPTY, HOUSE, BRIDGE }

var houses : Array[Rect2i]
var growable : Array[int]
var cartography : Array = []
var bunnies = []
var total_house_size : int = 0
var limits : Rect2i
const houses_wide : int = 5
const houses_deep : int = 5
const house_skip_chance : int = 20
const house_space_x : int = 4
const house_space_z : int = 4
const min_left : int = - house_space_x * houses_wide / 2
const min_top : int = - house_space_z * houses_deep / 2
const max_right : int = house_space_x * houses_wide / 2
const max_bottom : int = house_space_z * houses_deep / 2
const start_bunny_count : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate():
	generate_rects()
	generate_houses()
	generate_map()
	generate_bridges()
	generate_nav_walls()
	generate_broccoli()
	generate_bunnies()

func generate_rects():
	for z in houses_deep:
		for x in houses_wide:
			var skippy = randi_range(0,100)
			if skippy > house_skip_chance:
				var house = Rect2i(0,0,0,0)
				house.position.x = min_left + x * house_space_x + randi() % (house_space_x - 2)
				house.position.y = min_top + z * house_space_z + randi() % (house_space_z - 2)
				# the size needs to be 1 too big to force intersection on touch
				house.size.x = 2
				house.size.y = 2
				houses.append(house)

	growable.resize(houses.size())
	for idx in growable.size():
		growable[idx] = idx
			
	while not growable.is_empty():
		var idx = randi() % growable.size()
		var house_idx = growable[idx]
		var house = houses[house_idx]
		var rect : Rect2i = house
		var direction = randi() % 4
		var start_direction = direction
		var keep_trying = true
		while keep_trying:
			if direction == 0:
				if rect.position.x > min_left:
					rect.position.x -= 1
					if house_touch(house_idx, rect):
						rect.position.x += 1
					else:
						rect.size.x += 1
			elif direction == 1:
				if rect.position.x + rect.size.x < max_right:
					rect.size.x += 1
					if house_touch(house_idx, rect):
						rect.size.x -= 1
			elif direction == 2:
				if rect.position.y > min_top:
					rect.position.y -= 1
					if house_touch(house_idx, rect):
						rect.position.y += 1
					else:
						rect.size.y += 1
			else:
				if rect.position.y + rect.size.y < max_bottom:
					rect.size.y += 1
					if house_touch(house_idx, rect):
						rect.size.y -= 1
			if rect.size == house.size:
				direction = (direction + 1) % 4
				if direction == start_direction:
					keep_trying = false
					growable.remove_at(idx)
			else:
				houses[house_idx] = rect
				keep_trying = false
	
	for idx in houses.size():
		houses[idx].size.x -= 1
		houses[idx].size.y -= 1

func generate_map():
	limits = Rect2i(0,0,1,1)
	for idx in houses.size():
		limits = limits.merge(houses[idx])
	
	cartography.resize(limits.size.y)
	for y in limits.size.y:
		cartography[y] = []
		cartography[y].resize(limits.size.x)
		for x in limits.size.x:
			cartography[y][x] = Carto.EMPTY
	
	for idx in houses.size():
		var rect = houses[idx]
		for y in range(0, rect.size.y):
			var row = cartography[y + rect.position.y - limits.position.y]
			for x in range(0, rect.size.x):
				row[x + rect.position.x - limits.position.x] = Carto.HOUSE

func generate_houses():
	for idx in houses.size():
		var house : Rect2i = houses[idx]
		var house_object = house_res.instantiate();
		house_object.set_size(house.size.x, house.size.y)
		var posx : float = house.position.x + 0.5 * house.size.x
		var posy : float = house.position.y + 0.5 * house.size.y
		house_object.set_position(Vector3(posx, 0.0, posy))
		add_child(house_object)
		total_house_size += house.get_area()

func generate_bridges():
	# if we expand neighbouring rects by 1 in opposite directions,
	# then the overlaps formed are the potential bridges, and we just
	# need to choose one
	for lidx in range(0, houses.size() - 1, 1):
		for ridx in range(lidx + 1, houses.size(), 1):
			var lr = houses[lidx]
			var rr = houses[ridx]

			lr.size.x += 1
			rr.position.x -= 1
			var intersect : Rect2i = lr.intersection(rr)
			if intersect.size.y > 0:
				build_bridge(intersect)
			lr.size.x -= 1
			rr.position.x += 1

			rr.size.x += 1
			lr.position.x -= 1
			intersect = lr.intersection(rr)
			if intersect.size.y > 0:
				build_bridge(intersect)
			rr.size.x -= 1
			lr.position.x += 1

			lr.size.y += 1
			rr.position.y -= 1
			intersect = lr.intersection(rr)
			if intersect.size.x > 0:
				build_bridge(intersect)
			lr.size.y -= 1
			rr.position.y += 1

			rr.size.y += 1
			lr.position.y -= 1
			intersect = lr.intersection(rr)
			if intersect.size.x > 0:
				build_bridge(intersect)
			rr.size.y -= 1
			lr.position.y += 1

func build_bridge(rect):
	var px = rect.position.x + randi() % rect.size.x
	var py = rect.position.y + randi() % rect.size.y
	var pos = Vector3(px + 0.5, 0.0, py + 0.5)
	
	var bridge_object = bridge_res.instantiate()
	bridge_object.set_position(pos)
	add_child(bridge_object)
	cartography[py - limits.position.y][px - limits.position.x] = Carto.BRIDGE

func generate_nav_walls():
	for y in range(limits.size.y):
		var row = cartography[y]
		for x in range(limits.size.x):
			if row[x] == Carto.EMPTY:
				var nav_wall_object = nav_wall_res.instantiate()
				nav_wall_object.set_position(Vector3(limits.position.x + x + 0.5, 0.0, limits.position.y + y + 0.5))
				add_child(nav_wall_object)
				
	get_node("world_nav_low_x").get_node("shape").position.x = limits.position.x
	get_node("world_nav_low_z").get_node("shape").position.z = limits.position.y
	get_node("world_nav_high_x").get_node("shape").position.x = limits.position.x + limits.size.x
	get_node("world_nav_high_z").get_node("shape").position.z = limits.position.y + limits.size.y

func house_touch(idx, rect):
	for cidx in houses.size():
		if cidx != idx:
			var col_house : Rect2i = houses[cidx]
			if col_house.intersects(rect):
				return true
	return false

func random_place():
	var r = randi_range(0, total_house_size)
	for idx in houses.size():
		var rect : Rect2i = houses[idx]
		var count = rect.get_area()
		if r > count:
			r -= count
		else:
			var z : int = rect.position.y
			while r >= rect.size.x:
				r -= rect.size.x
				z += 1
			return Vector2(0.5 + rect.position.x + r, 0.5 + z)
	print("ERROR in random place")
	return houses[0].position

func generate_broccoli():
	for idx in houses.size():
		var rect : Rect2i = houses[idx]
		for z in range(rect.position.y, rect.position.y + rect.size.y, 1):
			for x in range(rect.position.x, rect.position.x + rect.size.x, 1):
				var broc = broccoli_res.instantiate()
				broc.set_position(Vector3(x + randf_range(0.2,0.8), 0.0, z + randf_range(0.2,0.8)))
				add_child(broc)
				
func generate_bunnies():
	for idx in start_bunny_count:
		var pos = random_place()
		build_bunny(pos)

func build_bunny(pos):
	var bun = bunny_res.instantiate()
	add_child(bun)
	bun.randomize()
	bun.reposition(Vector3(pos.x, 0.0, pos.y))
