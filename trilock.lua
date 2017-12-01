function pos(p0,p1)
	-- compute transform
	delta = p1 - p0
	l = math.sqrt(dot(delta,delta))
	u = normalize(delta)
	theta = atan2(u.y,u.x)
	phy   = atan2(u.z,math.sqrt(u.x*u.x+u.y*u.y))
	return translate((p0+p1)*0.5) 
		  * rotation(theta,Z)
		  * rotation(-phy,Y)
end

function bar(diam,p0,p1)
  delta = p1 - p0
  l = math.sqrt(dot(delta,delta))
  return merge{
     pos(p0,p1) * rotate(90,Y) * translate(0,0,-l/2) * cylinder(diam/2,l),
	 translate(p0)*sphere(diam/2),
	 translate(p1)*sphere(diam/2)}	 
end

sz = 30
dm = 5
cut = 1

a = v(  0,0,0)
b = v(sz,0,0)
c = v(sz/2,sz*math.sqrt(3)/2,0)
d = v(sz/2,sz*math.sqrt(3)/6,sz*math.sqrt(6)/3)

tetra = translate(-0.25*(a+b+c+d)) * union{
bar(dm,b,c),
bar(dm,a,b),
bar(dm,a,c),
bar(dm,a,d),
bar(dm,b,d),
bar(dm,c,d)
}

clamp = union(
translate(0,0,-d.z*0.25-dm/2+cut)*scale(sz*1.5,sz*1.5,10)*translate(0,0,-0.5)*box(1),
translate(0,0, d.z*0.75+dm/2-cut)*scale(sz*1.5,sz*1.5,10)*translate(0,0,0.5)*box(1)
)
emit(difference(tetra,clamp),0)
emit(difference(translate(0,0,d.z/2) * rotate(180,X) * tetra,clamp),1)

emit(translate(0,0,-7.4) * scale(10,10,0.5) * box(1))

-- emit(clamp)
