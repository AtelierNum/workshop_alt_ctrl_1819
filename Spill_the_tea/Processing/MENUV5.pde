import processing.serial.*;    // Importe la libraire série pour communiquer avec Arduino
Serial myPort;                 // Initialise une variable 'myPort' pour la communication série
Serial myPort2;                // Initialise une variable 'myPort' pour la communication série
import processing.sound.*;     // Importe la librairie pour gérer le son

//-----------------------------------------------------------------------------------------------------------------------------------------------

float note_jouee = 6 ;         //crée une variable pour la note qu'on récuperera sur arduino
float note_joueeD = 6 ;        //crée une variable pour la seconde note qu'on récuperera sur arduino
int timeDebut;                 // crée une variable pour le temps
int niveau = 0;                // crée et initialise la variable pour le niveau
int note = 0;                  // variable de la note de la musique pour la main gauche
int noteD = 0;                 // variable de la note de la musique pour la main droite
int score = 0;                 // variable du score
int gameScreen = 0;            // variable pour afficher les différents écrans du jeu

//-----------------------------------------------------------------------------------------------------------------------------------------------

Serial arduino1;                         // Déclarer l'objet série pour le premier arduino
Serial arduino2;                         // Déclarer l'objet série pour le second arduino
int arduino1_data1, arduino1_data2;      // Données du premier arduino
int arduino2_data1, arduino2_data2;      // Données du second arduino

//-----------------------------------------------------------------------------------------------------------------------------------------------

PImage imgStart, imgMenu, niv1, niv2, niv3, scoreimg; //crée les images pour les différents fonds
PImage score1, score2, score3, score4, score5;        //crée les images pour le score pendant le jeu
PImage scoreF1, scoreF2, scoreF3, scoreF4, scoreF5;   //crée les images pour le score final
PImage[] imgMainsG = new PImage[4];                   //crée une liste d'images pour la main gauche
PImage[] imgMainsD = new PImage[4];                   //crée une liste d'images pour la main droite
SoundFile[] mesSons = new SoundFile[3];               //crée une liste de sons
Mains[] m = new Mains[50];                            //crée les icones pour la main gauche
MainsD[] mD = new MainsD[50];                         //crée les icones pour la main droite

boolean[] displayIcon = new boolean[50];              //crée les booléns pour l'affichage des icones de la main gauche
boolean[] displayIconD = new boolean[50];             //crée les booléns pour l'affichage des icones de la main droite

//-----------------------------------------------------------------------------------------------------------------------------------------------

//les tableaux des notes avec leurs timings pour chacune des 3 musiques, un pour la main gauche et un pour la main droite
int[][] chansonD1 = { 
  {0, 1, 2, 0, 2, 1, 0, 2, 1, 2, 3}, //11 //main droite 
  {5120, 7000, 9060, 15000, 18070, 20230, 22190, 28110, 30040, 32190, 36170} 
};

int[][] chansonD2 = { 
  {2, 3, 1, 0, 2, 1, 0, 2, 3, 1, 0, 2, 3, 1, 2, 3, 0}, //17 //main droite 
  {3100, 8160, 9060, 10100, 12140, 14180, 15180, 17090, 20170, 23010, 26060, 27120, 30100, 31190, 33100, 35240, 37000} 
}; 

int[][] chansonD3 = { 
  {1, 2, 0, 2, 1, 0, 1, 2, 3, 1, 0, 2, 1, 0, 2, 2, 0, 2, 3, 1, 2, 0, 3, 3, 2, 1, 0}, //27 //maindroite 
  {8040, 9240, 10140, 14080, 14260, 16030, 19150, 20010, 21090, 24190, 25030, 26070, 29080, 30110, 30270, 33150, 34260, 35140, 35260, 36090, 36140, 38160, 38290, 40110, 40210, 41080, 43030} 
}; 

int[][] chansonG1 = { 
  {0, 2, 2, 0, 0, 1, 2, 3, 2, 2, 3, 2, 3, 3, 0}, //15
  {2190,  4070, 6220, 8170, 10080, 12020, 15090, 18230, 22020, 23040, 25050, 29140, 30210, 34100} 
}; 

int[][] chansonG2 = { 
  {3, 1, 2, 2, 0, 0, 1, 2, 3, 2, 2, 3, 2, 3, 3, 0}, //16
  {8000,  9220, 10220, 11180, 13000, 17210, 21080, 22030, 23080, 24120, 28020, 31000, 34130, 35090, 36000} 
}; 

int[][] chansonG3 = { 
  {3, 0, 1, 2, 2, 0, 1, 0, 1, 2, 3, 2, 2, 1, 1, 2, 2, 0, 1, 2, 3, 3, 1, 2, 2, 3, 3, 0, 1}, //29 
  {2100, 3290, 5140, 11100, 12100, 12290, 16280, 17130, 18080, 22030, 22260, 23080, 27020, 27250, 28040, 28200, 31160, 31270, 32030, 32250, 37010, 38090, 38290, 40110, 40210, 41200, 42070, 42160, 43030} 
};


void setup ( ) { //------------------------------------------------------------------------------------------------------------------------------------------------------
  size (1920, 1080);
  
  //appelle toutes les images des fonds d'écrans et score
  imgStart = loadImage("imgdepart.png");
  imgMenu = loadImage("imgmenu.png");
  niv1 = loadImage("niveau1.png");
  niv2 = loadImage("niveau2.png");
  niv3 = loadImage("niveau3.png");
  scoreimg = loadImage("score.png");
  score1 = loadImage("tea_0.png");
  score2 = loadImage("tea_25.png");
  score3 = loadImage("tea_50.png");
  score4 = loadImage("tea_75.png");
  score5 = loadImage("tea_100.png");
  scoreF1 = loadImage("GT_0_.png");
  scoreF2 = loadImage("GT_25_.png");
  scoreF3 = loadImage("GT_50_.png");
  scoreF4 = loadImage("GT_75_.png");
  scoreF5 = loadImage("GT_100_.png");
  

  printArray(Serial.list());      // Afficher sur la console la liste des ports série utilisés
 
  arduino1 = new Serial(this, "/dev/cu.usbmodem14101", 9600); //appelle la première carte arduino
  arduino2 = new Serial(this, "/dev/cu.usbmodem14201", 9600); //appelle la seconde carte arduino
  arduino1.bufferUntil('\n'); 
  arduino2.bufferUntil('\n');
  
  //initialisation des arrays
  for (int i = 0; i < 3; i++) {   //importe les sons
    mesSons[i] = new SoundFile(this, "son" + str(i) + ".mp3");
  }
  for (int i = 0; i < 4; i++) {  //importe les images pour la main gauche
    imgMainsG[i] = loadImage("mainG" + str(i) + ".png");
  }
  for (int i = 0; i < 4; i++) {  //importe les images pour la main droite
    imgMainsD[i] = loadImage("mainD" + str(i) + ".png");
  }
  for (int i = 0; i < 50; i++) {  //défini les booléens
    displayIcon[i] = false;
  }  
  for (int i = 0; i < 50; i++) {  //défini les booléens
    displayIconD[i] = false;
  }
  for (int i = 0; i < 50; i++) {  //défini les icones mains
    m[i] = new Mains(-140, 830);
  }
  for (int i = 0; i < 50; i++) {  //défini les icones mains
    mD[i] = new MainsD(2160, 830);
  }
  
}


void serialEvent (Serial port) { //------------------------------------------------------------------------------------------------------------------------------------------------------
 
  // Réception des évènements sur les ports série
  // les deux ports sont différenciés avant de traiter les données
  if (port == arduino1) {
    note_jouee = float(port.readStringUntil('\n'));   //assigne à note_jouee la valeur récuperée sur le premier arduino
  } else if (port == arduino2) {
     note_joueeD = float(port.readStringUntil('\n')); //assigne à note_joueeD (de la main droite) la valeur récuperée sur le second arduino
  }
}

void draw ( ) { //------------------------------------------------------------------------------------------------------------------------------------------------------

  //affiche les écrans en fonction de l'état de la variable gameScreen
  if (gameScreen == 0) {
    accueilScreen();              // écran d'accueil
  } else if (gameScreen == 1) {
    menuScreen();                 // écran de menu/choix
  } else if (gameScreen == 2) {
    jeu1();                       // premiere musique
    scoreThe();                   // affiche le score
  } else if (gameScreen == 3) {
    jeu2();                       // seconde musique
    scoreThe();                   // affiche le score
  } else if (gameScreen == 4) {
    jeu3();                       // troisième musique
    scoreThe();                   // affiche le score
  } else if (gameScreen == 5) {
    scoreScreen();                // score final
  }
  
}


void accueilScreen() { //-----------------------------------------------------------------------------------------------------------------------------------------
  
  // affiche l'écran d'accueil, permet de passer à l'écran du menu
  background(imgStart);
  if (note_jouee == 0) {
    gameScreen = 1;
  }
}

void scoreScreen() { //-----------------------------------------------------------------------------------------------------------------------------------------
  
  // affiche la tasse de thé remplie ou non en fonction du score sur l'écran final
  background(scoreimg);   
  if (score <= 2) {
     image(scoreF1, 750, 400, 400, 203 );
   }
   if (score <= 5 && score > 2) {
     image(scoreF2, 750, 400, 400, 203 );
   }
   if (score <= 9 && score > 5) {
     image(scoreF3, 750, 400, 400, 203 );
   }
   if (score <= 12 && score > 9) {
     image(scoreF4, 750, 400, 400, 203 );
   }
   if (score > 12) {
     image(scoreF5, 750, 400, 400, 203 );
   }
  if (note_jouee == 0) {
    gameScreen = 1;
  }
}

void scoreThe() { //-----------------------------------------------------------------------------------------------------------------------------------------
 
   // Affiche la tasse de thé remplie ou non en fonction du score sur l'écran de jeu
   if (score <= 2) {
     image(score1, 900, 80, 111, 56 );
   }
   if (score <= 5 && score > 2) {
     image(score2, 900, 80, 111, 56 );
   }
   if (score <= 9 && score > 5) {
     image(score3, 900, 80, 111, 56);
   }
   if (score <= 12 && score > 9) {
     image(score4, 900, 80, 111, 56 );
   }
   if (score > 12) {
     image(score5, 900, 80, 111, 56);
   }
}

void menuScreen() {  //-----------------------------------------------------------------------------------------------------------------------------------------
  
  note = 0;             // réinitialise les notes
  noteD = 0;            // réinitialise les notes
  score = 0;             // réinitialise le score
  
  // Choix de la musique à jouer en fonction de la note jouée
  background(imgMenu);
  if (note_jouee == 1) {
    timeDebut = millis(); // initialise le temps de la musique
    gameScreen = 2;       // affiche le second écran
    mesSons[0].play();    // lance la musique
  }
  if (note_jouee == 2) {
    timeDebut = millis();
    gameScreen = 3;
    mesSons[1].play();
  }
  if (note_jouee == 3) {
    timeDebut = millis();
    gameScreen = 4;
    mesSons[2].play();
  }
}

void jeu1() { //---------------------------------------------------------------------------------------------------------------------------------------------------
  
  // partie de la première musique
  background(niv1); //met le fond correspondant
  
  //PARTIE GAUCHE
  if (millis()<= timeDebut+37000){ //arrête la partie quand la musique est finie
    // lance les icones des mains une seconde avant la note et tant qu'il reste des notes
    if (millis() >= timeDebut+chansonG1[1][note]-1000 && millis() <= timeDebut+chansonG1[1][note]+100 && note < 13) {
      displayIcon[note] = true;    // rend vrai le booléen de la note correspondante
      if (note_jouee == float(chansonG1[0][note])) {  // compare la note qui passe et la note jouée
        score = score+1; // incrémente le score si c'est la même
      }
      note = note+1; // incrémente les notes
    }
    
    // affiche les icones de mains en fonction du booléen displayIcon et la note correspondante, en passant par une boucle for
    for (int i=0; i<42; i++) { 
      //ne l'affiche pas si il a dépassé le rond sur l'interface
      if (m[i].x >= 750) { 
        displayIcon[i] = false;
      }
      if (displayIcon[i] == true) {
        m[i].display(chansonG1[0][i]); // l'affiche avec l'icone correspondante
        m[i].bouge();                  // le déplace
        displayIcon[i] = true;
      }
    }
   
   //PARTIE DROITE
   if (millis() >= timeDebut+chansonD1[1][noteD]-1000 && millis() <= timeDebut+chansonD1[1][noteD] && noteD < 10) {
      displayIconD[noteD] = true;
      if (note_jouee == float(chansonD1[0][noteD])) {  
        score = score+1;
      }
      noteD = noteD+1;
    }
  
    for (int i=0; i<42; i++) {
      if (mD[i].x <= 970) {
        displayIconD[i] = false;
      }
      if (displayIconD[i] == true) {
        mD[i].display(chansonD1[0][i]);
        mD[i].bouge();
        displayIconD[i] = true;
      }
     }
     
   // si la musique dépasse son temps, on affiche l'écran de score final 
   } else {
    gameScreen = 5;
   }
 }

void jeu2() { //---------------------------------------------------------------------------------------------------------------------------------------------------

  background(niv2);
  
  //PARTIE GAUCHE
  if (millis()<= timeDebut+38000){
    if (millis() >= timeDebut+chansonG2[1][note]-1000 && millis() <= timeDebut+chansonG2[1][note]+100 && note < 14) {
      displayIcon[note] = true;
      if (note_jouee == float(chansonG2[0][note])) {  
        score = score+1;
      }
      note = note+1;
    }

    for (int i=0; i<42; i++) {
      if (m[i].x >= 750) {
        displayIcon[i] = false;
      }
      if (displayIcon[i] == true) {
        m[i].display(chansonG2[0][i]);
        m[i].bouge();
        displayIcon[i] = true;
      }
    }
    
   //PARTIE DROITE
   if (millis() >= timeDebut+chansonD2[1][noteD]-1000 && millis() <= timeDebut+chansonD2[1][noteD] && noteD < 15) {
      displayIconD[noteD] = true;
      if (note_jouee == float(chansonD2[0][noteD])) {  
        score = score+1;
      }
      noteD = noteD+1;
    }
  
    for (int i=0; i<42; i++) {
      if (mD[i].x <= 970) {
        displayIconD[i] = false;
      }
      if (displayIconD[i] == true) {
        mD[i].display(chansonD2[0][i]);
        mD[i].bouge();
        displayIconD[i] = true;
      }
    }
    
  } else {
    gameScreen = 5;
  }
}

void jeu3() { //---------------------------------------------------------------------------------------------------------------------------------------------------

  background(niv3);
  
  //PARTIE GAUCHE
  if (millis()<= timeDebut+45000){
    if (millis() >= timeDebut+chansonG3[1][note]-1000 && millis() <= timeDebut+chansonG3[1][note]+100 && note < 27) {
      displayIcon[note] = true;
      if (note_jouee == float(chansonG3[0][note])) {  
        score = score+1;
      }
      note = note+1;
    }
  
    for (int i=0; i<42; i++) {
      if (m[i].x >= 750) {
        displayIcon[i] = false;
      }
      if (displayIcon[i] == true) {
        m[i].display(chansonG3[0][i]);
        m[i].bouge();
        displayIcon[i] = true;
      }
    }
      
   //PARTIE DROITE   
   if (millis() >= timeDebut+chansonD3[1][noteD]-1000 && millis() <= timeDebut+chansonD3[1][noteD] && noteD < 25) {
      displayIconD[noteD] = true;
      if (note_jouee == float(chansonG3[0][noteD])) {  
        score = score+1;
      }
      noteD = noteD+1;
    }
  
    for (int i=0; i<42; i++) {
      if (mD[i].x <= 970) {
        displayIconD[i] = false;
      }
      if (displayIconD[i] == true) {
        mD[i].display(chansonD3[0][i]);
        mD[i].bouge();
        displayIconD[i] = true;
      }
    }
    
  } else {
    gameScreen = 5;
  }
}

void startGame() { //---------------------------------------------------------------------------------------------------------------------------------------------------
  
  // ouvre le premier écran de jeu
  gameScreen=1; 
}
