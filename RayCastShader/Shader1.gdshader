shader_type spatial;
render_mode cull_back;

uniform sampler2D inst;
varying flat vec3 cam;

vec4 getPix(ivec3 pos,ivec3 size){
	if(pos.x < 0 || pos.x > size.x-1 || pos.y < 0 || pos.y > size.y-1 || pos.z < 0 || pos.z > size.z-1){
		return vec4(0);
	}
	return texelFetch(inst,ivec2(pos.x + pos.y*size.z,pos.z),0);
}
//Depth,Normal,Color
mat4 intersect(ivec3 size,vec3 start,vec3 dir){
	vec3 vStart = start * vec3(size);
	float shift = 1.f/1024.f;
	if(vStart.x == 0.f) vStart.x -= shift;
	if(vStart.y == 0.f) vStart.y -= shift;
	if(vStart.z == 0.f) vStart.z -= shift;
	if(vStart.x == float(size.x)) vStart.x += shift;
	if(vStart.y == float(size.y)) vStart.y += shift;
	if(vStart.z == float(size.z)) vStart.z += shift;
	ivec3 vMCheck = ivec3(floor(vStart));
	vec3 vRUSS = vec3(sqrt(1.f+(dir.y/dir.x)*(dir.y/dir.x)+(dir.z/dir.x)*(dir.z/dir.x)),sqrt(1.f+(dir.x/dir.y)*(dir.x/dir.y)+(dir.z/dir.y)*(dir.z/dir.y)),sqrt(1.f+(dir.y/dir.z)*(dir.y/dir.z)+(dir.x/dir.z)*(dir.x/dir.z)));
	vec3 vRL1D;
	ivec3 vStep;
	if(dir.x < 0.f){
		vStep.x = -1;
		vRL1D.x = (vStart.x - vec3(vMCheck).x)*vRUSS.x;
	}else{
		vStep.x = 1;
		vRL1D.x = (vec3(vMCheck).x - vStart.x+1.f)*vRUSS.x;
	}
	if(dir.y < 0.f){
		vStep.y = -1;
		vRL1D.y = (vStart.y - vec3(vMCheck).y)*vRUSS.y;
	}else{
		vStep.y = 1;
		vRL1D.y = (vec3(vMCheck).y - vStart.y+1.f)*vRUSS.y;
	}
	if(dir.z < 0.f){
		vStep.z = -1;
		vRL1D.z = (vStart.z - vec3(vMCheck).z)*vRUSS.z;
	}else{
		vStep.z = 1;
		vRL1D.z = (vec3(vMCheck).z - vStart.z+1.f)*vRUSS.z;
	}
	ivec3 vPCheck;
	bool bFound = false;
	vec4 VoxelColor = vec4(0.f);
	float Distance = 0.f;
	float DistMax = float(size.y*2);
	while(!bFound && Distance < DistMax){
		vPCheck = vMCheck;
		if(vRL1D.x < vRL1D.y && vRL1D.x < vRL1D.z){
			vMCheck.x += vStep.x;
			Distance = vRL1D.x;
			vRL1D.x += vRUSS.x;
		}else if(vRL1D.y < vRL1D.z && vRL1D.y < vRL1D.x){
			vMCheck.y += vStep.y;
			Distance = vRL1D.y;
			vRL1D.y += vRUSS.y;
		}else{
			vMCheck.z += vStep.z;
			Distance = vRL1D.z;
			vRL1D.z += vRUSS.z;
		}
		VoxelColor = getPix(vMCheck,size);
		if(VoxelColor.a != 0.f) bFound = true;
	}
	
	return mat4(VoxelColor,vec4(vec3(vPCheck - vMCheck),Distance/length(vec3(size))),vec4(1.f),vec4(1.f));
}

void vertex(){
	cam = (CAMERA_MATRIX * vec4(0.f,0.f,0.f,1.f)).xyz;
}

void fragment() {
	vec3 ver = (CAMERA_MATRIX * vec4(VERTEX, 1.f)).xyz;
	vec3 dirv = normalize(ver - cam);
	ivec3 size = ivec3(textureSize(inst,0),0);
	size.z = size.y;
	size.y = size.x/size.y;
	size.x = size.z;
	mat4 its = intersect(size,COLOR.xyz,dirv);
	NORMAL = its[1].xyz;
	DEPTH = its[1].w;
	ALBEDO = its[0].rgb;
	ALPHA = its[0].a*max(min(distance(cam,ver)+DEPTH-0.5,1.f),0.f);
}