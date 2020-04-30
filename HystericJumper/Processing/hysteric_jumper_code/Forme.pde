

class Forme {

  PVector position;          // position x,y de l'objet
  PVector velocite;          // vecteur de déplacement
  float frottement = 0.1;   // frottement (ralentit progressivement la vélocité)
  PVector gravite;           // vecteur de gravité, force verticale qui attire vers le centre de la terre
  PImage sol;
  float diametre;
  PVector ligne_debut;
  PVector ligne_fin;
  color c;

  Forme(color _c) {
    position = new PVector(600, 0);
    velocite = new PVector(random(-4, 4), 0);
    gravite = new PVector(0, 1);   // la gravité est une force uniquement verticale (en y)
    diametre = 10;
    ligne_debut = new PVector(0, 0);
    ligne_fin = new PVector(20, 0);
    c = _c;
  }

  void deplacer() {
    velocite.add(gravite);
    velocite.mult(1 - frottement);
    position.add(velocite);              // appliquer le déplacement à l'objet 

    // Tester la collision avec le sol

    color c = sol.get(int(position.x), int(position.y + (diametre / 2)));
    if (red(c) > 240) {
      chercherLigne();
      rebond(ligne_debut, ligne_fin);
      velocite.y -= 1;
    }


    // Faire rebondir l'objet sur les bords de l'écran
    if (position.x < 0 || position.x > width) velocite.x = - velocite.x;
    if (position.y < 0 || position.y > height) velocite.y = - velocite.y;
    // Empecher l'objet de sortir de l'écran
    if (position.y > height) position.y = height;
  }

  void chercherLigne() {
    int max_debut = int(position.y + (diametre / 2));
    int max_fin   = int(position.y + (diametre / 2));
    int xd = int(position.x - (diametre / 2));
    int xf = int(position.x + (diametre / 2));
    for (int i = max_debut; i > position.y; i--) {
      color cc = sol.get(xd, i);
      if (red(cc) > 240) max_debut = i;
    }
    for (int i = max_fin; i > position.y; i--) {
      color cc = sol.get(xf, i);
      if (red(cc) > 240) max_fin = i;
    }
    println(max_debut + " " + max_fin);
    ligne_debut.set(0, max_debut - position.y);
    ligne_fin.set(20, max_fin - position.y);
  }

  void afficher() {
    fill(c);
    stroke(c);
    ellipse(position.x, position.y, diametre, diametre);
  }

  void afficherLigne() {
    stroke(255);
    strokeWeight(3);
    line( 495, 40 + ligne_debut.y, 505, 40 + ligne_fin.y);
  }

  void rebond (PVector tip1, PVector tip2) {
    PVector n = new PVector(tip2.x - tip1.x, tip2.y - tip1.y);
    n.set( -n.y, n.x, 0);
    n.normalize();
    float dotVec = velocite.dot(n) * 2;
    n.mult(dotVec);
    PVector mvn = new PVector(velocite.x - n.x, velocite.y - n.y);
    velocite.set(mvn.x, mvn.y, 0);
  }

  void changeImage(PImage _sol) {
    sol = _sol;
  }
}
