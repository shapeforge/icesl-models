width = ui_scalar('Width (mm)', 28, 20, 40)
thickness = ui_scalar('Thickness (mm)', 1, 0.3, 2)

f = font(Path .. 'fonts/LiberationMono-Regular.ttf')
text = f:str('IceSL', 1)

c1 = v(0,0,0)
c2 = v(width,0,0)
c3 = v(width/2,(math.sqrt(3)/2) * -width,0)

cl1 = translate(c1) * cylinder(width,thickness)
cl2 = translate(c2) * cylinder(width,thickness)
cl3 = translate(c3) * cylinder(width,thickness)

tbox = bbox(text)
factor = (width / 1.5) / tbox:extent().x

shape = to_voxel_solid(I{cl1,cl2,cl3}, 0.1)
smooth_voxels(shape, 10)

emit(shape)
emit(
 translate(
   math.abs(factor * tbox:extent().x -width)/2,
  -factor * tbox:extent().y,
   thickness) *
 scale(
   factor,
   factor,
  (thickness / 2) / tbox:extent().z) *
text,0)

--[[ PRINTING SETTINGS ]]--
set_setting_value('add_brim', true)
set_setting_value('print_speed_mm_per_sec', 20)
set_setting_value('perimeter_print_speed_mm_per_sec', 20)
set_setting_value('z_layer_height_mm', 0.2)
set_setting_value('process_thin_features', true)
set_setting_value('num_shells_0', 0)
set_setting_value('cover_thickness_mm_0', 1.0)
set_setting_value('infill_percentage_0', 100)
set_setting_value('fill_tiny_gaps_0', true)
set_setting_value('enable_curved_covers_0', true)
set_setting_value('print_perimeter_0', true)
