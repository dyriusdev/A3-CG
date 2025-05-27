extends CanvasLayer

@onready var pages : Label = $Pages
@onready var stamina : ProgressBar = $Stamina
@onready var seeing_timer : Timer = $SeeingTimer
@onready var vhs : ColorRect = $Vhs
@onready var suspense : AudioStreamPlayer = $Suspense
@onready var battery : TextureProgressBar = $Battery
@onready var battery_timer : Timer = $BatteryTimer
@onready var over : ColorRect = $Over
@onready var end : ColorRect = $End

@export_node_path("CharacterBody3D") var player_path : NodePath = ""

var player = null

var current_battery : int = 100
var tolerance : int = 1

func _ready() -> void:
	player = get_node(player_path)
	
	Globals.collected_keys.connect(_on_collected)
	Globals.seeing_monster.connect(_on_see)
	
	stamina.max_value = player.max_stamina
	stamina.value = player.current_stamina
	
	seeing_timer.timeout.connect(_on_seein_timeout)
	battery_timer.timeout.connect(_on_battery_timeout)
	Globals.game_over.connect(_on_gameover)
	pass

func _process(_delta : float) -> void:
	stamina.value = player.current_stamina
	
	if current_battery <= 0:
		player.flashlight = false
		player.set_flashlight()
	pass

func _on_gameover() -> void:
	over.show()
	pass

func _on_battery_timeout():
	if player.flashlight:
		current_battery -= 0.01
	else:
		current_battery += 1
	
	battery.value = current_battery
	battery_timer.start()
	pass

func _on_see(flag : bool) -> void:
	vhs.visible = flag
	if flag:
		seeing_timer.start(0.5)
	else:
		seeing_timer.stop()
	pass

func _on_seein_timeout() -> void:
	vhs.visible = true
	
	if tolerance < 24:
		tolerance += 8
	
	vhs.set_instance_shader_parameter("samples", tolerance)
	seeing_timer.start(0.5)
	pass

func _on_collected() -> void:
	Globals.keys += 1
	Globals.to_collect -= 1
	
	if Globals.keys < Globals.to_collect / 2.0:
		suspense.stream = preload("res://assets/sounds/silence_02.ogg")
		suspense.play()
	else:
		suspense.stream = preload("res://assets/sounds/silence_03.ogg")
		suspense.play()
	
	if Globals.to_collect == 0:
		suspense.stop()
		end.show()
	
	pages.text = "Collected : %s/%s" % [Globals.keys, Globals.to_collect]
	pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/start.tscn")
	pass
