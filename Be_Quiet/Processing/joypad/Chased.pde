/*
 * Class describing the begavior of the chased player <the human> 
 *
*/


class Chased{

  private ArrayList <Ripple> ripples = new ArrayList<Ripple>();
  
  public PVector location;
  public PVector velocity;
  public PVector acceleration;

  public int size;
  public int rippleCounter;

  private int maxRipple;
  private int minRipple;
  private int time;
  private int time_1;

  private float bounce;
  private float mass;
  
  Chased(PVector p){
    mass = 1;
    location = p;
    size = 50;
    bounce = -3;
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    maxRipple = 300;
    minRipple = 50;
    rippleCounter = maxRipple/3;
  }

  void regenerate(){
    if(rippleCounter <= minRipple){
      if( millis() > time ){
        time = millis() + 1800;
        rippleCounter += 4;
      }
    }
  }

  void rippleColide(Ripple riple){
    float dist = _dist(riple.location,chaser.location);
    float delta = dist  - (riple.size*0.5 + chaser.size*0.5);
    int range = 10;

    if(  delta < range && delta > -range ){
      chaser.seen(dist);
    }

    for(int i = 0; i < items.size(); i++){
      Item item = items.get(i);  
      
      float dist_1 = _dist(riple.location,item.location);
      float delta_1 = dist_1  - (riple.size*0.5 + item.size*0.5);

      if(  delta_1 < range && delta_1 > -range ){
        if (item.state == 0){
          item.setState(1);
        }
      }
    }
  }
 
  public void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
 
  public void update() {
    velocity.add(acceleration);
    velocity.limit(2.8);
    location.add(velocity);
    velocity.mult(0.90);
    acceleration.mult(0);
    regenerate();
    checkEdges();

    // send footstep sound to PD
    if(stepPlayer != 0){ 
      if( millis() > time_1){
        time_1 = millis() + 600;
          sendOscMessage("/walk",1);
          sendOscMessage_A1("/walk",1);
      }
    }

    //location.x =mouseX;
    //location.y = mouseY;
  }
 
  public void render() {
    ripples();
    pushMatrix();
      fill(100,100,100);
      translate(location.x,location.y);
      rotate(angle(velocity));
      noStroke();
      ellipse(0,0,size,size);

      pushMatrix();
        translate(size/2 - 5,0);
        rotate(PI/4);
        rect(0,0,18,18);
      popMatrix();

      fill(255,0,0);
      arc(0,0, size-9, size-9, 0, map(rippleCounter,0,maxRipple,0,PI), PIE);
      arc(0,0, size-9, size-9, map(rippleCounter,0,maxRipple,0,-PI), 0, PIE);
      fill(255);
      ellipse(0,0,size-15,size-15);
     
    popMatrix();
  }
  
  public void feed(){
    sendOscMessage("/light_on",1);
    sendOscMessage_A1("/light_on",1);
    if(rippleCounter + 30 < maxRipple){
      rippleCounter += 30;
    }else{
      rippleCounter = maxRipple;
    }
  }
 
  private void checkEdges() {
    float halfSize = size/2;
    if(location.x + size*0.5 >= width) {
      velocity.x *= bounce;
      location.x = width - halfSize;
    }else if (location.x - size*0.5 <= 0) {
      velocity.x *= bounce;
      location.x = 0 + halfSize;
    }
    if(location.y + size*0.5 >= height) {
      velocity.y *= bounce;
      location.y = height - halfSize;
    }else if(location.y - size*0.5 <= 0) {
      velocity.y *= bounce;
      location.y = 0 + halfSize;
    }

    if( 
      location.x + size*0.5 >= width 
      || location.x - size*0.5 <= 0 
      || location.y + size*0.5 >= height
      || location.y - size*0.5 <= 0
      ){
      color r_col = color(255, 0, 0);
      if(ripples.size() < 10) ripples.add(new Ripple(location,300,0,20,r_col));
    }
  }

  public void emitRipple(float pressureSonar){
    if(rippleCounter <= 0) return;

    float dist = _dist(chased.location,chaser.location);
    float spread = constrain(map(pressureSonar,-200,1000,0,width/1.3),100,width/1.3 );
    float size = int(map(pressureSonar,0,1000,1,40));
    float cost = int(map(pressureSonar,0,1000,1,4));

    color r_col = color(255, 0, 0);

    ripples.add(new Ripple(location,spread,0,size,r_col));
    sendOscMessage("/ripple",dist);
    sendOscMessage_A1("/ripple",dist);
    rippleCounter -= 3;
  }

  public void ripples(){
    for(int i = 0; i < ripples.size(); i++){
      Ripple ripple = ripples.get(i);
      ripple.update();
      ripple.render();

      rippleColide(ripple);
      
      if (ripple.isDead){
        ripples.remove(ripple);
      }
    }
  }
  
}
