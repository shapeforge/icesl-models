dofile(Path..'servo.lua')

--

-- parameters

delta = 26.5
arm_u_h = 30
arm_u_bore_spacing = 20
arm_u_bore_radi = 2

--

delta = math.max(delta,hs311_height_with_wheel()/2)

tr_arm =  translate(delta,0,20) * rotate(0,90,0)

-- first bracket
joint_top = 
    hs311_fixture_pos() * union(
    translate(0,0,0) * scale(25,60,3) * translate(0,0,-0.5) * box(1),
    translate(21,-10.5,0) * scale(9,39,3) * translate(-0.5,0,-0.5) * box(1)
)	
joint_top = difference(joint_top,hs311_bore(3))

-- second bracket
joint_top = union( joint_top ,
    translate(0,0,-17) * hs311_fixture_pos() * union(
    translate(0,0,0) * scale(25,60,3) * translate(0,0,-0.5) * box(1),
    translate(21,-10.5,0) * scale(9,39,3) * translate(-0.5,0,-0.5) * box(1))	
)
joint_top = difference(joint_top,translate(0,0,-17) * hs311_bore(3))

-- axis on other side
axis_d = 4
axis_h = 4
axis = union{
    translate(0,0,-delta*2) * rotate(0,180,0) * cylinder(axis_d,axis_h),
    translate(0,0,-delta*2-axis_h) * rotate(0,180,0) * cone(axis_d,7,3)
}
joint_top = union{ joint_top , axis }

-- U bracket
l = delta*2 - hs311_fixture_height() + tol
ubr = union{
    translate(0,10,-delta*2) * scale(8,60,3) * translate(0,0,0.5) * box(1),
    translate(0,39,-delta*2) * scale(8,3,l-tol) * translate(0,0,0.5) * box(1),
    translate(0,-18.5,-delta*2) * scale(8,3,l-tol) * translate(0,0,0.5) * box(1) 
}
joint_top = union( joint_top , ubr )

--joint_top = axis
base = difference{
               translate(0,0,-1) * cylinder(25,3),
			   translate(-26,0,-1.5) * scale(20,50,4) * translate(0,0,0.5) * box(1),
			   translate(19.9,0,-1.5) * scale(20,50,4) * translate(0,0,0.5) * box(1),
			}

-- support bars
support = union{
  translate(-9,0,0) * rotate(0,-45,0) * scale(2,5,23.5) * translate(0,0,0.5) * box(1),
  translate(-9,16.5,0) * rotate(0,-45,0) * scale(2,5,23.5) * translate(0,0,0.5) * box(1),
  translate(-9,-16.5,0) * rotate(0,-45,0) * scale(2,5,23.5) * translate(0,0,0.5) * box(1),
  tr_arm * translate(11.4,39.3,-16.6) * scale(2,2,17) * translate(0,0,-0.5) * box(1),
  tr_arm * translate(-11.4,39.3,-16.6) * scale(2,2,17) * translate(0,0,-0.5) * box(1),
  tr_arm * translate(11.4,-18.7,-16.6) * scale(2,2,17) * translate(0,0,-0.5) * box(1),
  tr_arm * translate(-11.4,-18.7,-16.6) * scale(2,2,17) * translate(0,0,-0.5) * box(1),
  tr_arm * translate(-11.4,10,-16.6) * scale(2,2,17) * translate(0,0,-0.5) * box(1),
}

joint = union{ base, tr_arm * joint_top} -- , support}
joint = difference( joint , hs311_wheel_bore() )

-------------- arm bottom

arm_dish = difference{ translate(0,0,-1) * cylinder(15,3),  
                                 translate(22,0,-1.5) * scale(20,50,4) * translate(0,0,0.5) * box(1),
}
arm_fork = translate(0,0,-delta*2-tol) * rotate(0,180,0) * difference{ cylinder(10,3),  
                                 translate(-22,0,-0.5) * scale(20,50,4) * translate(0,0,0.5) * box(1),
								 cylinder(axis_d+tol,3),  
                                 scale(20,axis_d*2+tol*2,3) * translate(-0.5,0,0.5) * box(1),
                                 translate(22,0,-1.5) * scale(20,50,4) * translate(0,0,0.5) * box(1),
                                 }

arm_u = difference{
union{
    translate(0,0,-1) * scale(arm_u_h,axis_d*2+tol*2,3) * translate(-0.5,0,0.5) * box(1),
    translate(-5,0,-delta*2-tol-3) * scale(arm_u_h-5,axis_d*2+tol*2,3) * translate(-0.5,0,0.5) * box(1),
    translate(-arm_u_h,0,0) * scale(3,axis_d*2+tol*2,delta*2+tol+3) * translate(0.5,0,-0.5) * box(1),
},
translate(-arm_u_h,0,-delta-arm_u_bore_spacing/2) * rotate(0,90,0) * cylinder(arm_u_bore_radi+tol,5),
translate(-arm_u_h,0,-delta+arm_u_bore_spacing/2) * rotate(0,90,0) * cylinder(arm_u_bore_radi+tol,5)
}
								 
arm_btm = difference( union{ arm_dish, arm_fork, arm_u } , hs311_wheel_bore() )

-------------- arm top

arm_top_w = 30
arm_top_delta = 5
arm_top_h = 33

arm_top_bar = difference{
  scale(3,axis_d*2+tol*2,arm_top_w) * translate(0.5,0,0) * box(1),
  translate(0,0,-arm_u_bore_spacing/2) * rotate(0,90,0) * cylinder(arm_u_bore_radi+tol,5),
  translate(0,0,arm_u_bore_spacing/2) * rotate(0,90,0) * cylinder(arm_u_bore_radi+tol,5)
}

arm_top_u = difference{union{
	  arm_top_bar,
	  translate(-arm_top_h,0,0) * arm_top_bar,
	  scale(arm_top_w,axis_d*2+tol*2,10) * translate(-0.5,0,0) * box(1),
	},
	translate(-arm_top_h/2-arm_u_bore_spacing/2+1.5,5,0) * rotate(90,0,0) * cylinder(arm_u_bore_radi+tol,10),
	translate(-arm_top_h/2+arm_u_bore_spacing/2+1.5,5,0) * rotate(90,0,0) * cylinder(arm_u_bore_radi+tol,10),
}

arm_top = translate(-arm_u_h-arm_top_delta,0,-delta) * arm_top_u

-------------- cam slot

cam_d = 21.2
cam_h = 32.5
cam_w = 36.2

cam_top_bar = difference{
  scale(3,43.2,16) * translate(0.5,-0.5,0) * box(1),
}

cam_u = difference{union{
	  difference{
	    cam_top_bar,
		translate(0,-25,0)*rotate(0,90,0)*cylinder(2.5,3),
		translate(0,-25,0)*scale(3,4,20)*translate(0.5,0,0.5)*box(1)
	  },
	  translate(-cam_h-3,0,0) * cam_top_bar,
	  scale(cam_h,8,16) * translate(-0.5,-0.5,0) * box(1),
  	  translate(0,-25+6,0)*scale(5,3,16)*translate(-0.5,0.5,0)*box(1),
  	  translate(0,-25+6-cam_d-3,0)*scale(5,3,16)*translate(-0.5,0.5,0)*box(1),
  	  translate(-cam_h,0,0) * translate(0,-25+6,0)*scale(5,3,16)*translate(0.5,0.5,0)*box(1),
  	  translate(-cam_h,0,0) * translate(0,-25+6-cam_d-3,0)*scale(5,3,16)*translate(0.5,0.5,0)*box(1),
	},
	translate(-arm_top_h/2-arm_u_bore_spacing/2+1.5,0,0) * rotate(90,0,0) * cylinder(arm_u_bore_radi+tol,16),
	translate(-arm_top_h/2+arm_u_bore_spacing/2+1.5,0,0) * rotate(90,0,0) * cylinder(arm_u_bore_radi+tol,16),
}

cam_slot = translate(-arm_u_h-arm_top_delta,-20,-delta) * cam_u

cam = scale(cam_h,cam_d,cam_w) * translate(-0.5,-0.5,0) * box(1)
cam = translate(-arm_u_h-arm_top_delta,-20-19,-delta) * cam

----------------------

if false then
-- design

emit( hs311() )
emit( tr_arm * hs311() )

emit( joint )
emit( tr_arm * arm_btm )
emit( tr_arm * arm_top )
emit( tr_arm * cam_slot )
emit( tr_arm * cam )

else
-- print

emit( rotate(0,90,0) * joint )
--emit( translate(50,-20,arm_u_h-9.9) * rotate(90,-90,0) * arm_btm )
--emit( translate(-20,15,-5.5) * rotate(90,0,90) * translate(arm_u_h+arm_top_delta,0,delta) * arm_top )
--emit( translate(-5,45,24.6) * rotate(0,0,0) * cam_slot )

end
