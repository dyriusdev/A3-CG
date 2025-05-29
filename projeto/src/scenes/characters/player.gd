extends CharacterBody3D

const FRICTION : float = 0.5
const ACCELERATION : float = 0.25

@onready var sfx_silence1 : AudioStreamOggVorbis = preload("res://assets/sounds/silence_01.ogg")
@onready var sfx_silence2 : AudioStreamOggVorbis = preload("res://assets/sounds/silence_02.ogg")
@onready var sfx_silence3 : AudioStreamOggVorbis = preload("res://assets/sounds/silence_03.ogg")

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam : Camera3D = $Cam
@onready var steps : AudioStreamPlayer3D = $Steps
@onready var light : SpotLight3D = $Cam/Flashlight/Light
@onready var flashlight_sfx : AudioStreamPlayer3D = $Cam/Flashlight/Sfx
@onready var ray : RayCast3D = $Cam/RayCast3D
@onready var animation_player: AnimationPlayer = $jaymerrickRIGGING_BACKUP/AnimationPlayer

@export var default_walk_speed : float = 3
@export var default_sprint_speed : float = 6
@export var default_sneak_speed : float = 1
@export var max_stamina : float = 100

var current_stamina : float = 0
var current_speed : float = 0
var sprinting : bool = false
var sneaking : bool = false

var flashlight : bool = false

func _ready() -> void:
	current_speed = default_walk_speed
	current_stamina = max_stamina
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event : InputEvent) -> void:
	# Rotação do jogador e da camera
	if is_instance_of(event, InputEventMouseMotion) and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Globals.mouse_sensitivity)
		cam.rotate_x(-event.relative.y * Globals.mouse_sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(90), deg_to_rad(90))
	
	# Controle da lanterna
	if event.is_action_pressed("act_flashlight"):
		flashlight = !flashlight
		set_flashlight()
	
	# Controle de corrida
	if Input.is_action_just_pressed("move_sprint") and not sprinting:
		sprinting = true
		current_speed = default_sprint_speed
		steps.pitch_scale = 1.5
	elif Input.is_action_just_released("move_sprint") and sprinting:
		sprinting = false
		current_speed = default_walk_speed
		steps.pitch_scale = 1
	
	# Controle de esgueirar
	if Input.is_action_just_pressed("move_sneak") and not sneaking:
		sneaking = true
		current_speed = default_sneak_speed
		steps.pitch_scale = 0.75
	elif Input.is_action_just_released("move_sneak") and sneaking:
		sneaking = false
		current_speed = default_sneak_speed
		steps.pitch_scale = 1
	
	# Interação para pegar chave
	if event.is_action_pressed("act_interact") and event.is_pressed() and ray.is_colliding():
		var collider = ray.get_collider()
		if is_instance_valid(collider) and collider.is_in_group("chave"):
				Globals.collected_keys.emit()
				collider.call_deferred("queue_free")
	pass

func _process(_delta : float) -> void:
	if current_stamina > 0 and sprinting:
		current_stamina -= 0.25
	elif current_stamina < max_stamina and not sprinting:
		current_stamina += 0.25
	
	if current_stamina <= 0:
		sprinting = false
		current_speed = default_sneak_speed
		steps.pitch_scale = 1
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if is_instance_valid(collider) and collider.is_in_group("monstro"):
				Globals.seeing_monster.emit(true)
	pass

func _physics_process(delta : float) -> void:
	# Aplica a gravidade caso não esteja no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y <= -5:
			get_tree().reload_current_scene()
	
	var axis : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move(axis)
	
	# Controle de animações
	if axis.length() > 0:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
	
	# Controle do som de passos
	if axis.length() > 0 and not steps.playing:
		steps.play()
	elif axis.length() == 0 and steps.playing:
		steps.stop()
	
	Globals.apply_objects_impulse(self)
	pass

func set_flashlight() -> void:
	light.visible = flashlight
	flashlight_sfx.play()
	pass

# Função que implementa movimentação 3d
func move(axis : Vector2) -> void:
	var direction : Vector3 = (transform.basis * Vector3(axis.x, 0, axis.y)).normalized()
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()
	pass
