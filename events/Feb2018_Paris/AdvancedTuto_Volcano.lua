enable_variable_cache = true

-- Valley : implicit_distance_field 
--    The volume is defined as points P verifying distance(P)<=0
--    intersected with a bounding box.
--    The function 'distance' is defined in the glsl language.
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

-- Sculpting a cavity --

bx = bbox(imp)
bx:enlarge(1)

-- after selecting "Paint Field/Peindre volume", select on the right slider 
-- the value to be used: smaller than 0.5 means adding material, greater means removing
-- since we're doing an intersection, only the removed material will initially have impact 
-- on the resulting shape 
f = ui_field('Sculpting',bx:min_corner(),bx:max_corner())
valley = intersection(imp,
  to_voxel_solid(f,
  bx:min_corner(),
  bx:max_corner()))
emit(valley,2)

-- Rocks distribution --

rock = scale(1.0,0.7,0.3)*sphere(0.5)

--if not s then -- only computed once (require enable_variable_cache = true)
  -- if valley is modified previous 'if not s then' should be commented out to allow recomputation  
  s = distribute(valley, 0.5)
--end
-- s is a table containing the candidate positions for the rocks
-- distributed over the shape valley (increasing the second parameter 
-- will increase the density)
-- each entry in the table contains :
--	1: a position
--	2: the normal to the surface at the given point
--	3: the distance to closest points registered in s

ui_field('Path', bx:min_corner(), bx:max_corner())
-- used to define the area where rocks should be placed

rocks = {}
for i=1,#s do
  local val = ui_field_value_at('Path', s[i][1])
  if val > 0.5 then -- removing the condition allows to better understand the way 'distribute' works
    rocks[#rocks+1] = 
      translate(s[i][1]) * 
      frame(s[i][2]) * 
      scale(s[i][3] * val) * 
      rock
  end
end
emit(merge(rocks),1)

ui_file(Path..'AdvancedTuto_Volcano.xml') -- allows to save and load values defined thanks to the 'ui_...' objects


-- Mesh --
--if not mesh then
--  mesh = to_mesh_dual(union(valley, merge(rocks)), 0.1)
--  dump(mesh, 'tutorial.stl')
--end
