-- Frosty Screwless Micro-Pyramid Gears
--
-- Modified by Sylefeb 2012-11-02
--  derived from http:--www.thingiverse.com/thing:24675

dofile(Path .. 'libs/gear.lua')
dofile(Path .. 'libs/pins.lua')


hs=50			-- heart size (width)
hz=-10			-- heart z-position (motion relative to 100mm original height)
rf1=0.75*hs		-- distance from center of cube to cut corner faces
cp=0.2			-- percentage of rf1 for the center block
ph=6			-- pin height in center block
ph1=rf1*0.25	-- pin height in large gears
ph2=rf1*0.25	-- pin height in small gears
pd=4.5			-- pin shaft diameter
b=0.5			-- backlash

pt=1.3 	  	-- pin's lip thickness thickness 
chainHole=3  	-- chain hole diameter 
pinShift=.85 	-- distance the pins are shifted out from the center 
pinSizeOffset=5.6 -- lazy way of fixing a problem with the lengths of the pins. Value decreases the size. 


n1=9-- number of teeth on gear1 
n2=6-- number of teeth on gear2
-- Run gearopt.m (from Thing:6073) with inputs of n1 and n2 above, copy outputs r1 and r2 below.
r1= 0.685990104234767
r2= 0.457326736156511

-- -------------- Don't edit below here unless you know what you're doing. 
dc=rf1/math.sqrt(1-math.pow(r1,2))
theta=asin(1/math.sqrt(3))
pitch=360*r1*dc/n1
rf2=math.sqrt(math.pow(dc,2)-math.pow(r2*dc,2))
L1=ph1+ph
L2=ph2+ph

function cbox()
return translate(0,0,-(rf2-rf1)*cp/2) * difference({
	scale(dc,dc,(rf1+rf2)*cp) * ccube(1),
	translate(0,0,-(rf1+rf2)*cp/2-.01-pinShift) * pinhole{h=ph,r=pd/2,tight=true, lt=pt},
	rotate(180,0,0) * translate(0,0,-(rf1+rf2)*cp/2-.01-pinShift) * pinhole{h=ph,r=pd/2,tight=true, lt=pt}
  })
end

function center()
return rotate(180,0,0) *
intersection({
	rotate(-90-theta,0,0)  * cbox(),
	rotate(-90-theta,0,180)* cbox(),
	rotate(90-theta,0,90)  * cbox(),
	rotate(90-theta,0,-90) * cbox()
})
end

function gearA()
	return rotate(180,0,n2) * translate(0,0,-rf1) *
	difference(
		bevel_gear{number_of_teeth=n1,
			outside_circular_pitch=pitch,
			cone_distance=dc,
			face_width=dc*(1-cp),
			bore_diameter=0,
			backlash=b,
			finish=0},
		translate(0,0,rf1*(1-cp)+pinShift) * rotate(180,0,0) * pinhole{h=ph,r=pd/2,tight=false, lt=pt}
	)
end

function gearB()
	return rotate(180,0,n2) * translate(0,0,-rf2) *
	difference(
		bevel_gear{number_of_teeth=n2,
			outside_circular_pitch=pitch,
			cone_distance=dc,
			face_width=dc*(1-cp),
			bore_diameter=0,
			backlash=b},
		translate(0,0,rf2*(1-cp)+pinShift) * rotate(180,0,0) * pinhole{h=ph,r=pd/2,tight=false, lt=pt}
	)
end

crustThickness = 0

function gear1()
	return rotate(0,-90+theta,0) * rotate(0,-theta+90,0) *
	intersection(
		scale(hs/100) * translate(0,0,hz-crustThickness) * load(Path .. 'meshes/pyr.stl'),
		rotate(0,theta-90,0) * rotate(0,90-theta,0) * gearB()
	)
end
	
function gear2()
  return rotate(-90+theta,0,0) * rotate(0,-theta+90,0) *
  intersection(
  	  scale(hs/100) * translate(crustThickness/1.4,crustThickness*1.1,hz+crustThickness/2) * load(Path .. 'meshes/pyr.stl'),
 	  rotate(0,theta-90,0) * rotate(90-theta,0,0) * gearA()
  )
end

function gear3()
 return rotate(0,-90+theta,0)*rotate(0,0,180)*rotate(0,-theta+90,0)*
    intersection(
	scale(hs/100)*translate(crustThickness,crustThickness/1.5,hz+crustThickness/1.5)*load(Path .. 'meshes/pyr.stl'),
	rotate(0,theta-90,0)*rotate(0,0,180)*rotate(0,90-theta,0)*gearB()
  )
end

function gear4()
  return rotate(-90+theta,0,0)*rotate(0,0,180)*rotate(0,-theta+90,0)*
  intersection(
	scale(hs/100)*translate(crustThickness,-crustThickness*1.5,hz+crustThickness/2)*load(Path .. 'meshes/pyr.stl'),
	rotate(0,theta-90,0)*rotate(0,0,180)*rotate(90-theta,0,0)*gearA()
  )
end

function gear5()
  return rotate(0,-90+theta,0)*rotate(0,180,90)*rotate(0,-theta+90,0)*
  intersection(
	scale(hs/100)*translate(0,crustThickness,hz+crustThickness/1.5)*load(Path .. 'meshes/pyr.stl'),
	rotate(0,theta-90,0)*rotate(0,180,90)*rotate(0,90-theta,0)*gearB()
  )
end

function gear6()
  return rotate(-90+theta,0,0)*rotate(0,180,90)*rotate(0,-theta+90,0)*
  intersection(
      scale(hs/100)*translate(-crustThickness*1.5,0,hz+crustThickness/2)*load(Path .. 'meshes/pyr.stl'),
	  rotate(0,theta-90,0)*rotate(0,180,90)*rotate(90-theta,0,0)*gearA()
  )
end

function gear7()
  return rotate(0,-90+theta,0)*rotate(0,180,-90)*rotate(0,-theta+90,0)*
  intersection(
	scale(hs/100)*translate(-crustThickness/1.44,-crustThickness/1.44,hz+crustThickness/2)*load(Path .. 'meshes/pyr.stl'),
	rotate(0,theta-90,0)*rotate(0,180,-90)*rotate(0,90-theta,0)*gearB()
  )
end

function gear8()
	return rotate(-90+theta,0,0)*rotate(0,180,-90)*rotate(0,-theta+90,0)*
    intersection(
		scale(hs/100)*translate(0,0,hz+crustThickness)*load(Path .. 'meshes/pyr.stl'),
		rotate(0,theta-90,0)*rotate(0,180,-90)*rotate(90-theta,0,0)*gearA()
	)
end

function fourgears()
	z = - rf2 + bevel_gear_height(n2,pitch,dc,dc*(1-cp))
	return 
	union({
	translate(-16,12,z) * gear1(),
	translate(16,12,z) * rotate(0,0,90) * gear3(),
	translate(-16,-18,z) * gear5(),
	translate(16,-20,z) * gear7(),
	})
end

function fourbiggears()
	z = - rf1 + bevel_gear_height(n1,
			pitch,
			dc,
			dc*(1-cp));
	return union({
	translate(-20,25,z) * gear2(),
	translate(20,28,z) * gear4(),
	translate(-24,-12,z) * rotate(0,0,90)* gear6(),
	translate(20,-12,z) * gear8(),
	})
end

function fullplate()
    return rotate(0,0,90) * union({
          translate(0,55,(rf1+rf2)*cp/2-(rf2-rf1)*cp/2) *
          rotate(0,theta-90,0) *
          center(),
        translate(0,-60,0) * fourgears(),
        fourbiggears(),
     })
end

function pin2()
  return pinpeg{h=L2-pinSizeOffset,r=pd/2, lt=pt}
end

function pinplate()
	for i=1,5 do
	  for j=1,2 do
		emit( translate(i*10,j*15,0) * pin2() )  
	  end
	end
end

emit(fullplate())
-- emit(fourbiggears())
-- pinplate()
-- emit(gear2())
