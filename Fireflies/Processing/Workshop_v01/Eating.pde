//Fonction manger ennemie et boule de lumière
void eatingBoule() {
  if (split == true) {
    //eating boule bleue
    for (int i = 0; i < pleinBouleBleue.size(); i++) {
      float nbBx = pleinBouleBleue.get(i).loc.x;
      float nbBy = pleinBouleBleue.get(i).loc.y;

      //distance entre le Player2 et les boules bleu
      distanceBouleBleue = dist(PosX2, PosY2, nbBx, nbBy);
      //manger les boules
      if (distanceBouleBleue < Light2 * 0.5) {

        pleinBouleBleue.remove(i);
        //son manger
        gulp.play();
        //nbr de boule mangée
        bouleEat ++ ;
        Light2 += 2 ;
      }
    }
    //eating boule rose
    for (int i = 0; i< pleinBouleRose.size(); i++) {
      float nbRx = pleinBouleRose.get(i).loc.x;
      float nbRy = pleinBouleRose.get(i).loc.y;

      distanceBouleRose = dist(PosX, PosY, nbRx, nbRy);

      if (distanceBouleRose < Light * 0.5) {
        pleinBouleRose.remove(i);
        //son manger
        gulp.play();
        //nbr boule mangée
        bouleEat ++;
        Light += 2;
      }
    }
    //eating ennemy Player1 & Player2
    for (int i = 0; i < pleinEnnemy.size(); i++) {
      float nbEx = pleinEnnemy.get(i).loc.x;
      float nbEy = pleinEnnemy.get(i).loc.y;
      float taille = pleinEnnemy.get(i).taille;
      boolean destroyEnnemy = false;

      distanceEnnemy1 = dist(PosX, PosY, nbEx, nbEy);
      distanceEnnemy2 = dist(PosX2, PosY2, nbEx, nbEy);

      if (distanceEnnemy1 < Light * 0.5) {
        if (Light > taille) {
          //manger ennemy
          destroyEnnemy = true;
          bouleEat++;
          Light += 5;
        } else {
          if (Light > LightMini) {
            //perte de lumière quand on est plus petit que l'ennemy
            Light -= 10;
          }
        }
      }

      if (distanceEnnemy2 < Light2 * 0.5) {
        if (Light2 > taille) {
          //manger ennemy
          destroyEnnemy = true;
          bouleEat++;
          Light2 += 5;
        } else {
          if (Light2 > LightMini) {
            //perte de lumière quand on est plus petit que l'ennemy
            Light2 -= 10;
          }
        }
      }
      if (destroyEnnemy) pleinEnnemy.remove(i);
    }
  } else {
    //eating boule violette
    for (int i = 0; i < pleinBouleViolette.size(); i++) {
      float nbVx = pleinBouleViolette.get(i).loc.x;
      float nbVy = pleinBouleViolette.get(i).loc.y;

      distanceBouleViolette = dist(newPosX, newPosY, nbVx, nbVy);

      if (distanceBouleViolette < LightReunis * 0.5) {
        pleinBouleViolette.remove(i);
        //son manger
        gulp.play();
        //nbr boule violette manger
        bouleEatV++;
        Light +=2;
        Light2 += 2;
      }
    }

    //eating ennemy Player Reunis
    for (int i = 0; i < pleinEnnemy.size(); i++) {
      float nbEx = pleinEnnemy.get(i).loc.x;
      float nbEy = pleinEnnemy.get(i).loc.y;
      float taille = pleinEnnemy.get(i).taille;

      distanceEnnemy1 = dist(newPosX, newPosY, nbEx, nbEy);

      if (distanceEnnemy1 < LightReunis * 0.5) {
        if (LightReunis > taille) {
          pleinEnnemy.remove(i);
          //son manger
          gulp.play();
          //nbr boule manger
          bouleEat++;
          Light += 5;
          Light2 += 5;
        } else {
          if (Light > LightMini || Light2 > LightMini) {
            //perte de lumière quand on est plus petit que l'ennemy
            Light -= 10;
            Light2 -= 10;
          }
        }
      }
    }
  }
}
