/****TOUR HUMAIN****/
playTurn(InBoard, Colour, OutBoard) :- print('Joueur '), print(Colour), print(', à votre tour !'), nl,
																			 turn(InBoard, Colour, OutBoard).

turn(InBoard, Colour, OutBoard) :- getCote(Cote, Colour), afficherPlateau(InBoard, Cote),
									                 influenceKhan(Colour),
                                   initMove(Colour, Move),
                                   possibleMoves(InBoard,Colour, MoveList),
                                   execMove(InBoard, Colour, Move, MoveList, OutBoard).

influenceKhan(_) :- pion(kinit, _, _, khan, _), !.
influenceKhan(Colour):- pion(_,_,_,khan,Marqueur), pion(TypePion,_,_,in,Marqueur), findColour(TypePion,Colour), !.
influenceKhan(_):- write('Desobeissance au khan !'),nl,
			             write('Vous pouvez soit bouger n''importe quelle piece de votre equipe, soit faire revenir une ancienne piece.'), nl.

/*SAISIE DU MOUVEMENT*/
initMove(rouge, (Col1, Lin1, Col2, Lin2)) :- print('Pion à déplacer (kr, r1..r5) ? '),
                                             read(Pion),
                                             testInitMove(rouge, Pion, (Col1, Lin1, Col2, Lin2)).

initMove(ocre, (Col1, Lin1, Col2, Lin2)) :- print('Pion à déplacer (ko, o1..o5) ? '),
                                            read(Pion),
                                            testInitMove(ocre, Pion, (Col1, Lin1, Col2, Lin2)).

/*Vérification de la saisie du pion et saisie de la position d'arrivée*/
testInitMove(Colour, Pion, (Col1, Lin1, Col2, Lin2)) :- findColour(Pion, Colour),
                                                        pion(Pion, Col1, Lin1, 'in', _), !,

                                                        getNewPos(Col2, Lin2),write((Col1,Lin1,Col2,Lin2)).
/*Cas d'erreur 1 : L'utilisateur a effectué une mauvaise saisie*/
testInitMove(Colour, Pion, Move) :- \+findColour(Pion, Colour),
                                    print('Erreur de saisie du pion.'), nl,
                                    initMove(Colour, Move).
/*Cas d'erreur 2 : Le pion n'est pas en jeu*/
testInitMove(Colour, Pion, Move) :- pion(Pion, _, _, 'out', _),
                                    print('Erreur : le pion choisi n est pas en jeu.'), nl,
                                    initMove(Colour, Move).

/*Saisie de la position d'arrivée*/
getNewPos(Col, Lin) :-  print('Position d''arrivee (Ex. a1) ? '), nl,
                        read(Pos), testPos(Pos, Col, Lin).

/*Test de la saisie de la position d'arrivée (On boucle tant qu'on n'a pas une saisie correcte)*/
testPos(Pos, Col, Lin) :- parse(Pos, Col, Lin), Col \= 0, Lin \= 0, !.
testPos(Pos, Col, Lin) :- parse(Pos, 0, 0), print('Erreur de saisie de la position d''arrivée.'), nl, getNewPos(Col, Lin).


/**VERIFICATION ET EXECUTION DU MOUVEMENT**/
execMove(InBoard, _, Move, MoveList, OutBoard) :- write('Mouvement accepté'), nl, element(Move, MoveList), !,
                                                  transfert(InBoard, Move, OutBoard),!.

execMove(InBoard, Colour, _, _, OutBoard) :- print('Erreur : mouvement invalide.'), nl,
                                             turn(InBoard, Colour, OutBoard).
