/*********************/
/*Programme Principal*/
/*********************/

play :- print('~~~~~~~~~~~~~~~~KHAN~~~~~~~~~~~~~~~~\n'),
        initPlayers,
        initBoard(Board),
        asserta(plateau(Board)),
        main(Board),
        winner(WColour, WType),
        print('Le gagnant est le joueur '), print(WColour), print(' ('), print(WType), print(') !').

/*L'appel d'initBoard effectue les actions suivantes :

  - le prédicat retourne en paramètre le plateau de jeu initialisé, sous forme de liste de ligne [L1, ..., L6], chaque ligne étant une liste de tuples [(Indice1, Type1), ..., (Indice6, Type6)] contenant l'indice de la case (de 1 à 3) et le type de pion sur cette case (b = case blanche, kr = Kalista rouge, ko = Kalista ocre, r1 à r5 = sbires rouges, o1 à o5 = sbires ocres)

  - lors de l'exécution du prédicat, une liste de pions est générée dynamiquement dans le programme; elle est accessible par le prédicat listePions(List), où List est une liste de tuples [(Type1, Lin1, Col1), ..., (TypeN, LinN, ColN)] contenant le type de pion, la ligne et la colonne de chaque pion.*/

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
%:- include('moves/bestmove').
