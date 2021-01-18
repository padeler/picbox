// Paint example specifically for the TFTLCD breakout board.
// If using the Arduino shield, use the tftpaint_shield.pde sketch instead!
// DOES NOT CURRENTLY WORK ON ARDUINO LEONARDO

#include <SPI.h>
#include "src/tft/Adafruit_TFTLCD.h" // Hardware-specific library
#include <TouchScreen.h>

// next line for SD.h
//#include <SD.h>

#include <SdFat.h>
SdFat SD;

#if defined(__SAM3X8E__)
#undef __FlashStringHelper::F(string_literal)
#define F(string_literal) string_literal
#endif

#define YP A3 // must be an analog pin, use "An" notation!
#define XM A2 // must be an analog pin, use "An" notation!
#define YM 9  // can be a digital pin
#define XP 8  // can be a digital pin

#define TS_MINX 248
#define TS_MAXX 435
#define TS_MINY 102
#define TS_MAXY 900

// (partial) fix for my broken touchscreen 
#define TS_MINX2 150
#define TS_MAXX2 550


// For better pressure precision, we need to know the resistance
// between X+ and X- Use any multimeter to read it
// For the one we're using, its 300 ohms across the X plate
TouchScreen ts = TouchScreen(XP, YP, XM, YM, 300);

#define LCD_CS A3
#define LCD_CD A2
#define LCD_WR A1
#define LCD_RD A0
// optional
#define LCD_RESET A4

#define SD_CS 10 // Set the chip select line to whatever you use (10 doesnt conflict with the library)

// Assign human-readable names to some common 16-bit color values:
#define BLACK 0x0000
#define BLUE 0x001F
#define RED 0xF800
#define GREEN 0x07E0
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define YELLOW 0xFFE0
#define WHITE 0xFFFF
#define BC1 0xAAAA
#define BC2 0xBBBB
#define BC3 0xCCCC


Adafruit_TFTLCD tft(LCD_CS, LCD_CD, LCD_WR, LCD_RD, LCD_RESET);

#define BOXSIZE 34
#define PENRADIUS 3

#define ALBUM "/album"
uint16_t oldcolor, currentcolor;
uint16_t total_images;

uint16_t current_image;

File album;
bool repaint;

bool seed_needed = true;

void setup(void)
{
  // // initialize digital pin LED_BUILTIN as an output.
  // pinMode(LED_BUILTIN, OUTPUT);
  // digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  // delay(500);                       // wait for a second
  // digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW

  Serial.begin(9600);
  Serial.println(F("Starting Paint!"));

  tft.reset();

  uint16_t identifier = 0x9341; //tft.readID();

  // if(identifier == 0x9325) {
  //   Serial.println(F("Found ILI9325 LCD driver"));
  // } else if(identifier == 0x9328) {
  //   Serial.println(F("Found ILI9328 LCD driver"));
  // } else if(identifier == 0x7575) {
  //   Serial.println(F("Found HX8347G LCD driver"));
  // } else if(identifier == 0x9341) {
  //   Serial.println(F("Found ILI9341 LCD driver"));
  // } else if(identifier == 0x8357) {
  //   Serial.println(F("Found HX8357D LCD driver"));
  // } else {
  //   Serial.print(F("Unknown LCD driver chip: "));
  //   Serial.println(identifier, HEX);
  //   Serial.println(F("If using the Adafruit 2.8\" TFT Arduino shield, the line:"));
  //   Serial.println(F("  #define USE_ADAFRUIT_SHIELD_PINOUT"));
  //   Serial.println(F("should appear in the library header (Adafruit_TFT.h)."));
  //   Serial.println(F("If using the breakout board, it should NOT be #defined!"));
  //   Serial.println(F("Also if using the breakout, double-check that all wiring"));
  //   Serial.println(F("matches the tutorial."));
  //   return;
  // }

  tft.begin(identifier);

  tft.fillScreen(BLACK);

  // Serial.print(F("Initializing SD card..."));
  if (!SD.begin(SD_CS))
  {
    // Serial.println(F("failed!"));
    return;
  }
  // Serial.println(F("OK!") );

  // // bmpDraw("/test.bmp");

  repaint = true;
  if(!(album = SD.open(ALBUM)))
  {
    return; // failed to open album folder
  }

  total_images = count_files(&album);
  current_image = 0; //random(total_images);
  pinMode(13, OUTPUT);
}

#define MINPRESSURE 10
#define MAXPRESSURE 1000

void loop()
{
  // delay(100);
  paint_loop();
}

uint16_t count_files(File *dir)
{
  dir->rewind();
  uint16_t res=0;
  File f;
  while(f.openNext(dir, O_READ))
  {
    if (f.isFile())
    {
      res++;
    }
    f.close();
  }
  return res;
}

File open_file(File *dir, uint16_t index)
{
  uint16_t pos = 0;
  dir->rewind();
  File res;
  while(pos<=index && res.openNext(dir, O_READ)) 
  {
    if(res.isFile())
    {
      if(pos==index){
        return res;
      }
      pos++;
    }
    res.close();
  }
}


void paint_buttons(uint8_t selected)
{

  // top buttons
  tft.fillRect(0         + BOXSIZE/4, tft.height() - BOXSIZE/2, BOXSIZE/2, BOXSIZE/4, BC1);
  tft.fillRect(BOXSIZE*2 + BOXSIZE/4, tft.height() - BOXSIZE/2, BOXSIZE/2, BOXSIZE/4, BC2);
  tft.fillRect(BOXSIZE*3 + BOXSIZE/4, tft.height() - BOXSIZE/2, BOXSIZE/2, BOXSIZE/4, BC3);
  tft.fillRect(BOXSIZE*6 + BOXSIZE/4, tft.height() - BOXSIZE/2, BOXSIZE/2, BOXSIZE/4, BC1);


  // bottom buttons
  tft.fillRect(0         + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, RED);
  tft.fillRect(BOXSIZE   + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, YELLOW);
  tft.fillRect(BOXSIZE*2 + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, GREEN);
  tft.fillRect(BOXSIZE*3 + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, CYAN);
  tft.fillRect(BOXSIZE*4 + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, BLUE);
  tft.fillRect(BOXSIZE*5 + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, MAGENTA);
  tft.fillRect(BOXSIZE*6 + BOXSIZE/4, 0 + BOXSIZE/4, BOXSIZE/2, BOXSIZE/2, WHITE);
  tft.drawFastHLine(0, 0, tft.width(), BLACK);
  tft.drawFastHLine(0, BOXSIZE-1, tft.width(), BLACK);

  tft.drawFastHLine(BOXSIZE*selected, 0, BOXSIZE, WHITE);
  tft.drawFastHLine(BOXSIZE*selected, BOXSIZE-1, BOXSIZE, WHITE);

  // tft.fillRect(0, tft.height()-3, tft.width(), 3, WHITE);
}

void paint_loop()
{
  if (repaint)
  {
    // XXX No need to clear screen if all album images are qvga
    // tft.fillRect(0, BOXSIZE, tft.width(), tft.height()-BOXSIZE, BLACK);

    File bmpFile = open_file(&album, current_image);
    if (bmpFile.isFile())
    {
      bmpDraw(bmpFile);
    }

    bmpFile.close();

    currentcolor = RED;
    paint_buttons(0);

    repaint = false;
  }

  digitalWrite(13, HIGH);
  TSPoint p = ts.getPoint();
  digitalWrite(13, LOW);


  // if sharing pins, you'll need to fix the directions of the touchscreen pins
  //pinMode(XP, OUTPUT);
  pinMode(XM, OUTPUT);
  pinMode(YP, OUTPUT);
  //pinMode(YM, OUTPUT);

  // we have some minimum pressure we consider 'valid'
  // pressure of 0 means no pressing!

  if(p.z > MINPRESSURE && p.z < MAXPRESSURE)
  {
    if(seed_needed)
    {
        randomSeed(p.x+p.y+p.z);
        seed_needed=false;
    }
    Serial.print(F("RAW "));
    Serial.print(p.x);Serial.print(" ");
    Serial.print(p.y);Serial.print(" ");

    p.y = map(p.y, TS_MINY, TS_MAXY, 0, tft.height());
    p.y = constrain(p.y, 0 , tft.height());

    if(p.y<60 || p.y>230)
    { // PPP Broken touch screen: On the edges use different mapping for p.x
      p.x = map(p.x, TS_MINX2, TS_MAXX2, 0, tft.width());  
    }
    else
    {
      p.x = map(p.x, TS_MINX, TS_MAXX, 0, tft.width());
    }

    p.x = constrain(p.x, 0 , tft.width());
    
    Serial.print(F("MAP "));
    Serial.print(p.x);Serial.print(" ");
    Serial.print(p.y);Serial.println(" ");

    // y is inverted for some reason in the tft lib.
    p.y = tft.height() - p.y; 

    if(p.y>tft.height()-BOXSIZE)
    { // top buttons
      uint8_t m = p.x / BOXSIZE;
      switch(m)
      {
        case 0: // right button 
          current_image = (current_image+1)%total_images;
          repaint=true;
          break;
        case 1:
          break;
        case 2: //  button, repaint
          repaint=true;
          break;
        case 3: //  , random image
          randomSeed(millis());
          current_image = random(total_images);
          repaint=true;
          break;
        case 4:
          break;
        case 6: // left button
          current_image>0?current_image = current_image-1:current_image=total_images-1;
          repaint=true;
          break;
      }      
    }


    if (p.y < BOXSIZE)
    {
      oldcolor = currentcolor;
      uint8_t m = p.x / BOXSIZE;
      paint_buttons(m);

      switch(m)
      {
        case 0:
          currentcolor = RED;
          break;
        case 1:
          currentcolor = YELLOW;
          break;
        case 2:
          currentcolor = GREEN;
          break;
        case 3:
          currentcolor = CYAN;
          break;
        case 4:
          currentcolor = BLUE;
          break;
        case 5:
          currentcolor = MAGENTA;
          break;
        default:
          currentcolor = WHITE;
      }
    }
    if (((p.y - PENRADIUS) > BOXSIZE) && ((p.y + PENRADIUS) < tft.height()))
    { // paint
      // tft.drawPixel(p.x, p.y, currentcolor);
      tft.fillRect(p.x, p.y, PENRADIUS, PENRADIUS, currentcolor);
    }
  }
}

#define RGB_BUF_SIZE 48
#define BMP_HEADER_LEN 34

bool read(File &f, uint8_t *buf, int len)
{
  int rcv=0;
  while(rcv!=len)
  {
    int got = f.read(buf+rcv, len-rcv);
    if(got==-1) return false;
    rcv+=got;
  }
  return true;
}

void bmpDraw(File &bmpFile)
{

  uint8_t *rgb = (uint8_t*)malloc(RGB_BUF_SIZE);

  // read full bmp header
  if(read(bmpFile, rgb, BMP_HEADER_LEN))
  {
    if(*((uint16_t*)(rgb+0)) == 0x4D42 && // bmp signature
      *((uint16_t*)(rgb+2+4+4+4+4+4+4)) == 1 && // planes==1
      *((uint16_t*)(rgb+2+4+4+4+4+4+4+2)) == 24 && // depth==24
      *((uint32_t*)(rgb+2+4+4+4+4+4+4+2+2)) == 0) // 0==uncompressed
    {
      uint32_t bmpImageoffset = *((uint32_t*)(rgb+2+4+4)); // offset
      uint32_t bmpWidth       = *((uint32_t*)(rgb+2+4+4+4+4)); // width
      uint32_t bmpHeight      = *((uint32_t*)(rgb+2+4+4+4+4+4)); // height

      if (bmpHeight < 0)
      {
        // If bmpHeight is negative, image is in top-down order.
        // This is not canon but has been observed in the wild.
        bmpHeight = -bmpHeight;
      }
      // Set TFT address window to clipped image bounds
      tft.setAddrWindow(0, 0, bmpWidth, bmpHeight);

      // BMP rows are padded (if needed) to 4-byte boundary
      uint32_t padSize = ((bmpWidth * 3 + 3) & ~3)-3*bmpWidth;

      uint32_t pos = 0; 
      bmpFile.seek(bmpImageoffset);
      while(pos<bmpWidth*bmpHeight)
      {
        uint8_t step = min((bmpWidth-pos%bmpWidth)*3, RGB_BUF_SIZE);
        // read step bytes
        if(!read(bmpFile, rgb, step)) 
        {
          break;
        }
        // convert inplace to 16bit pixels and send to TFT
        uint8_t j=0;
        for(uint8_t i=0;i<step;i+=3)
        {
          ((uint16_t*)rgb)[j] = tft.color565(rgb[i+2], rgb[i+1], rgb[i+0]);
          j++;
        }
        tft.pushColors(((uint16_t*)rgb), j, pos==0);

        pos+=step/3;
        if(pos%bmpWidth==0){  // skip padding
          bmpFile.seekCur(padSize);
        }
      }
    }
  }

  free(rgb);
}
