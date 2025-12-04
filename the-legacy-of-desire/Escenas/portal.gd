extends Area2D

const SCENE_TO_LOAD := "res://Escenas/map1.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		print("Cambiando a escena: ", SCENE_TO_LOAD)
		get_tree().change_scene_to_file(SCENE_TO_LOAD)
