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
placerPionIA(InBoard, Cote, TypePion, OutBoard) :- generatePos(TypePion, Cote, Lin, Col),
                                                   remplacer(InBoard, Lin, Col, TypePion, OutBoard),
                                                   updateListePions(TypePion, Lin, Col).

/*On peut remarquer, dans la structure du plateau, que chaque côté contient 4 cases de chaque indice (1,2,3); tous les côtés sont donc équivalents sur ce plan.

On peut entourer la Kalista de 2 à 3 sbires pour la protéger.

On peut ne placer ses pions que sur des cases de 2 indices; ainsi, il est possible dès le début de partie de désobéir au Khan, et donc de forcer le jeu de l'adversaire.*/

/*TODO : Optimisation de la génération de position. En passant par un random, on est obligé de checker qu'il n'y a pas déjà un pion à la place souhaitée => la complexité est un peu pourrie*/
generatePos(TypePion, Cote, Lin, Col) :- randomPos(Cote, Lin, Col),
                                         findColour(TypePion, Colour),
                                         listePions(Colour, Liste),
                                         checkNonOccupeIA(TypePion, Cote, Lin, Col, Liste).

/*TODO : fixer le bug de checkNonOccupeIA*/
checkNonOccupeIA(_, _, _, _, []) :- !.
checkNonOccupeIA(TypePion, Cote, Lin, Col, [(TypePion, Lin, Col)|_]) :- generatePos(TypePion, Cote, Lin, Col), !.
checkNonOccupeIA(TypePion, Cote, Lin, Col, [_|Q]) :- checkNonOccupeIA(TypePion, Cote, Lin, Col, Q).

randomPos(gauche, Lin, Col) :- random(1, 7, Lin), random(1, 3, Col).
randomPos(droite, Lin, Col) :- random(1, 7, Lin), random(5, 7, Col).
randomPos(haut, Lin, Col) :- random(1, 3, Lin), random(1, 7, Col).
randomPos(bas, Lin, Col) :- random(5, 7, Lin), random(1, 7, Col).
