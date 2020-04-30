class shot {

  float angle_radian, speed = 10;
  float x, y, speedX, speedY;
  int team;
  boolean killMe = false; // variable demandant le suicide de la de la balle


  // Constructor
  shot(float _x, float _y, float _angle_radian, int _team) {
    angle_radian = _angle_radian;
    speedX = speed*cos(angle_radian);
    speedY = speed*sin(angle_radian);
    x = _x;
    y = _y;
    team = _team;
  }




  // calcul du deplacement 
  void deplacement() { 
    x = x + speedX;
    y = y + speedY;
  }

  //detection de la collision avec le joueur adverse
  void collision() {
    if (team == 1) {
      float distanceJoueurB = sqrt( sq(x - (playerB.x)) + sq(y - (playerB.y))  );
      //Si la balle touche le joueur visuellement 
      if (distanceJoueurB < TAILLEJOUEUR/2 + TAILLEBALLE/2) {
        //diminuer la vie
        //playerA.shootValid++;
        playerB.life = playerB.life - DEGATSHOT ;
        // on memorise la derniere fois que l'on a tiré
        playerB.lastTouchedMillis = millis();
        // on joue de son de dégat 
        damagePlayerB.stop();
        damagePlayerB.play();
        //on demande le suicide de la balle 
        killMe = true;
      }
    } else { // voir joueur B
      float distanceJoueurA = sqrt( sq(x - (playerA.x)) + sq(y - (playerA.y))  );
      if (distanceJoueurA < TAILLEJOUEUR/2  + 3) {
        playerA.life = playerA.life - DEGATSHOT ;
        //playerB.shootValid++;
        playerA.lastTouchedMillis = millis();
        damagePlayerA.stop();
        damagePlayerA.play();
        killMe = true;
      }
    }
  }

  //affichage d'une balle
  void display() {
    //la balle est du couleur de son joueur
    if (team == 1) {
      stroke(245, 151, 125);
    } else {
      stroke(36, 201, 158);
    }
    noFill();
    strokeCap(SQUARE);
    strokeWeight(TAILLEBALLE); 
    // on affiche une trainée derriere la balle 
    line (x, y, x-speedX*2, y-speedY*2); 
  }

// on verifie si la balle est hors de la map
  void checkout() {
    float distanceCentre = sqrt( sq(x - (width/2)) + sq(y - (height/2))  );
    if (distanceCentre> RAYONMAP) {
      //on demande le suicide de la balle 
      killMe = true;
    }
  }
}
