extends BaseMultiMeshDebugDraw


func _enter_tree() -> void:
	multimesh.instance_count = DebugDraw.MAX_SHAPES_PER_TYPE
	multimesh.mesh = ImmediateMesh.new()

	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD

	multimesh.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	multimesh.mesh.surface_set_color(Color.WHITE)
	multimesh.mesh.surface_add_vertex(pointA)
	multimesh.mesh.surface_add_vertex(pointB)

	multimesh.mesh.surface_end()
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.transparency = mat.TRANSPARENCY_ALPHA
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	multimesh.mesh.surface_set_material(0, mat)



func set_line_relative(pointA : Vector3, dir_len : Vector3, color: Color = Color.RED, duration: float = 1.0):
	set_line(pointA, pointA+dir_len, color, duration)


func set_line(pointA : Vector3, pointB : Vector3, color: Color = Color.RED, duration: float = 1.0):
	var id: int = _get_available_id()
	multimesh.set_instance_color(id, color)

	var l_transform = Transform3D(Basis(), pointA)
	var dir = pointA.direction_to(pointB)
	if abs(dir.y) > 0.95:
		l_transform.basis = l_transform.basis.looking_at(dir, Vector3.FORWARD)
	else:
		l_transform.basis = l_transform.basis.looking_at(dir)

	# Scale mesh to fit length and thickness. Base mesh if 1 thick, 1 length.
	var len = pointA.distance_to(pointB)
	l_transform = l_transform.scaled_local(Vector3(1.0, 1.0, len))

	# Sphere mesh has radius 1. So scaling it equals effective radius
	multimesh.set_instance_transform(id, l_transform)

	if duration > DebugDraw._PHYSICS_TIME:
		await get_tree().create_timer(duration).timeout
	else:
		await get_tree().process_frame

	remove_instance(id)
