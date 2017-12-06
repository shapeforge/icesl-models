m = scale(0.4)*merge_vertices(load(Path .. '../meshes/2color_heartless_dragon.stl'))

offs = ui_scalar('offset',0.6,0.1,1.0)

eroded = erode(m,offs)
dilated = dilate(m,offs)

emit(translate(-30,-2.5,0)*eroded)
emit(difference(m,eroded))
emit(translate( 30,-2.5,0)*dilated)
