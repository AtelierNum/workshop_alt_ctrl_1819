#include "EasyButton.h" //EasyButton pour utiliser le bouton Start

EasyButton BUTTON_START(8);
int button = 0;
int value = 0;

void setup() {
  Serial.begin(9600);

  //Initialise le bouton START et sa fonction BUTTON_PRESS lorsque l'on appuie
  BUTTON_START.begin();
  BUTTON_START.onPressed(BUTTON_PRESS);
}

void loop() { //On envoie les valeurs du bouton et du micro via du json

  value = analogRead(A0);
  String json;
  json = "{\"valeurmicro\":";
  json = json + value;
  json = json + ",";
  json = json + "\"bouton\":";
  json = json + button;
  json = json + "}";

  BUTTON_START.read(); //On lit l'état du bouton

  Serial.println(json);
}

//Permet de démarrer une nouvelle partie lorsque l'on appuie sur le Bouton Start
void BUTTON_PRESS() {
  Serial.println("Nouvelle partie");
  button = 1;
  String json;
  json = "{\"valeurmicro\":";
  json = json + value;
  json = json + ",";
  json = json + "\"bouton\":";
  json = json + button;
  json = json + "}";
  Serial.println(json);
  delay(500);
  button = 0;
}
