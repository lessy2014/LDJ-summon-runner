extends Node

#База
const CHECHIK_START_POS := Vector2i(142, 438)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i



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
	
	if $Camera2D.position.x - $"Граунд".position.x > screen_size.x * 1.5:
		$"Граунд".position.x += screen_size.x
