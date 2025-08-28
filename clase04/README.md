# Clase 04
### Ley de Ohm

```V = I x R``` Ley de ohm

```P = I x V``` Potencia [W]

### LED (Ligth Emiting Diode)
Usa ~10 mA, con 5v ```R = I/V``` ```l```

pata larga POSITIVA
cara plana NEGATIVA

### Potenciometro
gnd - output - Vcc


```
const int pinPot = A1;
const int pin_led = 7;
int valorPot0 = 0;
int valorPot1 = 0;
int mapPot = 0;
int i = 0;


void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
pinMode(pin_led, OUTPUT);
}

void loop() {
valorPot1 = analogRead(pinPot);
i = valorPot1 - valorPot0;

mapPot = map(valorPot1,0,1023,20,200);

digitalWrite(pin_led, HIGH);
delay(mapPot);
digitalWrite(pin_led, LOW);
delay(mapPot);

if (i > 3 || i < -3) {
  Serial.println(mapPot);
  valorPot0 = valorPot1;
}
}

```

```
const int PIN_LED = 7;
const int PIN_POT = A1;

unsigned long t0 = 0;
unsigned long t1;

bool estadoLed = 0;

int intervalo = 100;



void setup(){
Serial.begin(9600);
pinMode(PIN_LED, OUTPUT);
}



void loop(){

  t1 = millis();

  intervalo = map(analogRead(PIN_POT),0,1023,20,200);;

  if (t1 - t0 > intervalo){
    estadoLed = !estadoLed;
    digitalWrite(PIN_LED, estadoLed);
    t0 = t1;
  }
}
```
```
const int PIN_LED = 9;
const int PIN_POT = A1;

int intensidad;




void setup(){
Serial.begin(9600);
pinMode(PIN_LED, OUTPUT);
}



void loop(){
intensidad = analogRead(PIN_POT);
intensidad = map(intensidad, 0, 1023, 0, 255);

for(int i = 0; i < 256; i++){
  analogWrite(PIN_LED, i);
  delay(5);
}

for(int i = 255; i > 0; i--){
  analogWrite(PIN_LED, i);
  delay(5);
}
```
## Entrega 4
mapear por segmentos el brillo del led al potenciometro

## Encargo 
Conseguir pantalla 0,96



