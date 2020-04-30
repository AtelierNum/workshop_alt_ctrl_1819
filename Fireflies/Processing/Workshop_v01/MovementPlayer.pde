//Mouvement des joueurs
void moveLux() {

  //Distance entre les deux Player
  distanceBTW = dist(PosX, PosY, PosX2, PosY2); 

  //Movement Player1
  if (Distance < 15) {
    PosX += cos(radians(potaMap)) * Speed;
    PosY += sin(radians(potaMap)) * Speed;
  }

  //Movement Player2
  if (Distance2 < 15) {
    PosX2 += cos(radians(potaMap2)) * Speed;
    PosY2 += sin(radians(potaMap2)) * Speed;
  }
}
