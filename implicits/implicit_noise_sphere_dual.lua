sphA = implicit_distance_field(v(-30,-30,-30), v(30,30,30), [[
float perturb(vec3 p)
{
  return 5.0*abs(noise(p/7.0+2.0));
}
float distance(vec3 p) 
{
  return 0.3*(max(sphere(p,26),-sphere(p,23)) + perturb(p));
}
]])

sphB = implicit_distance_field(v(-30,-30,-30), v(30,30,30), [[
float perturb(vec3 p)
{
  return 4.0*abs(noise(p/7.0+2.0));
}
float distance(vec3 p) 
{
  return 0.3*(sphere(p,25.5) + perturb(p));
}
]])
emit(difference{sphA,sphere(21),translate(0,0,-30)*cube(61,61,7)})
emit(difference{sphB,sphere(21),translate(0,0,-30)*cube(61,61,7)},1)

set_brush_color(0, 1,1,1)
set_brush_color(1, 0.3,0.7,1)
