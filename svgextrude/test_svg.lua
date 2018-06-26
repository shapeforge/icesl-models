shapes = svg_ex(Path .. 'test.svg',90)

m = {}
for _,contour in ipairs(shapes) do
  table.insert(m,linear_extrude_from_oriented(v(0,0,1),contour:outline()))
end
emit(merge(m))
