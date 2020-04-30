int state = 0;
int timer;

void state() {

  if (state == 0) {
    file.loop();
    //afichage menu
    menu = true;
    image(Menu, 0, 0);
  } else if (state == 1) {
    //afichage du jeu
    isOnGame = true;
    gameScreen();
  } else if (state == 2) {
    //affichage victoire
    image(WinIMG, 0, 0);

    Win = true;
    file.stop();

    
  }
}
