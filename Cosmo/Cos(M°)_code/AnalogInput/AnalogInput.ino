#include <EasyButton.h>

// on cree toutes les variables


int pot1Pin = 0;
int pot1 = 0;  // variable to store the value coming from the sensor
float pot1Mapped = 0;

int pot2Pin = 1;
int pot2 = 0;  // variable to store the value coming from the sensor
float pot2Mapped = 0;


int btn1Pin = 4;
EasyButton button1(btn1Pin);

int btn2Pin = 7;
EasyButton button2(btn2Pin);

int btn1 = 0;
int btn1old = 0;
int shoot1 = 0;

int btn2 = 0;
int btn2old = 0;
int shoot2 = 0;


void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(pot1Pin, INPUT);
  pinMode(pot2Pin, INPUT);
  Serial.begin(9600);
  button1.begin();
  button2.begin();
}

void loop() {


  // on map les valeurs car le controleur n'utilise pas toute la course des potentiometres 
  pot1 = analogRead(pot1Pin);
  pot1Mapped = map(pot1, 930, 720, 0, 1000);

  pot2 = analogRead(pot2Pin);
  pot2Mapped = map(pot2,940, 715, 0, 1000);

  btn1old = btn1;
  btn1 = button1.read();
  if (btn1old == !btn1) {
    shoot1 = 1;
  } else {
    shoot1 = 0;
  }


  btn2old = btn2;
  btn2 = button2.read();
  if (btn2old == !btn2) {
    shoot2 = 1;
  } else {
    shoot2 = 0;
  }

/*Serial.print("btn2old = ");
Serial.print(btn2old);
Serial.print("; btn2 = ");
Serial.println(btn2);*/


  /* Serial.print("btn1old = ");
    Serial.print(btn1old);
    Serial.print("; btn1 = ");
    Serial.print(btn1);
    Serial.print("; shoot1 = ");
    Serial.print(shoot1);
    Serial.println(";");
  */

 // Serial.println(pot1);

  String json;

  //json = " {\"controle\":{\"pot1\":";
  json =        "{\"pot1\":";
  json = json + pot1Mapped;
  json = json + ",\"shoot1\":";
  json = json + shoot1;
  json = json + ",\"pot2\":";
  json = json + pot2Mapped;
  json = json + ",\"shoot2\":";
  json = json + shoot2;
  /*json = json + ",\"pot5\":";
    json = json + val5;
    json = json + ",\"pot6\":";
    json = json + val6;
    json = json + ",\"bouton1\":";
    json = json + b1;
    json = json + ",\"bouton2\":";
    json = json + b2;
    json = json + ",\"bouton3\":";
    json = json + b3; */
  json = json + "}";

  Serial.println(json);


  // stop the program for for <sensorValue> milliseconds:

}
