-- ---------------------------------------------
-- Pin Connectors V2
-- Tony Buser <tbuser@gmail.com>
-- modified by Zak Kus  <zakkus@gmail.com> 
-- 2013-02-03 sylefeb: ported to IceSL
-- ---------------------------------------------

function pin_solid(h, r, lh, lt)
  return union( {
    cylinder(r,h-lh),
    -- lip
    translate(0, 0, h-lh) * cone(r, r+(lt/2), lh*0.25),
    translate(0, 0, h-lh+lh*0.25) * cylinder(r+(lt/2), lh*0.25),   
    translate(0, 0, h-lh+lh*0.50) * cone(r+(lt/2), r-(lt/2), lh*0.50)
  } )
end

function pinhole_impl(h, r, lh, lt, t, tight) 
  -- h = shaft height
  -- r = shaft radius
  -- lh = lip height
  -- lt = lip thickness
  -- t = tolerance
  -- tight = set to false if you want a joint that spins easily
  
  c = cylinder(r,h+0.2)
  if tight == false then
    c = union(c,cylinder(r+(t/2)+0.25,h+0.2))
  end

  return union( {
    pin_solid(h, r+(t/2), lh, lt),
	c,
    -- widen the entrance hole to make insertion easier
    translate(0, 0, -0.1) * cone(r+(t/2)+(lt/2), r, lh/3)
  } )
end

function pinhole(args)
	return pinhole_impl(
		args.h or 10, 
		args.r or 4, 
		args.lh or 3, 
		args.lt or 1, 
		args.t or 0.3, 
		args.tight or true) 
end

-- just call pin instead, I made this module because it was easier to do the rotation option this way
-- since openscad complains of recursion if I did it all in one module
function pin_vertical(h, r, lh, lt)
  -- h = shaft height
  -- r = shaft radius
  -- lh = lip height
  -- lt = lip thickness

  return difference( {
    pin_solid(h, r, lh, lt),
    -- center cut
    translate(-r*0.5/2, -(r*2+lt*2)/2, h/2) * scale(r*0.5, r*2+lt*2, h) * translate(0.5,0.5,0.5) * box(1),
    translate(0, 0, h/4) * cylinder(r/2.5, h+lh),
    -- center curve
    translate(0, 0, h/2) * rotate(90, 0, 0) * translate( Z * -r ) * cylinder(r*0.5/2, r*2),
    -- side cuts
						translate(-r*2, r*.85, -1) * scale(r*4, r*2, h+2) * translate(0.5,0.5,0.5) * box(1),
	mirror(v( 0, 1, 0 )) * translate(-r*2, r*.85, -1) * scale(r*4, r*2, h+2) * translate(0.5,0.5,0.5) * box(1),
  } )
end

-- call pin with side=true instead of this
function pin_horizontal(h, r, lh, lt)
  -- h = shaft height
  -- r = shaft radius
  -- lh = lip height
  -- lt = lip thickness
  return translate(0, h/2, r*1.125-lt) * rotate(90, 0, 0) * pin_vertical(h, r, lh, lt);
end

function pin_impl(h, r, lh, lt, side) 
  -- h = shaft height
  -- r = shaft radius
  -- lh = lip height
  -- lt = lip thickness
  -- side = set to true if you want it printed horizontally

  if side then
    return pin_horizontal(h, r, lh, lt);
  else
    return pin_vertical(h, r, lh, lt);
  end
end

function pin(args)
	return pin_impl(
		args.h or 10, 
		args.r or 4, 
		args.lh or 3, 
		args.lt or 1, 
		args.side or false
	)
end

function pintack_impl(h, r, lh, lt, bh, br)
  -- bh = base_height
  -- br = base_radius
  
  return union(
    cylinder(br,bh),
    translate(0, 0, bh) * pin{h, r, lh, lt}
	)
end

function pintack(args)
	return pintack_impl(args.h or 10, args.r or 4, args.lh or 3, args.lt or 1, args.bh or 3, args.br or 8.75)
end

function pinpeg_impl(h, r, lh, lt)
  return union(
    translate(0, -h/4+0.05, 0) * pin{h=h/2+0.1, r=r, lh=lh, lt=lt, side=true},
    translate(0, h/4-0.05, 0) * rotate(0, 0, 180) * pin{h=h/2+0.1,r=r,lh=lh,lt=lt, side=true}
  )
end

function pinpeg(args)
	return pinpeg_impl(args.h or 20, args.r or 4, args.lh or 3, args.lt or 1)
end

-- ---------------------------------------------
-- ---------------------------------------------

-- TEST

function pins_test()

tolerance = 0.3
  
emit( translate(-12, 12, 0) * pinpeg{h=20, lt=3} )
emit( translate(12, 12, 0) * pintack{h=10} )
  
emit( difference( {
    union(
      translate(0, -12, 2.5)*scale(59, 20, 4)*box(1),
      translate(24, -12, 7.5)*scale(12, 20, 14)*box(1)
    ),
    translate(-24, -12, 0)*pinhole{h=5, t=tolerance},
    translate(-12, -12, 0)*pinhole{h=5, t=tolerance, tight=false},
    translate(0, -12, 0)*pinhole{h=10, t=tolerance},
    translate(12, -12, 0)*pinhole{h=10, t=tolerance, tight=false},
    translate(24, -12, 15)*rotate(0, 180, 0)*pinhole{h=10, t=tolerance}
  } ) )

end

-- pins_test()

-- ---------------------------------------------
