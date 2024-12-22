extends Marker3D


func _ready() -> void:
	var px = 0
	var py = 3.5
	var pz = 4
	DebugDraw.set_line_relative(position+Vector3(0, 3.5, 4), Vector3.UP, Color.REBECCA_PURPLE, 1.0)
	DebugDraw.set_line_relative(position+Vector3(0, 3.5, 4), Vector3.LEFT, Color.GREEN, 2.0)
	DebugDraw.set_line_relative(position+Vector3(0, 3.5, 4), Vector3(-1,1,0), Color.GREEN_YELLOW, 3.0)


	DebugDraw.set_line_relative(position+Vector3(px  , py,   pz), Vector3(-1, 0 , 0), Color.RED, 0.5)
	DebugDraw.set_line_relative(position+Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), Color.RED, 1.0)
	DebugDraw.set_line_relative(position+Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), Color.RED, 1.5)
	DebugDraw.set_line_relative(position+Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), Color.RED, 2.0)
	DebugDraw.set_line_relative(position+Vector3(px,   py  , pz), Vector3( 1, 0 , 0), Color.RED, 2.5)
	DebugDraw.draw_sphere_mm(position+Vector3(px,   py  , pz), 0.1, Color.GREEN, 10.0)
	DebugDraw.draw_sphere_mm(position+Vector3(px-1,   py  , pz), 0.1, Color.GREEN, 10.0)
	DebugDraw.draw_sphere_mm(position+Vector3(px-1,   py+1  , pz), 0.1, Color.GREEN, 10.0)
	DebugDraw.draw_sphere_mm(position+Vector3(px,   py+1  , pz), 0.1, Color.GREEN, 10.0)




func test_line_thick() -> void:
	var px = 0
	var py = 3.5
	var pz = 4
	DebugDraw.set_line_thick_relative(position+Vector3(0, 3.5, 4), Vector3.UP, 5.0, Color.REBECCA_PURPLE, 1.0)
	DebugDraw.set_line_thick_relative(position+Vector3(0, 3.5, 4), Vector3.LEFT, 3.0, Color.GREEN, 2.0)
	DebugDraw.set_line_thick_relative(position+Vector3(0, 3.5, 4), Vector3(-1,1,0), 3.0, Color.GREEN_YELLOW, 3.0)


	DebugDraw.set_line_thick_relative(position+Vector3(px  , py,   pz), Vector3(-1, 0 , 0), 3.0, Color.RED, 0.5)
	DebugDraw.set_line_thick_relative(position+Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), 3.0, Color.RED, 1.0)
	DebugDraw.set_line_thick_relative(position+Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), 3.0, Color.RED, 1.5)
	DebugDraw.set_line_thick_relative(position+Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), 3.0, Color.RED, 2.0)
	DebugDraw.set_line_thick_relative(position+Vector3(px,   py  , pz), Vector3( 1, 0 , 0), 3.0, Color.RED, 2.5)


func test_sphere() -> void:
	DebugDraw.draw_sphere_mm(position, 1.0, Color.GREEN, 10.0)
	position.x += 1
	DebugDraw.draw_sphere_mm(position, 1.0, Color(Color.RED, 0.85), 10.0)
	position.x += 1
	position.z += 1
	DebugDraw.draw_sphere_mm(position, 1.0, Color.GREEN, 10)
	position.x += 1
	DebugDraw.draw_sphere_mm(position, 1.0, Color.BLUE, 10)


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
	#for i in 300:
		#DebugDraw.draw_line_relative(position+Vector3(-2+i*0.1,0,0), Vector3.UP*5, Color.BLACK)
