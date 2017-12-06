-- inspired from testsphere in MB customizer

dofile(Path .. '../../icesl-models/libs/bar.lua')

if ui_scalar then
	nbr=math.floor(ui_scalar('num',16, 5,24))
	taille=ui_scalar('size1',2, 1,8)
	taille2=ui_scalar('size2',20, 10,40)
else
	nbr=12
	taille=2
	taille2=20
end

fermetrou=math.sqrt(0.5)*3

sphs={}
for i=0,nbr do
        for j=0,nbr/2-1 do
		  a=360*i/nbr
		  b=360*j/nbr
		  c=360*(i+1)/nbr
		  d=360*(j+1)/nbr
          v0 = v(sin(b)*sin(a)*taille2,sin(b)*cos(a)*taille2,cos(b)*taille2)
          v1 = v(sin(d)*sin(c)*taille2,sin(d)*cos(c)*taille2,cos(d)*taille2)
		  br = bar2(v0,v1, 
		    taille*(cos(d/fermetrou)), 
			taille*(cos(b/fermetrou)) 
   		  )
          table.insert(sphs, br )
		  -- table.insert(sphs, bar(v0,v1, 1) )
		end
end
emit(merge(sphs))
