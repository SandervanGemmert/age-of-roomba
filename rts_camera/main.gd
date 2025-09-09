extends Node3D
## enums
## consts
## exports
## public vars
## private vars
## onready vars
@onready var camera_3d: Camera3D = $Camera3D

## built-in override methods

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_camera(camera_3d)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## public methods

## private methods
func _setup_camera(cam:Camera3D) -> void:
	cam.fov = 70
	cam.position.y = 10.0
	cam.position.z = 10.0
	cam.rotation.x = deg_to_rad(-60)
		
