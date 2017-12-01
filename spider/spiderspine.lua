-- (c) Sylvain Lefebvre - INRIA - 2013

dofile(Path .. '../libs/gear.lua')
dofile(Path .. 'spiderglobals.lua')

axelpos = rotate(30,Y) * v(leverlen,0,0)

ground = 
    translate(0,-spacing*4,-20-leverlen+bore+1)
  * scale(leverlen*4,spacing*18,40) 
  * translate(0,0.5,0) 
  * box(1)

function spiderspine()
    wheel2 = rotate(90,0,0) * -- cylinder(wheel_radius,thickness)
	         union( cone(wheel_radius,wheel_radius*1.1,thickness/2),
			        translate(0,0,thickness/2) * cone(wheel_radius*1.1,wheel_radius,thickness/2)
				)
    axel2 = rotate(-90,0,0) * union({
	   translate(axel_bevel*Z) * cylinder(bore,leg_attach_thickness),
	   cone(bore*axel_bevel_ratio,bore,axel_bevel),
	   translate((axel_bevel+leg_attach_thickness)*Z) * cone(bore,bore*axel_bevel_ratio,axel_bevel)
	 })
	all = {}
    wheelpos = 0
	for i=1,3 do
	  n = i
	  if i > 3 then
	    n = 7-i
	  end
	  axelrotpos = rotate(120*n,Y) * axelpos
	  table.insert(all, translate(0,wheelpos,0) * wheel2 )
	  clamp = translate(0,wheelpos,0) 
	        * rotate(-90,0,0) * cylinder(wheel_radius,leg_spacing)
	  table.insert(all, intersection(clamp,
	        translate(0,wheelpos,0) * translate(axelrotpos) * axel2) )
	  wheelpos = wheelpos + leg_spacing + thickness
	end
    table.insert(all, translate(0,wheelpos,0) * wheel2 )
    -- intermediate space
	clamp = translate(0,wheelpos,0) 
	        * rotate(-90,0,0) * cylinder(wheel_radius,leg_spacing)
	table.insert(all, intersection(clamp,
	             translate(0,wheelpos,0) * translate(rotate(0  ,Y) * axelpos) * axel2 ) )
	table.insert(all, intersection(clamp,
	             translate(0,wheelpos,0) * translate(rotate(120,Y) * axelpos) * axel2 ) )
	table.insert(all, intersection(clamp,
		         translate(0,wheelpos,0) * translate(rotate(240,Y) * axelpos) * axel2 ) )
	wheelpos = wheelpos + leg_spacing + thickness
	for i=4,6 do
	  n = i
	  if i > 3 then
	    n = 7-i
	  end
	  axelrotpos = rotate(120*n,Y) * axelpos
	  table.insert(all, translate(0,wheelpos,0) * wheel2 )
	  clamp = translate(0,wheelpos,0) 
	        * rotate(-90,0,0) * cylinder(wheel_radius,leg_spacing)
	  table.insert(all, intersection(clamp,
	        translate(0,wheelpos,0) * translate(axelrotpos) * axel2) )
	  wheelpos = wheelpos + leg_spacing + thickness
	end
    table.insert(all, translate(0,wheelpos,0) * wheel2 )
    -- side axels
	axel_side = rotate(90,0,0) * union({
	   cylinder(bore_side,axel_side_length),
	   translate(0,0,axel_side_length) * cylinder(wheel_radius/1.5,thickness),
	   -- translate(0,0,axel_side_length+thickness)*cone(bore_side,2,0.5*axel_side_length),
	   translate(0,0,axel_side_length+thickness) 
	     * scale(bore_side,wheel_radius,1) 
	     * translate(0,-0.5,0.5) * box(1),
	   translate(0,0,axel_side_length+thickness) 
	     * scale(bore_side,bore_side,square_axel_len) 
	     * translate(0,0,0.5) * box(1)
	   })
	-- add support
	support = translate(0,-(axel_side_length+thickness*2+square_axel_len),-bore_side/2) *
	 union({ scale(bore_side*2,0.45,wheel_radius) * translate(0,0.5,-0.5) * box(1),
		     translate(bore_side,-bore_side,0) * scale(0.45,bore_side*2,wheel_radius) * translate(0,0.5,-0.5) * box(1),
			 translate(-bore_side,-bore_side,0) * scale(0.45,bore_side*2,wheel_radius) * translate(0,0.5,-0.5) * box(1) 
		   })
    axel_side = union(translate(-thickness*Y) * axel_side,support)
	-- add both sides
    table.insert(all, axel_side)
    table.insert(all, translate((-thickness*2+inner_length)*Y) * mirror(Y) * axel_side)
	-- emit
	return (difference(union(all),ground))
	-- return union( support, translate((-thickness*2+inner_length)*Y) * mirror(Y) * support )
	-- return support
end

function spiderlegguide()
	holder = union({
	                               cone(7,10,axel_bevel),
	   translate(0,0,axel_bevel) * cylinder(10,thickness),
	   translate(0,0,axel_bevel+thickness) * cone(10,7,axel_bevel)
	   })
    holder = rotate(90,0,0) * difference( 
	    holder,
		cylinder(bore+tolerance,axel_bevel*2+thickness) )
	wheelpos = axel_bevel
	all = {}
	table.insert(all,  translate(0,wheelpos,0) * holder )
	for i=1,7 do
	  wheelpos = wheelpos + leg_spacing + thickness
	  table.insert(all, translate(0,wheelpos,0) * holder )
	end
	-- erase sides
	sides = rotate(90,0,0) * union(
	   translate(0,0,thickness) * cylinder(10,thickness),
	   translate(0,0,-inner_length) * cylinder(10,thickness)
	   )
	all = difference(union(all),sides)
	-- add bar below
	barw = 10
	btm = translate(0,-thickness/2,-3-barw/2-tolerance)
     	* scale(7,wheelpos+5,3)
  	    * translate(0,0.5,0.5) * box(1)
    all = union( all, btm )
    return( difference(translate(0,0,1) * all,ground) )
end

function spiderspinegear()
-- create handle
	-- emit(cylinder(15,4))
	handle = translate(0,0,0) *
	gear{
	   circular_pitch=350,
	   gear_thickness=5,
	   rim_thickness=4,
	   rim_width=1,
	   hub_thickness=5,
	   hub_diameter=10,
	   circles=0,
	   bore_diameter=0}
	square_bore = scale(bore_side,bore_side,8) * translate(0,0,0.5) * box(1)
	square_bore = union( square_bore, 
	   translate(0,0,4) * 
	   scale(bore_side,wheel_radius*1.5,1) * translate(0,0.5,0.5) * box(1) )
	unglue = mirror(Y) * rotate(10,X) * translate(-1,0,-3) *
	   scale(wheel_radius*1.5,wheel_radius*1.5,1) * translate(0,0.5,0.5) * box(1)
	handle = difference({ handle, square_bore, unglue })
	return (handle)
	-- emit(unglue)
end

spineanchor = v(0,-thickness+axel_side_length/2+inner_length,0)
-- emit( translate(spineanchor) * sphere(4) )

-- emit( spiderspine() )
-- emit( spiderlegguide() )
-- emit( spiderspinegear() )
