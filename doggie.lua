-- Doggie
-- 29/08/2012 original scad by Trev Moseley
-- 29/09/2012 sylefeb: changed ball joint for easier mounting/manipulation
-- 01/02/2013 sylefeb: ported to IceSL

scl = 2
hdScl = 1.5
ball = 1.9
sck = 1.96
dome = 2.9
supp = 0.25

function unit_cube()
  return ocube(1)
end

function center_cylinder(r,h)
  return translate(0,0,-h/2) * cylinder(r,h)
end

function fleg()
	return scale(scl) *
	(	
		difference( {
			union( {
				translate(0,0,dome-sck) * sphere(dome),	-- shoulder
				translate(0.1,-1,1.5) * rotate(50,-20,-20) *
				union ( {
					cone(1.5,1,10),						-- leg
					translate(0,0,10) *	sphere(1.5)		-- foot
				} )
			} ),
			translate(-4,-4,-8) * scale(8) * unit_cube(),	-- cut in half
			translate(0,0,sck/2) * sphere(sck),				-- socket
			translate(0.7,0.7,-1.0) * rotate(0,0,-15) * scale(4) * unit_cube()	-- slice for easier fit
		} )
	)
end


function bleg()
	return scale(scl) *
	(
		difference( {
			union( {
				translate(0,0,dome-sck) * sphere(dome),	-- shoulder
				translate(-1.0,0,1) * rotate(60,10,20) *
					union ({
						cone(1.7,1.4,6),					--thigh
						translate(0,0,6) * sphere(1.4),			--knee
						translate(0,0,6) * rotate(0,-45,0) *
						union ({
							cone(1.4,1,7),
							translate(0,0,7) * sphere(1.5),
						})
					})
			} ),
			translate(-4,-4,-8)	* scale(8) * unit_cube(),	-- cut in half
			translate(0,0,sck/2) * sphere(sck),				-- socket
			translate(0,-0.75,-1) * rotate(0,0,-15) * scale(4,1.5,4) * unit_cube()	-- slice for easier fit
		} )
	)
end

function head()
	return scale(hdScl) * 
	(
		union( {
			difference( {
				union( {
					translate(0,0,9.5)	* sphere(5),	--round head
					cone(2,5, 9),						--snout
					translate(-4.3,-3,9)  * rotate(35,0, 50) * scale(1,5,5) * unit_cube(),		--left ear
					translate(3.5,-2.5,9) * rotate(35,0,-50) * scale(1,5,5) * unit_cube()		--right ear
				} ),
				translate(-3,-4,7) * sphere(2),		--left eye
				translate(3,-4,7) * sphere(2),		--right eye
				translate(0,2.6,10.9) * sphere(sck/hdScl*scl) --neck hole
			} ),
			translate(-2.5,-1.9,8) * sphere(1) ,--left eye
			translate(2.5,-1.9,8) * sphere(1)	--right eye
		} )
	)
end

function body()
	return scale(scl) *
	union ( {
		difference( {
			union( {
				cone(3,5, 12.5),					--body
				translate(0,0,13) * sphere(5),		--chest
				translate(0,-5.5,16) * sphere(ball),--neck
				difference(	{
					translate(-1,-5,4) * rotate(0,90,0) * cylinder(4,2),
					translate(-2,-5,6) * rotate(0,90,0)	* cylinder(4,4),
					translate(-2,-10,3.5) * scale(4) * unit_cube(),
				} )
			} ),
			translate(-3.5,2,14) * rotate(30,90,0) * center_cylinder(dome+0.5,3),
			translate(3.5,2,14)	* rotate(-30,90,0) * center_cylinder(dome+0.5,3),
			translate(-3.5,2,2)	* rotate(30,90,0) * center_cylinder(dome+0.5,3.7),
			translate(3.5,2,2) * rotate(-30,90,0) * center_cylinder(dome+0.5,3.7),
		} ),
		-- leg joints
		translate(-3.1,2,14) * sphere(ball),
		translate(3.1,2,14) * sphere(ball),
		translate(-3.1,2,ball) * sphere(ball),
		translate(3.1,2,ball) * sphere(ball),
	} )
end

function print()
	return scale(1) * 
	union({
		body(),
		translate(15,-13,0) * rotate(0,0,90) * head(),
		translate(-4,-25,0) * rotate(0,0,45) * fleg(),
		translate(18,-25,0) * rotate(0,0,-45) * mirror(X) * fleg(),
		translate(-4,-40,0) * mirror(X)	* bleg(),
		translate(18,-40,0) * bleg()
	})
end

emit(print(),0)
