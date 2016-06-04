/************************/
/*Gestion des mouvements*/
/************************/

/*Gros du boulot*/
possibleMoves(Board, Player, PossibleMoveList) :- element(Player, [rouge, ocre]).

/*Prédicat de pion : pion(IdPion, Col, Lin, in, IdCase)*/

/*Procedure de mise à jour de tous les effets d'un mouvement sur le plateau et sur les pieces sur la BDD du jeu*/
transfert(InBoard,Move,OutBoard) :- presenceProie(Move ,InBoard, NewBoard),
                                    rechercheMarqueur(NewBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, NewBoard, OutBoard),
                                    afficherPlateau(OutBoard), !.

transfert(InBoard,Move,OutBoard) :- rechercheMarqueur(InBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, InBoard, OutBoard), !.

presenceProie((Lin1, Col1, Lin2, Col2), Board, NewBoard) :-
  pion(_, Col1, Lin1, 'in', _),
  pion(TypePion, Col2, Lin2, 'in', _),
  suppressionProie(TypePion, Col2, Lin2),
  miseAJourPlateau(TypePion, Col2, Lin2, 'out', Board, NewBoard).

suppressionProie(TypePion,Lin,Col) :- retract(pion(TypePion, Col, Lin, 'in', _)),
                                      asserta(pion(TypePion, Col, Lin, 'out', 0)).

enregistrementMove((Lin1, Col1, Lin2, Col2), NewMarqueur, Board1, Board2) :-
  retract(pion(TypePion, Col1, Lin1, Statut,_)),
  asserta(pion(TypePion, Col2, Lin2, Statut, NewMarqueur)),
  miseAJourMove(TypePion, Lin1, Col1, Lin2, Col2, 'in', Board1, Board2), !.

rechercheMarqueur([T|_], (_, _, 1, Col), M) :- rechercheMarqueurDansLigne(T, Col, M).

rechercheMarqueur([_|Q], (_, _, Lin, Col), M) :- NLin is Lin-1,
                                                 rechercheMarqueur(Q, (_, _, NLin, Col), M).
/*On trouve la colonne*/
rechercheMarqueurDansLigne([(M, _)|_], 1,M).
rechercheMarqueurDansLigne([_|Q], Col, M) :- NCol is Col-1, rechercheMarqueurDansLigne(Q, NCol, M).

miseAJourMove(TypePion, Lin1, Col1, Lin2, Col2, 'in', Board1, Board3) :-
  miseAJourPlateau(TypePion, Lin1, Col1, 'out', Board1, Board2),
  miseAJourPlateau(TypePion, Lin2, Col2, 'in', Board2, Board3),
	setKhan(TypePion).

miseAJourPlateau(TypePion,Lin2,Col2,'in',Board1,Board2) :-
  remplacer(Board1, Lin2, Col2, TypePion, _, Board2),
  afficherPlateau(Board2).

miseAJourPlateau(_, Lin2, Col2, 'out', Board1, Board2) :-
  remplacer(Board1, Lin2, Col2, 'b', _, Board2),
  afficherPlateau(Board2).
