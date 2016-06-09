/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*On appelle possibleMoves pour récupérer la liste des mouvements possibles.
MoveList est sous la forme [[(X1, Y1, X2, Y2)],...] où X est la colonne, Y est la ligne, (X1,Y1) est la position de départ et (X2, Y2) la position d'arrivée*/
generateMove(Board, Player, Move) :- alphaBeta(Player, 4, Board, -100, 100, Move, _).

/**Algorithme Minimax Alpha-Beta**/
/*alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) où Value est l'heuristique*/

/*Cas 1 : si la frontière est à 0, on arrête l'exploration*/
alphaBeta(Player, 0, Board, _, _, _, Value) :- heuristic(Board, Value).
/*Cas 2 : On récupère les mouvements possibles pour le joueur, puis on évalue les mouvements possibles*/
alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) :- Frontiere > 0, % On vérifie que la frontière est bien positive !
                                                                possibleMoves(Board, Player, MoveList), % On récupère les mouvements possibles
                                                                Alpha1 is -Beta, % On change de joueur; on passe donc de MAX à MIN ou vice-versa.
                                                                Beta1 is -Alpha,
                                                                NFrontier is Frontier - 1, % On décrémente la frontière car on traite des cas plus profonds de l'arbre
                                                                evaluerEtChoisir(Player, MoveList, Board, NFrontier, Alpha1, Beta1, nil, (Move, Value)). %On récupère le meilleur mouvement

/*Evaluation des différents mouvements possibles, et choix du meilleur*/
evaluerEtChoisir(Player, [Move|Moves], Board, Frontier, Alpha, Beta, Record, BestMove) :- transfert(Board, Move, OutBoard), % On récupère un Board avec le mouvement de l'arbre à tester
                                                                                          oppPlayer(Player, OtherPlayer), % On change de joueur (pour minimiser les chances de l'adversaire / maximiser celles de l'IA)
                                                                                          alphaBeta(OtherPlayer, Frontier, OutBoard, Alpha, Beta, _, Value), % On rappelle alphaBeta à la profondeur suivante. _ : OtherMove
                                                                                          Value1 is -Value,
                                                                                          coupure(Player, Move, Value1, Frontier, Alpha, Beta, Moves, Position, Record, BestMove).
evaluerEtChoisir(_, [], _, _, Alpha, _, Move, (Move, Alpha)). %Si on n'a plus de mouvement à traiter dans la liste, on renvoie la valeur de Alpha ainsi que le mouvement.

coupure(_, Move, Value, _, _, Beta, _, _, _, (Move, Value)) :- Value >= Beta, !.
coupure(Player, Move, Value, Frontier, Alpha, Beta, Moves, Position, _, BestMove) :- Alpha < Value, Value < Beta, !,
                                                                              evaluerEtChoisir(Player, Moves, Position, Frontier, Value, Beta, Move, BestMove).
coupure(Player, _, Value, Frontier, Alpha, Beta, Moves, Position, Record, BestMove) :- Value =< Alpha, !,
                                                                                evaluerEtChoisir(Player, Moves, Position, Frontier, Alpha, Beta, Record, BestMove).

oppPlayer(rouge, ocre).
oppPlayer(ocre, rouge).


/**Calcul de la fonction heuristique**/

heuristic(Board, Value):- !.
