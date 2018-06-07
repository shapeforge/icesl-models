-- Sylvain Lefebvre 2018-06-06
-- MIT license

-- This is meant to be sliced using polyfoam with:
--   cover thickness = 0
--   0 shell

-- I recommend deactivating 'View => Execute script automatically' as the loops filling the fields are somewhat slow

r = 50
h = 5

set_setting_value('infill_type_0','Polyfoam')
set_setting_value('num_shells_0',0)
set_setting_value('cover_thickness_mm_0',0)

emit(cylinder(r,h))

-- Now we create fields by scripting
-- As of today all fields have to be 64x64x64

-- Allocate the fields as 3D textures, with a single 8 bit channel
density = tex3d_r8f(64,64,64)
angle   = tex3d_r8f(64,64,64)
shrink  = tex3d_r8f(64,64,64)

-- Fill them in
-- Values in 3D texture are always in [0,1], thus for
--   density, 0 is min, 1 is max
--   angle,   0 is 0 degree, 1 is 360 degrees
--   etc.
-- Only the first component of the textures is used ('red')
for i = 0,63 do
    for j = 0,63 do
        for k = 0,63 do
            delta = v(i,j,0) - v(31.5,31.5,0)
            a     = (180.0 + atan2(delta.x,delta.y)) / 360.0
            _,a     = math.modf(a+0.25) -- rotate 90 degree
            l     = length(delta) / 32.0
            density:set(i,j,k, v(0.1+0.4*l,0.0,0.0))
            angle  :set(i,j,k, v(a,0.0,0.0))
            shrink :set(i,j,k, v(0.05,0.0,0.0))
        end
    end
end

-- Set the 3D textures to the field settings
-- The binding requires a field (!), a bounding box where it is applied, and the internal name of the parameter (see tooltip in UI)
set_setting_value(density,v(-r,-r,0),v(r,r,h),'infill_percentage_0')
set_setting_value(angle,v(-r,-r,0),v(r,r,h),'infill_angle_0')
set_setting_value(shrink,v(-r,-r,0),v(r,r,h),'kgon_x_shrink_0')
