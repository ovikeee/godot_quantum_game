extends Node

export (PackedScene) var ParticleScene
export (PackedScene) var GameOverScene

var reality_radius = 700
var spawn_radius = reality_radius - 10
var particles: Array
var particleCount = 0
var maxParticleCount = 50
var fps
var message
var isGameOver = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps = Performance.get_monitor(Performance.TIME_FPS)
	message = "fps: " + String(fps) + "\n"
	message += "objects: " + String(get_children().size()) + "\n"
	$HUD.display_main_debug(message)
	$HUD.display_player_debug(String($Player.debug_log))
	for child in get_children():
		if (child.is_class("Particle")):
			if ($Player.position.distance_to(child.position) > reality_radius):
				remove_child(child)
				particleCount -= 1
	if ($Player.electron_count == $Player.electron_count_max && !isGameOver):
		end('WIN')
	if (Input.is_action_pressed('ui_accept') && !isGameOver):
		end('O')

func _on_SpawnTimer_timeout():
	if particleCount > maxParticleCount: return
	var particle = ParticleScene.instance()
	var particleAngle = rand_range(0, 2*PI)
	var particleDirection = rand_range(0, 2*PI)
	var speed = rand_range(0, particle.max_speed)
	particle.position = $Player.position + Vector2(spawn_radius,0).rotated(particleAngle)
	particle.velocity = Vector2(speed, 0).rotated(particleDirection)
	particles.append(particle)
	add_child(particle)
	particleCount += 1

func end(text):
	isGameOver = true
	var gameOver = GameOverScene.instance()
	gameOver.rect_position = $Player.position
	gameOver.text = text
	add_child(gameOver)
	for i in range(50):
		var particle = ParticleScene.instance()
		particle.position = $Player.position
		if (i < 30):
			particle.energy = randi() % 3 + 1
		else:
			particle.energy = 0
		var angle = rand_range(0, 2*PI)
		particle.velocity = Vector2(rand_range(0, particle.max_speed), 0).rotated(angle)
		add_child(particle)
	$Player.disabled = true
	$Player.hide()

func emit(energy):
	var particle = ParticleScene.instance()
	particle.position = $Player.position
	var angle = $Player.emit_angle
	particle.velocity = $Player.velocity + Vector2(particle.max_speed, 0).rotated(angle)
	particle.energy = energy
	particle.from_player = true
	particleCount += 1
	add_child(particle)

func _on_Player_emit_particle():
	emit(1)

func _on_Player_emit_green():
	emit(2)

func _on_Player_emit_electron():
	emit(0)
