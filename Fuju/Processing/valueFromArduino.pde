import processing.serial.*; //Import de Arduino vers processing
Serial myPort;

float valueFromArduino;
int bouton;

//Fonction récupérant les données
void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');
      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {
          JSONObject json = parseJSONObject(inBuffer);
          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            valueFromArduino    = json.getInt("valeurmicro");
            bouton    = json.getInt("bouton");
            //println(bouton);
          }
        } else {
        }
      }
    }
  } 
  catch (Exception e) {
  }
}
