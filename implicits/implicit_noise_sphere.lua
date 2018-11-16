sphere = implicit_distance_field(v(-8,-8,-8), v(8,8,8), [[
float distance(vec3 p) {
	return sphere(p,10);
}
]])

emit(rotate(25,10,7) * sphere)
