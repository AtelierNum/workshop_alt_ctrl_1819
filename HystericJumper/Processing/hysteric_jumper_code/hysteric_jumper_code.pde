
////////////////////// HYSTERIC JUMPER CODE /////////////////////////


/* 

Code commenté pour "Hysteric Jumper", par Samuel Lefebvre, Camille Campo, Lengliang Li et Yacine El Makhzoumi. 
Nantes, EDNA, workshop joypad, 8 mars 2019.

*/




import processing.serial.*;

Serial myPort;                                                // On fait le lien entre la carte arduino et processing
float valeur1 = 0, valeur2 = 0, valeur3 = 0, valeur4 = 0;     // On récupère les 4 valeurs liées à chacun des capteurs de pression
String texte = "";


PFont police;                                                 // On utilise PFont pour pouvoir exploiter la typo de notre choix
PImage sol;                                                   
int numberOfImages = 10;                                      // Le nombre d'images qui serviront pour les levels
int randNumber = 0;                                           // On initialise le sélecteur de level aléatoire à 0.
PImage images[] = new PImage[numberOfImages];
PImage win1;                                                  // On déclare l'image pour le cas où le joueur 1 gagne.
PImage win2;                                                  // On déclare l'image pour le cas où le joueur 2 gagne.
PImage home;                                                  // On déclare l'image pour l'écran de démarrage.

Forme forme1;                                                 // On créé une boule pour le joueur 1.
Forme forme2;                                                 // On créé une boule pour le joueur 2.

int mode_jeu = 0;                                             // On déclare la variable "mode_jeu". On l'exploitera pour la structure du jeu.
boolean mode_init = false;
int mode_start;

int points1 = 0;                                              // On déclare la variable "points1" pour le joueur 1. On initialise à 0.
int points2 = 0;                                              // Pareil pour le 2.

void setup () {
  //size(1350, 2400);
  fullScreen();                                               // On souhaite sortir la fenêtre en plein écran.
  police = loadFont("Pixellari-48.vlw");                      // On utilise la typo de notre choix.
  forme1 = new Forme(color(255, 0, 0));                       // On attribue la couleur rouge au joueur 1.
  forme2 = new Forme(color(200, 150, 100));                   // On attribue la couleur jaune au joueur 2.

  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); 

  win1 = loadImage("win1.png");
  win2 = loadImage("win2.png");
  home = loadImage("home.png");

  randNumber = int(random(numberOfImages));                   // On créé un sélecteur aléatoire d'images.
 
  images[0] = loadImage("lvl1.png");
  images[1] = loadImage("lvl2.png");
  images[2] = loadImage("lvl3.png");
  images[3] = loadImage("lvl4.png");
  images[4] = loadImage("lvl5.png");
  images[5] = loadImage("lvl6.png");
  images[6] = loadImage("lvl7.png");
  images[7] = loadImage("lvl8.png");
  images[8] = loadImage("lvl9.png");
  images[9] = loadImage("lvl10.png");
  
  forme1.changeImage(images[randNumber]);
  forme2.changeImage(images[randNumber]); 
  
}

void draw() {
  background(0);

  if (mode_jeu == 0) {                                         // On dit que pour 0, le "mode_jeu" affiche l'écran de démarrage.
    image(home, 0, 0);
    textFont(police, 16);
    textSize(32);
    fill(255);
    text("Appuyer sur une plateforme pour commencer", 350, 1900);
  }

  if (mode_jeu == 1) {                                         // On dit que pour 1, le "mode_jeu" affiche un premier level au hasard.

    image(images[randNumber], 0, 0 );
    forme1.deplacer();
    forme1.afficher();
    forme1.afficherLigne();

    forme2.deplacer();
    forme2.afficher();
    forme2.afficherLigne();

    textFont(police, 16);

    fill(255, 0, 0);                                            // Affichage du joueur 1 et de son score en haut à gauche.
    textSize(32);
    text("KANGOU 1 ", 10, 45);
    text("SCORE: " + points1, 10, 80);

    fill(200, 150, 50);                                         // Affichage du joueur 2 et de son score en haut à droite.
    textSize(32);
    text("KANGOU 2 ", 1150, 45);
    text("SCORE: " + points2, 1150, 80);

    if (forme1.position.y >= height) {                          // On indique que si la boule 1 dépasse la limite basse de l'écran :
      points1 += 1;                                             // on ajoute 1 point au joueur 1
      randNumber = int(random(numberOfImages));                 // on change de level
      forme1.changeImage(images[randNumber]);                   // on inclu le boule 1 dans le nouveau level
      forme1.position.y = 0;                                    // on l'a positione tout en haut de l'écran.
      forme2.changeImage(images[randNumber]);                   // on inclu le boule 2 dans le nouveau level
      forme2.position.y = 0;                                    // on l'a positione tout en haut de l'écran.
    }

    if (forme2.position.y >= height) {                          // Pareil si la boule 2 franchit le bas de l'écran en premier.
      points2 += 1;
      randNumber = int(random(numberOfImages));
      forme1.changeImage(images[randNumber]);
      forme1.position.y = 0;
      forme2.changeImage(images[randNumber]);
      forme2.position.y = 0;
    }

    if ((points1 >= 2) || (points2 >= 2)) {                      // Si l'un des joueurs gagne 2 points, alors le "mode_jeu" passe à 2.
      mode_jeu = 2;
      mode_init = true;
    }
  }

  if (mode_jeu == 2) {                                           // On déclenche un compte à rebourd avant de repasser à l'ecran de démarrage.
    if (mode_init == true) {
      mode_init = false;
      mode_start = millis();
    }

    if (points1 >= 2) {                                          // On affiche l'écran du vainceur "joueur 1" s'il a remporter les 2 points en premier.
      image(win1, 0, 0);
      forme1.position.y = 0;
      forme2.position.y = 0;
    }

    if (points2 >= 2) {                                          // On affiche l'écran du vainceur "joueur 2" s'il a remporter les 2 points en premier.
      image(win2, 0, 0);
      forme1.position.y = 0;
      forme2.position.y = 0;
    }
    if (millis() - mode_start > 10000) {                         // Au bout de 10 secondes, on revient à l'écran de démarrage.
      mode_jeu = 0;
      points1 = 0;
      points2 = 0;
    }
  }

  stroke(255);
  strokeWeight(2);
  fill(127);
}

void keyPressed() {

  if ((key == ' ') && ((mode_jeu == 0) || (mode_jeu == 2))) mode_jeu = 1;           // On appui sur "espace" pour lancé le jeu.

  if (key == 'r') {                                               // On appui sur "r" pour faire respawn les boules.
    forme1.position.set(width/2, 40);
    forme2.position.set(width/2, 60);
  }
}

void serialEvent (Serial myPort) {                                // On reçoit les 4 valeurs liées aux capteurs de pression connectés à la carte Arduino.

  while (myPort.available() > 0) {

    String inBuffer = myPort.readStringUntil('\n');

    if (inBuffer != null) { 
      texte = inBuffer;
      String[] list = split(inBuffer, ',');

      if (list.length == 4) {
        valeur1 = float(list[0]);
        valeur2 = float(list[1]);
        valeur3 = float(list[2]);
        valeur4 = float(list[3]);
        mouvementFormes(valeur1, valeur2, valeur3, valeur4);
      }
    }
  }
}

void mouvementFormes(float forme1gauche, float forme1droite, float forme2gauche, float forme2droite) {  // On attribue pour chaque capteur de pression une boule et sa direction de vélocité.

  float vxmin = 0.5;                                             // On attribue une vélocité minimum.
  float vxmax = 1;                                               // et maximum.

  if (forme1gauche > 200) {                                                // On fait monter la boule 1 vers la gauche pour une pression minimum de 200 sur le capteur 1.
    forme1.velocite.y -= 2;
    forme1.velocite.x -= map(forme1gauche, 200, 1023, vxmin, vxmax);
  }
  if (forme1droite > 200) {                                                // On fait monter la boule 1 vers la droite pour une pression minimum de 200 sur le capteur 2.
    forme1.velocite.y -= 2;
    forme1.velocite.x += map(forme1droite, 200, 1023, vxmin, vxmax);
  }
  if (forme2gauche > 200) {                                                // On fait monter la boule 2 vers la gauche pour une pression minimum de 200 sur le capteur 3.
    forme2.velocite.y -= 2;
    forme2.velocite.x -= map(forme2gauche, 200, 1023, vxmin, vxmax);
  }
  if (forme2droite > 200) {                                                // On fait monter la boule 2 vers la droite pour une pression minimum de 200 sur le capteur 4.
    forme2.velocite.y -= 2;
    forme2.velocite.x += map(forme2droite, 200, 1023, vxmin, vxmax);
  }
}
