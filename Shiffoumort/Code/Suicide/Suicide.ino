//BIBLIOTHEQUES

// Ruban led
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

// Capteur de toucher
#include <Wire.h>
#include "Adafruit_MPR121.h"



// BARRE DE VIE

//Définition
#define barreDeVie 14
#define nombrePixel 74
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(nombrePixel, barreDeVie, NEO_GRB + NEO_KHZ800);

//Timer Leds pour les animations de victoire
unsigned long p_millis = 0; // Temps où le ruban a changé d'état
int intervalle = 30; // En-dessous de 30, ça marche mal (allumage des leds est saccadé)
int nLed = 0; // Jusqu'à led le ruban s'allume
int nLed2 = nombrePixel; // Jusqu'à led le ruban s'allume
byte r, g, b; // Valeurs RVB



// BOULEENS

// Initialisation des différentes étapes de jeu
boolean depart = true;
boolean partie = false;
boolean victoire = false;

// Actions de blessures
bool cut = false;
bool fire = false;
bool poison = false;
bool cut1 = false;
bool fire1 = false;
bool poison1 = false;

// Actions de soins
bool bandage = false;
bool cream = false;
bool drug = false;
bool bandage1 = false;
bool cream1 = false;
bool drug1 = false;

// Gain ou perte de points de vie
boolean mort = false;
boolean vie = false;



//POINTS DE VIE

// Nombre de points de vie restant
int numMort;

// Nombre de points de vie maximum et minimum
int vieMax = 74;
int vieMin = -1;



// TIMERS

// Initialisation du timer du jeu
int rythmeTemps = 1000;
unsigned long millisTemps;
int compteurTemps;

// Initialisation du rythme de perte de vie
int rythmeMort = 150;
unsigned long millisMort;
int compteurMort;

// Initialisation du rythme de gain de vie (si besoin d'être réglé différament)
int rythmeVie = 100;
unsigned long millisVie;
int compteurVie;

//Durée de la partie
int dureePartie = 60;



// ZONES

// Parties du corps
const int tete = 8;
const int torse = 9;
const int brasdroit = 10;
const int brasgauche = 13;
const int jambegauche = 12;
const int jambedroit = 11;
const int tete2 = 2;
const int torse2 = 3;
const int brasdroit2 = 4;
const int brasgauche2 = 7;
const int jambegauche2 = 6;
const int jambedroit2 = 5;

// Capteur de toucher
Adafruit_MPR121 cap = Adafruit_MPR121();
Adafruit_MPR121 cap2 = Adafruit_MPR121();

uint16_t lasttouched = 0;
uint16_t currtouched = 0;
uint16_t lasttouched2 = 0;
uint16_t currtouched2 = 0;



// SON

int son;



// FICHIER INCLUS

// Animation des leds
#include "animationLeds.h"





// SETUP

void setup() {

  // Pour pouvoir lancer la console
  Serial.begin(9600);

  // Initialisation du ruban de Led au lancement du jeu
  pixels.begin();
  pixels.setBrightness(255); // Configuration de la luminosité (entre 0 et 255)
  r = 0; // Variables liées à la fonction ledDepart() dans le second fichier
  g = 0;
  b = 0;
  for (int i = 0; i <= nombrePixel; i++) { // On étent toutes les leds
    pixels.setPixelColor(i, pixels.Color(0, 0, 0));
  }
  pixels.show(); // On affiche ce qui est demandé

  // Initialisation du capteur de toucher
  pinMode(tete, OUTPUT);
  pinMode(brasdroit, OUTPUT);
  pinMode(torse, OUTPUT);
  pinMode(brasgauche, OUTPUT);
  pinMode(jambegauche, OUTPUT);
  pinMode(jambedroit, OUTPUT);

  pinMode(tete2, OUTPUT);
  pinMode(brasdroit2, OUTPUT);
  pinMode(torse2, OUTPUT);
  pinMode(brasgauche2, OUTPUT);
  pinMode(jambegauche2, OUTPUT);
  pinMode(jambedroit2, OUTPUT);

  if (!cap.begin(0x5A)) {
    Serial.println("cap not found, check wiring?");
    while (1);
  }
  Serial.println("cap found!");

  if (!cap2.begin(0x5C)) {
    Serial.println("cap2 not found, check wiring?");
    while (1);
  }
  Serial.println("cap2 found!");

  cap.setThreshholds(12, 6);
  cap2.setThreshholds(12, 6);
}





// LOOP

void loop() {

  currtouched = cap.touched();
  currtouched2 = cap2.touched();

  // DÉPART
  // Actions à faire pendabt le départ
  if (depart) {

    // Reset le nombre de points de vie en début de partie (Surtout si un bouton permet de relancer le jeu)
    numMort = vieMax;

    // Reset le timer en début de partie (Surtout si un bouton permet de relancer le jeu)
    compteurTemps = 0;

    son = 0;
    Serial.println(son);
    
    // On fait l'animation des leds qui lancent le départ (Et on dit merci à Clement Gaumt pour ça)
    ledDepart();

    // On lance la partie et on arrete le départ
    partie = true;
    depart = false;
    victoire = false;
  }



  // PARTIE
  // Actions à faire pendant la partie
  if (partie) {



    // On lance le timer
    timer();
    // On lance la réaction des petites leds aux capteurs de toucher (qui indiquent la zones touchée par l'autre joueur)
    ledCorps();

    // On initialise l'état de nos points de vie
    // On en perd pas
    mort = false;
    //On en gagne pas
    vie = false;



    // On indique les conditions pour la perte de points de vie
    // Si le suicidaire de blesse, il perd des points de vie
    if (cut == true && bandage == false) { mort = true;   }
    if (cut1 == true && bandage1 == false) { mort = true;}
    if (poison == true && drug == false) { mort = true; }
    if (poison1 == true && drug1 == false) { mort = true; }
    if (fire == true && cream == false) { mort = true;}
    if (fire1 == true && cream1 == false) { mort = true;}
    
    // Si le médecin soigne sans que le suicidaire de blesse, il perd des points de vie
    if (cut == false && bandage == true) { mort = true; }
    if (cut1 == false && bandage1 == true) { mort = true; }
    if (poison == false && drug == true) { mort = true; }
    if (poison1 == false && drug1 == true) { mort = true; }
    if (fire == false && cream == true) { mort = true; }
    if (fire1 == false && cream1 == true) { mort = true; }
    
    // On indique les conditions pour le gain de points de vie
    // Si le médecin soigne en même temps que le suicidaire se blesse, il gagne des points de vie
    if (cut == true && bandage == true) { vie = true; }
    if (cut1 == true && bandage1 == true) { vie = true; }
    if (poison == true && drug == true) { vie = true; }
    if (poison1 == true && drug1 == true) { vie = true; }
    if (fire == true && cream == true) { vie = true; }
    if (fire1 == true && cream1 == true) { vie = true; }

    

    // Qu'est ce que ça vait si je perd des points de vie
    if (mort) {
      // On lance la fonction qui fait perdre des points (cf bas de page)
      PVMort();
      // On l'affiche sur les leds
      for (int i = 0; i <= numMort; i++) {
        pixels.setPixelColor(i, pixels.Color(255, 0, 0));
      }
      for (int i = nombrePixel; i > numMort; i--) {
        pixels.setPixelColor(i, pixels.Color(0, 0, 0));
      }
    }

    // Qu'est ce que ça vait si je gagne des points de vie
    if (vie) {
      // On lance la fonction qui fait gagner des points (cf bas de page)
      PVVie();
      // On l'affiche sur les leds
      for (int i = 0; i <= numMort; i++) {
        pixels.setPixelColor(i, pixels.Color(0, 255, 0));
      }
    }



    // Sinon la barre de vie est fixe et blanche
    if (!mort && !vie) {
      for (int i = 0; i <= numMort; i++) {
        pixels.setPixelColor(i, pixels.Color(255, 255, 255));
      }
    }



    // On check les conditions de victoire pour les deux joueurs
    // Si les points de vie sont à 0, le suicidaire gagne
    if (numMort <= 0) {
      //On éteind les leds
      for (int i = 0; i <= nombrePixel; i++) {
        pixels.setPixelColor(i, pixels.Color(0, 0, 0));
      }
      // On reset le compteur temps" (pour éviter les interférances avec l'autre condition de victoire)
      compteurTemps = 0;
      // On passe à l'étape victoire
      victoire = true;
      partie = false;
      depart = false;
    }
    

    // Si le temps est écoulé le médecin gagne
    if (compteurTemps > dureePartie) {
      //On éteind les leds
      for (int i = 0; i <= nombrePixel; i++) {
        pixels.setPixelColor(i, pixels.Color(0, 0, 0));
      }
      // On passe à l'étape victoire
      victoire = true;
      partie = false;
      depart = false;
    }
  }


  // VICTOIRE
  // Actions à faire pendant la victoire
  if (victoire) {
    
    // Si le suicidaire gagne
    if (numMort <= 0) {
      //On met l'animation adaptée
      ledVainqueurSuicidaire();
      son = 9;
      Serial.println(son);
    }
    if (compteurTemps > dureePartie && numMort <= 15) {
      ledVainqueurSuicidaire();
      son = 9;
      Serial.println(son);
    }

    // Si le Médecin gagne
    if (compteurTemps > dureePartie && numMort > 15) {
      ledVainqueurSoignant();
    }
  }



  // On affiche les actions demandée pour les leds tout au long de se loop
  pixels.show();
}





// ZONES DU CORPS
// Si un joueur touche une zone, on indique à l'autre joueur quelle zone à été touchée
void ledCorps() {

  // TOUCHÉ
  // Corps du suicidaire
  if (cap.filteredData(0) < 100) {
    poison = true;
    digitalWrite(tete2, HIGH);
    son = 8;
    Serial.println(son);
  }
  if (cap.filteredData(1) < 100) {
    poison1 = true;
    digitalWrite(torse2, HIGH);
    son = 8;
    Serial.println(son);
  }
  if (cap.filteredData(2) < 100) {
    cut = true;
    digitalWrite(brasdroit2, HIGH);
    son = 12;
    Serial.println(son);
  }
  if (cap.filteredData(3) < 100) {
    fire = true;
    digitalWrite(jambedroit2, HIGH);
    son = 5;
    Serial.println(son);
  }
  if (cap.filteredData(4) < 100) {
    fire1 = true;
    digitalWrite(jambegauche2, HIGH);
    son = 5;
    Serial.println(son);
  }
  if (cap.filteredData(5) < 100) {
    cut1 = true;
    digitalWrite(brasgauche2, HIGH);
    son = 12;
    Serial.println(son);
  }

  // Corps du "médecin" (Enfin celui du suicidaire mais qui se trouve face au médecin, avec les actions du médecin donc)
  if (cap.filteredData(6) < 100) {
    drug = true;
    digitalWrite(tete, HIGH);
    son = 7;
    Serial.println(son);
  }
  if (cap.filteredData(7) < 100) {
    drug1 = true;
    digitalWrite(torse, HIGH);
    son = 7;
    Serial.println(son);
  }
  if (cap.filteredData(8) < 100) {
    bandage = true;
    digitalWrite(brasdroit, HIGH);
    son = 1;
    Serial.println(son);
  }
  if (cap.filteredData(9) < 100) {
    cream = true;
    digitalWrite(jambedroit, HIGH);
    son = 4;
    Serial.println(son);
  }
  if (cap.filteredData(10) < 100) {
    cream1 = true;
    digitalWrite(jambegauche, HIGH);
    son = 4;
    Serial.println(son);
  }
  if (cap.filteredData(11) < 100) {
    bandage1 = true;
    digitalWrite(brasgauche, HIGH);
    son = 1;
    Serial.println(son);
  }

  // RELACHÉ
  // Corps du suicidaire
  if (!(currtouched & _BV(0)) && (lasttouched & _BV(0)) ) {
    poison = false;
    digitalWrite(tete2, LOW);
  }
  if (!(currtouched & _BV(1)) && (lasttouched & _BV(1)) ) {
    poison1 = false;
    digitalWrite(torse2, LOW);
  }
  if (!(currtouched & _BV(2)) && (lasttouched & _BV(2)) ) {
    cut = false;
    digitalWrite(brasdroit2, LOW);
  }
  if (!(currtouched & _BV(3)) && (lasttouched & _BV(3)) ) {
    fire1 = false;
    digitalWrite(jambedroit2, LOW);
  }
  if (!(currtouched & _BV(4)) && (lasttouched & _BV(4)) ) {
    fire = false;
    digitalWrite(jambegauche2, LOW);
  }
  if (!(currtouched & _BV(5)) && (lasttouched & _BV(5)) ) {
    cut1 = false;
    digitalWrite(brasgauche2, LOW);
  }

  // Corps du médecin (mais pas vraiment, vous avez compris le truc)
  if (!(currtouched & _BV(6)) && (lasttouched & _BV(6)) ) {
    drug = false;
    digitalWrite(tete, LOW);
  }
  if (!(currtouched & _BV(7)) && (lasttouched & _BV(7)) ) {
    drug1 = false;
    digitalWrite(torse, LOW);
  }
  if (!(currtouched & _BV(8)) && (lasttouched & _BV(8)) ) {
    bandage = false;
    digitalWrite(brasdroit, LOW);
  }
  if (!(currtouched & _BV(9)) && (lasttouched & _BV(9)) ) {
    cream1 = false;
    digitalWrite(jambedroit, LOW);
  }
  if (!(currtouched & _BV(10)) && (lasttouched & _BV(10)) ) {
    cream = false;
    digitalWrite(jambegauche, LOW);
  }
  if (!(currtouched & _BV(11)) && (lasttouched & _BV(11)) ) {
    bandage1 = false;
    digitalWrite(brasgauche, LOW);
  }
  lasttouched = currtouched;
  lasttouched2 = currtouched2;
}





// TIMER DU JEU
// Pour calculer la durée de la partie

void timer() {
  // Timer
  if ( millis() - millisTemps >= rythmeTemps ) {
    millisTemps = millis();
    // On ajoute un temps au compteur
    compteurTemps++;
  }
}



// TEMPO DE DIMINUTION DES PV
// Fonction pour calculer la vitesse de diminution des points de vie
void PVMort() {
  if ( millis() - millisMort >= rythmeMort ) {
    millisMort = millis();
    numMort--;
  }
}



// TEMPO D'AUGMENTATION DES PV
// Fonction pour calculer la vitesse d'augmentation des points de vie (utile si on veut dissocier les deux)
void PVVie() {
  if ( millis() - millisVie >= rythmeVie ) {
    millisVie = millis();
    numMort++;
    // On met un maximum limité au ombre de leds (
    if (numMort >= nombrePixel) {
      numMort = nombrePixel;
    }
  }
}
