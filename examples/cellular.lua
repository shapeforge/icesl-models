shape = difference{
  scale(0.5,1,2) * sphere(10),
  rotate(0,90,0) * ccylinder(5,20),
  translate(-10,0,0) * sphere(9),
  translate(10,0,0) * sphere(9),
  }

--emit(shape)

s = distribute(shape, 0.2)

centroids = {} 
for i = 1,#s,1 do
	centroids[i] = translate(s[i][1]) * frame(s[i][2]) * scale(1.2,1.2,0.5) * sphere(0.5*s[i][3]) 
end

r = difference(difference(shape,merge(centroids)),
                       translate(0,0,-20)*ccube(20,20,10))
emit(r)

-- save as mesh
-- dump(to_mesh(r,0.2),'output.stl')
