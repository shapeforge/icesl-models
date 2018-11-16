impl0 = implicit_solid(v(-5,-5,-5), v(5,5,5), 0.25, [[
float solid(vec3 p) {
	return 0.01*dot(abs(p),vec3(1.0)) - 1.0;
}
]])
emit(translate(15,15,0) * scale(1) * impl0)

impl1 = implicit_distance_field(v(-5,-5,-5), v(5,5,5), [[
float distance(vec3 p) {
	return 0.01*(sin(0.2*3.1415926*(p.x*p.x+p.y*p.y))/2.0 + p.z);
}
]])
emit(translate(-15,15,5) * scale(2) * impl1)

impl2 = implicit_solid_from_file(v(-5,-5,-5), v(5,5,5), 0.25, Path .. 'implicit_torus.glsl')
emit(translate(15,-15,-3) * rotate(90, Y) * scale(2) * impl2)

impl3 = implicit_distance_field_from_file(v(-3,-3,-4), v(3,3,4), Path .. 'implicit_drope.glsl')
emit(translate(-15,-15,5) * scale(3) * impl3)
