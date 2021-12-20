-- Parametric Spiralised Christmas Tree --
-- created by Pierre-Alexandre Hugron --
-- 20/12/2021 -- 

-- Feel free to modify this script for creating your own Christmas ornament! --

-- This model is printable with auto spiralise, if you change some geometry, it can be necesseray to use cavity function to make them printable.


-- geometry script

-- cube Dimensions
len = 20
width = 20
height = 20

-- tree Parameters
max_value = 90
height_rep = 17
angle_offset = 25
angle_step = 360 / max_value

--#################################################

function  tree_layer( len,width, height,max_value,angle_offset,sf)
  local geom = {}
  local a = translate(sf*110,0,0)*rotate(-45,-45,0)*cube(width,len,height)
  local angle_step = 360 / max_value
  for i = 1, max_value do
    
    geom[#geom+1] = rotate(0,0,i * angle_step+ angle_offset)*a
  end
  return union(geom)
end

for i  = 1, height_rep do
  scale_factor = 1-((i-1)/(1.0*height_rep))
  test = 1-((i-1)/(1.0*height_rep))
emit (translate(0,0,(i*height)*1)*tree_layer(len,width,height,test*max_value,(i-1)/(1.0*height_rep)*angle_step,scale_factor))
end

--################################################

-- cone Dimensions
--needs to be set manualy to avoid holes inside the model

emit(cone(117,6.5,365))

-- sclicing parameters

set_setting_value("z_layer_height_mm", 0.3)
set_setting_value("print_speed_mm_per_sec", 30)
set_setting_value("perimeter_print_speed_mm_per_sec", 30)
set_setting_value("auto_spiralize", true)
set_setting_value("num_shells_0", 0)
set_setting_value("cover_thickness_mm_0", 0)
set_setting_value("nozzle_diameter_mm_0", 0.8)