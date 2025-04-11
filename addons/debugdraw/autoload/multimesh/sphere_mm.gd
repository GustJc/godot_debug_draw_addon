extends BaseMultiMeshDebugDraw


func _enter_tree() -> void:
	multimesh.instance_count = DebugDraw.MAX_SHAPES_PER_TYPE


func set_sphere(pos: Vector3, radius: float, color: Color, duration: float) -> void:
	var id: int = _get_available_id()
	if id < 0:
		return
	multimesh.set_instance_color(id, color)
	# Sphere mesh has radius 1. So scaling it equals effective radius
	multimesh.set_instance_transform(id, Transform3D(Basis().scaled(Vector3.ONE*radius), pos))

	if duration > DebugDraw._PHYSICS_TIME:
		await get_tree().create_timer(duration).timeout
	else:
		await get_tree().physics_frame

	remove_instance(id)
