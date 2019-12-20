-- Parametric Christmas Ball --
-- created By Pierre-Alexandre Hugron --
-- 18/12/2019 --

-- Feel free to modify this script for creating your own Christmas ornament! --

-- This model is printable with auto spiralise, if you change some geometry, it can be necesseray to use cavity function to make them printable.


-- slicing parameters --

set_setting_value("z_layer_height_mm",0.15)
set_setting_value("auto_spiralize",true)
set_setting_value("num_shells_0",0)
set_setting_value("print_perimeter_0",true)
set_setting_value("enable_different_top_bottom_covers_0",false)
set_setting_value("cover_thickness_top_mm_0",0)
set_setting_value("cover_thickness_bottom_mm_0",0.2)
set_setting_value("cover_filter_diameter_mm_0",2)
set_setting_value("infill_percentage_0",0)
set_setting_value("nozzle_diameter_mm_0",0.8)

-- geometry script --

base = sphere(35)
ex_base = sphere(40)
wing = translate(0,0,-38) *rotate(0,0,0) * cube(127,1.6,160)

n = 20

wings = {}
for i = 1 , n do 
  wings[i] = rotation(18*i,Z) * wing
end
all_wings = (union(wings))

summ = (intersection(all_wings,ex_base))
top = translate(0,0,34) * cone(7,6,8)


ball = (union{
   base,
   summ,
   top
})

emit(difference(ball, translate(0,0,-88)*cube(50)))
