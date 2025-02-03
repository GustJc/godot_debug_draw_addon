extends Marker3D


func _ready() -> void:
	var tween := create_tween()

	tween.set_loops()
	tween.tween_property(self, "global_position:y", 1, 1.0).as_relative()
	tween.tween_property(self, "global_position:y", -1, 1.0).as_relative()

func _process(_delta: float) -> void:
	for i in range(1, 10):
		var offset := -Vector3.LEFT * 5.0 + Vector3.LEFT * i
		DebugDraw.qdraw_line_relative_thick(global_position + offset, Vector3.UP * 2)
	for i in range(1, 10):
		var offset := -Vector3.LEFT * 5.5 + Vector3.LEFT * i
		DebugDraw.qdraw_line_relative_thickpointy(global_position + offset, Vector3.UP * 2)
