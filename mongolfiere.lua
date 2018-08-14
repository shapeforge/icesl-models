quartier = scale(0.4,1.0,1.0)*sphere(25)

-- reduce tesselation factor to speed up convex hull
set_tesselation_factor(0.3)

hull = convex_hull( union{
 quartier,
 translate(0,0,-25)*scale(0.36)*quartier
} )

shapes = {}
for i=0,16 do
  table.insert(shapes,rotate(0,0,i*360/16)*hull)
end

baloon = union(shapes)
baloon = difference(
    baloon,
    translate(0,0,-35)*cube(17,17,3)
    )

nacelle = convex_hull(union{
  translate(2,2,2)*sphere(2),
  translate(2,8,2)*sphere(2),
  translate(8,2,2)*sphere(2),
  translate(8,8,2)*sphere(2),
  translate(0,0,10)*sphere(1),
  translate(0,10,10)*sphere(1),
  translate(10,0,10)*sphere(1),
  translate(10,10,10)*sphere(1),

})

emit(translate(-5,-5,-40)*cone(1,1,10))
emit(translate(-5,5,-40)*cone(1,1,10))
emit(translate(5,-5,-40)*cone(1,1,10))
emit(translate(5,5,-40)*cone(1,1,10))
emit(translate(0,0,-31)*ccube(12,12,2))

emit(baloon)
emit(translate(-5,-5,-50)*nacelle)
