extends CharacterBody2D

@export var move_speed : int = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
# parameters/idle/blend_position

@onready var animation_tree = $AnimationTree
#stores the node animation free in editor as varible

@onready var state_machine = animation_tree.get("parameters/playback")

#parameters/idle/blend_position
#this is the position in gadot to edit the idle perameter

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	
	#get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	update_animation_parameters(input_direction)
	
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	
	det_cur_state()
	
func update_animation_parameters(move_input : Vector2):
	
	#gets movment input vector and converts it to blend position
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		
		
	
func det_cur_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
		#print("idle")
	
	#update velocity 
	
	#do some stuff   
	#etc
	
	
	
