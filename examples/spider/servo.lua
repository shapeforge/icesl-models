-- adapted from http://www.servocity.com/html/hs-311_standard.html

a = 19.82
b = 13.47
c = 33.79
d = 10.17
e = 9.66
f = 30.22
g = 11.68
h = 26.67
j = 52.84
k = 9.35
l = 4.38
m = 39.88
x = 3.05
wt = 16.6
sp = 10.2
hd = 47.8
bd = 2.15
tol = 0.4 -- tolerance

function hs311()
	body   = scale(a,m,h+g) * translate(0,0,-0.5) * box(1)
	attach = translate(0,0,-g) * scale(a,j,3.3) * translate(0,0,0.5) * box(1)
	holes  = union{
	  translate(sp/2,- hd/2,-g) * cylinder(bd,4),
	  translate(-sp/2,- hd/2,-g) * cylinder(bd,4),
	  translate(sp/2,  hd/2,-g) * cylinder(bd,4),
	  translate(-sp/2, hd/2,-g) * cylinder(bd,4),
	}
	attach = difference(attach,holes)
	servo  = translate(0,0,g-wt) * translate(0,m/2-e,0) * union{body,attach}
	wheel  = translate(0,0,-2) * difference{cylinder(12,2),
						 translate(-17/2,0,0) * cylinder(0.75,10),
						 translate( 17/2,0,0) * cylinder(0.75,10),
						 translate(0,-14/2,0) * cylinder(0.75,10),
						 translate(0, 14/2,0) * cylinder(0.75,10),
			   }
	spline = translate(0,0,-2-x) * cylinder(2,x)
	return union{servo,spline,wheel}
end

function hs311_wheel_bore()
	wheel = union{translate(0,0,-2) * cylinder(12+tol,2),
						 --translate(-17/2,0,0) * cylinder(0.75,10),
						 --translate( 17/2,0,0) * cylinder(0.75,10),
						 translate(0,-14/2,0) * cylinder(0.75,10),
						 translate(0, 14/2,0) * cylinder(0.75,10),
						 translate(0,0,0) * cylinder(4,10)
			   }
	return wheel
end

function hs311_bore(thick)
	holes  = union{
	  translate(sp/2,- hd/2,-wt-thick-0.5) * cylinder(bd,thick+1),
	  translate(-sp/2,- hd/2,-wt-thick-0.5) * cylinder(bd,thick+1),
	  translate(sp/2,  hd/2,-wt-thick-0.5) * cylinder(bd,thick+1),
	  translate(-sp/2, hd/2,-wt-thick-0.5) * cylinder(bd,thick+1),
	}
    return union{
	  translate(0,m/2-e,-wt+0.5) * scale(a+tol*3,m+tol*3,thick+1) * translate(0,0,-0.5) * box(1),
	  translate(0,m/2-e,0) * holes,
	  translate(0,     -e,-wt+0.5) * scale(6.5,2.5,thick+1) * translate(0,-0.5,-0.5) * box(1),
	}
end

function hs311_fixture_pos()
  return translate(0,m/2-e,-wt)
end

function hs311_fixture_height()
  return wt
end

function hs311_height_with_wheel()
  return h+wt
end