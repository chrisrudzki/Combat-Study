extends Sprite2D




var sprite_sheet_1:	Texture2D
var sprite_sheet_2:	Texture2D

func ready():
	sprite_sheet_1 = preload("res://Art/Sprout Lands - Sprites - Basic pack/Characters/Basic Charakter Actions.png")
	sprite_sheet_2 = preload("res://Art/Sprout Lands - Sprites - Basic pack/Characters/Basic Charakter Spritesheet.png")
	
	
func play(animation_name):
	#if animation_name == "attack"
		##play attack
		#
	#elif animation_name == "idle"
	#
	#elif animation_name == "walk"
