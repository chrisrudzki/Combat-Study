extends CharacterBody2D


var movement_speed = 5000

var neighbours = []

var neighbours_and_p = []
var boid_num
var player
var player_in_boid
var boid_avoid
var vel_slow = 2
@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var raycast3 = $RayCast2D3
@onready var raycast4 = $RayCast2D4
#@onready var raycast5 = $RayCast2D5
#@onready var raycast6 = $RayCast2D6

@onready var timer = $Timer
@onready var timer2 = $Timer2

var melee_dmg = 25

var melee_cooldown = false
var is_attacking = false
var boid_stop = false
var knockback_timer = 0
var drag_coefficient = .0001
var dir_to

#offset centre, adj movement, nearby velocity
var oc = Vector2.ZERO
var am = Vector2.ZERO
var nv = Vector2.ZERO



func all_raycasts():
	var casts = [raycast1, raycast2, raycast3, raycast4]
	return casts

func all_neighbours():
	return neighbours
	
	
func does_boid_avoid():
	return boid_avoid



func boid():
	pass

func get_player():
	if player != null:
		return player
		
	
func _physics_process(_delta: float):
	
	var parent = get_parent()
	var player = parent.get_node("Player")
	
	
	if is_attacking and melee_cooldown == false: #if player is in boid 
		
		player.get_hit(melee_dmg)
		melee_cooldown = true
		timer2.wait_time = 2
		timer2.start()
	
	
	var path_arr = parent.get_path_arr(position, player.position)
	
	
	#print("size ", path_arr.size())
	
	#print("player pos ", player.position)
	#print("boid pos ", position)
	#
	if path_arr:
		dir_to = position.direction_to(path_arr[2])
		#print("vel 1 ", velocity)
	
		#print("dir to ", dir_to)
	
		rotation = lerp_angle(rotation, position.direction_to(path_arr[2]).angle(), .4)
		
		
	#add dir_to
	#velocity = velocity * movement_speed
	
	
	
	#print("velo 1", velocity)
	
	#velocity = velocity * movement_speed
	
	#velocity = velocity.normalized() * movement_speed
	
	
	
	#print("dir to d", position.direction_to(path_arr[2]))
	#velocity = velocity.normalized() * movement_speed
	#print()
	
	#velocity = dir_to * movement_speed
	
	
	#velocity = velocity + position.direction_to(path_arr[2])
	
	#
	#print("velo 1", velocity)
	#
	#print("")
	#move_and_slide()
	
	
	
	if boid_avoid == true:
		
		if abs(player.position.x - position.x) < 60 and abs(player.position.y - position.y) < 60:
			am = am - (player.position - position) * 3#/250
			boid_stop = true
			#print("am: ", am)
	
	
	for i in len(neighbours):
		
		oc = oc + neighbours[i].position
		
		nv = nv + neighbours[i].velocity 
		
		if abs(neighbours[i].position.x - position.x) < 35 and abs(neighbours[i].position.y - position.y) < 35:
			am = am - (neighbours[i].position - position)/20000
			knockback_timer = 10
		
	
	if len(neighbours) != 0:
		
		oc = oc / len(neighbours)
		oc = oc.normalized()
		
		nv = nv / len(neighbours)
	
		nv = nv / 800
	
	#print
	
	#normalize boids speed when alone or in a group
		
	if len(neighbours) == 0:
		velocity = velocity /1.07
			
			
	#offset centre, adj movement, nearby velocity
	
	
	#put in adj movment for non boid avoidance(player)
	
	
	#velocity = velocity.normalized() + (path_arr[0]) * 4
	
	#velocity = dir_to
	
	#position = position + velocity
	#
	
	
	#print(" ")
	#print("velo 2 ", velocity)
	#print(oc)
	#print(am)
	#print(nv)
	#print(dir_to_player)
	
	
	
	#print("vel ", velocity)
	#if boid_stop == true:
		#velocity = velocity / 2
		##velocity = velocity / vel_slow
		#vel_slow = vel_slow - 1
		#if vel_slow < 0:
			#vel_slow = 2
			#boid_stop = false
	##
	
	
	#boid_stop
	
		
	if knockback_timer > 0:
		
		velocity -= velocity * drag_coefficient * _delta
		
		knockback_timer = knockback_timer -1 
	
	
	if velocity.length() < .3:
		velocity = Vector2.ZERO
	
	
	
	#var casts = all_raycasts()
	#dont have to initalize every frame
	#for r in casts:
		#if r.is_colliding():
			#
			#if r.get_collider().is_in_group("blocks"):
				#print("is block")
				#
				##var magi = (100/(r.get_collision_point() - global_position).length_squared())
				#var distance_between = r.get_collision_point() - position
				##print("distance_between ", distance_between)
				#var new_loc = (position - distance_between) * .01
				#rotation = lerp_angle(rotation, (global_position - distance_between).angle(), 0.4)
				##x -= (r.cast_to.rotated(rotation) * magi)
				##x = new_loc
			#
				#velocity = velocity + new_loc
	#
	#
	#
	
	#dir_to + oc +  am + nv
	#velocity = velocity.normalized()
	#
	
	
	print("dir_to ", dir_to)
	#print("oc ", oc)
	#print("am ", am)
	#print("nv ", nv)
	#
	velocity = (dir_to + oc/2 +  am + nv) * movement_speed * _delta
	
	
	#print("boid v", velocity * _delta)
	#print("vel2 ", velocity)
	#move_and_collide(velocity * movement_speed * _delta)
	
	print("velo end", velocity)
	
	move_and_slide()
	oc = Vector2.ZERO
	am = Vector2.ZERO
	nv = Vector2.ZERO
	
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	
	if body.has_method("player"):
		player_in_boid = true
		#print("player enter!")
		
		if body.player_rolling == true:
			boid_avoid = true
			
		else:
			is_attacking = true
			#player = body
			
			
	if (body.has_method("boid") and body.boid_num != boid_num):
		#print("appending here!!")
		neighbours.append(body)
	
	
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	
	
	if body.has_method("boid") and body.boid_num != boid_num:
		
		neighbours.erase(body)
		
	if body.has_method("player"):
		
		player_in_boid = false
		boid_avoid = false
		is_attacking = false



func _on_timer_timeout() -> void:
	pass


func _on_timer_2_timeout() -> void:
	melee_cooldown = false
