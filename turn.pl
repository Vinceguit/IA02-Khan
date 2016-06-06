/*********************/
/*****Tour de jeu*****/
/*********************/

/****APPEL PRINCIPAL****/
main(Board) :- player(J1, rouge),
               player(J2, ocre),
               mainLoop(Board, rouge, J1, J2).

/*Arrêt de la boucle : la kalista adverse est prise*/
mainLoop(_, _, _, _) :- pion(ko, _, _, out, _), asserta(winner(rouge)), !.
mainLoop(_, _, _, _) :- pion(kr, _, _, out, _), asserta(winner(ocre)), !.

/*Sinon, exécution du tour, puis appel du suivant*/
mainLoop(InBoard, rouge, humain, J2) :- playTurn(InBoard, rouge, OutBoard),
                                        mainLoop(OutBoard, ocre, machine, J2), !.

mainLoop(InBoard, rouge, machine, J2) :- playTurnAI(InBoard, rouge, OutBoard),
                                         mainLoop(OutBoard, ocre, humain, J2), !.

mainLoop(InBoard, ocre, J1, humain) :- playTurn(InBoard, ocre, OutBoard),
                                       mainLoop(OutBoard, rouge, J1, humain), !.

mainLoop(InBoard, ocre, J1, machine) :- playTurnAI(InBoard, ocre, OutBoard),
                                        mainLoop(OutBoard, rouge, J1, machine).

/****TOUR HUMAIN****/
playTurn(InBoard, Colour, OutBoard) :- initMove(Colour, Move),
                                       possibleMoves(InBoard, Colour, MoveList),
                                       checkMove(InBoard, Colour, Move, MoveList, OutBoard).


/**SAISIE DU MOUVEMENT**/
initMove(rouge, (Col1, Lin1, Col2, Lin2)) :- print('Pion à déplacer (kr, r1..r5) ? '),
                                             read(Pion),
                                             testInitMove(rouge, Pion, (Col1, Lin1, Col2, Lin2)).

initMove(ocre, (Col1, Lin1, Col2, Lin2)) :- print('Pion à déplacer (ko, o1..o5) ? '),
                                            read(Pion),
                                            testInitMove(ocre, Pion, (Col1, Lin1, Col2, Lin2)).

/*Vérification de la saisie du pion et saisie de la position d'arrivée*/
testInitMove(Colour, Pion, (Col1, Lin1, Col2, Lin2)) :- findColour(Pion, Colour),
                                                        \+pion(Pion, Col1, Lin1, out, _), !,
                                                        getNewPos(Lin2, Col2).
/*Cas d'erreur 1 : L'utilisateur a effectué une mauvaise saisie*/
testInitMove(Colour, Pion, Move) :- \+findColour(Pion, Colour),
                                    print('Erreur de saisie du pion.'), nl,
                                    initMove(Colour, Move).
/*Cas d'erreur 2 : Le pion n'est pas en jeu*/
testInitMove(Colour, Pion, Move) :- pion(Pion, _, _, out, _),
                                    print('Erreur : le pion choisi n est pas en jeu.'), nl,
                                    initMove(Colour, Move).

/*Saisie de la position d'arrivée*/
getNewPos(Lin, Col) :-  print('Position d''arrivee'), nl,
                        print('Ligne ? '), read(Lin),
                        print('Colonne ? '), read(Col).


/**VERIFICATION DU MOUVEMENT**/
checkMove(InBoard, Player, Move, PossibleMoveList, OutBoard) :- possibleMoves(Player,PossibleMoveList),
												   element(Move, PossibleMoveList), !,
                                                   transfert(InBoard, Move, OutBoard).

checkMove(InBoard, Colour, Move, PossibleMoveList, OutBoard) :- \+element(Move, PossibleMoveList),
                                                        print('Erreur : mouvement invalide.'), nl,
                                                        playTurn(InBoard, Colour, OutBoard).


/****TOUR MACHINE****/
playTurnAI(Colour, InBoard, OutBoard).
