extends Node2D


var mynode = preload("res://boid.tscn")

var boids = []
var boid_num = 0

#@onready var raycasts = $Detection


func _ready() -> void:
	
	#initalze _positions
	#for loop spawning boids
	#var boid_amount = 2
	
	#var vec = Vector2(700,0)
	
	pass
	
	
	#
	#for b in boid_amount:
		#
		#b = inst(vec)
		##print("boid pos ", vec)
		#boids.append(b)
		#
		#vec.x = vec.x + 250
		#vec.y = vec.y + -100
		#
		#
		#var o = Vector2(0,0)
		#var nn = Vector2(1,3)
		#
		#var u = o + nn
		#u = u + 1
		#
		#print(u)
		#
		#
	
	

func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("click"):
		var click_position = get_global_mouse_position()
		var b = inst(click_position)
		boids.append(b)
	
	move_all_boids_to_new_positions(boids)
	
	
	
	
func move_all_boids_to_new_positions(boids):
	
	var v1 : Vector2 = Vector2.ZERO
	var v2 : Vector2 = Vector2.ZERO
	var v3 : Vector2 = Vector2.ZERO
	var v4 : Vector2 = Vector2.ZERO
	
	for b in boids:
		
		v1 = rule1(b)
		v2 = rule2(b)
		v3 = rule3(b)
		
		
		
		#normalize boids speed when alone or in a group
		var neighbours = b.all_neighbours()
		
		if len(neighbours) == 0:
			b.velocity = b.velocity /1.07
			
			
			
		v4 = avoid_map_col(b)
		
		
		
		
			
			
		
		b.velocity = b.velocity + v1 + v2 + v3
		b.position = b.position + b.velocity
		
		
		






func rule1(b):
	#fly towards center of mass
	#correct faster lone boids
	
	var pc = Vector2.ZERO
	#return Vector2.ZERO
	
	var neighbours = b.all_neighbours()
	#print("len neighnours ", len(neighbours))
	for i in len(neighbours):
		
		#print("neighbour", i)
		pc = pc + neighbours[i].position
		
	#print("pc: ", pc)
		
	if len(neighbours) != 0:
	
		pc = pc / (len(neighbours))
		
		return pc.normalized() *3
	
	return Vector2.ZERO
	
	
	
func rule2(b):
	#distance away from boids and objects
	
	var c = Vector2.ZERO
	
	var neighbours = b.all_neighbours()
	#
	var neighbours_and_p = b.all_neighbours_and_p()
	
	
	
	
	for i in len(neighbours):
		
		if abs(neighbours[i].position.x - b.position.x) < 50 and abs(neighbours[i].position.y - b.position.y) < 50:
			c = c - (neighbours[i].position - b.position)#/250
			
			c = c.normalized()
			#print("c: ", c)
	
	if b.get_player() != null:
		var p = b.get_player()
		
		
		if abs(p.global_position.x - b.position.x) < 60 and abs(p.global_position.y - b.position.y) < 60:
			c = c - (p.global_position - b.position) * 1.5 #/250
			
		b.slow_boid()
	
	
	
	return c
	
	
	
	
	
func rule3(b):
	#match velocity
	
	var neighbours = b.all_neighbours()
	
	var pv = Vector2.ZERO
	
	
	if len(neighbours) != 0:
		for i in range(len(neighbours)):
		#print("n velocity ", neighbours[i].velocity)
			pv = pv + neighbours[i].velocity 
		
		pv = pv / len(neighbours)
	
		return pv / 6
	
	
	
	
	return Vector2.ZERO
	
	
func avoid_map_col(b):
	
	var x = Vector2.ZERO
	#var raycasts = $Detection
	var raycasts = b.all_raycasts()
	#.get_children()

	##UNDERSTANDD THIS 
	
	for r in raycasts:
		
		if r.is_colliding():
			
			if r.get_collider().is_in_group("blocks"):
				#print("is block")
				
				#var magi = (100/(r.get_collision_point() - global_position).length_squared())
				var distance_between = r.get_collision_point() - b.global_position
				print("distance_between ", distance_between)
				var new_loc = (b.global_position - distance_between)*10
				b.rotation = lerp_angle(b.rotation, (b.global_position - distance_between).angle(), 0.4)
				#x -= (r.cast_to.rotated(rotation) * magi)
				x = new_loc
	return x
	
	
	
func inst(pos):
	var ins = mynode.instantiate()
	
	
	ins.boid_num = boid_num + 1
	boid_num = boid_num + 1
	ins.position = pos
	#ins.target = $Player
	add_child(ins)
	
	return ins
