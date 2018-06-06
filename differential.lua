dofile(Path .. 'libs/gear.lua')
dofile(Path .. 'libs/pins.lua')

-- compute cone distance for small gears, given all other params

n1 = 10
n2 = 22
cp = 180

cd2 = 12
cd1 = (n1*cp) / (2*180*sin(90 - asin(n2*cp/(2*180*cd2)) ) )

params_b = {
    number_of_teeth=n1,
    bore_diameter=0,
	cone_distance=cd1,
	outside_circular_pitch=cp,
	face_width=6}

params_g = {
    number_of_teeth=n2,
    bore_diameter=0,
	cone_distance=cd2,
	outside_circular_pitch=cp,
	face_width=5,
	finish=1}
	
apex_b = bevel_gear_pitch_apex(params_b)

b = bevel_gear(params_b)
b = union( b , translate(0,0,-3.5) * cylinder(2,4) )

g = bevel_gear(params_g)
apex_g = bevel_gear_pitch_apex(params_g)

b = translate(0,0,-apex_b) * b

tolerance = 0.1

gb = translate(0,0,-apex_g) * g
gb = difference(gb,translate(0,0,-apex_g-13) * scale(40,40,20) * box(1))
gb = union(gb,translate(0,0,-apex_g-2) * cylinder(5,apex_g+2-tolerance*2))

pd=4.5
pt=1.0
peg = pinpeg{h=apex_g*2-2.0,r=pd/2-tolerance,lt=pt-tolerance}
pin = translate(0,0,-apex_g/2-0.4) * pinhole{h=apex_g/2,r=pd/2,tight=true, lt=pt}
gb = difference(gb,pin)

b_clear = union( cone(n1*cp/180,0,apex_b) , 
                 translate(0,0,-5) * cylinder(2+tolerance,10) )
side_box = translate(10,0,0) * scale(5,20,20) * box(1)
b_clear = difference({ b_clear, side_box, mirror(X) * side_box})
b_clear = difference( b_clear, side_box )
clearance = union({
  translate(0,0,-apex_b) * b_clear,
  rotate(0,120,0) * translate(0,0,-apex_b) * b_clear,
  rotate(0,240,0) * translate(0,0,-apex_b) * b_clear
})

b_clear_big = cone(n1*cp/180*2,0,apex_b*2)
b_clear_big = difference({ 
     b_clear_big, 
     translate(0,0,apex_b) * side_box, 
     mirror(X) * translate(0,0,apex_b) *side_box })
clearance_big = union({
  translate(0,0,-apex_b*2) * b_clear_big,
  rotate(0,120,0) * translate(0,0,-apex_b*2) * b_clear_big,
  rotate(0,240,0) * translate(0,0,-apex_b*2) * b_clear_big
})

-- clear_box = translate(0,0,-19) * scale(20,20,10) * box(1)
-- clearance_box = union({
  -- clear_box,
  -- rotate(0,120,0) * clear_box,
  -- rotate(0,240,0) * clear_box
-- })

trsf = rotate(90,0,0) * translate(0,0,-3.5)
inside = difference(trsf * cylinder(13,7) , clearance_big)
belt = difference( trsf * cylinder(15,7) , clearance )
-- belt = difference( belt, union(clearance,clearance_box) )
belt = difference( belt, inside )

function assembled()

emit( b )
--emit( rotate(0,120,0) * b )
--emit( rotate(0,240,0) * b )
emit( rotate(90,0,0) * rotate(90,0,0) * translate(0,0,-3/2) * peg )
emit( rotate(90,0,0) * gb )
--emit( mirror(Y) * rotate(90,0,0) * gb )
emit( belt )

end

function plate()

emit( rotate(180,0,0) * b )
emit( translate(15,0,0) * rotate(180,0,0) * b )
emit( translate(-15,0,0) * rotate(180,0,0) * b )
emit( translate(13,-19,0) * translate(0,0,apex_g+13-4) * gb )
emit( translate(-13,-19,0) * translate(0,0,apex_g+13-4) * gb )
emit( translate(0,25,9.5) * rotate(90,0,0) * belt )
emit( translate(0,25,apex_g/2+pd-pt/2) * peg )

end

--emit( clearance_big )
--emit(inside)
--emit( clearance )
--emit( b_clear )
--emit( side_box ) 
--emit(clearance)
--emit( belt ) 

--assembled()
plate()
