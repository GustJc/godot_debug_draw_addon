extends CanvasLayer

@onready var debug_marker: Marker3D = %DebugMarker


func _on_line_pressed() -> void:
	debug_marker.test_line()


func _on_thick_line_pressed() -> void:

	debug_marker.test_line_thick()


func _on_sphere_pressed() -> void:
	debug_marker.test_sphere()


func _on_hit_ray_pressed() -> void:
	debug_marker.test_hits()


func _on_arrow_pressed() -> void:
	debug_marker.test_draw_arrow()


func _on_process_pressed() -> void:
	debug_marker.test_process = not debug_marker.test_process


func _on_physics_pressed() -> void:
	debug_marker.test_physics_process = not debug_marker.test_physics_process


func _on_debug_pressed() -> void:
	DebugDraw.print_debug_info()
