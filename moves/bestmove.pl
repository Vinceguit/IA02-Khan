/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*On appelle possibleMoves pour récupérer la liste des mouvements possibles.
MoveList est sous la forme [[(X1, Y1, X2, Y2)],...] où X est la colonne, Y est la ligne, (X1,Y1) est la position de départ et (X2, Y2) la position d'arrivée*/

generateMove(Board, Player, Move) :-
  retractall(playerState(_,_)),
  oppPlayer(Player, Player2),
  asserta(playerState(Player, max)),
  asserta(playerState(Player2, min)),
  miniMax(Player, 3, Board, Move, _).

/**Algorithme Minimax**/
/*miniMax(Player, Frontier, Board, Move, Value)*/
/*minimax(p) = f(p) si p est une feuille de l’arbre où f est une fonction d’évaluation de la position du jeu
minimax(p) = MAX(minimax(O1), …, minimax(On)) si p est un nœud Joueur avec fils O1, …, On
minimax(p) = MIN(minimax(O1), …, minimax(On)) si p est un nœud Opposant avec fils O1, …, On*/
miniMax(Player, 0, Board, BestMove, Value) :-
  print('MINIMAX TERMINAL - Frontiere:0  Valeur:'),
  transfertAI(Board, BestMove, OutBoard),
  heuristic(OutBoard, Player, 0, Value),
  print(Value), nl, !.

miniMax(Player, Frontier, Board, BestMove, Value) :-
  print('MINIMAX - Frontiere:'), print(Frontier), print('  Joueur:'), print(Player), nl,
  possibleMoves(Board, Player, MoveList),
  best(Player, Frontier, Board, MoveList, BestMove, Value).
% BoardList : liste de tuples (Move, Board) pour retrouver un mouvement correspondant à un état du plateau plus facilement


%On trouve le meilleur mouvement
best(Player, Frontier, Board, [Move], Move, Value) :-
  print('Mouvement:'), print(Move), nl,
  NFrontier is Frontier - 1,
  oppPlayer(Player, Player2),
  transfertAI(Board, Move, Board2),
  miniMax(Player2, NFrontier, Board2,  _, Value), !.

best(Player, Frontier, Board, [Move1|MoveList], BestMove, BestValue) :-
  print('Mouvement:'), print(Move1), nl,
  NFrontier is Frontier - 1,
  oppPlayer(Player, Player2),
  transfertAI(Board, Move1, Board2),
  miniMax(Player2, NFrontier, Board2, _, Value1),
  best(Player, Frontier, Board, MoveList, Move2, Value2),
  betterOf(Player, Move1, Value1, Move2, Value2, BestMove, BestValue),
  print('Best move : '), print(BestMove), print(' - Best value : '), print(BestValue), nl.


betterOf(Player, Move1, Value1, _, Value2, Move1, Value1) :-
    playerState(Player, min),
    Value1 > Value2, !.

betterOf(Player, Move1, Value1, _, Value2, Move1, Value1) :-
    playerState(Player, max),
    Value1 < Value2, !.

betterOf(_, _, _, Move2, Value2, Move2, Value2).

/**Algorithme Alpha-Beta**/
/*alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) où Value est l'heuristique*/

/*Cas 1 : si la frontière est à 0, on arrête l'exploration et on calcule l'heuristique*/
alphaBeta(Colour, 0, Board, _, _, Move, Value) :-
  heuristic(Board, Colour, 0, Value).

%Cas 2 : On récupère les mouvements possibles pour le joueur, puis on évalue les mouvements possibles
alphaBeta(Player, Frontier, Board, Alpha, Beta, Move, Value) :-
  print('ALPHABETA - Frontiere '), print(Frontier), print(' - a:'), print(Alpha), print(' b:'), print(Beta), nl,
  Frontier > 0, % On vérifie que la frontière est bien positive !
  possibleMoves(Board, Player, MoveList), % On récupère les mouvements possibles
  NAlpha is -Beta, % On change de joueur; on passe donc de MAX à MIN ou vice-versa.
  NBeta is -Alpha,
  NFrontier is Frontier - 1, % On décrémente la frontière car on traite des cas plus profonds de l'arbre
  evaluerEtChoisir(Player, MoveList, Board, NFrontier, NAlpha, NBeta, nil, Move, Value). %On récupère le meilleur mouvement


%Evaluation des différents mouvements possibles, et choix du meilleur
evaluerEtChoisir(Player, [Move|MoveList], Board, Frontier, Alpha, Beta, Record, BestMove, BestValue) :-
  nl, print('EVALUERCHOISIR\n'),
  transfertAI(Board, Move, OutBoard), % On récupère un Board avec le mouvement de l'arbre à tester
  oppPlayer(Player, OtherPlayer), % On change de joueur (pour minimiser les chances de l'adversaire / maximiser celles de l'IA)
  alphaBeta(OtherPlayer, Frontier, OutBoard, Alpha, Beta, _, Value), % On rappelle alphaBeta à la profondeur suivante. _ : OtherMove
  NValue is -Value,
  coupure(Player, Move, NValue, Frontier, Alpha, Beta, MoveList, Board, Record, BestMove, BestValue).

evaluerEtChoisir(_, [], _, _, Alpha, _, Move, Move, Alpha):- print('EVALUERCHOISIR TERMINAL\n'). %Si on n'a plus de mouvement à traiter dans la liste, on renvoie la valeur de Alpha ainsi que le mouvement.


%Traitement selon la valeur de Value par rapport à Alpha et Beta
coupure(_, Move, Value, _, _, Beta, _, _, _, Move, Value) :-
  Beta =< Value, !,
  print('      CUTOFF - Beta <= Val\n'), !.

coupure(Player, Move, Value, Frontier, Alpha, Beta, Moves, Board, _, BestMove, BestValue) :-
  Alpha < Value, Value < Beta, !,
  print('      CUTOFF - Alpha < Val < Beta\n'),
  evaluerEtChoisir(Player, Moves, Board, Frontier, Value, Beta, Move, BestMove, BestValue), !.

coupure(Player, _, Value, Frontier, Alpha, Beta, Moves, Board, Record, BestMove, BestValue) :-
  Value =< Alpha, !,
  print('      CUTOFF - Val <= Alpha\n'),
  evaluerEtChoisir(Player, Moves, Board, Frontier, Alpha, Beta, Record, BestMove, BestValue).


/*Petit prédicat pour trouver le joueur adverse*/
oppPlayer(rouge, ocre).
oppPlayer(ocre, rouge).


/**Transfert d'un pion sur le plateau sans passer par les prédicats externes**/
transfertAI(InBoard, (Col1, Lin1, Col2, Lin2), OutBoard) :-
  getIdPion(InBoard, Col1, Lin1, IdPion),
  miseAJourMove(IdPion, Col1, Lin1, Col2, Lin2, 'in', InBoard, OutBoard).

/*On trouve IdPion*/
/*On trouve la ligne*/
getIdPion([T|_], Col, 1, IdPion) :- getIdInLine(T, Col, IdPion).
getIdPion([_|Q], Col, Lin, IdPion) :- Lin > 0, NLin is Lin-1, getIdPion(Q, Col, NLin, IdPion).
/*On trouve la colonne*/
getIdInLine([(_, IdPion)|_], 1, IdPion).
getIdInLine([_|Q], Col, IdPion) :- Col > 0, NCol is Col-1, getIdInLine(Q, NCol, IdPion).


/**Calcul de la fonction heuristique**/
/*On maximise pour l'IA; on minimise pour son adversaire*/

heuristic(Board, Colour, V1, V10):-
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
