a = scale(10) * translate(0,0,-5) * cylinder(2,10)
b = a
b = translate(Vector(10,0,0)) * scale(Vector(1,1,2)) * b
c = scale(0.5) * difference(a,b)

hs = 50
e = translate(-20,0,0) * rotate(90,90,270) * scale(hs/100) * load(Path .. 'meshes/heart.stl')

--emit(c)
--emit(e)

emit( difference(c,e) );
