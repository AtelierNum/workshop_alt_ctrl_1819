#define BROCHE_POTENTIOMETRE_J1   A0 //potentiomètre branché sur analog A0

int etatlumino1;   //varioble pour l'état du la photo-résistance
int etatlumino2;   //varioble pour l'état du la photo-résistance


void setup() {
  Serial.begin(9600); // ouvrir la connexion série
  pinMode(BROCHE_POTENTIOMETRE_J1, INPUT);


}


void loop() {

  int lumino1 = analogRead(6); // on définit la photo-résistance 1 sur la variable lumin1, on lit la valeur sur la pin A0 et la stocker dans la variable 
  int lumino2 = analogRead(7);
    
  if (lumino1 >= 600) {      //quand la valeur de la photo-résistance atteint 600 (obscurité), etatlumino1 prend la valeur de 1
    etatlumino1 = 1;
  } else {
    etatlumino1 = 0 ;
  }

  if (lumino2 >= 600) {      //quand la valeur de la photo-résistance 2 atteint 600 (obscurité), etatlumino2 prend la valeur de 1
    etatlumino2 = 1;
  } else {
    etatlumino2 = 0 ;
  }



  int Pression_DroiteJ2 = analogRead(4); // lire la valeur sur la pin A4 (capteur pression droite J2) et la stocker dans une variable entière
  int Pression_GaucheJ2 = analogRead(5); // lire la valeur sur la pin A5 (capteur pression gauche J2) et la stocker dans une variable entière
  int Pression_DroiteJ1 = analogRead(2); // lire la valeur sur la pin A2 (capteur pression droite J1) et la stocker dans une variable entière
  int Pression_GaucheJ1 = analogRead(3); // lire la valeur sur la pin A3 (capteur pression gauche J1) et la stocker dans une variable entière
  int signal_potentiometreJ1; // conserver la valeur du potentiomètre
  signal_potentiometreJ1 = analogRead(BROCHE_POTENTIOMETRE_J1); // Prendre valeur du potentiomètre et les stocker 


  
  // communication vers processing on inscrivant données dans le port série
  Serial.print(Pression_DroiteJ2);
  Serial.print(",");
  Serial.print(Pression_GaucheJ2);
  Serial.print(",");
  Serial.print(signal_potentiometreJ1);
  Serial.print(",");
  Serial.print(Pression_DroiteJ1);
  Serial.print(",");
  Serial.print(Pression_GaucheJ1);
  Serial.print(",");
  Serial.print(lumino1); 
  Serial.print(",");
  Serial.print(lumino2); 
  Serial.print("\n");


}
