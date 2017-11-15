plate = translate(0,-12.5,0)*scale(99,135,1)*box(1)
hole1 = translate(0,-28,0)*scale(80,60,1)*box(1)
hole2 = translate(0,30,0)*scale(80,20,1)*box(1)
fixA  = translate(0,-135/2+13.6,0)*translate(0,-12.5,0)*scale(37,3,1)*box(1)
fixB  = translate(0,77,0)*fixA

body = difference{plate,hole1,hole2,
   translate(-62/2,0,0)*fixA,
   translate( 62/2,0,0)*fixA,
   translate(-62/2,0,0)*fixB,
   translate( 62/2,0,0)*fixB,
   }

t = 2.0
side = translate(0,-12.5,0)*scale(t,135,12)*translate(0,0,0.5)*box(1)
side = difference{
			side,
			translate(0,-101/2,6)*translate(-(t+1)/2,0,0)*rotate(90,Y)*cylinder(2.2,t+1),
			translate(0, 101/2,6)*translate(-(t+1)/2,0,0)*rotate(90,Y)*cylinder(2.2,t+1)
       }

left  = translate(-99/2-t/2,0,-0.5)*side
right = translate( 99/2+t/2,0,-0.5)*side

final = union{body,left,right}

emit(rotate(90,Z)*final)
