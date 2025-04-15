extends BaseMultiMeshDebugDraw
## Create thick lines instances
##
## The created meshes lacks proper normals, to its meant to be used as unshaded.


func _enter_tree() -> void:
	multimesh.instance_count = DebugDraw.MAX_SHAPES_LINE_THICK_TYPE
	MMShapeCreator.setup_line_thick_normalied(multimesh)


func set_line_relative(pointA : Vector3, dir_len : Vector3, thickness: float = 2.0, color: Color = Color.RED, duration: float = 1.0):
	set_line(pointA, pointA+dir_len, thickness, color, duration)


func set_line(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.RED, duration: float = 1.0):
	if pointA.is_equal_approx(pointB):
		if DebugDraw.show_minor_warnings:
			print_rich("[color=orange] Trying to draw zero length line at: %s [/color]" % pointA)
		return
	var id: int = _get_available_id()
	if id < 0:
		return
	multimesh.set_instance_color(id, color)

	var l_transform = Transform3D(Basis(), pointA)
	var dir = pointA.direction_to(pointB)
	if abs(dir.y) > 0.95:
		l_transform.basis = l_transform.basis.looking_at(dir, Vector3.LEFT)
	else:
		l_transform.basis = l_transform.basis.looking_at(dir)

	# Scale mesh to fit length and thickness. Base mesh if 1 thick, 1 length.
	var len = pointA.distance_to(pointB)
	l_transform = l_transform.scaled_local(Vector3(thickness, thickness, len))

	# Sphere mesh has radius 1. So scaling it equals effective radius
	multimesh.set_instance_transform(id, l_transform)

	if duration > DebugDraw._PHYSICS_TIME:
		await get_tree().create_timer(duration).timeout
	else:
		await get_tree().physics_frame

	remove_instance(id)
