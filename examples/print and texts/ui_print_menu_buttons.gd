extends CanvasLayer


func _test_multiple_prints() -> void:

	DebugDraw.text("This is okay")
	await get_tree().create_timer(randf_range(0.4, 0.6)).timeout
	DebugDraw.text("Variable [b]accepted[/b]")
	await get_tree().create_timer(randf_range(0.4, 0.6)).timeout
	DebugDraw.text("[color=red]Another Variable[/color] accepted")
	pass


func _test_persistent() -> void:
	DebugDraw.set_text("This is a persistent text or Help text")
	DebugDraw.set_text("[color=black][b] Here is another text [/b][/color]", 1)


func _test_hide_persistent() -> void:
	DebugDraw.hide_text()

func _test_hide_all_persistent() -> void:
	DebugDraw.hide_all_texts()
