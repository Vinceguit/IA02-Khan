/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*On appelle possibleMoves pour récupérer la liste des mouvements possibles.
MoveList est sous la forme [[(X1, Y1),(X2, Y2)],...] où X est la colonne, Y est la ligne, (X1,Y1) est la position de départ et (X2, Y2) la position d'arrivée*/
generateMove(Board, Player, Move) :- possibleMoves(Board, Player, MoveList),
                                     findBestMove(MoveList, Move).

/*Considérer les mouvements à 2 ou 3 tours en avant*/

/*MEILLEUR MOUVEMENT
1. Si on peut éliminer directement la Kaista adverse, alors c'est le meilleur mouvement.
2. Si on peut éliminer la Kalista adverse en 2 coups, alors c'est le meilleur mouvement.
3.Sinon :
  ELIMINATION DES PIRES MOUVEMENTS
  a. Si un seul mouvement possible, meilleur mouvement.
  b. Si un mouvement entraîne la perte de la kalista au tour suivant, on l'élimine.
  c. Si un mouvement permet à l'adversaire de jouer indépendamment du Khan, on l'élimine.*/
findBestMove(_, _).
