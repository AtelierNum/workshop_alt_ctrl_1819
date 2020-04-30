class Player {

  float x; //position en x
  float y; // position en y
  float distanceCentre; // distance au centre
  float reculx = 0; // vitesse en x
  float reculy = 0; // vitesse en y
  int shootValid = 0; // Nombre de fois que l'on a touché l'autre joueur (pour V2 avec laser)


  float angle_degree = 0; // angle du joueur en degree par rapport à un vecteur u(1,0)
  float angle_radian; // angle du joueur en radian par rapport à un vecteur u(1,0)
  float tourner; // "quantité de virage"
  float life = 100; // nombre de vie (sur 100)
  int joueur; //joueur 1 ou 2 ?
  long lastShotMillis = 0; // quand est-ce que l'on a tiré pour la derniere fois
  long lastTouchedMillis = 0; // quand est-ce que l'on a été touché pour la derniere fois 



  // on initialise les valeur du joueur 
  Player(float _x, float _y, int _joueur) {
    x = _x;
    y = _y;
    joueur = _joueur;
  }




  //calcul de l'angle en fonction du potard du controleur 
  void angle_calc() {

    if (joueur == 1) {
      tourner = map(pot1, 0, 1000, -SENSIBILITEVIRAGE, SENSIBILITEVIRAGE);
    } else {
      tourner = map(pot2, 0, 1000, -SENSIBILITEVIRAGE, SENSIBILITEVIRAGE);
    }
    angle_degree = angle_degree + tourner;
  }


  // lors du tir
  void shoot() {
    //on calcul l'angle et donc les valeurs deplacement X et Y de la balle au moment du tir 
    angle_radian = (angle_degree*3.14159265359)/180;
    reculx = reculx - (cos(angle_radian) * SHOOTRECUL);
    reculy = reculy - (sin(angle_radian) * SHOOTRECUL);
    //on crée un nouveau shot (projectile)
    messhot.add(new shot(x, y, angle_radian, joueur));
    lastShotMillis = millis();
    // on joue le son de tire à differentes vitesse pour qu'il ne soit pas lassant
    shoot.rate(random(0.8, 1.5));
    if (!shoot.isPlaying()) {
      shoot.play();
    }
  }

  // si le joueur ne tir pas et n'est pas touché pendant 2s, il gagne de la vie
  void heal() {
    if (joueur == 1) {
      if (millis() - lastShotMillis > 2000 && life<100 && millis()-lastTouchedMillis > 2000) {
        life= life+HEAL; 
        if (!healing_playerA.isPlaying()) {
          healing_playerA.play();
        }
      }
    } else {
      if (millis() - lastShotMillis > 2000 && life<100 && millis()-lastTouchedMillis > 2000) {
        life= life+0.15; 
        if (!healing_playerB.isPlaying()) {
          healing_playerB.play();
        }
      }
    }
  }

  // calcul du deplacement 
  void deplacement() { 
    x = x + reculx;
    y = y + reculy;
  }

  //calcul de la friction de l'environement 
  void friction() {
    reculx = reculx/FRICTION;
    reculy = reculy/FRICTION;
  }


  //afficher le cannon du joueur
  void canon_show() {
    stroke(0);
    strokeWeight(20);
    strokeCap(SQUARE);
    angle_radian = (angle_degree*3.14159265359)/180;
    line(x, y, x + (cos(angle_radian) * 60), y + (sin(angle_radian) * 60));
  }

  // on verrifie que le joueur n'est pas en dehors de la map
  void checkout() {
    //on calcule la distance au centre
    distanceCentre= sqrt( sq(x - (width/2)) + sq(y - (height/2))  );
    // si le joueur est trop loin du centre on inverse sa position par rapport au centre
    if (distanceCentre > RAYONMAP - TAILLEJOUEUR/2) {
      x = width - x ;
      y = height - y ;

      // on décale legerement le joueur vers le centre pour eviter certains bugs
      if (x>width/2) {
        x--;
      } else {
        x++;
      }
      if (y>height/2) {
        y--;
      } else {
        y++;
      }
    }
  }

  // on affiche le joueur
  void display() {
    // il s'agit d'un rond noir
    fill(255);
    stroke(0);
    strokeWeight((12 * TAILLEJOUEUR)/30+ 1); 
    ellipse(x, y, TAILLEJOUEUR, TAILLEJOUEUR);
    // Et d'un rond de couleur en son centre
    if (joueur == 1) {
      fill(245, 151, 125);
      noStroke();
      ellipse(x, y, TAILLEJOUEUR*0.7, TAILLEJOUEUR*0.7);
    } else {
      fill(36, 201, 158);
      noStroke();
      ellipse(x, y, TAILLEJOUEUR*0.7, TAILLEJOUEUR*0.7);
    }
  }

  //Si le joueur est mort
  void die() {
    // on arrete la musique du jeu
    musiqueLoop.stop();
    // on joue le son de mort
    defeated.play();
    // on crée des débris generativement
    float angleTotal = 0;
    //on crée des debris tant que l'ensemble des debris en arcs ne forment pas un cercle
    while (angleTotal <= 2*PI) {
      // on genere une taille random pour le debris
      float angleDebrit = random(0, PI);
      //le dernier debris risque d'etre trop grand, on le met ton à la bonne taille
      if (angleDebrit+angleTotal > 2*PI) {
        angleDebrit = (2*PI) - angleTotal;
      }

      // on cree les debris pour le bon joueur 
      mesDebrit.add(new Debrit(playerB.x, playerB.y, angleDebrit, angleTotal, joueur /*team*/));

      // on calcule l'angle total des debris pour la condition while
      angleTotal = angleTotal + angleDebrit;
    }

    // on dit que les debris ont etes generés 
    debritGenerated = true;
    //on enregistre le temps de fin de la partie
    EndGameMillis = millis();
   
  }
}
