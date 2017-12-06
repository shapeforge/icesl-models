-- (c) Sylvain Lefebvre - INRIA - 2013

dofile(Path .. '../libs/gear.lua')
dofile(Path .. 'spiderglobals.lua')
dofile(Path .. 'spiderspine.lua')

function bar(p0,p1,w,t)
	-- compute transform
	d = p1 - p0
	l = math.sqrt(dot(d,d))
	u = normalize(d)
	agl = atan2(u.y,u.x)
	b = translate((p0+p1)*0.5) 
		  * rotation(agl,Z)
		  * scale(l,w,t)
		  * translate(0,0,0.5)
		  * box(1)
	c0 = translate(p0) * cylinder(w/2,t)
	c1 = translate(p1) * cylinder(w/2,t)
	return union({b,c0,c1})
end


spinelen = inner_length + tolerance
print('spinelen : ' .. spinelen)

trl = translate( v(0,0,0) - h213 )
barthick = thickness
barw = 10

bodyw = 29.5 -- 29 -- 50

-- emit(translate(0,0,10) * box(10))

xtrl = h213.x
h218 = translate(bodyw - xtrl,0,0) * h218
h213 = translate(bodyw - xtrl,0,0) * h213

symetry = mirror(X)

o218 = symetry*h218
o213 = symetry*h213

side    = translate(0,0,barthick*0.3/2) * bar(h213,h218,barw,barthick*0.7)
center  = bar(h218,o218,barw,barthick)
scafold = translate(0,0,barthick*0.3/2) * bar(h213,(o218*0.4+h218*0.6),barw/2,barthick*0.7)

side = union({
  side,
  symetry*side,
  scafold,
  symetry*scafold,
  center
})

-- spine axel clips
szb  = (bore_side*1.8+tolerance)*1.5
side = union     (side, translate(h213)*translate(0,0,barthick*0.3/2)*cylinder(szb,barthick*0.7) )
side = union     (side, translate(o213)*translate(0,0,barthick*0.3/2)*cylinder(szb,barthick*0.7) )
side = difference(side, translate(h213)*cylinder(bore_side+tolerance,barthick) )
side = difference(side, translate(o213)*cylinder(bore_side+tolerance,barthick) )
-- slitA = bar( h213, h213 + v(-10,10,0), bore_side*1.8-tolerance,3 )
-- slitB = bar( o213, o213 + v( 10,10,0), bore_side*1.8-tolerance,3 )
-- side = difference(side, slitA)
-- side = difference(side, slitB)
-- bottom leg axis support
side = difference(side, translate(h218)*cylinder(bore,barthick) ) -- tight to lock bar inside
side = difference(side, translate(o218)*cylinder(bore,barthick) )
body = union( side , translation(Z*(spinelen+barthick)) * side)

bottombar = scale(barthick*2.5,4,barthick+spinelen)
  * translate(0,0,0.5) * box(1)
clamp = translate(0,-2,barthick)*scale(barthick*2.5,barw,barw)*translate(0,0.5,0.5)*box(1)
btmscafold = intersection( clamp,
             translate(0,1,-5)*rotate(35,X)*scale(barthick*2.5,barw,barw*2)*translate(0,0.5,0.5)*box(1) )
bottombar = union( bottombar , btmscafold )
bottombar = union( bottombar , translation(Z*(spinelen+barthick*2)) * mirror(Z) * btmscafold )
bottombar = translate(0,-3,0) * translate((h218+o218)*0.5) * bottombar
  
p0 = translate(0,-3,0) * v(0,0,0)
p1 = translate(0,3,0) * v(0,0,0)
slit = translate(0,15,18.5) * rotate(-90,X) * bar(p0,p1,3,6)

bottombar = difference( bottombar , slit )

body = union(body,translate( 18,0,0) * bottombar)
body = union(body,translate(-18,0,0) * bottombar)

dist = math.sqrt(dot(o218 - h218,o218 - h218))
print('dist = ' .. dist)

function spidermotorgear()

	motorgear = gear{
	   circular_pitch=350,
	   gear_thickness=7,
	   rim_thickness=7,
	   rim_width=4,
	   hub_thickness=5,
	   hub_diameter=10,
	   circles=0}
	-- motorgear = cylinder(12,3)
	motorgear = difference(motorgear,translate(-17/2,0,0) * cylinder(0.75,10))
	motorgear = difference(motorgear,translate( 17/2,0,0) * cylinder(0.75,10))
	motorgear = difference(motorgear,translate(0,-14/2,0) * cylinder(0.75,10))
	motorgear = difference(motorgear,translate(0, 14/2,0) * cylinder(0.75,10))
	unglue = mirror(Y) * rotate(10,X) * translate(-1,0,-3) *
	   scale(wheel_radius*1.5,wheel_radius*1.5,1) * translate(0,0.5,0.5) * box(1)
	motorgear = difference( motorgear, unglue )

	return (motorgear)

end

function spiderbody()

  return (rotate(90,X) * body)

end

function spiderbodyandspines()
  
  anchor = rotate(90,X) * o213
--  emit( translate(anchor) * sphere(5) )

  spine = translate(anchor - spineanchor - barthick/2 * Y) * rotate(180,Y) * spiderspine()
  spine = union( spine, symetry * spine )
  
  grnd  = translate(anchor - spineanchor - barthick/2 * Y) * rotate(180,Y) * ground
  grnd  = translate(75,0,0)*scale(2.5,1,1)*grnd
  body  = difference(spiderbody(),grnd)

  return union( spine,body )
  
end

-- 

