extends MeshInstance

export(Texture) var texture : Texture = preload("res://wheat.png")
export(Vector3) var size = Vector3(8,28,8)
export(bool) var AutoScale = true
export(int) var index = 0

func _ready():
	_update()

func _update():
	var mater : ShaderMaterial = get_active_material(0)
	var shader : Shader = load("res://UShader.gdshader")
	mater.shader = shader
	texture.flags = 0
	if AutoScale:
		scale = size/8
	mater.set_shader_param("image",texture)
	mater.set_shader_param("sizeV",size.floor())
	mater.set_shader_param("sizeI",texture.get_size())
	mater.set_shader_param("index",index)
