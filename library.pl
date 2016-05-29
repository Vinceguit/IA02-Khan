/***********************************************************/
/*Bibliothèque de prédicats utiles dans différents fichiers*/
/***********************************************************/

/*element(X, L) s'efface si X est élément de la liste L*/
element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

/*Longueur d'une liste*/
longueur(0, []).
longueur(Long, [_|Q]) :-longueur(L,Q), Long is L+1.

/*Retirer l'élément X d'une liste*/
retireElement(_, [], []).
retireElement(X, [X|Q], Q) :- !.
retireElement(X, [T|Q], [T|R]) :- X \= T, retireElement(X, Q, R).

/*Suppression des pions de la dernière exécution; reset des listes de positions*/
/*listePos : Position en (Col, Lin) ou (X,Y)*/
resetPions :- retractall(pion(_, _, _, _, _)),
              retractall(listePos(_, _)),
              asserta(listePos(haut, [(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2)])),
              asserta(listePos(bas, [(1, 5), (2, 5), (3, 5), (4, 5), (5, 5), (6, 5), (1, 6), (2, 6), (3, 6), (4, 6), (5, 6), (6, 6)])),
              asserta(listePos(gauche, [(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6)])),
              asserta(listePos(droite, [(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6), (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6)])).

/*Déclaration d'un pion*/
addPion(TypePion, Lin, Col, IdCase) :- asserta(pion(TypePion, Col, Lin, in, IdCase)).

/*Renvoie la couleur d'un pion à partir de son type*/
findColour(TypePion, rouge) :- element(TypePion, [kr, r1, r2, r3, r4, r5]), !.
findColour(TypePion, ocre) :- element(TypePion, [ko, o1, o2, o3, o4, o5]), !.
