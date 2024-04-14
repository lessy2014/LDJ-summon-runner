extends CharacterBody2D

var meduse = preload("res://Scenes/meduse.tscn")
var мышмышползет = preload("res://Scenes/мышмышползет.tscn")
var rhino = preload("res://Scenes/rhino.tscn")
var мышмышужеползет = false
var rhino_spawned = false
var summons : Array
var last_summon

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var physicsEnabled = 1

var main_scene
var camera

func _ready():
	main_scene = get_parent()
	camera = $Camera2D
	camera.position = Vector2i(400, -100)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 5 * physicsEnabled

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and main_scene.speed != 0:
		velocity.y = JUMP_VELOCITY
		var meduse = meduse.instantiate()
		meduse.body_entered.connect(hit_meduse)
		meduse.position = Vector2i(200 + position.x, 440)
		main_scene.add_child(meduse)
		summons.append(meduse)
		last_summon = meduse
		await get_tree().create_timer(1).timeout
		meduse.queue_free()
		summons.erase(meduse)
		
	if Input.is_action_just_pressed("ui_left") and is_on_floor() and main_scene.speed != 0:
		velocity.y = JUMP_VELOCITY * 2
		await get_tree().create_timer(0.2).timeout
		var meduse = meduse.instantiate()
		meduse.position = Vector2i(0, -100)
		add_child(meduse)
		summons.append(meduse)
		last_summon = meduse
		physicsEnabled = 0
		velocity.y = 0
		await get_tree().create_timer(1.20).timeout
		physicsEnabled = 1
		velocity.x = 0
		meduse.queue_free()
		summons.erase(meduse)
		
	if Input.is_action_just_pressed("ui_down") and is_on_floor() and main_scene.speed != 0:
		if not мышмышужеползет:
			мышмышужеползет = true
			var мышмышползет = мышмышползет.instantiate()
			мышмышползет.position = Vector2i (50 + position.x, 440)
			мышмышползет.velocity.x = 1000
			main_scene.add_child(мышмышползет)
			summons.append(мышмышползет)
			last_summon = мышмышползет
			remove_child(camera)
			мышмышползет.add_child(camera)
			await get_tree().create_timer(1).timeout
			мышмышползет.remove_child(camera)
			add_child(camera)
			var newposition = мышмышползет.position
			position = newposition
			мышмышползет.queue_free()
			мышмышужеползет = false
			
	if Input.is_action_just_pressed("ui_right") and is_on_floor() and main_scene.speed != 0:
		if not rhino_spawned:
			rhino_spawned = true 
			var rhino = rhino.instantiate()
			rhino.position = Vector2i (50 + position.x, 440)
			rhino.velocity.x = 2000
			main_scene.add_child(rhino)
			summons.append(rhino)
			last_summon = rhino
			await get_tree().create_timer(1).timeout
			rhino.queue_free()
			rhino_spawned = false
			
	if Input.is_action_just_pressed("ui_accept") and main_scene.speed == 0:
		main_scene.new_game()
			
			
	move_and_slide()
		
func hit_meduse(body):
	if body.name == "Chechik":
		velocity.y = JUMP_VELOCITY * 3
		

	
