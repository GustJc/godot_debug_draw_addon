extends Object
class_name MMShapeCreator



static func setup_line_thick_normalied(multimesh: MultiMesh) -> void:
	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD
	var thickness = 1.0
#
	var scale_factor := 100.0

	var dir := pointA.direction_to(pointB)
	var EPISILON = 0.00001

	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_smooth_group(-1)

	# Draw cube line
	var normal := Vector3(-dir.y, dir.x, 0).normalized() \
		if (abs(dir.x) + abs(dir.y) > EPISILON) \
		else Vector3(0, -dir.z, dir.y).normalized()
	normal *= thickness / scale_factor

	var vertices_strip_order = [
		0, 1, 2, 0, 2, 3,  # Back face
		6, 5, 4, 7, 6, 4,  # Front face
		0, 3, 7, 0, 7, 4,  # Left face
		1, 5, 6, 1, 6, 2,  # Right face
		3, 2, 6, 3, 6, 7,  # Top face
		0, 4, 5, 0, 5, 1   # Bottom face
	]
	var localB = (pointB-pointA)
	# Calculates line mesh at origin
	for v in range(36):
		var vertex = normal if \
			vertices_strip_order[v] < 4 else \
			normal + localB
		var final_vert := vertex.rotated(dir,
			PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
		# Offset to real position
		final_vert += pointA
		surface_tool.add_vertex(final_vert)
	surface_tool.generate_normals()
	multimesh.mesh = surface_tool.commit()

	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.transparency = mat.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	multimesh.mesh.surface_set_material(0, mat)


## Old mesh from triangle_strips. No normals calculated.
static func setup_line_thick_unnormalized_mesh(multimesh: MultiMesh) -> void:
	multimesh.mesh = ImmediateMesh.new()

	var pointA = Vector3.ZERO
	var pointB = Vector3.FORWARD
	var thickness = 1.0

	multimesh.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	multimesh.mesh.surface_set_color(Color.WHITE)
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
	for v in range(14):
		var vertex = normal if \
			vertices_strip_order[v] < 4 else \
			normal + localB
		var final_vert = vertex.rotated(dir,
			PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25))
		# Offset to real position
		final_vert += pointA
		multimesh.mesh.surface_add_vertex(final_vert)
		#multimesh.mesh.surface_set_normal(normal)
	multimesh.mesh.surface_end()
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.transparency = mat.TRANSPARENCY_ALPHA
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	multimesh.mesh.surface_set_material(0, mat)


## Create a box to act as a line. the box is 1 unit long, and 0.01 units wide/height
static func create_line_thick_mesh() -> Mesh:
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
	return surface_tool.commit()
