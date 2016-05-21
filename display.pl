/*******************************/
/**Affichage du plateau de jeu**/
/*******************************/

/*Affichage du plateau : afficherPlateau(Board)*/
afficherPlateau([]) :- print('_____________________________________\n').
afficherPlateau([T|Q]) :- print('_____________________________________\n'),
                         print('|'), afficherLigne(T), print('\n'),
                         print('|     |     |     |     |     |     |\n'),
                         afficherPlateau(Q).
afficherLigne([]).
afficherLigne([(T1, X)|Q]) :- print(' '), print(T1), afficher(X), afficherLigne(Q).

/*On traite les différents cas d'affichage; à revoir différement une fois les pions définis*/
afficher(b) :- print('   |'), !.
afficher(r) :- print(' r |'), !.
afficher(kr) :- print(' R |'), !.
afficher(o) :- print(' o |'), !.
afficher(ko) :- print(' O |'), !.
