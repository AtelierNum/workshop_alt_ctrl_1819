int tailleMax = 500;

void initEnnemy() {
  nbEnnemy = 2;
  //instance des ennmie et leur tailles
  for (int i = 0; i < nbEnnemy; i++) {

    if (LightReunis < tailleMax) {
      pleinEnnemy.add(new ennemy(random(LightReunis - 100, LightReunis + 100)));
    } else {
      pleinEnnemy.add(new ennemy(random(tailleMax - 100, tailleMax)));
    }
  }
}
