/************************/
/*Gestion des mouvements*/
/************************/

/*Gros du boulot*/

/*transfert([[(2, b),(3, r1)],[(2, b),(1, o3)]],(1,1,2,1),NewBoard) --> [[(2,b),(3,r1)],[(2,r1),(1,o3)]].*/
/*Prédicat de pion : pion(IdPion, Col, Lin, in, IdCase)/

/*Procedure de mise à jour de tous les effets d'un mouvement sur le plateau et sur les pieces sur la BDD du jeu

Cas 1: Le mouvement saisi fait arriver la pièce sur une case occupée par une pièce ennemie*/

transfertMiniMax(InBoard,Move,Pion,OutBoard) :-
									presenceProieMiniMax(Move ,InBoard, NewBoard), !,
									/* On cherche le nouveau marqueur (1,2 ou 3) associé à la position d'arrivée*/
                                    rechercheMarqueur(NewBoard, Move, NewMarqueur),
									/*On vient faire toutes les modifications pour modifier les infos dans la BDD*/
                                    enregistrementMoveMiniMax(Move, NewMarqueur, Pion, NewBoard, OutBoard).

/* Cas 2: La case d'arrivée est vide*/
transfertMiniMax(InBoard,Move,Pion,OutBoard) :-  rechercheMarqueur(InBoard, Move, NewMarqueur),
                                    enregistrementMoveMiniMax(Move, NewMarqueur,Pion, InBoard, OutBoard).

/* La pièce bougée change de position et devient le khan*/
enregistrementMoveMiniMax((Col1, Lin1, Col2, Lin2), NewMarqueur, Pion, Board1, Board2) :-
	retract(miniMaxPion(TypePionKhan, ColKhan, LinKhan,khan,MKhan)),
	asserta(miniMaxPion(TypePionKhan, ColKhan, LinKhan, in, MKhan)),
	retract(miniMaxPion(Pion,_, _,_,_)),
	asserta(miniMaxPion(Pion, Col2, Lin2, khan, NewMarqueur)),
	miseAJourMoveMiniMax(Pion, Col1, Lin1, Col2, Lin2, 'in', Board1, Board2),!.

enregistrementMoveMiniMax((Col1, Lin1, Col2, Lin2), NewMarqueur, Pion, Board1, Board2) :-
  retract(miniMaxPion(Pion, _, _,_,_)),
	asserta(miniMaxPion(Pion, Col2, Lin2, khan, NewMarqueur)),
	miseAJourMoveMiniMax(Pion, Col1, Lin1, Col2, Lin2, 'in', Board1, Board2),!.


/* Suppression de la pièce présente au point de chute de la pièce bougée*/
presenceProieMiniMax((_, _, Col2, Lin2), Board, NewBoard) :- miniMaxPion(TypePion, Col2, Lin2, 'in', _),
                                                            suppressionProieMiniMax(TypePion, Col2, Lin2),
                                                            miseAJourPlateauMiniMax(TypePion, Col2, Lin2, 'out', Board, NewBoard).

presenceProieMiniMax((_, _, Col2, Lin2), Board, NewBoard) :- miniMaxPion(TypePion, Col2, Lin2, 'khan', _),
                                                            suppressionProieMiniMax(TypePion, Col2, Lin2),
                                                            miseAJourPlateauMiniMax(TypePion, Col2, Lin2, 'out', Board, NewBoard).

/*Passage de la pièce de in à out*/
suppressionProieMiniMax(TypePion,Col,Lin) :- retract(miniMaxPion(TypePion, Col, Lin, _, _)),
                                      asserta(miniMaxPion(TypePion,0,0, 'out', 0)).



/* Remplacement des pièces sur le plateau de jeu ASCII*/
miseAJourMoveMiniMax(TypePion, Col1,Lin1, Col2, Lin2, 'in', Board1, Board3) :- miseAJourPlateauMiniMax(TypePion, Col1, Lin1, 'out', Board1, Board2),
                                                                        miseAJourPlateauMiniMax(TypePion, Col2, Lin2, 'in', Board2, Board3).

miseAJourPlateauMiniMax(TypePion,Col2,Lin2,'in',Board1,Board2) :- remplacer(Board1, Col2, Lin2, TypePion, _, Board2).
miseAJourPlateauMiniMax(_,0,0,'out',B,B).
miseAJourPlateauMiniMax(_, Col1, Lin1, 'out', Board1, Board2) :- remplacer(Board1, Col1, Lin1, b, _, Board2).
