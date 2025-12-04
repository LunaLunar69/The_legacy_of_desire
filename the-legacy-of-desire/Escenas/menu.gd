extends Control



func _on_np_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/openworld.tscn")




func _on_cp_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/map1.tscn")




func _on_exit_btn_pressed() -> void:
	get_tree().quit() #salir

#lol
