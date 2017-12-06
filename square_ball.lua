
test = 10.0

b = box(test)

cy = translation(Z*-6) * cylinder(4,12)
b = difference(b,cy)
b = difference(b,rotation(90,Y) * cy)
b = difference(b,rotation(90,X) * cy)
s = sphere(6)
c1 = cylinder(2,10)

c1 = translation(Z*-5) * c1
b1 = rotation(45,X) * scale(Vector(0.1,1,1)) * box(5)
b1 = translation(Z*(5-1.5)) * b1
bsub = translation(Z*(10-0.01)) * box(10)
--emit(b1)
b1 = difference(b1,bsub)
--emit(translation(Z*(-12)) * bsub)
b1 = difference(b1,translation(Z*-11.5) * bsub)
-- emit(b1)
b2 = rotation(180,X) * b1
c1 = union(c1,union(b1,b2))

c2 = translation(Y*-5) * rotation(90,X) * c1
c3 = rotation(90,X) * translation(X*5) * rotation(90,Y) * c1
c2 = translation(Y*5) * c2
c3 = translation(X*-5) * c3
c  = union(c1,union(c2,c3))

s_in = sphere(5)

final = union(
  difference(b,s),
  union(s_in,c)
)
final = scale(2.0) * final
emit(final)

