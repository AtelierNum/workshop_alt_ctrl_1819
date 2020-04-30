int digitalPin2 = 2;
int digitalPin3 = 3;
int digitalPin4 = 4;
int digitalPin13 = 13;

int digitalPin8 = 8;
int digitalPin9 = 9;
int digitalPin10 = 10;

int analogPin14 = 14;

int bouton1 = 0;
int bouton2 = 0;
int bouton3 = 0;

int ready2 = 0;

int led1 = 0;
int led2 = 0;
int led3 = 0;

float pot1 = 0;
float tourner2 = 0;
int etatBouton1 = 0;
int etatBouton2 = 0;
int etatBouton3 = 0;
int etatLed1 = 0;
int etatLed2 = 0;
int etatLed3 = 0;

int start2 = 0;
 
void setup() {
  Serial.begin(9600);
  pinMode(digitalPin2,INPUT);
  pinMode(digitalPin3,INPUT);
  pinMode(digitalPin4,INPUT);
  pinMode(digitalPin13,INPUT);
  
  pinMode(digitalPin8,OUTPUT);
  pinMode(digitalPin9,OUTPUT);
  pinMode(digitalPin10,OUTPUT);
  
  pinMode(analogPin14,INPUT);
 
}
 
void loop() {
  bouton1 = digitalRead(digitalPin4);
  bouton2 = digitalRead(digitalPin3);
  bouton3 = digitalRead(digitalPin2);
  ready2 = digitalRead(digitalPin13);

  led1 = digitalRead(digitalPin8);
  led2 = digitalRead(digitalPin9);
  led3 = digitalRead(digitalPin10);

  digitalWrite(digitalPin8,LOW);
  digitalWrite(digitalPin9,LOW);
  digitalWrite(digitalPin10,LOW);

  if(bouton1 == HIGH){
    etatBouton1 = 1;
  }
  if(etatBouton1 == HIGH){
    digitalWrite(digitalPin8,HIGH);
    etatLed1 = 1;
  }

  if(bouton2 == HIGH){
    etatBouton2 = 1;
  }
  if(etatBouton2 == HIGH){
    digitalWrite(digitalPin9,HIGH);
    etatLed2 = 1;
  }

  if(bouton3 == HIGH){
    etatBouton3 = 1;
  }
  if(etatBouton3 == HIGH){
    digitalWrite(digitalPin10,HIGH);
    etatLed3 = 1;
  }

  if(etatLed1 == 1 && etatLed2 == 1 && etatLed3 == 1){
   delay(200);
  digitalWrite(digitalPin8,LOW);
  etatLed1 = 0;
  etatBouton1 = 0;
  digitalWrite(digitalPin9,LOW);
  etatLed2 = 0;
  etatBouton2 = 0;
  digitalWrite(digitalPin10,LOW);
  etatLed3 = 0;
  etatBouton3 = 0;
  start2 = 10;
  }

start2 -= 1;
  
  pot1 = analogRead(analogPin14);
 
  tourner2 = map(pot1,0,1023,-100,100);
  tourner2 = tourner2/100;

  
  String json;
  json = "{\"arduino2\":{\"tourner2\":";
  json = json + tourner2;
  json = json + ",\"start2\":";
  json = json + start2;
  json = json + ",\"ready2\":";
  json = json + ready2;
  json = json + "}}";

  Serial.println(json);
  
  start2 = 0;
  delay(10);
}
