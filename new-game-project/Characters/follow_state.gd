class_name FollowState
extends State


@export var raycast1 : RayCast2D
@export var raycast2 : RayCast2D
@export var raycast3 : RayCast2D
@export var raycast4 : RayCast2D
@export var raycast5 : RayCast2D
@export var raycast6 : RayCast2D
@export var raycast7 : RayCast2D
@export var raycast8 : RayCast2D

@export var navigation_agent_2d : NavigationAgent2D
@export var sprite : Sprite2D
@export var animation_tree : AnimationTree
@export var actor : Node
@export var parent_node : Node

@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 10





func _ready():
	
	set_physics_process(false)
	#call_deferred("seeker_setup")
	
func _enter_state():
	print("enter follow state")
	set_physics_process(true)
	call_deferred("seeker_setup")

func _exit_state():
	print("exit follow state")
	set_physics_process(false)
	
	#wait a physiscs frame before tree set up 
func seeker_setup():
	await get_tree().physics_frame
	
	#if target exists then nav agents target pos to target
	if parent_node.target:
		navigation_agent_2d.target_position = parent_node.target.global_position
	

func _physics_process(_delta):
	#print("follwing")
	if parent_node.target:
		navigation_agent_2d.target_position = parent_node.target.global_position
	
	if navigation_agent_2d.is_navigation_finished():
		
		return
	
	var current_agent_position = actor.global_position
	var next_path_postition = navigation_agent_2d.get_next_path_position()
	
	var norm_to_player_vector = current_agent_position.direction_to(next_path_postition)
	
	#get dot product of each of the 8 directions and norm_to_player_vector
	var directions = [Vector2(0,-1), Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(-1,1),Vector2(-1,0),Vector2(-1,-1)]
	var intrest_arr = []
	var smart_intrest_arr = []
	var coll_arr = [0,0,0,0,0,0,0,0]
	
	var dot_product : float = 0
	
	
	for i in range(len(directions)):
		
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
		
	#print("intrest arr: ", intrest_arr)

	
	for i in range(len(intrest_arr)):
		
		if coll_arr.is_empty() == false :
			
			smart_intrest_arr.append(intrest_arr[i] - coll_arr[i])
		
	#print("smart_intrest_arr: ", smart_intrest_arr)
	var max_i = smart_intrest_arr.max()
	var max_index = smart_intrest_arr.find(max_i)
	
	var steering_force = (directions[max_index] * move_speed)  - actor.velocity 
	actor.velocity = actor.velocity + (steering_force * _delta)
	
	actor.move_and_slide()
	det_cur_state()
	sprite.flip_h = false if actor.velocity.x > 0 else true 
	

func det_cur_state():
	
	if actor.velocity != Vector2.ZERO:
		state_machine.travel("walk_right")
		#print("here")
	else:
		state_machine.travel("idle_right")
