import processing.serial.*;
import processing.sound.*;
Serial myPort;  // Create object from Serial class

//on recupere les valeurs des potentiomètres et des tilts du controlleur 
int pot1, shoot1, pot2, shoot2;

//on indique à quelle etape du programme nous commençons
float gameState = 1; 
// 1 = ecran d'accueil; 
// 2 = ecran tuto/secouer pour commencer
// 3 = le jeu 
// 10 = reinitialisation du jeu et retour à l'écran tuto

// on initialise toutes les variables 
boolean shoot1debug = false; // variable evitant de tirer deux fois d'affilé
boolean shoot2debug = false; // variable evitant de tirer deux fois d'affilé

boolean debritGenerated = false; // variable indiquant si les debrits ont étés générés lorsqu'un joueur est mort

int player1Ready = 0; // variable permettant de lancer le jeu quand les deux joueurs sont prets
int player2Ready = 0; // variable permettant de lancer le jeu quand les deux joueurs sont prets



//PHYSIQUE 
float TAILLEJOUEUR = 60; // en pixels de diametre
float TAILLEBALLE = 6; // en pixel de largeur
float FRICTION = 1.15; // friction davec l'environnement 
float SHOOTRECUL = 10; // recul exercé par le shoot
float SENSIBILITEVIRAGE = 7; //sensibilité du virage
float HEAL = 0.15; // vitesse de heal
float DEGATSHOT = 10; // degats infligé par une balle
float SPEEDDEBRIT = 2;




//JEU
float RAYONMAP; // Rayon de la map (calculé dans le setup)
float epaisseurLife; // epaisseur des barres de vies (calculé dans le setup)



//Listes d'objets
ArrayList<shot> messhot = new ArrayList<shot>(); //liste de shots
ArrayList<Debrit> mesDebrit = new ArrayList<Debrit>(); // liste de debrit


// EMPREINTES TEMPORELLES
int gameStartMillis; // empreinte temporelle du lancement du programme (dans le doute, si le programme a une latence)
int game321Millis; // empreinte temporelle du lancement du jeu
int EndGameMillis; // empreinte temporelle de la fin du jeu



//SONS
SoundFile musiqueIntro;
SoundFile musiqueLoop;
SoundFile defeated;
SoundFile healing_playerA;
SoundFile healing_playerB;
SoundFile shoot;
SoundFile damagePlayerA;
SoundFile damagePlayerB;
SoundFile decompteGo;



//iIMAGES
PImage readyNo;
PImage ready1;
PImage ready2;
PImage readyBoth;
PImage gameStart;



//PLAYERS
Player playerA;
Player playerB;



//LASERS (pour v2, pas fini)
//Ulti_ligne ulti_ligne1;
//Ulti_ligne ulti_ligne2;



void setup() {
  fullScreen(); // le jeu s'adapte à l'ecran
  RAYONMAP = (height *0.9)/2; // la taille de la map est adapté à l'écran
  epaisseurLife = RAYONMAP *0.045; // l'epaisseur des barres de vies est adapté à l'écran
  noCursor(); // on n'affiche pas le curseur

  // Position d'apparition des joueurs
  float playerAx = width/3;
  float playerAy = height/2;
  playerA = new Player(playerAx, playerAy, 1);

  float playerBx = width-width/3;
  float playerBy = height/2;
  playerB = new Player(playerBx, playerBy, 2);

  /*
  ulti_ligne1 = new Ulti_ligne(1); //team1
   ulti_ligne2 = new Ulti_ligne(2); //team2
   */

  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  printArray(Serial.list());
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');



  //Importation des sons
  musiqueIntro = new SoundFile(this, "music_intro.wav");
  musiqueLoop = new SoundFile(this, "music_loop.wav");
  defeated = new SoundFile(this, "defeated.wav");
  healing_playerA = new SoundFile(this, "healing_playerA.wav");
  healing_playerB = new SoundFile(this, "healing_playerB.wav");
  shoot = new SoundFile(this, "shoot.wav");
  damagePlayerA= new SoundFile(this, "damagePlayerA.wav");
  damagePlayerB= new SoundFile(this, "damagePlayerB.wav");
  decompteGo= new SoundFile(this, "321Go.wav");

  //Importation des images
  readyNo = loadImage("readyNo.png");
  ready1 = loadImage("ready1.png");
  ready2 = loadImage("ready2.jpg");
  readyBoth = loadImage("readyBoth.png");
  gameStart = loadImage("gameStart.png");
}


void draw() {
  // println("mesDebrit.size() = " + mesDebrit.size() );
  // println("gameState = " + gameState);
  //println("distance centre-souris = " + sqrt( sq(mouseX - (width/2)) + sq(mouseY - (height/2))));


  ////////////////// Ecran d'accueil //////////////////

  if (gameState == 1) { 
    //si la joueur
    if (!musiqueIntro.isPlaying()) {
      musiqueLoop.stop();
      musiqueIntro.loop();
      gameStartMillis = millis();
    }
    //afficher ecran accueil
    background(0);
    image(gameStart, 0, height/2 - ((9*width)/16)/2, width, (9*width)/16 );

    if (millis() - gameStartMillis > 5000) {
      gameState = 2;
    }
  }

  ////////////////// ecran tuto/secouer pour commencer //////////////////

  if (gameState == 2) {

    if (!musiqueIntro.isPlaying()) {
      //lancer musique d'accueil
      musiqueIntro.loop();
    }


    //afficher tuto
    background(0);
    image(readyNo, 0, height/2 - ((9*width)/16)/2, width, (9*width)/16 );
    /* //ATTENTION BY PASS 
     player1Ready++;
     player2Ready++;
     //ATTENTION BY PASS */
    if (shoot1 == 1 && shoot1debug == false) {
      player1Ready++;
      shoot1debug = true;
    }
    if (shoot1 == 0 && shoot1debug == true) {
      shoot1debug = false;
    }

    if (shoot2 == 1 && shoot2debug == false) {
      player2Ready++;
      shoot2debug = true;
    }
    if (shoot2 == 0 && shoot2debug == true) {
      shoot2debug = false;
    }
    println("player1Ready = " + player1Ready + "; player2Ready = " + player2Ready + ";");
    if (player1Ready > 3 &&  player2Ready > 3) {
      //afficher que les deux joueurs on secoués 
      image(readyBoth, 0, height/2 - ((9*width)/16)/2, width, (9*width)/16 );
      game321Millis = millis();
      musiqueIntro.stop();
      decompteGo.play();
      //barre de chargement rapide (1 seconde)
      gameState = 3;
    } else if (player1Ready > 3) {
      //afficher joueur 1 a secoué
      image(ready1, 0, height/2 - ((9*width)/16)/2, width, (9*width)/16 );
    } else if (player2Ready > 3) {
      //afficher joueur 2 a secoué
      image(ready2, 0, height/2 - ((9*width)/16)/2, width, (9*width)/16 );
    }
  }

  ////////////////// Le jeu //////////////////

  if (gameState == 3 || gameState == 4) {


    background(0);

    playerA.heal();
    playerB.heal();

    //on affiche le font de la map en blanc
    noStroke();
    fill(244, 238, 236);
    ellipse(width/2, height/2, RAYONMAP*2, RAYONMAP*2);

    /* 
     //Key pressed de test (lettre a clavier macbookpro) 
     keyPressed();
     println(keyCode);
     if (keyCode == 65) {
     playerB.life = 0;
     }
     */

    // affichage du décompte de debut de partie 
    if ((millis() - game321Millis)< 3000) {
      if ((millis() - game321Millis)> 2000) {
        //1000
        textSize(100);
        fill(0);
        text("1", width/2 - 30, height/2);
      } else if ((millis() - game321Millis)> 1000) {
        //2000
        textSize(100);
        fill(0);
        text("2", width/2 -30, height/2);
      } else {
        //1000
        textSize(100);
        fill(0);
        text("1", width/2 -30, height/2);
      }
    } else {

      // affichage de la partie 

      // on demarre la musique du jeu 
      if (!musiqueLoop.isPlaying() && (millis() - game321Millis)> 3000) {
        musiqueLoop.loop();
      }

      // detection du tir joueur 1/A
      if (shoot1 == 1 && shoot1debug == false) {
        playerA.shoot();
        shoot1debug = true;
      }
      if (shoot1 == 0 && shoot1debug == true) {
        shoot1debug = false;
      }

      // detection du tir joueur 2/B
      if (shoot2 == 1 && shoot2debug == false) {
        playerB.shoot();
        shoot2debug = true;
      }
      if (shoot2 == 0 && shoot2debug == true) {
        shoot2debug = false;
      }

      //On deplace les joueurs 
      playerA.deplacement();
      playerB.deplacement();

      //on applique de la friction au deplacement des joueurs
      playerA.friction();
      playerB.friction();

      //on verrifie que les joueurs ne sont pas hors de la carte
      //et si ils le sont on les renvoie de l'autre coté
      playerA.checkout();
      playerB.checkout();



      //on affiche les balles
      for (int i = 0; i < messhot.size(); i++) {
        //on selectione une balle
        shot shoti = messhot.get(i);
        //on deplace la balle 
        shoti.deplacement();
        //on verrifie que la balle n'est pas en dehors de la map
        shoti.checkout();
        // si la balle est hors de la map on la supprime 
        if (shoti.killMe == true) {
          messhot.remove(i);
        } else { // sinon on detete les collision et on l'affiche 
          shoti.collision();
          shoti.display();
        }
      }


      //Si un joueur vient de mourrir on genere des debrits
      if (playerB.life <= 0 && debritGenerated == false) {
        //generation des debris
        playerB.die();
      } else if (playerA.life <= 0 && debritGenerated == false) {
        //generation des debris
        playerA.die();
      }
    }

    //on calcul l'angle du joueur
    playerA.angle_calc();
    playerB.angle_calc();

    // si un joueur est vivant on l'affiche
    if (playerA.life > 0) {
      playerA.canon_show();
      playerA.display();
    }
    if (playerB.life > 0) {
      playerB.canon_show();
      playerB.display();
    } 

    // si un joueur est mort, on affiche les débrits
    if (playerA.life <0 || playerB.life <0) {
      for (int i = 0; i < mesDebrit.size(); i++) {
        // on selectione un débris
        Debrit debriti = mesDebrit.get(i);
        // on deplace le debris
        debriti.deplacement();
        //on applique de la friction au deplacement du débrit
        debriti.friction();
        //on affiche le débris
        debriti.display();
        //3 seconde apres la mort d'un des joueurs, on va reinitialiser le jeu et retourner au tuto
        if (millis() - EndGameMillis >3000) {
          gameState = 10 ; //reinit variables
        }
      }
    }


    /*
    //afficher le laser
     ulti_ligne1.angleUpdate();
     ulti_ligne1.display(); */


    // on affiche les barres de vies
    strokeWeight(epaisseurLife);
    noFill();
    stroke(245, 151, 125);
    arc(width/2, height/2, RAYONMAP*2 + epaisseurLife-0.5, RAYONMAP*2 + epaisseurLife-0.5, HALF_PI, map(playerA.life, 0, 100, HALF_PI, PI+HALF_PI));
    stroke(36, 201, 158);
    arc(width/2, height/2, RAYONMAP*2 + epaisseurLife-0.5, RAYONMAP*2 + epaisseurLife-0.5, map(playerB.life, 0, 100, HALF_PI, -HALF_PI), HALF_PI);
  }

  if (gameState == 10) {
    //on reinitialise toutes les variables
    shoot1debug = false;
    shoot2debug = false;
    debritGenerated = false;

    player1Ready = 0;
    player2Ready = 0;

    keyCode = 2000;

    mesDebrit = new ArrayList<Debrit>();

    playerA.reculx = 0;
    playerA.reculy = 0;
    playerA.angle_degree = 0; // attention, c'est par rapport au cercle trigojoueuretrique
    playerA.life = 100;
    playerA.lastShotMillis = 0;
    playerA.lastTouchedMillis = 0;

    playerB.reculx = 0;
    playerB.reculy = 0;
    playerB.angle_degree = 0; // attention, c'est par rapport au cercle trigojoueuretrique
    playerB.life = 100;
    playerB.lastShotMillis = 0;
    playerB.lastTouchedMillis = 0;

    musiqueIntro.stop();
    musiqueLoop.stop();
    defeated.stop();
    healing_playerA.stop();
    healing_playerB.stop();
    shoot.stop();
    damagePlayerA.stop();
    damagePlayerB.stop();
    decompteGo.stop();

    float playerAx = width/3;
    float playerAy = height/2;
    playerA = new Player(playerAx, playerAy, 1);

    float playerBx = width-width/3;
    float playerBy = height/2;
    playerB = new Player(playerBx, playerBy, 2);

    // on revoie au tuto
    gameState = 2;
  }
}
