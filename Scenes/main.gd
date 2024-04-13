extends Node


var jump_wall = preload("res://Scenes/jump_wall.tscn")
var hole = preload("res://Scenes/hole.tscn")
var obstacle_types = [jump_wall, hole]
#База
const CHECHIK_START_POS := Vector2i(142, 438)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 5.0
const MAX_SPEED : int = 25
var screen_size : Vector2i
var obstacles : Array
var last_obstacle



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Chechik.position = CHECHIK_START_POS 
	$Chechik.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Граунд.position = Vector2i(143,465)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	
	$Chechik.position.x += speed
	$Camera2D.position.x += speed
	generate_obs()
	for obs in obstacles:
		if (obs.position.x < ($Camera2D.position.x - screen_size.x)):
			remove_obstacle(obs)
	if $Camera2D.position.x - $"Граунд".position.x > screen_size.x * 1.5:
		$"Граунд".position.x += screen_size.x
		
func generate_obs():
	if obstacles.is_empty() or last_obstacle.position.x < $Chechik.position.x + randi_range(-700, -500):
		var obstacle_type = obstacle_types[randi_range(0, obstacle_types.size() - 1)]
		var obstacle = obstacle_type.instantiate()
		obstacle.body_entered.connect(hit_obstacle)
		obstacle.position = Vector2i(1200 + $Chechik.position.x, 500)
		add_child(obstacle)
		obstacles.append(obstacle)
		last_obstacle = obstacle
		
func remove_obstacle(obstacle):
	obstacle.queue_free()
	obstacles.erase(obstacle)
	
func hit_obstacle(body):
	if body.name == "Chechik":
		print("Collision")
