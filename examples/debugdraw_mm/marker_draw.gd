extends Marker3D

var test_process := false
var test_physics_process := false


func test_draw_arrow() -> void:
	var pos := position
	#DebugDraw.print_debug_info()
	DebugDraw.draw_arrow(pos, pos+Vector3.RIGHT, 1, 0.25, Color.BLUE, Color.BLUE, 5.0)
	DebugDraw.draw_arrow(pos, pos+Vector3.UP, 1, 0.25, Color.BLUE, Color.BLUE, 5.0)
	#DebugDraw.print_debug_info()
	await get_tree().create_timer(1).timeout

	pos = pos + Vector3.RIGHT
	DebugDraw.draw_arrow(pos, pos+Vector3.UP+Vector3.LEFT, 1.5, 0.2, Color.RED, Color.RED, 5.0, false, true)
	DebugDraw.draw_arrow(pos, pos+Vector3.UP, 1.5, 0.2, Color.RED, Color.RED, 5.0, false, true)
	pass

func _process(_delta: float) -> void:
	if test_process:
		var co := cos(Time.get_ticks_msec()/1000.0)
		var si := sin(Time.get_ticks_msec()/1000.0)
		var px = 0 + 1 * si
		var py = 3.5
		var pz = 1 + 1 * co
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3.UP, 1.0, Color.REBECCA_PURPLE)
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3(-1*co, 0, 1*si), 2.0, Color.GREEN)
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3(-1*co, 1, 1*si), 3.0, Color.GREEN_YELLOW)


func _physics_process(_delta: float) -> void:
	if test_physics_process:
		var co := cos(Time.get_ticks_msec()/1000.0)
		var si := sin(Time.get_ticks_msec()/1000.0)
		var px = 0 + 1 * co
		var py = 3.5
		var pz = 1 + 1 * si
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3.UP, 1.0, Color.BROWN)
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3(-1*si, 0, 1*co), 2.0, Color.CRIMSON)
		DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3(-1*si, 1, 1*co), 3.0, Color.GOLD)

func test_hits() -> void:
	DebugDraw.draw_hit_ray(position, Vector3.UP)
	DebugDraw.draw_hit_ray(position+Vector3.UP, Vector3.UP)


	DebugDraw.draw_hit_ray_thick(position+Vector3.RIGHT, Vector3.UP)
	DebugDraw.draw_hit_ray_thick(position+Vector3.UP+Vector3.RIGHT, Vector3.RIGHT+Vector3.DOWN)

func test_line() -> void:
	var px = 0
	var py = 3.5
	var pz = 1
	DebugDraw.draw_ray(Vector3(px, py, pz), Vector3.UP, Color.REBECCA_PURPLE, 1.0)
	DebugDraw.draw_ray(Vector3(px, py, pz), Vector3.LEFT, Color.GREEN, 2.0)
	DebugDraw.draw_ray(Vector3(px, py, pz), Vector3(-1,1,0), Color.GREEN_YELLOW, 3.0)

	DebugDraw.draw_ray(Vector3(px  , py,   pz), Vector3(-1, 0 , 0), Color.RED, 0.5)
	DebugDraw.draw_ray(Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), Color.RED, 1.0)
	DebugDraw.draw_ray(Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), Color.RED, 1.5)
	DebugDraw.draw_ray(Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), Color.RED, 2.0)
	DebugDraw.draw_ray(Vector3(px,   py  , pz), Vector3( 1, 0 , 0), Color.RED, 2.5)


func test_line_thick() -> void:
	var px = 0
	var py = 3.5
	var pz = 1
	DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3.UP, 5.0, Color.REBECCA_PURPLE, 1.0)
	DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3.LEFT, 3.0, Color.GREEN, 2.0)
	DebugDraw.draw_ray_thick(Vector3(px, py, pz), Vector3(-1,1,0), 3.0, Color.GREEN_YELLOW, 3.0)

	await get_tree().create_timer(3.0).timeout
	var fac = 5.0
	DebugDraw.draw_ray_thick(Vector3(px  , py,   pz), Vector3(-1, 0 , 0), 0.5*fac, Color.RED, 2.0)
	DebugDraw.draw_ray_thick(Vector3(px-1, py,   pz), Vector3( 0, 1 , 0), 1.0*fac, Color.RED, 2.0)
	DebugDraw.draw_ray_thick(Vector3(px-1, py+1, pz), Vector3( 1, 0 , 0), 1.5*fac, Color.RED, 2.0)
	DebugDraw.draw_ray_thick(Vector3(px,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, Color.RED, 2.0)
	DebugDraw.draw_ray_thick(Vector3(px,   py  , pz), Vector3( 1, 0 , 0), 2.5*fac, Color.RED, 2.0)

	await get_tree().create_timer(1.0).timeout
	var mat := DebugDraw.line_thick_mm.multimesh.mesh.surface_get_material(0)
	mat.shading_mode = mat.SHADING_MODE_PER_PIXEL

	await get_tree().create_timer(2.0).timeout

	DebugDraw.draw_ray_thick(Vector3(px+0.1,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, Color.RED, 3.0)
	DebugDraw.draw_ray_thick(Vector3(px-0.1,   py+1, pz), Vector3( 0,-1 , 0), 2.0*fac, Color.RED, 3.0)


func test_sphere() -> void:
	DebugDraw.draw_sphere(position, 1.0, Color.GREEN, 10.0)
	position.x += 1
	DebugDraw.draw_sphere(position, 1.0, Color(Color.RED, 0.85), 10.0)
	position.x += 1
	position.z += 1
	DebugDraw.draw_sphere(position, 1.0, Color.GREEN, 10.0)
	position.x += 1
	DebugDraw.draw_sphere(position, 1.0, Color.BLUE, 10.0)



func _ready() -> void:
	#test_line()
	#test_line_thick()
	#test_hits()
	#test_draw_arrow()

	#test_surf_tool()
	#test_surf_tool_2_STRIP()
	#test_surf_tool_pointy_2_STRIP()
	#test_surf_tool_pointy()
	#test_zero_duration = true
	pass
#region mesh creation

func test_surf_tool_pointy() -> void:
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Define the vertices of the cube
	var thickness = 2.0
	var f: float = (1.0/100.0) / 2.0
	f *= thickness
	var fhalf := f/4.0
	var vertices = [
		Vector3(-fhalf, -fhalf, -1), Vector3(fhalf, -fhalf, -1),
		Vector3(fhalf, fhalf, -1), Vector3(-fhalf, fhalf, -1),  # Back face

		Vector3(-f, -f, 0), Vector3(f, -f, 0),
		Vector3(f, f, 0), Vector3(-f, f, 0)   # Front face
	]

	# Define the indices for the triangles
	var indices = [
		0, 1, 2, 0, 2, 3,  # Back face
		6, 5, 4, 7, 6, 4,  # Front face
		0, 3, 7, 0, 7, 4,  # Left face
		1, 5, 6, 1, 6, 2,  # Right face
		3, 2, 6, 3, 6, 7,  # Top face
		0, 4, 5, 0, 5, 1   # Bottom face
	]

	surface_tool.set_smooth_group(-1)
	# Add vertices and indices to the SurfaceTool
	for i in indices:
		surface_tool.add_vertex(vertices[i])

	surface_tool.generate_normals()

	# Commit to a mesh.
	var mesh = surface_tool.commit()

	%Mesh3D.mesh = mesh

func test_surf_tool_pointy_2_STRIP() -> void:
	var surface_tool = SurfaceTool.new()

	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD
	var thickness = 1.0

	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	surface_tool.set_color(Color.WHITE)
#
	var scale_factor := 100.0

	var dir := pointA.direction_to(pointB)
	var EPISILON = 0.00001

	# Draw cube line
	var normal := Vector3(-dir.y, dir.x, 0).normalized() \
		if (abs(dir.x) + abs(dir.y) > EPISILON) \
		else Vector3(0, -dir.z, dir.y).normalized()
	normal *= thickness / scale_factor

	var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
	var localB = (pointB-pointA)
	# Calculates line mesh at origin
	surface_tool.set_smooth_group(-1)
	for v in range(14):
		var vertex = normal if \
			vertices_strip_order[v] < 4 else \
			normal /3.0 + localB
		var final_vert = vertex.rotated(dir,
			PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
		# Offset to real position
		final_vert += pointA
		surface_tool.add_vertex(final_vert)

	# Commit to a mesh.
	var mesh = surface_tool.commit()

	%Mesh3D2.mesh = mesh

func test_surf_tool_2_STRIP() -> void:
	var surface_tool = SurfaceTool.new()

	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD
	var thickness = 1.0

	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	surface_tool.set_color(Color.WHITE)
#
	var scale_factor := 100.0

	var dir := pointA.direction_to(pointB)
	var EPISILON = 0.00001

	# Draw cube line
	var normal := Vector3(-dir.y, dir.x, 0).normalized() \
		if (abs(dir.x) + abs(dir.y) > EPISILON) \
		else Vector3(0, -dir.z, dir.y).normalized()
	normal *= thickness / scale_factor

	var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
	var localB = (pointB-pointA)
	# Calculates line mesh at origin
	surface_tool.set_smooth_group(-1)
	for v in range(14):
		var vertex = normal if \
			vertices_strip_order[v] < 4 else \
			normal + localB
		var final_vert = vertex.rotated(dir,
			PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
		# Offset to real position
		final_vert += pointA
		surface_tool.add_vertex(final_vert)

	#surface_tool.generate_normals()

	# Commit to a mesh.
	var mesh = surface_tool.commit()

	%Mesh3D2.mesh = mesh

func test_surf_tool() -> void:
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Define the vertices of the cube
	var f: float = (1.0/100.0) / 2.0
	var vertices = [
		Vector3(-f, -f, -1), Vector3(f, -f, -1),
		Vector3(f, f, -1), Vector3(-f, f, -1),  # Back face

		Vector3(-f, -f, 0), Vector3(f, -f, 0),
		Vector3(f, f, 0), Vector3(-f, f, 0)   # Front face
	]

	# Define the indices for the triangles
	var indices = [
		0, 1, 2, 0, 2, 3,  # Back face
		6, 5, 4, 7, 6, 4,  # Front face
		0, 3, 7, 0, 7, 4,  # Left face
		1, 5, 6, 1, 6, 2,  # Right face
		3, 2, 6, 3, 6, 7,  # Top face
		0, 4, 5, 0, 5, 1   # Bottom face
	]

	surface_tool.set_smooth_group(-1)
	# Add vertices and indices to the SurfaceTool
	for i in indices:
		surface_tool.add_vertex(vertices[i])

	surface_tool.generate_normals()

	# Commit to a mesh.
	var mesh = surface_tool.commit()

	%Mesh3D.mesh = mesh

#endregion
