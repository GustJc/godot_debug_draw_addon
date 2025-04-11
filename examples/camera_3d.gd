extends Camera3D
## Needs to have inputs for
## move_forward, move_backward, move_up, move_down
## move_left, move_right, move_speed,
## toggle_mouse_capture, toggle_mouse_capture

const MOUSE_SENSITIVITY = 0.002

# The camera movement speed (tweakable using the mouse wheel).
@export var move_speed := 1.0

# Stores where the camera is wanting to go (based on pressed keys and speed modifier).
var motion := Vector3()

# Stores the effective camera velocity.
var velocity := Vector3()

@export var is_active := true
@export var start_enabled := false

func _ready() -> void:
	if start_enabled:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:

	if event is InputEventKey:
		if event.keycode == KEY_QUOTELEFT and event.pressed:
			is_active = not is_active
	if not is_active: return

	# Toggle mouse capture (only while the menu is not visible).
	if event is InputEventKey:
		if event.keycode == KEY_TAB and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	# Mouse look (effective only if the mouse is captured).
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees.
		rotation.x = clamp(rotation.x - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-90), deg_to_rad(90))



	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	#if event.is_action_pressed("time_scale_1"):
		#Engine.time_scale = 1
	#elif event.is_action_pressed("time_scale_0.5"):
		#Engine.time_scale = 0.5
	#elif event.is_action_pressed("time_scale_0.2"):
		#Engine.time_scale = 0.2
#
	#if event.is_action_pressed("movement_speed_increase"):
		#move_speed = min(1.5, move_speed + 0.1)
#
	#if event.is_action_pressed("movement_speed_decrease"):
		#move_speed = max(0.1, move_speed - 0.1)


func _process(delta: float) -> void:
	if not is_active: return

	if Input.is_key_pressed(KEY_W):
		motion.z = -1
	elif Input.is_key_pressed(KEY_S):
		motion.z = 1
	else:
		motion.z = 0

	if Input.is_key_pressed(KEY_A):
		motion.x = -1
	elif Input.is_key_pressed(KEY_D):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_key_pressed(KEY_E):
		motion.y = 1
	elif Input.is_key_pressed(KEY_Q):
		motion.y = -1
	else:
		motion.y = 0

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement).
	motion = motion.normalized()

	# Speed modifier.
	if Input.is_key_pressed(KEY_SHIFT):
		motion *= 2

	# Rotate the motion based on the camera angle.
	motion = motion \
		.rotated(Vector3(0, 1, 0), rotation.y) \
		.rotated(Vector3(1, 0, 0), cos(rotation.y) * rotation.x) \
		.rotated(Vector3(0, 0, 1), -sin(rotation.y) * rotation.x)

	# Add motion, apply friction and velocity.
	velocity += motion * move_speed
	velocity *= 0.9
	var unscaled_delta = delta if (Engine.time_scale == 0) else (delta / Engine.time_scale);
	position += velocity * unscaled_delta
