enable_variable_cache = true

shape = difference{
  scale(0.5,1,2) * sphere(10),
  rotate(0,90,0) * ccylinder(5,20),
  translate(-10,0,0) * sphere(9),
  translate(10,0,0) * sphere(9),
  }

--emit(shape)

if not bx then
  bx = bbox(shape)
end

f = ui_field('paint to add cells',bx:min_corner(),bx:max_corner())

if not s then
  s = distribute(shape, 0.7)
end

centroids = {} 
for i = 1,#s,1 do
    v = ui_field_value_at('paint to add cells',s[i][1])
    if v > 0.1 then
      scl = (v - 0.1) * 3.0
	  centroids[i*2]   = translate(s[i][1]) * frame(s[i][2]) * scale(scl) * cone(s[i][3],0.1*s[i][3],1) 
	  centroids[i*2+1] = translate(s[i][1]) * frame(s[i][2]) * scale(scl) * mirror(Z) * cone(s[i][3],0.1*s[i][3],1) 
    end
end

r = difference(union(shape,merge(centroids)),
                       translate(0,0,-20)*ccube(20,20,10))
emit(r)

-- save as mesh
-- dump(to_mesh(r,0.2),'output.stl')
