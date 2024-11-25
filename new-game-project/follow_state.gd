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
@export var timer : Timer
@export var knockback_power : float = 1000.0
var knockback_duration : int = 10


@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 5

var player_in_range = false
var reaction_time = 0.5

func _ready():
	
	set_physics_process(false)
	#call_deferred("seeker_setup")
	
func _enter_state():
	#print("enter follow state")
	set_physics_process(true)
	call_deferred("seeker_setup")

func _exit_state():
	#print("exit follow state")
	set_physics_process(false)
	
	#wait a physiscs frame before tree set up 
func seeker_setup():
	await get_tree().physics_frame
	
	#if target exists then nav agents target pos to target
	if parent_node.target:
		navigation_agent_2d.target_position = parent_node.target.global_position
	

func _physics_process(_delta):
	#print("follwing")
	
	
	#!!!!!
	#print(player_in_range)
	#print("-")
	#print("player not in range")
	if player_in_range == true:
		#print("player in range")
		if timer.is_stopped():
		
		
		#THIS IS THE ISSUE 
			timer.start(.3)
	#else: 
		#print("player not in range")
	
	
	if parent_node.target:
		navigation_agent_2d.target_position = parent_node.target.global_position
		
	#print("-")
	#print("player position: ", parent_node.target.global_position)
	#print("cow position: ", actor.global_position)
	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var current_agent_position = actor.global_position
	var next_path_postition = navigation_agent_2d.get_next_path_position()
	
	#print("-")
	#print("current_agent_position: ", current_agent_position)
	#print("next_path_postition: ",  next_path_postition)
	var norm_to_player_vector = current_agent_position.direction_to(next_path_postition)
	#print("norm_to_player_vector", norm_to_player_vector)
	#!
	
	#get dot product of each of the 8 directions and norm_to_player_vector
	
	#assuming normal x,y axis
	var directions = [Vector2(0,-1), Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(-1,1),Vector2(-1,0),Vector2(-1,-1)]
	var intrest_arr = []
	var smart_intrest_arr = []
	var coll_arr = [0,0,0,0,0,0,0,0]
	
	var dot_product : float = 0
	
	
	for i in range(len(directions)):
		
		dot_product = (norm_to_player_vector.x * directions[i].x) + (norm_to_player_vector.y * directions[i].y)
		intrest_arr.append(dot_product)
		
		
	
	#print(intrest_arr)
	
	
	if raycast1.is_colliding():
		#print("coll1")
		coll_arr = [8,4,0,0,0,0,0,4]
	
	if raycast2.is_colliding():
		#print("coll1")
		coll_arr = [4,8,4,0,0,0,0,0]
		
	if raycast3.is_colliding():
		#print("coll3")
		coll_arr = [0,4,8,4,0,0,0,0]
		
	if raycast4.is_colliding():
		#print("coll4")
		coll_arr = [0,0,4,8,4,0,0,0]
		
	if raycast5.is_colliding():
		#print("coll5")
		coll_arr = [0,0,0,4,8,4,0,0]
		
	if raycast6.is_colliding():
		#print("coll6")
		coll_arr = [0,0,0,0,4,8,4,0]
		
	if raycast7.is_colliding():
		#print("coll7")
		coll_arr = [0,0,0,0,0,4,8,4]
		
	if raycast8.is_colliding():
		#print("coll8")
		coll_arr = [4,0,0,0,0,0,4,8]
		
	#print("intrest arr: ", intrest_arr)

	
	if coll_arr.is_empty() == false :
		for i in range(len(intrest_arr)):
			smart_intrest_arr.append(intrest_arr[i] - coll_arr[i])
			
	#print("smart_intrest_arr: ", smart_intrest_arr)
		
	#print("smart_intrest_arr: ", smart_intrest_arr)
	var max_i = smart_intrest_arr.max()
	var max_index = smart_intrest_arr.find(max_i)
	
	var steering_force = (directions[max_index] * move_speed)  - actor.velocity 
	#var steering_force = (directions[max_index] * move_speed)  - actor.velocity 
	actor.velocity = actor.velocity + (steering_force * _delta)
	
	#actor.velocity = Vector2.ZERO
	actor.move_and_slide()
	det_cur_state()
	sprite.flip_h = false if actor.velocity.x > 0 else true 
	

func det_cur_state():
	
	if actor.velocity != Vector2.ZERO:
		state_machine.travel("walk_right")
		#print("here")
	else:
		state_machine.travel("idle_right")


func _on_cow_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		#print("true")
		player_in_range = true



func _on_cow_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		#print("false")
		player_in_range = false


func _on_timer_3_timeout() -> void:
	#if enemy has player in range 
	#print("attack player")
	parent_node.target.reduce_health(20)
	#print(parent_node.target.global_position, " - ", actor.global_position)
	#print((parent_node.target.global_position - actor.global_position).normalized()*knockback_power)
	#print(actor.global_position)
	
	#print("outside while")
	#print(knockback_duration)
	print("in ranage timer")
	if player_in_range == true:
		print("here")
		parent_node.target.reduce_health(20)
		parent_node.target.player_knockback((parent_node.target.global_position - actor.global_position).normalized()*knockback_power)
	
	#while knockback_duration > 0:
		#print("knockback player")
		#knockback_duration = knockback_duration - 1
		#parent_node.target.player_knockback((parent_node.target.global_position - actor.global_position).normalized()*knockback_power)
	#knockback_duration = 10
