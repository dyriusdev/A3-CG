extends CharacterBody3D

signal enemy_died

const ACCELERATION : float = 0.25

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var life_time : Timer = $LifeTime
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent
@onready var animation_player : AnimationPlayer = $slendermanFINAL/AnimationPlayer
@onready var slenderman_final : Node3D = $slendermanFINAL

@export var speed : int = 3

var player : CharacterBody3D = null

func _ready() -> void:
	life_time.start(randf_range(20, 50))
	pass

func _physics_process(delta : float) -> void:
	# Aplica a gravidade caso não esteja no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var direction : Vector3 = Vector3.ZERO
	if player:
		
		navigation_agent.target_position = player.global_position
		direction = (navigation_agent.get_next_path_position() - global_position).normalized()
		look_at(player.global_position)
		velocity = velocity.lerp(direction * speed, ACCELERATION * delta)
		move_and_slide()
	
	if direction.length() > 0:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
	pass

# Após o tempo de vida acabar a entidade precisa ser removida
func _on_life_time_timeout() -> void:
	enemy_died.emit()
	Globals.seeing_monster.emit(false)
	call_deferred("queue_free")
	pass

func _on_visible_on_screen_screen_exited() -> void:
	Globals.seeing_monster.emit(false)
	pass
