/*
 * Class describing the begavior of the generator the player must light on to find the exit.
 *
*/


class Item{

  private ArrayList <Ripple> ripples = new ArrayList<Ripple>();

  public PVector location;

  private float rotation;
  private float size;

  private int state;
  private int time;

  Item(PVector pos){
    location = pos;
    rotation = random(0,PI);
    size = random(20,40);
    state = 0;
    time = 0;
  }

  // setter for internal state
  public void setState(int st){
    state = st;
  }

  // hadle the login of the component
  private void update(){
    if( millis() > time ){
      time = millis() + 500;
      color r_col = color(255,255,255);
      float dist = _dist(location,chaser.location);
      sendOscMessage("/generator-sound",1);
      sendOscMessage_A1("/generator-sound",1);
      ripples.add(new Ripple(new PVector(0,0),100,1,4,r_col));
    }
  }

  // main render function
  public void render(){

    pushMatrix();
      if(state == 0){
        fill(0);
        stroke(0,0,0);
      }else if(state == 1){
        fill(30);
        stroke(50);
      }else if(state == 2){
        fill(255);
        stroke(255);
      }
      
      translate(location.x,location.y);

      if(state == 2){
        update();
        ripples();
      }

      rotate(rotation);
      rect(0,0,size,size);
    popMatrix();
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
