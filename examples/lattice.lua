tile = difference(ccube(10,10,10),sphere(6.0))
df_tile = to_voxel_distance_field(tile,0.2,0)

lattice = implicit(v(0,0,0), v(30,30,10), [[
uniform sampler3D tile;

float distanceEstimator(vec3 p) 
{
  vec3 uvw = p / 2;
  uvw.x = uvw.x + sin(p.z / 5);
  return 0.1*(texture(tile,uvw).x - 0.5);
}
]])

set_uniform_texture3d(lattice,'tile',df_tile)

emit(lattice)
