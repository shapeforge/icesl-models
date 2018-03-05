

-- Bottom of rook

hTour = ui_scalar('Hauteur Tour', 40, 1,60)
hBase = ui_scalar('Hauteur Base', 5, 1,60)
r = ui_scalar('Rayon', 10, 1,60)
ratio = 1.4

base = union(
  cylinder(r*ratio,hBase),
  translate(0,0,hBase)*cone(r*ratio,r,hBase)
)

corps = cylinder(r, hTour)

tete = translate(0,0,hTour)*rotation(180,0,0)*base
--tete = translate(0,0,hTour)*mirror(Z)*base

tab = {}

for i=1,3 do
  tab[i] = rotate(0,0,i*360/3)*cube(2*r*ratio*1.1, 2,2)
end

couronne = translate(0,0,hTour)*
difference(
  difference(
    cylinder(r*ratio, 2),
    cylinder(r*ratio-2, 2)
  ),
  union(tab)
)

tour = union{
  base,
  corps,
  tete, 
  couronne
}

-- Add stairs inside the tower
marche = {}
n=60
for i=1,n-1 do
  marche[i] = translate(0,0,i*hTour/n)*rotate(0,0,i*10)*cube(r, 2,hTour/n)
end

tour = difference(tour, cylinder(r/2,hTour*1.1))
tour = union(tour,union(marche))


emit(tour)
