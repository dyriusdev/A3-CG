extends CanvasLayer

@onready var pages : Label = $Pages
@onready var stamina : ProgressBar = $Stamina
@onready var seeing_timer : Timer = $SeeingTimer
@onready var vhs : ColorRect = $Vhs
@onready var suspense : AudioStreamPlayer = $Suspense
@onready var battery : TextureProgressBar = $Battery
@onready var over : ColorRect = $Over
@onready var end : ColorRect = $End

@export_node_path("CharacterBody3D") var player_path : NodePath = ""

var player = null
var current_battery : float = 100
var samples : int = 4
var intensity : float = 0.1

func _ready() -> void:
	player = get_node(player_path)
	
	Globals.collected_keys.connect(_on_collected)
	Globals.seeing_monster.connect(_on_see)
	
	stamina.max_value = player.max_stamina
	stamina.value = player.current_stamina
	
	Globals.game_over.connect(_on_gameover)
	pass

func _process(_delta : float) -> void:
	pages.text = "Coletado : %s/%s" % [Globals.keys, Globals.to_collect]
	
	stamina.value = player.current_stamina
	
	if player.flashlight and current_battery > 0:
		current_battery -= 0.25
	elif player.flashlight and current_battery <= 0:
		player.flashlight = false
		player.set_flashlight()
	elif not player.flashlight and current_battery < 100:
		current_battery += 1
	
	battery.value = current_battery
	pass

func _on_gameover() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	suspense.stop()
	over.show()
	pass

func _on_see(flag : bool) -> void:
	vhs.visible = flag
	if flag:
		seeing_timer.start(0.75)
	else:
		seeing_timer.stop()
	pass

func _on_seein_timeout() -> void:
	vhs.visible = true
	
	if samples < 24:
		samples += 8
		intensity += 0.2
	else:
		_on_gameover()
	
	vhs.set_instance_shader_parameter("samples", samples)
	vhs.set_instance_shader_parameter("filter_intensity", intensity)
	seeing_timer.start(0.75)
	pass

func _on_collected() -> void:
	Globals.keys += 1
	Globals.to_collect -= 1
	
	if Globals.keys < 2:
		suspense.stream = preload("res://assets/sounds/silence_02.ogg")
		suspense.play()
	else:
		suspense.stream = preload("res://assets/sounds/silence_03.ogg")
		suspense.play()
	
	if Globals.to_collect == 0:
		suspense.stop()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		end.show()
	pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/start.tscn")
	pass
