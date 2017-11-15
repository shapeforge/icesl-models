
numholes = 3
diameter = 20
attach_len = 10
h = 9
t = 5

base = translate(0,0,0)*box(attach_len*2+(diameter+t)*numholes,t,h)

bore = translate(0,0,0)*rotate(90,0,0)*union(
translate(0,0,-7)*cylinder(4.5/2,15),
translate(0,0,-3)*cone(0,11,15)
)
base = difference(base,translate(-attach_len/2-(diameter+t)*(numholes)/2,0,0)*bore)
base = difference(base,translate( attach_len/2+(diameter+t)*(numholes)/2,0,0)*bore)

xstart = -(diameter+t)*(numholes-1)/2
for i=1,numholes do
  x = xstart+(i-1)*(diameter+t)
  y = -diameter/2
  hole       = translate(x,y,-h)*cylinder(diameter/2+t/2,h*2)
  in_hole   = translate(x,y,-h/2)*cylinder(diameter/2,h)
  out_hole = translate(x,y,-h/2)*cylinder(diameter/2+t/2,h)
  circlips = difference(out_hole,in_hole)
  base = union(circlips,difference(base,hole))
end

emit(base)
