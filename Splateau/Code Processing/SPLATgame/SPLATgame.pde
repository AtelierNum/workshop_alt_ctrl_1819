// CECI EST LE CODE DU JEU S.P.L.A.T. DU WORKSHOP JOYPAD DE LA SEMAINE DU 04/03/2019

import processing.serial.*;

Serial arduino1;
Serial arduino2;
Serial arduino3;  
int arduino1_data1, arduino1_data2;
int arduino2_data1, arduino2_data2;
int arduino3_data1, arduino3_data2;

import processing.sound.*;
SoundFile musique;

PImage obstacles, voiture1, voiture2, TerrainLayer0, TerrainLayer3, Explosion, bonusPickup, 
  readyText, round1Text, round2Text, round3Text, player1Win, player2Win, logo, backDrop, 
  roundResults1, roundResults2;
float obstaclesx, obstaclesy, angleCar1, newAngleCar1, angleCar2, newAngleCar2, zonePositionX, 
  zonePositionY, 
  car1MaxSpeed, car2MaxSpeed, tsunamiVal, newTsunamiVal, ready1Float, ready2Float;
int roundNumber, oldTime, newTime, timer, nextRoundTimer, player1Score, player2Score;
boolean car1IsTrunedOn, car2IsTrunedOn, inGame, isInRound, secondsReset, timerOn, drawStats, 
  nextRndT, checkColor, bonusIsOnTerrain, bombBlewUp, tsunamiEvent, ready1, ready2, startGame, 
  displayPlayer1AsRoundWinner, displayPlayer2AsRoundWinner;

float bonusX = 50, bonusY = 50, bonusType, 
  bonusRound1Pos1X, bonusRound1Pos1Y, 
  bonusRound1Pos2X, bonusRound1Pos2Y, 
  bonusRound1Pos3X, bonusRound1Pos3Y, 
  bonusRound2Pos1X, bonusRound2Pos1Y, 
  bonusRound2Pos2X, bonusRound2Pos2Y, 
  bonusRound3Pos1X, bonusRound3Pos1Y, 
  bonusRound3Pos2X, bonusRound3Pos2Y, 
  bonusRound3Pos3X, bonusRound3Pos3Y, 
  paintMultiplier1, paintMultiplier2;

float FillBar1, FillBar2;

float volant1 = 0;
float volant2 = 0;

float start1;
float start2;

float btnTsunami;
float btnCaller;
float btnVent;
float btnPlusObst;

boolean btnTsunamiBool;
boolean btnCallerBool;
boolean btnVentBool;
boolean btnPlusObstBool;

PImage ventImage, invisibleImage, tsunamiImage, tremblementImage;

boolean timerBonusInvisible;
float timeInvisible;
float cooldownInvisible;

Voiture car1, car2;

int Fill1 = 1;
int Fill2 = 1;
int FillTot = 1;

PGraphics pg;

void setup() {
  //size(1024, 1024);
  fullScreen();
  noCursor();
  background(0, 0);

  // On crée les ports arduino, A METTRE EN COMMENTAIRE POUR LANCER LE SCRIPT SANS LES CARTES
  // ARDUINO CONNECTÉES.
  printArray(Serial.list());
  String nom_port_1 = Serial.list()[1];
  String nom_port_2 = Serial.list()[2];
  String nom_port_3 = Serial.list()[3];
  arduino1 = new Serial(this, nom_port_1, 9600);
  arduino2 = new Serial(this, nom_port_2, 9600);
  arduino3 = new Serial(this, nom_port_3, 9600);
  arduino1.bufferUntil('\n'); 
  arduino2.bufferUntil('\n');
  arduino3.bufferUntil('\n');

  // On associe les images à des png dans le dossier.
  obstacles = loadImage("Obstacle0Layer1.png");
  voiture1 = loadImage("voiturebleue.png");
  voiture2 = loadImage("voitureblanche.png");
  readyText = loadImage("ReadyText.png");
  round1Text = loadImage("Round1NumberText.png");
  round2Text = loadImage("Round2NumberText.png");
  round3Text = loadImage("Round3NumberText.png");
  player1Win = loadImage("Player1Win.png");
  player2Win = loadImage("Player2Win.png");
  Explosion = loadImage("Explosion.gif");
  logo = loadImage("logo piskel.png");
  backDrop = loadImage("BackDrop.png");
  bonusPickup = loadImage("bombe.gif");
  ventImage = loadImage("vent.png");
  invisibleImage = loadImage("montagne.png");
  tsunamiImage = loadImage("ras.png");
  tremblementImage = loadImage("tremblement.png");
  roundResults1 = loadImage("RoundResults1.png");
  roundResults2 = loadImage("RoundResults2.png");

  // On défini une valeur qui va être souvent utilisée pour placer des objets.
  obstaclesx = (width - obstacles.width)/2;
  obstaclesy = (height - obstacles.height)/2;

  // On crée les voitures des deux joueurs.
  car1 = new Voiture();

  car1.position.x = obstaclesx + 64;
  car1.position.y = obstaclesy + 512;
  car1.voiture = voiture1;

  car2 = new Voiture();

  car2.position.x = obstaclesx + 964;
  car2.position.y = obstaclesy + 512;
  car2.voiture = voiture2;

  TerrainLayer0 = loadImage("TerrainLayer0.png");
  TerrainLayer3 = loadImage("TerrainLayer3.png");

  drawBackground();

  angleCar1 = 0;
  newAngleCar1 = 0;
  angleCar2 = 180;
  newAngleCar2 = 180;

  car1MaxSpeed = 2;
  car2MaxSpeed = 2;

  car1.deplacer(car1MaxSpeed);
  car1.afficher(newAngleCar1);
  car2.deplacer(car1MaxSpeed);
  car2.afficher(newAngleCar1);

  // On attribue la musique au fichier mp3;
  musique = new SoundFile(this, "MusiqueJeu.mp3");

  inGame = false;

  // Toutes les positions de spawn possibles pour les bonus en fonction des rounds.
  bonusRound1Pos1X = width/2;
  bonusRound1Pos1Y = height/2;
  bonusRound1Pos2X = width/2 + 150;
  bonusRound1Pos2Y = height/2 - 250;
  bonusRound1Pos3X = width/2 - 150; 
  bonusRound1Pos3Y = height/2 + 250;
  bonusRound2Pos1X = width/2 + 300; 
  bonusRound2Pos1Y = height/2 + 300;
  bonusRound2Pos2X = width/2 - 300; 
  bonusRound2Pos2Y = height/2 - 300;
  bonusRound3Pos1X = width/2; 
  bonusRound3Pos1Y = height/2;
  bonusRound3Pos2X = width/2; 
  bonusRound3Pos2Y = height/2 - 400;
  bonusRound3Pos3X = width/2; 
  bonusRound3Pos3Y = height/2 + 400;

  bonusX = bonusRound1Pos1X;
  bonusY = bonusRound1Pos1Y;

  paintMultiplier1 = 1;
  paintMultiplier2 = 1;

  cooldownInvisible = 10000;

  //tsunamiEvent = true;
}

////////////////////////////////////////////////////////////////////////
////////////////////////////BEGIN DRAW//////////////////////////////////
////////////////////////////////////////////////////////////////////////

void draw() {

  // Pour commencer la partie on vérifie que les joueurs ont tous les deux
  // pressé le bouton "ready";
  if (ready1Float > 0.5) {
    ready1 = true;
  }

  if (ready2Float > 0.5) {
    ready2 = true;
  }

  if (ready1 && ready2 && !startGame) {
    startGame = true;

    startNextRound();
  }

  // Pour éviter un bug, on s'assure que la vitesse des voitures est bien de 2 pendant les 
  // rounds.
  if (isInRound) {
    car1MaxSpeed = 2;
    car2MaxSpeed = 2;
  }

  // On crée la trainée de peinture avec des éllipses de tailles différentes à chaques frames
  // sur la position de la voiture du joueur correspondant.
  if (car1IsTrunedOn == true) {
    noStroke();
    fill(#98627E);
    ellipseMode(CENTER);
    ellipse(car1.position.x, car1.position.y, random(50, 80)*paintMultiplier1, random(50, 80)*paintMultiplier1);
  }
  if (car2IsTrunedOn == true) {
    noStroke();
    fill(#B88C3A);
    ellipseMode(CENTER);
    ellipse(car2.position.x, car2.position.y, random(50, 80)*paintMultiplier2, random(50, 80)*paintMultiplier2);
  }

  // La taille de les trainées de peinture des joueurs est ramenée lentement à leurs tailles
  // initiale (pour mettre fin au bonus qui la fait doubler de taille) en baissant les valeurs 
  // des multiplicateurs de celles-ci.
  paintMultiplier1 = lerp(paintMultiplier1, 1, 0.003);
  paintMultiplier2 = lerp(paintMultiplier2, 1, 0.003);

  // Code de l'effet des spectateurs du vent. On donne simplement un nouvel angle au hasard
  // aux voitures.
  if (btnVent > 0.5 && !btnVentBool && isInRound) {
    btnVentBool = true;

    angleCar1 += random(0, 360);
    angleCar2 += random(0, 360);
  }

  // Code de l'effet des spectateurs qui active le tsunami.
  if (btnTsunami > 0.5 && !btnTsunamiBool && isInRound)
  {
    tsunamiEvent = true;

    btnTsunamiBool = true;
  }

  // On dessine une forme bleu (+ on anime sa taille) et si elle recouvre tout le terrain,
  // on la recouvre par le sprite du sol.
  if (tsunamiEvent)
  {
    newTsunamiVal += 10;

    tsunamiVal = lerp(tsunamiVal, newTsunamiVal, 0.05);

    fill(#52A3E5);
    rect(obstaclesx, obstaclesy, 1024, tsunamiVal);

    if (tsunamiVal > 1200) {
      tsunamiEvent = false;
      newTsunamiVal = 0;
      tsunamiVal = 0;

      drawBackground();
    }
  }

  // Code de l'effet des spectateurs, il arrête tout simplement les voitures.
  if (btnCaller > 0.5 && !btnCallerBool && isInRound) {
    btnCallerBool = true;

    car1IsTrunedOn = false;
    car2IsTrunedOn = false;
  }

  // Code de l'effet des spectateurs qui rends les obstacles invisibles.
  if (btnPlusObst > 0.5 && !btnPlusObstBool && isInRound) {
    btnPlusObstBool = true;
    timerBonusInvisible = true;      
    timeInvisible = millis();

    // On load une image de la même forme que les obstacles, mais avec la texture du sol
    // en fonction du round.
    if (roundNumber == 1) {
      obstacles = loadImage("Obstacle1Layer1Invisible.png");
    }
    if (roundNumber == 2) {
      obstacles = loadImage("Obstacle2Layer1Invisible.png");
    }    
    if (roundNumber == 3) {
      obstacles = loadImage("Obstacle3Layer1Invisible.png");
    }
  }
  // On time la fin de l'effet pour reset l'apparence des obstacles.
  if (timerBonusInvisible) {

    if ( millis() - timeInvisible >= cooldownInvisible) {
      // On load l'image des obstacles en fonction du round.
      if (roundNumber == 1) {
        obstacles = loadImage("Obstacle1Layer1.png");
      }
      if (roundNumber == 2) {
        obstacles = loadImage("Obstacle2Layer1.png");
      }    
      if (roundNumber == 3) {
        obstacles = loadImage("Obstacle3Layer1.png");
      }
      timerBonusInvisible = false;
    }
  }

  // si les joueurs sont dans un round, on affiche les obstacles.
  if (isInRound) {
    image(obstacles, obstaclesx, obstaclesy);
  }

  // On démarre les voitures si le joueur a donné les inputs de démarages.
  if (start1 >= 1) {
    car1IsTrunedOn = true;
  }
  if (start2 >= 1) {
    car2IsTrunedOn = true;
  }

  // Si la voiture est en marche, on lui applique sa vitesse et son angle.
  if (car1IsTrunedOn == true) {
    angleCar1 += 5*(volant1/4);
    car1.accelerer();
    car1.changerDirection(angleCar1);
    car1.deplacer(car1MaxSpeed);
  }
  if (car2IsTrunedOn == true) {
    angleCar2 += 5*(volant2/4);
    car2.accelerer();
    car2.changerDirection(angleCar2);
    car2.deplacer(car2MaxSpeed);
  }

  // Si les joueurs, sont dans l'écran titre, on affiche le texte et le logo.
  if (!inGame) {
    drawBackground();
    image(readyText, obstaclesx, obstaclesy);

    image(logo, obstaclesx, obstaclesy);
  }

  // On passe par une valeur intermédiaire pour rendre la rotation des voitures plus smooth.
  newAngleCar1 = lerp(newAngleCar1, angleCar1, 0.2);
  newAngleCar2 = lerp(newAngleCar2, angleCar2, 0.2);   

  // On affiche les voitures.
  car1.afficher(newAngleCar1);
  car2.afficher(newAngleCar2);

  // On affiche le sprite d'un bonus.

  if (bonusIsOnTerrain && isInRound) {
    imageMode(CENTER);
    image(bonusPickup, bonusX, bonusY);
    imageMode(CORNER);
  }

  // On détecte la collision avec un obstacle et resset la position des voitures. 
  if (collision(obstacles, obstaclesx, obstaclesy, voiture1, car1.position.x, car1.position.y)) {
    noStroke();
    fill(#98627E);
    ellipseMode(CENTER);
    ellipse(car1.position.x, car1.position.y, 60, 60);
    /*imageMode(CORNER);
     image(Explosion,car1.position.x,car1.position.y);
     imageMode(CENTER);*/
    car1.position.x = obstaclesx + 64;
    car1.position.y = obstaclesy + 512;
    angleCar1 = 0;
    newAngleCar1 = 0;

    car1IsTrunedOn = false;
    car1.afficher(angleCar1);
  }
  if (collision(obstacles, obstaclesx, obstaclesy, voiture2, car2.position.x, car2.position.y)) {
    noStroke();
    fill(#B88C3A);
    ellipseMode(CENTER);
    ellipse(car2.position.x, car2.position.y, 60, 60);
    /*imageMode(CORNER);
     image(Explosion,car2.position.x,car2.position.y);
     imageMode(CENTER);*/
    car2.position.x = obstaclesx + 964;
    car2.position.y = obstaclesy + 512;   
    angleCar2 = 180;
    newAngleCar2 = 180;

    car2IsTrunedOn = false;
    car2.afficher(angleCar2);
  }  

  // On détecte la collision avec un bonus (voir le code de collision l.xxx) et déclenche ses
  // effets.

  if (collision(bonusPickup, bonusX-32, bonusY-32, voiture1, car1.position.x, car1.position.y)) {
    bonusIsOnTerrain = false;
    if (bonusType > 1 && bombBlewUp) {
      noStroke();
      fill(#98627E);
      ellipseMode(CENTER);
      ellipse(car1.position.x, car1.position.y, 400, 400);
      car1.afficher(newAngleCar1);
      bombBlewUp = false;
    }
    if (bonusType < 1) {
      paintMultiplier1 = 2;
    }
  }
  if (collision(bonusPickup, bonusX-32, bonusY-32, voiture2, car2.position.x, car2.position.y)) {
    bonusIsOnTerrain = false;
    if (bonusType > 1 && bombBlewUp) {
      noStroke();
      fill(#B88C3A);
      ellipseMode(CENTER);
      ellipse(car2.position.x, car2.position.y, 400, 400);
      car2.afficher(newAngleCar2);
      bombBlewUp = false;
    }
    if (bonusType < 1) {
      paintMultiplier2 = 2;
    }
  }

  // On affiche les décors à l'écran (murs et garrages).
  image(TerrainLayer3, obstaclesx, obstaclesy);


  // Le timer qui commence au début d'un round ou entre les rounds. Il s'occupe de déterminer
  // la fin du round, de faire apparaitre de nouveaux bonus pour les joueurs et de passer
  // de l'affichage du gagnant d'un round au round suivant ou à l'écran de fin de partie.
  if (timerOn) {

    // Ici, je détermine si une seconde vient de passer pour ajouter au timer.
    newTime = second();

    if (oldTime != newTime) {
      timer += 1;

      if (nextRndT) {
        nextRoundTimer += 1;
      }

      oldTime = newTime;
    }

    // Toutes les 10 secondes on donne l'opportunité à un nouveau bonus d'apparaitres sur le
    // terrain, on lui indique son type et sa position.
    if (timer == 10 || timer == 20 || timer == 30 || timer == 40 || timer == 50 || timer == 60) {
      if (!bonusIsOnTerrain) {
        bonusIsOnTerrain = true;
        bonusType = random(0, 2);

        if (bonusType > 1) {
          bonusPickup = loadImage("bombe.gif");
          bombBlewUp = true;
        }
        if (bonusType < 1) {
          bonusPickup = loadImage("size_up.gif");
        }

        if (roundNumber == 1) {
          int pos = (int) random(1, 4);
          if (pos == 1) {
            bonusX = bonusRound1Pos1X;
            bonusY = bonusRound1Pos1Y;
          } else if (pos == 2) {
            bonusX = bonusRound1Pos2X;
            bonusY = bonusRound1Pos2Y;
          } else if (pos == 3) {
            bonusX = bonusRound1Pos3X;
            bonusY = bonusRound1Pos3Y;
          }
        } else if (roundNumber == 2) {
          int pos = (int) random(1, 3);
          if (pos == 1) {
            bonusX = bonusRound2Pos1X;
            bonusY = bonusRound2Pos1Y;
          } else if (pos == 2) {
            bonusX = bonusRound2Pos2X;
            bonusY = bonusRound2Pos2Y;
          }
        } else if (roundNumber == 3) {
          int pos = (int) random(1, 4);
          if (pos == 1) {
            bonusX = bonusRound3Pos1X;
            bonusY = bonusRound3Pos1Y;
          } else if (pos == 2) {
            bonusX = bonusRound3Pos2X;
            bonusY = bonusRound3Pos2Y;
          } else if (pos == 3) {
            bonusX = bonusRound3Pos3X;
            bonusY = bonusRound3Pos3Y;
          }
        }
      }
    }

    // Si le round est en cours depuis plus de 82 secondes, il prend fin
    if (timer >= 82) {

      EndRound();
    }

    // Ce timer entre le calcul du gagnant du round et le lancement du prochain round permet 
    // d'afficher le gagnant.
    if (nextRoundTimer >= 5) {
      startNextRound(); 
      nextRoundTimer = 0;
      nextRndT = false;
    }
  }

  // Cette image permet de masquer les débordements de peintures et du tsunami hors de la
  // zone de 1024x1024 pixels.
  image(backDrop, 0, 0);

  // On affice les sprites des actions du public si ceux-ci sont disponibles.
  if (!btnVentBool && isInRound) {
    image(ventImage, obstaclesx, obstaclesy);
  }
  if (!btnPlusObstBool && isInRound) {
    image(invisibleImage, obstaclesx, obstaclesy);
  }
  if (!btnTsunamiBool && isInRound) {
    image(tsunamiImage, obstaclesx, obstaclesy);
  }
  if (!btnCallerBool && isInRound) {
    image(tremblementImage, obstaclesx, obstaclesy);
  }  

  // Si l'un des joueurs a remporté un round, on l'affice à l'écran.
  if (displayPlayer1AsRoundWinner) {
    imageMode(CENTER);
    image(roundResults1, width/2, height/2);
    //displayPlayer1AsRoundWinner = false;
    imageMode(CORNER);
  }
  if (displayPlayer2AsRoundWinner) {
    imageMode(CENTER);
    image(roundResults2, width/2, height/2);
    //displayPlayer2AsRoundWinner = false;
    imageMode(CORNER);
  }
}

////////////////////////////////////////END OF DRAW///////////////////////////////////////////

// Cette fonction appelée à la fin du round contiens le système de détection et d'attribution
// de la victoire d'un round.
void EndRound() {
  bonusIsOnTerrain = false;

  timerOn = false;
  timer = 0;
  isInRound = false;

  car1MaxSpeed = 0;
  car2MaxSpeed = 0;
  car1IsTrunedOn = false;
  car2IsTrunedOn = false;

  // On load les pixels à l'écran et on compte le nombre de pixels de la couleurs des joueurs.

  Fill1 = 1;
  Fill2 = 1;
  FillTot = 1;
  checkColor = true;
  if (checkColor) {
    loadPixels();
    for (int i = 0; i < pixels.length; i+=20) {

      color pixColor;
      pixColor = pixels[i];
      if (pixColor == #98627E) {
        Fill1 ++;
        pixColor = 0;
      } else if (pixColor == #B88C3A) {
        Fill2 ++;
        pixColor = 0;
      }

      println(Fill1 + " " + Fill2);
    }
  }
  checkColor = false;

  // On met fin à la musique pour être sur qu'elle ne joue pas deux fois en même temps.
  musique.stop();

  // On détermine le gagnant du round et on lui attribue un point supplémentaire.
  if (Fill1 > Fill2) {
    player1Score += 1; 

    displayPlayer1AsRoundWinner = true;
  } 
  if (Fill1 < Fill2) {
    player2Score += 1;

    displayPlayer2AsRoundWinner = true;
  } 
  // Funfact : au cas ou les joueurs seraient à égalité (ce qui est hautement improbable), 
  // le joueur 1 remporte quand même le round. La vie est injuste.
  if (Fill1 == Fill2) {
    player1Score += 1;

    displayPlayer1AsRoundWinner = true;
  }

  // On lance le timer pour le lancement du round suivant.
  nextRoundTimer = 0;
  timerOn = true;
  nextRndT = true;
  //startNextRound();
}

// On lance le round suivant ou détérmine le gagnant de la patie.
void startNextRound() {
  car1IsTrunedOn = false;
  car2IsTrunedOn = false;

  displayPlayer1AsRoundWinner = false;
  displayPlayer2AsRoundWinner = false;

  // On vérifie que les deux joueurs ont bien un score inférieur à 2 pour passer au 
  // round suivant.
  if (player1Score < 2 && player2Score < 2) {
    roundNumber += 1;
    inGame = true;
    drawBackground();
    // On change l'image des obstacles et des voitures en fonction du numéro du round.
    if (roundNumber == 1) {
      obstacles = loadImage("Obstacle1Layer1.png");
      image(round1Text, obstaclesx, obstaclesy);
    }
    if (roundNumber == 2) {
      obstacles = loadImage("Obstacle2Layer1.png");

      car1.voiture = loadImage("truckblanc.png");
      car2.voiture = loadImage("truckjaune.png");

      image(round2Text, obstaclesx, obstaclesy);
    }
    if (roundNumber == 3) {
      obstacles = loadImage("Obstacle3Layer1.png");
      image(round3Text, obstaclesx, obstaclesy);

      car1.voiture = loadImage("voituremort.png");
      car2.voiture = loadImage("voiturerouge.png");

      // Si il s'agit du 3e round, on reset les actions du public.      
      btnTsunamiBool = false;
      btnCallerBool = false;
      btnVentBool = false;
      btnPlusObstBool = false;
    }
    // On indique que le round commence et on démare la musique.
    isInRound = true;
    timerOn = true;
    musique.play();
    isInRound = true;
    // Si le score du joueur 1 est égal à deux, il remporte la partie.
  } else if (player1Score == 2) {
    image(player1Win, obstaclesx, obstaclesy);
    car1IsTrunedOn = true;
    car2IsTrunedOn = false;
    car1MaxSpeed = 2;
    car2MaxSpeed = 0;
    obstacles = loadImage("Obstacle0Layer1.png");
    // Si le score du joueur 2 est égal à deux, il remporte la partie.
  } else if (player2Score == 2) {
    image(player2Win, obstaclesx, obstaclesy);
    car2IsTrunedOn = true;
    car1IsTrunedOn = false;
    car1MaxSpeed = 0;
    car2MaxSpeed = 2;
    obstacles = loadImage("Obstacle0Layer1.png");
  }

  // On reset la position, l'angle, la vitesse, etc... des deux joueurs.
  car1.position.x = obstaclesx + 64;
  car1.position.y = obstaclesy + 512;    
  angleCar1 = 0;
  newAngleCar1 = 0;
  car2.position.x = obstaclesx + 964;
  car2.position.y = obstaclesy + 512;   
  angleCar2 = 180;
  newAngleCar2 = 180;
  car1.afficher(angleCar1);
  car2.afficher(angleCar2);
}

void drawBackground() {
  image(TerrainLayer0, obstaclesx, obstaclesy);
}

// Cette partie du code sert à la detection de collision, en utilisant les valeurs alpha
// des png.
final int ALPHALEVEL = 20;

boolean collision(PImage imgA, float aix, float aiy, PImage imgB, float bix, float biy) {
  int topA, botA, leftA, rightA;
  int topB, botB, leftB, rightB;
  int topO, botO, leftO, rightO;
  int ax, ay;
  int bx, by;
  int APx, APy, ASx, ASy;
  int BPx, BPy; //, BSx, BSy;

  topA   = (int) aiy;
  botA   = (int) aiy + imgA.height;
  leftA  = (int) aix;
  rightA = (int) aix + imgA.width;
  topB   = (int) biy - 32;
  botB   = (int) biy - 32 + imgB.height;
  leftB  = (int) bix - 32;
  rightB = (int) bix - 32 + imgB.width;

  if (botA <= topB  || botB <= topA || rightA <= leftB || rightB <= leftA)
    return false;

  leftO = (leftA < leftB) ? leftB : leftA;
  rightO = (rightA > rightB) ? rightB : rightA;
  botO = (botA > botB) ? botB : botA;
  topO = (topA < topB) ? topB : topA;
  APx = leftO-leftA;   
  APy = topO-topA;
  ASx = rightO-leftA;  
  ASy = botO-topA-1;
  BPx = leftO-leftB;   
  BPy = topO-topB;

  int widthO = rightO - leftO;
  boolean foundCollision = false;

  // Images to test
  imgA.loadPixels();
  imgB.loadPixels();

  int surfaceWidthA = imgA.width;
  int surfaceWidthB = imgB.width;

  boolean pixelAtransparent = true;
  boolean pixelBtransparent = true;

  // Get start pixel positions
  int pA = (APy * surfaceWidthA) + APx;
  int pB = (BPy * surfaceWidthB) + BPx;

  ax = APx; 
  ay = APy;
  bx = BPx; 
  by = BPy;
  for (ay = APy; ay < ASy; ay++) {
    bx = BPx;
    for (ax = APx; ax < ASx; ax++) {
      pixelAtransparent = alpha(imgA.pixels[pA]) < ALPHALEVEL;
      pixelBtransparent = alpha(imgB.pixels[pB]) < ALPHALEVEL;

      if (!pixelAtransparent && !pixelBtransparent) {
        foundCollision = true;
        break;
      }
      pA ++;
      pB ++;
      bx++;
    }
    if (foundCollision) break;
    pA = pA + surfaceWidthA - widthO;
    pB = pB + surfaceWidthB - widthO;
    by++;
  }
  return foundCollision;
}

// Les inputs clavier et de debug, ils ne sont pas utilisés durant une partie normale
void keyPressed() {
  if (key == 'q' && car1IsTrunedOn || key == 'Q' && car1IsTrunedOn) {
    angleCar1 -= 5;
  }
  if (key == 'd' && car1IsTrunedOn || key == 'D' && car1IsTrunedOn) {
    angleCar1 += 5;
  }
  if (keyCode == LEFT && car2IsTrunedOn) {
    angleCar2 -= 5;
  }
  if (keyCode == RIGHT && car2IsTrunedOn) {
    angleCar2 += 5;
  }

  if (key == 'z' || key == 'Z') {
    car1IsTrunedOn = true;
  }

  if (key == 'v' || key == 'V') {
    btnVent = 1;
  }

  if (keyCode == UP) {
    car2IsTrunedOn = true;
  }

  if (key == 'n' || key == 'N') {
    startNextRound();
  }

  if (key == 't' || key == 'T') {
    tsunamiEvent = true;
    newTsunamiVal = 0;
    tsunamiVal = 0;
  }
}


// On récupère les inputs depuis les trois cartes arduino une par une
void serialEvent (Serial port) {
  if (port == arduino1) {
    try {
      String inBuffer1 = port.readStringUntil('\n');
      if (inBuffer1 != null) {
        //println(inBuffer1);

        if (inBuffer1.substring(0, 1).equals("{")) {
          JSONObject json = parseJSONObject(inBuffer1);
          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            JSONObject arduino1 = json.getJSONObject("arduino1");
            //println("json ok");
            volant1 = arduino1.getFloat("tourner1");
            start1 = arduino1.getInt("start1");
            ready1Float = arduino1.getInt("ready1");
          }
        }
      }
    }
    catch (Exception e) {
    }
  } else if (port == arduino2) {
    try {
      String inBuffer2 = port.readStringUntil('\n');
      if (inBuffer2 != null) {
        //println(inBuffer2);

        if (inBuffer2.substring(0, 1).equals("{")) {

          JSONObject json = parseJSONObject(inBuffer2);

          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            JSONObject arduino2 = json.getJSONObject("arduino2");
            //println("json ok");
            volant2 = arduino2.getFloat("tourner2");
            start2 = arduino2.getInt("start2");
            ready2Float = arduino2.getInt("ready2");
          }
        } else {
        }
      }
    }
    catch (Exception e) {
    }
  } else if (port == arduino3) {
    try {
      String inBuffer3 = port.readStringUntil('\n');
      if (inBuffer3 != null) {
        //println(inBuffer3);

        JSONObject json = parseJSONObject(inBuffer3);

        if (json == null) {
          println("JSONObject could not be parsed");
        } else {
          //println("json ok");
          JSONObject arduino3 = json.getJSONObject("arduino3");
          btnCaller = arduino3.getInt("boutonSpect1");
          btnTsunami = arduino3.getInt("boutonSpect2");
          btnPlusObst = arduino3.getInt("boutonSpect3");
          btnVent= arduino3.getInt("boutonSpect4");
        }
      }
    } 
    catch (Exception e) {
    }
  }
  println("" + btnCaller + ", " + btnTsunami + ", " + btnPlusObst + ", " + btnVent + "*************************************");
}
