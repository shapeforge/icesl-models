
cardan = {}

tolerance = 0.4

ground = translate(0,-4.5,0) * scale(50,50,50) * translate(0,-0.5,0) * box(1)
-- emit(ground)

axel2_hole = translate(0,6,7.5) * rotate(90,X) * cylinder(2+tolerance,10)

axel1_radius = 3.4

second_block = {}

axel1 =  difference(union({
             cylinder(axel1_radius,15), 
--            difference(cylinder(axel1_radius,15), 
--			           translate(0,-3.5,0)*scale(6,3,15)*translate(0,0,0.5)*box(1)),
			                      cone(5-tolerance,axel1_radius,3)  ,
			translate(0,0,15-3) * cone(axel1_radius,5-tolerance,3) 
         }),axel2_hole)
table.insert(second_block,difference(axel1,ground))

axel2 = translate(0,4.5,7.5) * rotate(90,X) * 
        union({translate(0,0,-3.5) * cylinder(2,16),
		      translate(0,0,8) *cone(2,5,7),
			  translate(0,0,-6)*cone(5,2,7)})
table.insert(second_block,axel2)
		 
bar1 = scale(15,9,3) * translate(0.5,0,0.5) * box(1)
bar1 = union(bar1, cylinder(6,3))
bar1 = difference( bar1 , cone(5,axel1_radius+tolerance,3) )
sym  = mirror(Z) * translate(0,0,-15)
table.insert(cardan,difference(bar1,ground))
table.insert(cardan,difference(sym * bar1,ground))
-- rear bar
table.insert(cardan,translate(14,0,7.5) * scale(2,4,9) * box(1))
-- rear cylinder
table.insert(cardan,translate(14,0,7.5) * rotate(90,Y) * cylinder(3,10))
table.insert(cardan,translate(22.5,-1,7.5) * scale(3,7,3) * box(1))

bar2 = translate(-6,-3.75,7.5) * scale(21,3,4) * box(1)
table.insert(second_block,translate(0,-5,0) * bar2)
table.insert(second_block,translate(0,12.5,0)   * bar2)
-- top bar of second block
-- table.insert(second_block,translate(-15,0,7.5) * scale(3,15,4) * box(1))

-- v1 = rotate(90,X) * union(union(cardan),difference(rotate(-90,Z) * union(second_block),ground))

v2 = rotate(90,X) * union({union(cardan),
                          difference(rotate(0,Z) * union(second_block),ground),
						  translate(0,-3.5,7.5) * rotate(90,X) * cylinder(3,1)
						  }) 


emit(v2)
emit(translate(-30,0,0) * mirror(X) * v2)
						  
-- emit(v1)
-- emit(translate(0,20,0) * v2)

-- emit(union(cardan))
