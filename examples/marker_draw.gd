extends Marker3D


func _ready() -> void:
	#test_line()
	#test_line_thick()
	test_hits()
	pass


func test_hits() -> void:
	DebugDraw.draw_hit_ray(position, Vector3.UP)
	DebugDraw.draw_hit_ray(position+Vector3.UP, Vector3.UP)


	DebugDraw.draw_hit_ray_thick(position+Vector3.RIGHT, Vector3.UP)
	DebugDraw.draw_hit_ray_thick(position+Vector3.UP+Vector3.RIGHT, Vector3.RIGHT)

func test_line() -> void:
	var px = 0
	var py = 3.5
	var pz = 4
	DebugDraw.draw_ray(position+Vector3(0, 3.5, 4), Vector3.UP, 1.0, Color.REBECCA_PURPLE)
	DebugDraw.draw_ray(position+Vector3(0, 3.5, 4), Vector3.LEFT, 2.0, Color.GREEN)
	DebugDraw.draw_ray(position+Vector3(0, 3.5, 4), Vector3(-1,1,0), 3.0, Color.GREEN_YELLOW)

	DebugDraw.draw_ray(position+Vector3(px  , py,   pz), Vector3(-1, 0 , 0), 0.5, Color.RED)
	DebugDraw.draw_ray(position+Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), 1.0, Color.RED)
	DebugDraw.draw_ray(position+Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), 1.5, Color.RED)
	DebugDraw.draw_ray(position+Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), 2.0, Color.RED)
	DebugDraw.draw_ray(position+Vector3(px,   py  , pz), Vector3( 1, 0 , 0), 2.5, Color.RED)
	DebugDraw.draw_sphere_mm(position+Vector3(px,   py  , pz), 10.0, 0.1, Color.GREEN)
	DebugDraw.draw_sphere_mm(position+Vector3(px-1,   py  , pz), 10.0, 0.1, Color.GREEN)
	DebugDraw.draw_sphere_mm(position+Vector3(px-1,   py+1  , pz), 10.0, 0.1, Color.GREEN)
	DebugDraw.draw_sphere_mm(position+Vector3(px,   py+1  , pz), 10.0, 0.1, Color.GREEN)




func test_line_thick() -> void:
	var px = 0
	var py = 3.5
	var pz = 4
	DebugDraw.draw_ray_thick(position+Vector3(0, 3.5, 4), Vector3.UP, 5.0, 1.0, Color.REBECCA_PURPLE)
	DebugDraw.draw_ray_thick(position+Vector3(0, 3.5, 4), Vector3.LEFT, 3.0, 2.0, Color.GREEN)
	DebugDraw.draw_ray_thick(position+Vector3(0, 3.5, 4), Vector3(-1,1,0), 3.0, 3.0, Color.GREEN_YELLOW)


	var fac = 10.0
	DebugDraw.draw_ray_thick(position+Vector3(px  , py,   pz), Vector3(-1, 0 , 0), 0.5*fac, 3.0, Color.RED)
	DebugDraw.draw_ray_thick(position+Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), 1.0*fac, 3.0, Color.RED)
	DebugDraw.draw_ray_thick(position+Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), 1.5*fac, 3.0, Color.RED)
	DebugDraw.draw_ray_thick(position+Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, 3.0, Color.RED)
	DebugDraw.draw_ray_thick(position+Vector3(px,   py  , pz), Vector3( 1, 0 , 0), 2.5*fac, 3.0, Color.RED)


	DebugDraw.draw_ray_thick(position+Vector3(px+0.1,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, 3.0, Color.RED)
	DebugDraw.draw_ray_thick(position+Vector3(px-0.1,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, 3.0, Color.RED)


func test_sphere() -> void:
	DebugDraw.draw_sphere_mm(position, 1.0, 10.0, Color.GREEN)
	position.x += 1
	DebugDraw.draw_sphere_mm(position, 1.0, 10.0, Color(Color.RED, 0.85))
	position.x += 1
	position.z += 1
	DebugDraw.draw_sphere_mm(position, 1.0, 10.0, Color.GREEN)
	position.x += 1
	DebugDraw.draw_sphere_mm(position, 1.0, 10.0, Color.BLUE)


func _physics_process(_delta: float) -> void:
	pass
	#for i in 300:
		#DebugDraw.draw_line_relative(position+Vector3(-2+i*0.1,0,0), Vector3.UP*5, Color.BLACK)
