r = 0
s = scale(0.7)
k = rotate(r,Z)*s*(load(Path .. 'meshes/2color_dragon_heart.stl'))
k1 = rotate(r,Z)*s*(load(Path .. 'meshes/2color_heartless_dragon.stl'))
kt = translate(-33.0,0.0,0.0)*k
k1t = translate(-33.0,0.0,0.0)*k1

emit(k,1)
emit(k1,0)
--it1 = intersection(k,kt)
--it2 = intersection(k1,k1t)

--emit(it1,0)
--emit(it2,0)


eye = translate(-4.8,-17.2,6.9)*sphere(2.2)
eyes = rotate(r,Z)*union(eye,translate(-7.3,0,0)*eye)
emit(eyes,1)


set_brush_color(0,0.7,0.1,0.1);
set_brush_color(1,0.0,0.0,0.0);
