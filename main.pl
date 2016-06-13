/*********************/
/*Programme Principal*/
/*********************/

play :-
  print('~~~~~~~~~~~~~~~~KHAN~~~~~~~~~~~~~~~~\n'),
  initPlayers,
  initBoard(Board),
  asserta(plateau(Board)),
  main(Board),
  winner(WColour, WType), !,
  print('Le gagnant est le joueur '), print(WColour), print(' ('), print(WType), print(') !').

/*Import de la bibliothèque principale*/
:- include('./library').

/*Import de la bibliothèque d'affichage du plateau*/
:- include('./display').

/*Import du parseur de coordonnées*/
:- include('./coord_parser').

/*Import de la bibliothèque d'initialisation du plateau*/
:- include('./init/init').

/*Import de la bibliothèque d'exécution des tours*/
:- include('./turn/turn').

/*Import de la bibliothèque de modification de la BDD lors du mouvement*/
:- include('moves/moves').

/*Import de la bibliothèque de génération du meilleur mouvement possible*/
:- include('moves/graphe').
/*Import de la bibliothèque de génération de la liste des mouvements autorisés*/
:- include('moves/legalMoves').
/*Import de la bibliothèque de génération de la liste des mouvements autorisés dans le cas de la recherche AI, le prédicat pion étant remplacé par le prédicat temporaire minimaxPion*/
:- include('moves/legalMovesMinimax').
/*Import de la bibliothèque de modification de la BDD lors du mouvement dans le cas du minimax*/
:- include('moves/movesMinimax').

/*Import des heuristiques*/
:- include('moves/heuristic').

