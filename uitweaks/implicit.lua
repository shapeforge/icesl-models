scl = ui_scalar('pscale',4.0,1.0,10.0)
sph = implicit(v(-15,-15,-15), v(15,15,15), [[
uniform float scl=4.5;
float perturb(vec3 p)
{
  vec3 t = vec3(3,0,0);
  return scl*abs(noise((p+t)/7.0+2.0));
}
float distanceEstimator(vec3 p) 
{
  return 
    min(
    min(
	min( 
	  0.3*(max(sphere(p,13),-sphere(p,12)) + perturb(p))
	,
	  0.3*(max(sphere(p,11),-sphere(p,10)) + perturb(p))
    )
	,
	min( 
	  0.3*(max(sphere(p,9),-sphere(p,8)) + perturb(p))
	,
	  0.3*(max(sphere(p,7),-sphere(p,6)) + perturb(p))
    )	
	)
	,
	min( 
	  0.3*(max(sphere(p,5),-sphere(p,4)) + perturb(p))
	,
	  0.3*(max(sphere(p,3),-sphere(p,2)) + perturb(p))
    )		
	)
	;
}
]])

r = ui_scalar('radius',12,8,20)
set_uniform_scalar(sph,'scl',scl)
s = 
union{
difference(
rotate(-30,0,0)*union{
  rotate(25,0,0)*sph,
  rotate(-5,0,0)*translate(0,0,-15)*cylinder(1.5,13),
  rotate(45,-20,0)*translate(0,0,-14)*cylinder(1.5,12),
  },
translate(0,0,-15)*cylinder(15,3)  
),
translate(0,-2,-12)*cylinder(8,1.0),
translate(0,-2,-12)*cylinder(r,0.3)  
}

emit(s)
