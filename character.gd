
extends CharacterBody2D

@export var move_speed : int = 520

var starting_direction = Vector2(0,1)
var input_direction = starting_direction
#var velocity : Vector2
#print
#var boid_num = 9999
#
var boid_avoids = false
@onready var timer = $Timer
var prev_input_direction = starting_direction
var player_rolling = false

var health = 100

func player():
	pass
	
func get_hit(x):
	
	
	health = health - x
	print("HEALTH: ", health)
	


func _physics_process(_delta):
	
	if !player_rolling:
		input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	
	#
	#print("in_dir", input_direction)
	#print(Input.get_action_strength("right"))
	#print(Input.get_action_strength("left"))
	#
	
	if input_direction != Vector2.ZERO:
		prev_input_direction = input_direction
		
	
	
	var player_roll = Input.get_action_strength("space")
	
	if player_roll:
		boid_avoids = true
		player_rolling = true
		move_speed = 1000
		
		timer.wait_time = .17
		timer.start()
		
	if player_rolling == true:
		input_direction = prev_input_direction
	
	
	
	input_direction = input_direction.normalized()
	
	
	velocity = input_direction * move_speed
	
	if velocity.x > move_speed or velocity.y > move_speed:
		
		velocity = input_direction * move_speed
	
	
	move_and_slide()
	
	
func _on_timer_timeout() -> void:
	move_speed = 520
	player_rolling = false
	boid_avoids = false
	velocity = Vector2.ZERO # Replace with function body.
