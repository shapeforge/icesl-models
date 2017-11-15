function planar_bar(p0,p1,w,t)
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

function bar(p0,p1,r)
	d    = p1 - p0
	l    = math.sqrt(dot(d,d))
	u    = normalize(d)
	u_xy = normalize(v(d.x,d.y,0))
	aglZ = atan2(u_xy.x,u_xy.y)
	aglX = atan2(u.z,length(v(u.x,u.y,0)))
	return merge{translate((p0+p1)*0.5) 
		  * rotation(-aglZ,Z)
		  * rotation(90,X)
		  * rotation(aglX,X)
		  * ccylinder(r,l),
		  translate(p0)*sphere(r),
		  translate(p1)*sphere(r),
		  }
end

function bar2(p0,p1,r0,r1)
	d    = p1 - p0
	l    = math.sqrt(dot(d,d))
	u    = normalize(d)
	u_xy = normalize(v(d.x,d.y,0))
	aglZ = atan2(u_xy.x,u_xy.y)
	aglX = atan2(u.z,length(v(u.x,u.y,0)))
	return merge{translate((p0+p1)*0.5) 
		  * rotation(-aglZ,Z)
		  * rotation(90,X)
		  * rotation(aglX,X)
		  * ccone(r0,r1,l),
		  translate(p0)*sphere(r1),
		  translate(p1)*sphere(r0),
		  }
end
