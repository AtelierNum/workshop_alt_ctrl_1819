/*
 * Class ripple
 * Used to generate ripple like pattern on screen
 *
*/

class Ripple {
  
  //global Varibale definitions
  public PVector location;

  public boolean isDead = false;

  private float size = 25;
  private float growthStroke = 5;
  private float maxSpread = 500;
  private float easing = 0.05;
  private float min,max;

  private color col;
  
  // contructor
  Ripple(PVector p,float spread,float minimum,float maximum,color col1){
    location = p.copy(); 
    maxSpread = spread;
    min = minimum;
    max = maximum;
    col = col1;
    emit();
  }

  // emmit osc message to play the ripple sound
  private void emit(){
    float dist = _dist(location,chaser.location);
  }
  
  // update function
  public void update(){
    if (size <= maxSpread -1){
      float growthStroke = maxSpread - size;
      size += growthStroke * easing;
    }   
    else {
      isDead = true; 
    }
  }
  
  // render function
  public void render(){
    pushStyle();
      noFill();
      stroke(col,map(size, 0, maxSpread, 255, 0));
      strokeWeight(map(size, 0, maxSpread, min, max));
      ellipse(location.x, location.y, size, size);
    popStyle();
  }
}
