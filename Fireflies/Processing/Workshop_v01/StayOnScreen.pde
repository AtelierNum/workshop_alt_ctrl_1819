//Fonction pour garder les joueurs dans l'écran de jeu
void stayOnScreen() {
  if (split == true) {
    //Player1 stay on screen
    //X position
    if (PosX < 0) {
      PosX = width;
    } else if (PosX > width) {
      PosX = 0;
    }
    //Y position
    if (PosY < 0) {
      PosY = height;
    } else if (PosY > height) {
      PosY = 0;
    }

    //Player2 stay on screen
    //X position
    if (PosX2 < 0) {
      PosX2 = width;
    } else if (PosX2 > width) {
      PosX2 = 0;
    }
    //Y position
    if (PosY2 < 0) {
      PosY2 = height;
    } else if (PosY2 > height) {
      PosY2 = 0;
    }
  } else {

    //Player Reunis stay on screen
    //x possition
    if (newPosX < 0) {
      PosX = width;
      PosX2 = width;
    } else if (newPosX > width) {
      PosX = 0;
      PosX2 = 0;
    }
    //Y position
    if (newPosY < 0) {
      PosY = height;
      PosY2 = height;
    } else if (newPosY > height) {
      PosY = 0;
      PosY2 = 0;
    }
  }
}
