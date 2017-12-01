gyro = implicit(v(-17,-17,-17), v(17,17,12), [[
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


float distanceEstimator(vec3 p) 
{
  return DE2(p);
}

]])

m = union{
  difference(gyro,translate(0,0,15)*sphere(17.0)),
  intersection(translate(0,0,15)*difference(sphere(17.0),sphere(12.0)),ccube(40,40,32)),
  translate(0,0,-17)*ccube(34,34,3)
} 

-- d = m

if not a then
  a = to_voxel_distance_field(m,0.4)
end

b = duplicate(a)

t = ui_scalar("iso",0.45,0.4,0.55)
set_distance_field_iso(b,t)
smooth_voxels_preserve_volume(b,5)

set_brush_color(0, 1,0.9,1)

--emit(a,0)
--emit(translate(-45,0,0)*m,0)

emit(translate( 40,0,0)*b)
