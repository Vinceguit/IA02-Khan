/*******************************/
/**Affichage du plateau de jeu**/
/*******************************/

/*Affichage du plateau : afficherPlateau(Board, Cote)*/
afficherPlateau(Board, bas) :- print('   A     B     C     D     E     F   \n'),
                               affichagePlateauBas(Board, 1),
                               print('_____________________________________\n'), nl.

afficherPlateau(Board, haut) :- print('   F     E     D     C     B     A   \n'),
                                affichagePlateauHaut(Board, 0),
                                print('_____________________________________\n'), nl.

afficherPlateau(Board, gauche) :- print('   1     2     3     4     5     6   \n'),
                                  affichagePlateauGauche(Board, 6),
                                  print('_____________________________________\n'), nl.

afficherPlateau(Board, droite) :- print('   6     5     4     3     2     1   \n'),
                                  affichagePlateauDroite(Board, 1),
                                  print('_____________________________________\n'), nl.

/*On traite les différents cas d'affichage*/
afficher(b) :- print('   |'), !.
afficher(r1) :- print(' r1|'), !.
afficher(r2) :- print(' r2|'), !.
afficher(r3) :- print(' r3|'), !.
afficher(r4) :- print(' r4|'), !.
afficher(r5) :- print(' r5|'), !.
afficher(kr) :- print(' KR|'), !.
afficher(o1) :- print(' o1|'), !.
afficher(o2) :- print(' o2|'), !.
afficher(o3) :- print(' o3|'), !.
afficher(o4) :- print(' o4|'), !.
afficher(o5) :- print(' o5|'), !.
afficher(ko) :- print(' KO|'), !.

/*Parseur d'affichage des colonnes*/
afficherId(1) :- print(' A').
afficherId(2) :- print(' B').
afficherId(3) :- print(' C').
afficherId(4) :- print(' D').
afficherId(5) :- print(' E').
afficherId(6) :- print(' F').

/*Affichage du plateau du côté bas*/
affichagePlateauBas([], _) :- !.
affichagePlateauBas([T|Q], Lin) :- print('_____________________________________\n'),
                                        print('|'), afficherLigneBas(T), print(Lin), nl,
                                        print('|     |     |     |     |     |     |\n'),
                                        NLin is Lin + 1,
                                        affichagePlateauBas(Q, NLin).
afficherLigneBas([]):- print(' ').
afficherLigneBas([(T1, X)|Q]) :- print(' '), print(T1), afficher(X), afficherLigneBas(Q).


/*Affichage du plateau du côté haut*/
affichagePlateauHaut([], _) :- !.
affichagePlateauHaut([T|Q], Lin) :- NLin is Lin + 1,
                                    affichagePlateauHaut(Q, NLin),
                                    print('_____________________________________\n'),
                                    print('|'), afficherLigneHaut(T), print(' '), print(NLin), nl,
                                    print('|     |     |     |     |     |     |\n').
afficherLigneHaut([]).
afficherLigneHaut([(T1, X)|Q]) :- afficherLigneHaut(Q), print(' '), print(T1), afficher(X).


/*Affichage du plateau du côté gauche*/
affichagePlateauGauche(_, 0) :- !.
affichagePlateauGauche(Board, Lin) :- print('_____________________________________\n'),
                                      print('| '), afficherLigneGauche(Board, Lin), afficherId(Lin), nl,
                                      NLin is Lin - 1,
                                      print('|     |     |     |     |     |     |\n'),
                                      affichagePlateauGauche(Board, NLin).

afficherLigneGauche([], _).
afficherLigneGauche([T|Q], Lin) :- afficherElementGauche(T, Lin), afficherLigneGauche(Q, Lin).

afficherElementGauche([(T1, X)|_], 1) :- print(T1), afficher(X), print(' '), !.
afficherElementGauche([_|Q], Lin) :- Lin > 1, NLin is Lin - 1, afficherElementGauche(Q, NLin).


/*Affichage du plateau du côté droite*/
affichagePlateauDroite(_, 7) :- !.
affichagePlateauDroite(Board, Lin) :- NLin is Lin + 1,
                                      print('_____________________________________\n'),
                                      print('| '), afficherLigneDroite(Board, Lin), afficherId(Lin), nl,
                                      print('|     |     |     |     |     |     |\n'),
                                      affichagePlateauDroite(Board, NLin).

afficherLigneDroite([], _).
afficherLigneDroite([T|Q], Lin) :- afficherLigneDroite(Q, Lin), afficherElementDroite(T, Lin).

afficherElementDroite([(T1, X)|_], 1) :- print(T1), afficher(X), print(' '), !.
afficherElementDroite([_|Q], Lin) :- Lin > 1, NLin is Lin - 1, afficherElementDroite(Q, NLin).
