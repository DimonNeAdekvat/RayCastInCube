extends MeshInstance

export(Texture) var texture
export(Vector3) var size
export(bool) var AutoScale
var index : int = 0;

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
	
	var shader1 = load("res://Shader2.gdshader")
	var material1 = ShaderMaterial.new()
	material1.shader = shader1
	material1.set_shader_param("image",texture)
	material1.set_shader_param("sizeI",texture.get_size())
	material1.set_shader_param("sizeV",size)
	if(AutoScale):
		scale = size/8
	material1.set_shader_param("scale",scale)
	material1.set_shader_param("index",index)
	surface_tool.set_material(material1)
	
	mesh = surface_tool.commit()
	$Timer.start()

func _on_Timer_timeout():
	var nindex : int
	if index == 0:
		nindex = 1
	if index == 1:
		nindex = 0
	index = nindex
	var mater : ShaderMaterial = get_active_material(0)
	mater.set_shader_param("index",int(index))
