extends CharacterBody2D


var movement_speed = 3.5

var neighbours = []
var neighbours_and_p = []
var boid_num
var player
var player_in_boid
var boid_avoid
@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var raycast3 = $RayCast2D3
@onready var raycast4 = $RayCast2D4

@onready var timer = $Timer
@onready var timer2 = $Timer2

var melee_dmg = 35

var melee_cooldown = false
var is_attacking = false


func all_raycasts():
	
	var casts = [raycast1, raycast2, raycast3, raycast4]
	return casts

func all_neighbours():
	
	return neighbours
	
	
func does_boid_avoid():
	return boid_avoid

func slow_boid():
	movement_speed = .5
	timer.start()
	

func boid():
	pass

func get_player():
	if player != null:
		return player
		

	
func _physics_process(delta: float):
	
	
	var parent = get_parent()
	var player = parent.get_node("Player")
	
	if is_attacking and melee_cooldown == false: #if player is in boid 
	###!!!
		player.get_hit(melee_dmg)
		melee_cooldown = true
		timer2.wait_time = 2
		timer2.start()
	

		
	var dir_to_player = self.global_position.direction_to(player.global_position)
		
	dir_to_player = dir_to_player.normalized()
		
	rotation = lerp_angle(rotation, dir_to_player.angle(), .4)
		
	velocity = dir_to_player * movement_speed
	
	
	move_and_collide(velocity)

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		player_in_boid = true
		
		if body.boid_avoids == true:#player is rolling
			boid_avoid = true
			
		else:
			is_attacking = true
			#player = body
			
			
	if (body.has_method("boid") and body.boid_num != boid_num):
		neighbours.append(body)
		
	
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("here exit")
	if body.has_method("boid") and body.boid_num != boid_num:
		neighbours.erase(neighbours.find(body))
	
	if body.has_method("player"):
		player_in_boid = false
		is_attacking = false



func _on_timer_timeout() -> void:
	movement_speed = 3.5


func _on_timer_2_timeout() -> void:
	melee_cooldown = false
