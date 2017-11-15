-- (c) Sylvain Lefebvre - INRIA - 2013

dofile(Path .. 'spiderbody.lua')
dofile(Path .. 'spiderspine.lua')

emit( spiderbodyandspines() )
-- emit( spiderbody() )
-- emit( translate(30,-70+tolerance,41) * spiderspine() )
emit( translate(47,-70+tolerance,19.5) * spiderlegguide() )

if true then

  xtrl = h213.x
  h218 = translate(bodyw - xtrl,0,0) * h218
  h213 = translate(bodyw - xtrl,0,0) * h213

  motorh = 1.5
  emit( translate(0,-40,45+motorh) * translate((h218+o218)*0.5) * rotate(-90,X) * load_centered(Path .. 'servo.stl'))
  emit( rotate(90,X) * translate(0,24+motorh,18.5) * translate((h218+o218)*0.5) * rotate(-90,X) * load_centered(Path .. 'servo-mount.stl'))

  motorgear = spidermotorgear()
  
  motorctr = rotate(90,X) * translate(0,36.2,-10) * v(0,0,0)
  emit( translate(motorctr) * rotate(90,-6,0) * motorgear )
  
  sgear = spiderspinegear()
  emit (
	  translate(0,-2,0) *
      rotate(90,X) * 
	  translate(0,0,-10) *
	  translate(h213) * rotate(180,Z) * sgear )
  emit (
	  translate(0,-2,0) *
      rotate(90,X) *
	  translate(0,0,-10) *
	  translate(o213) * rotate(0,0,180+12) * sgear )
  
end
