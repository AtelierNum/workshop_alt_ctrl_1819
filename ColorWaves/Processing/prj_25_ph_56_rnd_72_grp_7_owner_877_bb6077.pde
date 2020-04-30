
import processing.serial.*;// librairie pour la liaison série
import processing.sound.*;// librairie pour le son

float smoothingFactor = 0.25;// coefficient pour smooth l'impact du son sur le noise

float sum;// valeur smooth qui va impacter le noise

int score = -1;// score des joueurs -1 car il y a un tour dans le vide pour générer une couleur
int highscore = 0;// variable qui prend la valeur dans highscore.txt ou la valeur score si elle est supérieur
String[] highscoreload;// tableau qui prend les valeur situées dans highscore.txt
int r =0;// valeur rouge de la couleur à obtenir
int v =0;// valeur verte...
int b =0;// valeur bleu...

int[] chcouleur= { 0, 120, 250 };// Possibilités que peuvent prendre r,v,b
int rplayer =0;// valeur rouge entrante
int vplayer =0;// valeur verte...
int bplayer =0;//valeur bleu...

int rplayerend=0;//valeur rplayer mapper entre 3 possibilitées, 0,120,250
int vplayerend =0;// valeur vplayer...
int bplayerend =0;//valeur bplayer...

int testA, testB, testtemps;// variable qui sert à check si les joueurs ont la bonne couleur pendant 3sec
int go = 0;// variable si elle est égal à zero attribue une nouvelle couleur à obtenir
int changecolour = 0;// variable qui valide la manche, pour passer au étape suivante
int gameover = 0;// variable qui si est égal à 1 affiche l'écran de score car la partie est finie
int gamestart = 0;// variable qui si est égal à 1 commence une nouvelle partie
float coeffvitesse;// coefficient pour augmenter la vitesse du jeu en fonction du score



////////////////cercle avec du bruit

float resolution = 500; // nombre de point par cercle avec le bruit
float x = 1;//coordonnée vertex des points du cercle
float y = 1;//...
float t = 0; // temps passé
float tChange = .02; // valeur de vitesse de changement des coordonnées des vertex
float nVal; // valeur du bruit

float nIntr = 3.5; // intensité du bruit du cercle rouge
float nAmpr = 0.7; // amplitude du bruit du cercle rouge

float nIntv = 3; // cercle vert
float nAmpv = 0.75; // cercle vert

float nIntb = 3.2; // cercle bleu
float nAmpb = 0.8; // cercle bleu


/////////////


int delaygameover =0;// variable qui si est égal à 1 évite un delai
int delaygamestart = 0;// variable qui si est égal à 1 évite un delai
int rayonend = 0;// valeur de la taille du cercle quand la partie est perdu
int scoretextflash =0;// valeur de la taille de la police du texte "score"
int scoreflash =0;//valeur de la taille de la police du texte de la variable score
int colourwaveflash =100;// valeur de la taille de la police du texte colour waves
float hsb;// variable hsb pour la couleur du titre principal dans le menu
float rayon = 1000;// dimension du cercle qui se rapproche, qui défini le temps restant et la couleur à obtenir
String inBuffer;// variable qui prend la valeur du Serial via arduino
long temps;// variable qui prend millis à un temps donné
PFont font;// déclaration d'une font

SoundFile ambiancesound;//déclaration d'un son
SoundFile gameoversound;//...
SoundFile victoiresound;//...
Amplitude rms;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port


void setup() {

  fullScreen(2); // plein écran sur le deuxième écran
  font = createFont("Atari.ttf", 70);// création de la font atari
  textAlign(CENTER);// origine de tous les textes par le centre
  textFont(font);// applique la font atari
  printArray(Serial.list());// liste les ports ouverts pour une liaison série
  String portName = Serial.list()[0];// choisi le port correspondant à notre arduino
  myPort = new Serial(this, portName, 9600);// Avec un baudrate de 9600
  myPort.bufferUntil('\n');// enlève les espaces
  highscoreload = loadStrings("highscore.txt");//  charge le score placé dans highscore.txt
  highscore = Integer.parseInt(highscoreload[0]);// par et prend la première valeur

  ambiancesound= new SoundFile(this, "ambiance.wav");// associe les variables à des fichiers son
  gameoversound= new SoundFile(this, "gameover.wav");//...
  victoiresound= new SoundFile(this, "victoire.wav");//...
  ambiancesound.amp(0.5);// diminue le volume de moitié
  ambiancesound.play();// on le joue
  ambiancesound.loop();// en boucle
  rms = new Amplitude(this);   // création d'un patch pour suivre l'rms de la musique d'ambiance
  rms.input(ambiancesound);
}

void draw() {
  translate(width/2, height/2);// on place l'origine au centre de notre fenêtre
  if ( gamestart == 0) {// si les capteurs ne sont pas activé reste dans cette boucle
    menu();// menu du jeu
  } else {
    colorMode(RGB);//on change le mode de couleur en rvb
    if (gameover == 1) {// si on perd
      gameover();// affichage du score et retour au menu
    } else {
      affichage();// on affiche les différents élements du jeu
      if (go == 0) {
        nouvellecouleur();// remet des variables à zero et attribue une nouvelle couleur à obtenir
      }
      score();// système de score
    }
  }
}

void affichage() {
  clean();// fonction qui nettoie la fenêtre avec un rectangle blanc
  noFill();
  strokeWeight(50);
  stroke(r, v, b);// le contour de l'ellipse prend la valeur r,v,b que doit avoir les joueurs pour obtenir un point
  ellipse(0, 0, rayon, rayon);// l'ellipse en question
  gestioncouleur();// map les couleurs des joueurs ainsi que le noise des cercles
  cerclenoise();// on affiche les ellipses avec du noise
  noStroke();
  fill(rplayerend, vplayerend, bplayerend);// l'ellipse centrale qui correspond à la combinaison des r,v,b joueurs
  ellipse(0, 0, 300, 300);// l'ellipse en question
  fill(255);
  textSize(70);
  text(score, 0, 0+30);//affichage du score
}

void cerclenoise() {
  // CODE TROUVÉ SUR INTERNET avec quelques ajouts 
  noFill();
  strokeWeight(8);
  stroke(rplayerend, 0, 0);// couleur du joueur rouge
   sum += (rms.analyze() - sum) * smoothingFactor; // smooth la valeur de l'analyse de la musique d'ambiance
   float rayon = map(sum,0,1,0,150); // map sum qui est compris entre 0,1 pour avoir une plus grande amplitude visuelle
  beginShape();
  for (float a=0; a<=TWO_PI; a+=TWO_PI/resolution) {

    nVal = map(noise( cos(a)*nIntr+1, sin(a)*nIntr+1, t ), 0.0, 1.0, nAmpr, 1.0); // map noise value to match the amplitude

    x = cos(a)*(400+rayon) *nVal;
    y = sin(a)*(400+rayon) *nVal;
    vertex(x, y);
  }
  endShape(CLOSE);

  stroke(0, vplayerend, 0);// couleur du joueur vert
  beginShape();
  for (float a=0; a<=TWO_PI; a+=TWO_PI/resolution) {

    nVal = map(noise( cos(a)*nIntv+1, sin(a)*nIntv+1, t ), 0.0, 1.0, nAmpv, 1.0); // map noise value to match the amplitude

    x = cos(a)*(430+rayon) *nVal;
    y = sin(a)*(430+rayon) *nVal;
    vertex(x, y);
  }
  endShape(CLOSE);

  stroke(0, 0, bplayerend);// couleur du joueur bleu
  beginShape();
  for (float a=0; a<=TWO_PI; a+=TWO_PI/resolution) {

    nVal = map(noise( cos(a)*nIntb+1, sin(a)*nIntb+1, t ), 0.0, 1.0, nAmpb, 1.0); // map noise value to match the amplitude

    x = cos(a)*(460+rayon)*nVal;
    y = sin(a)*(460+rayon)*nVal;
    vertex(x, y);
  }
  endShape(CLOSE);

  t += tChange;
}

void clean() {//fonction qui nettoie la fenêtre avec un rectangle blanc
  fill(240);
  noStroke();
  rect(-width, -height, width*2, height*2);
}

void gameover() {
  if ( delaygameover == 0) {//un délai pour laisser le joueur voir l'écran
    delay(1000);
    delaygameover=1;
  }
  if ( rayonend < 2500) {//affichage d'un écran noir via une ellipse
    fill(0);
    ellipse(0, 0, rayonend, rayonend);
    rayonend = rayonend + 20;
  } else { 
    if (scoretextflash < 200) {//affiche le texte score avec un effet de profondeur
      scoretextflash+=2;
      fill(0, 50);
      rect(-width, -height, 2*width, height);
      fill(255);
      textSize(scoretextflash);
      text("Score", 0, -200);
    } else {
      if (scoreflash < 180) {//affiche le score avec un effet de profondeur
        scoreflash+=3;
        fill(0, 50);
        rect(-width, 0, 2*width, height);
        fill(255);
        textSize(scoreflash);
        text(score, 0, 200);
      } else {
        delay(4000);// délai pour voir notre score
        gamestart = 0;// reset les variables
        colourwaveflash =0;
        delaygamestart = 0;
        rplayerend=0;
        vplayerend =0;
        bplayerend =0;
        fill(0);//efface tout avec un rectangle noir
        rect(-width, -height, width*2, height*2);
      }
    }
  }
}

void gestioncouleur() {
  if ( rplayer < 60) {// partie qui map les valeurs entrantes en 3 possibilitées, 0,120,250 pour simplifier le jeu.
    rplayerend = 0;
  }
  if ( rplayer >60 && rplayer <180) {// plage plus grande pour la valeur du milieu car plus compliqué à avoir avec les capteurs
    rplayerend = 120;
  }
  if ( rplayer >180) {
    rplayerend = 250;
  }

  if ( vplayer < 60) {
    vplayerend = 0;
  }
  if ( vplayer >60 && vplayer <180) {
    vplayerend = 120;
  }
  if ( vplayer >180) {
    vplayerend = 250;
  }

  if ( bplayer < 60) {
    bplayerend = 0;
  }
  if ( bplayer >60 && bplayer <150) {
    bplayerend = 120;
  }
  if ( bplayer >180) {
    bplayerend = 250;
  }


  //////////////////////// On map les données entrantes des joueurs avec l'intensité et l'amplitude du bruit pour savoir si on se rapproche de la bonne valeur ou non

  if ( r == 0) {
    nIntr = map(rplayer, 0, 255, 0.8, 5);
    nAmpr = map(rplayer, 0, 255, 1, 0.8);
  }
  if ( r == 250) {
    nIntr = map(rplayer, 0, 255, 5, 0.8);
    nAmpr = map(rplayer, 0, 255, 0.8, 1);
  }
  if ( r == 120) {
    if ( rplayer < 120) {
      nIntr = map(rplayer, 0, 120, 5, 0.8);
      nAmpr = map(rplayer, 0, 120, 0.8, 1);
    }
    if ( rplayer > 120) {
      nIntr = map(rplayer, 120, 255, 0.8, 5);
      nAmpr = map(rplayer, 120, 255, 1, 0.8);
    }
  }
  if ( v == 0) {
    nIntv = map(vplayer, 0, 255, 0.8, 5);
    nAmpv = map(vplayer, 0, 255, 1, 0.8);
  }
  if ( v == 250) {
    nIntv = map(vplayer, 0, 255, 5, 0.8);
    nAmpv = map(vplayer, 0, 255, 0.8, 1);
  }
  if ( v == 120) {
    if ( vplayer < 120) {
      nIntv = map(vplayer, 0, 120, 5, 0.8);
      nAmpv = map(vplayer, 0, 120, 0.8, 1);
    }
    if ( vplayer > 120) {
      nIntv = map(vplayer, 120, 255, 0.8, 5);
      nAmpv = map(vplayer, 120, 255, 1, 0.8);
    }
  }

  if ( b == 0) {
    nIntb = map(bplayer, 0, 255, 0.8, 5);
    nAmpb = map(bplayer, 0, 255, 1, 0.8);
  }
  if ( b == 250) {
    nIntb = map(bplayer, 0, 255, 5, 0.8);
    nAmpb = map(bplayer, 0, 255, 0.8, 1);
  }
  if ( b == 120) {
    if ( bplayer < 120) {
      nIntb = map(bplayer, 0, 120, 5, 0.8);
      nAmpb = map(bplayer, 0, 120, 0.8, 1);
    }
    if ( bplayer > 120) {
      nIntb = map(bplayer, 120, 255, 0, 5);
      nAmpb = map(bplayer, 120, 255, 1, 0.8);
    }
  }
}
void menu() {
  gestioncouleur();// map les couleurs des joueurs ainsi que le noise des cercles
  colorMode(HSB);// change le mode de couleur ( effet rainbow du menu plus facile à obtenir)
  if (hsb >= 255) {// boucle la valeur de saturation de 0 à 255
    hsb=0;
  } else {
    hsb++;
  }
  if (colourwaveflash < 200) { // on affiche le texte colour waves avec de la profondeur
    colourwaveflash+=1;
    fill(0, 10);
    rect(-width, -height, 2*width, 2*height);
    fill(hsb, 255, 255);
    textSize(colourwaveflash);
    text("color waves", 0, -200);
  } else {
    fill(0, 0, 255);
    if ( delaygamestart == 0) {// délai pour que le joueur puisse voir les informations
      delay(1000);
      delaygamestart = 1;
    }
    if (score > highscore) {// détermine si le meilleur score a été battu et l'affiche, ainsi que le texte pour appeler le joueur à commencer une partie
      highscore = score;
      String[] highscoresave = new String[]{str(highscore)};
      saveStrings("highscore.txt", highscoresave);
    }
    textSize(60);
    text("HighScore", -50, 30);
    text(highscore, 150, 30);
    textSize(40);
    text("Activer les capteurs pour commencer", 0, 200);
    if ( rplayerend > 200 && vplayerend > 200 && bplayerend > 200) { // si les joueurs on activé leur capteur
      delay(2000);
      gamestart=1;// reset les variables
      score =-1;
      scoretextflash =0;
      scoreflash =0;
      gameover =0;
      delaygameover=0;
      rayonend=0;
      changecolour=0;
      rayon=1000;
      go=0;
    }
    fill(hsb, 255, 255);//effet rainbow du titre
    textSize(200);
    text("color waves", 0, -200);
  }
}

void nouvellecouleur() {// on attribue soit 0,120,250 avec un random
  int randomcouleur= int(random(0, 3));
  r = chcouleur[randomcouleur];
  randomcouleur= int(random(0, 3));
  v = chcouleur[randomcouleur];
  randomcouleur= int(random(0, 3));
  b = chcouleur[randomcouleur];
  go=1;//reset des variables
  changecolour=0;//...
  rayon=1000;//...
  score++;// on ajoute 1 point au score
  victoiresound.amp(1);// on joue un son
  victoiresound.play();
}

void score() {
  if (r == rplayerend && v == vplayerend && b == bplayerend  ) { //si les joueurs tiennent la bonne couleur pendant 3 secondes, ils valident la manche
    if ( testtemps == 0) {
      temps = millis(); 
      testtemps=1;
    }
    if ( millis() > temps+1000) {
      testA=1;
    }
    if ( (millis() > temps+2000) && testA==1) {
      testB=1;
    }
    if ( (millis() > temps+3000) && testB==1) {
      changecolour=1;
    }
  }
  if (millis() > temps+3000) {// sinon on reset le temps
    testtemps=0;
  }
  if ( rayon < 250 ) {// si les joueurs ont trouvé la bonne couleur avant le temps imparti, il valide la manche
    changecolour = 1;
    if (r == rplayerend && v == vplayerend && b == bplayerend) {
      changecolour = 1;
    } else {// sinon game over
      gameoversound.amp(1);
      gameoversound.play();
      gameover =1;
    }
  }
  if (rayon > 1000) {// si la manche à été validé, on réduit le temps de la manche
    go=0;
  } else {
    coeffvitesse = 0.5*((float(score)/5)+1);// on calcule un coefficient en fonction du score
    rayon = rayon-coeffvitesse;// on soustrait le coefficient au rayon du cercle qui détermine le temps de la manche
  }

  if (changecolour == 1) {// quand la manche est validé, on fait revenir le cercle qui détermine le temps de sa position initiale
    rayon= rayon+20;
  }
}
void serialEvent (Serial myPort) {

  while (myPort.available() > 0) {
    String inBuffer = myPort.readStringUntil('\n');

    if (inBuffer != null) { 
      String[] firstsplit = (split(inBuffer, ':'));// on split la inBuffer avec ":"
      String verifsplit = "valeur";
      if ( firstsplit[0].equals(verifsplit) == true) { //si la première valeur est égal a valeur, pour éviter les informations non voulu qu'enverrai l'arduino
        int[] secondsplit = int(split(firstsplit[1], '/'));// on split la deuxième valeur pour récupérer les valeurs r,v,b des joueurs
        bplayer = secondsplit[0];//on attribue les valeurs à récupérer de l'arduino
        vplayer = secondsplit[1];//...
        rplayer = secondsplit[2];//...
      }
    }
  }
}
