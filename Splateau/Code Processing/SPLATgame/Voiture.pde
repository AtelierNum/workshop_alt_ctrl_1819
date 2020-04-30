/*
  Un objet capable de se déplacer dans l'écran et sujet à des forces physiques
  Le type PVector est un type de données pour stocker des vecteurs (deux valeurs)
  voir : https://processing.org/reference/PVector_set_.html
*/

class Voiture {

  PVector position;          // position x,y de l'objet
  PVector velocite;          // vecteur de déplacement
  PVector acceleration;      // vecteur d'acceleration
  float frottement = 0.003;  // frottement (ralentit progressivement la vélocité)
  color c = color(233, 247, 145, 30);
  
  PImage voiture;
  
  Voiture() {
    position = new PVector(random(width), random(height));
    velocite = new PVector(random(-2,2), random(-2,2));
    acceleration = new PVector(0, 0);    // Pas d'accélération à l'initialisation de l'objet 
  }
  
  void deplacer(float vLimit) {
    velocite.add(acceleration);
    velocite.mult(1 - frottement);
    velocite.limit(vLimit);              // limiter la vitesse!
    position.add(velocite);              // appliquer le déplacement à l'objet 
    //reduireAcceleration();
    
    // Maintenir l'objet dans l'écran
    // Si l'objet sort de l'écran en x ou en y, il réapparaît de l'autre côté
    // Une autre possibilité serait de le faire rebondir sur le bord en inversant le vecteur de vélocité
    if (position.x < 0) position.x = width;
    else if (position.x > width) position.x = 0;
    if (position.y < 0) position.y = height;
    else if (position.y > height) position.y = 0;
    
    
  }

  void afficher(float angle) {
    fill(c);
    stroke(c);
    // Tracer la forme en superposant des ellipses transparentes
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    image(voiture, 0, 0);
    popMatrix();
    imageMode(CORNER);
    
  }
  
 /* void changerVelocite() { 
    // Réatribuer aléatoirement de nouvelles valeurs au vecteur de vélocité
    velocite.set(random(-2,2), random(-2,2));
  }
  
  void changerVitesse(float v) {
    // La vitesse est une valeur scalaire, il faut recalculer le vecteur de vélocité en fonction  
    velocite.mult(v);
 */
  
  void accelerer() { // accélérer sans changer la direction
    //acceleration.set(1, 1);
    acceleration.set(velocite.x, velocite.y);
    
  }
  
  /*void reduireAcceleration() {
    acceleration.mult(0.8);
  }
  
  void inverserDirection() {
    velocite.rotate(PI);
  }*/
  
  void changerDirection(float angle) {
    // Pour changer la direction, il faut d'abord créer un nouveau vecteur à partir de l'angle souhaité
    PVector nouveau = PVector.fromAngle(radians(angle));
    // Puis calculer la vitesse actuelle (la vitesse est la magnitude de la vélocité)
    float vitesse = velocite.mag();
    // Et enfin, réattribuer ce nouveau vecteur à la vélocité de l'objet
    velocite.set(nouveau.x * vitesse, nouveau.y  *vitesse);    
  }
  
}
