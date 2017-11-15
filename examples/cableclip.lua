c1 = cylinder(14,4)
c2 = scale(1.2,1,1) * translate(0,0,-0.5) * cylinder(10,5)

t1 = translate(1,-13,2) * scale(0.6,1,1) * rotate(0,0,45) * box(8)
t1_2 = translate(10,-10,0) * box(20)
t1 = difference(t1,t1_2)

t2 = translate(0,4.5,0) * mirror(X) * t1
c = scale(0.9) * difference(c1,c2)
clip = difference({c,t1,t2})

emit( clip )
--emit( t1 )
--emit( t2 )
