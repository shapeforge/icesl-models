-- Sylvain Lefebvre 2018-06-06
-- MIT license

-- This is meant to be sliced using a mixing nozzle:

sz = 15

emit(cube(sz))

-- Now we create a color field by scripting

-- Allocate the field as a 3D texture
-- As of today all fields have to be 64x64x64

ratios = tex3d_rgb8f(64,64,64)

-- Fill them in
-- Values in 3D texture are always in [0,1]
-- The texture can hold up to three components
-- For mixing ratios the sum of the three should be exactly 1
for i = 0,63 do
    for j = 0,63 do
        for k = 0,63 do
            r0 = i/63.0
            r1 = j/63.0
            r2 = k/63.0 - 0.5*r1
            ratios:set(i,j,k, v(r0,r1,r2) / (r0+r1+r2))
        end
    end
end

-- Bind the 3D texture to the field
-- The binding requires a field (!), a bounding box where it is applied, and the internal name of the parameter (see tooltip in UI)
set_setting_value(ratios,v(-sz/2,-sz/2,-sz/2),v(sz/2,sz/2,sz/2),'micro_mixing_field')
