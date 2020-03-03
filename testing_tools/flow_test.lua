--###### Parametric Material Flow Test######--
-- by Pierre Bedell and Pierre-Alexandre Hugron--
                 --MFX Team--
                --03/03/2020--

-- Feel free to customize to test your own material.

-- plate dimension
plate_th = ui_scalar("Plate thickness",1,0.1,1)
plate_size = ui_scalar("Plate size",30,20,50)

plates_spacing = ui_scalar("Plates spacing",5,0,10)

-- flow limits
min_flow = 0.95
max_flow = 1.05
flow_step = 0.01

-- font importation
f = font(Path .. '../fonts/SourceSansPro-Regular.ttf')

--#################################################

function gen_plate(s)
  local plate = cube(plate_size, plate_size, plate_th)
  local text = translate(-plate_size/3,-plate_size/3,4*(plate_th/5))*scale(1.6,1.6,plate_th)*f:str(s, 1)
  return difference(plate,text)
end

--#################################################

nb_steps = (max_flow - min_flow) / flow_step
half_steps = (nb_steps/2) - flow_step
flow = min_flow
brush = 0

for i = 0, half_steps do
  emit(translate(i * (plate_size + plates_spacing),0,0)*gen_plate(tostring(flow)),brush)
  set_setting_value('flow_multiplier_' .. brush, flow)
  set_setting_value('speed_multiplier_' .. brush, flow)
  flow = flow + flow_step
  brush = brush + 1
end

for j = half_steps, nb_steps do
  emit(translate((j - nb_steps / 2) * (plate_size + plates_spacing),-(plate_size + plates_spacing),0)*gen_plate(tostring(flow)),brush)  
  set_setting_value('flow_multiplier_' .. brush, flow)
  set_setting_value('speed_multiplier_' .. brush, flow)
  flow = flow + flow_step
  brush = brush + 1
end

--#################################################
