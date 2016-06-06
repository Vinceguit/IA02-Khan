
possibleMoves(Player,PossibleMoveList):- pion(_,_,_,'khan',Marqueur),
											   etablirEquipeActive(Player,Marqueur,PossibleMoveList).



activable(X,Y,Equipe,Marqueur) :- pion(TypePion,X,Y,Ok,Marqueur),
								  findColour(TypePion, Equipe),
								  element(Ok,['in','khan']).
									 
etablirEquipeActive(Equipe,Marqueur,PossibleMoveList) :- findall((Col,Lin),activable(Col,Lin,Equipe,Marqueur),ListeActivable),print(ListeActivable),
										recherchePionParPion(ListeActivable,Marqueur,[],Equipe,PossibleMoveList).
    

recherchePionParPion([(ColInit,LinInit)|Q],I,L1,Equipe,PossibleMoveList) :- exploGraphe(I,L1,L2,Equipe,ColInit,LinInit,ColInit,LinInit),nl,
																
														   recherchePionParPion(Q,I,L2,Equipe,PossibleMoveList).
recherchePionParPion([],_,PossibleMoveList,_,PossibleMoveList).

exploGraphe(I,L1,L5,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dir(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),
													   dir(haut,I,L4,L5,Equipe,ColInit,LinInit,Col,Lin),!.
													   

exploGrapheVersGauche(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dir(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin),!.
								  
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
								  
dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- write(I),write('gauche'),I>1,
													  NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,I,Equipe),
													  NewI is I-1,
													  
													  exploGrapheVersGauche(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.
													  
dir(gauche,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,1,Equipe),
													  write((ColInit,LinInit,NewCol,Lin)),
													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.	
dir(gauche,_,L,L,_,_,_,_,_).

dir(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- write(I),write('droite'),I>1,
													  NewCol is Col+1,
													  NewCol<7,
													  caseVide(NewCol,Lin,I,Equipe),
													  NewI is I-1,
													  exploGrapheVersDroite(NewI,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin),!.


													  
dir(droite,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col+1,
													  NewCol<7,
													  caseVide(NewCol,Lin,1,Equipe),
													  write((ColInit,LinInit,NewCol,Lin)),
													  append([(ColInit,LinInit,NewCol,Lin)],L1,L2),!.	
													  
dir(droite,_,L,L,_,_,_,_,_).

dir(haut,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- write(I),write('haut'),I>1,
													NewLin is Lin-1,
													NewLin>0,
													caseVide(Col,NewLin,I,Equipe),
													NewI is I-1,
													
													exploGrapheVersHaut(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.
													  
dir(haut,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewLin is Lin-1,
											        NewLin>0,
													caseVide(Col,NewLin,1,Equipe),
													write((ColInit,LinInit,Col,NewLin)),
													append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.	
dir(haut,_,L,L,_,_,_,_,_).													

dir(bas,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :-    write(I),write('bas'),I>1,
												      NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,I,Equipe),
													  NewI is I-1,
													  
													  exploGrapheVersBas(NewI,L1,L2,Equipe,ColInit,LinInit,Col,NewLin),!.
													  
dir(bas,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- 
													  NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,1,Equipe),
													  write((ColInit,LinInit,Col,NewLin)),
													  append([(ColInit,LinInit,Col,NewLin)],L1,L2),!.
													  
dir(bas,_,L,L,_,_,_,_,_).
												


											  
caseVide(X,Y,I,_) :- I>1, \+ pion(_,X,Y,in,_),\+ pion(_,X,Y,khan,_).
caseVide(X,Y,1,_) :- \+ pion(_,X,Y,in,_).
caseVide(X,Y,1,Equipe) :- pion(TypePion,X,Y,in,_), \+ findColour(TypePion,Equipe).
