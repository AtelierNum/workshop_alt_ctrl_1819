/*  Déclenchement des sons pour le jeu Chifumort
 
 */

// Bibliothèques
import processing.sound.*;
import processing.serial.*;

// Port utilisé par arduino
Serial myPort; 

// Initialisation des sons
SoundFile[] fichier;
int nombre_sons = 13;
String s;

void setup() {
  
  // Initialisation des différents sons
  fichier = new SoundFile[nombre_sons];
  fichier[0]  = new SoundFile(this, "321HurtYourself.wav");
  fichier[1]  = new SoundFile(this, "BandAid.wav");
  fichier[2]  = new SoundFile(this, "BeepTimerEnd.wav");
  fichier[3]  = new SoundFile(this, "BeepTimerOneSHot.wav");
  fichier[4]  = new SoundFile(this, "Cream.wav");
  fichier[5]  = new SoundFile(this, "Fire.wav");
  fichier[6]  = new SoundFile(this, "MainMusic.wav");
  fichier[7]  = new SoundFile(this, "Pills.wav");
  fichier[8]  = new SoundFile(this, "Poison.wav");
  fichier[9]  = new SoundFile(this, "YouDied.wav");
  fichier[10] = new SoundFile(this, "YouLose.wav");
  fichier[11] = new SoundFile(this, "YouWin.wav");
  fichier[12] = new SoundFile(this, "Sword1.wav");

  // On regarde et on dit d'où on reçoit les données
  printArray(Serial.list());
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

void draw() {
}

//Debug
void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');

      if (inBuffer != null) { 
        try {
          s = inBuffer.replace("\n", "");
          int val = Integer.parseInt(s.trim());
          declencherSon(val);
        } 
        catch (NumberFormatException npe) {
          // Not an integer so forget it
        }
      }
    }
  } 
  catch (Exception e) {
  }
}


// Fonction de liaison entre le signal envoyé par arduino et le son à déclancher
void declencherSon(int son_a_declencher) {
  println("envoi par arduino : declencher son " + son_a_declencher);
  if ((son_a_declencher >= 0) && (son_a_declencher < nombre_sons)) {
    if (!fichier[son_a_declencher].isPlaying()) fichier[son_a_declencher].play(1.0, 1.0);
  }
}


// Jouer les sons en fonction du capteur déclanché
void keyPressed() {
  //String touche = "" + key;
  //declencherSon(key);
  switch(key) {
  case 'a':
    fichier[0].play(1.0, 1.0);
    break;
  case 'z':
    fichier[1].play(1.0, 1.0);
    break;
  case 'e':
    fichier[2].play(1.0, 1.0);
    break;
  case 'r':
    fichier[3].play(1.0, 1.0);
    break;
  case 't':
    fichier[4].play(1.0, 1.0);
    break;
  case 'y':
    fichier[5].play(1.0, 1.0);
    break;
  case 'u':
    fichier[6].play(1.0, 1.0);
    break;
  case 'i':
    fichier[7].play(1.0, 1.0);
    break;
  case 'o':
    fichier[8].play(1.0, 1.0);
    break;
  case 'p':
    fichier[9].play(1.0, 1.0);
    break;
  case 'q':
    fichier[10].play(1.0, 1.0);
    break;
  case 's':
    fichier[11].play(1.0, 1.0);
    break;
  case 'd':
    fichier[12].play(1.0, 1.0);
    break;
  }
}