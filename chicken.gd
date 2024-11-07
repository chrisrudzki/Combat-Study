extends CharacterBody2D

@export var move_speed : float = 10

@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var raycast3 = $RayCast2D3
@onready var raycast4 = $RayCast2D4
@onready var raycast5 = $RayCast2D5
@onready var raycast6 = $RayCast2D6
@onready var raycast7 = $RayCast2D7
@onready var raycast8 = $RayCast2D8

@export var target: Node2D = null 
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite = $Sprite2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")


#var player_cat_global_position = $player_cat.global_position


func _ready():
	call_deferred("seeker_setup")
	
	
	#wait a physiscs frame before tree set up 
func seeker_setup():
	await get_tree().physics_frame
	
	#if target exists then nav agents target pos to target
	if target:
		navigation_agent_2d.target_position = target.global_position
	

func _physics_process(_delta):
	if target:
		navigation_agent_2d.target_position = target.global_position
	
	if navigation_agent_2d.is_navigation_finished():
		
		return
	
	var current_agent_position = global_position
	var next_path_postition = navigation_agent_2d.get_next_path_position()
	
	var norm_to_player_vector = current_agent_position.direction_to(next_path_postition)
	
	#get dot product of each of the 8 directions and norm_to_player_vector
	var directions = [Vector2(0,-1), Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(-1,1),Vector2(-1,0),Vector2(-1,-1)]
	var intrest_arr = []
	var smart_intrest_arr = []
	var coll_arr = [0,0,0,0,0,0,0,0]
	
	var dot_product : float = 0
	
	
	for i in range(len(directions)):
		#dot product of norm_to player , each directions 
		#print(norm_to_player_vector)
		#print("1 calc: ", norm_to_player_vector.x * directions[i].x, "    2 calc: ", norm_to_player_vector.y * directions[i].y)
		dot_product = (norm_to_player_vector.x * directions[i].x) + (norm_to_player_vector.y * directions[i].y)
		intrest_arr.append(dot_product)
		
	
	
	
	if raycast1.is_colliding():
		#print("coll1")
		coll_arr[7] += 2
		coll_arr[0] += 5
		coll_arr[1] += 2
	
	if raycast2.is_colliding():
		#print("coll1")
		coll_arr = [2,5,2,0,0,0,0,0]
		
	if raycast3.is_colliding():
		#print("coll3")
		coll_arr = [0,2,5,2,0,0,0,0]
		
	if raycast4.is_colliding():
		#print("coll4")
		coll_arr = [0,0,3,5,3,0,0,0]
		
	if raycast5.is_colliding():
		#print("coll5")
		coll_arr = [0,0,0,3,5,3,0,0]
		
	if raycast6.is_colliding():
		#print("coll6")
		coll_arr = [0,0,0,0,3,5,3,0]
		
	if raycast7.is_colliding():
		#print("coll7")
		coll_arr = [0,0,0,0,0,3,5,3]
		
	if raycast8.is_colliding():
		#print("coll8")
		coll_arr = [3,0,0,0,0,0,3,5]
		
	print("intrest arr: ", intrest_arr)

	
	
	
	
	for i in range(len(intrest_arr)):
		
		if coll_arr.is_empty() == false :
			
			smart_intrest_arr.append(intrest_arr[i] - coll_arr[i])
		
	
	
	#print("smart_intrest_arr: ", smart_intrest_arr)
	var max_i = smart_intrest_arr.max()
	var max_index = smart_intrest_arr.find(max_i)
	#print("max_index: ", max_index, " smart_intrest_arr: ", smart_intrest_arr)
	#print("current velocity: ", velocity) 
	
	var steering_force = (directions[max_index] * move_speed)  - velocity 
	#print("new volocity", (directions[max_index] * move_speed), "velocity: ",  velocity)
	
	velocity = velocity + (steering_force * _delta)
	
	move_and_slide()
	det_cur_state()
	sprite.flip_h = false if velocity.x > 0 else true 
	

func det_cur_state():
	
	if velocity != Vector2.ZERO:
		state_machine.travel("walk_right")
		print("here")
	else:
		state_machine.travel("idle_right")
