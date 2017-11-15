dofile(Path .. 'libs/bar.lua')

thickness = 2
spacing = 1
tolerance = 0.2
grasp = 0.7

function hinge_pin(w,h,tol)
  base = cylinder(w/2+tol,h)
  base = union(base , translate(0,0,h-spacing-thickness/2) 
       * cone(w/2+grasp+tol,w/2+tol,thickness/2) )
  base = union(base , translate(0,0,h-spacing-thickness  ) 
       * cone(w/2+tol,w/2+grasp+tol,thickness/2) )
  return base
end

pc = v(0,0,0)
p1 = v(30,0,0)
p2 = rotate(120,Z) * p1
p3 = rotate(120,Z) * p2

-- generate pins

wstart = 5
winc = 3

barC = translate(0,0,thickness*2+spacing*2) * planar_bar(pc,p3,wstart,thickness)
barC = union     ( barC, hinge_pin(wstart,thickness*2+spacing*2,0) )
--- support for printing
barC = union(barC,translate(p3) * cylinder( wstart/2,thickness*2+spacing*2))

wstart = wstart + winc
barB = translate(0,0,thickness  +spacing  ) * planar_bar(pc,p2,wstart,thickness)
barB = union     ( barB, hinge_pin(wstart,thickness+spacing,0) )
barB = difference( barB, hinge_pin(wstart-winc,thickness*2+spacing*2,tolerance) )
--- support for printing
barB = union(barB,translate(p2) * cylinder( wstart/2,thickness+spacing))

wstart = wstart + winc
barA = planar_bar(pc,p1,wstart,thickness)
barA = difference( barA, hinge_pin(wstart-winc,thickness+spacing,tolerance) )


emit( barA )
emit( barB )
emit( barC )
