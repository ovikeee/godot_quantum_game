extends Area2D

signal emit_particle
signal emit_green
signal emit_electron

var emit_impulse = 65
var emit_impulse_green = 180
var emit_impulse_electron_blue = 400
var emit_impulse_electron_green = 200
var emit_angle
var max_speed = 300
var mass = 10
var velocity: Vector2
var cooldown = false
var disabled = false

var particle_count = 1
var electron_count = 4
var electron_count_max = 8

var debug_log: String = ""

func is_class(type): return type == "Player" or .is_class(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (disabled): return
	$Sprite.rotate(0.2*delta)
	velocity = velocity.clamped(max_speed)
	position += velocity*delta
	#debug_log = ""
	#debug_log += "velocity: " + String(velocity.length()) + "\n"
	#debug_log += "electrons: " + String(electron_count) + "/" + String(electron_count_max) + "\n"
	#debug_log += "agitated: " + String(particle_count) + "\n"
	$Text.text = String(electron_count) + "/" + String(electron_count_max) + " (" + String(particle_count) + ")\n"

func _input(event):
	if event.is_action_pressed('click_left'):
		if (disabled): return
		if (cooldown): return
		var target = position - get_global_mouse_position()
		velocity += target.normalized()*emit_impulse
		emit_angle = (-target).angle()
		emit_signal("emit_particle")
		#$CooldownTimer.start()
		#cooldown = true
	if event.is_action_pressed('click_right'):
		if (disabled): return
		if (particle_count <= 0): return
		particle_count -= 1
		var target = position - get_global_mouse_position()
		velocity += target.normalized()*emit_impulse_green
		emit_angle = (-target).angle()
		emit_signal("emit_green")

func _on_Player_area_entered(area):
	if (disabled): return
	if (area.is_class("Particle") && !area.from_player):
		var is_absorbed = true
		if (area.energy == 0):
			if (electron_count < electron_count_max):
				electron_count += 1
			else:
				is_absorbed = false
		elif (area.energy == 1):
			if (particle_count < electron_count):
				particle_count += 1
		elif (area.energy == 2):
			if (particle_count > 0):
				particle_count -= 1
				electron_count -= 1
				emit_angle = rand_range(0, 2*PI)
				velocity += Vector2(0,1).rotated(-emit_angle)*emit_impulse_electron_green
				emit_signal("emit_electron")
			elif (electron_count > 0):
				particle_count += 1
		elif (area.energy == 3):
			if (electron_count > 0):
				electron_count -= 1
				if (particle_count > 0): particle_count -= 1
				emit_angle = rand_range(0, 2*PI)
				velocity += Vector2(0,1).rotated(-emit_angle)*emit_impulse_electron_blue
				emit_signal("emit_electron")
		if (is_absorbed):
			area.absorb()
			velocity += (area.velocity * area.mass) / mass
		else:
			var normal = (area.position - position).normalized()
			area.velocity = area.velocity.bounce(normal)
			velocity += 2 * (area.velocity * area.mass) / mass

func _on_CooldownTimer_timeout():
	cooldown = false
