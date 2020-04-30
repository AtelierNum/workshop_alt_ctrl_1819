void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {

      String inBuffer = myPort.readStringUntil('\n');

      //println(inBuffer);

      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {

          JSONObject json = parseJSONObject(inBuffer);

          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            //println("json ok");
            pot1    = json.getInt("pot1");
            shoot1    = json.getInt("shoot1");
            pot2    = json.getInt("pot2");
            shoot2    = json.getInt("shoot2");
         /*   print("pot 1 : " + pot1 + ", ");
            print("shoot1 : " + shoot1 + ", ");
            print("pot 2 : " + pot2 + ", ");
            println("shoot2 : " + shoot2 + ", ");*/
          }
        } else {
        }
      }
    }
  } 
  catch (Exception e) {
  }
}
