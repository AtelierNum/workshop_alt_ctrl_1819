class Debrit {
 
  float angleTotal, angleDebrit;
  float x, y, speedX, speedY;
  int team;
  boolean killMe = false; // variable demandant le suicide de la du debris

  // Constructor
  Debrit(float _x, float _y, float _angleDebrit, float _angleTotal, int _team) {
    angleDebrit = _angleDebrit;
    angleTotal = _angleTotal; 
    float angleDeplacement = angleTotal+angleDebrit/2;
    // on multiplie l'angle du debris par leur vitesse
    speedX = SPEEDDEBRIT*cos(angleDeplacement);
    speedY = SPEEDDEBRIT*sin(angleDeplacement);
    x = _x;
    y = _y;
    team = _team;
  }

  // calcul du deplacement 
  void deplacement() { 
    x = x + speedX;
    y = y + speedY;
  }

  // calcul de la friction
  void friction() {
    speedX = speedX/(FRICTION*0.9);
    speedY = speedY/(FRICTION*0.9);
  }

  //on affiche le debrit
  void display() {

    stroke(0);
    noFill();
    arc(x, y, TAILLEJOUEUR, TAILLEJOUEUR, angleTotal, angleTotal + angleDebrit );
    // on choisi la couleur du centre en fonction de la team du debrit
    if (team == 1) {
      fill(245, 151, 125);
    } else {
      fill(36, 201, 158);
    }
    noStroke();
    arc(x, y, TAILLEJOUEUR*0.7, TAILLEJOUEUR*0.7, angleTotal, angleTotal + angleDebrit);
  }
}
