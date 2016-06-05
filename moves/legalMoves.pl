

activable(X,Y,Equipe,Marqueur) :- membreEquipe(Equipe,X,Y),
findColour(TypePion, Equipe),
									 pion(TypePion,X,Y,Ok,Marqueur),
									 element(Ok,['in','khan']).
									 
etablirEquipeActive(Equipe,Marqueur) :- setof((Col,Lin),activable(Col,Lin,Equipe,Marqueur),listeActivable),
										recherchePionParPion(listeActivable,[],PossibleMoveList,Marqueur,Equipe),
                                        demandeChoixMove(PossibleMoveList).

recherchePionParPion([(Col,Lin)|Q],I,L1,L3,Equipe) :- exploGraphe(Col,Lin,I,L1,L2,Equipe),
													recherchePionParPion(Q,I,L2,L3,Equipe).
recherchePionParPion([],_,_,_,_).

exploGrapheVersGauche(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dir(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin).
								  
exploGrapheVersGauche(_,_,0,_,_,_).

exploGrapheVersDroite(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
																 dir(bas,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
																 dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin).
								  
exploGrapheVersDroite(_,_,0,_,_,_).

exploGrapheVersHaut(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   
													   dir(haut,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin).
								  
exploGrapheVersHaut(_,_,0,_,_,_).

exploGrapheVersBas(I,L1,L4,Equipe,ColInit,LinInit,Col,Lin) :- dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin),
													   dir(droite,I,L2,L3,Equipe,ColInit,LinInit,Col,Lin),
													   dir(bas,I,L3,L4,Equipe,ColInit,LinInit,Col,Lin).
								  
exploGrapheVersBas(_,_,0,_,_,_).
								  
dir(gauche,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,I,Equipe),
													  exploGrapheVersGauche(I,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin).
													  
dir(gauche,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col-1,
													  NewCol>0,
													  caseVide(NewCol,Lin,1,Equipe),
													  append((ColInit,LinInit,NewCol,Lin),L1,L2).	

dir(droite,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													  NewCol is Col+1,
													  NewCol<7,
													  caseVide(NewCol,Lin,I,Equipe),
													  exploGrapheVersDroite(I,L1,L2,Equipe,ColInit,LinInit,NewCol,Lin).
													  
dir(droite,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewCol is Col-1,
													  NewCol<7,
													  caseVide(NewCol,Lin,1,Equipe),
													  
													  append((ColInit,LinInit,NewCol,Lin),L1,L2).	

dir(haut,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- I>1,
													NewLin is Lin-1,
													NewLin>0,
													caseVide(Col,NewLin,I,Equipe),
													exploGrapheVersHaut(I,L1,L2,Equipe,ColInit,LinInit,Col,NewLin).
													  
dir(haut,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- NewLin is Lin-1,
											        NewLin>0,
													caseVide(Col,NewLin,1,Equipe),
													append((ColInit,LinInit,Col,NewLin),L1,L2).												  

dir(bas,I,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :-    I>1,
												      NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,I,Equipe),
													  exploGrapheVersBas(I,L1,L2,Equipe,ColInit,LinInit,Col,NewLin).
													  
dir(bas,1,L1,L2,Equipe,ColInit,LinInit,Col,Lin) :- 
													  NewLin is Lin+1,
													  NewLin<7,
													  caseVide(Col,NewLin,1,Equipe),
													  append((ColInit,LinInit,Col,NewLin),L1,L2).
													  
caseVide(X,Y,I,_) :- I>1, not(pion(_,X,Y,Ok,_)),element(Ok,['in','khan']).
caseVide(X,Y,1,Equipe) :- not(pion(Equipe,X,Y,Ok,_)), element(Equipe,'rouge'), element(Ok,['in','khan']).

demandeChoixMove(PossibleMoveList) :- write('Quel mouvement wesh ?'),read(Move), element(Move,PossibleMoveList),write('ok'),!.
demandeChoixMove(PossibleMoveList) :- demandeChoixMove(PossibleMoveList).