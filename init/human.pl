/*Placement des pions d'une couleur : prédicat appelé dans l'initialisation*/
placerPions(InBoard, Cote, rouge, OutBoard) :- placerPion(InBoard, Cote, kr, Board1),
                                               placerPion(Board1, Cote, r1, Board2),
                                               placerPion(Board2, Cote, r2, Board3),
                                               placerPion(Board3, Cote, r3, Board4),
                                               placerPion(Board4, Cote, r4, Board5),
                                               placerPion(Board5, Cote, r5, OutBoard).

placerPions(InBoard, Cote, ocre, OutBoard) :- placerPion(InBoard, Cote, ko, Board1),
                                              placerPion(Board1, Cote, o1, Board2),
                                              placerPion(Board2, Cote, o2, Board3),
                                              placerPion(Board3, Cote, o3, Board4),
                                              placerPion(Board4, Cote, o4, Board5),
                                              placerPion(Board5, Cote, o5, OutBoard).

/*Placement d'un pion : On initialise la valeur (saisie utilisateur), puis on vérifie si c'est correct*/
placerPion(InBoard, Cote, TypePion, OutBoard) :-
  initPion(TypePion, Lin, Col),
  testPion(InBoard, Cote, TypePion, OutBoard, Lin, Col).

/****initPion****/
/*On récupère les positions des pions entrées par l'utilisateur*/
initPion(kr, Lin, Col) :- print('Kalista rouge'), nl,
                          lirePosInitiale(Lin, Col), !.
initPion(ko, Lin, Col) :- print('Kalista ocre'), nl,
                          lirePosInitiale(Lin, Col), !.
initPion(TypePion, Lin, Col) :- element(TypePion, [r1, r2, r3, r4, r5]),
                                print('Sbire rouge'), nl,
                                lirePosInitiale(Lin, Col), !.
initPion(TypePion, Lin, Col) :- element(TypePion, [o1, o2, o3, o4, o5]),
                                print('Sbire ocre'), nl,
                                lirePosInitiale(Lin, Col), !.
/*Lecture ligne et colonne*/
lirePosInitiale(Lin, Col) :-  print('Position (Ex. :''A1'') ? '), nl, read(Pos), nl,
                              parse(Pos, Col, Lin).

/****testPion****/
/*Vérification de la valeur saisie*/
testPion(InBoard, Cote, TypePion, OutBoard, Lin, Col) :-
  checkCote(Cote, Lin, Col),
  checkNonOccupe(Lin, Col, InBoard), !,
  remplacer(InBoard, Lin, Col, TypePion, IdCase, OutBoard),
  addPion(TypePion, Lin, Col, IdCase),
  afficherPlateau(OutBoard).

/*Cas d'erreur 1 : La saisie ne correspond pas au côté du joueur ; on replace alors le pion*/
testPion(InBoard, Cote, TypePion, OutBoard, Lin, Col) :-
  \+checkCote(Cote, Lin, Col),
  print('Erreur : vous devez placer votre pion du cote '), print(Cote), nl,
  placerPion(InBoard, Cote, TypePion, OutBoard).

/*Cas d'erreur 2 : La saisie correspond à une case déjà occupée ; on replace alors le pion*/
testPion(InBoard, Cote, TypePion, OutBoard, Lin, Col) :-
  \+checkNonOccupe(Lin, Col, InBoard),
  print('Erreur : un pion est deja present ici'), nl,
  placerPion(InBoard, Cote, TypePion, OutBoard).

/*On vérifie si les pions sont placés du bon côté */
checkCote(gauche, Lin, Col) :- Lin > 0, Lin < 7, Col > 0, Col < 3 .
checkCote(droite, Lin, Col) :- Lin > 0, Lin < 7, Col > 4, Col < 7 .
checkCote(haut, Lin, Col) :- Lin > 0, Lin < 3, Col > 0, Col < 7 .
checkCote(bas, Lin, Col) :- Lin > 4, Lin < 7, Col > 0, Col < 7 .

/*On vérifie que la case où l'on veut placer le pion n'est pas déjà occupée*/
/*On trouve la ligne*/
/*TODO : Revoir checkNonOccupe à l'aide des listes de pions.*/
checkNonOccupe(1, Col, [Ligne|_]) :- checkNonOccupeDansLigne(Col, Ligne).
checkNonOccupe(Lin, Col, [_|Q]) :- Lin > 0, NLin is Lin - 1, checkNonOccupe(NLin, Col, Q).
/*On trouve la colonne*/
checkNonOccupeDansLigne(1, [(_, b)|_]).
checkNonOccupeDansLigne(Col, [_|Q]) :- Col > 0, NCol is Col - 1, checkNonOccupeDansLigne(NCol, Q).
