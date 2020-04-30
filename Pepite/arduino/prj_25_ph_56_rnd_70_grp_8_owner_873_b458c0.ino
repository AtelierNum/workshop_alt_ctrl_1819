

#include "Ultrasonic.h"

Ultrasonic ultrasonic1(10);//on lie le capteur ultrason à la pin digitale 10
//initialisation
long sum = 0;
int son1;
int son2;
int RangeInCentimeters;
int value;
int sarbacanne;


void setup() {
  Serial.begin(9600);
  
}

void loop() {

  // Relevé du capteur de chaleur (thermistance)
  // Moyenne avec calcul par décalage de bits https://playground.arduino.cc/Code/BitMath
  sum = 0;
  for (int i=0; i<32; i++) {
    sum += analogRead(0);// on additionne les données du capteur à sum
  }
  sum >>= 5;//décalage digital de 5bit (divisé par 32)
  value = sum; // value prend donc pour valeur la moyenne des 32 dernier relevés

  // Relevé du capteur de son1
  sum = 0;
  for (int i=0; i<32; i++) {
  sum += analogRead(4);  
  }
  sum >>= 5;
  son1 = sum;

  // Relevé du capteur de son2
  sum = 0;
  for (int i=0; i<32; i++) {
   sum += analogRead(5);  
  }
  sum >>= 5;
  son2 = sum;

  // Relevé du capteur de sarbacanne;
  sarbacanne = analogRead(3)/2;// pas de moyenne pour diminuer une lattence dans le jeu
  

  // Relevé de distance = moyenne de 8 valeurs
  sum = 0;
  for (int i=0; i<8; i++) {
    sum += ultrasonic1.MeasureInCentimeters(); // two measurements should keep an interval -> delay(30) ci-dessous
    delay(30);
  }
  sum >>= 3;// division par 8
  RangeInCentimeters = sum;

  // on envoie les données vers processing
  Serial.print(son1);
  Serial.print(",");
  Serial.print(son2);
  Serial.print(",");
  Serial.print(value);
  Serial.print(",");
  Serial.print(sarbacanne);
   Serial.print(",");
  Serial.print(RangeInCentimeters);
  Serial.println();
  //delay(50);
  
}
