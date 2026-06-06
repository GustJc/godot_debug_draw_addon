extends CanvasLayer


func print_message(msg_str: String, time: float) -> void:
	var l := RichTextLabel.new()
	l.fit_content = true
	l.bbcode_enabled = true
	l.text = msg_str

	%PrintContainer.add_child(l)

	if time < 0: time = DebugDraw.PRINT_DEFAULT_TIME
	await get_tree().create_timer(time).timeout

	var t := create_tween()
	t.tween_property(l, "self_modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(l.queue_free)


func set_text(msg_str: String, idx: int = 0) -> void:
	if idx < 0 or idx >= %PermanentContainer.get_child_count():
		return # silent return

	var rtl : RichTextLabel = %PermanentContainer.get_child(idx)
	rtl.text = msg_str
	rtl.show()


func hide_text(idx: int = 0) -> void:
	if idx < 0 or idx >= %PermanentContainer.get_child_count():
		return # silent return

	var rtl : RichTextLabel = %PermanentContainer.get_child(idx)
	rtl.hide()


func hide_all_texts() -> void:
	for n in %PermanentContainer.get_children():
		n.hide()
