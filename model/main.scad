
include <common.scad>
include <top.scad>
include <bottom.scad>


//rotate([180,0,0])

//top();

//rotate([0,180,0])
//translate([0,0,-2*height])
difference() {
bottom();

//color([0,0,255])
translate([(boxWidth+2*roundR)/2-2*layerWidth,0,5])
rotate([90,0,90])
linear_extrude(layerWidth*3)
text("Σόφη",halign="center", spacing=1.3);
}
//
//foo_internals1();