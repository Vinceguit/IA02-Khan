placerPionsIA(InBoard, Cote, rouge, OutBoard) :- print('Initialisation des pions de la machine rouge'), nl,
                                                 placerPionIA(InBoard, Cote, kr, Board1),
                                                 placerPionIA(Board1, Cote, r1, Board2),
                                                 placerPionIA(Board2, Cote, r2, Board3),
                                                 placerPionIA(Board3, Cote, r3, Board4),
                                                 placerPionIA(Board4, Cote, r4, Board5),
                                                 placerPionIA(Board5, Cote, r5, OutBoard),
                                                 afficherPlateau(OutBoard), !.

placerPionsIA(InBoard, Cote, ocre, OutBoard) :- print('Initialisation des pions de la machine ocre'), nl,
                                                placerPionIA(InBoard, Cote, ko, Board1),
                                                placerPionIA(Board1, Cote, o1, Board2),
                                                placerPionIA(Board2, Cote, o2, Board3),
                                                placerPionIA(Board3, Cote, o3, Board4),
                                                placerPionIA(Board4, Cote, o4, Board5),
                                                placerPionIA(Board5, Cote, o5, OutBoard),
                                                afficherPlateau(OutBoard), !.

/*Pour l'instant, on appelle le placement de pion humain pour faire tourner le programme*/
placerPionIA(InBoard, Cote, TypePion, OutBoard) :- generatePos(Cote, Col, Lin),
                                                   remplacer(InBoard, Col, Lin, TypePion, IdCase, OutBoard),
                                                   addPion(TypePion, Col, Lin, IdCase).

/*On peut remarquer, dans la structure du plateau, que chaque côté contient 4 cases de chaque indice (1,2,3); tous les côtés sont donc équivalents sur ce plan.
On peut entourer la Kalista de 2 à 3 sbires pour la protéger.
On peut ne placer ses pions que sur des cases de 2 indices; ainsi, il est possible dès le début de partie de désobéir au Khan, et donc de forcer le jeu de l'adversaire.*/


/*Génération aléatoire de la position; on utilise une liste de positions possibles dynamique, qu'on update au fur et à mesure en supprimant une position déjà prise.*/
generatePos(Cote, Col, Lin) :- listePos(Cote, List),
                                longueur(Long, List),
                                L is Long + 1,
                                random(1, L, RandPos),
                                findAndDelete(RandPos, Col, Lin, List, NewList),
                                retract(listePos(Cote, List)),
                                asserta(listePos(Cote, NewList)).

/*On trouve la position choisie aléatoirement dans la liste, on récupère la ligne et la colonne, puis on supprime l'occurrence*/
findAndDelete(1, Col, Lin, [(Col, Lin)|Q], Q) :- !.
findAndDelete(Pos, Col, Lin, [T|Q], [T|Res]) :- Pos > 0, NPos is Pos-1, findAndDelete(NPos, Col, Lin, Q, Res).
