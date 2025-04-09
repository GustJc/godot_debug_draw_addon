extends MultiMeshInstance3D
class_name BaseMultiMeshDebugDraw

var last_id : int = -1
var freed_list : Array[int]
var use_list : Array[int]


func _get_available_id() -> int:
	if freed_list.is_empty():
		last_id = multimesh.visible_instance_count
	else:
		last_id = freed_list.pop_front() # gets first in

	if last_id+1 > multimesh.visible_instance_count:
		multimesh.visible_instance_count = min(last_id+1, multimesh.instance_count)

	return last_id


func remove_instance(id: int) -> void:
	multimesh.set_instance_color(id, Color.TRANSPARENT)
	multimesh.set_instance_transform(id, Transform3D())
	freed_list.push_back(id)
