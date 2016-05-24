/*********************/
/*Programme Principal*/
/*********************/

khan :- print('---KHAN---\n'),
        print('Joueur vs Joueur : khan(1).\n'),
        print('Joueur vs Machine : khan(2).\n'),
        print('Machine vs Machine : khan(3).\n\n').

khan(X) :- X > 0, X < 4, initBoard(_).

element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

/*Import du package d'initialisation du plateau*/
:- include(init).

/*Import du package d'affichage du plateau*/
:- include(display).

/*Import du package d'affichage des mouvements possibles*/
%:- include(moves).
