--###### Parametric Tower Temperature Test######--
-- by Pierre Bedell and Pierre-Alexandre Hugron--
                 --MFX Team--
                --03/03/2020--

--Feel free to customize to test your own material.

-- material / test name
material_name = "Generic PLA" 

-- temperature settings
min_temp = 190
max_temp = 230
temp_step = 5

-- invert the order of the test (if true, temperatures will decrease along the z axis)
inverting = true

-- tower geometry settings
cube_size_x = ui_scalar("Pillard width",15,10,30)
cube_size_y = ui_scalar("Pillard depth",8,5,20)
cube_size_z = ui_scalar("Block height",8,5,20)

bridge_length = ui_scalar("Bridge length",50,10,100)
bridge_th = ui_scalar("Bridge thickness",1.0,0.1,5)

-- text settings
writing_depth = 1
writing_scale_factor = 1.5

-- font importation
f = font(Path .. '../fonts/SourceSansPro-Regular.ttf')

--#################################################

nb_blocks = (max_temp - min_temp) / temp_step

function gen_text(s)
	return scale(writing_scale_factor,writing_scale_factor,writing_depth)*f:str(s, 1)
end

function array_reverse(a)
	local i, j = 0, #a
	while i < j do 
		a[i], a[j] = a[j], a[i]
		i = i + 1
		j = j - 1
	end
end

function gen_block(temp)	
	local block = difference{
		union{
			translate(-bridge_length/2,0,0)*cube(cube_size_x,cube_size_y,cube_size_z), -- left cube 
	  	translate(-bridge_length/2,0,-cube_size_z/10)*cube(cube_size_x/1.1,cube_size_y/1.1,cube_size_z/10),
			translate(bridge_length/2,0,0)*cube(cube_size_x,cube_size_y,cube_size_z), -- right cube
			translate(bridge_length/2,0,-cube_size_z/10)*cube(cube_size_x/1.1,cube_size_y/1.1,cube_size_z/10),
	  	translate(0,0,cube_size_z-bridge_th)*cube(bridge_length,cube_size_y,bridge_th), -- bridge
		},
		translate(-bridge_length/2 - cube_size_x/3 , -(cube_size_y/2) + writing_depth, cube_size_z/3)*rotate(90,0,0)*gen_text(tostring(temp)), -- temperature marking
	}
	return block
end

function gen_tower(temp_array, material_string)
	local tower = {}
	local temp_field = {}

	if inverting == true then
		array_reverse(temp_array)
	end

	for i = 0, nb_blocks do
	  tower[i] = translate(0,0,i*(cube_size_z+cube_size_z/10))*gen_block(temp_array[i])
	  if i > 0 then
	  	temp_field[i * (cube_size_z + cube_size_z/10)] = temp_array[i-1]
	  end
	  temp_field[i * (cube_size_z + cube_size_z/10) + 0.1] = temp_array[i]
	end

	local text = translate(bridge_length/2 + cube_size_x/4 , -(cube_size_y/2) + writing_depth, cube_size_z/3)*rotate(90,-90,0)*gen_text(material_string)

	tower = difference( union(tower), text)
	
	return tower, temp_field
end

--#################################################

-- temperatures array
temps = {} 
for i = 0, nb_blocks do
	temps[i] = min_temp + i * temp_step
end

-- part generation
tower, temp_field = gen_tower(temps,material_name)

emit(tower)

-- affect the generated values to the temperature field
set_setting_value("extruder_temp_degree_c_0", temp_field)

--#################################################
