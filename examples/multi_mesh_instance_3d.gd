extends MultiMeshInstance3D


func _ready() -> void:
	multimesh.instance_count = 10000

	# Set the transform of the instances.
	var width = 5
	var length = 30
	var colors = [Color.BEIGE, Color.BLACK, Color.YELLOW, Color.RED]
	for x in range(length):
		for z in range(width):
			var id= x*width + z
			var c = colors[randi_range(0, colors.size()-1)]
			multimesh.set_instance_color(id, c)
			multimesh.set_instance_transform(id, Transform3D(Basis().scaled(Vector3.ONE), Vector3((length/2.0)-x, 0,(width/2.0)-z)))
