extends Area2D

var red_texture = preload("particle_red.png")
var green_texture = preload("particle_green.png")
var blue_texture = preload("particle_blue.png")

var velocity: Vector2
var max_speed = 400
var mass = 1
var energy = -1
var from_player = false

func is_class(type): return type == "Particle" or .is_class(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	if (energy < 0):
		energy = randi() % 4
	if (energy == 0):
		mass = 3
	if (energy == 1):
		$Sprite.texture = red_texture
	elif (energy == 2):
		$Sprite.texture = green_texture
	elif (energy == 3):
		$Sprite.texture = blue_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (energy > 0): velocity = velocity.normalized()*max_speed
	velocity = velocity.clamped(max_speed)
	position += velocity*delta

func absorb():
	hide()

#func _on_Particle_area_entered(area):
#	if (area.is_class("Player") && !from_player):
#		hide()
#	elif (area.is_class("Particle")):
#		pass