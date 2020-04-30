#include "Ultrasonic.h"

Ultrasonic ultrasonic(7); //Capteur Distance Player1
Ultrasonic ultrasonic2(8); //Capteur Distance Player2


#define Interrupteur 13 //Interrupteur Changement de forme
int interrupteurValue = 0;
int pota = A0; //Potentiomètre Player1
int pota2 = A1 ; //Potentiomètre Player2
int potaValue = 0;
int potaValue2 = 0;

void setup()
{
  pinMode(Interrupteur, INPUT);
  Serial.begin(38400);
}
void loop()
{
  //Valeur Potentiomètre
  potaValue = analogRead(pota);
  potaValue2 = analogRead(pota2);

  interrupteurValue = digitalRead(Interrupteur); //Valeur Interrupteur

  //Récupération Capteur de distance en cm
  long RangeInCentimeters;
  long RangeInCentimeters2;

  RangeInCentimeters = ultrasonic.MeasureInCentimeters(); // two measurements should keep an interval
  RangeInCentimeters2 = ultrasonic2.MeasureInCentimeters();

  String json;
  json = "{\"Distance\":";
  json = json + RangeInCentimeters;
  json = json + ",\"Distance2\":" + RangeInCentimeters2;
  json = json + ",\"Interrupteur\":" + interrupteurValue;
  json = json + ",\"Pota\":" + potaValue;
  json = json + ",\"Pota2\":" + potaValue2;
  json = json + "}";

  Serial.println(json);

}
