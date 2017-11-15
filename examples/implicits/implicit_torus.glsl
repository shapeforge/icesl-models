float distanceEstimator(vec3 p) {
	return 0.01*(pow(sqrt(p.x*p.x+p.y*p.y)-3,2) + p.z*p.z-1);
}