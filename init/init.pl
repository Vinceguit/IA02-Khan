/************************************/
/**Initialisation du plateau de jeu**/
/************************************/

/***IMPORTS****/
/*Import des prédicats d'initialisation pour un humain*/
:- include('./human').
/*Import des prédicats d'initialisation pour une machine*/
:- include('./machine').


/****CHOIX DES JOUEURS (Humain/Machine)****/
typePlayer(humain).
typePlayer(machine).
initPlayers :- retractall(player(_, _)), getPlayer(rouge), getPlayer(ocre).
getPlayer(Colour) :- print('Joueur '), print(Colour), print(' : humain ou machine ?'), nl,
                     read(Player),
                     testPlayer(Player, Colour).

testPlayer(Player, Colour) :- typePlayer(Player), asserta(player(Player, Colour)), !.
testPlayer(_, _) :-  print('Erreur de saisie'), !, fail.


/****PRINCIPAL****/

/*Etat initial du plateau de jeu*/
etatInitial([[(2, b),(3, b),(1, b),(2, b),(2, b),(3, b)],
             [(2, b),(1, b),(3, b),(1, b),(3, b),(1, b)],
             [(1, b),(3, b),(2, b),(3, b),(1, b),(2, b)],
             [(3, b),(1, b),(2, b),(1, b),(3, b),(2, b)],
             [(2, b),(3, b),(1, b),(3, b),(1, b),(3, b)],
             [(2, b),(1, b),(3, b),(2, b),(2, b),(1, b)]]).

/*Prédicat d'initialisation du plateau, à appeler dans le programme principal*/
initBoard(Board) :- setListePions,
                    player(J1, rouge), player(J2, ocre),
                    etatInitial(BoardInit),
                    afficherPlateau(BoardInit),
                    initCouleur(BoardInit, Cote, rouge, J1, BoardInter),
                    oppose(Cote, CoteOpp),
                    initCouleur(BoardInter, CoteOpp, ocre, J2, Board), !.


/****CÔTÉS****/
/*Déclaration des côtés valides*/
cote(gauche).
cote(droite).
cote(haut).
cote(bas).

/*Déclaration de l'opposé de chaque côté (pour avoir le côté de la couleur ocre)*/
oppose(gauche, droite).
oppose(droite, gauche).
oppose(haut, bas).
oppose(bas, haut).

/*Lecture du côté*/
lireCote(Cote) :- print('Quel cote choisir ?'), nl, read(Cote), cote(Cote), !.
lireCote(_) :- print('Erreur de saisie'), nl, !, fail.

/*Génération aléatoire d'un côté*/
convertToCote(1, gauche).
convertToCote(2, droite).
convertToCote(3, haut).
convertToCote(4, bas).
randomCote(Cote) :- random(1, 5, Rand), convertToCote(Rand, Cote),
                    print('Cote choisi par la machine : '), print(Cote), nl.


/****INITIALISATION DES PIONS****/
/*Initialisation des pions d'une couleur; c'est lui qu'on appelle dans initBoard*/
initCouleur(InBoard, Cote, rouge, humain, OutBoard) :- lireCote(Cote),
                                                       placerPions(InBoard, Cote, rouge, OutBoard), !.

initCouleur(InBoard, Cote, ocre, humain, OutBoard) :- placerPions(InBoard, Cote, ocre, OutBoard), !.

initCouleur(InBoard, Cote, rouge, machine, OutBoard) :- randomCote(Cote),
                                                        placerPionsIA(InBoard, Cote, rouge, OutBoard), !.

initCouleur(InBoard, Cote, ocre, machine, OutBoard) :- placerPionsIA(InBoard, Cote, ocre, OutBoard), !.
