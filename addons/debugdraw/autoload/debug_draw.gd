extends Node
class_name CDebugDraw
## Used to draw debug shapes
##
## An Autoload named [b]DebugDraw[/b] is loaded with the plugin.
## There are two types of debug draw methods.
## [br][br]
## Functions starting with 'q' are quick draws. eg: [method qdraw_line_relative].[br]
## These are draw with an ImmediateMesh and need to be called every frame.[br]
## You can disable [member auto_clear_shapes] to not clear drawn shapes. And manually clear them with [method qclear_all_shapes]
## [br][br]
## The second method uses an MultiMesh to draw shapes. eg: [method draw_ray].[br]
## These are drawn using a [code]duration[/code] and don't need to be called every frame.

@onready var _draw_debug_line: MeshInstance3D = %DrawDebugLine
@onready var _draw_debug_tri: MeshInstance3D = %DrawDebugTriangle
@onready var sphere_mm: MultiMeshInstance3D = %SphereMM
@onready var line_thick_mm: MultiMeshInstance3D = %LineThickMM
@onready var line_simple_mm: MultiMeshInstance3D = %LineSimpleMM

@onready var _PHYSICS_TIME: float = ProjectSettings.get_setting("physics/common/physics_ticks_per_second") / 3600.0
@export var use_debug_draw: bool = true    ## Draw debug shapes. Disable this to not draw anything.
@export var auto_clear_shapes: bool = true ## Auto clear quick draw shapes each frame

var _started_line_drawing := false
var _started_triangle_drawing := false
var MAX_SHAPES_PER_TYPE : int = ProjectSettings.get_setting("debug_draw_addon/max_shapes_per_type", 200)


func _process(delta: float) -> void:
	if _started_line_drawing:
		_stop_line_drawing()
	if _started_triangle_drawing:
		_stop_triangle_drawing()


func _physics_process(delta: float) -> void:
	if auto_clear_shapes:
		qclear_all_shapes()


#region MultiMesh Macro Functions
func draw_hit_ray(hit_pos: Vector3, hit_direction: Vector3, duration: float = 2.0,
			hit_radius: float = 0.05, trail_len: float = 0.5,
			hit_color: Color = Color(Color.RED, 0.8),
			trail_color: Color = Color(Color.BLUE, 0.8)) -> void:
	draw_sphere(hit_pos, hit_radius, hit_color, duration)
	draw_ray(hit_pos, -hit_direction*trail_len, trail_color, duration)


func draw_hit_ray_thick(hit_pos: Vector3, hit_direction: Vector3, duration: float = 2.0,
			hit_radius: float = 0.1, trail_len: float = 1.0, trail_thickness: float = 2.0,
			hit_color: Color = Color(Color.RED, 1.0),
			trail_color: Color = Color(Color.BLUE, 1.0) ) -> void:
	draw_sphere(hit_pos, hit_radius, hit_color, duration)
	draw_ray_thick(hit_pos, -hit_direction*trail_len, trail_thickness, trail_color, duration)


func draw_arrow_ray(start_pos: Vector3, direction: Vector3,
			thickness: float = 1.0, arrow_len: float = 0.5,
			color: Color = Color.BLUE, color_point: Color = Color.BLUE,
			duration: float = 0,
			flip_two_arrows: bool = false, draw_four_arrows: bool = false) -> void:
	draw_arrow(start_pos, start_pos + direction, thickness, arrow_len, color, color_point,
		duration, flip_two_arrows, draw_four_arrows)


func draw_arrow(start_pos: Vector3, end_pos: Vector3,
			thickness: float = 1.0, arrow_len: float = 0.5,
			color: Color = Color.BLUE, color_point: Color = Color.BLUE,
			duration: float = 0,
			flip_two_arrows: bool = false, draw_four_arrows: bool = false) -> void:
	draw_line_thick(start_pos, end_pos, thickness, color, duration)

	#arrow lines
	var direction = (end_pos - start_pos).normalized()
	var up_vector = Vector3.UP
	if abs(direction.dot(Vector3.UP)) > 0.99: # Check if direction is almost parallel to UP
		up_vector = Vector3.RIGHT
	var right_vector = direction.cross(up_vector).normalized()

	var tip_pos = end_pos
	var arrow_length = arrow_len # Adjust this value for the arrowhead length
	var arrow_width = arrow_len  # Adjust this value for the arrowhead width

	# Only draw two arrows
	if not draw_four_arrows:
		if flip_two_arrows:
			var rotation_angle = PI / 2.0
			var rotation_basis = Basis(direction, rotation_angle)
			right_vector = rotation_basis * right_vector # Using the multiplication operator for transformation

	var base_point_1 = end_pos - direction * arrow_length + right_vector * (arrow_width / 2.0)
	var base_point_2 = end_pos - direction * arrow_length - right_vector * (arrow_width / 2.0)

	draw_line_thick(tip_pos, base_point_1, thickness, color_point, duration)
	draw_line_thick(tip_pos, base_point_2, thickness, color_point, duration)

	if not draw_four_arrows:
		return

	var rotation_angle = PI / 2.0
	var rotation_basis = Basis(direction, rotation_angle)
	var rotated_right_vector = rotation_basis * right_vector # Using the multiplication operator for transformation

	base_point_1 = end_pos - direction * arrow_length + rotated_right_vector * (arrow_width / 2.0)
	base_point_2 = end_pos - direction * arrow_length - rotated_right_vector * (arrow_width / 2.0)

	draw_line_thick(tip_pos, base_point_1, thickness, color_point, duration)
	draw_line_thick(tip_pos, base_point_2, thickness, color_point, duration)

#endregion END MultiMesh Macro Functions


#region MultiMesh Functions
## Draw a line from [param pointA] with direction and length [param dir_len].
## Uses a MultiMesh for drawing.
func draw_ray(pointA : Vector3, dir_len : Vector3, color: Color = Color.RED, duration: float = 0.0):
	%LineSimpleMM.set_line_relative(pointA, dir_len, color, duration)


## Draw a line from [param pointA] to [param pointB].
## Uses a MultiMesh for drawing.
func draw_line(pointA : Vector3, pointB : Vector3, color: Color = Color.RED, duration: float = 0.0):
	%LineSimpleMM.set_line(pointA, pointB, color, duration)


## Draw a thick line from [param pointA] with direction and length [param dir_len].
## Uses a MultiMesh for drawing.
func draw_ray_thick(pointA : Vector3, dir_len : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, duration: float = 0.0):
	%LineThickMM.set_line_relative(pointA, dir_len, thickness, color, duration)


## Draw a thick line from [param pointA] with direction and length [param dir_len].
## Uses a MultiMesh for drawing.
func draw_line_thick(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, duration: float = 0.0):
	%LineThickMM.set_line(pointA, pointB, thickness, color, duration)


## Draw a sphere. The sphere stays visible for [param duration] seconds.
## Uses a MultiMesh for drawing.
func draw_sphere(pos: Vector3, radius: float, color: Color = Color(Color.RED, 0.85), duration: float = 0.0) -> void:
	%SphereMM.set_sphere(pos, radius, color, duration)


#endregion END MultiMesh Functions


#region Quick Draw Functions
## Draw a line from [param pointA] to [param pointB].[br]
## This needs to be called each frame as it is erased after the end of each frame.
func qdraw_line(pointA : Vector3, pointB : Vector3, color: Color = Color.BLACK):
	if not use_debug_draw or pointA.is_equal_approx(pointB):
		return

	if _draw_debug_line.mesh is ImmediateMesh:
		_start_line_drawing()
		_draw_debug_line.mesh.surface_set_color(color)
		_draw_debug_line.mesh.surface_add_vertex(pointA)
		_draw_debug_line.mesh.surface_add_vertex(pointB)


## Draw a line from [param pointA] to [param dir_len].[br]
## This needs to be called each frame as it is erased after the end of each frame.
func qdraw_line_relative(pointA : Vector3, dir_len : Vector3, color: Color = Color.PURPLE):
	qdraw_line(pointA, pointA+dir_len, color)


## Draw a thick line from [param pointA] to [param dir_len].[br]
## This needs to be called each frame as it is erased after the end of each frame.[br][br]
## Based on Raycast3D debug shape: [br]
## [url]https://github.com/godotengine/godot/blob/44e399ed5fa895f760b2995e59788bdb49782666/scene/3d/ray_cast_3d.cpp#L397C2-L408C3[/url]
func qdraw_line_relative_thick(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, is_pointy: bool = false):
	pointB = pointA+pointB

	if not use_debug_draw or pointA.is_equal_approx(pointB):
		return
	if _draw_debug_tri.mesh is ImmediateMesh:
		_start_triangle_drawing()
		_draw_debug_tri.mesh.surface_set_color(color)
#
		var scale_factor := 100.0

		var dir := pointA.direction_to(pointB)
		var EPISILON = 0.00001

		# Draw cube line
		var normal := Vector3(-dir.y, dir.x, 0).normalized() \
			if (abs(dir.x) + abs(dir.y) > EPISILON) \
			else Vector3(0, -dir.z, dir.y).normalized()
		normal *= thickness / scale_factor

		var vertices_strip_order = [
			0, 1, 2, 0, 2, 3,  # Back face
			6, 5, 4, 7, 6, 4,  # Front face
			0, 3, 7, 0, 7, 4,  # Left face
			1, 5, 6, 1, 6, 2,  # Right face
			3, 2, 6, 3, 6, 7,  # Top face
			0, 4, 5, 0, 5, 1   # Bottom face
		]
		var localB = (pointB-pointA)
		var pointy_factor: float = 3.0 if is_pointy else 1.0
		# Calculates line mesh at origin
		for v in range(36):
			var vertex = normal if \
				vertices_strip_order[v] < 4 else \
				(normal / pointy_factor) + localB
			var final_vert = vertex.rotated(dir,
				PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
			# Offset to real position
			final_vert += pointA
			_draw_debug_tri.mesh.surface_add_vertex(final_vert)


## Draw a pointy line from [param pointA] to [param dir_len].[br]
## This needs to be called each frame as it is erased after the end of each frame.[br]
func qdraw_line_relative_thickpointy(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK):
	qdraw_line_relative_thick(pointA, pointB, thickness, color, true)


func _start_line_drawing() -> void:
	if not _started_line_drawing:
		_draw_debug_line.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		_started_line_drawing = true


func _stop_line_drawing() -> void:
	_draw_debug_line.mesh.surface_end()
	_started_line_drawing = false


func _start_triangle_drawing() -> void:
	if not _started_line_drawing:
		_draw_debug_tri.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
		_started_line_drawing = true


func _stop_triangle_drawing() -> void:
	_draw_debug_tri.mesh.surface_end()
	_started_triangle_drawing = false


## Clear all surfaces from the ImmediateMesh debug mesh.
## Only affects 'quick draws' functions
## This is auto-called every next physics frames.
## You only need to call this if you disable [member auto_clear_shapes]
func qclear_all_shapes():
	if _draw_debug_tri.mesh is ImmediateMesh:
		_draw_debug_tri.mesh.clear_surfaces()
	if _draw_debug_line.mesh is ImmediateMesh:
		_draw_debug_line.mesh.clear_surfaces()
#endregion end Quick Draw Functions


func print_debug_info():
	print_rich("[color=red][b]・▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖▖・[/b][/color]")
	print("Visible instance count of multimesh, counts transparent ('erased') meshes.")
	print_rich("[b]Thick lines:[/b]")
	print("Visible instance count: ",%LineThickMM.multimesh.visible_instance_count)

	print_rich("[b]Line:[/b]")
	print("Visible instance count: ",%LineSimpleMM.multimesh.visible_instance_count)

	print_rich("[b]Spheres:[/b]")
	print("Visible instance count: ",%SphereMM.multimesh.visible_instance_count)
	print("\n")
