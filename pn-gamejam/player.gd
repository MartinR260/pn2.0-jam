extends CharacterBody3D

@onready var camera = $Camera3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 9

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Handle jump. (default)
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	
	
	# Movement. (default)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	#Simple collision and pushing of rigidbodies by player
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			#var push_dir = -c.get_normal()
			#c.get_collider().apply_impulse(push_dir * 5, c.get_position() - c.get_collider().global_position)
		
	move_and_slide()



func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))
