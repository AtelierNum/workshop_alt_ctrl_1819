import processing.serial.*;
Serial myPort;

import processing.sound.*;
SoundFile file, gulp;

PImage Menu;
PImage WinIMG;

boolean split;
boolean menu, isOnGame, Win;

//Arduino
int Distance, Distance2;
int Interrupteur;
int Pota, Pota2;

int Speed;
int Light, Light2, LightReunis, LightMini;
int nbBoule, nbBouleRose, nbBouleViolette, nbEnnemy;
int bouleEat, bouleEatTarget;
int bouleEatV, bouleEatTargetV;
int ennemyTargetToSpawn;

float PosX, PosY;
float PosX2, PosY2;
float newPosX, newPosY;
float potaMap, potaMap2;
float distanceBTW, distanceBouleBleue, distanceBouleRose, distanceBouleViolette, distanceEnnemy1, distanceEnnemy2;

//Liste de boule bleue
ArrayList<bouleBleue> pleinBouleBleue = new ArrayList<bouleBleue>();
//Liste de boule rose
ArrayList<bouleRose> pleinBouleRose = new ArrayList<bouleRose>();
//Liste de boule violette
ArrayList<bouleViolette> pleinBouleViolette = new ArrayList<bouleViolette>();
//Liste d'Ennemy
ArrayList<ennemy> pleinEnnemy = new ArrayList<ennemy>();

void setup() {

  fullScreen();
  //Images
  Menu = loadImage("Menu.png");
  WinIMG = loadImage("win.png");

  //Arduino
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 38400);
  myPort.bufferUntil('\n');

  //Musics
  file = new SoundFile(this, "soundGame.mp3");
  gulp = new SoundFile(this, "gulp.wav");

  noCursor();

  state();
}

void draw() {
  //Lancement du jeu via le menu
  if (Distance < 15 && Distance2 < 15 && menu) {
    menu = false;
    state++;
    state();
  }
  //Ecran de jeu
  if (state == 1) {
    background(0);
    noStroke();


    //Boule Bleue 
    for (int i = 0; i < pleinBouleBleue.size(); i++) {
      pleinBouleBleue.get(i).update();
      pleinBouleBleue.get(i).draw();
    }
    //Boule Rose
    for (int i = 0; i < pleinBouleRose.size(); i++) {
      pleinBouleRose.get(i).update();
      pleinBouleRose.get(i).draw();
    }
    //BouleViolette
    for (int i = 0; i < pleinBouleViolette.size(); i++) {
      pleinBouleViolette.get(i).update();
      pleinBouleViolette.get(i).draw();
    }
    //Ennemy
    for (int i = 0; i < pleinEnnemy.size(); i++) {
      pleinEnnemy.get(i).update();
      pleinEnnemy.get(i).draw();
    }


    //Condition nbr de boule à manger pour faire spawn des boules violette
    if (bouleEat >= bouleEatTarget) {    
      bouleEatTarget = bouleEatTarget + 20;
      initBouleViolette();
      nbBouleViolette = nbBouleViolette += 2;
    }
    //Condition nbr de boule à manger pour faire spawn de nouvelle boule bleue et rose
    if (bouleEatV >= bouleEatTargetV) {
      bouleEatTargetV += 10;
      initNewBoule();
    }
    //Condition nbr de boule à manger pour faire spawn des ennemis
    if (bouleEat + bouleEatV >= ennemyTargetToSpawn) {
      ennemyTargetToSpawn += 40;
      initEnnemy();
      println("fuck");
    }


    //Potentiomètre Mapage des valeurs
    potaMap = map(Pota, 35, 1007, 0, 360);
    potaMap2 = map(Pota2, 35, 1007, 0, 360);

    //Addition des deux light pour la light du Player Reunis
    LightReunis = Light + Light2;

    //Launch fonction de jeu
    moveLux();
    renderLux();
    stayOnScreen();
    eatingBoule();
    victory();
  } // fin de state 1

  //Condition de retour écran menu
  if (Win == true && Interrupteur == 1) {
    Win = false;
    state = 0;
    state();
  }
  if (Win == true) {
    //Détruit les boules bleues restantes

    for (int i = 0; i < pleinBouleBleue.size(); i++) {
      //bouleBleue b = pleinBouleBleue.get(i);
      pleinBouleBleue.remove(0);
    }
    //println(lala);
    //Détruis les boules roses restantes
    for (int i = 0; i < pleinBouleRose.size(); i++) {
      pleinBouleRose.remove(0);
    }
    //Détruis les boules violettes restantes
    for (int i = 0; i < pleinBouleViolette.size(); i++) {
      pleinBouleViolette.remove(0);
    }
    // Détruit les ennemis restant
    for (int i = 0; i < pleinEnnemy.size(); i++) {
      pleinEnnemy.remove(0);
    }
  }
}

//condition de victoire
void victory() {
  if (LightReunis > 1000 && split == false && isOnGame) {
    isOnGame = false;
    state++;
    state();
  }
}


// Récupérer valeur Arduino
void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');
      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {
          JSONObject json = parseJSONObject(inBuffer);
          if (json == null) {

            //println("JSONObject could not be parsed");
          } else {
            Distance    = json.getInt("Distance");
            Distance2    = json.getInt("Distance2");
            Interrupteur    = json.getInt("Interrupteur");
            Pota = json.getInt("Pota");
            Pota2 = json.getInt("Pota2");
          }
        } else {
        }
      }
    }
  } 
  catch (Exception e) {
  }
}
