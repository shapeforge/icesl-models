s = difference(sphere(10),translate(10,0,0)*sphere(15))

-- computes the bounding box of s
bx = bbox(s)
if bx:empty() then
  print('oops, box is empty!')
else
  ex = bx:extent()
  cr  = bx:min_corner()
  print('extent = ' .. ex.x .. ' ' .. ex.y .. ' ' .. ex.z .. '\n')
  print('mincorner = ' .. cr.x .. ' ' .. cr.y .. ' ' .. cr.z .. '\n')
  c = translate(cr.x+1,cr.y+1,cr.z)*ocube(ex.x-2,ex.y-2,ex.z-1)
  emit(c)
end

emit(s)
