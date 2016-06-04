/*********************/
/*Programme Principal*/
/*********************/

play :- print('~~~~~~~~~~~~~~~~KHAN~~~~~~~~~~~~~~~~\n'),
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

/*Import de la bibliothèque d'affichage des mouvements possibles*/
:- include('moves/moves').

/*Import de la bibliothèque de génération du meilleur mouvement possible*/
:- include('moves/bestmove').
