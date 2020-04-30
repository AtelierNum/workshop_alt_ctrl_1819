import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import processing.serial.*;
import processing.sound.*;
SoundFile file;



Serial myPort;   // Create object from Serial class

PImage startscreen; //Création du class image
CountdownTimer timer; //Initialisation de la library CountdownTimer
int stage; //Création de la variable stage


PFont font;
// The font must be located in the sketch's 
// "data" directory to load successfully



//JOUEUR 1
//Joueur 1 Bouton
int val1;        // Data received from the serial port
int pot1;        // Variable pour capteur son joueur 1
int etatButtonRP1; // Variable pour bouton droit joueur 1
int etatButtonLP1; // Variable pour bouton gauche joueur 1
int etatButtonUP1; // Variable pour bouton haut joueur 1
int etatButtonDP1; // Variable pour bouton bas joueur 1

//Joueur 1 balle
float ballX; // Variable pour coordonnée X joueur 1
float ballY; // Variable pour coordonnée Y joueur 1
float radius; // Variable pour taille joueur 1 & 2
float ballSpeed1; // Variable pour vitesse joueur 1

int scoreFinalP1 = 0; // Score que l'on va retrouver à la fin du jeu 

//JOUEUR 2
//joueur 2 Bouton
int val2;        // Data received from the serial port
int pot2;        // Variable pour capteur son joueur 2
int ButtonRP2;  // Variable pour bouton droit joueur 2
int ButtonLP2;  // Variable pour bouton gauche joueur 2
int ButtonUP2;  // Variable pour bouton haut joueur 2
int ButtonDP2;  // Variable pour bouton bas joueur 2

//Joueur 2 Balle
float ballSpeed2; // Variable pour coordonnée X joueur 2
float ball2X; // Variable pour coordonnée Y joueur 2
float ball2Y; // Variable pour vitesse joueur 2

int scoreFinalP2 =0; //Score que l'on va retrouver à la fin du jeu

int tickCounter = 0 ; // for countdowntimer

color backgroundColor = color(154, 229, 229); //donner une valeur couleur à la variable backgroundColor

//OBSTACLE1
float Obs1X; //Coordonné X obstacle 1
float Obs1Y; //Coordonné Y obstacle 1
float distanceJoueur1Obs1; //distance entre joueur 1 obstacle 1
float distanceJoueur2Obs1;  //distance entre joueur 2 obstacle 1

//OBSTACLE1
float Obs2X; //Coordonné X obstacle 1
float Obs2Y; //Coordonné Y obstacle 2
float distanceJoueur1Obs2; //distance entre joueur 1 obstacle 2
float distanceJoueur2Obs2; //distance entre joueur 2 obstacle 2


int radius2; //Radius des obstacles
boolean hit=false; //Boolean vérification toucher obstacle.

void setup() 
{

  //fullScreen();
  size(1920, 1080); //Définit la taille du sketch
  // ATTENTION à bien utiliser le port adapté
  printArray(Serial.list());
  String portName = Serial.list()[1]; //Lire sur le port de la carte Arduino
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); 
  noStroke(); //pas de contour dans le sketch
  smooth(6);
  frameRate(30);
  file = new SoundFile(this, "data/musique2.mp3"); //Récupération du fichier mp3
  file.play(1); //Lecture du fichier mp3
  stage = 1; //Initialisation - Première étapes du programe.
  startscreen = loadImage("menu.jpg"); //Récupération fichier jpg de l'écran d'accueil
  font = loadFont("SaniretroRegular-48.vlw"); // Récupération de la police d'écriture
  textFont(font);

  //Initialisation des coordonnés de départ du joueur 1
  ballX = 480; 
  ballY = 540;    
  
  //Initialisation des coordonnésde départ du joueur 2
  ball2X = 1440;
  ball2Y = 540;  

  //donner une valeur au radius des joueurs pour leur taille
  radius = 25;

  //Initialisation des coordonnésde départ de l'obstacle 1
  Obs1X = 960;
  Obs1Y = 270;
  
  //Initialisation des coordonnésde départ de l'obstacle 2
  Obs2X = 960;
  Obs2Y = 810;
  
  //donner une valeur au radius des obstacles
  radius2 = 100;
}

void draw() {
  //Stage 1 - Introduction
  //Si l'on démarre la première étape
  if (stage==1) {
    scoreFinalP1 = 0;
    scoreFinalP2 = 0;
    background(startscreen); //Affichage de l'écran d'accueil
    /*
    Si on appuie sur une touche du clavier ou sur le bouton du joueur 1 droit
    Alors on passe à l'étape 2 et on lance le timer de 3 secondes
    */
    if ((keyPressed==true)||(etatButtonRP1 == 1)) { 
      stage = 2;
      timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
    }
  }

  //Stage 2 - Décompte première manche
    /*
    Si on se trouve dans l'étape numéro 2
    Alors on affiche BackgroundColor et on écrit "Joueur 1 - Prédateur" au centre de l'écran.
    */
  if (stage==2) {
    background(backgroundColor);
    textAlign(CENTER);
    textSize(90);
    text("Joueur 1 - Prédateur", 960, 540);  
  }
  
    //Stage 3 - Premier Round
    /*
    Si on se trouve dans l'étape numéro 3
    Alors on affiche on passe le background en blanc, puis on dessine chaque joueur et obstacle
    */

  if (stage ==3 ) {
    background(255);             

    // dessiner joueur 1
    fill(255, 156, 144); //couleur
    ellipse(ballX, ballY, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    // dessiner joueur 2
    fill(154, 229, 229); //couleur
    ellipse(ball2X, ball2Y, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle1
    fill(0); //couleur
    ellipse(Obs1X, Obs1Y, radius2, radius2); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle2
    fill(0); //couleur
    ellipse(Obs2X, Obs2Y, radius2, radius2); //coordonnées et rayon pour la taille et l'emplacement
    
    
 
    //OBSTACLE 1
    /*
    Si le joueur 1 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur1Obs1 = dist(ballX, ballY, Obs1X, Obs1Y); //On calcul la différence entre le centre des deux ellipses 

    if (distanceJoueur1Obs1<= 65 && hit == false){
    //println("yes");
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs1<= 65 && hit == true){
    println("non");
    }
    /*
    Si le joueur 2 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */

    distanceJoueur2Obs1 = dist(ball2X, ball2Y, Obs1X, Obs1Y); //Calcul diférence position entre joueur 2 et obstacle 1

    if (distanceJoueur2Obs1<= 65 && hit == false){
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs1<= 65 && hit == true){
    println("non");
    }
    
        /*
    Si le joueur 1 est proche de l'obstacle 2 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    
    //OBSTACLE 2
    
    distanceJoueur1Obs2 = dist(ballX, ballY, Obs2X, Obs2Y); //Calcul diférence position entre joueur 1 et obstacle 2

    if (distanceJoueur1Obs2<= 65 && hit == false){
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs2<= 65 && hit == true){
    println("non");
    }
    
        /*
    Si le joueur 1 est proche de l'obstacle 2 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    
    distanceJoueur2Obs2 = dist(ball2X, ball2Y, Obs2X, Obs2Y); //Calcul diférence position entre joueur 1 et obstacle 2

    if (distanceJoueur2Obs2<= 65 && hit == false){
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs2<= 65 && hit == true){
    }
    
    //Etat des joueurs proie et prédateur
    float distanceJoueur =dist(ballX, ballY, ball2X, ball2Y); //Calcul diférence position entre joueur 1 et joueur 2
    /*
    Si la différence de distance entre les deux joueurs est inférieur à leurs rayons 
    alors le joueur 1 gagne un point, on lance le timer de 3 secondes, on réinitialise la position des joueurs ,
    on remet le tickCounter à 0 et on passe à l'étape 4.
    */
    if (distanceJoueur <= radius) {
      scoreFinalP1=scoreFinalP1+1;
      timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
      reInitPositions();
      reInitHit();
      tickCounter=0;
      stage = 4;
    }
  }
  
  /*
  Si stage est égale à l'étape 4, alors on met la class backgroundColor pour la couleur du backgorund , 
  et on écrit en blanc aligner au centre en police 90, que le Joueur 2 devient prédateur et on affiche les scores du premier round.
  */ 
  
  if (stage==4) {
      background(backgroundColor);
      textAlign(CENTER);
      textSize(90);
      text("Joueur 2 - Prédateur", 960, 270);
      text("Joueur 1 : " + scoreFinalP1, 480,540);
      text("Joueur 2 : " + scoreFinalP2, 1440,540);
      fill(255);
  }
  
  if (stage ==5 ) {
    background(255); //Remise à couleur blanc du background           
    //fill(0);
    // dessiner joueur 1
    fill(255, 156, 144); //Couleur
    ellipse(ballX, ballY, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    // dessiner joueur 2
    fill(154, 229, 229); //Couleur
    ellipse(ball2X, ball2Y, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle1
    fill(0); //Couleur
    ellipse(Obs1X, Obs1Y, radius2, radius2); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle2
    fill(0); //Couleur
    ellipse(Obs2X, Obs2Y, radius2, radius2);//coordonnées et rayon pour la taille et l'emplacement
    
    //OBSTACLE 1
    /*
    Si le joueur 1 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur1Obs1 = dist(ballX, ballY, Obs1X, Obs1Y);

    if (distanceJoueur1Obs1<= 65 && hit == false){
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs1<= 65 && hit == true){
    }
    /*
    Si le joueur 2 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur2Obs1 = dist(ball2X, ball2Y, Obs1X, Obs1Y);

    if (distanceJoueur2Obs1<= 65 && hit == false){
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs1<= 65 && hit == true){
    }
    
    //OBSTACLE2
    /*
    Si le joueur 1 est proche de l'obstacle 2 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur1Obs2 = dist(ballX, ballY, Obs2X, Obs2Y);

    if (distanceJoueur1Obs2<= 65 && hit == false){
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs2<= 65 && hit == true){
    }
    
    distanceJoueur2Obs2 = dist(ball2X, ball2Y, Obs2X, Obs2Y);

    if (distanceJoueur2Obs2<= 65 && hit == false){
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs2<= 65 && hit == true){
    }

    //Etat des joueurs proie et prédateur
    float distanceJoueur =dist(ballX, ballY, ball2X, ball2Y);
    /*
    Si la différence de distance entre les deux joueurs est inférieur à leurs rayons 
    alors le joueur 1 gagne un point, on lance le timer de 3 secondes, on réinitialise la position des joueurs ,
    on remet le tickCounter à 0 et on passe à l'étape 4.
    */
    if (distanceJoueur <= radius) {
      scoreFinalP2=scoreFinalP2+1;
      background(backgroundColor);
      timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
      reInitPositions();
      reInitHit();
      stage = 6;

    }
  }
  /*
  Si stage est égale à l'étape 6, alors on met la class backgroundColor pour la couleur du backgorund , 
  et on écrit en blanc aligner au centre en police 90, que le Joueur 1 devient prédateur et on affiche les scores du premier round.
  */ 
    if (stage==6) {
    background(backgroundColor); //Remttre le backgroundColor
    textAlign(CENTER); //Aligner le text au centre
    textSize(90); //Taille de la police a 90
    text("Joueur 1 - Prédateur", 960, 270); //écrire joueur 1 devient prédateur
    text("Joueur 1 : " + scoreFinalP1, 480,540); //Inscription des scores
    text("Joueur 2 : " + scoreFinalP2, 1440,540); //Inscription des scores
    fill(255);
  }
  
  if (stage ==7 ) {
    background(255);  //Background blanc           
    //fill(0);
    // dessiner joueur 1
    fill(255, 156, 144); //Couleur
    ellipse(ballX, ballY, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    // dessiner joueur 2
    fill(154, 229, 229); //Couleur
    ellipse(ball2X, ball2Y, radius, radius); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle1
    fill(0); //Couleur
    ellipse(Obs1X, Obs1Y, radius2, radius2); //coordonnées et rayon pour la taille et l'emplacement
    //dessiner obstacle2
    fill(0); //Couleur
    ellipse(Obs2X, Obs2Y, radius2, radius2); //coordonnées et rayon pour la taille et l'emplacement
    
    
    //OBSTACLE1
    /*
    Si le joueur 1 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur1Obs1 = dist(ballX, ballY, Obs1X, Obs1Y);

    if (distanceJoueur1Obs1<= 65 && hit == false){
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs1<= 65 && hit == true){
    }
    
    /*
    Si le joueur 1 est proche de l'obstacle 1 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    distanceJoueur2Obs1 = dist(ball2X, ball2Y, Obs1X, Obs1Y);

    if (distanceJoueur2Obs1<= 65 && hit == false){
    //println("yes");
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs1<= 65 && hit == true){
    }
    
    //OBSTACLE2
    /*
    Si le joueur 1 est proche de l'obstacle 2 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */
    
    distanceJoueur1Obs2 = dist(ballX, ballY, Obs2X, Obs2Y);

    if (distanceJoueur1Obs2<= 65 && hit == false){
    //println("yes");
    scoreFinalP2=scoreFinalP2+1;
    hit=true;
    }
    if (distanceJoueur1Obs2<= 65 && hit == true){
    }
    
    /*
    Si le joueur 2 est proche de l'obstacle 2 et que la fonction booleen est égale à fasle 
    alors la fonction booleen devient true et le joueur 2 marque un point.
    si le fonction est égale a TRUE rien ne se passe. Ceci empêche la condition de répété la supression du point.
    */    
    distanceJoueur2Obs2 = dist(ball2X, ball2Y, Obs2X, Obs2Y);

    if (distanceJoueur2Obs2<= 65 && hit == false){
    //println("yes");
    scoreFinalP1=scoreFinalP1+1;
    hit=true;
    }
    if (distanceJoueur2Obs2<= 65 && hit == true){
    }

    //Etat des joueurs proie et prédateur
    float distanceJoueur =dist(ballX, ballY, ball2X, ball2Y);
    /*
    Si la différence de distance entre les deux joueurs est inférieur à leurs rayons 
    alors le joueur 1 gagne un point, on lance le timer de 3 secondes, on réinitialise la position des joueurs ,
    on remet le tickCounter à 0 et on passe à l'étape 4.
    */
    //Distance entre le joueur prédateur et le joueur proie
    if (distanceJoueur <= radius) {
      scoreFinalP1=scoreFinalP1+1;
      timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
      reInitPositions();
      reInitHit();
      stage = 8;
    }
  }
  
  if (stage == 8) {
    textSize(90); 
    background(255, 156, 144); //change couleur de fond
    textAlign(CENTER); //Aligner text au centre
    text("Résultat", 960, 240); //Afficher résultat
    text("Joueur 1 : " + scoreFinalP1, 480,540); //Afficher score 1
    text("Joueur 2 : " + scoreFinalP2, 1440,540); //Afficher score 2
    fill(255); 
  } 
}


void reInitPositions(){
  //Remettre les positions des balles aux positions initiales
    ballX = 480;
    ballY = 540;   
    ball2X = 1440;
    ball2Y = 540;    
}

void reInitHit(){
   //Remttre le boolean Hit en False.
    hit = false;    
}


void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
//Si stage = 2 alors on change la couleur du background en fonction du tickCounter
  if (stage == 2) {
    if (tickCounter ==0) {
      backgroundColor =  color(255, 156, 144); 

    }   
    if (tickCounter ==1) {
      backgroundColor = color(154, 229, 229);

    }
    tickCounter +=1;
  }

//Si stage = 4 alors on change la couleur du background en fonction du tickCounter
  if (stage == 4) {

    if (tickCounter ==0) {
      backgroundColor =  color(255, 156, 144); 
    }   
    if (tickCounter ==1) {
      backgroundColor = color(154, 229, 229);
    }
    tickCounter +=1;
  }
  
  //Si stage = 6 alors on change la couleur du background en fonction du tickCounter
    if (stage == 6) {

    if (tickCounter ==0) {
      backgroundColor =  color(255, 156, 144); 
    }
    if (tickCounter ==1) {
      backgroundColor = color(154, 229, 229);
    }
    tickCounter +=1;
    }
}

void onFinishEvent(CountdownTimer t) {
// Si Stage =2 tickCounter est remis a 0 et on lance un nouveau timer de 4 sec et on passe au stage 3
  if (stage == 2) {
    tickCounter = 0;
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 40000).start();
    stage = 3;
  }
  // Si Stage =3 tickCounter est remis a 0, on réinitialise les balles on lance un nouveau timer de 40 sec et on passe au stage 4
  else if (stage == 3) {
    tickCounter = 0;
    reInitPositions();
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
    stage = 4;
  }
  // Si Stage =4 tickCounter est remis a 0 et on lance un nouveau timer de 4 sec et on passe au stage 5
  else if (stage == 4) {
    tickCounter = 0;  
    reInitPositions();
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 40000).start();
    stage = 5;
  }
    // Si Stage =5 tickCounter est remis a 0, on réinitialise les balles on lance un nouveau timer de 40 sec et on passe au stage 6
    else if (stage == 5) {
    tickCounter = 0;  
    reInitPositions();
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 3000).start();
    stage = 6;
  }
  // Si Stage =6 tickCounter est remis a 0 et on lance un nouveau timer de 4 sec et on passe au stage 7
  else if (stage == 6) {
    tickCounter = 0;  
    reInitPositions();
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 40000).start();
    stage = 7;
  }
  // Si Stage =7 tickCounter est remis a 0 et on lance un nouveau timer de 4 sec et on passe au stage 8
    else if (stage == 7) {
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 5000).start();
    stage = 8;
    }
    //Si Stage = 8 on retourne au stage 1
    else if (stage == 8) {
    stage = 1;
    }

}


void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {

      String inBuffer = myPort.readStringUntil('\n');

      //println(inBuffer);

      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {

          JSONObject json = parseJSONObject(inBuffer);

          if (json == null) {
          } else {
            //récupération des valeurs dans la carte arduino
            pot1    = json.getInt("pot1");
            pot2    = json.getInt("pot2");       
            etatButtonRP1  =json.getInt("etatButtonRP1");
            ButtonRP2  =json.getInt("ButtonRP2");
            etatButtonLP1  =json.getInt("etatButtonLP1");
            ButtonLP2  =json.getInt("ButtonLP2");
            etatButtonUP1  =json.getInt("etatButtonUP1");
            ButtonUP2  =json.getInt("ButtonUP2");
            etatButtonDP1  =json.getInt("etatButtonDP1");
            ButtonDP2  =json.getInt("ButtonDP2");
          }
        } else {
        } 


        //Joueur 1 capteur son
        // Si la donné du capteur son est inférieur a 200 la vitesse = 0 sinon vistesse = 30
        if (pot1 <= 200) {
          ballSpeed1 = 0;
        } else { 
          ballSpeed1 = 30;
        }

        //Joueur 2 capteur son
        // Si la donné du capteur son est inférieur a 200 la vitesse = 0 sinon vistesse = 30
        if (pot2 <= 100) {
          ballSpeed2 = 0;
        } else { 
          ballSpeed2 = 30;
        }

        //joueur 1 Bouton
        // Si un bouton est égale à 1 alors la balle se déplace à gauche
        if ( (etatButtonRP1 == 1) && (ballX > radius) ) {
          ballX = ballX - ballSpeed1;
        }
        // Si un bouton est égale à 1 alors la balle se déplace à droit
        if ( (etatButtonLP1 == 1) && (ballX < width-radius) ) {
          ballX = ballX + ballSpeed1;
        }
        // Si un bouton est égale à 1 alors la balle se déplace à haut
        if ( (etatButtonUP1 == 1) && (ballY > radius) ) {
          ballY = ballY - ballSpeed1;
        }
        // Si un bouton est égale à 1 alors la balle se déplace à bas
        if ( (etatButtonDP1 == 1) && (ballY < height-radius) ) {
          ballY = ballY + ballSpeed1;
        }
        //joueur 2

        // Si un bouton est égale à 1 alors la balle se déplace à gauche
        if ( (ButtonRP2 == 1) && (ball2X > radius) ) {
          ball2X = ball2X - ballSpeed2;
        }

        // Si un bouton est égale à 1 alors la balle se déplace à droit
        if ( (ButtonLP2 == 1) && (ball2X < width-radius) ) {
          ball2X = ball2X + ballSpeed2;
        }

        // Si un bouton est égale à 1 alors la balle se déplace à haut
        if ( (ButtonUP2 == 1) && (ball2Y > radius) ) {
          ball2Y = ball2Y - ballSpeed2;
        }
        
        // Si un bouton est égale à 1 alors la balle se déplace à bas
        if ( (ButtonDP2 == 1) && (ball2Y < height-radius) ) {
          ball2Y = ball2Y + ballSpeed2;
        }
      }
    }
  }
  catch (Exception e) {
  }
}