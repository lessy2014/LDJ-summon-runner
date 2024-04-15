extends Node


var jump_wall = preload("res://Scenes/jump_wall.tscn")
var hole = preload("res://Scenes/hole.tscn")
var мышстенакродется = preload("res://Scenes/мышстенакродется.tscn")
var rhino_wall = preload("res://Scenes/rhino_wall.tscn")
var obstacle_types = [jump_wall, hole, мышстенакродется, rhino_wall]
#База
const CHECHIK_START_POS := Vector2i(142, 438)

var score : int 
var started = false
var high_score : int = 0
const Score_modifier : int = 10
var speed : float
const START_SPEED : float = 12.5
const MAX_SPEED : int = 50
var screen_size : Vector2i
var obstacles : Array
var hud
var main_text
var last_obstacle
var last_obstacle_type
var chechik
var music




# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	hud = $HUD
	main_text = hud.get_node("Space")
	screen_size = get_window().size
	preset()

func preset():
	score = 0
	chechik = $Chechik
	chechik.sprite_2d.play("running")
	music = chechik.get_node("Music")
	music.play()
	chechik.position = CHECHIK_START_POS 
	chechik.velocity = Vector2i(0,0)
	$Граунд.position = Vector2i(143,465)
	remove_all_obstacles()
	started = false
	main_text.text = "press space to boban"

func new_game():
	started = true
	speed = START_SPEED
	main_text.text = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chechik.position.x += speed
	generate_obs()
	for obs in obstacles:
		if (obs.position.x < (chechik.position.x - screen_size.x)):
			remove_obstacle(obs)
	if chechik.position.x - $"Граунд".position.x > screen_size.x:
		$"Граунд".position.x += screen_size.x
		
		# Warning Даша влезла
	score += speed 
	if (high_score <= score):
		high_score = score
	show_score()
	
	
func show_score ():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / Score_modifier)
	$HUD.get_node("Highscore").text = "HIGH SCORE: " + str(high_score / Score_modifier)
		
func generate_obs():
	if obstacles.is_empty() or last_obstacle.position.x < chechik.position.x + randi_range(-700, -500):
		var obstacle_type = obstacle_types[randi_range(0, obstacle_types.size() - 1)]
		while(last_obstacle_type == obstacle_type):
			obstacle_type = obstacle_types[randi_range(0, obstacle_types.size() - 1)]
		last_obstacle_type = obstacle_type
		var obstacle = obstacle_type.instantiate()
		if (obstacle_type == rhino_wall):
			obstacle.body_entered.connect(hit_rhino)
		elif obstacle_type == мышстенакродется:
			obstacle.body_entered.connect(хит_мыш)
		else:
			obstacle.body_entered.connect(hit_obstacle)
		obstacle.position = Vector2i(1200 + chechik.position.x, 500)
		add_child(obstacle)
		obstacles.append(obstacle)
		last_obstacle = obstacle
		
func remove_all_obstacles():
	for obs in obstacles:
		remove_obstacle(obs)
	obstacles.clear()

func remove_obstacle(obstacle):
	obstacle.queue_free()
	obstacles.erase(obstacle)
	
func hit_obstacle(body):
	if body.name == "Chechik":
		print("Collision")
		chechik.sprite_2d.play("death")
		music.stop()
		speed = 0
		main_text.text = "press space to restart"
		print("Game over kind of")
		print("Press space to restart")
		
func hit_rhino(body):
	hit_obstacle(body)
	if body.name == "Rhino":
		last_obstacle.get_node("CollisionShape2D").set_deferred("disabled", true)
		last_obstacle.get_node("Sprite2D").animation = "Destruction"
		
func хит_мыш(body):
	hit_obstacle(body)
	print(body.name)
	if body.name == "мышмышползет":
		last_obstacle.get_node("CollisionShape2D").set_deferred("disabled", true)
		
