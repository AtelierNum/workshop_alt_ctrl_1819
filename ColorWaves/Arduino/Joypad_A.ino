#include "Ultrasonic.h"  //library for ultrasonic sensor
int range;  //ultrasonic sensor value
int force;  //strenght resistor value
int torsion;  //flex resistor value
int forcefiltre;    //value with minim filtered for more accuracy
int torsionfiltre;
int capteurforce = A5;
int capteurtorsion = A1;
Ultrasonic ultrasonic(7);


void setup()
{
  Serial.begin(9600);
}
void loop()
{                           //on this part we filter the values, to get more precision when using the sensors. 
  forcefiltre = analogRead(capteurforce);
  if ( forcefiltre < 140) {
    forcefiltre = 140;
  }

  torsionfiltre = analogRead(capteurtorsion);
  if ( torsionfiltre < 270) {
    torsionfiltre = 270;
  }

                             //we map the values in order to get a range from 0 to 255, max and minimum values for RVB 
  torsion = map(torsionfiltre, 270, 400, 0, 255);
  force = map(forcefiltre, 140, 1000, 0, 255);

  range = map((ultrasonic.MeasureInCentimeters() * 10), 10, 450, 255, 0);

                            //we bound limits to make sure to never get above 255 and under 0 
  if (torsion > 255) {
    torsion = 255;
  }
  if (force > 255) {
    force = 255;
  }
  if (range > 255) {
    range = 255;
  }
  if (torsion < 0) {
    torsion = 0;
  }
  if (force < 0) {
    force = 0;
  }
  if (range < 0) {
    range = 0;
  }

                              //thank to this command we print the values on the pattern : valeur:R/V/B  in order to use it in processing
  Serial.print("valeur:");
  Serial.print(torsion);
  Serial.print("/");
  Serial.print(force);
  Serial.print("/");
  Serial.print(range);
  Serial.println("/");
  delay(20);
}
