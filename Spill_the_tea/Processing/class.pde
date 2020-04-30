
// class pour les icones des mains à gauche
class Mains { 
  //Déclaration des caractéristiques
  float x;
  float y;
  float vitesseX = 10;
  PImage[] imgLa;

  //Constructeur de l'icone
  Mains (float nouvX, float nouvY) {
    x      = nouvX;
    y      = nouvY;
    for (int i = 0; i < 4; i++) {  //importe les images pour la main gauche
      imgMainsG[i] = loadImage("mainG" + str(i) + ".png");
    }
  }

  void display(int imgLa) { //affiche l'icone avec la bonne taille et la bonne image
    image(imgMainsG[imgLa], x, y, 195, 195);
  }
  
  void bouge() { //permet de se déplacer de gauche à droite
      x = x + vitesseX;
  }

}

// class pour les icones des mains à droite
class MainsD {
  //Déclaration des caractéristiques
  float x;
  float y;
  float vitesseX = 10;
  PImage[] imgLa;

  //Constructeur de l'icone
  MainsD (float nouvX, float nouvY) {
    x      = nouvX;
    y      = nouvY;
    //this.imgLa = imgLa;
    for (int i = 0; i < 4; i++) {  //importe les images pour la main droite
      imgMainsD[i] = loadImage("mainD" + str(i) + ".png");
    }
  }

  void display(int imgLa) {
    image(imgMainsD[imgLa], x, y, 195, 195);
  }
  
  void bouge() { //permet de se déplacer de droite à gauche
      x = x - vitesseX;
  }
}
