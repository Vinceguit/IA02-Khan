/************************************/
/**Initialisation du plateau de jeu**/
/************************************/

/****PRINCIPAL****/
/*Etat initial du plateau de jeu*/
etatInitial([[(2, b),(3, b),(1, b),(2, b),(2, b),(3, b)],
          	 [(2, b),(1, b),(3, b),(1, b),(3, b),(1, b)],
          	 [(1, b),(3, b),(2, b),(3, b),(1, b),(2, b)],
             [(3, b),(1, b),(2, b),(1, b),(3, b),(2, b)],
             [(2, b),(3, b),(1, b),(3, b),(1, b),(3, b)],
             [(2, b),(1, b),(3, b),(2, b),(2, b),(1, b)]]).

/*Prédicat d'initialisation du plateau, à appeler dans le programme principal*/
initBoard(Board) :-	etatInitial(BoardInit),
                    afficherPlateau(BoardInit),
					          lireCote(Cote),
					          initCouleur(BoardInit, Cote, rouge, BoardInter),
                    oppose(Cote, CoteOpp),
                    initCouleur(BoardInter, CoteOpp, ocre, Board).



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
lireCote(X) :- print('Quel cote choisir ?'), nl, read(X), cote(X).



/****INITIALISATION DES PIONS****/
/*Initialisation des pions d'une couleur; c'est lui qu'on appelle dans initBoard*/
initCouleur(InBoard, Cote, rouge, OutBoard) :- placerPion(InBoard, Cote, kr, Board1),
                                               placerPion(Board1, Cote, r1, Board2),
                                               placerPion(Board2, Cote, r2, Board3),
                                               placerPion(Board3, Cote, r3, Board4),
                                               placerPion(Board4, Cote, r4, Board5),
                                               placerPion(Board5, Cote, r5, OutBoard).

initCouleur(InBoard, Cote, ocre, OutBoard) :- placerPion(InBoard, Cote, ko, Board1),
                                              placerPion(Board1, Cote, o1, Board2),
                                              placerPion(Board2, Cote, o2, Board3),
                                              placerPion(Board3, Cote, o3, Board4),
                                              placerPion(Board4, Cote, o4, Board5),
                                              placerPion(Board5, Cote, o5, OutBoard).

/*Placement d'un pion*/
placerPion(InBoard, Cote, TypePion, OutBoard) :-
  initPion(Cote, TypePion, Lin, Col),
  checkNonOccupe(Lin, Col, InBoard),
  remplacer(InBoard, Lin, Col, TypePion, OutBoard),
  afficherPlateau(OutBoard).

/****initPion****/
/*On récupère les positions des pions entrées par l'utilisateur*/
initPion(Cote, kr, Lin, Col) :- print('Kalista rouge'), nl,
                                lirePosInitiale(Cote, Lin, Col).
initPion(Cote, ko, Lin, Col) :- print('Kalista ocre'), nl,
                                lirePosInitiale(Cote, Lin, Col).
initPion(Cote, TypePion, Lin, Col) :- element(TypePion, [r1, r2, r3, r4, r5]),
                                      print('Sbire rouge'), nl,
                                      lirePosInitiale(Cote, Lin, Col).
initPion(Cote, TypePion, Lin, Col) :- element(TypePion, [o1, o2, o3, o4, o5]),
                                      print('Sbire ocre'), nl,
                                      lirePosInitiale(Cote, Lin, Col).

/*Lecture ligne et colonne + vérification du côté*/
lirePosInitiale(Cote, Lin, Col) :- print('Ligne ?'), nl, read(Lin), nl,
                                   print('Colonne ?'), nl, read(Col), nl,
                                   checkCote(Cote, Lin, Col).

/*On vérifie si les pions sont placés du bon côté */
checkCote(gauche, Lin, Col) :- Lin > 0, Lin < 7, Col > 0, Col < 3 .
checkCote(droite, Lin, Col) :- Lin > 0, Lin < 7, Col > 4, Col < 7 .
checkCote(haut, Lin, Col) :- Lin > 0, Lin < 3, Col > 0, Col < 7 .
checkCote(bas, Lin, Col) :- Lin > 4, Lin < 7, Col > 0, Col < 7 .


/****checkNonOccupe****/
/*On vérifie que la case où l'on veut placer le pion n'est pas déjà occupée*/
/*On trouve la ligne*/
checkNonOccupe(1, Col, [Ligne|_]) :- checkNonOccupeDansLigne(Col, Ligne).
checkNonOccupe(Lin, Col, [_|Q]) :- Lin > 0, NLin is Lin - 1, checkNonOccupe(NLin, Col, Q).
/*On trouve la colonne*/
checkNonOccupeDansLigne(1, [(_, b)|_]).
checkNonOccupeDansLigne(Col, [_|Q]) :- Col > 0, NCol is Col - 1, checkNonOccupeDansLigne(NCol, Q).


/****remplacer****/
/*Placement d'un pion en remplacant la valeur 'b' dans le tableau initial*/
/*On trouve la ligne*/
remplacer([T|Q], 1, Col, X, [Ligne|Q]) :- remplacerDansLigne(T, Col, X, Ligne).
remplacer([T|Q], Lin, Col, X, [T|Res]) :- Lin > 0, NLin is Lin-1, remplacer(Q, NLin, Col, X, Res), !.
remplacer(L, _, _, L).
/*On trouve la colonne*/
remplacerDansLigne([(Val, b)|Q], 1, X, [(Val, X)|Q]).
remplacerDansLigne([T|Q], Col, X, [T|Res]) :- Col > 0, NCol is Col-1, remplacerDansLigne(Q, NCol, X, Res), !.
remplacerDansLigne(L, _, _, L).
