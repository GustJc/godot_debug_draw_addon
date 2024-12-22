extends Node

@onready var draw_debug: MeshInstance3D = %DrawDebugMesh
@onready var draw_debug_strip: MeshInstance3D = %DrawDebugStrip
@export var use_debug_draw: bool = true
@export var auto_clear_lines: bool = true

var started_line_drawing := false
var started_strip_drawing := false


func _process(delta: float) -> void:
	if started_line_drawing:
		draw_debug.mesh.surface_end()
		started_line_drawing = false
	if started_strip_drawing:
		draw_debug_strip.mesh.surface_end()
		started_strip_drawing = false

	await get_tree().physics_frame
	if auto_clear_lines:
		_clear_all_lines()


func set_line_relative(pointA : Vector3, pointB : Vector3, color: Color = Color.RED, duration: float = 1.0):
	%LineSimpleMM.set_line_relative(pointA, pointB, color, duration)

func set_line_thick_relative(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, duration: float = 1.0):
	%LineMM.set_line_relative(pointA, pointB, thickness, color, duration)

func draw_sphere_mm(pos: Vector3, radius: float, color: Color = Color(Color.RED, 0.85), duration: float = 0.1) -> void:
	%SphereMM.set_sphere(pos, radius, color, duration)


#region Draw lines
func draw_line(pointA : Vector3, pointB : Vector3, color: Color = Color.BLACK):
	if not use_debug_draw or pointA.is_equal_approx(pointB):
		return

	if draw_debug.mesh is ImmediateMesh:
		_start_line_drawing()
		draw_debug.mesh.surface_set_color(color)
		draw_debug.mesh.surface_add_vertex(pointA)
		draw_debug.mesh.surface_add_vertex(pointB)


func draw_line_relative(pointA : Vector3, pointB : Vector3, color: Color = Color.PURPLE):
	draw_line(pointA, pointA+pointB, color)


## Based on Raycast3D debug shape https://github.com/godotengine/godot/blob/44e399ed5fa895f760b2995e59788bdb49782666/scene/3d/ray_cast_3d.cpp#L397C2-L408C3
func draw_line_relative_thick(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK):
	pointB = pointA+pointB

	if not use_debug_draw or pointA.is_equal_approx(pointB):
		return
	if draw_debug_strip.mesh is ImmediateMesh:
		_start_strip_drawing()
		draw_debug_strip.mesh.surface_set_color(color)
#
		var scale_factor := 100.0

		var dir := pointA.direction_to(pointB)
		var EPISILON = 0.00001

		# Draw cube line
		var normal := Vector3(-dir.y, dir.x, 0).normalized() \
			if (abs(dir.x) + abs(dir.y) > EPISILON) \
			else Vector3(0, -dir.z, dir.y).normalized()
		normal *= thickness / scale_factor

		var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
		var localB = (pointB-pointA)
		# Calculates line mesh at origin
		for v in range(14):
			var vertex = normal if \
				vertices_strip_order[v] < 4 else \
				normal + localB
			var final_vert = vertex.rotated(dir,
				PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
			# Offset to real position
			final_vert += pointA
			draw_debug_strip.mesh.surface_add_vertex(final_vert)


func draw_line_relative_thickpointy(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK):
	pointB = pointA+pointB

	if not use_debug_draw or pointA.is_equal_approx(pointB):
		#print("Same start/end line")
		return
	if draw_debug_strip.mesh is ImmediateMesh:
		_start_strip_drawing()
		draw_debug_strip.mesh.surface_set_color(color)
#
		var scale_factor := 100.0

		var dir := pointA.direction_to(pointB)
		var EPISILON = 0.00001

		# Draw cube line
		var normal := Vector3(-dir.y, dir.x, 0).normalized() \
			if (abs(dir.x) + abs(dir.y) > EPISILON) \
			else Vector3(0, -dir.z, dir.y).normalized()
		normal *= thickness / scale_factor

		var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
		var localB = (pointB-pointA)
		# Calculates line mesh at origin
		for v in range(14):
			var vertex = normal if \
				vertices_strip_order[v] < 4 else \
				normal /3.0 + localB
			var final_vert = vertex.rotated(dir,
				PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
			# Offset to real position
			final_vert += pointA
			draw_debug_strip.mesh.surface_add_vertex(final_vert)
#endregion draw lines


func _start_line_drawing() -> void:
	if not started_line_drawing:
		draw_debug.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		started_line_drawing = true


func _start_strip_drawing() -> void:
	if not started_strip_drawing:
		draw_debug_strip.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		started_strip_drawing = true


func _clear_all_lines():
	if draw_debug.mesh is ImmediateMesh:
		draw_debug.mesh.clear_surfaces()
