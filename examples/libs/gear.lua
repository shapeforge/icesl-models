-- Parametric Involute Bevel and Spur Gears by GregFrost
-- It is licensed under the Creative Commons - GNU LGPL 2.1 license.
-- © 2010 by GregFrost, thingiverse.com/Amp
-- http:--www.thingiverse.com/thing:3575 and http:--www.thingiverse.com/thing:3752

-- 2013-02-02 sylefeb - ported to IceSL

-- ---------------------------------------------

function involute(base_radius, involute_angle)
  return v( 
	base_radius*(cos(involute_angle) + involute_angle*math.pi/180*sin(involute_angle)),
	base_radius*(sin(involute_angle) - involute_angle*math.pi/180*cos(involute_angle))
  )
end

-- ---------------------------------------------

function mirror_point(coord)
	return v( coord.x, - coord.y )
end

-- ---------------------------------------------

function rotate_point(rotate, coord)
 return v(
	cos(rotate) * coord.x + sin(rotate) * coord.y,
	cos(rotate) * coord.y - sin(rotate) * coord.x
  )
 end

 -- ---------------------------------------------

function involute_intersect_angle(base_radius, radius) 
  return math.sqrt(math.pow(radius/base_radius, 2) - 1) * 180 / math.pi;
end

 -- ---------------------------------------------

function involute_bevel_gear_tooth(
	back_cone_radius,
	root_radius,
	base_radius,
	outer_radius,
	pitch_apex,
	cone_distance,
	half_thick_angle,
	involute_facets)

	min_radius = math.max(base_radius*2,root_radius*2)

	pitch_point =
		involute (
			base_radius*2,
			involute_intersect_angle (base_radius*2, back_cone_radius*2))
	pitch_angle = atan2(pitch_point.y, pitch_point.x)
	centre_angle = pitch_angle + half_thick_angle

	start_angle = involute_intersect_angle (base_radius*2, min_radius)
	stop_angle = involute_intersect_angle (base_radius*2, outer_radius*2)
	
--	res=(involute_facets!=0)?involute_facets:($fn==0)?5:$fn/4;
	res = involute_facets
	if involute_facets == 0 then
		res = 32
	end
	
	verts = {}
	tris  = {}
	table.insert(verts,v(back_cone_radius*2+0.1,0,cone_distance*2))
	table.insert(verts,v(0.1,0,0))
	n     = 2
	t     = 0
	for i=1,res do
		point1 = involute (base_radius*2,start_angle+(stop_angle - start_angle)*(i-1)/res)
		point2 = involute (base_radius*2,start_angle+(stop_angle - start_angle)*(i)/res)

		side1_point1 = rotate_point(centre_angle, point1)
		side1_point2 = rotate_point(centre_angle, point2) 
		side2_point1 = mirror_point(rotate_point (centre_angle, point1))
		side2_point2 = mirror_point(rotate_point (centre_angle, point2))
		if i == 1 then
			table.insert(verts,side1_point1)
			n = n + 1
			table.insert(verts,side2_point1)
			n = n + 1
		end
		table.insert(verts,side1_point2)
		n = n + 1
		table.insert(verts,side2_point2)
		n = n + 1
		table.insert(tris,v(n-4,n-3,n-2))
		table.insert(tris,v(n-2,n-3,n-1))
		table.insert(tris,v(n-4,n-2,0))
		table.insert(tris,v(n-1,n-3,0))
	end
	table.insert(tris,v(0,n-2,n-1))
	table.insert(tris,v(0,1,2))
	table.insert(tris,v(0,3,1))
	table.insert(tris,v(1,3,2))
	
	return translate(0,0,pitch_apex) *
		rotate (0,-atan(back_cone_radius/cone_distance),0) *
		translate (-back_cone_radius*2,0,-cone_distance*2) * 
		polyhedron(verts,tris)
	
end

-- ---------------------------------------------

function bevel_gear_impl (
	number_of_teeth,
	cone_distance,
	face_width,
	outside_circular_pitch,
	pressure_angle,
	clearance,
	bore_diameter,
	gear_thickness,
	backlash,
	involute_facets,
	finish )
	
	-- Pitch diameter: Diameter of pitch circle at the fat end of the gear.
	outside_pitch_diameter  =  number_of_teeth * outside_circular_pitch / 180;
	print('pitch diameter: '..outside_pitch_diameter)
	outside_pitch_radius = outside_pitch_diameter / 2;

	-- The height of the pitch apex.
	pitch_apex = math.sqrt (math.pow (cone_distance, 2) - math.pow (outside_pitch_radius, 2));
	print('pitch apex: '..pitch_apex)
	pitch_angle = asin (outside_pitch_radius/cone_distance);
	print('pitch_angle: '..pitch_angle)

	bevel_gear_flat = 0
	bevel_gear_back_cone = 1

	if finish == -1 then
	  if pitch_angle < 45 then
	    finish = bevel_gear_flat
	  else
	    finish = bevel_gear_back_cone
      end	  
	end 

	apex_to_apex=cone_distance / cos (pitch_angle);
	back_cone_radius = apex_to_apex * sin (pitch_angle);

	-- Calculate and display the pitch angle. This is needed to determine the angle to mount two meshing cone gears.

	-- Base Circle for forming the involute teeth shape.
	base_radius = back_cone_radius * cos (pressure_angle);

	-- Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / outside_pitch_diameter;

	-- Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1.0 / pitch_diametrial;
	-- Outer Circle
	outer_radius = back_cone_radius + addendum;

	-- Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;
	dedendum_angle = atan (dedendum / cone_distance);
	root_angle = pitch_angle - dedendum_angle;

	root_cone_full_radius = tan (root_angle)*apex_to_apex;
	back_cone_full_radius=apex_to_apex / tan (pitch_angle);

	back_cone_end_radius =
		outside_pitch_radius -
		dedendum * cos (pitch_angle) -
		gear_thickness / tan (pitch_angle);
	back_cone_descent = dedendum * sin (pitch_angle) + gear_thickness;

	-- Root diameter: Diameter of bottom of tooth spaces.
	root_radius = back_cone_radius - dedendum;

	half_tooth_thickness = outside_pitch_radius * sin (360 / (4 * number_of_teeth)) - backlash / 4;
	half_thick_angle = asin (half_tooth_thickness / back_cone_radius);

	face_cone_height = apex_to_apex-face_width / cos (pitch_angle);
	face_cone_full_radius = face_cone_height / tan (pitch_angle);
	face_cone_descent = dedendum * sin (pitch_angle);
	face_cone_end_radius =
		outside_pitch_radius -
		face_width / sin (pitch_angle) -
		face_cone_descent / tan (pitch_angle);

	-- For the bevel_gear_flat finish option, calculate the height of a cube to select the portion of the gear that includes the full pitch face.
	bevel_gear_flat_height = pitch_apex - (cone_distance - face_width) * cos (pitch_angle);

--	translate([0,0,-pitch_apex])
	allteeth = {}
	for i = 1,number_of_teeth do
		table.insert( allteeth,
			rotate(0,0,i*360/number_of_teeth) *
			involute_bevel_gear_tooth(
				back_cone_radius,
				root_radius,
				base_radius,
				outer_radius,
				pitch_apex,
				cone_distance,
				half_thick_angle,
				involute_facets) )
	end
	teeth = union(allteeth)

	if finish == bevel_gear_back_cone then
		m_finish1 = translate (0,0,-back_cone_descent) *
		cone(
--			$fn=number_of_teeth*2,
			back_cone_end_radius,
			back_cone_full_radius*2,
			apex_to_apex + back_cone_descent)
	else
		m_finish1 = translate(-1.5*outside_pitch_radius,-1.5*outside_pitch_radius,0)
		* scale(3*outside_pitch_radius,3*outside_pitch_radius,bevel_gear_flat_height)
		* translate(0.5,0.5,0.5) * box(1)
	end

	if finish == bevel_gear_back_cone then
		m_finish2 = translate (0,0,-face_cone_descent)
		* cone (
			face_cone_end_radius,
			face_cone_full_radius * 2,
			face_cone_height + face_cone_descent+pitch_apex)
	else
		m_finish2 = Void
	end

	g = difference ( {
		intersection (
			union(
				rotate (0,0,half_thick_angle) *
				translate (0,0,pitch_apex-apex_to_apex) *
				cone(root_cone_full_radius,0,apex_to_apex), -- $fn=number_of_teeth*2
				teeth
			) ,
			m_finish1
		) ,
		m_finish2,
		translate (0,0,pitch_apex - apex_to_apex) * cylinder(bore_diameter/2,apex_to_apex)
	} )
	-- return teeth
	return g
			
end

-- ---------------------------------------------

function bevel_gear(params)
      return bevel_gear_impl(
			  params.number_of_teeth or 12,
			  params.cone_distance or 50,
			  params.face_width or 20,
			  params.outside_circular_pitch or 1000,
			  params.pressure_angle or 30,
			  params.clearance or 0.2,
			  params.bore_diameter or 4,
			  params.gear_thickness or 15,
			  params.backlash or 0,
			  params.involute_facets or 0,
			  params.finish or -1
             )
end

-- ---------------------------------------------

function bevel_gear_pitch_apex(params)
	outside_pitch_diameter  =  params.number_of_teeth * params.outside_circular_pitch / 180;
	outside_pitch_radius = outside_pitch_diameter / 2;
	pitch_apex = math.sqrt (math.pow (params.cone_distance, 2) - math.pow (outside_pitch_radius, 2));
	return pitch_apex
end

-- ---------------------------------------------

function bevel_gear_height(
	number_of_teeth,
	outside_circular_pitch,
	cone_distance,
	face_width
	)
return (math.sqrt(
          math.pow(cone_distance, 2)
        - math.pow((number_of_teeth * outside_circular_pitch / 180)/2, 2)
		)
		)
	- (cone_distance - face_width)
	* cos (asin (((number_of_teeth * outside_circular_pitch / 180)/2)/cone_distance));
end

-- ---------------------------------------------
-- ---------------------------------------------

function circle(r)
  points = {}
  N = 32
  for i = 1,N do
    a = i*math.pi*2/N
    p = v(r*math.cos(a),r*math.sin(a),0)
	table.insert(points,p)
  end
  return points
end

-- ---------------------------------------------

function involute_gear_tooth(
	pitch_radius,
	root_radius,
	base_radius,
	outer_radius,
	half_thick_angle,
	involute_facets)
	min_radius = math.max (base_radius,root_radius);

	pitch_point = involute(base_radius, involute_intersect_angle (base_radius, pitch_radius));
	pitch_angle = atan2(pitch_point.y, pitch_point.x);
	centre_angle = pitch_angle + half_thick_angle;

	start_angle = involute_intersect_angle (base_radius, min_radius);
	stop_angle = involute_intersect_angle (base_radius, outer_radius);

	res = 32;

	points = {}
	for i=1,res do
		point1=involute(base_radius,start_angle+(stop_angle - start_angle)*(i-1)/res)
		point2=involute(base_radius,start_angle+(stop_angle - start_angle)*i/res)
		side1_point1=rotate_point (centre_angle, point1)
		side1_point2=rotate_point (centre_angle, point2)
		table.insert(points,side1_point1)
		table.insert(points,side1_point2)
	end
	for i=res,1,-1 do
		point1=involute (base_radius,start_angle+(stop_angle - start_angle)*(i-1)/res)
		point2=involute (base_radius,start_angle+(stop_angle - start_angle)*i/res)
		side2_point1=mirror_point (rotate_point (centre_angle, point1))
		side2_point2=mirror_point (rotate_point (centre_angle, point2))
		table.insert(points,side2_point2)
		table.insert(points,side2_point1)
	end
	return points
end

-- ---------------------------------------------

function gear_shape (
	number_of_teeth,
	pitch_radius,
	root_radius,
	base_radius,
	outer_radius,
	half_thick_angle,
	involute_facets,
	rim_thickness)
	tooth = involute_gear_tooth (
					pitch_radius,
					root_radius,
					base_radius,
					outer_radius,
					half_thick_angle,
					involute_facets);
	tooth_ex = linear_extrude(v(0,0,rim_thickness),tooth)
	last = v(0,0,0)
	for _,p in pairs(tooth) do last = p end
	first = tooth[1]
	-- points={v(0,0,0)}
	teeth={}
	interior_outline={}
	for i = 1,number_of_teeth do
		r = rotate(0,0,i*360/number_of_teeth)
		table.insert(teeth,r * tooth_ex)
		table.insert(interior_outline,r * first)
		table.insert(interior_outline,r * last)
	end
	interior = linear_extrude(v(0,0,rim_thickness),interior_outline)
	return union(merge(teeth),interior)
--	rotate (half_thick_angle) circle ($fn=number_of_teeth*2, r=root_radius);
end

-- ---------------------------------------------

function gear_impl(
	number_of_teeth,
	circular_pitch, 
	diametral_pitch,
	pressure_angle,
	clearance,
	gear_thickness,
	rim_thickness,
	rim_width,
	hub_thickness,
	hub_diameter,
	bore_diameter,
	circles,
	backlash,
	twist,
	involute_facets,
	flat)

	if ( circular_pitch < 0 and diametral_pitch < 0 ) then
		print("!! gear module needs either a diametral_pitch or circular_pitch !!");
		return Void
	end

	-- Convert diametrial pitch to our native circular pitch
	if circular_pitch < 0 then
		circular_pitch = 180/diametral_pitch
	end

	-- Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;
	print("Teeth:" .. number_of_teeth .. " Pitch radius:" .. pitch_radius);

	-- Base Circle
	base_radius = pitch_radius*cos(pressure_angle);

	-- Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;

	-- Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;

	--Outer Circle
	outer_radius = pitch_radius+addendum;

	-- Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;

	-- Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
	backlash_angle = backlash / pitch_radius * 180 / math.pi;
	half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;

	-- Variables controlling the rim.
	rim_radius = root_radius - rim_width;

	-- Variables controlling the circular holes in the gear.
	circle_orbit_diameter=hub_diameter/2+rim_radius;
	circle_orbit_curcumference=math.pi*circle_orbit_diameter;

	-- Limit the circle size to 90% of the gear face.
	circle_diameter=
		math.min (
			0.70*circle_orbit_curcumference/circles,
			(rim_radius-hub_diameter/2)*0.9);

    sub0 = Void
	if (gear_thickness < rim_thickness) then
		sub0 = translate(0,0,gear_thickness) * cylinder (rim_radius,rim_thickness-gear_thickness+1)
    end
	
	gearmain = gear_shape (
		number_of_teeth,
		pitch_radius,
		root_radius,
		base_radius,
		outer_radius,
		half_thick_angle,
		involute_facets,
		rim_thickness)

	gbody = difference(gearmain,sub0)
	
	un0 = Void
	if (gear_thickness > rim_thickness) then
		un0 = linear_extrude(v(0,0,gear_thickness), circle(rim_radius) )
	end
	if ((not flat) and (hub_thickness > gear_thickness)) then
		un0 = union(un0,
			translate(0,0,gear_thickness) *
			linear_extrude(v(0,0,hub_thickness-gear_thickness), circle(hub_diameter/2))
		)
	end
	allcircles = {Void}
	if (circles>0) then
		for i=0,circles-1 do
			table.insert( allcircles ,
				rotate(0,0,i*360/circles)
				* translate(circle_orbit_diameter/2,0,-1)
				* linear_extrude(v(0,0,math.max(gear_thickness,rim_thickness)+3),
								 circle(circle_diameter/2)
								 )
			)
		end
	end
	
	return difference({
			union (gbody,un0),
			translate(0,0,-1)
  			   * linear_extrude(v(0,0,2+math.max(rim_thickness,hub_thickness,gear_thickness)), circle (bore_diameter/2)),
			union(allcircles)
		})

end

-- ---------------------------------------------

function gear(params)
      return gear_impl(
			params.number_of_teeth or 15,
			params.circular_pitch or -1, 
			params.diametral_pitch or -1,
			params.pressure_angle or 28,
			params.clearance or 0.2,
			params.gear_thickness or 12,
			params.rim_thickness or 15,
			params.rim_width or 5,
			params.hub_thickness or 17,
			params.hub_diameter or 15,
			params.bore_diameter or 5,
			params.circles or 3,
			params.backlash or 0,
			params.twist or 0,
			params.involute_facets or 0,
			params.flat or false
    )
end

-- ---------------------------------------------

-- ---------------------------------------------
-- ---------------------------------------------

-- TEST
function gear_test()
--  b = bevel_gear{number_of_teeth=8,bore_diameter=2.5,cone_distance=50,outside_circular_pitch=400,face_width=10}
  b = gear({number_of_teeth=25,circular_pitch=350})
  emit(b)
end

-- gear_test()
