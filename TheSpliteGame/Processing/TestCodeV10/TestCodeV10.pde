//une grande partie des commentaires a été rédigé en anglais car zemin était plus à l'aise en anglais
import fisica.*; //librarie fisica pour gérer la physique des objets et des personnages
import processing.serial.*;  //pour communiquer 
import processing.sound.*;

/* ----- different scene --  0:indication  1:main  2:win   3:lose ----- */
int scene = 0;


/* ----- Code Arduino, raw input from 0 to 1023 ----- */
Serial myPort;  // Create object from Serial class
float signal_potentiometreJ1 = 5, pre_signal_potentiometreJ1, Pression_DroiteJ1 = 0, Pression_GaucheJ1 = 0;
float Pression_DroiteJ2 = 0, Pression_GaucheJ2 = 0;

/* ----- input 0 or 1 ----- */
float jumpJ1;
float jumpJ2;
float lumino1;
float lumino2;

float preSlideValue;

float position_joueur1, pressionDroit;

// ATTENTION à bien utiliser le port adapté


/* ----- Code Fisica ----- */
FWorld world1;
FWorld world2;

FBox player1;
FBox player2;


/* ----- Player input ----- */
// limit of velocity
float maxVelocityX=200;

// input
float valueLeft = 500;
float valueRight = 500;
float valueUp = 400;

//// slide value for movable platform
float slideValue = 5;

// image
PImage couverture;
PImage bg;
PImage win;
PImage gameover;
PImage sprite1;
PImage sprite2;

// sound
SoundFile bgm;
SoundFile lose;
//SoundFile respawn;
SoundFile appear;
SoundFile saut;
SoundFile saut2;

// score 
float score1 =0;
float score2 =0;

// time in second for a round
int time = 120;

// bool to check which player touches which door
boolean p1RightDoorTouch;
boolean p2RightDoorTouch;

// bool to check if the player is suspended
boolean p1InAir;
boolean p2InAir;

// Temps de référence pour la scene 2 ou 3
int tpsRef;


// keycode
boolean[] keys = new boolean[25];

/* ----- movable vertical ----- */
FBox mP1_1;
FBox mP1_2;
FBox mP2_1;
FBox mP2_2;
FBox mP3_1;
FBox mP3_2;
FBox mP4_1;
FBox mP4_2;
FBox mP5_1;
FBox mP5_2;
FBox mP6_1;
FBox mP6_2;
FBox mP10_1;
FBox mP10_2;
FBox mP11_1;
FBox mP11_2;

/* ----- movable horizontal ----- */
FBox mP7_1;
FBox mP7_2;
FBox mP8_1;
FBox mP8_2;
FBox mP9_1;
FBox mP9_2;

// trigger
FBox trigger1;
FBox trigger2;

// door
FBox doorLeft1;
FBox doorLeft2;
FBox doorRight1;
FBox doorRight2;

void setup() {

  //size(1440, 900);
  //size(1920, 1080);
  fullScreen();
  smooth();
  noCursor();
  
  /* ----- Image Init ----- */
  bg = loadImage("bg_1920.jpg");
  couverture = loadImage("couverture.jpg");
  win = loadImage("win.jpg");
  gameover = loadImage("gameover.jpg");
  PImage sprite1 = loadImage("joueur1.png");
  PImage sprite2 = loadImage("joueur2.png");
  sprite1.resize(45, 45);
  sprite2.resize(45, 45);

  bgm = new SoundFile(this, "bgm.wav");
  bgm.loop();
  appear = new SoundFile(this, "appear.wav");
  lose = new SoundFile(this, "lose.wav");
  //respawn = new SoundFile(this, "respawn.wav");
  saut = new SoundFile(this, "saut.wav");
  saut2 = new SoundFile(this, "saut2.wav");


  //printArray(Serial.list());
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); 



  /* ----- Fisica Init ----- */
  Fisica.init(this);
  // the area of this world: float topLeftX,float topLeftY,float bottomRightX,float bottomRightY
  world1 = new FWorld();
  //world1.setEdges(0, 0.51*height, width, height, color(200, 200, 200));
  world1.setGravity(0, 1000);
  world2 = new FWorld();
  //world2.setEdges(0, 0, width, 0.49*height, color(200, 0, 200));
  world2.setGravity(0, -1000);


  // platform below
  //colonne 1
  FBox p0 = createPlatformSolid(0.00*width, 0.95*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 2
  FBox p1 = createPlatformSolid(0.05*width, 0.90*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 4
  FBox p3 = createPlatformSolid(0.15*width, 0.90*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 5
  FBox p5 = createPlatformSolid(0.20*width, 0.85*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  FBox p6 = createPlatformSolid(0.20*width, 0.95*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 7
  FBox p9 = createPlatformSolid(0.30*width, 0.80*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 8
  FBox p11 = createPlatformSolid(0.35*width, 0.90*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 9
  FBox p14 = createPlatformSolid(0.40*width, 0.95*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 10
  FBox p31= createPlatformSolid(0.45*width, 0.75*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 11
  FBox p19 = createPlatformSolid(0.5*width, 0.85*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 13
  FBox p24 = createPlatformSolid(0.6*width, 0.95*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 15
  FBox p25 = createPlatformSolid(0.7*width, 0.85*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 16
  FBox p29=  createPlatformSolid(0.75*width, 0.95*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 18
  FBox p32 = createPlatformSolid(0.85*width, 0.90*height, 0.05*width, 0.05*height, world1, 255, 195, 14);
  //colonne 19
  FBox p34 = createPlatformSolid(0.95*width, 0.85*height, 0.05*width, 0.05*height, world1, 255, 195, 14);

  // platform above
  //colonne 1
  FBox p35 = createPlatformSolid(0.00*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 2
  FBox p36 = createPlatformSolid(0.05*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p37 = createPlatformSolid(0.05*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 4
  FBox p38 = createPlatformSolid(0.15*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p39= createPlatformSolid(0.15*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 5
  FBox p40 = createPlatformSolid(0.20*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p41 = createPlatformSolid(0.20*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 7
  FBox p42 = createPlatformSolid(0.30*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p43 = createPlatformSolid(0.30*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p44 = createPlatformSolid(0.30*width, 0.15*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p45 = createPlatformSolid(0.30*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 8
  FBox p46 = createPlatformSolid(0.35*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p47 = createPlatformSolid(0.35*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 9
  FBox p48 = createPlatformSolid(0.40*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p49 = createPlatformSolid(0.40*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 10
  FBox p50 = createPlatformSolid(0.45*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p51= createPlatformSolid(0.45*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p52= createPlatformSolid(0.45*width, 0.15*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p53 = createPlatformSolid(0.45*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p54= createPlatformSolid(0.45*width, 0.20*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 11
  FBox p55 = createPlatformSolid(0.5*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p56= createPlatformSolid(0.5*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p57 = createPlatformSolid(0.5*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 13
  FBox p58 = createPlatformSolid(0.6*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p59 = createPlatformSolid(0.6*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 15
  FBox p60 = createPlatformSolid(0.7*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p61 = createPlatformSolid(0.7*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p62 = createPlatformSolid(0.7*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 16
  FBox p63 = createPlatformSolid(0.75*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p64= createPlatformSolid(0.75*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p65 = createPlatformSolid(0.75*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 18
  FBox p66 = createPlatformSolid(0.85*width, 0.05*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  FBox p67 = createPlatformSolid(0.85*width, 0.00*height, 0.05*width, 0.05*height, world2, 255, 195, 14);
  //colonne 19
  FBox p68 = createPlatformSolid(0.95*width, 0.10*height, 0.05*width, 0.05*height, world2, 255, 195, 14);




  // movable platform, the second number represent the world it is in
  mP1_1 =createPlatformSolid(0.1*width, 0.2*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP1_2 =createPlatformSolid(0.1*width, 0.2*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP2_1 =createPlatformSolid(0.25*width, 0.4*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP2_2 =createPlatformSolid(0.25*width, 0.4*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP3_1 =createPlatformSolid(0.55*width, 0.2*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP3_2 =createPlatformSolid(0.55*width, 0.2*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP4_1 =createPlatformSolid(0.65*width, 0.4*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP4_2 =createPlatformSolid(0.65*width, 0.4*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP5_1 =createPlatformSolid(0.80*width, 0.2*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP5_2 =createPlatformSolid(0.80*width, 0.2*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP6_1 =createPlatformSolid(0.90*width, 0.4*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP6_2 =createPlatformSolid(0.90*width, 0.4*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP10_1 =createPlatformSolid(0.35*width, 0.5*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP10_2 =createPlatformSolid(0.35*width, 0.5*height, 0.05*width, 0.02*height, world2, 80, 134, 224);
  mP11_1 =createPlatformSolid(0.05*width, 0.6*height, 0.05*width, 0.02*height, world1, 80, 134, 224);
  mP11_2 =createPlatformSolid(0.05*width, 0.6*height, 0.05*width, 0.02*height, world2, 80, 134, 224);

  mP7_1 =createPlatformSolid(0.15*width, 0.25*height, 0.1*width, 0.02*height, world1, 38, 151, 212);
  mP7_2 =createPlatformSolid(0.15*width, 0.25*height, 0.1*width, 0.02*height, world2, 38, 151, 212);
  mP8_1 =createPlatformSolid(0.35*width, 0.90*height, 0.15*width, 0.02*height, world1, 38, 151, 212);
  mP8_2 =createPlatformSolid(0.35*width, 0.90*height, 0.15*width, 0.02*height, world2, 38, 151, 212);
  mP9_1 =createPlatformSolid(0.75*width, 0.25*height, 0.1*width, 0.02*height, world1, 38, 151, 212);
  mP9_2 =createPlatformSolid(0.75*width, 0.25*height, 0.1*width, 0.02*height, world2, 38, 151, 212);


  // trigger
  //trigger1 = createPlatform(0.2*width, 0.9*height, 0.1*width, 0.05*height, world1, 0, 122, 255);
  //trigger2 = createPlatform(0.1*width, 0.1*height, 0.1*width, 0.05*height, world2, 0, 122, 255);

  // player below
  player1 = createPlayer(0.03*width, 0.70*height, world1, sprite1);
  // player above
  player2 = createPlayer(30, 250, world2, sprite2);

  // door
  doorLeft1 =createPlatform(0*width, 0.10*height, 0.02*width, 0.1*height, world1, 239, 81, 79);
  doorLeft2 =createPlatform(0*width, 0.90*height, 0.02*width, 0.1*height, world2, 239, 81, 79);
  doorRight1 =createPlatform(1*width, 0.25*height, 0.02*width, 0.1*height, world1, 239, 81, 79);
  doorRight2 =createPlatform(1*width, 0.75*height, 0.02*width, 0.1*height, world2, 239, 81, 79);
} // fin du setup

void draw() {

  // indication page
  if (scene == 0) {
    background(couverture);

    //fill(255);
    //textSize(16);
    //String s = "Il était une fois, Malika, Dounyo et Simeon, trois amis qui aimaient s’amuser sur des jeux d’arcade. Au fur et a mesure qu’ils jouaient ensemble, une rivalité naquit. Pour les punir le jeu les engloutis et les plongea dans un univers d’aliens. Pour les libérer ils sont condamnés à collaborer ensemble pour sortir du jeu. Venez prendre place pour incarner c’est 3 personnages : Malika, Dounyo et Simeon , Malika le petit alien vert se retrouve coincé la tête en bas. Dounyo lui contrôle seulement les plateformes amovibles. Et Simeon incarne le petit alien violet.   ";
    //text(s, 0.05*width, 0.1*height, 0.9*width, 0.3*height);
    //String u = "Pour libérer les joueurs vous devez aider les deux aliens à atteindre le score de 2 points chacun pendant 180s. Pour gagner un point les joueurs doivent traverser respectivement leur partie de l’écran et venir toucher les murs rouges. À chaque fois qu’un mur est touché, il disparaît pour apparaître de nouveau de l’autre côté de l’écran.";
    //text(u, 0.05*width, 0.35*height, 0.9*width, 0.3*height);
    //textSize(20);

    //String v = "Pour se déplacer vers la droite : utilisez le capteur de pression vers la droite. Pour se déplacer vers la gauche : utilisez le capteur de pression vers la gauche.";
    //text(v, 0.05*width, 0.50*height, 0.9*width, 0.3*height);
    //String w = "Pour sauter : cachez la photo-résistance en recouvrant le boîtier situer près de votre pied.";
    //text(w, 0.05*width, 0.60*height, 0.9*width, 0.3*height);
    //String x = "Pour déplacer les plateformes : tournez le potentiomètre.";
    //text(x, 0.05*width, 0.65*height, 0.9*width, 0.3*height);
  }


  // main game
  if (scene == 1) {

    background(bg);




    /* ----- Code Fisica ----- */
    world1.draw();
    world1.step();
    world2.draw();
    world2.step();


    /* ----- Control key player 1 ----- */
    if (abs(Pression_GaucheJ1/100)>5)
    {
      if (abs(player1.getVelocityX()) < maxVelocityX) {
        player1.addForce(-Pression_GaucheJ1, 0);
      }
    };
    if (abs(Pression_DroiteJ1/100)>5)
    {
      if (abs(player1.getVelocityX()) < maxVelocityX) {
        player1.addForce(Pression_DroiteJ1, 0);
      }
    };
    if (lumino1 >= 600 && !p1InAir) //W
    {
      player1.setVelocity(0, -valueUp);
      p1InAir = true;
      saut.play();
    };


    /* ----- Control key player 2 ----- */
    if (abs(Pression_GaucheJ2/100)>5)
    {
      if (abs(player2.getVelocityX()) < maxVelocityX) {
        player2.addForce(-Pression_GaucheJ2, 0);
      }
    };
    if (abs(Pression_DroiteJ2/100)>5)
    {
      if (abs(player2.getVelocityX()) < maxVelocityX) {
        player2.addForce(Pression_DroiteJ2, 0);
      }
    };

    if (lumino2 >= 600 && !p2InAir) //jump
    {
      player2.setVelocity(0, valueUp);
      p2InAir = true;
      saut2.play();
    };


    /* ----- End of control key ----- */

    /* ----- Test Key ----- */
    if (keys[0]) //A
    {
      if (abs(player1.getVelocityX()) < maxVelocityX) {
        player1.addForce(-valueLeft, 0);
      }
    };
    if (keys[3]) //D
    {
      if (abs(player1.getVelocityX()) < maxVelocityX) {
        player1.addForce(valueRight, 0);
      }
    };
    if (keys[22] && !p1InAir) //W
    {
      player1.setVelocity(0, -valueUp);
      p1InAir = true;
    };

    // control player2 keycode
    if (keys[9]) //J
    {
      if (abs(player2.getVelocityX()) < maxVelocityX) {
        player2.addForce(-valueLeft, 0);
      }
    };
    if (keys[11]) //L
    {
      if (abs(player2.getVelocityX()) < maxVelocityX) {
        player2.addForce(valueRight, 0);
      }
    };
    if (keys[8] && !p2InAir) //I
    {
      player2.setVelocity(0, valueUp);
      p2InAir = true;
      saut2.play();
    };


    /* ----- End Test Key ----- */




    /* ----- function to check each frame ----- */
    movePlatform();
    changeDoor();
    showScore();
    showTime();
    detectBorder();

    /* ----- win or lose scene ----- */


    /* ----- end of draw function ----- */
    tpsRef = millis();
  } // fin de la  scene 1

  // win scene
  if (scene == 2)
  {
    background(win);
  }

  // lose scene
  if (scene == 3) {
    background(gameover);
  }
  updateScene();
  pre_signal_potentiometreJ1 = signal_potentiometreJ1;
} // fin du draw()

// movable platform function
void movePlatform() {
  float y1 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-50);
  float y2 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-150);
  float y3 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-50);
  float y4 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-450);
  float y5 = map(pre_signal_potentiometreJ1, 0, 1023, 0, height-50);
  float y6 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-50);
  float y10 = map(pre_signal_potentiometreJ1, 0, 1023, 50, height-150);
  float y11 = map(pre_signal_potentiometreJ1, 0, 1023, 150, height-150);

  float x7 = map(pre_signal_potentiometreJ1, 0, 1023, 0, width-1050);
  float x8 = map(pre_signal_potentiometreJ1, 0, 1023, 100, width-550);
  float x9 = map(pre_signal_potentiometreJ1, 0, 1023, 250, width-250);

  if (false)
  {
    return;
  } else
  {
    mP1_1.setPosition(mP1_1.getX(), y1);
    mP1_2.setPosition(mP1_2.getX(), y1);
    mP2_1.setPosition(mP2_1.getX(), y2);
    mP2_2.setPosition(mP2_2.getX(), y2);
    mP3_1.setPosition(mP3_1.getX(), y3);
    mP3_2.setPosition(mP3_2.getX(), y3);
    mP4_1.setPosition(mP4_1.getX(), y4);
    mP4_2.setPosition(mP4_2.getX(), y4);
    mP5_1.setPosition(mP5_1.getX(), y5);
    mP5_2.setPosition(mP5_2.getX(), y5);
    mP6_1.setPosition(mP6_1.getX(), y6);
    mP6_2.setPosition(mP6_2.getX(), y6);
    mP10_1.setPosition(mP4_1.getX(), y10);
    mP10_2.setPosition(mP4_2.getX(), y10);
    mP11_1.setPosition(mP5_1.getX(), y11);
    mP11_2.setPosition(mP5_2.getX(), y11);


    mP7_1.setPosition(x7, mP7_1.getY());
    mP7_2.setPosition(x7, mP7_2.getY());
    mP8_1.setPosition(x8, mP8_1.getY());
    mP8_2.setPosition(x8, mP8_2.getY());
    mP9_1.setPosition(x9, mP9_1.getY());
    mP9_2.setPosition(x9, mP9_2.getY());
  }
}


void keyPressed() { 
  k(key, true);
}
void keyReleased() { 
  k(key, false);
}
void k(int e, boolean y) {
  int t = e - 'a';
  if (t>=0&&t<25) {
    keys[t]= y;
  }
}

// all the functions to create a platform
FBox createPlatform(float x, float y, float w, float h, FWorld world, int r, int g, int b)
{
  FBox p = new FBox(w, h);
  p.setPosition(x, y);
  p.setStatic(true);
  p.setFill(r, g, b);
  p.setRestitution(0);
  world.add(p);

  return p;
}

// all the functions to create a platform
FBox createPlatformSolid(float x, float y, float w, float h, FWorld world, int r, int g, int b)
{
  FBox p = new FBox(w, h);
  p.setPosition(x+0.5*w, y+0.5*h);
  p.setStatic(true);
  p.setFill(r, g, b);
  p.setFriction(1);
  p.setRestitution(0);
  world.add(p);

  return p;
}

// all the functions to create a player
FBox createPlayer(float x, float y, FWorld world, PImage img)
{
  FBox player = new FBox(20, 20);
  player.setPosition( x, y);
  player.setVelocity(0, 200);
  player.setRestitution(0);
  player.setNoStroke();
  player.attachImage(img);
  player.setFill(200, 30, 90);
  player.setFriction(0.05);
  world.add(player);
  return player;
}

// when player touches door, it will disappear and other will show
void changeDoor()
{
  if (p1RightDoorTouch)
  {
    doorRight1.setPosition(1.2*width, 0.85*height);
    doorLeft1.setPosition(0*width, 0.85*height);
  } else if (!p1RightDoorTouch)
  {
    doorRight1.setPosition(1*width, 0.85*height);
    doorLeft1.setPosition(-0.1*width, 0.85*height);
  }

  if (p2RightDoorTouch)
  {
    doorRight2.setPosition(1.2*width, 0.85*height);
    doorLeft2.setPosition(0*width, 0.10*height);
  } else if (!p2RightDoorTouch) {
    doorRight2.setPosition(1*width, 0.25*height);
    doorLeft2.setPosition(-0.1*width, 0.10*height);
  }
}

void showScore()
{
  fill(255);
  textSize(32);
  text("Player 1 : " + score1, 0.20*width, 0.55*height); 
  fill(255);
  textSize(32);
  text("Player 2 : " + score2, 0.60*width, 0.55*height);


  //push();
  //fill(0, 102, 153);
  //translate(0.45*width, 0.44*height);
  //rotate(PI);
  //textSize(16);
  //text("Player 2 : " + score2, 0,0);

  //pop();
}

void showTime()
{
  int m = millis();
  int seconds = m/1000;
  float progress = map(seconds, 0, time, 0, width);
  fill(255, 255, 255);
  rect(0, 0.5*height, progress, 0.01*height);
  if (progress > width && scene == 1)
  {
    if (score1>=2 && score2>=2)
    {
      scene = 2;
      print(scene);
    } else
    {
      scene = 3;
      print(scene);
    }
  }
}

void updateScene()
{
  if (scene ==0)
  {
    if (abs(Pression_GaucheJ2/100)>5 ||abs(Pression_DroiteJ2/100)>5||abs(Pression_GaucheJ1/100)>5 ||abs(Pression_DroiteJ1/100)>5 ||keys[6])
    {
      score1 = 0;
      score2 = 0;
      scene =1;
    }
  }
  if (scene == 2 || scene == 3) {
    //int tpsRef = millis();
    //int seconds = m/1000;
    
    if (millis() - tpsRef > 5000) {
     score1 = 0;
     score2 = 0;
     scene = 0;
     println("hello");
     }
     
  }
}

// when player disappear, reshow him
void detectBorder()
{
  if (player2.getY()<0|| player2.getX()<-0.05*width||player2.getX()>1.05*width)
  {
    if (p2RightDoorTouch)
    {
      player2.setPosition(0.97*width, 0.20*height);
    } else
    {
      player2.setPosition(0.03*width, 0.10*height);
    }
  }
  if (player1.getY()>height || player1.getX()<-0.05*width||player1.getX()>1.05*width)
  {

    if (p1RightDoorTouch)
    {
      player1.setPosition(0.97*width, 0.80*height);
    } else
    {
      player1.setPosition(0.03*width, 0.90*height);
    }
  }
}


// contact detecting, ensure player can jump once
void contactStarted(FContact contact) {
  if (contact.getBody1()==player1 || contact.getBody2()== player1)
  {
    p1InAir = false;
  }
  if (contact.getBody1()==player2 || contact.getBody2()== player2)
  {
    p2InAir = false;
  }


  //// detect whether is on trigger
  //if (contact.getBody1()==trigger1 || contact.getBody2()== trigger1)
  //{
  //  onTrigger1 = true;
  //  fill(0, 170, 0);
  //  ellipse(contact.getX(), contact.getY(), 20, 20);
  //}
  //if (contact.getBody1()==trigger2 || contact.getBody2()== trigger2)
  //{
  //  onTrigger2 = true;
  //}

  // check the door touch and score
  if (contact.getBody1()==doorRight1 || contact.getBody2()== doorRight1)
  {
    p1RightDoorTouch = true;
    score1++;
  }
  if (contact.getBody1()==doorRight2 || contact.getBody2()== doorRight2)
  {
    p2RightDoorTouch = true;
    score2++;
  }
  if (contact.getBody1()==doorLeft1 || contact.getBody2()== doorLeft1)
  {
    p1RightDoorTouch = false;
    score1++;
  }
  if (contact.getBody1()==doorLeft2 || contact.getBody2()== doorLeft2)
  {
    p2RightDoorTouch = false;
    score2++;
  }
}

// when player leaves the trigger
void contactEnded(FContact contact) {
}


/* ----- Code Arduino ----- */
void serialEvent (Serial myPort) {

  while (myPort.available() > 0) {
    String inBuffer = myPort.readStringUntil('\n');

    if (inBuffer != null) { 
      // texte = inBuffer;
      String[] list = split(inBuffer, ',');

      /* récupération des données envoyées par Arduino dans un tableau */
      if (list.length == 7) {
        Pression_DroiteJ2 = float(list[0]);
        Pression_GaucheJ2 = float(list[1]);
        signal_potentiometreJ1 = float(list[2]);
        Pression_DroiteJ1 = float(list[3]);
        Pression_GaucheJ1 = float(list[4]);
        lumino1 = float(list[5]);
        lumino2 = float(list[6]);
      }
    }
  }
}
