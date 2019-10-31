--Happy Halloween with IceSL--
--made by Jimmy Etienne and Pierre-Alexandre Hugron--
--30/10/19-- 

emit_body = true
emit_hat = true

enable_variable_cache = true

outer_radius = 70
inner_radius = 38
thickness    = 2
height       = 61


global_scale = 0.4


s = scale(1.0 , 1.6 ,   2 * height / outer_radius) * sphere(outer_radius - inner_radius)
s2 = scale(0.8 , 1.6 ,  2 * height / outer_radius - 0.3) * sphere(outer_radius - inner_radius - thickness)
c = translate(0 , 0 , -86) * cube(200 , 200 , 40)

n = 13
angle = 360/n
part = Void
for i=0, n do  
  part = union(part, rotate(0,0,i*angle) * translate(0,inner_radius,0) * s)
end

part2 = Void
for j=0 , n do  
  part2 = union(part2, rotate(0,0,j*angle) * translate(0,inner_radius,0) * s2)
end

p = difference{
  part,
  part2,
  c
}

if not vx then
  vx = to_voxel_distance_field(p,0.7,3)
  smooth_voxels_preserve_volume(vx, 2)
end



--face

triangle = { v(10,12), v(0,31), v(-10,-10) } 
triangle_nose = { v(0,0), v(0,38), v(-20,0) } 
dir      = v(0,0,outer_radius)	
pupil = (translate(29, 24, 0) * cylinder(5,outer_radius))
eye1 = D(( translate( 23, 24, 0) * rotate (0, 0,-57) * linear_extrude_from_oriented(dir, triangle) ), pupil)
eye2 = mirror(X) * eye1

nose = scale(0.5) * translate( 0, 0, 0) * rotate (0, 0, 0) * linear_extrude_from_oriented(dir, triangle_nose)
nose = rotate(0, 0, 9) * union(nose, mirror(X) * nose)


eyes = (union (eye1, eye2))
--emit (eyes)
--emit (pupil)



c1 =  translate(0,  0, 0) * cylinder(40, outer_radius)
c2 =  translate(0, 25, 0) * cylinder(45, outer_radius)
mouth = difference (c1, c2)


teeth = cube(18,10,outer_radius)
mouth = D(mouth, rotate(0,0,9) * translate(3,-19,0) * teeth)
mouth = D(mouth, rotate(0,0,-2) * translate(-2,-36,0) * teeth)
mouth = D(mouth, rotate(0,0,20) * translate(20,-37,0) * teeth)
mouth = D(mouth, rotate(0,0,-24) * translate(-15,-20,0) * teeth)

face = union({eyes, nose, mouth})
face = translate(0, outer_radius + inner_radius,0) * rotate (90, 0, 0) * face

cut_cylinder = cone (25, 100, 100)



---------------------------------
---------------------------------
seed = 10000

------ Tree

-- Bezier spline interpolation
function bezier(u,p0,p1,p2,p3)
  local tensil = 0.125
  local t_p1 = p1 + (p2 - p0)*tensil
  local t_p2 = p2 - (p3 - p1)*tensil
  local u2 = u*u
  local u3 = u2*u
  local c = 3.0 * (t_p1 - p1)
  local b = 3.0 * (t_p2 - t_p1) - c
  local a = p2 - p1 - c - b
  return a * u3 + b * u2 + c * u + p1
end

-- interpolates a path using Bezier spline
function smooth(tbl)
  if not do_mesh then -- skip if not producing the final mesh
    return tbl
  end
  local num_start = #tbl
  local all = {}
  local num = #tbl
  local p0,p1,p2,p3
  for i,p in ipairs(tbl) do
    if i == 1 then
       p0 = p
       p1 = p
       p2 = p
       p3 = p
    else
       local pb = bezier(0.5,p0,p1,p2,p3)
       table.insert(all,p1)
       table.insert(all,pb)
    end
    p0 = p1
    p1 = p2
    p2 = p3
    p3 = p
  end
  return all
end

-- generates a path geometry using cones and spheres
function path(tbl,r_base)
    local r_tip = 1
    local r = r_base
    local prev
    local r_prev
    local all = {}
    local num = #tbl
    for i,p in ipairs(tbl) do
        if i == 1 then
          prev = p
          r_prev = r
        else
          if not do_mesh then
            r = math.max(r * 0.95,r_tip)
          else
            r = math.max(r * math.sqrt(0.95),r_tip)
          end
          table.insert(all,(cone(r_prev,r,prev,p)))
		  table.insert(all,(translate(prev)*sphere(r_prev)))
        end
        prev = p
        r_prev = r
    end
    return (union(all))
end

if emit_body then

  emit (scale(global_scale) * translate(-140,0,90.35) * rotate(0,0,180) * D(difference(vx, face), cut_cylinder),2)

end

---------------------------

if emit_hat then

  points = {v(0,0,9), v(-12,-13,33), v(0,0,42), v(0,0,50), v(-14,0,60)}
  stick = translate(0, 0, height/2) * path(smooth(points),7)
  if not vx_stick then
    vx_stick = to_voxel_distance_field(stick, 0.7, 4)
    smooth_voxels_preserve_volume(vx_stick, 1)
  end
  
  cut_cube = translate(0,0,44)*cube(outer_radius*2,outer_radius*2,100)

  emit ( scale(global_scale) * I(vx_stick,cut_cube),1)
  emit ( scale(global_scale) * I(I(vx, cut_cylinder), cut_cube),2)
  
end

---------------------------
