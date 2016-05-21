/************************************/
/**Initialisation du plateau de jeu**/
/************************************/

/*Prédicat d'initialisation du plateau, à appeler dans le programme principal*/

initBoard(Board) :-	afficherPlateau([[(2, b),(3, b),(1, b),(2, b),(2, b),(3, b)],
          									         [(2, b),(1, b),(3, b),(1, b),(3, b),(1, b)],
          									         [(1, b),(3, b),(2, b),(3, b),(1, b),(2, b)],
                            				 [(3, b),(1, b),(2, b),(1, b),(3, b),(2, b)],
                            			   [(2, b),(3, b),(1, b),(3, b),(1, b),(3, b)],
                            				 [(2, b),(1, b),(3, b),(2, b),(2, b),(1, b)]]),
					          lireCote(Cote),
					          initCouleur([[(2, b),(3, b),(1, b),(2, b),(2, b),(3, b)],
          									     [(2, b),(1, b),(3, b),(1, b),(3, b),(1, b)],
          									     [(1, b),(3, b),(2, b),(3, b),(1, b),(2, b)],
          									     [(3, b),(1, b),(2, b),(1, b),(3, b),(2, b)],
                                 [(2, b),(3, b),(1, b),(3, b),(1, b),(3, b)],
          									     [(2, b),(1, b),(3, b),(2, b),(2, b),(1, b)]], Cote, rouge, Board),
					          afficherPlateau(Board).

/*Initialisation des pions*/
cote(gauche).
cote(droite).
cote(haut).
cote(bas).

oppose(gauche, droite).
oppose(droite, gauche).
oppose(haut, bas).
oppose(bas, haut).

lireCote(X) :- print('Quel cote choisir ?'), nl, read(X), cote(X).

initCouleur(InBoard, Cote, rouge, OutBoard) :- placerPion(InBoard, Cote, kr, OutBoard).

placerPion(InBoard, Cote, TypePion, OutBoard) :- initPion(Cote, TypePion, Lin, Col), remplacer(InBoard, Lin, Col, TypePion, OutBoard).

/*Placement d'un pion en remplacant la valeur 'b' dans le tableau initial
On trouve la ligne*/
remplacer([T|Q], 0, Col, X, [Ligne|Q]) :- remplacerDansLigne(T, Col, X, Ligne).
remplacer([T|Q], Lin, Col, X, [T|Res]) :- Lin > -1, NLin is Lin-1, remplacer(Q, NLin, Col, X, Res), !.
remplacer(L, _, _, L).
/*On trouve la colonne*/
remplacerDansLigne([(Val, b)|Q], 0, X, [(Val, X)|Q]).
remplacerDansLigne([T|Q], Col, X, [T|Res]) :- Col > -1, NCol is Col-1, remplacerDansLigne(Q, NCol, X, Res), !.
remplacerDansLigne(L, _, _, L).


/*On récupère les positions des pions entrées par l'utilisateur*/
initPion(Cote, kr, Lin, Col) :- print('Kalista rouge'), nl, lirePosInitiale(Cote, Lin, Col).
initPion(Cote, ko, Lin, Col) :- print('Kalista ocre'), nl, lirePosInitiale(Cote, Lin, Col).
initPion(Cote, r, Lin, Col) :- print('Sbire rouge'), nl, lirePosInitiale(Cote, Lin, Col).
initPion(Cote, o, Lin, Col) :- print('Sbire ocre'), nl, lirePosInitiale(Cote, Lin, Col).

lirePosInitiale(Cote, Lin, Col) :- print('Ligne ?'), nl, read(Lin), nl, print('Colonne ?'), nl, read(Col), nl, checkCote(Cote, Lin, Col).
/*On vérifie si les pions sont placés du bon côté */
checkCote(gauche, Lin, Col) :- Lin > 0, Lin < 7, Col > 0, Col < 3 .
checkCote(droite, Lin, Col) :- Lin > 0, Lin < 7, Col > 4, Col < 7 .
checkCote(haut, Lin, Col) :- Lin > 0, Lin < 3, Col > 0, Col < 7 .
checkCote(bas, Lin, Col) :- Lin > 4, Lin < 7, Col > 0, Col < 7 .
