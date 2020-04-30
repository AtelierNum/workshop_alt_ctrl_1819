//Références : https://ouiaremakers.com/posts/tutoriel-diy-transformer-une-arduino-uno-en-pseudo-makey-makey

int sensor[2][6] = { // tableau de int à 2 dimensions
  {0, 1, 2, 3, 4},
  {0, 0, 0, 0, 0}
};

int valeurMin = 500; // seuil de détection du passage du courant


void setup() {
  Serial.begin(9600);
}


void loop() {

  //assigne à chaque case de la seconde ligne du tableau la valeur du courant pour le doigt correspondant
  for (int i = 0; i < 4; i++) {
    sensor[1][i] = analogRead(sensor[0][i]);

    //si cette valeur est en dessous du seuil de détection, on envoie à Processing le numéro du doigt correspondant
    if (sensor[1][i]<valeurMin){

      Serial.println(sensor[0][i]);
    }
  }
  
}
