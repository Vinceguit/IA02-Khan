/************************/
/*Gestion des mouvements*/
/************************/

/*Gros du boulot*/
possibleMoves(Board, Player, PossibleMoveList) :- element(Player, [rouge, ocre]).
/*transfert([[(2, b),(3, r1)],[(2, b),(1, o3)]],(1,1,2,1),NewBoard) --> [[(2,b),(3,r1)],[(2,r1),(1,o3)]].*/
/*Prédicat de pion : pion(IdPion, Col, Lin, in, IdCase)/

/*Procedure de mise à jour de tous les effets d'un mouvement sur le plateau et sur les pieces sur la BDD du jeu*/
transfert(InBoard,Move,OutBoard) :- print('Il y avait une proie'),
presenceProie(Move ,InBoard, NewBoard),!,
                                    rechercheMarqueur(NewBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, NewBoard, OutBoard),
                                    afficherPlateau(OutBoard).

transfert(InBoard,Move,OutBoard) :- rechercheMarqueur(InBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, InBoard, OutBoard), !.

presenceProie((Col1, Lin1, Col2, Lin2), Board, NewBoard) :-
  
  pion(TypePion, Col2, Lin2, 'in', _),
  suppressionProie(TypePion, Col2, Lin2),
  miseAJourPlateau(TypePion, Col2, Lin2, 'out', Board, NewBoard).

suppressionProie(TypePion,Col,Lin) :- retract(pion(TypePion, Col, Lin, 'in', _)),
                                      asserta(pion(TypePion, Col, Lin, 'out', 0)).

enregistrementMove((Col1, Lin1, Col2, Lin2), NewMarqueur, Board1, Board2) :-
  pion(TypePion,Col1,Lin1,'in',M),
  retract(pion(TypePion, Col1, Lin1, 'in',M)),
  asserta(pion(TypePion, Col2, Lin2, 'in', NewMarqueur)),
  miseAJourMove(TypePion, Col1, Lin1, Col2, Lin2, 'in', Board1, Board2), !.

rechercheMarqueur([T|_], (_, _, Col, 1), M) :- rechercheMarqueurDansLigne(T, Col, M).

rechercheMarqueur([_|Q], (_, _, Col, Lin), M) :- NLin is Lin-1,
                                                 rechercheMarqueur(Q, (_, _, Col, NLin), M).
/*On trouve la colonne*/
rechercheMarqueurDansLigne([(M, _)|_], 1,M).
rechercheMarqueurDansLigne([_|Q], Col, M) :- NCol is Col-1, rechercheMarqueurDansLigne(Q, NCol, M).

miseAJourMove(TypePion, Col1,Lin1, Col2, Lin2, 'in', Board1, Board3) :-
  miseAJourPlateau(TypePion, Col1, Lin1, 'out', Board1, Board2),
  miseAJourPlateau(TypePion, Col2, Lin2, 'in', Board2, Board3),
	setKhan(TypePion).

miseAJourPlateau(TypePion,Col2,Lin2,'in',Board1,Board2) :-
  remplacer(Board1, Col2, Lin2, TypePion, _, Board2),
  afficherPlateau(Board2).

miseAJourPlateau(_, Col2, Lin2, 'out', Board1, Board2) :-
  remplacer(Board1, Col2, Lin2, 'b', _, Board2),
  afficherPlateau(Board2).
  
