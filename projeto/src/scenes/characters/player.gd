extends CharacterBody3D

const FRICTION : float = 0.5
const ACCELERATION : float = 0.25

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam : Camera3D = $Cam

@export var default_walk_speed : int = 5
@export var default_sprint_speed : int = 8
@export var default_sneak_speed : int = 3

var current_speed : int = 0
var sprinting : bool = false
var sneaking : bool = false

func _ready() -> void:
	current_speed = default_walk_speed
	pass

func _input(event : InputEvent) -> void:
	# Rotação do jogador e da camera
	if is_instance_of(event, InputEventMouseMotion) and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Globals.mouse_sensitivity)
		cam.rotate_x(-event.relative.y * Globals.mouse_sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(90), deg_to_rad(90))
	pass

func _physics_process(delta : float) -> void:
	# Aplica a gravidade caso não esteja no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
	move(Input.get_vector("move_left", "move_right", "move_forward", "move_backward"))
	pass

# Função que implementa movimentação 3d
func move(axis : Vector2) -> void:
	var direction : Vector3 = (transform.basis * Vector3(axis.x, 0, axis.y)).normalized()
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()
	pass
