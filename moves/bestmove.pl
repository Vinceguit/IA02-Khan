/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*On appelle possibleMoves pour récupérer la liste des mouvements possibles.
MoveList est sous la forme [[(X1, Y1, X2, Y2)],...] où X est la colonne, Y est la ligne, (X1,Y1) est la position de départ et (X2, Y2) la position d'arrivée*/

generateMove(Board, Player, Move) :- alphaBeta(Player, 4, Board, -100, 100, Move, _).

/**Algorithme Minimax Alpha-Beta**/
/*alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) où Value est l'heuristique*/

/*Cas 1 : si la frontière est à 0, on arrête l'exploration et on calcule l'heuristique*/
alphaBeta(Colour, 0, Board, _, _, Move, Value) :-
  heuristic(Board, Colour, Move,0,Value).
  

/*Cas 2 : On récupère les mouvements possibles pour le joueur, puis on évalue les mouvements possibles*/
alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) :-
  Frontier > 0, % On vérifie que la frontière est bien positive !
  possibleMoves(Board, Player, MoveList), % On récupère les mouvements possibles
  Alpha1 is -Beta, % On change de joueur; on passe donc de MAX à MIN ou vice-versa.
  Beta1 is -Alpha,
  NFrontier is Frontier - 1, % On décrémente la frontière car on traite des cas plus profonds de l'arbre
  evaluerEtChoisir(Player, MoveList, Board, NFrontier, Alpha1, Beta1, nil, (Move, Value)). %On récupère le meilleur mouvement


/*Evaluation des différents mouvements possibles, et choix du meilleur*/
evaluerEtChoisir(Player, [Move|MoveList], Board, Frontier, Alpha, Beta, Record, BestMove) :-
  transfert(Board, Move, OutBoard), % On récupère un Board avec le mouvement de l'arbre à tester
  oppPlayer(Player, OtherPlayer), % On change de joueur (pour minimiser les chances de l'adversaire / maximiser celles de l'IA)
  alphaBeta(OtherPlayer, Frontier, OutBoard, Alpha, Beta, _, Value), % On rappelle alphaBeta à la profondeur suivante. _ : OtherMove
  NValue is -Value,
  coupure(Player, Move, NValue, Frontier, Alpha, Beta, MoveList, Board, Record, BestMove).

evaluerEtChoisir(_, [], _, _, Alpha, _, Move, (Move, Alpha)). %Si on n'a plus de mouvement à traiter dans la liste, on renvoie la valeur de Alpha ainsi que le mouvement.


/*Traitement selon la valeur de Value par rapport à Alpha et Beta*/
coupure(_, Move, Value, _, _, Beta, _, _, _, (Move, Value)) :-
  Value >= Beta, !.

coupure(Player, Move, Value, Frontier, Alpha, Beta, Moves, Board, _, BestMove) :-
  Alpha < Value, Value < Beta, !,
  evaluerEtChoisir(Player, Moves, Board, Frontier, Value, Beta, Move, BestMove).

coupure(Player, _, Value, Frontier, Alpha, Beta, Moves, Board, Record, BestMove) :-
  Value =< Alpha, !,
  evaluerEtChoisir(Player, Moves, Board, Frontier, Alpha, Beta, Record, BestMove).


/*Petit prédicat pour trouver le joueur adverse*/
oppPlayer(rouge, ocre).
oppPlayer(ocre, rouge).


/**Calcul de la fonction heuristique**/

heuristic(Board,Colour,Move,V1, V10):- 
								listingPionsEquipe(Board,L1,L2),
								listingPionsEnnemis(Board,L3,L4),
								nbPositionAttaque(0.2,Board,V1,V2),
								nbPositionVictime(0.2,Board,V2,V3),
								nbSbiresEnnemisEnJeu(0.2,Board,V4,V5), 
								distanceSbiresKalista(0.2,Board,V5,V6),
								defenseKalista(0.2,Board,V7,V8),
								gagne(Board,Colour,V8,V9),
								perdu(Board,Colour,V9,V10).
								
gagne(Board,rouge,_,Vb):- Vb is 100,element(Q,Board),\+ element((ko,_),Q),!.
gagne(Board,ocre,_,Vb):- Vb is 100,element(Q,Board),\+element((kr,_),Q),!.
gagne(_,_,V,V).
perdu(Board,rouge,_,Vb):- element(Q,Board),\+element((kr,_),Q),Vb is 0,!.
perdu(Board,ocre,_,Vb):-element(Q,Board),\+ element((ko,_),Q),Vb is 0,!.
perdu(_,_,V,V).

nbSbiresEnnemiEnJeu(Coeff,Board,Colour,Va,Vb):- oppPlayer(Colour,Ennemi),
												rechercheNombreDispo(Board,Ennemi,1,1,0,V),
												calculNbSbires(Coeff,Va,Vb,V).

rechercheNombreDispo([T|Q],Colour,Col,Lin, V1,V3) :- Lin<7,NLin is Lin+1, rechercheNombreDispoDansLigne(T,Colour,Col,Lin,V1,V2),
												 rechercheNombreDispo(Q,Colour,Col,NLin,V2,V3),!.
rechercheNombreDispo(_,_,_,7,V,V).

rechercheNombreDispoDansLigne([(_, Pion)|Q], Colour,Col,Lin,V1,V3) :- Col<7, NCol is Col+1,findColour(Pion,Colour),V2 is V1+1,print(V2),!, rechercheNombreDispoDansLigne(Q, Colour,NCol,Lin,V2,V3).
rechercheNombreDispoDansLigne([_|Q], Colour,Col,Lin,V1,V2) :- Col <7,NCol is Col+1,!, rechercheNombreDispoDansLigne(Q,Colour,NCol,Lin,V1,V2),!.
rechercheNombreDispoDansLigne([],_,7,_,V,V).
rechercheNombreDispoDansLigne(_,_,7,_,V,V).

calculNbSbires(Coeff,Va,Vb,1):- Vb is Va+Coeff*(0),!.
calculNbSbires(Coeff,Va,Vb,2):- Vb is Va+Coeff*(33),!.
calculNbSbires(Coeff,Va,Vb,3):- Vb is Va+Coeff*(66),!.
calculNbSbires(Coeff,Va,Vb,4):- Vb is Va+Coeff*(100),!.
calculNbSbires(Coeff,Va,Vb,5):- Vb is Va+Coeff*(50),!.
calculNbSbires(Coeff,Va,Vb,6):- Vb is Va+Coeff*(0),!.
												