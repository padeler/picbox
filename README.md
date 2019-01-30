# picbox
Arduino based Photo album and sketch toy. 
Simple functionality for browsing the photos on the SD card and sketching in different colors.

# Notes
In order to keep the code small enough to fit into the 28k of the arduino micro 
I stripped the TFTLCD library and kept only the functionality I needed.

The code looks for "bmp" photos in the "/album" folder of the SD Card and 
displays them starting from a random point on each boot.

Top (navigation) buttons are (from left to right) 
- show previous
- show random
- reload
- show next

Bottom buttons select the pen color for sketching.

Toy case created with OpenSCAD and printed with PLA.

## Hardware used
- Arduino pro micro (leonardo) 5V
- TF-028 TFT touch screen (240x320) shield with sd-card
- 2x18650 Batteries in series (because I had some spare)
- Power switch
- Prototyping PCB 

## External Libraries
- [TFTLCD-Library](https://github.com/adafruit/TFTLCD-Library)
- [SdFat](https://github.com/greiman/SdFat)



## Making-of Photos
PCB, arduino and LCD+touchscreen+SDCard_reader shield. Front and back views
![hw2](/photos/hw2.jpg) ![hw](/photos/hw.jpg)
In order to save space the arduino goes between the PCB and the LCD board.
![pack1](/photos/pack1.jpg)
After soldering the arduino to the PCB. It is a bit messy but it was my first try using a PCB this way.
![pack2](/photos/pack2.jpg)
Testing basic h/w and s/w functionality.
![test](/photos/test.jpg)
Assempling everything into the 3D printed case. Orange is a nice color for a little girl's toy :)
![ass1](/photos/ass1.jpg)
Another view of the box. Since this is a kids toy, I secured all h/w in place with some hot glue. Maybe it will survive a few more hits this way!
![ass2](/photos/ass2.jpg)
And this is the end result. The use of 18650 batteries made it a bit thicker than it would be if I had opted for for 2xAAA batteries and 3V H/W. But it has a pretty long battery life now!
![final1](/photos/final1.jpg) ![final2](/photos/final2.jpg)
And a closeup of the screen showing the interface
![screen](/photos/screen.jpg)

