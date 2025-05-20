extends CanvasLayer

@onready var members: ColorRect = $Menu/Members

func _on_new_pressed() -> void:
	pass

func _on_members_pressed() -> void:
	members.show()
	pass

func _on_back_pressed() -> void:
	members.hide()
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass
