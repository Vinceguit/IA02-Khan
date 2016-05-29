/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*On appelle possibleMoves pour récupérer la liste des mouvements possibles.
MoveList est sous la forme [[(X1, Y1),(X2, Y2)],...] où X est la colonne, Y est la ligne, (X1,Y1) est la position de départ et (X2, Y2) la position d'arrivée*/
generateMove(Board, Player, Move) :- possibleMoves(Board, Player, MoveList),
                                     findBestMove(MoveList, Move).

/*MOUVEMENTS A ELIMINER
1. Mouvement mettant en danger la Kalista*/
findBestMove(_, _).
