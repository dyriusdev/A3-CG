extends CharacterBody3D

const FRICTION : float = 0.5
const ACCELERATION : float = 0.25

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam : Camera3D = $Cam
@onready var steps : AudioStreamPlayer3D = $Steps
@onready var light : SpotLight3D = $Cam/Flashlight/Light
@onready var flashlight_sfx : AudioStreamPlayer3D = $Cam/Flashlight/Sfx

@export var default_walk_speed : int = 5
@export var default_sprint_speed : int = 8
@export var default_sneak_speed : int = 3

var current_speed : int = 0
var sprinting : bool = false
var sneaking : bool = false

var flashlight : bool = false

func _ready() -> void:
	current_speed = default_walk_speed
	pass

func _input(event : InputEvent) -> void:
	# Para remover no final
	if Input.is_key_pressed(KEY_ESCAPE):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Rotação do jogador e da camera
	if is_instance_of(event, InputEventMouseMotion) and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Globals.mouse_sensitivity)
		cam.rotate_x(-event.relative.y * Globals.mouse_sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(90), deg_to_rad(90))
	
	# Controle da lanterna
	if event.is_action_pressed("act_flashlight"):
		flashlight = !flashlight
		light.visible = flashlight
		flashlight_sfx.play()
	
	# Controle de corrida
	if Input.is_action_just_pressed("move_sprint") and not sprinting:
		sprinting = true
		current_speed = default_sprint_speed
	elif Input.is_action_just_released("move_sprint") and sprinting:
		sprinting = false
		current_speed = default_walk_speed
	
	# Controle de esgueirar
	if Input.is_action_just_pressed("move_sneak") and not sneaking:
		sneaking = true
		current_speed = default_sneak_speed
	elif Input.is_action_just_released("move_sneak") and sneaking:
		sneaking = false
		current_speed = default_sneak_speed
	pass

func _physics_process(delta : float) -> void:
	# Aplica a gravidade caso não esteja no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var axis : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move(axis)
	
	# Controle do som de passos
	if axis.length() > 0 and not steps.playing:
		steps.play()
	elif axis.length() == 0 and steps.playing:
		steps.stop()
	pass

# Função que implementa movimentação 3d
func move(axis : Vector2) -> void:
	var direction : Vector3 = (transform.basis * Vector3(axis.x, 0, axis.y)).normalized()
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()
	pass
