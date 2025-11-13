#define CLK 2
#define DT 3
#define SW 4

long encoderValue = 0;
int lastCLK;
int lastButtonState = HIGH;
unsigned long lastSend = 0;
const unsigned long sendInterval = 50; // send at least every 50 ms

void setup() {
  pinMode(CLK, INPUT);
  pinMode(DT, INPUT);
  pinMode(SW, INPUT_PULLUP);

  Serial.begin(9600);
  lastCLK = digitalRead(CLK);
}

void loop() {
  int currentCLK = digitalRead(CLK);

  // detect rotation
  if (currentCLK != lastCLK) {
    if (digitalRead(DT) != currentCLK) {
      encoderValue++;
    } else {
      encoderValue--;
    }
  }
  lastCLK = currentCLK;

  // read button (active LOW)
  int buttonState = digitalRead(SW);

  // periodically or on change, send data
  if (millis() - lastSend > sendInterval ||
      buttonState != lastButtonState ||
      currentCLK != lastCLK) {

    Serial.print("ENC:");
    Serial.print(encoderValue);
    Serial.print(", BTN:");
    Serial.println(buttonState == LOW ? 1 : 0);

    lastSend = millis();
  }

  lastButtonState = buttonState;
}
