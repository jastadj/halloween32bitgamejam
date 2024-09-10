class_name Player
extends CharacterBody3D

var speed: float = 10 # m/s
var jump_height: float = 1.0 # m
var camera_sens: float = 1.0
var acceleration: float = 100 # m/s^2
var interact_distance: float = 3.0

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var inventory:Control = $CanvasLayerUI/inventory

func _ready() -> void:
	capture_mouse()
	ray.target_position = Vector3(0,0,-interact_distance)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	elif Input.is_action_just_pressed("quit"):
		if inventory.visible:
			capture_mouse()
			inventory.hide()
		else:
			get_tree().quit()
	elif Input.is_action_just_released("open_inventory"):
		if !inventory.visible:
			release_mouse()
			inventory.show()
		else:
			capture_mouse()
			inventory.hide()
	elif Input.is_action_just_pressed("jump"): jumping = true
	elif Input.is_action_just_pressed("toggle_flashlight"):
		$Camera3D/flashlight.visible = !$Camera3D/flashlight.visible
	elif Input.is_action_just_pressed("activate"):
		if ray.looking_at != null:
			var obj = ray.looking_at
			var interact_node:ComponentInteract = obj.get_node_or_null("can_interact")
			if interact_node != null:
				if interact_node.interaction_type == ComponentInteract.INTERACTION_TYPE.PICKUP:
					pickup(obj)

func _physics_process(delta: float) -> void:
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func pickup(obj:RigidBody3D) -> bool:
	
	if obj == null:
		return false
	
	var colliding_bodies = obj.get_colliding_bodies()
	
	if !inventory.add_object(obj):
		return false
	
	print("You picked up ", obj.get_node("object_info").object_name, ".")
	
	# wake up any bodies that were touching this object
	for colliding_body in colliding_bodies:
		if colliding_body is RigidBody3D:
			colliding_body.sleeping = false
	
	return true
