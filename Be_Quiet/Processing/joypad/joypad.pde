/*
 *  Code for the Game "Be Quite" built during a 4 day workshop at L'école de design Nantes Atlantique 
 *  By Simon Renault, Martin Lamire, Christophe Le Conte, Andrews Kimbembe and Sébastien Reischek
 *  
 *  The arduino code is require din order to run the game as well as the code made in puredata.
 *
 *
 *
*/

import oscP5.*;
import netP5.*;
import processing.serial.*;
Serial myPort;

// libraries definitions
OscP5 oscP5;
NetAddress myRemoteLocation;

OscP5 oscP5_A1;
NetAddress myRemoteLocation_A1;

// object definitions
Chaser chaser; 
Chased chased;
Screen screen;
Exit exit;
ArrayList <Item> items;

//raw values from sensors
float r = 0;
float r1 = 0;

float time;
float time_1;
float stereo;
float pressureSonar;
float rotPlayer;

int stepPlayer;
int itemCount;

boolean isDebug = false;
boolean isFinished = false;

// vectors definitions
PVector posChaser ;
PVector posChased ;
PVector chasedForce ;



// global helpers definition

// calc the angle represneted as a vector
float angle(PVector vec){
  return atan2(vec.y,vec.x);
}
// calc the dist of 2 location vectors
float _dist(PVector v1, PVector v2){
  return  round(dist(v2.x, v2.y, v1.x,v1.y));
}


// set or reste the game to it's base state
void init(){
  exit = new Exit();
  items = new ArrayList<Item>();
  chaser = new Chaser(new PVector(200,200));
  chased = new Chased(new PVector(500,500)); 
  posChaser = new PVector();
  posChased = new PVector();
  itemCount = 3;
  screen = new Screen();
  exit.state = 0;
  addRandomItem();
  items.get(0).setState(1);
}

// basic setup fof the game, different from init which can be called at every new game this fu ction can oly be called once for first initialisation
void setup() {
  fullScreen();
  noCursor();

  // osc com with master pure data patch for the chaser
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("192.168.43.82", 1230);


  // osc com with the secondary pure data patch used for the ambiance sound for the public watching the game.
  myRemoteLocation_A1 = new NetAddress("192.168.43.82", 1236);

  printArray(Serial.list());

  String portName = Serial.list()[11];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');

  rectMode(CENTER);
  smooth(10);
  pixelDensity(1);
  init();
}


// ad an item at a random location in the canvas
// @todo : make it less random and add some location rules.
void addRandomItem(){
  int padding  = 100;
 float x = random(0 + padding,width - padding);
 float y = random(0 + padding,height - padding);
 items.add(new Item(new PVector(x,y)));
}

// compute all base positions according to sensors
void compute(){
  posChased.x = mouseX;
  posChased.y = mouseY;
  posChaser.x = sin(r);
  posChaser.y = cos(r);
  posChaser.mult(r);
  pressure();

  // if the button is pressed, then move.
  if((stepPlayer != 0)){ 
    try{
      chased.applyForce(chasedForce.normalize().mult(10));
    }catch(Exception e){}
  } 
}


// drawing stack of the game, beware the z-index and the frame rate.
// executed in average 60 time a second
void draw() {
  if(isDebug) debug();
  screen.update();
}

// calc and handle colisions between the chased and the chaser.
void calc(){
  float y = 5;
  chasedForce = new PVector (cos(map(rotPlayer, 0, 1023, 0,TWO_PI*y )), sin(map(rotPlayer, 0, 1023, 0,TWO_PI*y)));
  
  float dist = dist(chased.location.x,chased.location.y,chaser.location.x,chaser.location.y);
  if(dist <= chased.size/2 + chaser.size/2){
    //if dead
    screen.goToIndex(2);
    sendOscMessage("/endgame",1);
    sendOscMessage("/loose",1);
  }
  if(dist <= chased.size/2 + chaser.size/2 + 200){
    
    if( millis() > time_1 ){
      time_1 = millis() + 10000;
      sendOscMessage("/near",1);
    }
  }
  sendOscMessage("/distance",dist);
}


// just a verry simple debug mode
// update the boolean in the head to display it
void debug(){
  stroke(255);
  line(chased.location.x,chased.location.y,chaser.location.x,chaser.location.y);
}

// hadle all items dispatched in the screen
void items(){
  int sum = 0;
  int maxGenerators = 5;

  for(int i = 0; i < items.size(); i++){
    Item item = items.get(i);
    if(item.state == 2){
      sum ++;
    }
  }

  for(int i = 0; i < items.size(); i++){
    Item item = items.get(i);
    item.render();

    if (  _dist(  item.location,chased.location) <= item.size/2 +chased.size/2  ){
      if(item.state == 1 && item.state !=2){
        chased.feed();
        item.setState(2);

        if(sum < maxGenerators -1){
          addRandomItem();
        }
      }
    }
  }

  // if all generators < item > are lit on then display the exit 
  if(sum >= maxGenerators){
    exit.state = 1;
  }

}

// function handling the reception of any incoming osc event
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/rotation_vector/r3")) {
    float r3 = theOscMessage.get(0).floatValue();
    r = map(r3,-1,1,0,TWO_PI);
  }
  if (theOscMessage.addrPattern().equals("/rotation_vector/r1")) {
    float r2 = theOscMessage.get(0).floatValue();
    r1 = map(r2,-0.5,0.5,-1,1);
    r1 = constrain(r1,0,1);
  }
}

// function dealing with the arduino presure sensor
// millis() used to prevent spamming the rippleEmitter
void pressure(){
  if(pressureSonar > 180){
    if( millis() > time ){
      time = millis() + int(map(pressureSonar,10,1000,100,400));
      chased.emitRipple(pressureSonar);
    }
  }
}

// function responsible of sending osc messages
void sendOscMessage(String id, float value) {
  OscMessage myMessage = new OscMessage(id);
  myMessage.add(value); 
  oscP5.send(myMessage, myRemoteLocation);
}

// function responsible of sending osc messages
void sendOscMessage_A1(String id, float value) {
  OscMessage myMessage = new OscMessage(id);
  myMessage.add(value); 
  oscP5.send(myMessage, myRemoteLocation_A1);
}



// function dealing with all incoming  serial messages
// Parsing of the json and errors are handled here to prevent poluting the global scope.
void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');
      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {
          JSONObject json = parseJSONObject(inBuffer);
          println(inBuffer);
          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            rotPlayer = json.getInt("rotChased");
            pressureSonar = json.getInt("sonarChased");
            stepPlayer = json.getInt("stepChased") ;
          }
        } else {
          //@todo : maybe do something
        }
      }
    }
  } 
  catch (Exception e) {
    // catch all exeptions
    println(e);
  }
}
