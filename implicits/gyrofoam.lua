gyro = implicit_distance_field(v(-30,-30,-30), v(30,30,30), [[
// Simple Gyroid Isosurface (spherical crop)
//
// Mikael Hvidtfeldt Christensen
// @SyntopiaDK
//
// License:
// Creative Commons Attribution
// http://creativecommons.org/licenses/by/3.0/

#define MinimumDistance 0.01
#define normalDistance     0.0002
#define PI 3.141592

float time = 0.0;

uniform float scale = 0.8;

float DE2(vec3 z) 
{ 
 z *= scale;
 z += vec3(0,5,-1);
 float base = (cos(z.x) * sin(z.y) + cos(z.y) * sin(z.z) + cos(z.z) * sin(z.x));
 float inverse = -base + (1.0+cos(time/4.0))*4.0;
 return min(base,inverse);
}


float distance(vec3 p) 
{
  return 0.3*DE2(p);
}

]])

c = ui_scalar('scale',1,0.1,2.0)
set_uniform_scalar(gyro,"scale",c)

emit(gyro)
