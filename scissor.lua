
ld = 20
lu = 20
w = 7
t = 2
space = 0.4
crd_small = 2
crd_large = 3.1
tolerance = 0.2

h = t*2+space
-- verticals
up = translate(0,0,h/2) * scale(w,t,h) * box(1)
-- up bar
bup = translate(0,0,t+space+t/2) * scale(w,lu,t) * box(1)
bupaux = translate(0,0,t+space+t/4) * scale(crd_small*2.0,lu-t,t/2) * box(1)
bup = difference( bup, bupaux )
bup = difference( bup, translate(0,0,t+space) * cone(crd_small,crd_large,t) )
-- down bar
bdwn = translate(0,0,t/2) * scale(w,ld,t) * box(1)
bdwn = difference(bdwn, translate(0,0,0) * cone(crd_large,crd_small,t) )

function bar_dud()

  b = union({
     bdwn,
     translate(0,ld/2,0) * up,
	 translate(0,ld/2+lu/2,0) * bup,
	 translate(0,ld/2+lu,0) * up,
	 translate(0,ld+lu,0) * bdwn})
  return translate(0,-lu/2-ld/2,0) * b

end

function bar_udu()

  b = union({
    translate(0,-lu/2,0) * up,
    translate(0,0,0) * bup,
    translate(0,lu/2,0) * up,
    translate(0,lu/2+ld/2,0) * bdwn,
    translate(0,lu/2+ld,0) * up,
    translate(0,lu+ld,0) * bup,
    translate(0,lu+ld+lu/2,0) * up,
    })
  return translate(0,-lu/2-ld/2,0) * b

end

function pin()

  p = cylinder(crd_small-tolerance,t*2+space)
  p = union(p , cone(crd_large-tolerance,crd_small-tolerance,t) )
  p = union(p , translate(0,0,t+space) * cone(crd_small-tolerance,crd_large-tolerance,t) )
  c = cylinder(crd_large-tolerance*2.5,t*2+space)
  return intersection(p,c)

end

pattern = union({
bar_dud(),
rotate(0,0,90) * bar_udu(),
pin(),
})

endpins = union(
translate(0,ld/2+lu/2,0) * pin(),
translate(ld/2+lu/2,0,0) * pin()
)

trl = v(ld/2+lu/2,ld/2+lu/2,0)
pos = v(0,0,0)
for i=0,3 do
  emit(translate(pos) * pattern)
  emit(translate(pos) *endpins)
  pos = pos + trl
end

-- ---------------------------------------

-- emit(pin())

--p = v(0,ld+lu/2,0)
--p = rotate(0,0,90) * p
--o = v(0,ld/2,0)
--emit( translate(o-p) * rotate(0,0,90) * bar() )
--emit( translate(o) * pin())