-- Image filename (replace this with your own image)
image_file = Path..'beethoven.jpg'

-- Print size of largest image axis (mm)
print_extent = ui_number('Size (mm)', 100, 50, 200)

-- Nozzle diameter and layer thickness influences quality level with Optizor
nozzle_diameter = 0.4
layer_thickness = 0.2

-- settings to allow infill to be visible and well printed (brush 0)
set_setting_value('nozzle_diameter_mm_0', nozzle_diameter)
set_setting_value('z_layer_height_mm', layer_thickness)
set_setting_value('cover_thickness_mm_0', 0)
set_setting_value('num_shells_0', 0)
set_setting_value('print_perimeter_0', true)
set_setting_value('force_backtrack_0', false)
set_setting_value('max_backtrack_len_mm_0', 1)
set_setting_value('travel_max_length_without_retract', 0.8)
set_setting_value('enable_z_lift', true)
set_setting_value('travel_straight', true)
set_setting_value('add_brim', true)

-- settings to produce sturdy base (brush 1)
set_setting_value('infill_type_1', 'Automatic')
set_setting_value('infill_percentage_1', 100)
set_setting_value('num_shells_1', 2)
set_setting_value('cover_thickness_mm_1', layer_thickness * 2)
set_setting_value('print_perimeter_1', true)

-- optizor settings
set_setting_value('infill_type_0', 'Optizor')
set_setting_value('infill_percentage_0', 100)
set_setting_value('optizor_image_field_0', image_file)

-- Geometry
image_matrix = load_image(image_file)
image_x_res = #image_matrix[1]
image_y_res = #image_matrix
if image_x_res > image_y_res then
	image_ratio = image_y_res / image_x_res
	emit(cube(print_extent, image_ratio * print_extent, layer_thickness))
	emit(translate(0,0,-2 * layer_thickness) * cube(print_extent, image_ratio * print_extent, layer_thickness * 2), 1)
else
	image_ratio = image_x_res / image_y_res
	emit(cube(print_extent * image_ratio, print_extent, layer_thickness))
	emit(translate(0,0,-2 * layer_thickness) * cube(print_extent * image_ratio, print_extent, layer_thickness * 2), 1)
end