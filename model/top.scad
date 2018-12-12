
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
                circle(roundR);
            }
        }
                                                                            // SUBSTRACT
        union()
        {
            // lift floor height
            translate([0, 0, floorHeight])
            {
                // Cut base inner hole
                linear_extrude(height = height, convexity = 10)
                minkowski()
                {
                    square([width, wide], center = true);
                    circle(roundR - pillarSize);
                }
                // Cut block lock
                translate([0, 0, height/2 - blockLockSize])
                linear_extrude(height = height, convexity = 10)
                minkowski()
                {
                    square([width, wide], center = true);
                    circle(roundR - layerWidth*3);
                }
                // Cut x panels 
                for (i = [0 : 180 : 180])				
                rotate([0, 0, i])
                translate([width/2 + roundR - pillarSize/2 - layerWidth*7, 0, 0])
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
                translate([wide/2 + roundR - pillarSize/2 - layerWidth*7, 0, 0])
                {
                    // Cut Y panel hole
                    translate([0, 0, height/2])
                    cube([pillarSize, sidePanelYWidth, height], center=true);
                }
                
                // Cut USB and Power holes
                // Rotate due to panel upside down
                mirror([0, 1 , 0])
                
                // translate to pcb position
                translate([-pcbPositionX, -pcbWide/2, height - floorHeight*2 -pcbPositionZ-pcbHeight])
                {
                    // Cut power hole
                    translate([0, powerJackPosition, -(powerJackHeight-2)/2])
                    cube([10, powerJackWide, powerJackHeight], center=true);
                    // Cut usb hole
                    translate([0, usbHolePosition, -1.3])
                    cube([10, usbWide, usbHeight], center=true);
                    
                    // Cut connectors holes
                    // upper
                    translate([upperConnectorXPos + upperConnectorWidth/2,
                            upperConnectorYPos + connectorWide/2,
                            -17])
                    linear_extrude(height = 5, convexity = 10)
                    minkowski()
                    {									
                        square([upperConnectorWidth - connectorRoundR*2,
                        connectorWide - connectorRoundR*2], center = true);
                        circle(connectorRoundR);
                    }
                    // lower
                    translate([lowerConnectorXPos + lowerConnectorWidth/2,
                            lowerConnectorYPos + connectorWide/2,
                            -17])
                    linear_extrude(height = 5, convexity = 10)
                    minkowski()
                    {									
                        square([lowerConnectorWidth - connectorRoundR*2,
                        connectorWide - connectorRoundR*2], center = true);
                        circle(connectorRoundR);
                    }
                    // icsp
                    translate([icspConnectorXPos + icspConnectorWide/2,
                            icspConnectorYPos - icspConnectorWidth/2,
                            -17])
                    linear_extrude(height = 5, convexity = 10)
                    minkowski()
                    {									
                        square([icspConnectorWide - connectorRoundR*2,
                        icspConnectorWidth - connectorRoundR*2], center = true);
                        circle(connectorRoundR);
                    }
                    // led hole
                    translate([ledHoleXPos ,
                            ledHoleYPos ,
                            -17])
                    linear_extrude(height = 5, convexity = 10)
                    minkowski()
                    {									
                        square([ledHoleWidth - connectorRoundR*2,
                        ledHoleWide - connectorRoundR*2], center = true);
                        circle(connectorRoundR);
                    }
                    // button
                    translate([buttonXPos, buttonYPos, -17])
                    cylinder(h = 5, r = buttonSize/2 + 0.5);
                    // buttonFrame
                    translate([buttonXPos, buttonYPos, -(height - floorHeight -pcbPositionZ-pcbHeight)])
                    buttonFrame();
                }
            }
        }
    }


    //------------------------------------------------------------------------- ADD PCB LEGS
    // Rotate due to panel upside down
    mirror([0, 1 , 0])

    // Translate to pcbPositionX	
    translate([-pcbPositionX, -pcbWide/2, 0])


    difference()
    {
                                                                            // ADD
        union()
        {
            // Add pcb legs
            for(i=[ [15.24, 50.8, 0],
                    [66.04, 35.56, 0],
                    [66.04, 7.62, 0] ])
            {
                    translate(i)
                    top_pcbLeg();
            }
            translate([13.97, 2.54, 0])
            cylinder(h = height - floorHeight - pcbPositionZ - pcbHeight, r = 4.5/2);

            // Add connectors walls
            // upper
            translate([upperConnectorXPos + upperConnectorWidth/2,
                    upperConnectorYPos + connectorWide/2,
                    0])
            linear_extrude(height = floorHeight+5, convexity = 10)
            minkowski()
            {									
                square([upperConnectorWidth - connectorRoundR*2,
                connectorWide - connectorRoundR*2], center = true);
                circle(connectorRoundR + layerWidth*3);
            }
            // lower
            translate([lowerConnectorXPos + lowerConnectorWidth/2,
                    lowerConnectorYPos + connectorWide/2,
                    0])
            linear_extrude(height = floorHeight+5, convexity = 10)
            minkowski()
            {									
                square([lowerConnectorWidth - connectorRoundR*2,
                connectorWide - connectorRoundR*2], center = true);
                circle(connectorRoundR+ layerWidth*3);
            }
            // icsp
            translate([icspConnectorXPos + icspConnectorWide/2,
                    icspConnectorYPos - icspConnectorWidth/2,
                    0])
            linear_extrude(height = floorHeight+5, convexity = 10)
            minkowski()
            {									
                square([icspConnectorWide - connectorRoundR*2,
                icspConnectorWidth - connectorRoundR*2], center = true);
                circle(connectorRoundR+ layerWidth*3);
            }
            // ledHole
            translate([ledHoleXPos,
                    ledHoleYPos,
                    0])
            linear_extrude(height = floorHeight+5, convexity = 10)
            minkowski()
            {									
                square([ledHoleWidth - connectorRoundR*2,
                ledHoleWide - connectorRoundR*2], center = true);
                circle(connectorRoundR+ layerWidth*3);	
            }
            // button
            translate([buttonXPos, buttonYPos, 0])

            cylinder(h = height - floorHeight - pcbPositionZ - pcbHeight - 3 - buttonBaseHeight - layerHeight*2,
                    r = buttonBaseR);

        }
                                                                            // SUBSTRACT
        union()
        {
            // Cut connectors holes
            // upper
            translate([0, 0, height - floorHeight -pcbPositionZ-pcbHeight])
            {
                translate([upperConnectorXPos + upperConnectorWidth/2,
                        upperConnectorYPos + connectorWide/2,
                        -17])
                linear_extrude(height = 25, convexity = 10)
                minkowski()
                {									
                    square([upperConnectorWidth - connectorRoundR*2,
                    connectorWide - connectorRoundR*2], center = true);
                    circle(connectorRoundR);
                }
                // lower
                translate([lowerConnectorXPos + lowerConnectorWidth/2,
                        lowerConnectorYPos + connectorWide/2,
                        -17])
                linear_extrude(height = 25, convexity = 10)
                minkowski()
                {									
                    square([lowerConnectorWidth - connectorRoundR*2,
                    connectorWide - connectorRoundR*2], center = true);
                    circle(connectorRoundR);
                }
                // icsp
                translate([icspConnectorXPos + icspConnectorWide/2,
                        icspConnectorYPos - icspConnectorWidth/2,
                        -17])
                linear_extrude(height = 25, convexity = 10)
                minkowski()
                {									
                    square([icspConnectorWide - connectorRoundR*2,
                    icspConnectorWidth - connectorRoundR*2], center = true);
                    circle(connectorRoundR);
                }
                // ledHole
                translate([ledHoleXPos ,
                        ledHoleYPos,
                        -17])
                linear_extrude(height = 25, convexity = 10)
                minkowski()
                {									
                    square([ledHoleWidth - connectorRoundR*2,
                    ledHoleWide - connectorRoundR*2], center = true);
                    circle(connectorRoundR);	
                }
                // button
                translate([buttonXPos, buttonYPos, -17])
                cylinder(h = 15, r = buttonSize/2 + 0.25);
            }
            // buttonFrame
            translate([buttonXPos, buttonYPos, 0])
            buttonFrame();
        }
    }
}

//top();