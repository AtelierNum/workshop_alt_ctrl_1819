//crétion graphique des Players

void renderLux() {
  //Split des lumière selon l'interrupteur
  if (Interrupteur == 1) {
    split = true;
  } else if (Interrupteur == 0 && distanceBTW < 150) {
    split = false;
  }

  if (split == true) {
    //Light Player1
    fill(236, 188, 215, 50);
    ellipse(PosX, PosY, Light, Light);

    //Light Player2
    fill( 198, 231, 232, 50);
    ellipse(PosX2, PosY2, Light2, Light2);

    //Player1
    fill(255, 129, 148, 200);
    ellipse(PosX, PosY, 50, 50);

    //Player2
    fill(165, 253, 255, 200);
    ellipse(PosX2, PosY2, 50, 50);
  } else {
    //Player Reunis Position
    newPosX = (PosX + PosX2) * 0.5;
    newPosY = (PosY + PosY2) * 0.5;
    float newPotaMap = (potaMap + potaMap2) * 0.5;

    //Player Reunis
    fill(182, 95, 255, 250);
    pushMatrix();
    translate(newPosX, newPosY);
    rotate(radians(newPotaMap));
    ellipse(0, 0, 100, 100);

    //Light Player Reunis
    fill( 142, 76, 158, 50);
    ellipse(0, 0, LightReunis, LightReunis);
    popMatrix();
  }
}
