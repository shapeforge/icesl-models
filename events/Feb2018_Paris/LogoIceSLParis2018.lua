s = math.sqrt(3)/6
pts = {v( 0.0,  0.0,  0.5),
       v(   s, -0.5, -s/2), 
       v(   s,  0.5, -s/2), 
       v(-s*2,  0.0, -s/2)}

prim = Void
for i = 1, #pts do 
  for j = i, #pts do 
      prim = union(prim,
             cylinder(0.05, pts[i], pts[j]))
  end
  prim = union(prim, sphere(0.05, pts[i]))
end 

d_pyr = scale(42) * rotate(-1337, Z)  * prim 
u_pyr = scale(42) * rotate(0,267,150) * prim 
u_pyr = translate(0, 0, 17.7) * u_pyr

emit(d_pyr, 0)
emit(u_pyr, 1)
-- %line_number février 2018 # Découvrir IceSL --