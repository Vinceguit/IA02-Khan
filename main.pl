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

/* La fonction modificationPosition permet de modifier les informations dans la BDD à partir du move, qui indique le point de départ et le point d'arrivée */
modificationPosition(Player, Board, [(X1,X2),(Y1,Y2)]):- transferPiece(Teams,X2,Y2,(Player,X1,Y1,_,_)),transferNbMoves(Board, (Player,X,Y,P,NbMoves)).
transferPiece(Teams,X2,Y2,(Player,X1,Y1,_,_)):- "trouver",modifierPiece(I,X2,Y2) 
transferNbMoves(Board, (Player,X,Y,P,NbMoves)):- trouverCase(X,Y,Board,Z),NbMoves is Z,switchInOff(X,Y,_,_).
/* trouverPièce permet d'identifier une pièce sur le plateau, elle s'arrête à la première pièce trouvé
 trouverCase renvoie le NbMoves de la case dans Z*/
trouverCase.
/* switch inoff permet de modifier l'info de la pièce en fonction de NbMoves */
switchInOff
MiseAJourPlateau

Disparition pièce... modificationPosition (Otherplayer, Board, Move)
