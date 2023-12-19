extends Node3D

var house_res = preload("res://levels/house.tscn")
var bridge_res = preload("res://levels/bridge.tscn")

var houses : Array[Rect2i]
var growable : Array[int]
const houses_wide : int = 5
const houses_deep : int = 5
const house_skip_chance : int = 20
const house_space_x : int = 4
const house_space_z : int = 4
const min_left : int = - house_space_x * houses_wide / 2
const min_top : int = - house_space_z * houses_deep / 2
const max_right : int = house_space_x * houses_wide / 2
const max_bottom : int = house_space_z * houses_deep / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate():
	generate_rects()
	generate_houses()
	generate_bridges()

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

func generate_houses():
	for idx in houses.size():
		var house : Rect2i = houses[idx]
		var house_object = house_res.instantiate();
		house_object.set_size(house.size.x, house.size.y)
		var posx : float = house.position.x + 0.5 * house.size.x
		var posy : float = house.position.y + 0.5 * house.size.y
		house_object.set_position(Vector3(posx, 0.0, posy))
		add_child(house_object)

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
	var px = randi() % rect.size.x
	var py = randi() % rect.size.y
	var pos = Vector3(rect.position.x + px + 0.5, 0.0, rect.position.y + py + 0.5)
	
	var bridge_object = bridge_res.instantiate();
	bridge_object.set_position(pos)
	add_child(bridge_object)

func house_touch(idx, rect):
	for cidx in houses.size():
		if cidx != idx:
			var col_house : Rect2i = houses[cidx]
			if col_house.intersects(rect):
				return true
	return false
