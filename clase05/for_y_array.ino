
int numerosLost[] = {4, 8 , 15, 16, 23, 42}; 

String poema[] ={
"Señor",
"la jaula se ha vuelto pajaro",
"y se ha volado",
"y mi corazon esta loco",
"porque aulla la muerte",
"y sonrrie detras del viento",
"a is delirios"
};

void setup() {
  Serial.begin(9600);

}

void loop() {

  for(int i = 0; i < 7; i++)
  {
    Serial.println(poema[i]);
    delay(1000);
  }
}
