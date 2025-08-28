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



