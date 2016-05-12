/*Démarrage du jeu*/
khan :- print('---KHAN---\n'),
        print('Joueur vs Joueur : khan(1).\n'),
        print('Joueur vs Machine : khan(2).\n'),
        print('Machine vs Machine : khan(3).\n\n').

khan(X) :- X > 0, X < 4, jeu(X, _, [[(2, r),(3, b),(1, r),(2, b),(2, kr),(3, b)],
                                    [(2, b),(1, b),(3, b),(1, b),(3, b),(1, b)],
                                    [(1, b),(3, b),(2, b),(3, b),(1, b),(2, b)],
                                    [(3, b),(1, b),(2, b),(1, b),(3, b),(2, b)],
                                    [(2, b),(3, b),(1, b),(3, ko),(1, b),(3, b)],
                                    [(2, b),(1, b),(3, o),(2, b),(2, b),(1, b)]]).

/*Affichage du plateau*/

jeu(_, Y, Z):- afficherPlateau(Z), lireCote(Y).
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

/*Initialisation des pions*/
cote(gauche).
cote(droite).
cote(haut).
cote(bas).
lireCote(X) :- print('Quel cote choisir ?'), nl, read(X), cote(X).
