
![Alt Text](img/bandeau.jpg)


![Alt Text](img/gif_cosmo_1.gif)
	
	Cos(M°) en test publique 

![Alt Text](img/a_propos.jpg)





# Le principe

Cos(M°) vous propose de de transposer vos meilleurs souvenirs de space shooter dans une borne d'arcade revisitée. Cosm(M°) traduit l'orientation de votre guidon ainsi que les secousses que vous lui faites subir en direction et en tir. L'immersion est à bout de doigt.

# Le matériel
Afin de réaliser le projet Cos(M°), vous aurez besoins des matériaux suivants.

|Composants Electroniques|nombre     |
|----------------|-------------------------------|
|Capteurs TILT|2
|Carte Arduino uno|1
|Résistance  100kΩ      |2|
|Breadbord         |1


|Matériaux Bruts|nombre     |
|----------------|-------------------------------|
|Planche 37x9cm|2
|Planche 9x3cm|8
|Planche 18x10cm|2
|Colle à bois|∞




# Code Arduino

Le code :

Commençons par inclure au début du programme, la bibliothèque "EasyButton.h" pour prendre en charge nos deux potentiomètres :

    #include <EasyButton.h>
    
On déclare nos quatre capteurs d'entrée ainsi que les variables de stockage de données :
	    
	#include <EasyButton.h>
	
	// on cree toutes les variables
	
	
	int pot1Pin = 0;
	int pot1 = 0;  
	float pot1Mapped = 0;
	
	int pot2Pin = 1;
	int pot2 = 0;  
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
	  pinMode(pot1Pin, INPUT);
	  pinMode(pot2Pin, INPUT);
	  Serial.begin(9600);
	  button1.begin();
	  button2.begin();
	}

On map ensuite les valeurs minimales et maximales souhaitées des potentiomètres :    
     
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
	
	
	
	  String json;
	
	  json =        "{\"pot1\":";
	  json = json + pot1Mapped;
	  json = json + ",\"shoot1\":";
	  json = json + shoot1;
	  json = json + ",\"pot2\":";
	  json = json + pot2Mapped;
	  json = json + ",\"shoot2\":";
	  json = json + shoot2;
	 
	  json = json + "}";
	
	  Serial.println(json);
	
	
	
	}
	
	
# Code Source
Retrouvez le code source dans le dossier Cos(M°)_code.



# Construction de la maquette
Un travail conséquent à été effectué pour que le guidon profite d'une ergonomie hors normes :

Pour commencer voici les cotes de découpe des pièces en bois dont vous aurez besoin :

![image](img/découpe.png)


Voici le manuel de fabrication des pièces en bois qui forment le guidon, fixé sur un axe, ici une chaise :


![image](img/guidon.png)

Voici pour vous aider, une plaque empiécée vous indiquant comment optimiser les découpe de tout les pièces :

![image](img/tableau_de_découpe.png)













# Schéma du circuit électronique 

Ci dessous le schéma du montage électronique de la carte Arduino pour un joueur de Cos(M°) composé d'un capteur tilt et d'un potentiomètre.

![image](img/Schéma_montage_.png)


# Scénario
Ci dessous le déroulé d'une partie de Cos(M°). 

![Alt Text](img/Diagramme_partie.png)


# Scénographie
Le cadre de présentation de Cos(M°) est plongé dans l'obscurité, les dux joueurs sont cote à cote face à un écran surelevé entouré de deux enceintes. Les joueurs sont pisitionnés "à cheval" sur leurs chaises.

![Alt Text](img/scénographie.png)
![Alt Text](img/gif_cosmo_2.gif)
	
	fin de la partie