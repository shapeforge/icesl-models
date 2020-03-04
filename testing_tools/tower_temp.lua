--###### Parametric Tower Temperature Test######--
-- by Pierre Bedell and Pierre-Alexandre Hugron--
                 --MFX Team--
                --03/03/2020--

--Feel free to customize to test your own material.

--#################################################
-- settings

-- material / test name
material_name = "Generic PLA" 

-- temperature settings
min_temp = ui_number("Minimum temperature",190,150,270)
max_temp = ui_number("Maximum temperature",math.max(230,min_temp),min_temp,270)
temp_step = ui_number("Temperature step",5,1,50)

-- invert the order of the test (if true, temperatures will decrease along the z axis)
inverting = true

-- tower geometry settings
cube_size_x = ui_number("Pillard width",15,10,15)
cube_size_y = ui_number("Pillard depth",8,5,10)
cube_size_z = ui_number("Block height",8,5,10)

bridge_length = ui_number("Bridge length",math.max(30,cube_size_x+5),cube_size_x+5,100)
bridge_thickness = ui_scalar("Bridge thickness",1.0,0.1,1.0)

-- text settings
writing_depth = 1

writing_height = cube_size_z - 4 * (cube_size_z/10)
writing_scale_factor = writing_height / 2.5
writing_spacing = 0.1 * writing_scale_factor

-- font importation
f = font(Path .. '../fonts/SourceSansPro-Regular.ttf')

--#################################################
-- internal functions

function array_reverse(a)
	local i, j = 0, #a
	while i < j do 
		a[i], a[j] = a[j], a[i]
		i = i + 1
		j = j - 1
	end
end

function gen_text(value, depth, scaling, spacing)
	if type(value) ~= "string" then -- convet value to string
    value = tostring(value)
  end
	return scale(scaling,scaling,depth)*f:str(value, spacing)
end

function gen_block(value, size_x, size_y, size_z, bridge_ln, bridge_th)
	local pillar = union{
		cube(size_x/1.1,size_y/1.1,size_z/10),
		translate(0,0,size_z/10)*cube(size_x,size_y,size_z - size_z/10)
	}
	local bridge = cube(bridge_ln,size_y,bridge_th)
	local block = difference{
		union{
			translate(-(bridge_ln/2+size_x/2),0,0)*pillar, -- left pillar
			translate((bridge_ln/2+size_x/2),0,0)*pillar, -- right pillar
	  	translate(0,0,size_z-bridge_th)*bridge
		},
		translate(-((bridge_ln/2)+(size_x-writing_spacing*3)),-(size_y/2)+writing_depth,(size_z/10)*2)*rotate(90,0,0)*gen_text(value, writing_depth, writing_scale_factor, writing_spacing) -- temperature marking
	}
	return block
end

--#################################################

nb_blocks = (max_temp - min_temp) / temp_step

-- temperatures array
temps = {} 
for i = 0, nb_blocks do
	temps[i] = min_temp + i * temp_step
end

if inverting == true then
	array_reverse(temps)
end

tower = {}
temp_field = {}

--#################################################
-- part generation

for i = 0, nb_blocks do
  tower[i] = translate(0,0,i*cube_size_z)*gen_block(temps[i], cube_size_x, cube_size_y, cube_size_z, bridge_length, bridge_thickness)
  if i > 0 then
  	temp_field[i*cube_size_z] = temps[i-1]
  end
  temp_field[i*cube_size_z+0.1] = temps[i]
end

text = translate((bridge_length/2+cube_size_x/2) + cube_size_x/4 , -(cube_size_y/2) + writing_depth, cube_size_z/3)*rotate(90,-90,0)*gen_text(material_name, writing_depth, writing_scale_factor, writing_spacing)

tower = difference( union(tower), text)

emit(tower)

-- affect the generated values to the temperature field
set_setting_value("extruder_temp_degree_c_0", temp_field)

--#################################################
