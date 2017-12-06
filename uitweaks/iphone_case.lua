c = load_centered(Path .. 'iPhone_case_v2.stl')

b = translate(0,-5,-4)*ccube(50,90,5)

if ui_scalar then
  strength = ui_scalar('strength',2.0, 0.0,5.0)
  scale = ui_scalar('scale',1.0, 1.0,10.0)
  noisy = ui_scalar('noisy',2.0, 0.0,5.0)
  angle = ui_scalar('angle',45.0, 0.0,180.0)
  type = ui_scalar('type',1.0, 0.0,1.0)
  thick = ui_scalar('thick',0.0, -1.0,1.0)
else
  strength = 2.0
  scale = 1.0
  noisy = 2.0
  angle = 45.0
  type = 1.0
  thick = 0.0
end

if type < 0.5 then
imp = implicit(v(-55,-55,-6), v(55,55,-3), [[
uniform float scale;
uniform float strength;
uniform float noisy;
uniform float thick;
float perturb(vec3 p)
{
  return (noise(p));
}
float distanceEstimator(vec3 p)
{
  return (sin(p.x*scale + perturb(vec3(p.xy,p.z)*noisy/50.0)*strength) - thick);
}
]])
else
imp = implicit(v(-55,-55,-6), v(55,55,-3), [[
uniform float scale;
uniform float strength;
uniform float noisy;
uniform float thick;
float perturb(vec3 p)
{
  return (noise(p));
}
float distanceEstimator(vec3 p)
{
  p = p + vec3(perturb(p*noisy/40.0),perturb(p.yxz*noisy/40.0),0)*strength;
  ivec2 ij = ivec2(p.xy*scale/10.0);
  float d  = 1000.0;
  for (int j = ij.y - 1 ; j < ij.y + 1 ; j++) {
    for (int i = ij.x - 1 ; i < ij.x + 1 ; i++) {
	  d = min(d,length(p.xy*scale/10.0 - vec2(i+0.5,j+0.5)));
    }
  }
  return (0.5-d+(thick-1.0)*0.1)*4.0;
}
]])
end

set_uniform_scalar(imp,'thick',thick)
set_uniform_scalar(imp,'scale',scale)
set_uniform_scalar(imp,'noisy',noisy)
set_uniform_scalar(imp,'strength',strength)

emit(union{ intersection(rotate(angle,Z)*imp,c), difference(c,b) })
--set_brush_color(0, 0.8, 0.3, 0.3)
