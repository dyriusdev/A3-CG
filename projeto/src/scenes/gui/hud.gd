extends CanvasLayer

@onready var pages : Label = $Pages

func _ready() -> void:
	Globals.collected_keys.connect(_on_collected)
	pass

func _on_collected() -> void:
	Globals.keys += 1
	if Globals.to_collect <= 0:
		return
	
	pages.text = "Collected : %s/%s" % [Globals.keys, Globals.to_collect]
	pass
