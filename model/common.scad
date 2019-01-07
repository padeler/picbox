//  ----------------------------------------------------------------------- LICENSE
//  This "3D Printed Case for Arduino Uno, Leonardo" by Zygmunt Wojcik is licensed
//  under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit
//  http://creativecommons.org/licenses/by-sa/3.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


//------------------------------  internals (battery,board etc) 

tftRoundR = 2.54/2;

tftWide = 46;
tftLength = 60;

tftWideFull = 50;
tftLengthFull = 70;

tftPadBottom = 7; 
tftPadTop = tftLengthFull - tftLength - tftPadBottom;

tftSlotHeight = 0.5;

// 18650 cell dims
batteryD  = 18.2;
batteryRad = batteryD/2;
batteryLength = 65;

// tft+pcb+arduino assemply
boxLength=78.3;
boxWidth=55;
boxHeight=19; // total height of the assemply
tftHeight=7.2; // tft shield height 

pcbLegHeight = batteryD + boxHeight +tftSlotHeight - tftHeight ;

boxPositionX = 0;
boxPositionY = 8.7+1.8; // offset towards top

powerHoleHeight = 5 + 13.5;
powerHoleWidth = 19;
powerHolePosZ = tftHeight-tftSlotHeight;
powerHolePosX = -52.6/2 + 22;
// NOTE: a hole with height 4.5 is needed  on the bottom side
powerHoleBottomHeight = 4.5;



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

floorHeight = 2.0; // 6*0.25 layer + 0.3 first layer

height = batteryD+boxHeight+2*floorHeight; // case height
innerHeight = batteryD+boxHeight;

pillarSize = roundR-0.01; // corner pillar size

// dimensions of minkowski's inner square
// these are NOT case dimensions
// to calculate external case dimesions add 2 * roundR
// 55.3 + (2*10.5) = 76.3
width = boxWidth ;
wide = boxLength;

blockLockSize = 2; // middle connection lock size

// side cutting panels size
sidePanelXWidth = wide;
sidePanelYWidth = width;

// screw hole position from centre of the corner round circle
screwHoleRoundR = roundR - layerWidth*4 - (triangleH/2 - layerWidth*4)/2;

// prints dimensions of the case to the console
echo("width", width + roundR*2); // total width
echo("wide", wide + roundR*2); // total wide


usbHolePosition=38.1;
usbHeight=7.2 + 2;
usbWide=10.5 + 2;
powerJackPosition=7.62;
powerJackWide=8.9 +2;
powerJackHeight=10.8 +2;





//------------------------------------------------------------------COMMON MODULES
module pcbLeg() {		
    cylinder(h = pcbLegHeight, r1=5/2, r2 = 4/2);
}

module batSep(){
        cube([2*layerWidth, batteryLength-5, batteryD-5]);
}

//----------------------------------------------------------------------- FOO MODULES
module cell(){
    color([0.5,0.2,0.2])
    rotate([90,0,0])
    cylinder(batteryLength, batteryRad, batteryRad);
}

module fullbox(){
    color([0.2,0.2,0.8]) // TFT Shield  blue
    translate([-boxWidth/2,-boxLength/2,0])
    cube([boxWidth, boxLength, tftHeight]);
    color([0.2,0.5,0.2]) // PCB green
    translate([-boxWidth/2,-boxLength/2.5,tftHeight])
    cube([boxWidth, boxLength*2/3, boxHeight-tftHeight]);
}


module foo_internals1(){
    rotate([0,0,0])
    translate([0,0,floorHeight-tftSlotHeight]){
        fullbox();
        translate([-boxWidth/2 +batteryRad-1*layerWidth, boxLength/2-8,boxHeight+batteryRad])
        cell();
        translate([boxWidth/2 -batteryRad-3*layerWidth, boxLength/2-8,boxHeight+batteryRad])
        cell();

    }
}

