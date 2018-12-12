//  ----------------------------------------------------------------------- LICENSE
//  This "3D Printed Case for Arduino Uno, Leonardo" by Zygmunt Wojcik is licensed
//  under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit
//  http://creativecommons.org/licenses/by-sa/3.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


//------------------------------------------------------------------------- SHARED PARAMETERS
$fn=100; // resolution


circleD = 21; // round corner circle diameter
roundR = circleD/2; // round corner circle radius
triangleH = (sqrt(3)*(circleD))/2; // triangle height to calculate other variables

layerHeight = 0.25; // some variariables are multiple of layer height and width
layerWidth = 0.5;

screwExt = 3.4; // screw through hole diameter
verConnectionHoleR = 1.2; // screw thread hole radius
screwHead = 6; // screw head hole diameter

gap = layerHeight/2;

floorHeight = 1.8; // 6*0.25 layer + 0.3 first layer

height = 20.6; // case height
innerHeight = height - floorHeight*2;

pillarSize = roundR-0.01; // corner pillar size

// dimensions of minkowski's inner square
// these are NOT case dimensions
// to calculate external case dimesions add 2 * roundR
// 55.3 + (2*10.5) = 76.3
width = 70.3;
wide = 80.3;

blockLockSize = 2; // middle connection lock size

// side cutting panels size
sidePanelXWidth = wide;
sidePanelYWidth = width;

// screw hole position from centre of the corner round circle
screwHoleRoundR = roundR - layerWidth*4 - (triangleH/2 - layerWidth*4)/2;

// prints dimensions of the case to the console
echo("width", width + roundR*2); // total width
echo("wide", wide + roundR*2); // total wide


// LEONARDO PCB dimensions
pcbWide=53.3;
pcbLenght=68.58;
pcbHeight=1.64;
usbHolePosition=38.1;
usbHeight=7.2 + 2;
usbWide=10.5 + 2;
powerJackPosition=7.62;
powerJackWide=8.9 +2;
powerJackHeight=10.8 +2;

pcbPositionX = width/2 + roundR - layerWidth*7 - gap*4;
pcbPositionZ = 2.5;


//-----------------------------------------------------------------TOP PARAMETERS
// lid holes dimensions
connectorRoundR = 2.54/2;
connectorWide = 2.54*3;

upperConnectorWidth = 44.704 + 2.54*2;
upperConnectorXPos = 18.796 - 2.54;
upperConnectorYPos = 50.8 - 2.54*2;
lowerConnectorWidth = 35.56 + 2.54*2;
lowerConnectorXPos = 27.94 - 2.54;
lowerConnectorYPos = 2.54 - 2.54;

icspConnectorWidth = 5.08 + 2.54*2;
icspConnectorWide = 2.54 + 2.54*2;
icspConnectorXPos = 63.64 - 2.54;
icspConnectorYPos = 30.43 + 2.54;

ledHoleWidth = 2.54 + 1.27*2;
ledHoleWide = 11.5 + 1.27*2;
ledHoleXPos = 4.45;
ledHoleYPos = 22 ;

buttonSize = 4;
buttonXPos = 6.15;
buttonYPos = 50;
buttonBaseHeight = 2;
buttonBaseR = buttonSize/2 + 0.25 + layerWidth*3;


// internals (battery,board etc) 

// 18650 cell dims
batteryRad = 19/2;
batteryHeight = 65;

// tft+pcb+arduino assemply
boxLength=80;
boxWidth=55;
boxHeight=18; // total height of the assemply
tftHeight=7; 




//------------------------------------------------------------------COMMON MODULES
module bottom_pcbLeg() {		
	translate([0, 0, 0])
	difference() { 											
		cylinder(h = floorHeight + pcbPositionZ, r1=5.5/2, r2 = 4.5/2);
	}
}



module top_pcbLeg() {		
	translate([0, 0, 0])
	difference() { 											
		cylinder(h = height - floorHeight - pcbPositionZ - pcbHeight, r = 5.7/2);
	}
}

module buttonFrame() {
	translate([0, 0, -0.05])
	cylinder(h=1.01, r1=buttonSize/2 + 0.5 + 1, r2=buttonSize/2 + 0.5);
}


//----------------------------------------------------------------------- FOO MODULES
module cell(){
    color([0.5,0.2,0.2])
    rotate([90,0,0])
    cylinder(batteryHeight, batteryRad, batteryRad, center=true);
}

module fullbox(){
    color([0.2,0.5,0.2])
    cube([boxWidth, boxLength, boxHeight], center=true);
}


module foo_internals1(){
    rotate([0,0,90])
    translate([0,0,floorHeight]){
        translate([0,0,boxHeight/2])
        fullbox();
        translate([boxWidth/2+batteryRad,0,batteryRad])
        cell();

        translate([-boxWidth/2-batteryRad,0,batteryRad])
        cell();
    }
}

