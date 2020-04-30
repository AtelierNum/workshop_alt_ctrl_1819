[**home**](../README.md)

## SPLIT GAME

## Workshop Joypad - Mars 2019

*Raphaëlle Gorenbouh, Seohee Park, Anna Rabeony, Zemin Xu*

![40% center](images/Team_work.jpg)

## Index

1. Introduction
2. Cheminement de pensées
3. Scénario
4. Arcade Flyer
5. Principe de jeu
6. Mécanisme
7. Inspirations
8. Aides consultées pour le code
9. Extraits de code
10. Branchements
11. Maquette

## Introduction

Il nous a été demandé pour ce workshop transversal Interactivité et Game Design de 5 jours, de réaliser un jeu pouvant se jouer avec différentes interactions.

Avant d'arriver à notre idée finale, nous avons exploré plusieurs pistes. Nous voulions créer un jeu pouvant être jouer à plusieurs, alternant moments collaboratifs et en compétition.


## Cheminement de pensées

### Idée de jeu 1

Au départ, nous avions eu l'idée d'un jeu dont le parcours serait ponctué de choix à réaliser ainsi que de plusieurs mini-jeux. Nous avions pensé à un plateau physique modélisant une carte où les différents chemins auraient été tracés, ainsi qu'un un écran, placé à côté, qui aurait permis d'afficher les différents mini-jeux et choix à réaliser.

Pour cette première piste nous nous sommes inspiré de différentes mécaniques de jeu
[](http://www.lagamification.com/47-idees-mecanismes-et-elements-de-gamification/).

![40% center](images/schema_idee_jeu1.JPG)

Nous avions imaginé comme scénario à ce jeu, l'histoire d'un petit garçon qui devait rejoindre un chateau. À chaque étape, il aurait dû réaliser un choix de chemin et jouer à un mini-jeu spécifique à son choix. Chaque chemin aurait permis d'explorer un univers différent.
Par exemple pour commencer, le personnage devait traverser la forêt. Puis, il aurait dû traverser la rivière en marchant sur les cailloux instables ou en traversant en équilibre sur un rondin de bois.
Au fur et à mesure, il aurait à récupérer des clés parsemées dans le parcours, lui permettant d'accéder au château, le point d'arrivée. Nous voulions permettre au joueur de vivre une expérience, dans un univers immersif en lui racontant une histoire poétique.
  
Nous avons réalisé l'empleur de la réalisation d'un jeu pareil et cela nous a paru bien trop compliqué par sa complexité et la durée du workshop.

### Idée de jeu 2

Nous avons donc recherché des inspirations pour simplifier le jeu en gardant
le principe de parcours. Le jeu [Braid](https://www.youtube.com/watch?v=OiGU0GXQdKA) nous alors inspiré, en particulier le dernier niveau de ce jeu.
Dans ce niveau, on remarque d'abord deux plans séparés, une princesse sur le niveau du haut et un chevalier sur celui du bas. Pour avancer dans le jeu, les deux joueurs doivent s'entraider (la princesse peut faire tomber un pont levis, faire descendre une échelle afin de libérer la voie pour le chevalier ne bas). Arrivés au bout du parcours (vers la droite), ils doivent revenir au début du parcours (refaire le parcours à l'envers vers la gauche). La logique de jeu s'inverse alors : la princesse en haut à pour but de placer les obstacles de manière cette fois à bloquer le chevalier.

![40% center](images/Braid.PNG) 

Nous nous sommes également inspiré de d'autres jeux comme 
[Limbo](https://www.youtube.com/watch?v=wUc7hQvBdNs)
[Inside]( https://www.youtube.com/watch?v=vPcolQbesz4)
[Ori and the blind forest](https://www.youtube.com/watch?v=Wh6gBjfXKxw) [MarioGame](http://processingjs.nihongoresources.com/test/PjsGameEngine/docs/tutorial/mario.html).
   
Nous avons voulu utilisé ce principe d'entraide et de rivalité en l'incluant dans l'univers d'une ville sous-marine.
Pour le scénario, nous avions pensé à l'histoire de deux frères qui partent à la recherche du trésor perdu dans les ruines d’une ville ravagée par l’eau suite à la chute d'un barrage. Ils partent donc à la recherche de ce trésor ensemble (partie collaboration), ils traversent le lac et trouve le trésor (pièces éparpillées dans l’eau). Mais sur le chemin du retour une rivalité naît, seul un des deux frères pourra remonter à la surface avec le trésor.
Il y avait donc un mode collectif lorsque les joueurs se dirigent vers la droite et lorsque ce parcours est terminée, le mode versus démarre, vers la gauche. À la fin du jeu un dernier choix aurait été proposé aux joueurs : il doit choisir de remonter à la surface avec le trésor et abondonner son frère ou abandonner le trésor et remonter avec son frère.

Suite à un temps d'échange avec les enseignants, nous en avons conlus que notre jeu était encore complexe dans sa réalisation.


### Idée de jeu 3

Nous avons donc décidé de simplifier une fois de plus notre idée, en mettant de côté l'histoire.
Nous voulions garder le mode de jeu en collectif et l'alternance entre collaboratif et rivalité.

Pour montrer cette opposition entre les deux joueurs nous avons décidé de poser l'écran de jeu à l'horizontal, en plaçant les joueurs de part et d'autre de l'écran.

L'écran est donc séparé en deux partie ayant sa propre gravité pour que chaque joueur fasse son propre parcours. 

Un système de plateforme amovible commune au deux parcours permettrait d'aider et de mettre en difficulté le joueur opposé.

Ce jeu démarrera en mode colletif, vers la droite, dans laquel les deux joueurs sont obligés de s'entraider pour avancer, puis une fois arrivé à la fin, le jeu recommence vers la gauche en mode versus.

![40% center](images/schema_Split_game.png)


### Idée de jeu final

Pour finir, nous avons gardé le mode de jeu en collectif mais nous avons mis de côté l'alternance entre les modes collaboratif et compétition pour ne garder que le mode collaboratif. Les deux joueurs sont donc obligés de s'entraider pour terminer le jeu.

Nous avons gardé l'idée de l'écran séparé en deux parties. Pour plus de complexité chaque joueur intervient dans une des deux partie de l'écran.


![40% center](images/dessin_jeu_final.png)



## Scénario

Chaque joueur est positionné d'un côté de l'écran posé à l'horizontal. Une manette de jeu est positionnée face à chaque joueur. Les manettes comportent chacune deux capteurs de pression (pour faire avancer le petit personnage vers la droite ou la gauche) et une photo-résistance (permettant de faire sauter le personnage) qui fonctionne comme un bouton mais en jouant avec le fait de cacher la lumière et qui est sera positionnée au niveau du pied de chaque joueur.
Un potentiomètre permettant de faire monter ou descendre des plateformes amovibles sera géré par un troisième joueur.

L'écran est partagé en deux. Chaque joueur incarne un petit personnage dans la moitié de l'écran. La difficulté sera pour le joueur 1 qui devra contrôler son personnage à l'envers (en haut de l'écran). Un troisième joueur contrôlera la position des plateformes amovibles qui aideront les deux joueurs à évoluer sur le parcours.


## Arcade player png

![](images/flyer_arcade1.png)

![](images/flyer_arcade2.png)
  
## Principe de jeu

The Split Game est un jeu de plateforme à trois joueurs et qui se joue en collaboration. Deux joueurs évoluent chacun sur une plateforme, dont un qui se retrouve la tête à l'envers. Le troisième joueur contrôle les plateformes amovibles pour aider les deux joueurs. La partie est gagnée uniquement quand les deux joueurs ont au moins deux points. Ce jeu nécessite donc de la communication et de la coopération entre les joueurs.
 
## Mécanisme du jeu
Les deux premiers joueurs contrôlent leur personnages à l'aide des capteurs de pression pour se diriger vers la droite ou la gauche. Ils peuvent sauter en posant leur pied sur la pédale avec la photo-résistance : en plaçant le pied, il cache la photo-résistance de la lumière, celle-ci renvoit donc une valeur (ici, supérieur à un seuil de 600) qui déclenchera un saut. Le troisième joueur utilise le potentiomètre à la même manière d'un slider pour faire bouger les plateformes amovibles


## Code - liaison Arduino et Processing

### Librairie Processing utilisés

* Fisica --> Pour créer des objets et des personnages_  
* Processing.Serial* --> Pour faire communiquer les données entre Arduino et Processing

### Code Arduino
Serial.print() va nous permettre d'écrire des variables dans le port série. On sépare chaque variables par une virgule pour les dissocier.

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


### Code Processing
On récupère les variables dans une fonction void serialEvent sous forme de tableau.

	if (list.length == 7) {
        Pression_DroiteJ2 = float(list[0]);
        Pression_GaucheJ2 = float(list[1]);
        signal_potentiometreJ1 = float(list[2]);
        Pression_DroiteJ1 = float(list[3]);
        Pression_GaucheJ1 = float(list[4]);
        lumino1 = float(list[5]);
        lumino2 = float(list[6]);
      } 



### Quelques ressources consultées pour le code

|Nom  | lien |
| ------ | ------ |
| Score | [CSDA, RLHaides, "Small game processing implementation"](https://blog.csdn.net/RALPHFJY/article/details/70186787?fbclid=IwAR26QFIIYvlmBKP_8Wmkj9fkp1GeRgEVNX941OFhgA29iCB6i_p9G5WIvC8) |
| Saut | [John McCaffrey, "programming platform and jump using processing"](https://www.youtube.com/watch?v=c9ZxyS2vyiM) |
| Branchement Arduino| [Github de Bérenger Recoules](https://github.com/b2renger/Introduction_arduino#fsr) |
| Code Processing| [Processing.org, documentation d'aide du logiciel Processing](https://processing.org/reference/) |
| Communication Arduino avec Processing| [Document mis à notre disposition sur le cloud](https://cloud.lecolededesign.com/index.php/apps/files/?dir=/Workshop%20Joypad/1%20-%20Ressources/arduino_1819&fileid=2117189) |
| Documentation bibliothèque Fisica| [Ricard Marxer, Fisica](https://cloud.lecolededesign.com/index.php/apps/files/?dir=/Workshop%20Joypad/1%20-%20Ressources/arduino_1819&fileid=2117189) |




## Branchements

### Liste complète des matériaux électroniques pour le montage final

| Élement  | Quantité |
| ------ | ------ |
| Potentiomètre | 1 |
| Arduino FSR406 Pressure Sensor | 2 par joueur x 2 |
| Résistance 47 kilo ohms | 4  |
| Résistance 10 kilo ohms | 2  |
| Carte Arduino MEGA 2560 | 1 |


#### Les capteurs de pression

Les capteurs de pression permettront aux joueurs de se déplacer de droite à gauche en fonction de la pression exercée sur les capteurs. Chaque joueur possède 2 capteurs de pression.

Pour le branchement d'un capteur de pression : 

* 1 capteurs de pression
* 1 résistances 47 kilo ohms
* 5 fils

Branchement des deux capteurs de pression pour un joueur :

![40% center](images/capteur_pression.png)


#### Le potentiometre
Le potentiometre permet de bouger les plateformes permettant aux joueurs d'avancer.

Pour le branchement d'un capteur de pression : 

* 1 potentiomètre
* 3 fils

![40% center](images/potentiometre.PNG)

#### Le capteur de luminosité
Le capteur de luminosité, placé au sol, permet au joueur de déclancher l'action de faire sauter son personnage lorsqu'il cache la lumière avec son pied.

Pour le branchement d'un capteur de luminosité : 

* 1 photo-résistance LDR
* 1 résistance 10 kilo ohms

![40% center](images/photoresistance.png)

#### Tous les branchements pour 1 joueur
Voici le montage de tous les capteurs pour un seul joueur.

Pour le branchement d'un capteur de pression : 

* 1 potentiomètre
* 2 capteurs de pression
* 1 photo-résistance
* 2 résistances 47 kilo ohms
* 1 résistance 10 kilo ohms
* 8 fils

![40% center](images/pression-potentiometre-lumiere-1joueur.png)

#### Branchement complet du jeu
Pour le branchement complet du jeu, il faut prendre une carte arduino Mega 2560.

* 1 potentiomètre
* 4 capteurs de pression
* 2 photo-résistances
* 4 résistances 47 kilo ohms (pour les capteurs de pression)
* 1 résistance 10 kilo ohms (pour les photo-résistances)
* 32 fils

![40% center](images/pression4-potentiometre1-lumeres2-2joueurs.png)



## Maquette

### Liste des matériaux pour la maquette

|Nom  | Nombre |
| ------ | ------ |
| Ecran posé à l'horizontal | 1  |
| Planche de carton plume blanche | 1  |
| Planche de carton plume noire | 1  |
| Scotch noir | 1  |
| Scotch double-face | 1  |
| Graphismes imprimés (nom des joueurs)| 1  |




#### Patron de la maquette pour les capteurs de pression (table)

_Patron_ 
![40% center](images/patron_pression_papier.JPG)
![40% center](images/patron_pression1.png)

_Découpe_ 
![40% center](images/boite_capteur_pression.JPG)

_Boitiers finaux_
![40% center](images/boiteJ1.JPG)
![40% center](images/boiteJ2.JPG)



#### Patron de la maquette pour le potentiomètre (sur la table)

_Patron_
![40% center](images/patron_potentiometre.JPG)
![40% center](images/patron_potentiometre_1.png)

_Photo boitier final_ 
![40% center](images/boitier_potentiometre.JPG)

#### Patron de la maquette pour la photo-résistance (au sol)

_Patron_
![40% center](images/patron_resistance.png)

_Photo boitier final_
![40% center](images/photoresistance.JPG)



#### Prototype de tous les capteurs
![40% center](images/capteurs_finaux.JPG)




## Prototype final

![](images/GIF_SplitGame.gif)

![40% center](images/SplitGame1.JPG)
![40% center](images/SplitGame2.JPG)
![40% center](images/SplitGame3.JPG)
![40% center](images/Joueurs.JPG)



## Remerciements

Merci à Pierre Commenge, Edouard Durand, Thomas François, Clément Gault, et Bérenger Recoules pour leur aide et leur patience.

[**home**](../README.md)
