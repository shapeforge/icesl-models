tess = ui_scalar('tesselation',0.4,0.0,1.0)
set_tesselation_factor(tess)

a = sphere(5)
b = translate(40, 0, 10) * scale(3) * a

emit(convex_hull(merge({a, b})))
