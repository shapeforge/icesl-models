-- (c) Sylvain Lefebvre - INRIA - 2013

bore = 2

pos = v(26.977503, 1.2443830, 0)
agl = -2.3080823 * 180.0 / Pi
m113 = translate(pos) * rotate(agl,Z)

pos = v(28.164534, 1.7381574, 0)
agl = 1.7639008 * 180.0 / Pi
m114 = translate(pos) * rotate(agl,Z)

pos = v(27.560066, 1.3100336,0)
agl = 1.7613611 * 180.0 / Pi
m115 = translate(pos) * rotate(agl,Z)

pos = v(27.514458, 1.2451988, 0)
agl = 1.7651474 * 180.0 / Pi
m116 = translate(pos) * rotate(agl,Z);

pos = v(28.127218, 2.0808647,0)
agl = 1.7754943 * 180.0 / Pi
m117 = translate(pos) * rotate(agl,Z)

pos = v(29.405464, 1.6973277,0)
agl = 0.78818381 * 180.0 / Pi
m118 = translate(pos) * rotate(agl,Z)

scl = 30

-- leg shape
h213 = scale(scl) * (m113 * v(-0.16637290, 0.0078625334,0))
h214 = scale(scl) * (m116 * v(0.0010045237, 0.65399033,0))
h215 = scale(scl) * (m114 * v(0.33230287, -0.0081313932,0))
h216 = scale(scl) * (m114 * v(-0.35735485, 4.7104346e-005,0))
h217 = scale(scl) * (m115 * v(-0.062266462, 0.010620555,0))
h218 = scale(scl) * (v(27.674820, 0.68528634,0))
h219 = scale(scl) * (m115 * v(0.63784134, -0.0077153589,0))
f221 = scale(scl) * (m118 * v(-0.030571532, 0.76214552,0))
e220 = scale(scl) * (m118 * v(-0.011682510, -0.72903293,0))

d = h213 - h214
leverlen = math.sqrt( dot(d,d) )
print('lever length = ' .. leverlen)

-- globals
leg_attach_thickness = 4.5 -- from spiderleg
spacing = 6
thickness = 3
axel_bevel = 1
axel_bevel_ratio = 1.7
leg_spacing = leg_attach_thickness + axel_bevel*2
wheel_radius = leverlen + bore
bore_side = 3
axel_side_length = thickness+0.4
square_axel_len = 7
inner_length = (leg_spacing + thickness)*7 + thickness
tolerance = 0.3
