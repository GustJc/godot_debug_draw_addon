extends MultiMeshInstance3D

var last_id : int = 0


func _enter_tree() -> void:
	multimesh.instance_count = DebugDraw.MAX_SHAPES_PER_TYPE


func set_sphere(pos: Vector3, radius: float, color: Color, duration: float) -> void:
	var id: int = last_id
	last_id = (last_id+1) % multimesh.instance_count
	# Show the next instance
	multimesh.visible_instance_count = min(multimesh.visible_instance_count+1, multimesh.instance_count)
	multimesh.set_instance_color(id, color)
	# Sphere mesh has radius 1. So scaling it equals effective radius
	multimesh.set_instance_transform(id, Transform3D(Basis().scaled(Vector3.ONE*radius), pos))

	if duration > DebugDraw._PHYSICS_TIME:
		await get_tree().create_timer(duration).timeout
	else:
		await get_tree().physics_frame

	remove_sphere(id)


func remove_sphere(id: int) -> void:
	multimesh.set_instance_color(id, Color.TRANSPARENT)
	multimesh.set_instance_transform(id, Transform3D())
