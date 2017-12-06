dofile(Path .. '../libs/gear.lua')

cpitch = 350

numt1 = math.floor(ui_scalar('num teeth 1',13, 5,23))
numt2 = math.floor(ui_scalar('num teeth 2',7, 5,23))

rd = 2 + 0.5 * (numt1 + numt2) * cpitch / 180

gear1 = gear{
       number_of_teeth=numt1,
	   circular_pitch=cpitch,
	   gear_thickness=7,
	   rim_thickness=7,
	   rim_width=4,
	   hub_thickness=5,
	   hub_diameter=10,
	   circles=0}

gear2 = gear{
       number_of_teeth=numt2,
	   circular_pitch=cpitch,
	   gear_thickness=7,
	   rim_thickness=7,
	   rim_width=4,
	   hub_thickness=5,
	   hub_diameter=10,
	   circles=0}
if numt2 % 2 == 0 then
  gear2 = rotate(0,0,0.5*360/numt2)*gear2
end
	   
	   
emit(gear1)
emit(translate(rd,0,0)*gear2)
