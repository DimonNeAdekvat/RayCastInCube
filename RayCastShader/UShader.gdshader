shader_type spatial;
render_mode cull_front;

varying flat vec3 cam;
varying smooth vec3 ver;

uniform sampler2D image;

uniform vec3 sizeV;
uniform vec2 sizeI;
uniform int index;


void vertex(){
	cam = (inverse(WORLD_MATRIX) * CAMERA_MATRIX * vec4(0.f,0.f,0.f,1.0)).xyz;
	ver = VERTEX;
}

vec4 voxel(ivec3 pos){
	if(pos.x < 0 || pos.x > int(sizeV.x) - 1 || pos.y < 0 || pos.y > int(sizeV.y) - 1 || pos.z < 0 || pos.z > int(sizeV.z) - 1){
		return vec4(0);
	}
	ivec2 get = ivec2(pos.x + pos.y*int(sizeV.x),pos.z + index*int(sizeV.z));
	if(get.x < 0 || get.y < 0 || get.x > int(sizeI.x) - 1 || get.y > int(sizeI.y) - 1) return vec4(0);
	return texture(image,vec2(float(get.x)/(sizeI.x - 1.f),float(get.y)/(sizeI.y - 1.f)),0);
}

mat3 intersect(vec3 endp,vec3 dirv,float dist){
	vec3 startp;
	float shift = 1.f/1024.f;
	float relat;
	vec3 vec = dirv*dist;
	vec3 ost = endp + vec;
	if(ost.x <= 0.f){
		relat = (0.f - endp.x)/vec.x;
		vec *= relat;
		ost = endp + vec;
	}
	if(ost.y <= 0.f){
		relat = (0.f - endp.y)/vec.y;
		vec *= relat;
		ost = endp + vec;
	}
	if(ost.z <= 0.f){
		relat = (0.f - endp.z)/vec.z;
		vec *= relat;
		ost = endp + vec;
	}
	if(ost.x >= 1.f){
		relat = (1.f - endp.x)/vec.x;
		vec *= relat;
		ost = endp + vec;
	}
	if(ost.y >= 1.f){
		relat = (1.f - endp.y)/vec.y;
		vec *= relat;
		ost = endp + vec;
	}
	if(ost.z >= 1.f){
		relat = (1.f - endp.z)/vec.z;
		vec *= relat;
		ost = endp + vec;
	}
	
	vec4 chk = voxel(ivec3(3,3,3));
	
	startp = ost*sizeV;
	if(startp.x < 0.5f*sizeV.x){startp.x -= shift;}else{startp.x += shift;}
	if(startp.y < 0.5f*sizeV.y){startp.y -= shift;}else{startp.y += shift;}
	if(startp.z < 0.5f*sizeV.z){startp.z -= shift;}else{startp.z += shift;}
	chk.rgb = startp;
	
	vec3 vRL1D;
	ivec3 vStep;
	ivec3 MCheck = ivec3(floor(startp));
	vec3 dirc = -dirv*sizeV;
	vec3 vRUSS;
	vRUSS.x = sqrt(1.f+(dirc.y/dirc.x)*(dirc.y/dirc.x)+(dirc.z/dirc.x)*(dirc.z/dirc.x));
	vRUSS.y = sqrt(1.f+(dirc.x/dirc.y)*(dirc.x/dirc.y)+(dirc.z/dirc.y)*(dirc.z/dirc.y));
	vRUSS.z = sqrt(1.f+(dirc.y/dirc.z)*(dirc.y/dirc.z)+(dirc.x/dirc.z)*(dirc.x/dirc.z));
	if(dirc.x < 0.f){
		vStep.x = -1;
		vRL1D.x = (startp.x - vec3(MCheck).x)*vRUSS.x;
	}else{
		vStep.x = 1;
		vRL1D.x = (vec3(MCheck).x - startp.x+1.f)*vRUSS.x;
	}
	if(dirc.y < 0.f){
		vStep.y = -1;
		vRL1D.y = (startp.y - vec3(MCheck).y)*vRUSS.y;
	}else{
		vStep.y = 1;
		vRL1D.y = (vec3(MCheck).y - startp.y+1.f)*vRUSS.y;
	}
	if(dirc.z < 0.f){
		vStep.z = -1;
		vRL1D.z = (startp.z - vec3(MCheck).z)*vRUSS.z;
	}else{
		vStep.z = 1;
		vRL1D.z = (vec3(MCheck).z - startp.z+1.f)*vRUSS.z;
	}
	bool bFound = false;
	float camDist = length(startp - (endp + dirv*dist)*sizeV);
	vec4 oColor = voxel(MCheck);
	float AShift = (camDist - 2.f)/2.f;
	if(AShift > 1.f) AShift = 1.f;
	if(AShift < 0.f) AShift = 0.f;
	oColor.a *= AShift;
	float Distance = 0.f;
	float DistMax = length(endp*sizeV - startp);
	int k = 0;
	ivec3 PCheck;
	vec3 oNormal;
	vec3 nNormal;
	while(!bFound && Distance < DistMax && oColor.a < 1.f && k < 3){
		PCheck = MCheck;
		if(vRL1D.x < vRL1D.y && vRL1D.x < vRL1D.z){
			MCheck.x += vStep.x;
			Distance = vRL1D.x;
			vRL1D.x += vRUSS.x;
		}else if(vRL1D.y < vRL1D.z && vRL1D.y < vRL1D.x){
			MCheck.y += vStep.y;
			Distance = vRL1D.y;
			vRL1D.y += vRUSS.y;
		}else{
			MCheck.z += vStep.z;
			Distance = vRL1D.z;
			vRL1D.z += vRUSS.z;
		}
		vec4 vColor = voxel(MCheck);
		AShift = (camDist+Distance-2.f)/2.f;
		if(AShift > 1.f) AShift = 1.f;
		if(AShift < 0.f) AShift = 0.f;
		vColor.a *= AShift;
		if(vColor.a > 0.f && voxel(PCheck).a < 0.01f){
			nNormal = vec3(PCheck - MCheck);
			oNormal = mix(nNormal,oNormal,oColor.a);
			oColor.rgb = mix(vColor.rgb,oColor.rgb,oColor.a);
			oColor.a += vColor.a;
			k += 1;
			if(oColor.a >= 1.f) oColor.a = 1.f;
		}
	}
//	return mat3(chk.rgb,vec3(0),vec3(chk.a));
	return mat3(oColor.rgb,oNormal,vec3(oColor.a,0.f,0.f));
}

void fragment() {
	vec3 dirv = normalize(cam - ver);
	float disn = distance(cam,ver);
	mat3 vox = intersect(COLOR.xyz,dirv,disn);
	ALBEDO = vox[0].rgb;
	ALPHA = vox[2].r;
	NORMAL = vox[1];
}