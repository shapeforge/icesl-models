hole = cylinder(1,10)
b = difference(cube(20,20,10),hole)
r = difference(cylinder(5,10),hole)

emit(b,1)
emit(r,0) -- brush 0 overrides brush 1
