--[[
  infill_distance_field.lua
  Author: Salim Perchy
  Modified: 14-01-2025
  
  Example to show the functionality of function 'texture3d_distance_field'.
  This function creates a 64x64x64 3D texture where its values are a
  distance filed calculated from some shape.
  
  Querying this 3D texture allows the user to create fields for settings
  based on the geometry being printed (or some other if the user intends to)
  Before, fields for settings where either painted using the mouse (inexact
  and cumbersome but quick if precision wasn't needed) or programmatically
  (difficult and slow but precise).
]]--

--[[ Main shape ]]--
-- Use your own shape here
brush = 0
shape = implicit_solid(v(-5,-5,-5), v(5,5,5), 0.25, [[
float solid(vec3 p) {
	return 0.01*(pow(sqrt(p.x*p.x+p.y*p.y)-3,2) + p.z*p.z-1);
}
]])
shape = scale(10) * shape
shape_bbox = bbox(shape)
emit(translate(shape_bbox:min_corner()) * ocube(shape_bbox:extent()), brush) 

--[[ Calculate distance field ]]--
shape_df_tex3D = texture3d_distance_field(shape)
-- Output texture is always 64x64x64 in size
-- Output values are in the range [0-1] where:
	-- 1: Closest to volume surface
	-- 0: Farthest from volume surface

--[[ Create density 3D texture ]]--
size_tex3D = 64 -- Do NOT change this. IceSL only supports 64x64x64 3D textures
density_field_0 = tex3d_r8f(size_tex3D, size_tex3D, size_tex3D)

for i = 0, shape_df_tex3D:w() - 1 do
	for j = 0, shape_df_tex3D:h() - 1 do
		for k = 0, shape_df_tex3D:d() - 1 do
			df_value = shape_df_tex3D:get(i, j, k)
			density = 0
			
			-- Code your own density calculation here
			if df_value.x > 0.99 then
				density = 0.1
			else
				density = 0.9
			end
			--
			
			density_field_0:set(i, j, k, v(density, 0, 0)) -- in r8f, only x coord. matters
		end
	end
end

--[[ Set infill density and other settings ]]--
set_setting_value('infill_type_'..brush, 'Polyfoam') -- infill
set_setting_value('infill_percentage_'..brush, density_field_0, shape_bbox:min_corner(), shape_bbox:max_corner()) -- infill density
-- only print infill, change if needed
set_setting_value('print_perimeter_0', false)
set_setting_value('num_shells_0', 0)
set_setting_value('cover_thickness_mm_0', 0)