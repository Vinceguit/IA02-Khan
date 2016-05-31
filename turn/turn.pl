/*********************/
/*****Tour de jeu*****/
/*********************/

/****IMPORTS****/
/*Import des prédicats d'initialisation pour un humain*/
:- include('./human').
/*Import des prédicats d'initialisation pour une machine*/
:- include('./machine').

/****APPEL PRINCIPAL****/
main(Board) :- player(J1, rouge),
               player(J2, ocre),
               mainLoop(Board, rouge, J1, J2).

/*Arrêt de la boucle : la kalista adverse est prise*/
mainLoop(_, _, _, _) :- pion(ko, _, _, out, _), setWinner(rouge), !.
mainLoop(_, _, _, _) :- pion(kr, _, _, out, _), setWinner(ocre), !.

/*Sinon, exécution du tour, puis appel du suivant*/
mainLoop(InBoard, rouge, humain, J2) :- playTurn(InBoard, rouge, OutBoard),
                                        mainLoop(OutBoard, ocre, machine, J2), !.

mainLoop(InBoard, rouge, machine, J2) :- playTurnAI(InBoard, rouge, OutBoard),
                                         mainLoop(OutBoard, ocre, humain, J2), !.

mainLoop(InBoard, ocre, J1, humain) :- playTurn(InBoard, ocre, OutBoard),
                                       mainLoop(OutBoard, rouge, J1, humain), !.

mainLoop(InBoard, ocre, J1, machine) :- playTurnAI(InBoard, ocre, OutBoard),
                                        mainLoop(OutBoard, rouge, J1, machine).

setWinner(Colour) :- player(TypePlayer, Colour),
                     asserta(winner(Colour, TypePlayer)).
