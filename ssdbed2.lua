b = scale(100,100,2) * box(1)
bminus = scale(70,80,2) * box(1)

dist_holes_ssd = 77

side = scale(2,100,10) * translate(0,0,0.5) * box(1)
hole = translate(0,-40,5) * rotate(0,90,0) * translate(0,0,-2) * cylinder(1.8,4)
holes = union( hole, translate(0,60,0) * hole )

screw_hole = translate(0,-40,5) * rotate(0,90,0) * translate(0,0,-2) * cylinder(3.5,4)
screw_holes_ssd = translate(0,8,0) * union( screw_hole, translate(0,dist_holes_ssd-1,0) * screw_hole )

side = difference({side, holes, screw_holes_ssd})

b = union({
 translate(-50+1,0,0) * side, 
 translate(50-1,0,0) * side, 
 b 
 })

side_ssd = scale(2,100,10) * translate(0,0,0.5) * box(1)
holes_ssd = union({ hole, 
   translate(0,dist_holes_ssd-2,0) * hole, 
   translate(0,dist_holes_ssd-1,0) * hole, 
   translate(0,dist_holes_ssd,0) * hole,
   translate(0,dist_holes_ssd+1,0) * hole, 
   })
side_ssd = difference(side_ssd,translate(0,8,0) * holes_ssd)

b = union({
translate(35+1.5,0,0) * side_ssd,
translate(-35-1.5,0,0) * side_ssd,
b})
 
b = difference(b,bminus)
 
emit(b)
