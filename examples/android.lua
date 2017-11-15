
Nsegs = 256

function circle(c,r)
  points = {}
  N = Nsegs
  for i = 1,N do
    a = i*math.pi*2/N
    p = c + v(r*math.cos(a),r*math.sin(a),0)
	table.insert(points,p)
  end
  return points
end
 
s = 0.5
tol = 0.4
tolhinge = 0.6

bar = union{
  cylinder(2,8),
  sphere(2),
  translate(0,0,8)*sphere(2),
}

arm =  translate(0,0,8) * rotate(-90,X) * translate(0,0,-8) * bar

foot = union{
   translate(0,1.5,0)*bar,
   translate(0,-1.5,0)*bar,
   translate(0,1.5,0)*rotate(90,X)*cylinder(2,3),
   scale(4,3,6)*translate(0,0,.5)*box(1)
}

arm = union{arm,
translate(0,0,8)*rotate(90,Y)*cylinder(1,7),
translate(6,0,8)*rotate(90,Y)*cylinder(2,1),
}

arms = union{
arm,
mirror(X)*translate(-20,0,0)*arm,
}
armssub = union{
translate(0,0,8)*rotate(90,Y)*cylinder(1 + tolhinge/2,7),
translate(6-tolhinge/2,0,8)*rotate(90,Y)*cylinder(2 + tolhinge/2,1+tolhinge),
}

feet = union{
(translate(7,0,-8)*foot),
(translate(13,0,-8)*foot)
}

body = translate(10,0,-2)*cylinder(7.5,11.5)
c = circle(v(5.5,0),2)
body = union(body,translate(10,0,-2)*rotate_extrude(c,Nsegs))
body = union(body,translate(10,0,-4)*cylinder(5.5,2))

neck = translate(10,0,7)*cylinder(2,5)
necksub = translate(10,0,7)*cylinder(2 + tol/2,5)

body = difference(union(arms,difference{union{body,feet},necksub,
  armssub,
  mirror(X)*translate(-20,0,0)*armssub}),translate(10,0,9.5)*scale(30,30,10)*translate(0,0,.5)*box(1))

head = translate(10,0,10) * scale(1,1,0.93) * difference(sphere(7.5),scale(15)*translate(0,0,-.5)*box(1))

antena = rotate(0,-25,0)*union{
  cylinder(0.5,3),
  sphere(0.5),
  translate(0,0,3)*sphere(0.5),
}

head=difference{union{
head,
translate(6,0,16)*antena,
mirror(X)*translate(-14,0,16)*antena,
},
translate(13.5,6,14)*sphere(1),
translate(6.5,6,14)*sphere(1),
necksub
}

if false then
  emit(body)
  emit(head)
  emit(neck)
else
  plate = union{
    (translate(-6,-15,9.5) * rotate(180,X)*body),
    (translate(0,-4,-10) * rotate(90,Z) * head),
    (translate(4,6,-7) * neck)
  }

  emit(scale(2)*plate)
end
