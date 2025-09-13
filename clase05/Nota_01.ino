#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#define ANCHO_PANTALLA 128
#define ALTO_PANTALLA 64
#define OLED_ADDR 0x3C  
Adafruit_SSD1306 display(ANCHO_PANTALLA, ALTO_PANTALLA, &Wire);

#define POT_PIN A0

#define BARRA_LEN 30
#define BARRA_OFFSET 3
#define BARRA_ALTURA 10

#define R 2
#define VEL  20



int pos; 
int t1, t0 = 0; 
float posX = 64, posY = 32;
int velX = VEL, velY = VEL;


void setup() {
     Serial.begin(9600);
  // Iniciar la pantalla
  if(!display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    Serial.begin(9600);
    Serial.println(F("No se encontró pantalla SSD1306"));
    for(;;); // se queda detenido
  }

  display.clearDisplay(); // Make sure the display is cleared
  display.display();
}

void loop() {
  t1 = millis();
  display.clearDisplay();

  display.drawRect(0, 0, display.width(), display.height()+1, SSD1306_WHITE);

  pos = map(analogRead(POT_PIN), 0, 1020, 0, 128-BARRA_LEN);
  display.fillRect(pos, display.height()-BARRA_OFFSET, BARRA_LEN, BARRA_ALTURA, SSD1306_WHITE);

  bola();

  display.display();
  t0 = t1;
}

void bola(){
  posX = posX + (float)velX * (float)(t1-t0)/1000;
  posY = posY + (float)velY * (float)(t1-t0)/1000;

  if (posX > R && posX < (ANCHO_PANTALLA - R)){
    display.fillCircle(posX, posY, R, SSD1306_WHITE);
  } else {
    velX = -velX;
    posX = posX + (float)velX * (float)(t1-t0)/1000;
  }

  if (posY > R ){
    display.fillCircle(posX, posY, R, SSD1306_WHITE);
  } else {
    velY = -velY;
    posY = posY + (float)velY * (float)(t1-t0)/1000;
  }

  if (posY > (display.height()  - R - BARRA_OFFSET) && posY < (display.height()  - R) && posX > pos && posX < pos+BARRA_LEN) {
    velY = -(velY + 10);
    if (velX > 0){velX += 5;}
    else{velX -= 5;}
    posY = posY + (float)velY * (float)(t1-t0)/1000;
  } 
}
