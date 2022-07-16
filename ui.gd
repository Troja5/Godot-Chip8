extends Control

onready var file_dialog = $FileDialog
onready var button = $Button

onready var chip8 = preload("res://chip8.tscn")

func _on_btn_open_pressed():
	file_dialog.popup()

func _on_FileDialog_file_selected(path):
	var instance = chip8.instance()
	add_child(instance)
	instance.initialise(path)
 
