extends CharacterBody2D


@export var hp_max : int = 100
@export var hp: int = hp_max
@export var defence: int = 0


@export var move_speed: int = 75
#var velocity: Vector2 = Vector2.ZERO

onready var sprite = $Sprite2D
onready var collShape = $CollisionShape2D
onready var animPlayer = $AnimationPlayer
