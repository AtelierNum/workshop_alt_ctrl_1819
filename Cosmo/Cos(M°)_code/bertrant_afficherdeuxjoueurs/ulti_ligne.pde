/*class Ulti_ligne {
  // A shot has x,y, and speed in x,y. All float for smooth movement
  float angle_radian;
  float x, y, speedX, speedY;
  int team;
  boolean killMe = false;


  // Constructor
  Ulti_ligne(int _team) {
    team = _team;
  }





  void angleUpdate() { 
    if (team == 1) {
      angle_radian = playerA.angle_radian;
    } else {
      angle_radian = playerB.angle_radian;
    }
  }


  void display() {



    if (team == 1) {
      x=playerA.x;
      y=playerA.y;
      while (dist(x, y, width/2, height/2 )<height*45) {

        x = x + cos(angle_radian);
        y = y + sin(angle_radian);
      }
    }

    stroke(0);
    strokeCap(SQUARE);
    strokeWeight(6); 
    line (playerA.x, playerA.y, x, y);
  }
}
*/
