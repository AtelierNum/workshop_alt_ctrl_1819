int digitalPin8 = 8;
int digitalPin9 = 9;
int digitalPin10 = 10;
int digitalPin11 = 11;

int boutonSpect1 = 0;
int boutonSpect2 = 0;
int boutonSpect3 = 0;
int boutonSpect4 = 0;

void setup() {
  Serial.begin(9600);
  pinMode(digitalPin8,INPUT);
  pinMode(digitalPin9,INPUT);
  pinMode(digitalPin10,INPUT);
  pinMode(digitalPin11,INPUT);

}

void loop() {
  boutonSpect1 = digitalRead(digitalPin8);
  boutonSpect2 = digitalRead(digitalPin9);
  boutonSpect3 = digitalRead(digitalPin10);
  boutonSpect4 = digitalRead(digitalPin11);
  
  String json;
  json = "{\"arduino3\":{\"boutonSpect1\":";
  json = json + boutonSpect1;
  json = json + ",\"boutonSpect2\":";
  json = json + boutonSpect2;
  json = json + ",\"boutonSpect3\":";
  json = json + boutonSpect3;
  json = json + ",\"boutonSpect4\":";
  json = json + boutonSpect4;
  json = json + "}}";

  Serial.println(json);
  delay(10);
}
