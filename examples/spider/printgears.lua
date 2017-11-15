dofile(Path .. 'spiderbody.lua')

emit( spidermotorgear() )
emit( translate(25,25,0) * spiderspinegear() )
emit( translate(-25,25,0) * spiderspinegear() )
