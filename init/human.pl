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
  initPion(TypePion, Col, Lin),
  testPion(InBoard, Cote, TypePion, OutBoard, Col, Lin).

/****initPion****/
/*On récupère les positions des pions entrées par l'utilisateur*/
initPion(kr, Col, Lin) :- print('Kalista rouge'), nl,
                          readInitPos(Col, Lin), !.
initPion(ko, Col, Lin) :- print('Kalista ocre'), nl,
                          readInitPos(Col, Lin), !.
initPion(TypePion, Col, Lin) :- element(TypePion, [r1, r2, r3, r4, r5]),
                                print('Sbire rouge'), nl,
                                readInitPos(Col, Lin), !.
initPion(TypePion, Col, Lin) :- element(TypePion, [o1, o2, o3, o4, o5]),
                                print('Sbire ocre'), nl,
                                readInitPos(Col, Lin).
/*Lecture ligne et colonne*/
readInitPos(Col, Lin) :-  print('Position (Ex. a1) ? '), read(Pos), nl,
                              testInitPos(Pos, Col, Lin).

testInitPos(Pos, Col, Lin) :- parse(Pos, Col, Lin), Col \= 0, Lin \= 0, !.
testInitPos(Pos, Col, Lin) :- parse(Pos, 0, 0), print('Erreur de saisie de la position.'), nl,
                              readInitPos(Col, Lin).

/****testPion****/
/*Vérification de la valeur saisie*/
testPion(InBoard, Cote, TypePion, OutBoard, Col, Lin) :-
  checkCote(Cote, Col, Lin),
  \+pion(_, Col, Lin, _, _), !,
  remplacer(InBoard, Col, Lin, TypePion, IdCase, OutBoard),
  addPion(TypePion, Col, Lin, IdCase),
  afficherPlateau(OutBoard, Cote).

/*Cas d'erreur 1 : La saisie ne correspond pas au côté du joueur ; on replace alors le pion*/
testPion(InBoard, Cote, TypePion, OutBoard, Col, Lin) :-
  \+checkCote(Cote, Col, Lin),
  print('Erreur : vous devez placer votre pion du cote '), print(Cote), nl,
  placerPion(InBoard, Cote, TypePion, OutBoard).

/*Cas d'erreur 2 : La saisie correspond à une case déjà occupée ; on replace alors le pion*/
testPion(InBoard, Cote, TypePion, OutBoard, Col, Lin) :-
  pion(_, Col, Lin, _, _),
  print('Erreur : un pion est deja present ici'), nl,
  placerPion(InBoard, Cote, TypePion, OutBoard).

/*On vérifie si les pions sont placés du bon côté */
checkCote(gauche, Col, Lin) :- Col > 0, Col < 3, Lin > 0, Lin < 7.
checkCote(droite, Col, Lin) :- Col > 4, Col < 7, Lin > 0, Lin < 7.
checkCote(haut, Col, Lin) :- Col > 0, Col < 7, Lin > 0, Lin < 3.
checkCote(bas, Col, Lin) :- Col > 0, Col < 7, Lin > 4, Lin < 7.
