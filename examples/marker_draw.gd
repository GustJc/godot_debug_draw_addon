extends Marker3D


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	for i in 300:
		DebugDraw.draw_line_relative(position+Vector3(-2+i*0.1,0,0), Vector3.UP*5, Color.BLACK)
