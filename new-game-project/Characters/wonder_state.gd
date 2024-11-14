class_name WonderState
extends State


@export var move_speed : float = 14
@export var idle_time : float = 7
@export var walk_time : float = 5


@export var actor: Entity
@export var animation_tree: AnimationTree


@onready var state_machine = animation_tree.get("parameters/playback")

@export var timer : Node
@export var sprite : Node



enum COW_STATE { IDLE, WALK }

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE


#this state has substates of idle and walk
func _ready():
	print("enter wonder state")
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)
	pick_new_state()
	
func test_func(x):
	print(x)
	
func _exit_state():
	print("exit wonder state")
	set_physics_process(false)

func _physics_process(_delta):
	if(current_state == COW_STATE.WALK):
	
		actor.velocity = move_direction * move_speed
	
		actor.move_and_slide()


func pick_new_state():
	
	
	if(current_state == COW_STATE.IDLE):
		
		state_machine.travel("walk_right")#changes animation
		current_state = COW_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
		
	elif(current_state == COW_STATE.WALK):
		
		state_machine.travel("idle_right")#changes animation
		current_state = COW_STATE.IDLE
		timer.start(idle_time)
	

	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	while move_direction == Vector2.ZERO:
		select_new_direction()
	
	if(move_direction.x < 0 ):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false 



func _on_timer_timeout():
	#print("timer timeout")
	pick_new_state()
	#pass # Replace with function body.
