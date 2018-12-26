//  ----------------------------------------------------------------------- LICENSE
//  This "3D Printed Case for Arduino Uno, Leonardo" by Zygmunt Wojcik is licensed
//  under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit
//  http://creativecommons.org/licenses/by-sa/3.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


include <common.scad>


//------------------------------------------------------------------------- MAIN BLOCK
module bottom(){
    difference()
    {
        // ADD
        union()
        {
            // Add Base
            linear_extrude(height = height/2, convexity = 10)
            minkowski()
            {									
                square([width, wide], center = true);
                circle(roundR);
            }
        }
        // SUBSTRACT
        union()
        {
            // Lift floor height
            // Cut Base hole
            translate([0, 0, floorHeight])
            linear_extrude(height = height/2, convexity = 10)
            minkowski()
            {
                square([width, wide], center = true);
                circle(roundR - pillarSize);
            }
            // Cut upper block lock
            difference() {
                translate([0, 0, height/2 - blockLockSize ]) {
                    linear_extrude(height = blockLockSize+2, convexity = 10)
                    minkowski() {
                        square([width+1, wide+1], center=true);
                        circle(roundR);
                    }
                }
                translate([0, 0, height/2 - blockLockSize ]) {
                    linear_extrude(height = blockLockSize+2, convexity = 10)
                    minkowski() {
                        square([width, wide], center=true);
                        circle(roundR - layerWidth*4);
                    }
                }
            }
                // Cut x panels 
                for (i = [0 : 180 : 180])				
                rotate([0, 0, i])
                translate([width/2 + roundR - pillarSize/2 - layerWidth*7, 0, floorHeight])
                {
                    // Cut X panel hole
                    translate([0, 0, height/2])
                    cube([pillarSize, sidePanelXWidth, height], center=true);
                    
                    // Cut X, Y srew holes
                    for (i = [wide/2, -wide/2])
                    {
                        translate([-(roundR - pillarSize/2 - layerWidth*7), i, - floorHeight])
                        if (i>0) 
                        {
                            rotate([0, 0, 45])
                            translate([screwHoleRoundR, 0, 0])
                            {
                                cylinder(h = height*2, r=screwExt/2, center=true);
                                cylinder(h = 5,
                                        r1 = (screwHead + (screwHead - screwExt))/2,
                                        r2 = screwExt/2, center=true);
                            }
                        }
                        else
                        {
                            rotate([0, 0, -45])
                            translate([screwHoleRoundR, 0, 0])
                            {
                                cylinder(h = height*2, r=screwExt/2, center=true);
                                cylinder(h = 5,
                                        r1 = (screwHead + (screwHead - screwExt))/2,
                                        r2 = screwExt/2, center=true);
                            }
                        }
                    }
                }
                // Cut Y panels 
                for (i = [90 : 180 : 270])
                rotate([0, 0, i])
                translate([wide/2 + roundR - pillarSize/2 - layerWidth*7, 0, floorHeight])
                {
                    // Cut Y panel hole
                    translate([0, 0, height/2])
                    cube([pillarSize, sidePanelYWidth, height], center=true);
                }
                
                // Cut USB and Power holes
                mirror(0,1,0)
                translate([powerHolePosX, boxLength/2, height/2 - powerHoleBottomHeight ])
                cube([powerHoleWidth, 20,  powerHoleBottomHeight+2]);

        }
    }
    
    translate([-boxWidth/2, -boxLength/2+5, floorHeight])
    batSep();
    translate([-boxWidth/2 + batteryD+4*layerWidth, -boxLength/2+5, floorHeight])
    batSep();
    
    translate([boxWidth/2 - batteryD-2*layerWidth,-boxLength/2+5,floorHeight])
    batSep();
    translate([boxWidth/2+2*layerWidth,-boxLength/2+5, floorHeight])
    batSep();
    
    translate([boxWidth/2 - 2 ,-boxLength/2 + 2,floorHeight])
    pcbLeg();

    translate([-boxWidth/2+2,-boxLength/2+2,floorHeight])
    pcbLeg();

    translate([boxWidth/2 - 2 ,boxLength/2 - 2,floorHeight])
    pcbLeg();

    translate([-boxWidth/2+2,boxLength/2-2,floorHeight])
    pcbLeg();
}

//bottom();
