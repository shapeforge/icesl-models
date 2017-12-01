
long = 100
r = scale(long,30,2) * translate(0,0,0.5) * box(1)

intersize = long/11
pos = -long/2+intersize
spacing = 2
for i=1,10 do
  c = translate(pos, 0, 0 ) * cylinder( (1+i)/2, 2 )
  r = difference( r, c )
  pos = pos + (i+1)/2 + spacing + (i+2)/2
end

cn = rotate(90,Y) * translate(0,0,-long/2) * cone(5/2,18/2,long)

emit( intersection(r,cn) )
