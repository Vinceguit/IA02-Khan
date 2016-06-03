/*******************************/
/**Affichage du plateau de jeu**/
/*******************************/

/*Affichage du plateau : afficherPlateau(Board)*/

afficherPlateau(Board) :- affichagePlateau(Board, 1).
affichagePlateau([], _) :- print('_____________________________________\n'),
                             print('   A     B     C     D     E     F   \n').
affichagePlateau([T|Q], Lin) :- print('_____________________________________\n'),
                         print('|'), afficherLigne(T), print(Lin), nl,
                         print('|     |     |     |     |     |     |\n'),
                         NLin is Lin + 1,
                         affichagePlateau(Q, NLin).
afficherLigne([]):- print(' ').
afficherLigne([(T1, X)|Q]) :- print(' '), print(T1), afficher(X), afficherLigne(Q).

/*On traite les différents cas d'affichage; à revoir différement une fois les pions définis*/
afficher(b) :- print('   |'), !.
afficher(r1) :- print(' r1|'), !.
afficher(r2) :- print(' r2|'), !.
afficher(r3) :- print(' r3|'), !.
afficher(r4) :- print(' r4|'), !.
afficher(r5) :- print(' r5|'), !.
afficher(kr) :- print(' R |'), !.
afficher(o1) :- print(' o1|'), !.
afficher(o2) :- print(' o2|'), !.
afficher(o3) :- print(' o3|'), !.
afficher(o4) :- print(' o4|'), !.
afficher(o5) :- print(' o5|'), !.
afficher(ko) :- print(' O |'), !.
