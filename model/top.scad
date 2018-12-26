
include <common.scad>

module top(){
    difference()
    {
                                                                            // ADD
        union()
        {
            // Add Base
            linear_extrude(height = height/2 + blockLockSize, convexity = 10)
            minkowski()
            {									
                square([width, wide], center = true);
                circle(roundR, center=true);
            }
        }
                                                                            // SUBSTRACT
        union()
        {
            // Cut base inner hole
            translate([0, 0, floorHeight])
            linear_extrude(height = height, convexity = 10)
            square([width,wide],center=true);

            // Cut block lock
            translate([0, 0, height/2])
            linear_extrude(height = height, convexity = 10)
            minkowski()
            {
                square([width, wide], center = true);
                circle(roundR - layerWidth*3);
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
                    translate([-(roundR - pillarSize/2 - layerWidth*7), i, 0])
                    if (i>0) 
                    {
                        rotate([0, 0, 45])
                        translate([screwHoleRoundR, 0, 0])
                        cylinder(h=height/2, r=verConnectionHoleR);
                    }
                    else
                    {
                        rotate([0, 0, -45])
                        translate([screwHoleRoundR, 0, 0])
                        cylinder(h=height/2, r=verConnectionHoleR);
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
            translate([powerHolePosX, boxLength/2, floorHeight+ powerHolePosZ])
            cube([powerHoleWidth, 20, powerHoleHeight]);
            
            // cut screen hole
            translate([boxPositionX, boxPositionY,0])
            {
                translate([0, 0, -0.1])
                linear_extrude(height = height, convexity = 10)
                square([tftWide,tftLength],center=true);

                translate([-tftWideFull/2, -tftLength/2 - tftPadBottom, floorHeight - tftSlotHeight])
                linear_extrude(height = height, convexity = 10)
                square([tftWideFull, tftLengthFull]);
            }
        }
    }

}

//top();