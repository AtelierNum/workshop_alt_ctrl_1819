//FUJU FUJU _ WORKSHOP JOYPAD

//Initilisation des images, variables, et autres paramètres
float diametre;
float newdiametre;
float valuepropre ;

PImage img;
PImage background;
PImage perso;
PImage startscreen;
PImage expression1;
PImage expression2;
PImage expression3;
PImage expression4;
PImage expression5;
PImage expression6;
PImage expression7;
PImage fondpoisson;
PImage endscreen;
PFont fujifont;

int scorej1;
int scorej2;
int scorej3;
int scorej4;
int round;
int joueur = 0;
int state;
float diamexplosion;

int level;
float quickanddirty;

Explosion boum;

void setup() {
  //size(1920, 1080, P2D);
  fullScreen();
  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, "/dev/tty.usbmodem14201", 9600);
  myPort.bufferUntil('\n');

  diametre = 10;
  diamexplosion = 500+random(-50, 200); //On définit une plage d'explosion du poisson entre 500 et 700
  state = 1;
  round = 1;
  //Chargement des Images au début afin de ne pas faire lagguer le programme
  img = loadImage("niveausouffle.jpg");
  background = loadImage("background.png");
  perso = loadImage("perso.png");
  startscreen = loadImage("startscreen.png");
  expression1 = loadImage("expression1.png");
  expression2 = loadImage("expression2.png");
  expression3 = loadImage("expression3.png");
  expression4 = loadImage("expression4.png");
  expression5 = loadImage("expression5.png");
  expression6 = loadImage("expression6.png");
  expression7 = loadImage("expression7.png");
  fondpoisson = loadImage("fondpoisson.png");
  endscreen = loadImage("endscreen.png");


  fujifont = loadFont("FujiQuakeZone-72.vlw");
}


void draw() {

  boutonrouge(); // On lit le bouton rouge

  if (state == 1) { //La variable state définit l'écran sur lequel on se situe
    startscreen();
  }
  if (state == 2) {
    game();
    // Déclenchement de l'explosion :
    if (boum == null) return;
    boum.render();
    boum.update();
  }
  if (state == 3) { //Ecran de fin
    endscreen();
  }
}

void startscreen() {
  image(startscreen, 0, 0);
}

void endscreen() {
  image(endscreen, 0, 0);
  float[] leader = { scorej1, scorej2, scorej3, scorej4 }; // A améliorer afin de d'afficher le joueur gagnant
  leader = sort(leader);
  println(leader[3]);
  fill(#FFFFFF);
  textAlign(CENTER);
  text("I THINK SOMEONE WON !!!!!", width/2, height/2);
}
void game() {
  background(background);
  //valuepropre permet de récuperer les données du micro entre 150 et 280 afin de les passer entre 0 et 100
  valuepropre = map(valueFromArduino, 150, 280, 0, 100);
  valuepropre = int(valuepropre);
  valuepropre = constrain(valuepropre, 0, 100);


  barresouffle(); //On affiche la barre qui augmente en fonction du souffle du joueur

  //On affiche tous les scores des joueurs
  textFont(fujifont);
  textAlign(RIGHT);
  fill(#FA1100);
  text(scorej1, 1875, 200); 
  fill(#64FF00);
  text(scorej2, 1875, 300); 
  fill(#3EFEFF);
  text(scorej3, 1875, 400);
  fill(#FFFF01);
  text(scorej4, 1875, 500); 
  fill(#FFFFFF);
  text("ROUND "+ str(round), 1875, 950);

  noStroke();
  fill(#F47920);
  if (valuepropre > 20) { //Si la valeur du micro est supérieure a 20 on augmente le diamètre ainsi que le score du joueur qui joue
    diametre=diametre+12;
    if (joueur == 1) {
      scorej1++;
    }
    if (joueur == 2) {
      scorej2++;
    }
    if (joueur == 3) {
      scorej3++;
    }
    if (joueur == 4) {
      scorej4++;
    }
  }

  if (diametre > diamexplosion) { //Si le dimètre dépasse le diamètre prévu à l'explosion, le diamètre repart a zéro, on démarre l'explosion de particules et on remet a zero le joueur ayant fait eclater le poisson
    diametre = 0;
    boum = new Explosion(800, width / 2, height / 2);
    round++; //On compte un round en plus
    diamexplosion = 550+random(-100, 200); //Définit un noouveau seuil d'explosion du poisson
    if (round >= 6) { //reset de la partie après le round 5
      state=3;
      scorej1=0;
      scorej2=0;
      scorej3=0; 
      scorej4=0;
      round=1;
    }
    if (joueur == 1) { //Reset du score du joueur 
      scorej1 = 0;
    }
    if (joueur == 2) {
      scorej2 = 0;
    }
    if (joueur == 3) {
      scorej3 = 0;
    }
    if (joueur == 4) {
      scorej4 = 0;
    }
  }
  //Ci dessous le code permet de placer les images du poissons ainsi que ses différentes expressions selon le diamètre du définit, le poisson gonfle donc en fonction du souffle
  imageMode(CENTER);
  image(fondpoisson, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));

  if (0 <= diametre && diametre <= 100) {
    image(expression1, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (100 < diametre && diametre <= 200) {
    image(expression2, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (200 < diametre && diametre <= 300) {
    image(expression3, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (300 < diametre && diametre <= 400) {
    image(expression4, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (400 < diametre && diametre <= 500) {
    image(expression5, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (500 < diametre && diametre <= 560) {
    image(expression6, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }
  if (560 < diametre && diametre <= 1000) {
    image(expression7, width/2, height/2, fondpoisson.width*(diametre/1000), fondpoisson.height*(diametre/1000));
  }

  imageMode(CORNER);
}

void boutonrouge() { 
  if (bouton == 1) { //Lorsque le bouton est appuyé
    state = 2;
    if (state == 3) {
      state = 1;
    }//On passe a l'ecran de jeu
    joueur++; //On passe au joueur suivant
    if (joueur > 4) {
      joueur = 1;
    }
    delay(500);
  }
}

void barresouffle() {
  //La barre de niveau de souffle utilise les infos du micro pour les visualiser a travers un arc en ciel qui auglente si on souffle fort
  level = int(map(valuepropre, 0, 70, 0, 700));
  float lerp = 0.95; //must be between 0-1
  quickanddirty = lerp * quickanddirty + (1.0-lerp) * level;

  img.resize(90, int(quickanddirty));
  image(img, 105, height - img.height - 200);

  image(perso, -110, 0);
  println(valuepropre);
  println(level);
}
