enable_variable_cache = true

-- Rock --
rock = scale(1.0,0.7,0.3)*sphere(0.5)

-- Valley --
height = ui_scalar('Height', 6, 1, 8)
imp = implicit_distance_field(v(-4,-4,-4), v(4,4,10),
[[
uniform float h;
float distance(vec3 p)
{
  return 0.01*(p.z - h*p.x*exp(-0.4*(pow(p.x,2) + pow(p.y,2))));
}
]])
set_uniform_scalar(imp, 'h', height)
imp = scale(10,10,5)*imp
bx = bbox(imp)
bx:enlarge(1)

-- Sculpt --
f = ui_field('Sculpting',bx:min_corner(),bx:max_corner())
--f = ui_field('Sculpting',bx)
valley = intersection(imp,
  to_voxel_solid(f,
  bx:min_corner(),
  bx:max_corner()))
emit(valley,2)

-- Path --
ui_field('Path', bx:min_corner(), bx:max_corner())
if not s then
  s = distribute(imp, 0.5)
end
rocks = {}
for i=1,#s do
  local val = ui_field_value_at('Path', s[i][1])
  if val > 0.5 then
    rocks[#rocks+1] = 
      translate(s[i][1]) * 
      frame(s[i][2]) * 
      scale(s[i][3] * val) * 
      rock
  end
end
emit(merge(rocks),1)

ui_file(Path..'tutorial_paint_implicits.xml')

-- Mesh --
--if not mesh then
--  mesh = to_mesh_dual(union(valley, merge(rocks)), 0.1)
--  dump(mesh, 'tutorial.stl')
--end