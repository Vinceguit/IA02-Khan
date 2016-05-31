

possibleMoves(Board, Player, PossibleMoveList) :- element(Player, [rouge, ocre]).

:-dynamic(piece/5).

piece('r1',1,2,'in',3).
piece('o2',3,5,'in',2).
piece('r3',2,2,'in',1).
piece('o4',5,3,'in',2).

transfert(Board,Move) :-  presenceProie(Move,Board,NewBoard), rechercheMarqueur(NewBoard, Move,NewMarqueur),enregistrementMove(Move,NewMarqueur,NewBoard,NewNewBoard),print(NewNewBoard),!.
transfert(Board,Move) :-  rechercheMarqueur(Board, Move,NewMarqueur),enregistrementMove(Move,NewMarqueur,Board,_),!.
/* commande de test([[(2, b),(3, b)],[(2, b),(1, b)]],2,2,1,1,M).*/

presenceProie((_,_,Lin2,Col2),Board,NewBoard):- piece(TypePion,Lin2,Col2,'in',_),suppressionProie(TypePion,Lin2,Col2),miseAJourPlateau(TypePion,Lin2,Col2,'out',Board,NewBoard).
suppressionProie(TypePion,Lin,Col) :- retract(piece(_,Lin,Col,'in',_)),asserta(piece(TypePion,Lin,Col,'out',0)).
enregistrementMove((Lin1,Col1,Lin2,Col2),NewMarqueur,Board1,Board2):- retract(piece(TypePion,Lin1,Col1,Statut,_)),asserta(piece(TypePion,Lin2,Col2,Statut,NewMarqueur)),miseAJourPlateau(TypePion,Lin2,Col2,'in',Board1,Board2).   


rechercheMarqueur([T|_], (_,_,1, Col),M) :- rechercheMarqueurDansLigne(T, Col,M).
rechercheMarqueur([_|Q], (_,_,Lin, Col), M) :- NLin is Lin-1, rechercheMarqueur(Q, (_,_,NLin, Col),M).
/*On trouve la colonne*/
rechercheMarqueurDansLigne([(M, _)|_], 1,M).
rechercheMarqueurDansLigne([_|Q], Col, M) :- NCol is Col-1, rechercheMarqueurDansLigne(Q, NCol, M).


miseAJourPlateau(TypePion,Lin2,Col2,'in',Board1,Board2) :- replace(Board1,Lin2,Col2,TypePion,Board2), print(Board2).
miseAJourPlateau(_,Lin2,Col2,'out',Board1,Board2):- replace(Board1,Lin2,Col2,'b',Board2), print(Board2).

findColour(TypePion, rouge) :- element(TypePion, [kr, r1, r2, r3, r4, r5]), !.
findColour(TypePion, ocre) :- element(TypePion, [ko, o1, o2, o3, o4, o5]), !.

replace([T|Q], 1,Col, X, [T|Q]):- replaceDansLigne(T,Col,X,T).
replace([_|Q], Lin,Col, X,[_|Q]):- NLin is Lin-1, replace(Q, NLin,Col, X, Q), !.
replaceDansLigne([(A,_)|T],1, X, [(A,X)|T]).
replaceDansLigne([H|T],Col, X, [H|R]):- NCol is Col-1, replace(T, NCol, X, R), !.


VincentBaheuxFaitDuSkiEnSlip.