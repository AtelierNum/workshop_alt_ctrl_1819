
// DÉPART
// On remercie Clement Gault pour cette animation
// Animation des leds pour annoncer le départ
void ledDepart() {
  int n = nombrePixel;
  int d = 1000;

  // "3" en rouge
  for (int i = 2; i < n / 5 + 2; i++) {
    pixels.setPixelColor(i, 255, 0, 0); // pixels.setPixelColor(quelle led ?, rouge, vert, bleu); la première led c'est la 0, etc.
  }
  for (int i = n / 2 - n / 10; i < n / 2 + n / 10; i++) {
    pixels.setPixelColor(i, 255, 0, 0);
  }
  for (int i = n - 3; i > n - 3 - n / 5; i--) {
    pixels.setPixelColor(i, 255, 0, 0);
  }

  pixels.show(); // Pour envoyer les données dans le ruban, sans l'appel de cette fonction, le ruban ne change pas de couleur
  delay(d);
  
  pixels.clear(); // On éteint toutes les leds
  pixels.show();
  delay(1); // Pour avoir le temps d'envoyer les données dans les leds

  // "2" en orange
  for (int i = n / 3 - n / 10; i < n / 3 + n / 10; i++) {
    pixels.setPixelColor(i, 255, 165, 0);
  }
  for (int i = 2 * (n / 3) - n / 10; i < 2 * (n / 3) + n / 10; i++) {
    pixels.setPixelColor(i, 255, 200, 0);
  }
  pixels.show();
  delay(d);
  
  pixels.clear();
  pixels.show();
  delay(1);

  // "1" en vert
  for (int i = n / 2 - n / 10; i < n / 2 + n / 10; i++) {
    pixels.setPixelColor(i, 0, 255, 0);
  }
  pixels.show();
  delay(d);

  pixels.clear();
  pixels.show();
  delay(1);
}



// VICTOIRE MÉDECIN
// On remercie aussi Clement Gault pour cette animation
//Animation des leds si le soignant gagne
void ledVainqueurSoignant() {
  if (millis() - p_millis >= intervalle) {
    p_millis = millis(); // Met à jour le moment où le ruban a changé d'état
    for (int i = 0; i < nLed; i++) { // On allume les leds juqu'a nLed
      pixels.setPixelColor(i, r, g, b); // i : numéro de led, r, v et b : couleur
    }
    if (nLed < pixels.numPixels()) { // strip.numPixels() renvoie le nb de leds dans le ruban
      nLed++;
    } else {
      nLed = 0;
      //strip.clear(); // On peut éteindre toutes les leds quand on arrive à la dernière
      r = random(0);
      g = random(256);
      b = random(0);
    }
  }
}



// VICTOIRE SUICIDAIRE
// On remercie encore Clement Gault pour cette animation
//Animation des leds si le suicidaire gagne
void ledVainqueurSuicidaire() {
    if (millis() - p_millis >= intervalle) {
    p_millis = millis(); // Met à jour le moment où le ruban a changé d'état
      for (int i = nombrePixel; i >= nLed2; i--) { // On allume les leds juqu'a nLed
        pixels.setPixelColor(i, r, g, b); // i : numéro de led, r, v et b : couleur
      }
      if (nLed2 >= 0) { // strip.numPixels() renvoie le nb de leds dans le ruban
        nLed2--;
      } 
      else {
      nLed2 = nombrePixel;
      //strip.clear(); // On peut éteindre toutes les leds quand on arrive à la dernière
      r = random(256);
      g = random(0);
      b = random(0);
    }
  }
}
