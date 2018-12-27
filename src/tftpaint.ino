// Paint example specifically for the TFTLCD breakout board.
// If using the Arduino shield, use the tftpaint_shield.pde sketch instead!
// DOES NOT CURRENTLY WORK ON ARDUINO LEONARDO

#include <SPI.h>
#include "tft/Adafruit_TFTLCD.h" // Hardware-specific library
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

#define TS_MINX 150
#define TS_MINY 120
#define TS_MAXX 920
#define TS_MAXY 940

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

Adafruit_TFTLCD tft(LCD_CS, LCD_CD, LCD_WR, LCD_RD, LCD_RESET);

#define BOXSIZE 40
#define PENRADIUS 3
uint16_t oldcolor, currentcolor;
bool repaint;

void setup(void)
{
  // Serial.begin(9600);
  // Serial.println(F("Paint!"));

  tft.reset();

  uint16_t identifier = tft.readID();

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

  // Serial.print(F("Initializing SD card..."));
  if (!SD.begin(SD_CS))
  {
    // Serial.println(F("failed!"));
    return;
  }
  // Serial.println(F("OK!"));

  // tft.fillScreen(BLACK);
  // bmpDraw("/test.bmp");

  repaint = true;

  // tft.fillRect(0, 0, BOXSIZE, BOXSIZE, RED);
  // tft.fillRect(BOXSIZE, 0, BOXSIZE, BOXSIZE, YELLOW);
  // tft.fillRect(BOXSIZE*2, 0, BOXSIZE, BOXSIZE, GREEN);
  // tft.fillRect(BOXSIZE*3, 0, BOXSIZE, BOXSIZE, CYAN);
  // tft.fillRect(BOXSIZE*4, 0, BOXSIZE, BOXSIZE, BLUE);
  // tft.fillRect(BOXSIZE*5, 0, BOXSIZE, BOXSIZE, MAGENTA);
  // tft.fillRect(BOXSIZE*6, 0, BOXSIZE, BOXSIZE, WHITE);

  // tft.drawRect(0, 0, BOXSIZE, BOXSIZE, WHITE);
  currentcolor = RED;

  pinMode(13, OUTPUT);
}

#define MINPRESSURE 10
#define MAXPRESSURE 1000

void loop()
{
  paint_loop();
}

void paint_loop()
{
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

  if (repaint || (p.z > MINPRESSURE && p.z < MAXPRESSURE))
  {
    /*
    Serial.print("X = "); Serial.print(p.x);
    Serial.print("\tY = "); Serial.print(p.y);
    Serial.print("\tPressure = "); Serial.println(p.z);
    */

    if (repaint || p.y < (TS_MINY - 5))
    {
      tft.fillRect(0, BOXSIZE, tft.width(), tft.height()-BOXSIZE, BLACK);
      // Serial.println("erase");
      // press the bottom of the screen to erase
      File bmpFile;
      if(bmpFile.openNext(SD.vwd(), O_READ))
      {
        if (bmpFile.isFile())
        {
          bmpDraw(bmpFile);
        }

      }
      else{
        SD.vwd()->rewind();
      }

      bmpFile.close();
      repaint = false;
    }

    // // scale from 0->1023 to tft.width
    p.x = map(p.x, TS_MINX, TS_MAXX, tft.width(), 0);
    p.y = map(p.y, TS_MINY, TS_MAXY, tft.height(), 0);

    p.x = tft.width() - p.x;

    // /*
    // Serial.print("("); Serial.print(p.x);
    // Serial.print(", "); Serial.print(p.y);
    // Serial.println(")");
    // */
    if (p.y < BOXSIZE)
    {
      oldcolor = currentcolor;
      uint8_t m = p.x / BOXSIZE;
      // tft.drawRect(m * BOXSIZE, 0, BOXSIZE, BOXSIZE, WHITE);
      currentcolor = WHITE;
      if (p.x < BOXSIZE)
      {
        currentcolor = RED;
        //  tft.drawRect(0, 0, BOXSIZE, BOXSIZE, WHITE);
      }
      else if (p.x < BOXSIZE * 2)
      {
        currentcolor = YELLOW;
        //  tft.drawRect(BOXSIZE, 0, BOXSIZE, BOXSIZE, WHITE);
      }
      else if (p.x < BOXSIZE * 3)
      {
        currentcolor = GREEN;
        //  tft.drawRect(BOXSIZE*2, 0, BOXSIZE, BOXSIZE, WHITE);
      }
      else if (p.x < BOXSIZE * 4)
      {
        currentcolor = CYAN;
        //  tft.drawRect(BOXSIZE*3, 0, BOXSIZE, BOXSIZE, WHITE);
      }
      else if (p.x < BOXSIZE * 5)
      {
        currentcolor = BLUE;
        //  tft.drawRect(BOXSIZE*4, 0, BOXSIZE, BOXSIZE, WHITE);
      }
      else if (p.x < BOXSIZE * 6)
      {
        currentcolor = MAGENTA;
        //  tft.drawRect(BOXSIZE*5, 0, BOXSIZE, BOXSIZE, WHITE);
      }

      if (oldcolor != currentcolor)
      {
        if (oldcolor == RED)
          tft.fillRect(0, 0, BOXSIZE, BOXSIZE, RED);
        if (oldcolor == YELLOW)
          tft.fillRect(BOXSIZE, 0, BOXSIZE, BOXSIZE, YELLOW);
        if (oldcolor == GREEN)
          tft.fillRect(BOXSIZE * 2, 0, BOXSIZE, BOXSIZE, GREEN);
        if (oldcolor == CYAN)
          tft.fillRect(BOXSIZE * 3, 0, BOXSIZE, BOXSIZE, CYAN);
        if (oldcolor == BLUE)
          tft.fillRect(BOXSIZE * 4, 0, BOXSIZE, BOXSIZE, BLUE);
        if (oldcolor == MAGENTA)
          tft.fillRect(BOXSIZE * 5, 0, BOXSIZE, BOXSIZE, MAGENTA);
      }
    }
    if (((p.y - PENRADIUS) > BOXSIZE) && ((p.y + PENRADIUS) < tft.height()))
    {
      tft.drawPixel(p.x, p.y, currentcolor);
      // tft.fillCircle(p.x, p.y, PENRADIUS, currentcolor);
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
