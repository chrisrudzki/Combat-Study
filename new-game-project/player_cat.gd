class_name Player
extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = false
var health = 100
var player_alive = true



@export var move_speed : int = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
# parameters/idle/blend_position

@onready var animation_tree = $AnimationTree
#@onready var timer = $Timer
#stores the node animation free in editor as varible

@onready var state_machine = animation_tree.get("parameters/playback")

@export var attack_cooldown : float = 2

@onready var new_player_pos = 0
@onready var timer = $Timer
@export var player_node = Node2D

var is_knockback = false
var k = 0

var can_attack = false

var hittable_obj = Node
var is_knockback_timer = 0
var drag_coefficient = 0.1

#var velocity = Vector2(0,0)

#var attack_cooldown = 10.0

#parameters/idle/blend_position
#this is the position in gadot to edit the idle perameter

func _ready():
	update_animation_parameters(starting_direction)

func player_knockback(new_pos):
	
	new_player_pos = new_pos
	is_knockback = true

		#_physics_process()
		#velocity = velocity + new_pos
		#print("knockback")
		#move_and_slide()


func _physics_process(_delta):
	
	#print("-")
	#enemy_attack()
	
	if health <= 0:
		player_alive = false
		#print("player dead!!")
		health = 0
		#do whatever death functions
		
		
	#get input direction
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	var attack_input = int(Input.get_action_strength("attack1"))
	#print(attack_input)
	
	
	if can_attack == true and attack_input == 1:
		hittable_obj.test()
		timer.start(attack_cooldown)
		can_attack = false
	
	
	
	
	update_animation_parameters(input_direction)
	
	#print("velocity: ", input_direction * move_speed)
	
	
	
	
	
	if is_knockback == true:
		
		velocity = velocity + new_player_pos.normalized() * 100
		is_knockback_timer = 10
		
	
		
	#print("velocity")
	if is_knockback_timer > 0:
		print("is_knockback_timer")
		print(velocity, " before")
		velocity -= velocity * drag_coefficient * _delta
		print(velocity, " after")
		is_knockback_timer = is_knockback_timer -1 
	else:
		velocity = input_direction * move_speed
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
		
	#velocity = input_direction * move_speed
	
	
	
	#print(velocity)
	
	#print("is_knockback: ", is_knockback)
	#if is_knockback == true:
		#k = k+1
		##print("player pos ", player_node.global_position)
		##print("knockback pos ", new_player_pos)
		##print("-")
		##print(velocity)
		##print(new_player_pos)
		##print("-")
		#
		##print("newplayer direction", new_player_pos.normalized())
		#velocity = new_player_pos.normalized() * 500
		#just_hit = 5
		#print("coll")
		##velocity = velocity + new_player_pos
	#
	
	#create a mechanic where it effects the pass after the knockback to knockback the player 1/2 the power
	
	
	#just_hit = just_hit - 1
	#
	#if just_hit <= 3 and just_hit > 0:
		#velocity =  velocity + (new_player_pos.normalized() * 500) / drag
		#drag = drag * 2
		#
		
		
		
	
	
	
	
	
	#print("just_hit: ", just_hit)
	move_and_slide()
	
	det_cur_state()
	
	is_knockback = false
	
	#just_hit = 0

	
func reduce_health(amount):
	
	health = health - amount



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
	
func player():
	pass
	

#i dont understand this connection
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("hittable"):
		can_attack = true
		hittable_obj = body 
	#if body.has_method("enemy"):
		#enemy_inattack_range = true
		#

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("hittable"):
		can_attack = false
	#if body.has_method("enemy"):
		#enemy_inattack_range = false
		#


#
#func enemy_attack():
	#if enemy_inattack_range and enemy_attack_cooldown == false:
		#health = health - 10
		#enemy_attack_cooldown = true
		#timer.start(attack_cooldown)
		



func _on_timer_timeout() -> void:
	can_attack = true
