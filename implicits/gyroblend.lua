gyro = implicit(v(-10,-10,-10), v(10,10,10), [[
// Simple Gyroid Isosurface (spherical crop)
//
// Mikael Hvidtfeldt Christensen
// @SyntopiaDK
//
// License:
// Creative Commons Attribution
// http://creativecommons.org/licenses/by/3.0/

uniform float scale  = 1.0;
uniform float smoothing = 0.1;

// blending adapted from https://github.com/AbFab3D/AbFab3D/blob/master/src/java/abfab3d/core/MathUtil.java

float blendQuadric(float x)
{
  return (1. - x)*(1. - x) * 0.25;
}

float blendMax(float a, float b, float w)
{
  float dd = max(a,b);
  float d  = abs(a-b);
  if( d <  w)  return (dd + w*blendQuadric(d/w));
  else         return dd;
}

float gyro(vec3 z) 
{ 
 z *= scale;
 z += vec3(0,5,-1);
 float base = (cos(z.x) * sin(z.y) + cos(z.y) * sin(z.z) + cos(z.z) * sin(z.x));
 float inverse = -base + 1.0*4.0;
 return 0.5 * min(base,inverse);
}

float sphere(vec3 p)
{
  return length(p) - 10.0;
}

float distance(vec3 p) 
{
  // return sphere(p); // sphere alone
  // return gyro(p); // gyro alone
  //return max(sphere(p),gyro(p)); // 'hard' intersection
  return blendMax(sphere(p),gyro(p),smoothing);
}

]])

set_uniform_scalar(gyro,'scale',ui_scalar('gyro scale',0.8,0.1,2.0))
set_uniform_scalar(gyro,'smoothing',ui_scalar('smoothness',1.0,0.01,2.0))

emit(gyro)
