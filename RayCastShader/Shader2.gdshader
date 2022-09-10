shader_type spatial;
render_mode unshaded,cull_back;



void fragment() {
	
	vec3 wrld_vertex = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
	  ALBEDO = wrld_vertex;
	  ALPHA = 1.f;
}
