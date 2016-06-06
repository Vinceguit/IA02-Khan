/*possibleMoves permet d'obtenir le listing de tous les mouvements autorisés de la forme (Coldep,Lindep,Colarrivée,Linarrivée)*/
possibleMoves(Player,PossibleMoveList):- pion(_,_,_,'khan',Marqueur),
											   etablirEquipeActive(Player,Marqueur,PossibleMoveList).


/* Une pièce est activable si elle appartient à l'equipe, si elle est en jeu et si son marqueur est le même que celui du Khan*/
activable(X,Y,Equipe,Marqueur) :- pion(TypePion,X,Y,Ok,Marqueur),
								  findColour(TypePion, Equipe),
								  element(Ok,['in','khan']).

/*Renvoie l'ensemble des pions jouables*/								  
etablirEquipeActive(Equipe,Marqueur,PossibleMoveList) :- findall((Col,Lin),activable(Col,Lin,Equipe,Marqueur),ListeActivable),
										recherchePionParPion(ListeActivable,Marqueur,[],Equipe,PossibleMoveList).
    
/*Pour chaque pion jouable, une recherche de mouvement est lancée grâce au exploGraphe*/
recherchePionParPion([(ColInit,LinInit)|Q],I,L1,Equipe,PossibleMoveList) :- exploGraphe(I,L1,L2,Equipe,ColInit,LinInit,ColInit,LinInit),nl,
																
														   recherchePionParPion(Q,I,L2,Equipe,PossibleMoveList).
/* Une fois que tousles pions sont testés, on récupère la PossibleMoveList, sans doublons*/
recherchePionParPion([],_,PossibleMoveList,_,PossibleMoveList).

/*Pour la première recherche, l'exploration se fait dans toutes les directions*/
exploGraphe(I,L1,L5,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dir(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),
													   dir(haut,I,L4,L5,Equipe,ColInit,LinInit,Col,Lin),!.
													   
/* Si le mouvement est vers la gauche, on lance exploGrapheVersGauche, l'un des 4 exploGrapheVers_
Chaque prédicat exploGrapheVers_ interdit à la recherche de retourner en arrière 
pas de dir(droite,_,_,_,_,_,_,_) dans exploGrapheVersGauche)
L'exploration se fait sur une distance de Manhattan de I */
exploGrapheVersGauche(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dir(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
/* Une fois que la pièce a fait I mouvements, l'exploration est stoppée*/								  
exploGrapheVersGauche(0,_,_,_,_,_,_,_).

exploGrapheVersDroite(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dir(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
								  
exploGrapheVersDroite(0,_,_,_,_,_,_,_).

exploGrapheVersHaut(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   
													   dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
								  
exploGrapheVersHaut(0,_,_,_,_,_,_,_).

exploGrapheVersBas(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dir(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
								  
exploGrapheVersBas(0,_,_,_,_,_,_,_).

/* Pour I>1, on ne peut pas manger de pièce, on doit donc continuer l'exploration du plateau si la case est vide
Il est nécéssaire de vérifier que la pièce ne sort pas du plateau de jeu*/
								  
dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,I,Equipe),
													  NewI is I-1,
													  
													  exploGrapheVersGauche(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.
													  
/*Pour I=1, il est désormais possible de manger une pièce adverse
Dès Lors si la case est vide ou contient un ennemi, le mouvement est accepté dans L2
L2 est est une sous-partie de PossibleMoveList*/
dir(gauche,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,1,Equipe),
													  
													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.
/*Si la case est bloquée, pas de modification dans la liste d'entrée L
donc la liste de sortie de cette branche de l'exploration est aussi L */ 													  
dir(gauche,_,L,L,_,_,_,_,_).

dir(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col+1,
													  NewCol<7,
													  caseVide(NewCol,Lin,I,Equipe),
													  NewI is I-1,
													  exploGrapheVersDroite(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.


													  
dir(droite,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col+1,
													  NewCol<7,
													  caseVide(NewCol,Lin,1,Equipe),
													  
													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.	
													  
dir(droite,_,L,L,_,_,_,_,_).

dir(haut,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													NewLin is Lin-1,
													NewLin>0,
													caseVide(Col,NewLin,I,Equipe),
													NewI is I-1,
													
													exploGrapheVersHaut(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.
													  
dir(haut,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewLin is Lin-1,
											        NewLin>0,
													caseVide(Col,NewLin,1,Equipe),
													
													append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.	
dir(haut,_,L,L,_,_,_,_,_).													

dir(bas,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :-    I>1,
												      NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,I,Equipe),
													  NewI is I-1,
													  
													  exploGrapheVersBas(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.
													  
dir(bas,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- 
													  NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,1,Equipe),
													  
													  append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.
													  
dir(bas,_,L,L,_,_,_,_,_).
												

/*caseVide teste uniquement si la case est vide pour I>1
Une fois arrivé à I=1, au dernier mouvement, caseVide est vraie si la case est vide ou occupée par un ennemi */
											  
caseVide(X,Y,I,_) :- I>1, \+ pion(_,X,Y,in,_),\+ pion(_,X,Y,khan,_).
caseVide(X,Y,1,_) :- \+ pion(_,X,Y,in,_).
caseVide(X,Y,1,Equipe) :- pion(TypePion,X,Y,in,_), \+ findColour(TypePion,Equipe).
