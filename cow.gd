extends CharacterBody2D
class_name Entity



#two states for COW_STATE
enum COW_STATE { IDLE, WALK }
@export var move_speed : float = 20

@export var idle_time : float = 1
@export var walk_time : float = 2

@export var target: Node2D = null
#@onready var sprite = $Sprite2D


@onready var timer = $Timer2
@onready var fsm = $Finite_State_Machine
@onready var wonder_state = $Finite_State_Machine/WonderState as WonderState
@onready var follow_state = $Finite_State_Machine/FollowState as FollowState


@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D

#@onready var cow_hitbox = $cow_hitbox
#@onready var collisionshape = cow_hitbox.get("CollisionShape2D"")

var cow_health : int = 100


var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE
var p : int = 10

var player_in_range = false



func _ready():
	
	
	fsm.change_state(follow_state)
	
	
	#timer.start(10.0)
	
#func _physics_process(_delta):
	#if x > 10:
	#	fsm.change_state(otherstate)
	
	
#randomly generate move direction between -1 , 1

func hittable():
	pass
	
func damage_self():
	

	cow_health = cow_health - 30
	print("cow health: ", cow_health)
	
	
	#print("cow_health: ", cow_health)
	if cow_health < 0:
		#$CollisionShape2D.disabled = true
		$CowHitbox/CollisionShape2D.disabled = true
		
		
		
		set_physics_process(false)
		print("COW DEAD")
		queue_free()


func _on_timer_2_timeout() -> void:
	fsm.change_state(follow_state)
	
	
#not sure if this was here before or relevent
func _on_cow_hitbox_body_exited(body: Node2D):
	if body.has_method("player"):
		player_in_range = false
