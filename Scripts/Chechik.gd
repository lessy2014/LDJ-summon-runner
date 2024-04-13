extends CharacterBody2D

var meduse = preload("res://Scenes/meduse.tscn")
var summons : Array
var last_summon

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var main_scene

func _ready():
	main_scene = get_parent()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 5

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		var meduse = meduse.instantiate()
		meduse.body_entered.connect(hit_meduse)
		meduse.position = Vector2i(200 + position.x, 440)
		main_scene.add_child(meduse)
		summons.append(meduse)
		last_summon = meduse
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
		
func hit_meduse(body):
	if body.name == "Chechik":
		velocity.y = JUMP_VELOCITY * 3
		

	
