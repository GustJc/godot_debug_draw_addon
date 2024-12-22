@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("DebugDraw", "res://addons/debugdraw/autoload/DebugDraw.tscn")
	pass


func _exit_tree() -> void:
	remove_autoload_singleton("DebugDraw")
	pass
