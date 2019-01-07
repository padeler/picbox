
include <common.scad>
include <top.scad>
include <bottom.scad>


//rotate([180,0,0])

top();

rotate([0,180,0])
translate([0,0,-2*height])
bottom();

foo_internals1();