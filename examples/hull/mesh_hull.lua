m = load(Path .. "../meshes/Rose_Petal.stl")

--emit(m)
emit(convex_hull(m))
