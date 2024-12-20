class_name Player
extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = false
var health = 100
var player_alive = true



@export var move_speed : int = 70
@export var starting_direction : Vector2 = Vector2(0, 1)


@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var state_machine = animation_tree.get("parameters/playback")

@export var attack_cooldown : float = 2

@onready var new_player_pos = 0
@onready var timer = $Timer

@onready var timer2 = $Timer2

var is_knockback = false
var k = 0

var can_attack = false

var hittable_obj = Node
var is_knockback_timer = 0
var drag_coefficient = 0.1


var is_idle
var is_moving
var input_direction = starting_direction
var attack_input


func _ready():
	
	update_animation_parameters(starting_direction)

func player_knockback(new_pos):
	
	new_player_pos = new_pos
	is_knockback = true




func _physics_process(_delta):
	

	if health <= 0:
		player_alive = false
		
		health = 0
		
		
	
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	attack_input = int(Input.get_action_strength("attack1"))
	
	
	print(can_attack)
	if can_attack == true and attack_input == 1:
		
		hittable_obj.damage_self()
		timer.start(attack_cooldown)
		
		print("attacking!!")
		
		$PlayerHitbox/CollisionShape2D.disabled = true
		
		
		
	elif attack_input == 1:
		animation_tree["parameters/conditions/swing"] = true
	else:
		animation_tree["parameters/conditions/swing"] = false
	
	
	if is_knockback == true:
		
		velocity = velocity + new_player_pos.normalized() * 100
		is_knockback_timer = 10
		
	
		
	if is_knockback_timer > 0:
		
		velocity -= velocity * drag_coefficient * _delta
		
		is_knockback_timer = is_knockback_timer -1 
	else:
		velocity = input_direction * move_speed
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
		
	
	update_animation_parameters(input_direction)
	move_and_slide()
	
	is_knockback = false
	
func reduce_health(amount):
	
	health = health - amount



func update_animation_parameters(move_input : Vector2):
	
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/attack/blend_position", move_input)
		
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		
	else:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	
func player():
	pass
	

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("hittable"):
		can_attack = true
		hittable_obj = body
		#print("player enters!!!!")
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("hittable"):
		
		#print("player exits!!!!")
		can_attack = false
	
func _on_timer_timeout() -> void:
	$PlayerHitbox/CollisionShape2D.disabled = false
	


func _on_timer_2_timeout() -> void:
	
	can_attack = true
	pass
	
