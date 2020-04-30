//Initialisation boules bleue, rose, violette
void initBouleViolette() {
  //initialisation du nbr de boules violettes
  for (int i = 0; i < nbBouleViolette; i++) {
    pleinBouleViolette.add(new bouleViolette(random(35, 55)));
  }
}

void initNewBoule() {
  //générer les boules bleues
  for (int i = 0; i < 20; i++) {
    pleinBouleBleue.add(new bouleBleue(random(10, 20)));
  }
  //générer les boules roses
  for (int i = 0; i < 20; i++) {
    pleinBouleRose.add(new bouleRose(random(10, 20)));
  }
}
