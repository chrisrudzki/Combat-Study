extends "res://Characters/entity_base.gd"
class_name Entity


#two states for COW_STATE
enum COW_STATE { IDLE, WALK }
@export var move_speed : float = 20

@export var idle_time : float = 1
@export var walk_time : float = 2

@export var target: Node2D = null


@onready var timer = $Timer2
@onready var fsm = $Finite_State_Machine
@onready var wonder_state = $Finite_State_Machine/WonderState as WonderState
@onready var follow_state = $Finite_State_Machine/FollowState as FollowState

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE
var p : int = 10

func _ready():
	
	
	fsm.change_state(wonder_state)
	timer.start(10.0)
	
#func _physics_process(_delta):
	#if x > 10:
	#	fsm.change_state(otherstate)
	
	
#randomly generate move direction between -1 , 1


func _on_timer_2_timeout() -> void:
	fsm.change_state(follow_state)
