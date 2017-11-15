-- Author: Sylvain Lefebvre
-- http://www.thingiverse.com/thing:56757/#files

tolerance = 0.2
radius = 5
buldge = radius-1
thickness = 1
btmcut = 0.1
connect_length = 3.5

function balljoint(rest_angle,left_leg,right_leg)

	b = sphere(radius)
	b = union(b,translate(0,radius-buldge*0.9,0) * scale(1,1,1) * sphere(buldge))
	b = union(b,translate(0,0,radius-buldge*0.95) * scale(1,1,1) * sphere(buldge))
	b = union(b,translate( radius-buldge*0.9,0,0) * scale(1,1,1) * sphere(buldge))
	b = union(b,translate(-radius+buldge*0.9,0,0) * scale(1,1,1) * sphere(buldge))
	b = rotate(0,0,rest_angle/2) * b
	s = scale(1+tolerance/radius,1+tolerance/radius,1.0*(1+tolerance/radius)) * b
	o = sphere(radius+thickness+tolerance)
	c = scale(1.5,1,1.5) * rotate(90,0,0) * cone(0,radius+0.2,radius*1.3)
	btm = translate(0,0,-radius-4) * cylinder(radius*0.6,radius+4)

	j = difference({ o, s,
      c,
	  btm,
	  mirror(Z) * btm
	  })

	connect = rotate(90,0,rest_angle/2) * translate(0,0,radius-1) * cylinder(2,connect_length)
	connect = union( connect, rotate(0,0,rest_angle/2) * translate(0,-connect_length-radius+1,0) * sphere(2) )
	leg = rotate(0,0,rest_angle/2) * translate(0,-connect_length-radius+1,-radius*1.5) * cylinder(2,radius*1.5)
	connectors = union(
	  connect,
	  translate(0,thickness+tolerance+0.7,0) * mirror(Y) * connect
    )
    if left_leg then
	  connectors = union(connectors,leg)
	end
    if right_leg then
	  connectors = union(connectors,translate(0,thickness+tolerance+0.7,0) * mirror(Y) * leg)
	end
    g = translate(0,0,-radius/2-radius+btmcut) * scale(radius*3,radius*8,radius) * box(1)

	joint = union({
	connectors,
	j,
	b,
	})

	return difference( joint,g )

end

angle = 360/8-2
n = 8
ctr = (connect_length+radius-1+2)
pos = v(0,ctr,0)
totangle = 0
for i=0,n-1 do
  bj = translate(0,-ctr,0) * balljoint(angle/2,i==n-1,i==0)
  emit( translate(100,50,0) * rotate(0,0,90) * translate(pos) * rotate(0,0,totangle) *  bj )
  pos = pos + rotate(0,0,totangle) * v(0,-2*ctr+2,0)
  totangle = totangle + angle
  --angle = angle * 1.1
end

-- for i=0,2 do
 -- tolerance = 0.2 + 0.05 * i
 -- print('tolerance: ' .. tolerance)
 -- emit( translate(i*15,0,0) * balljoint(true,0) )
-- end
