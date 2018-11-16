float distance(vec3 p) {
	return 0.01*(p.z - 7*p.x*exp(-p.x*p.x-p.y*p.y));
}