function print_vector(vector)
  print('x='..vector.x..', y='..vector.y..', z='..vector.z..'\n')
end

bed_x = ui_scalar('Bed size x (mm)', 215, 1, 300)
bed_y = ui_scalar('Bed size y (mm)', 195, 1, 300)
transform = ui_pick('Choose point')


shape = load(Path..'../meshes/heart.stl')
box = bbox(shape)

emit(translate(0,0,-1)*cube(bed_x,bed_y,1),2)
emit(transform * translate(0,0,box:extent().z/2) * shape)

point = point_from_matrix(transform)
print_vector(point)

