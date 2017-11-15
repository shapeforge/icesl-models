-- (c) Sylvain Lefebvre - INRIA - 2013

thickness = 2.1
spacing   = 0.2
tolerance = 0.21 -- 0.2
h = thickness + spacing
htot = h + thickness
w = 7
bore = 2
pinsmall = 1.7
pinbase = 2.5

function bar_up(p0,p1)
	-- compute transform
	d = p1 - p0
	l = math.sqrt(dot(d,d))
	u = normalize(d)
	agl = atan2(u.y,u.x)
	bar = translate((p0+p1)*0.5) 
		  * translate(0,0,h)
		  * rotation(agl,Z)
		  * scale(l,pinbase*2,thickness)
		  * translate(0,0,0.5)
		  * box(1)
	c0 = translate(p0) * translate(0,0,h) * cylinder(pinbase,thickness)
	c1 = translate(p1) * translate(0,0,h) * cylinder(pinbase,thickness)
	return union({bar,c0,c1})
end

function bar_dwn(p0,p1)
	-- compute transform
	d = p1 - p0
	l = math.sqrt(dot(d,d))
	u = normalize(d)
	agl = atan2(u.y,u.x)
	bar = translate((p0+p1)*0.5) 
		  * rotation(agl,Z)
		  * scale(l,w,thickness)
		  * translate(0,0,0.5)
		  * box(1)
	c0 = translate(p0) * cylinder(w/2,thickness)
	c1 = translate(p1) * cylinder(w/2,thickness)
	return union({bar,c0,c1})
end

function bar_round(p0,p1)
	-- compute transform
	d = p1 - p0
	l = math.sqrt(dot(d,d))
	u = normalize(d)
	agl = atan2(u.y,u.x)
	bar =   rotation(agl,Z)
		  * scale(l,w,thickness)
		  * translate(0,0,0.5)
		  * box(1)
    n = v(-u.y,u.x,0)
	tmp_up = rotation(agl,Z)
	      * translate(-w/2,0,0)
		  * scale(l+w*2,w,thickness)
		  * translate(0,0,0.5)
		  * box(1)
	tmp_dwn = rotation(agl,Z)
		  * scale(l,w,thickness)
		  * translate(0,0,0.5)
		  * box(1)
	shift = w/2
	angle = 30
	c0 = translate(p0 - (p0+p1)*0.5)
  	* union( cylinder(w/2,1), translate(Z*1.0) * cone(w/2,w/2-1.8,thickness-1) )
	c1 = translate(p1 - (p0+p1)*0.5) * union( cylinder(w/2,1), translate(Z*1.0) * cone(w/2,w/2-1.8,thickness-1) )
	bar = union({bar,c0,c1})
	bar = difference( bar, translate(shift*n.x,shift*n.y,thickness/2) 
	                * rotate(-angle,u) * tmp_up )
	bar = difference( bar, translate(-shift*n.x,-shift*n.y,thickness/2) 
	                * rotate(angle,u) * tmp_up )
	--bar = difference( bar, translate(shift*n.x,shift*n.y,-thickness/2) 
	--                * rotate(angle,u) * tmp_dwn )
	--bar = difference( bar, translate(-shift*n.x,-shift*n.y,-thickness/2) 
	--                * rotate(-angle,u) * tmp_dwn )
    bar = translate((p0+p1)*0.5) * bar
	return bar
end

function pin_foot()
  clamp = cylinder(pinbase-tolerance*3,thickness)
  base = union( intersection(cone(pinbase-tolerance,pinsmall-tolerance,thickness*2/3),clamp),
                translate(0,0,thickness*2/3) * cone(pinsmall-tolerance,pinbase-tolerance,thickness/3) )
  top  = translate(0,0,thickness) * cone(pinbase-tolerance,pinbase,spacing)
  return union(base,top)
end

function pin_hole()
  base = union( cone(pinbase,pinsmall,thickness*2/3),
                translate(0,0,thickness*2/3) * cone(pinsmall,pinbase,thickness/3) )
  return base
end

pos = v(26.977503, 1.2443830, 0)
agl = -2.3080823 * 180.0 / Pi
m113 = translate(pos) * rotate(agl,Z)

-- id 114
pos = v(28.164534, 1.7381574, 0)
agl = 1.7639008 * 180.0 / Pi
size = v(0.87000000, 0.15999997, thickness)
m114 = translate(pos) * rotate(agl,Z)
b114 = translate(Z * h) * m114 * scale(size) * box(1)

pos = v(27.560066, 1.3100336,0)
agl = 1.7613611 * 180.0 / Pi
size = v(1.4400005, 0.18999997,thickness)
m115 = translate(pos) * rotate(agl,Z)
b115 = m115 * scale(size) * box(1)

pos = v(27.514458, 1.2451988, 0)
agl = 1.7651474 * 180.0 / Pi
size = v(0.17000002, 1.5700001, thickness)
m116 = translate(pos) * rotate(agl,Z);
b116 = m116 * scale(size) * box(1)

pos = v(28.127218, 2.0808647,0)
agl = 1.7754943 * 180.0 / Pi
size = v(0.17000002, 1.5700001,thickness)
m117 = translate(pos) * rotate(agl,Z)
b117 = m117 * scale(size) * box(1)

pos = v(29.405464, 1.6973277,0)
agl = 0.78818381 * 180.0 / Pi
size = v(0.14999962, 1.6700000,thickness)
m118 = translate(pos) * rotate(agl,Z)
b118 = m118 * scale(size) * box(1)

scl = 30

h213 = scale(scl) * (m113 * v(-0.16637290, 0.0078625334,0))
h214 = scale(scl) * (m116 * v(0.0010045237, 0.65399033,0))
h215 = scale(scl) * (m114 * v(0.33230287, -0.0081313932,0))
h216 = scale(scl) * (m114 * v(-0.35735485, 4.7104346e-005,0))
h217 = scale(scl) * (m115 * v(-0.062266462, 0.010620555,0))
h218 = scale(scl) * (v(27.674820, 0.68528634,0))
h219 = scale(scl) * (m115 * v(0.63784134, -0.0077153589,0))
f221 = scale(scl) * (m118 * v(-0.030571532, 0.76214552,0))
e220 = scale(scl) * (m118 * v(-0.011682510, -0.72903293,0))

trl = translate( v(0,0,0) - h213 )

-- emit(bar_up( h213,h214 )) -- wheel arm
-- emit(trl * bar_dwn( h213,h218 )) -- fixture center wheel, pin

barA = bar_up( h218,h219 )
foot = translate(h218) * cylinder(w/2,htot)
hole = translate(h218) * cylinder(bore+tolerance*1.5,htot*1.5)
barA = difference( union( barA, foot ), hole)
barA = union(barA,translate(h217) * pin_foot())
barA = union(barA,translate(h219) * pin_foot())

barB = bar_up( h215,h216 )
barB = union(barB,translate(h215) * pin_foot())
barB = union(barB,translate(h216) * pin_foot())

barL = bar_dwn( h214,h216 )
barL = difference(barL,translate(h216) * pin_hole())
barL = difference(barL,translate(h217) * pin_hole())
foot = translate(h214) * cylinder(w/2+0.4,htot)
hole = translate(h214) * cylinder(bore+0.4,htot*1.5)
barL = difference( union( barL, foot ), hole)
barL = difference( barL, 
            translate(w,-w/4,0) 
          * translate(h214) 
		  * rotate(-15,Z)
		  * scale(w*2,bore*2 - 1.5,w*2)
 		  * translate(0,0,0.5) * box(1) )

dir = normalize(f221 - h219)
barF_point = h219 - dir * 10
barF_base = union( bar_round( barF_point,f221 ),
                   bar_round( f221,e220 ) )
barF = translate(0,0,thickness) * mirror(Z) * barF_base
barF = difference(barF,translate(h219) * pin_hole())
barF = difference(barF,translate(h215) * pin_hole())

barF_top = translate(0,0,htot+spacing) * barF_base
barF_top = union( barF_top, translate(barF_point) * translate(Z*thickness) 
                           * cylinder(w/2,thickness+spacing*2) )
barF_top = union( barF_top, translate(f221) * translate(Z*thickness) 
                           * cylinder(w/2,thickness+spacing*2) )
barF_top = union( barF_top, translate(e220) * translate(Z*thickness) 
                           * cylinder(w/2,thickness+spacing*2) )

trl = rotate(0,0,-11) * trl
emit(trl * barL)
emit(trl * barA) -- up
emit(trl * barB) -- up
emit(trl * barF)
emit(trl * barF_top)

-- emit( trl * translate(h213)*cylinder(1,htot) )
-- emit( trl * translate(h214)*cylinder(1,htot) )
-- emit( trl * translate(h215)*cylinder(1,htot) )
-- emit( trl * translate(h216)*cylinder(1,htot) )
-- emit( trl * translate(h217)*cylinder(1,htot) )
-- emit( trl * translate(h218)*cylinder(1,htot) )
-- emit( trl * translate(h219)*cylinder(1,htot) )

