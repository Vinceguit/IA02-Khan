/************************/
/*Gestion des mouvements*/
/************************/

/*Gros du boulot*/
possibleMoves(Board, Player, PossibleMoveList) :- element(Player, [rouge, ocre]).


/*pion(IdPion, Col, Lin, in, IdCase).*/


transfert(InBoard,Move,OutBoard) :- presenceProie(Move ,InBoard, NewBoard),
                                    rechercheMarqueur(NewBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, NewBoard, OutBoard),
                                    print(OutBoard),!.

transfert(InBoard,Move,OutBoard) :- rechercheMarqueur(InBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, InBoard, OutBoard), !.

/* commande de test([[(2, b),(3, r1)],[(2, b),(1, o3)]],(2,2,1,1),NewBoard).*/

presenceProie((Lin1, Col1, Lin2, Col2), Board, NewBoard) :-
  piece(_, Lin1, Col1, 'in', _),
  piece(TypePion, Lin2, Col2, 'in', _),
  suppressionProie(TypePion, Lin2, Col2),
  miseAJourPlateau(TypePion, Lin2, Col2, 'out', Board, NewBoard).

suppressionProie(TypePion,Lin,Col) :- retract(piece(TypePion, Lin, Col, 'in', _)),
                                      asserta(piece(TypePion, Lin, Col, 'out', 0)).

enregistrementMove((Lin1, Col1, Lin2, Col2), NewMarqueur, Board1, Board2) :-
  retract(piece(TypePion, Lin1, Col1, Statut,_)),
  asserta(piece(TypePion, Lin2, Col2, Statut, NewMarqueur)),
  miseAJourMove(TypePion, Lin1, Col1, Lin2, Col2, 'in', Board1, Board2), !.

rechercheMarqueur([T|_], (_, _, 1, Col), M) :- rechercheMarqueurDansLigne(T, Col, M).

rechercheMarqueur([_|Q], (_, _, Lin, Col), M) :- NLin is Lin-1,
                                                 rechercheMarqueur(Q, (_, _, NLin, Col), M).
/*On trouve la colonne*/
rechercheMarqueurDansLigne([(M, _)|_], 1,M).
rechercheMarqueurDansLigne([_|Q], Col, M) :- NCol is Col-1, rechercheMarqueurDansLigne(Q, NCol, M).

miseAJourMove(TypePion, Lin1, Col1, Lin2, Col2, 'in', Board1, Board3) :-
  miseAJourPlateau(TypePion, Lin1, Col1, 'out', Board1, Board2),
  miseAJourPlateau(TypePion, Lin2, Col2, 'in', Board2, Board3).

miseAJourPlateau(TypePion,Lin2,Col2,'in',Board1,Board2) :- remplacer(Board1, Lin2, Col2, TypePion, _, Board2).

miseAJourPlateau(_, Lin2, Col2, 'out', Board1, Board2) :- remplacer(Board1, Lin2, Col2, 'b', _, Board2).
