
int pot1 = A0;
int val1;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  val1 = analogRead(pot1);
  delay(100);

  String json;

  //json = "{\"controle\":{\"pot1\":";
  json = "{\"pot1\":";
  json = json + val1;
  json = json + "}";

  Serial.println(json);
} 
