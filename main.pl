/*********************/
/*Programme Principal*/
/*********************/

khan :- print('---KHAN---\n'), initPlayers, initBoard(_).

element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

/*Import du package d'initialisation du plateau*/
:- include(init).

/*Import du package d'affichage du plateau*/
:- include(display).

/*Import du package d'affichage des mouvements possibles*/
%:- include(moves).
