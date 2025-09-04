```
const int PIN_LED = 9;
const int PIN_POT = A0;
int = pot;

void setup()
{
pinMode(PIN_LED, OUTPUT);
}

void loop()
{
pot = analogRead(PIN_POT);

if(pot > 256){
analogWrite(PIN_LED, 127);
} else if (pot > 512){
analogWrite(PIN_LED, 255);
} else if (pot > 750) {
analogWrite(PIN_LED, 0);
} else {
analogWrite(PIN_LED, 200);
}
}

```