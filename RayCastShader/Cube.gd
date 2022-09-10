extends MeshInstance

export(Texture) var texture

func _ready():
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP);
	surface_tool.add_color(Color(1, 0, 0))
	surface_tool.add_vertex(Vector3(1, 0, 0))
	surface_tool.add_color(Color(0, 1, 0))
	surface_tool.add_vertex(Vector3(0, 1, 0))
	surface_tool.add_color(Color(0, 0, 0))
	surface_tool.add_vertex(Vector3(0, 0, 0))
	surface_tool.add_color(Color(0, 0, 1))
	surface_tool.add_vertex(Vector3(0, 0, 1))
	surface_tool.add_color(Color(1, 0, 0))
	surface_tool.add_vertex(Vector3(1, 0, 0))
	surface_tool.add_color(Color(1, 0, 1))
	surface_tool.add_vertex(Vector3(1, 0, 1))
	surface_tool.add_color(Color(1, 1, 1))
	surface_tool.add_vertex(Vector3(1, 1, 1))
	surface_tool.add_color(Color(0, 0, 1))
	surface_tool.add_vertex(Vector3(0, 0, 1))
	surface_tool.add_color(Color(0, 1, 1))
	surface_tool.add_vertex(Vector3(0, 1, 1))
	surface_tool.add_color(Color(0, 1, 0))
	surface_tool.add_vertex(Vector3(0, 1, 0))
	surface_tool.add_color(Color(1, 1, 1))
	surface_tool.add_vertex(Vector3(1, 1, 1))
	surface_tool.add_color(Color(1, 1, 0))
	surface_tool.add_vertex(Vector3(1, 1, 0))
	surface_tool.add_color(Color(1, 0, 0))
	surface_tool.add_vertex(Vector3(1, 0, 0))
	surface_tool.add_color(Color(0, 1, 0))
	surface_tool.add_vertex(Vector3(0, 1, 0))
	
	var shader1 = load("res://Shader1.gdshader")
	var textur : Texture = load("res://test2.png")
	var material1 = ShaderMaterial.new()
	material1.shader = shader1
	material1.set_shader_param("inst",textur)
	surface_tool.set_material(material1)
	
	mesh = surface_tool.commit()

