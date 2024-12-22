extends MultiMeshInstance3D

var last_id : int = 0


func _init() -> void:
	multimesh.mesh = ImmediateMesh.new()

	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD
	var thickness = 1.0

	multimesh.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	multimesh.mesh.surface_set_color(Color.WHITE)
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
		multimesh.mesh.surface_add_vertex(final_vert)
	multimesh.mesh.surface_end()
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.transparency = mat.TRANSPARENCY_ALPHA
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	multimesh.mesh.surface_set_material(0, mat)


func set_line_relative(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.RED, duration: float = 1.0):
	var id: int = last_id
	last_id = (last_id+1) % multimesh.instance_count
	# Show the next instance
	multimesh.visible_instance_count = min(multimesh.visible_instance_count+1, multimesh.instance_count)
	multimesh.set_instance_color(id, color)

	var l_transform = Transform3D(Basis(), pointA)
	var dir = pointA.direction_to(pointA+pointB)
	if abs(dir.y) > 0.95:
		l_transform.basis = l_transform.basis.looking_at(dir, Vector3.FORWARD)
	else:
		l_transform.basis = l_transform.basis.looking_at(dir)

	# Scale mesh to fit length and thickness. Base mesh if 1 thick, 1 length.
	var len = pointA.distance_to(pointA+pointB)
	l_transform = l_transform.scaled_local(Vector3(thickness, thickness, len))

	# Sphere mesh has radius 1. So scaling it equals effective radius
	multimesh.set_instance_transform(id, l_transform)
	await get_tree().create_timer(duration).timeout
	remove_sphere(id)


func remove_sphere(id: int) -> void:
	multimesh.set_instance_color(id, Color.TRANSPARENT)
	multimesh.set_instance_transform(id, Transform3D())
