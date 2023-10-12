emit(cube(100,100,1), 0.3)

-- Nozzle diameter influences quality level with Optizor
nozzle_diameter = 0.4

-- settings to allow infill to be visible
set_setting_value('z_layer_height_mm', 0.3) 
set_setting_value('cover_thickness_mm_0', 0)
set_setting_value('nozzle_diameter_mm_0', nozzle_diameter)
set_setting_value('num_shells_0', 0)
set_setting_value('print_perimeter_0', false)
set_setting_value('add_brim', true)

-- optizor settings
set_setting_value('infill_type_0', 'Optizor')
set_setting_value('infill_percentage_0', 100)
set_setting_value('optizor_image_field_0', Path..'beethoven.jpg')