class_name Finite_State_Machine
extends Node


@export var state: State
	
func _ready():
	change_state(state)
	
	
func change_state(new_state: State):
	print("changing state!")
	
	if state is State:
		
		state._exit_state()
		
	new_state._enter_state()
	state = new_state
	
	
#take state in 
#set state 

#remove prev state? 
