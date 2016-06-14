/*legalMovesMinimax.pl est une variante de legalMoves.pl adaptée au prédicat de gestion des pion miniMaxPion, un prédicat temporaire utilisé dans les graphes de recherche*/

possibleMovesMiniMax(_,Player,PossibleMoveList):- miniMaxPion(_,_,_,'khan',Marqueur),
											   etablirEquipeActiveMiniMax(Player,Marqueur,PossibleMoveList),PossibleMoveList\=[],!.
possibleMovesMiniMax(Board,Player,PossibleMoveList):- otherPossibleMovesMiniMax(Board,Player,PossibleMoveList).
/*possibleMovesMiniMax(Player, KhanRespecte, PossibleMoveList):- miniMaxPion(_,_,_,'khan',Marqueur),
											   etablirEquipeActiveMiniMax(Player,Marqueur,PossibleMoveList)



Une pièce est activable si elle appartient à l'equipe, si elle est en jeu et si son marqueur est le même que celui du Khan*/
activableMiniMax(X,Y,Equipe,Marqueur) :- miniMaxPion(TypePion,X,Y,Ok,Marqueur),
								  findColour(TypePion, Equipe),
								  element(Ok,['in','khan']).

/*Renvoie l'ensemble des miniMaxPions jouables*/
etablirEquipeActiveMiniMax(Equipe,Marqueur,PossibleMoveList) :- findall((Col,Lin),activable(Col,Lin,Equipe,Marqueur),ListeActivable),ListeActivable\=[],
										recherchePionParPionMiniMax(ListeActivable,Marqueur,[],Equipe,PossibleMoveList).
etablirEquipeActiveMiniMax(_,_,[]).

/*Pour chaque miniMaxPion jouable, une recherche de mouvement est lancée grâce au exploGraphe*/
recherchePionParPionMiniMax([(ColInit,LinInit)|Q],I,L1,Equipe,PossibleMoveList) :- exploGrapheMiniMax(I,L1,L2,Equipe,ColInit,LinInit,ColInit,LinInit),

														   recherchePionParPionMiniMax(Q,I,L2,Equipe,PossibleMoveList).
/* Une fois que tousles miniMaxPions sont testés, on récupère la PossibleMoveList, sans doublons*/
recherchePionParPionMiniMax([],_,PossibleMoveList,_,PossibleMoveList).

/*Pour la première recherche, l'exploration se fait dans toutes les directions*/
exploGrapheMiniMax(I,L1,L5,Equipe,ColInit,LinInit,Col,Lin) :- dirMiniMax(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(haut,I,L4,L5,Equipe,ColInit,LinInit,Col,Lin),!.

/* Si le mouvement est vers la gauche, on lance exploGrapheVersGauche, l'un des 4 exploGrapheVers_
Chaque prédicat exploGrapheVers_ interdit à la recherche de retourner en arrière
pas de dir(droite,_,_,_,_,_,_,_) dans exploGrapheVersGauche)
L'exploration se fait sur une distance de Manhattan de I */
exploGrapheVersGaucheMiniMax(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dirMiniMax(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dirMiniMax(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dirMiniMax(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
/* Une fois que la pièce a fait I mouvements, l'exploration est stoppée*/
exploGrapheVersGaucheMiniMax(0,_,_,_,_,_,_,_).

exploGrapheVersDroiteMiniMax(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dirMiniMax(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dirMiniMax(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dirMiniMax(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.

exploGrapheVersDroiteMiniMax(0,_,_,_,_,_,_,_).

exploGrapheVersHautMiniMax(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dirMiniMax(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),

													   dirMiniMax(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.

exploGrapheVersHautMiniMax(0,_,_,_,_,_,_,_).

exploGrapheVersBasMiniMax(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dirMiniMax(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dirMiniMax(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.

exploGrapheVersBasMiniMax(0,_,_,_,_,_,_,_).

/* Pour I>1, on ne peut pas manger de pièce, on doit donc continuer l'exploration du plateau si la case est vide
Il est nécéssaire de vérifier que la pièce ne sort pas du plateau de jeu*/

dirMiniMax(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col-1,
													  NewCol>0,
													  caseVideMiniMax(NewCol,Lin,I,Equipe),
													  NewI is I-1,

													  exploGrapheVersGaucheMiniMax(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.

/*Pour I=1, il est désormais possible de manger une pièce adverse
Dès Lors si la case est vide ou contient un ennemi, le mouvement est accepté dans L2
L2 est est une sous-partie de PossibleMoveList*/
dirMiniMax(gauche,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col-1,
													  NewCol>0,
													  caseVideMiniMax(NewCol,Lin,1,Equipe),

													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.
/*Si la case est bloquée, pas de modification dans la liste d'entrée L
donc la liste de sortie de cette branche de l'exploration est aussi L */
dirMiniMax(gauche,_,L,L,_,_,_,_,_).

dirMiniMax(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col+1,
													  NewCol<7,
													  caseVideMiniMax(NewCol,Lin,I,Equipe),
													  NewI is I-1,
													  exploGrapheVersDroiteMiniMax(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.



dirMiniMax(droite,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col+1,
													  NewCol<7,
													  caseVideMiniMax(NewCol,Lin,1,Equipe),

													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.

dirMiniMax(droite,_,L,L,_,_,_,_,_).

dirMiniMax(haut,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													NewLin is Lin-1,
													NewLin>0,
													caseVideMiniMax(Col,NewLin,I,Equipe),
													NewI is I-1,

													exploGrapheVersHautMiniMax(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.

dirMiniMax(haut,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewLin is Lin-1,
											        NewLin>0,
													caseVideMiniMax(Col,NewLin,1,Equipe),

													append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.
dirMiniMax(haut,_,L,L,_,_,_,_,_).

dirMiniMax(bas,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :-    I>1,
												      NewLin is Lin+1,
													  NewLin<7,
													  caseVideMiniMax(Col,NewLin,I,Equipe),
													  NewI is I-1,

													  exploGrapheVersBasMiniMax(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.

dirMiniMax(bas,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :-
													  NewLin is Lin+1,
													  NewLin<7,
													  caseVideMiniMax(Col,NewLin,1,Equipe),

													  append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.

dirMiniMax(bas,_,L,L,_,_,_,_,_).


/*caseVide teste uniquement si la case est vide pour I>1
Une fois arrivé à I=1, au dernier mouvement, caseVide est vraie si la case est vide ou occupée par un ennemi */

caseVideMiniMax(X,Y,I,_) :- I>1, \+ miniMaxPion(_,X,Y,in,_),\+ miniMaxPion(_,X,Y,khan,_).
caseVideMiniMax(X,Y,1,_) :- \+ miniMaxPion(_,X,Y,in,_).
caseVideMiniMax(X,Y,1,Equipe) :- miniMaxPion(TypePion,X,Y,in,_), \+ findColour(TypePion,Equipe).


otherPossibleMovesMiniMax(Board,Player,PossibleMoveList):- miniMaxPion(_,_,_,'khan',Marqueur),
										   etablirEquipeActiveMiniMax(Player,1,L1),
										   etablirEquipeActiveMiniMax(Player,2,L2),
										   etablirEquipeActiveMiniMax(Player,3,L3),
										   
										   append(L1,L2,L), append(L,L3,ListeMouvementsLibres),
										   ajoutNouveauPionMiniMax(Board,Marqueur,ListeAjoutPion),
										   append(ListeMouvementsLibres,ListeAjoutPion,PossibleMoveList).
										   




ajoutNouveauPionMiniMax(Board, Marqueur,ListeAjoutPion) :- rechercheCaseDispo(Board,1,1, Marqueur,[],ListeAjoutPion).

rechercheCaseDispoMiniMax([T|Q],Col,Lin, M, L1,L3) :- Lin<7,NLin is Lin+1, rechercheCaseDispoDansLigneMiniMax(T,M,Col,Lin,L1,L2),
												 rechercheCaseDispoMiniMax(Q,Col,NLin,M,L2,L3),!.
rechercheCaseDispoMiniMax(_,_,7,_,L,L).

rechercheCaseDispoDansLigneMiniMax([(M, b)|Q], M,Col,Lin,L1,L3) :- Col<7, NCol is Col+1,append([(0,0,Col,Lin)],L1,L2),!, rechercheCaseDispoDansLigneMiniMax(Q, M,NCol,Lin,L2,L3).
rechercheCaseDispoDansLigneMiniMax([_|Q], M,Col,Lin,L1,L2) :- Col <7,NCol is Col+1,!, rechercheCaseDispoDansLigneMiniMax(Q,M,NCol,Lin,L1,L2),!.
rechercheCaseDispoDansLigneMiniMax([],_,7,_,L,L).
rechercheCaseDispoDansLigneMiniMax(_,_,7,_,L,L).
