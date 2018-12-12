
include <common.scad>
include <top.scad>
include <bottom.scad>


//rotate([180,0,0])

bottom();

mirror([0,0,1])
translate([0,0,-2*height])
top();

foo_internals1();