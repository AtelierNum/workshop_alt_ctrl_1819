class ennemy {

  PVector loc;
  PVector speed;
  PVector mov;
  float taille;

  ennemy(float t_) {
    loc  = new PVector(random(width), random(height));
    speed = new PVector();
    speed = PVector.random2D();
    mov = new PVector();
    taille = t_;
  }

  void update() {
    mov = PVector.random2D(); // mouvement alétoire
    mov.mult(0.45);

    speed.add(mov);
    speed.normalize();

    //ennemy stay on screen
    if (loc.x < 0) {
      loc.x = width;
    } else if (loc.x > width) {
      loc.x = 0;
    }
    if (loc.y < 0) {
      loc.y = height;
    } else if (loc.y > height) {
      loc.y = 0;
    }
    loc = loc.add(speed);
  }

//dessin des boules
  void draw() {
    fill(255, 10, 10, 200);
    ellipse(loc.x, loc.y, taille, taille);
  }
}
