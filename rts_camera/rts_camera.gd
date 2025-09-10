extends Node3D
## enums
## consts
## exports
## public vars
## private vars
var move_speed = 0.3
var move_target: Vector3

var rotation_keys_speed = 1.5
var rotation_keys_target: float

var zoom_speed = 3.0
var zoom_target: float
var min_zoom = 10.0
var max_zoom = 100.0

var mouse_sensitivity = 0.2

var edge_size = 10
var scroll_speed = 0.3

## onready vars
@onready var camera_position: Node3D = $"."
@onready var camera_rotation_x: Node3D = $CameraRotationX
@onready var camera_zoom_pivot: Node3D = $CameraRotationX/CameraZoomPivot
@onready var camera_3d: Camera3D = $CameraRotationX/CameraZoomPivot/Camera3D
## built-in override methods

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Position
	move_target = position
	# Rotation
	rotation_keys_target = rotation_degrees.y
	# Zoom 
	zoom_target = camera_3d.position.z
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Position 
	var input_direction = Input.get_vector("input_action_left","input_action_right","input_action_up","input_action_down")
	var movement_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	move_target += move_speed * movement_direction
	position = lerp(position, move_target, 0.05)
	
	# Middle mouse rotiation
	# see func _unhandled_input()
	if Input.is_action_just_pressed("rotate"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("rotate"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# Rotation
	var rotation_keys = Input.get_axis("input_action_bracket_left", "input_action_bracket_right")
	rotation_keys_target += rotation_keys * rotation_keys_speed
	rotation_degrees.y = lerp(rotation_degrees.y, rotation_keys_target, 0.05)
	
	# Zoom
	var zoom_direction = (int(Input.is_action_just_released("input_action_scroll_down")) - 
					int(Input.is_action_just_released("input_action_scroll_up")))
	zoom_target += zoom_direction * zoom_speed
	camera_3d.position.z = lerp(camera_3d.position.z, zoom_target, 0.05)
	

	
	# Edge panning
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	
	var scroll_direction = Vector3.ZERO
	if mouse_pos.x < edge_size:
		scroll_direction.x = -0.5
	elif mouse_pos.x > viewport_size.x - edge_size:
		scroll_direction.x = 0.5
		
	if mouse_pos.y < edge_size:
		scroll_direction.z = -0.5
	elif mouse_pos.y > viewport_size.y - edge_size:
		scroll_direction.z = 0.5
		
	move_target += transform.basis * scroll_direction * scroll_speed
		
	pass

## private methods
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate"):
		rotation_keys_target -= event.relative.x * mouse_sensitivity
		camera_rotation_x.rotation_degrees.x -= event.relative.x * mouse_sensitivity
		camera_rotation_x.rotation_degrees.x = clamp(camera_rotation_x.rotation_degrees.x, -10, 30)
		
## public methods
