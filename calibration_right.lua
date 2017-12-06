lx = scale(100,0.45,0.4) * box(1)
ly = scale(0.45,100,0.4) * box(1)

emit(lx,0)
emit(translate(0,-50,0) * lx,0)
emit(translate(0, 50,0) * lx,0)

emit(ly,0)
emit(translate(-50,0,0) * ly,0)
emit(translate( 50,0,0) * ly,0)
