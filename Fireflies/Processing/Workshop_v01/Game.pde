//Initialisation du jeu
void gameScreen() {
  
  //Initialisation Statistique de jeu
  Distance = 50;
  Distance2 = 50;
  Interrupteur = 1;
  Speed = 4;
  Light = 100;
  Light2 = 100;
  LightMini = 75;
  nbBoule = 50;
  nbBouleRose = 50;
  nbBouleViolette = 2;
  bouleEat = 0;
  bouleEatV = 0;
  bouleEatTarget = 20;
  bouleEatTargetV = 5;
  ennemyTargetToSpawn = 50;
  
//Initialisation Position Players
  PosX = width/4;
  PosY = height/2;

  PosX2 = width/2;
  PosY2 = height/2;

  rectMode(CENTER);

  //générer les boules bleues
  for (int i = 0; i < nbBoule; i++) {
    pleinBouleBleue.add(new bouleBleue(random(10, 20)));
  }
  //générer les boules roses
  for (int i = 0; i < nbBouleRose; i++) {
    pleinBouleRose.add(new bouleRose(random(10, 20)));
  }
}
