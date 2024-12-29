extends CharacterBody2D


var movement_speed = 3.5

var neighbours = []
var neighbours_and_p = []
var boid_num
var player
@onready var raycast1 = $RayCast2D
@onready var raycast2 = $RayCast2D2
@onready var raycast3 = $RayCast2D3
@onready var raycast4 = $RayCast2D4

@onready var timer = $Timer

func all_raycasts():
	
	var casts = [raycast1, raycast2, raycast3, raycast4]
	return casts

func all_neighbours():
	
	return neighbours
	
	
func all_neighbours_and_p():
	
	
	return neighbours_and_p

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
	
	if parent.has_node("Player"):
		
		#parent.Player.global_position
		var player = parent.get_node("Player")
		
		#print(player.global_position)
		
		var dir_to_player = self.global_position.direction_to(player.global_position)
		
		dir_to_player = dir_to_player.normalized()
		
		
		#print("rotation angle ", dir_to_player.angle())
		rotation = lerp_angle(rotation, dir_to_player.angle(), .4)
		
		
		#print("dir_to_player,  movement_speed ", dir_to_player, " ", movement_speed )
		velocity = dir_to_player * movement_speed
	
	
	
	move_and_collide(velocity)

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		if body.boid_avoids_p == true:
			player = body
			neighbours_and_p.append(body)
			#neighbours.append(body)
	
	if (body.has_method("boid") and body.boid_num != boid_num):
		neighbours.append(body)
		neighbours_and_p.append(body)#!
	
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("here exit")
	if body.has_method("boid") and body.boid_num != boid_num:
		neighbours.erase(neighbours.find(body))
	
	if body.has_method("player"):
		player = null


func _on_timer_timeout() -> void:
	movement_speed = 3.5
