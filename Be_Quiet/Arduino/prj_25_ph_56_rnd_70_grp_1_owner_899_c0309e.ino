/*
 *  Code for the Game "Be Quite" built during a 4 day workshop at L'école de design Nantes Atlantique 
 *  By Simon Renault, Martin Lamire, Christophe Le Conte, Andrews Kimbembe and Sébastien Reischek
 *  
 *  The processing code is require din order to run the game as well as the code made in puredata.
 *
 *  Most of the logic is handled in processing, stuff here is mostly reading raw sensors value and sending it.
 *
*/


void setup() {
  Serial.begin(9600);  // start the serial comunication with the computer
  pinMode(7, INPUT); //pin 7 as an input
}


void loop() {
  
  // Set pressure sensor value
  int pressSensorValue = analogRead(0); // Read the value of the pressure sensor. Will be used to trigger riples.
  
  // Set potentiometer value
  int potentValue = analogRead(2); // Read the value of the potentiometer. Will be used to controle the rotation
  
  //Set step player value
  int stepValue = digitalRead(7); // Read the value of the button. Will be used to trigger the walk behavior of the chased.

  // pack all the data in json format.
  String json;
  json = "{\"sonarChased\":";
  json = json + pressSensorValue;
  json = json + ",\"rotChased\":" + potentValue;
  json = json + ",\"stepChased\":" + stepValue;
  json = json + "}";

  // send the json to the main processing sketch
  Serial.println(json);
}
