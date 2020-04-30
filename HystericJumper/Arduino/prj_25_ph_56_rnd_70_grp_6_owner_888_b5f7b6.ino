////////////////////// HYSTERIC JUMPER CODE /////////////////////////


/* 

Code commenté pour "Hysteric Jumper", par Samuel Lefebvre, Camille Campo, Lengliang Li et Yacine El Makhzoumi. 
Nantes, EDNA, workshop joypad, 8 mars 2019.

*/

float valeur1, valeur2, valeur3, valeur4;          // On initialise les 4 valeurs pour chacun des 4 capteurs de pressions du jeu.
float compteur = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {                                      // On lit ces valeurs en boucle.
  valeur1 = analogRead(0);
  valeur2 = analogRead(1);
  valeur3 = analogRead(2);
  valeur4 = analogRead(3);


  Serial.print(valeur1);                           // On affiche ces valeurs.
  Serial.print(",");
  Serial.print(valeur2);
  Serial.print(",");
  Serial.print(valeur3);
  Serial.print(",");
  Serial.print(valeur4);
  Serial.println();



}
