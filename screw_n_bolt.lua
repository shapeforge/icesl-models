function circle_offset(r,o)
  local tbl = {}
  local n = 128
  for i=1,n do 
   local a = 360*i/n
   tbl[i] = r * v(cos(a),sin(a),0) + o
  end
  return tbl
end

function bolt(head_sz,head_h)
  local head = intersection{
    cube(head_sz,30,head_h),
    rotate(0,0,60)*cube(head_sz,30,head_h),
    rotate(0,0,120)*cube(head_sz,30,head_h),
    }
  return head
end

function screw(ra,rs,len)
  local all_tbl={}
  local n = len*10
  local a
  for h = 1,n do
    a = h * 10
    all_tbl[h] = circle_offset(ra,v(rs*cos(a),rs*sin(a),h/10))
  end
  local head_sz = ra*2.5
  local head_h  = ra/1.2
  local head    = bolt(head_sz,head_h)
  local s = union{
    translate(0,0,head_h)*sections_extrude(all_tbl),
    translate(0,0,head_h)*translate(rs*cos(a),rs*sin(a),n/10)*cone(ra,ra/2,ra/2),
    head
    }
  return s
end

emit(translate(20,0,0)*screw(7,0.5,20))

b = translate(0,0,0)*difference( 
   bolt(20,10),
   translate(0,0,-10)*screw(7.3,0.5,20)
   )
emit(b)
