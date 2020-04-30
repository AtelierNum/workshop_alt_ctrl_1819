/*
 * Class describing the begavior of the chaser <the beast> 
 *
*/

class Chaser{

  private ArrayList <Ripple> ripples = new ArrayList<Ripple>();

  public PVector location;
  public PVector velocity;
  public PVector acceleration;
  public PVector angle;
  public PVector earRight;
  public PVector earLeft;

  private boolean isCanvasInfinite;
  private boolean isSeen;

 
  private int time;
  public int size;

  private float mass;
  private float delta;
  private float bounce;
 
  private float force;
  private float initOpacity = 0;
  private float opacity;
 
  Chaser(PVector p){
    mass = 1;
    location = p;
    size = 200;
    bounce = -50;
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    earRight = new PVector(size/2,size/2);
    earLeft = new PVector(-size/2,-size/2);
    isCanvasInfinite = true;
  }
 
  public void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
 
  public void update() {
    //physics update
    velocity.add(acceleration).limit(3);
    location.add(velocity);
    acceleration.mult(0);
    if(isCanvasInfinite){
      checkEdges_infinite();
    }else{
      checkEdges_static();
    }
    listen();

   
  }


  public void seen(float f){
    isSeen = true;
    opacity = map(f,width*0.7,0,initOpacity,30);
    force = f;
  }

 
  public void render() {
    ripples();
    pushMatrix();
      translate(location.x,location.y);
      rotate(angle(velocity));
      noStroke();


      if(isSeen){

        if( millis() > time ){
          time = millis() + 500;
          isSeen = false;
          force = 0;
        }
        
      }else{
        if (opacity > initOpacity){
          opacity -= 5;
        }
        else{
          opacity = initOpacity;
        }
      }
      fill(opacity);
      ellipse(0,0,size,size);
      fill(255);
     
    popMatrix();
  }
  
  // handle the listening of the chaser, calculation for the stereo sound
  private void listen(){

    // extract information from position
    float sine = sin(angle(velocity));
    float cosine = cos(angle(velocity)); 
    
    // right ear
    float xA = location.x + earRight.x * sine;
    float yA = location.y + earRight.y * -cosine;
    
    // left ear
    float xB = location.x + earLeft.x * sine;
    float yB = location.y + earLeft.y * -cosine;
    
    
    float distRight = dist(xA,yA,chased.location.x,chased.location.y);
    float distLeft = dist(xB,yB,chased.location.x,chased.location.y);
   
    // calc the difference between distances and send it
    float delta = round(distRight - distLeft);
    sendOscMessage("/stereo",delta);
  }
 
  // check edges in a closed world
  private void checkEdges_static() {
    float halfSize = size/2;

    // colision checking in X
    if(location.x + size*0.5 >= width) {
      velocity.x *= bounce;
      location.x = width - halfSize;
    }else if (location.x - size*0.5 <= 0) {
      velocity.x *= bounce;
      location.x = 0 + halfSize;
    }

    // colision checking in Y
    if(location.y + size*0.5 >= height) {
      velocity.y *= bounce;
      location.y = height - halfSize;
    }else if(location.y - size*0.5 <= 0) {
      velocity.y *= bounce;
      location.y = 0 + halfSize;
    }
  }

  // check edges in an infinite looping world
  private void checkEdges_infinite() {
    float halfSize = size/2;

    // colision checking in X
    if(location.x  >= width) {
      location.x = 0;
    }else if (location.x  <= 0) {
      location.x = width;
    }

    // colision checking in Y
    if(location.y >= height) {
      location.y = 0;
    }else if(location.y <= 0) {
      location.y = height;
    }
  }

  // render the ripples atached to the chaser
  public void ripples(){
    // update and display ripples
    for(int i = 0; i < ripples.size(); i++){
      Ripple ripple = ripples.get(i);

      ripple.update();
      ripple.render();
      // delete dead ripples to save memory
      if (ripple.isDead) ripples.remove(ripple);
    }
  }
  
}
