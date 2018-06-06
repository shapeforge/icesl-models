-- Sylvain Lefebvre 2018-06-06
-- MIT license

-- This is meant to be sliced using polyfoam with:
--   cover thickness = 0
--   0 shell

-- I recommand deactivating 'View => Execute script automatically' as the loops filling the scripts are somewhat slow

r = 50
h = 5

emit(cylinder(r,h))

-- Now we create fields by scripting
-- As of today all fields have to be 64x64x64

-- Allocate the field as 3D textures
density = tex3d_r8f(64,64,64)
angle   = tex3d_r8f(64,64,64)
shrink  = tex3d_r8f(64,64,64)

-- Fill them in
-- Values in 3D texture are always in [0,1], thus for
--   density, 0 is min, 1 is max
--   angle,   0 is 0 degree, 1 is 360 degrees
--   etc.
-- The texture can hold three compoments, only the first is used
-- in most cases.
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

-- Bind the 3D texture to the fields
-- The binding requires a field (!), a bounding box where it is applied, and the internal name of the parameter (see tooltip in UI)
bind_tex3d_to_setting(density,v(-r,-r,0),v(r,r,h),'infill_percentage_0')
bind_tex3d_to_setting(angle,v(-r,-r,0),v(r,r,h),'infill_angle_0')
bind_tex3d_to_setting(shrink,v(-r,-r,0),v(r,r,h),'kgon_x_shrink_0')
