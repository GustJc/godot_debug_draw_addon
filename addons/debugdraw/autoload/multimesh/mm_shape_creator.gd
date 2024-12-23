extends Object


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
