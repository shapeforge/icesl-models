----------- Lithophane effect -----------
-- Salim Perchy
-- 23/03/2023
-- MFX Team (c)

set_setting_value('brim_distance_to_print_mm', 0)
set_setting_value('brim_num_contours', 12)

filename = ui_selectFile('Image (set this to your own image!)')
vox_size = ui_scalar('Pixel-to-voxel size (mm)', 0.1, 0.05, 1)
max_thickness = ui_scalar('Maximum thickness (mm)', 3.2, 1.0, 5)
min_thickness = ui_scalar('Minimum thickness (% of max. thickness)', 25, 1, 100)
scale_factor = ui_scalar('Scale (XY)', 2.5, 1.0, 5)

if filename == '' then
  filename = Path..'beethoven.jpg'
end

pixels = load_image(filename)
height_voxels = math.floor(max_thickness / vox_size)
base_voxels = math.floor(height_voxels * min_thickness / 100)
img_size_x = (#pixels[0] + 1)
img_size_y = (#pixels + 1)
texture = tex3d_r8f(img_size_x,img_size_y,height_voxels)

for ucoord = 0, texture:w() - 1 do
  for vcoord = 0, texture:h() -1 do
    color = pixels[img_size_y - 1 - vcoord][ucoord]
    bw = 1.0 - (color.x + color.y + color.z) / 3.0
    for wcoord = 0, texture:d() - 1 do
	  if wcoord >= base_voxels + math.floor(bw * (texture:d() - 1 - base_voxels)) then
	    texture:set(ucoord,vcoord,wcoord,v(1.0,0.0,0.0)) -- hollow
	  else
	    texture:set(ucoord,vcoord,wcoord,v(0.0,0.0,0.0)) -- solid
	  end
    end
  end
end

voxels = to_voxel_solid(texture, vox_size)
scaled_voxels = rotate(90,X) * scale(scale_factor,scale_factor,1) * voxels
emit(scaled_voxels)