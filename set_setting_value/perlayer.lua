emit(difference(sphere(15),translate(0,0,-15)*cube(30,30,15)))

set_setting_value('z_layer_height_mm',{[0.0]=0.3,[3.5]=0.2,[12]=0.1})
set_setting_value('extruder_mix_ratios_0',{0.3,0.5})
set_setting_value('extruder_mix_ratios_1',{[0.0]={1,0},[3.5]={0,1},[12]={0.5,0.5}})
