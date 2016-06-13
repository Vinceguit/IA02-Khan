/***********************************************************/
/*Bibliothèque de prédicats utiles dans différents fichiers*/
/***********************************************************/

:-dynamic(pion/5).
:-dynamic(miniMaxPion/5).
:-dynamic(idNoeud/7).
:-dynamic(bestMove/2).

/*element(X, L) s'efface si X est élément de la liste L*/
element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

/*Longueur d'une liste*/
longueur(0, []).
longueur(Long, [_|Q]) :-longueur(L,Q), Long is L+1.

/* Afficher une liste*/
affiche([]).
affiche([X|R]) :- write(X), nl, affiche(R).

/*Retirer l'élément X d'une liste*/
retireElement(_, [], []).
retireElement(X, [X|Q], Q) :- !.
retireElement(X, [T|Q], [T|R]) :- retireElement(X, Q, R).

/*Suppression des pions de la dernière exécution; reset des listes de positions*/
/*listePos : Position en (Col, Lin) ou (X,Y)*/
resetPions :- retractall(pion(_, _, _, _, _)),
              retractall(getCote(_, _)),
              retractall(listePos(_, _)),
              asserta(listePos(haut, [(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2)])),
              asserta(listePos(bas, [(1, 5), (2, 5), (3, 5), (4, 5), (5, 5), (6, 5), (1, 6), (2, 6), (3, 6), (4, 6), (5, 6), (6, 6)])),
              asserta(listePos(gauche, [(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6)])),
              asserta(listePos(droite, [(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6), (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6)])).

/*Déclaration d'un pion*/
addPion(IdPion, Col, Lin, IdCase) :- asserta(pion(IdPion, Col, Lin, in, IdCase)).

/*Affectation du Khan à un pion*/
setKhan(IdPion) :- retract(pion(IdPion, Col, Lin, _, IdCase)),
                   asserta(pion(IdPion, Col, Lin, khan, IdCase)).

/*Renvoie la couleur d'un pion à partir de son type*/
findColour(IdPion, rouge) :- element(IdPion, [kr, r1, r2, r3, r4, r5]), !.
findColour(IdPion, ocre) :- element(IdPion, [ko, o1, o2, o3, o4, o5]), !.

/*Placement effectif d'un pion en remplaçant la valeur dans le tableau initial*/
/*Prototype : remplacer(InBoard, Lin, Col, IdPion, IdCase, OutBoard), avec IdCase et OutBoard en sortie*/
/*On trouve la ligne*/
remplacer([T|Q], Col, 1, X, IdCase, [Ligne|Q]) :- remplacerDansLigne(T, Col, X, IdCase, Ligne).
remplacer([T|Q], Col, Lin, X, IdCase, [T|Res]) :- Lin > 0, NLin is Lin-1, remplacer(Q, Col, NLin, X, IdCase, Res), !.
remplacer(L, _, _, _, L).
/*On trouve la colonne*/
remplacerDansLigne([(IdCase, _)|Q], 1, X, IdCase, [(IdCase, X)|Q]).
remplacerDansLigne([T|Q], Col, X, IdCase, [T|Res]) :- Col > 0, NCol is Col-1, remplacerDansLigne(Q, NCol, X, IdCase, Res), !.
remplacerDansLigne(L, _, _, _, L).

/*Prédicat pour récupérer le marqueur à partir de la position*/
rechercheMarqueur([T|_], (_, _, Col, 1), M) :- rechercheMarqueurDansLigne(T, Col, M).
rechercheMarqueur([_|Q], (_, _, Col, Lin), M) :- NLin is Lin-1, rechercheMarqueur(Q, (_, _, Col, NLin), M).
/*On trouve la colonne*/
rechercheMarqueurDansLigne([(M, _)|_], 1,M).
rechercheMarqueurDansLigne([_|Q], Col, M) :- NCol is Col-1, rechercheMarqueurDansLigne(Q, NCol, M).
