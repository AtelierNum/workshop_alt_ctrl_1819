//bibliothèque pour la communication par serial
import processing.serial.*;
Serial myPort;  
 
//bibliothèque et déclaration des variables liés aux sons
import ddf.minim.*;
Minim minim;
AudioPlayer intro;
AudioPlayer main;
AudioPlayer flechette;
AudioPlayer hit;
AudioPlayer fire;


String texte = "";
int etape = 0;
float time;
float T;
float timer;
float Toucher=0;
float distance;
boolean Impact=false;
int x; 
int test=0;
int Start=0;
PFont bebas; //chargement police

// variables des capteurs arduino
float sonG;
float sonD;
float heat;
float sarbacane;

// variables pour les différents layers (profondeurs)
int layer=2;
int layerS1=2;
int layerS2=2;
int layerS3=2;

// variables pour les dimensions des sprites
float l=150;
float h=l;
float H1=149;
float L1=42;
float H2=149;
float L2=42;
float H3=149;
float L3=42;

// variables de positions et de déplacement des sprites
float varx;
float vary;
float speedX=5;
float speedY=0;
float lanceurX1=80;
float lanceurY1=h;
float lanceurX2=80;
float lanceurY2=h;
float lanceurX3=80;
float lanceurY3=h;
float speedY1=15;
float speedX1=0;
float speedY2=15;
float speedX2=0;
float speedY3=15;
float speedX3=0;

// images
PImage img;
PImage clouds;
PImage mont;
PImage back;
PImage mont1;
PImage mont2;
PImage temple;
PImage temple2;
PImage fleche;

// Le mouvement de la montgolfière est défini par deux vecteurs, position et vélocité
PVector position;
PVector velocite;



void setup() {
  // taille de la fenètre
  //size(1920, 1080);
  fullScreen();
  
  //initialisation des images
  img = loadImage("background3.jpg"); //loading image
  clouds = loadImage("clouds.png");
  mont = loadImage("mont.png");
  fleche = loadImage("fleche.png");
  back = loadImage("background1.jpg"); //loading images
  mont1 = loadImage("mont.png");
  mont2 = loadImage("montgolfiere-sans.png");
  temple = loadImage("temple_pepite.png");
  temple2 = loadImage("temple_sans.png");
  
  // initialisation des musiques et samples
  minim = new Minim(this);
  intro = minim.loadFile("Musique Loop.wav");
  main = minim.loadFile("Musique+Transi.wav");
  flechette = minim.loadFile("Sarbacane Simple.wav");
  hit = minim.loadFile("Sarbacane avec Hit.wav");
  fire = minim.loadFile("Mongole et fier.wav");

  // initialisation du port serie
  printArray(Serial.list());
  String SDA = Serial.list()[0];
  myPort = new Serial(this, SDA, 9600);
  myPort.bufferUntil('\n');

  //initialisation de la police
  bebas = createFont("BebasNeueBold.ttf",80);

  //définir la position et le mouvement de départ de la montgolfière
  position = new PVector(0, 175);
  velocite = new PVector(0, 0);
}

void draw() {
  if (etape == 0) { // début etape 0
    main.play();// lancement de la musique
    background(back); // fond d'écran
    image(temple, 0, 0, 1920, 1080); //positionnement du temple
    int x = frameCount % clouds.width; //vitesse du scrolling par rapport à la largeur de l'image
    for (int i = -x; i < width; i += clouds.width) { //Copié l'image à la fin de celle-ci
      copy(clouds, 0, 0, clouds.width, height, i, 0, clouds.width, height);
    }
    textFont(bebas);
    textSize(200);
    fill(#FFD700);
    textAlign(CENTER, CENTER);
    text("La Pepite", displayWidth/2, displayHeight/4); // affiche "Rick s'est echappé !"
    fill(255);
    if(Start!=1){
    textSize(80);
    textAlign(CENTER, CENTER);
    text("Press a to start", displayWidth/2, (displayHeight-(displayHeight/4))); // affiche "Rick s'est echappé !"
    }
    

    // si "a" la montgolfière se déplace
    if (keyPressed) {
      if (key == 'a') {
        Start=1;
        velocite.set(4, 0);
      }
    }
    // Appliquer le mouvement à la montgolfière
    position.add(velocite);

    // Afficher la montgolfière
    image(mont2, position.x, position.y, 300, 300); 

    // Evenements déclenchés selon la position de la montgolfière
    if (position.x > 475) {
      mont2 = mont1;    // changer les images des montgolfières
      temple = temple2; // changer les images des temples
    }
    if (position.x > displayWidth-(2*h)) {
      etape = 1;//passage à l'etape1
    }
    println("etape 0 " + millis());
  } // fin etape 0

  if (etape==1) { // début etape 1
    float timeT= millis()-time; // initialisation d'un cooldown utilisé pour les capteurs sons


    if (test==0) {//initialisation de la position de la montgolfière
      varx=displayWidth-(2*h);
      vary=400;
      test=1;
    }

    image(img, 0, 0, 1920, 1080); // image de fond
    int x = frameCount % clouds.width; //vitesse du scrolling par rapport à la largeur de l'image
    for (int i = -x; i < width; i += clouds.width) { //Copié l'image à la fin de celle-ci
      copy(clouds, 0, 0, clouds.width, height, i, 0, clouds.width, height);
    }





    float cooldown= millis()-T; // initialisation d'un autre cooldown
    // les variables de mouvement sont initialisées 
    lanceurY1 = lanceurY1 + speedY1;
    lanceurX1 = lanceurX1 + speedX1;
    lanceurY2 = lanceurY2 + speedY2;
    lanceurX2 = lanceurX2 + speedX2;
    lanceurY3 = lanceurY3 + speedY3;
    lanceurX3 = lanceurX3 + speedX3;
    
    //si le lanceur (slider de la sarbacane) arrive près des bords du display sa vitesse est inversé, l'opérateur est éffectuée pour chaque flechettes
    if (lanceurY1 > (displayHeight-(h/2)) || lanceurY1 < (h/4)) {
      speedY1 = speedY1 * -1;
    }
    if (lanceurY2 > (displayHeight-(h/2)) || lanceurY2 < (h/4)) {
      speedY2 = speedY2 * -1;
    }
    if (lanceurY3 > (displayHeight-(h/2)) || lanceurY3 < (h/4)) {
      speedY3 = speedY3 * -1;
    }
    
    //affichage des flechettes
    image(fleche, lanceurX1, lanceurY1, H1, L1);
    image(fleche, lanceurX2, lanceurY2, H2, L2);
    image(fleche, lanceurX3, lanceurY3, H3, L3);
    
    //affichage de la montgolfière
    image(mont, varx, vary, l, h);
    
    //utilisation des capteurs
    // si il y a suffisament de chaleur
    if (heat >= 750) {
      if (vary>=25) { // alors la montgolfière monte jusqu'à 25 pixels du haut
        fire.play();
        fire.rewind();
        vary = vary-2.5;
      }
    }
    //utilisation des capteurs de son pour que la montgolfière change de layer
    if (((sonG >= 700)&&(layer==2)&&(timeT>=1500))) { // si on souffle à gauche et que la montgolfière est sur le layer 2
      time= millis();
      layer=1; // est passé sur le layer 1 et change de taille
      l=170;
      h=170;
    }
    if (((sonG >= 700)&&(layer==3)&&(timeT>=1500))) { // si elle est sur le layer 3
      time= millis();
      layer=2; // elle passe sur le layer 2 et change de taille
      l=150;
      h=150;
    }


    if (((sonD >= 650)&&(layer==2)&&(timeT>=1500))) { // si on souflle à droite les déplacements sont inversés
      time= millis();
      layer=3;
      l=130;
      h=130;
    }
    if (((sonD >= 650)&&(layer==1)&&(timeT>=1500))) {
      time= millis();
      layer=2;
      l=150;
      h=150;
    }
    //pour aider à bien visualisé les changement de layer le numero du layer actuel est affiché
    textSize(60);
    textAlign(CENTER, CENTER);
    text(layer, displayWidth-100, displayHeight-100);

    // changement de layer pour la sarbacane en fonction de la distance avec le capteur, les flechettes déjà lancées ne change plus de layer
    if ((distance<=50)&&(speedX1==0)) { 
      layerS1=3;// layer 3 pour une distance de moins de 50 cm
      H1=120; //on adapte la taille
      L1=35;
      textSize(60); // on affiche le layer
      textAlign(CENTER, CENTER);
      text("3", 100, displayHeight-100);
    }
    if ((distance<=50)&&(speedX2==0)) {
      layerS2=3;// layer 3 pour une distance de moins de 50 cm
      H2=120; //on adapte la taille
      L2=35;
      textSize(60); // on affiche le layer
      textAlign(CENTER, CENTER);
      text("3", 100, displayHeight-100);
    }
    if ((distance<=50)&&(speedX3==0)) {
      layerS3=3;// layer 3 pour une distance de moins de 50 cm 
      H3=120; //on adapte la taille
      L3=35;
      textSize(60); // on affiche le layer
      textAlign(CENTER, CENTER);
      text("3", 100, displayHeight-100);
    }

    if (((distance>=50)&&(distance<=100))&&(speedX1==0)) {
      layerS1=2;// layer 2 pour une distance entre 50 et 100 cm 
      H1=149;
      L1=42;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("2", 100, displayHeight-100);
    }
    if (((distance>=50)&&(distance<=100))&&(speedX2==0)) {
      layerS2=2;// layer 2 pour une distance entre 50 et 100 cm 
      H2=149;
      L2=42;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("2", 100, displayHeight-100);
    }
    if (((distance>=50)&&(distance<=100))&&(speedX3==0)) {
      layerS3=2;// layer 2 pour une distance entre 50 et 100 cm 
      H3=149;
      L3=42;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("2", 100, displayHeight-100);
    }
    if (((distance>=100)&&(distance<=200))&&(speedX1==0)) {
      layerS1=1;// layer 1 pour une distance entre 100 et 200 cm
      H1=180;
      L1=50;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("1", 100, displayHeight-100);
    }
    if (((distance>=100)&&(distance<=200))&&(speedX2==0)) {
      layerS2=1;// layer 1 pour une distance entre 100 et 200 cm
      H2=180;
      L2=50;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("1", 100, displayHeight-100);
    }
    if (((distance>=100)&&(distance<=200))&&(speedX3==0)) {
      layerS3=1;// layer 1 pour une distance entre 100 et 200 cm
      H3=180;
      L3=50;
      textSize(60);
      textAlign(CENTER, CENTER);
      text("1", 100, displayHeight-100);
    }
    
    // si on souffle dans la sarbacane 
    if (sarbacane>=350) {
      if ((speedX1==0)&&(cooldown>=650)) { // et si la flechette 1 n'est pas encore lancé + le cooldown est passé
        T=millis();
        speedY1=0; // alors on arrete son mouvement en y et on lui donne une valeur en x
        speedX1=20;
        flechette.play();
      } else if ((speedX2==0)&&(cooldown>=650)) {
        T=millis();
        speedY2=0;
        speedX2=20;
        flechette.play();
      } else if ((speedX3==0)&&(cooldown>=650)) {
        T=millis();
        speedY3=0;
        speedX3=20;
        flechette.play();
      }
    }

    // si la flechette est sur le même layer que la montgolfière et qu'il y a collision alors ...
    if ((layer==layerS1)&&(((lanceurX1+(H1/2)<=varx+(h*0.6))&&(lanceurX1+(H1/2)>=varx+26))&&((lanceurY1>=vary-5)&&(lanceurY1<=vary+(h*0.95))))) {
      rect(0, 0, displayWidth, displayHeight); // un fond blanc fait un flash (retour visuel)
      lanceurX1=displayWidth; // la flechette est déplacer hors de l'écran pour éviter de compter plusieur collisions au lieu d'une
      Impact=true; // le booleen Impact prend la valeur vrai, elle nous permettra de compter le nombre de collisions
      hit.play();
    }
    if ((layer==layerS2)&&(((lanceurX2+(H2/2)<=varx+(h*0.6))&&(lanceurX2+(H2/2)>=varx+26))&&((lanceurY2>=vary-5)&&(lanceurY2<=vary+(h*0.95))))) {
      rect(0, 0, displayWidth, displayHeight);
      lanceurX2=displayWidth;
      Impact=true;
      hit.play();
    }
    if ((layer==layerS3)&&(((lanceurX3+(H3/2)<=varx+(h*0.6))&&(lanceurX3+(H3/2)>=varx+26))&&((lanceurY3>=vary-5)&&(lanceurY3<=vary+(h*0.95))))) {
      rect(0, 0, displayWidth, displayHeight);
      lanceurX3=displayWidth;
      Impact=true;
      hit.play();
    }
    
    //si Impact est vrai alors Toucher est incrémenté
    if (Impact==true) {
      Toucher=(Toucher+1);
      Impact=false; // impact prend la valeur faux
    }

    // si la montgolfière est touchée elle monte moins bien, (gravitée augmentée)
    if (Toucher==0) {
      vary=(vary+1.5);
    }
    if (Toucher==1) {
      vary=(vary+2);
    }
    if (Toucher==2) {
      vary=(vary+2.5);
    }
    if (Toucher==3) {
      vary=(vary+3);
    }
    if (Toucher==4) {
      vary=(vary+3.5);
    }
    if (Toucher==5) {
      vary=(vary+4);
    }
    if (Toucher==6) {
      vary=(vary+5);
    }
    if (Toucher==7) {
      vary=(vary+6);
    }
    
    // si les trois flechettes sortent de l'écran leur position sont réinitialisées et on peut a nouveau les lancer
    if ((lanceurX1 >= displayWidth)&&(lanceurX3 >= displayWidth)) {
      lanceurY1=h;
      lanceurX1=80;
      speedY1=15;
      speedX1=0;
      flechette.rewind();
      hit.rewind();
    }
    if ((lanceurX2 >= displayWidth)&&(lanceurX3 >= displayWidth)) {
      lanceurY2=h;
      lanceurX2=80;
      speedY2=15;
      speedX2=0;
      flechette.rewind();
      hit.rewind();
    }
    if (lanceurX3 >= displayWidth) {
      lanceurY3=h;
      lanceurX3=80;
      speedY3=15;
      speedX3=0;
      flechette.rewind();
      hit.rewind();
    }

    //si le ballon de la montgolfière touche le sol on lance l'étape 2
    if (vary>=displayHeight-(h)) {
      etape = 2;
    }
    
    //timer si la montgolfière ne touche pas le sol avant la fin de la progression alors ont passe à l'étape 3
    rect(0, 0, timer, 20);
    timer+=1;
    if (timer>=displayWidth) {
      etape = 3;
    }
    println("etape 1 " + millis());
  } // fin etape 1

  if (etape == 2) { // affiche le gagnant
    vary=displayHeight-(h/2);
    textSize(110);
    fill(#FFD700);
    textAlign(CENTER, CENTER);
    text("Les Azteques ont recupéré la pépite !", displayWidth/2, displayHeight/2); // affiche "Les Azteques ont recupéré la pépite !"
    fill(255);
    if (keyPressed) {
      if (key == 'b') {
        main.rewind(); //rembobine la musique
        reInit(); // reinitialise les variables
      }
    }
    println("etape 2 " + millis());
  } // fin etape 2

  if (etape == 3) { // affiche le gagnant
    textSize(180);
    fill(#FFD700);
    textAlign(CENTER, CENTER);
    text("Rick s'est echappé !", displayWidth/2, displayHeight/2); // affiche "Rick s'est echappé !"
    fill(255);
    if (keyPressed) {
      if (key == 'b') {
        main.rewind(); //rembobine la musique
        reInit(); // reinitialise les variables
      }
    }
    println("etape 3 " + millis());
  }// fin etape 3

  println("quel etape : " + etape);
}

void serialEvent (Serial myPort) { // fonction pour récupérer les variables arduino

  while (myPort.available() > 0) {
    String inBuffer = myPort.readStringUntil('\n');

    if (inBuffer != null) { 
      texte = inBuffer;
      String[] list = split(inBuffer, ',');

      if (list.length == 5) {
        sonG = float(list[0]);
        sonD = float(list[1]);
        heat = float(list[2]);
        sarbacane = float(list[3]);
        distance = float(list[4]);
      }
    }
  }
}

void reInit() { // fonction qui réinitialise les variables
  mont2 = loadImage("montgolfiere-sans.png");
  temple = loadImage("temple_pepite.png");
  etape = 0;
  time=0;
  x=0;
  position = new PVector(0, 175);
  velocite = new PVector(0, 0);
  l=150;
  h=l;
  H1=149;
  L1=42;
  H2=149;
  L2=42;
  H3=149;
  L3=42;
  layer=2;
  layerS1=2;
  layerS2=2;
  layerS3=2;
  sonG=0;
  sonD=0;
  heat=0;
  sarbacane=0;
  varx=0;
  vary=0;
  test=0;
  x=0; 
  speedX=5;
  speedY=0;
  T=0;
  lanceurX1=80;
  lanceurY1=h;
  lanceurX2=80;
  lanceurY2=h;
  lanceurX3=80;
  lanceurY3=h;
  speedY1=10;
  speedX1=0;
  speedY2=10;
  speedX2=0;
  speedY3=10;
  speedX3=0;
  Toucher=0;
  timer=0;
  distance=0;
  Start=0;
  Impact=false;
}
