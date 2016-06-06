/************************/
/*Gestion des mouvements*/
/************************/

/*Gros du boulot*/

/*transfert([[(2, b),(3, r1)],[(2, b),(1, o3)]],(1,1,2,1),NewBoard) --> [[(2,b),(3,r1)],[(2,r1),(1,o3)]].*/
/*Prédicat de pion : pion(IdPion, Col, Lin, in, IdCase)/

/*Procedure de mise à jour de tous les effets d'un mouvement sur le plateau et sur les pieces sur la BDD du jeu*/
transfert(InBoard,Move,OutBoard) :- presenceProie(Move ,InBoard, NewBoard), !,
                                    rechercheMarqueur(NewBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, NewBoard, OutBoard),
                                    print('Pièce adverse capturée !'), nl.

transfert(InBoard,Move,OutBoard) :- rechercheMarqueur(InBoard, Move, NewMarqueur),
                                    enregistrementMove(Move, NewMarqueur, InBoard, OutBoard).

presenceProie((_, _, Col2, Lin2), Board, NewBoard) :- pion(TypePion, Col2, Lin2, 'in', _),
                                                            suppressionProie(TypePion, Col2, Lin2),
                                                            miseAJourPlateau(TypePion, Col2, Lin2, 'out', Board, NewBoard).
															
presenceProie((_, _, Col2, Lin2), Board, NewBoard) :- pion(TypePion, Col2, Lin2, 'khan', _),
                                                            suppressionProie(TypePion, Col2, Lin2),
                                                            miseAJourPlateau(TypePion, Col2, Lin2, 'out', Board, NewBoard).

suppressionProie(TypePion,Col,Lin) :- retract(pion(TypePion, Col, Lin, _, _)),
                                      asserta(pion(TypePion,0,0, 'out', 0)).

enregistrementMove((Col1, Lin1, Col2, Lin2), NewMarqueur, Board1, Board2) :- pion(TypePion, Col1, Lin1, 'in', M),
                                                                             retract(pion(TypePion, _, _,_,M)),
                                                                             asserta(pion(TypePion, Col2, Lin2, 'khan', NewMarqueur)),
                                                                             miseAJourMove(TypePion, Col1, Lin1, Col2, Lin2, 'in', Board1, Board2).



miseAJourMove(TypePion, Col1,Lin1, Col2, Lin2, 'in', Board1, Board3) :- miseAJourPlateau(TypePion, Col1, Lin1, 'out', Board1, Board2),
                                                                        miseAJourPlateau(TypePion, Col2, Lin2, 'in', Board2, Board3).

miseAJourPlateau(TypePion,Col2,Lin2,'in',Board1,Board2) :- remplacer(Board1, Col2, Lin2, TypePion, _, Board2).
miseAJourPlateau(_, Col1, Lin1, 'out', Board1, Board2) :- remplacer(Board1, Col1, Lin1, b, _, Board2).
