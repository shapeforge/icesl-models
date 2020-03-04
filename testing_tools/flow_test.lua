--###### Parametric Material Flow Test######--
-- by Pierre Bedell and Pierre-Alexandre Hugron--
                 --MFX Team--
                --03/03/2020--

-- Feel free to customize to test your own material.

--#################################################
-- internal functions

function round(number, decimals)
  local power = 10^decimals
  return math.ceil(number * power) / power
end

function gen_plate(value, size_x, size_y, size_z)
  if type(value) ~= "string" then -- convet value to string
    value = tostring(value)
  end
  local plate = cube(size_x, size_x, size_z)
  local text = translate(-size_x/3,-size_y/3,4*(size_z/5))*scale(1.6,1.6,size_z)*f:str(value, 1)
  return difference(plate,text)
end

--#################################################
-- settings

-- plate dimension
plate_th = ui_scalar("Plate thickness",1,0.1,1)
plate_size = ui_number("Plate size",30,20,50)

plates_spacing = ui_number("Plates spacing",5,0,10)

-- flow limits
min_flow = round(ui_scalar("Minimum flow",0.95,0.5,2.0),3)
max_flow = round(ui_scalar("Maximum flow",1.05,min_flow,2.0),3)
flow_step = round(ui_scalar("Flow step",0.01,0.01,0.1),3)

-- printer bed size (TODO: this will be fetched from a future get_setting_value("setting_name"))
bed_x_mm = 220
bed_y_mm = 220

extruder = 0

-- font importation
f = font(Path .. '../fonts/SourceSansPro-Regular.ttf')

--#################################################

nb_steps = math.floor((max_flow - min_flow) / flow_step)
plates_per_line = math.floor(bed_x_mm / (plate_size + plates_spacing))
nb_rows = math.ceil(nb_steps / plates_per_line)

remaining_steps = nb_steps
flow = min_flow
brush = 0

for i = 0, nb_rows do
  local steps = math.min(remaining_steps,plates_per_line-1)
  for j = 0, steps do
    local plate = gen_plate(round(flow,2),plate_size,plate_size,plate_th)
    emit(translate(j*(plate_size+plates_spacing),-i*(plate_size+plates_spacing),0)*plate,brush)

    set_setting_value('flow_multiplier_' .. brush, flow)
    set_setting_value('speed_multiplier_' .. brush, flow)
    set_setting_value("extruder_" .. brush, extruder)
    set_setting_value("infill_extruder_" .. brush, extruder)

    flow = flow + flow_step
    brush = brush + 1
    remaining_steps = remaining_steps - 1
  end
end

--#################################################
