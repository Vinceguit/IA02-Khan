

/**Calcul de la fonction heuristique**/
/*On maximise pour l'IA; on minimise pour son adversaire*/


								
heuristic(Board,Colour,V9) :- listingPionsEquipe(Board,Colour,1,1,[],Lequipe),
								oppPlayer(Colour,Ennemi),
								listingPionsEquipe(Board,Ennemi,1,1,[],Lennemie),
								listingKalistas(Board,Colour,1,1, ((0,0),(0,0)),(KA,KE)),
								nbSbiresAlliesEnJeu(0.2,Lequipe,0,V2),print(V2),nl,
								nbSbiresEnnemisEnJeu(0.2,Lennemie,V2,V3),print(V3), nl,
								distanceSbiresKalista(0.2,KE,Lequipe,V3,V5),print(V5),nl,
								defenseKalistaAlliee(0.2,Lequipe,KA,V5,V6),print(V6),nl,
								defenseKalistaEnnemie(0.2,Lennemie,KE,V6,V7),print(V7),nl,
								gagne(Lennemie,Colour,V7,V8),
								perdu(Lequipe,Colour,V8,V9),write('Heuristique de '), print(V9),
								
								print(Ennemi),nl,
								print(Lequipe),nl,
								print(Lennemie),nl,
								print(KA),nl,
								print(KE),nl.

/* Ce coup passe à 100 si le joueur a gagné*/
gagne(L,rouge,_,Vb):- \+ element((_,_,ko),L),Vb is 100,!.
gagne(L,ocre,_,Vb):- \+ element((_,_,kr),L),Vb is 100,!.

gagne(_,_,V,V).
/*Ce coup passeà -100 si le joueur a perdu*/
perdu(L,rouge,_,Vb):- \+element((_,_,kr),L),Vb is 0,!.
perdu(L,ocre,_,Vb):- \+element((_,_,ko),L),Vb is 0,!.
perdu(_,_,V,V).


/* Cette heuristique cherche à laisser le plus souvent possible 4 pièces à l'ennemi, kalista comprise*/
nbSbiresEnnemisEnJeu(Coeff,L,Va,Vb):-longueur(V,L),
									 calculNbSbiresEnnemis(Coeff,Va,Vb,V).

nbSbiresAlliesEnJeu(Coeff,L,Va,Vb):- longueur(V,L),
									 calculNbSbiresAllies(Coeff,Va,Vb,V).
/* Determine le nombre de pions dans l'équipe adverse*/
listingPionsEquipe([T|Q],Colour,Col,Lin, V1,V3) :- Lin<7,NLin is Lin+1, listingPionsEquipeDansLigne(T,Colour,Col,Lin,V1,V2),
												 listingPionsEquipe(Q,Colour,Col,NLin,V2,V3),!.
listingPionsEquipe(_,_,_,7,V,V).

listingPionsEquipeDansLigne([(_, Pion)|Q], Colour,Col,Lin,V1,V3) :- Col<7, NCol is Col+1,findColour(Pion,Colour),append([(Col,Lin,Pion)],V1,V2),!, listingPionsEquipeDansLigne(Q, Colour,NCol,Lin,V2,V3).
listingPionsEquipeDansLigne([_|Q], Colour,Col,Lin,V1,V2) :- Col <7,NCol is Col+1,!, listingPionsEquipeDansLigne(Q,Colour,NCol,Lin,V1,V2),!.
listingPionsEquipeDansLigne([],_,7,_,V,V).
listingPionsEquipeDansLigne(_,_,7,_,V,V).

/*Determine le nombre de mouvements possibles susceptibles de supprimer des pièces adverses*/

nbPositionAttaque(Coeff,Colour,Board,Lennemi,V1,V2) :- possibleMoves(Board,Colour,PossibleMoveList),
															  findall((Col1,Lin1,Col2,Lin2),menacePion((Col1,Lin1,Col2,Lin2),PossibleMoveList,Lennemi),ListeMenaces),
															  longueur(L,ListeMenaces),
															  calculNbPositionAttaque(Coeff,V1,V2,L).

menacePion((Col1,Lin1,Col2,Lin2),PossibleMoveList,Lennemi) :- element((Col1,Lin1,Col2,Lin2),PossibleMoveList),element((Col2,Lin2,_),Lennemi).
/* Determine le nombre de mouvements adverses susceptibles de supprimer ses pièces*/
nbPositionVictime(Coeff,Colour,Board,Lequipe,V1,V2) :- possibleMoves(Board,Colour,PossibleMoveList),
															  findall((Col1,Lin1,Col2,Lin2),menacePion((Col1,Lin1,Col2,Lin2),PossibleMoveList,Lequipe),ListeMenaces),
															  longueur(L,ListeMenaces),
															  calculNbPositionVictime(Coeff,V1,V2,L).
															  
/*Recherche de la position des kalistas
listingKalistas(Board,Colour,1,1, ((0,0),(0,0)),(KA,KE)).*/
listingKalistas([T|Q],Colour,Col,Lin,(KAin,KEin),(KAout,KEout)) :- Lin<7,NLin is Lin+1, listingKalistasDansLigne(T,Colour,Col,Lin,(KAin,KEin),(KA2,KE2)),
												 listingKalistas(Q,Colour,Col,NLin,(KA2,KE2),(KAout,KEout)),!.
listingKalistas(_,_,_,7,(K1,K2),(K1,K2)):- print(K1),nl,print(K2).

listingKalistasDansLigne([(_, ko)|Q], ocre,Col,Lin,(_,KalistaEnnemie),(KA,KE)) :- Col<7, NCol is Col+1,!, listingKalistasDansLigne(Q, ocre,NCol,Lin,((Col,Lin),KalistaEnnemie),(KA,KE)),!.
listingKalistasDansLigne([(_, kr)|Q], rouge,Col,Lin,(_,KalistaEnnemie),(KA,KE)) :- Col<7, NCol is Col+1,!, listingKalistasDansLigne(Q, rouge,NCol,Lin,((Col,Lin),KalistaEnnemie),(KA,KE)),!.
listingKalistasDansLigne([(_, ko)|Q], rouge,Col,Lin,(KalistaAlliee,_),(KA,KE)) :- Col<7, NCol is Col+1,!, listingKalistasDansLigne(Q, rouge,NCol,Lin,(KalistaAlliee,(Col,Lin)),(KA,KE)),!.
listingKalistasDansLigne([(_, kr)|Q], ocre,Col,Lin,(KalistaAlliee,_),(KA,KE)) :- Col<7, NCol is Col+1,!, listingKalistasDansLigne(Q, ocre,NCol,Lin,(KalistaAlliee,(Col,Lin)),(KA,KE)),!.
listingKalistasDansLigne([_|Q], Colour,Col,Lin,(K1,K2),(K3,K4)) :- Col <7,NCol is Col+1,!, listingKalistasDansLigne(Q,Colour,NCol,Lin,(K1,K2),(K3,K4)),!.
listingKalistasDansLigne(_,_,7,_,(K1,K2),(K1,K2)).
															  
/*Recherche du nombre de sbires autour de la Kalista*/

defenseKalistaAlliee(Coeff,ListePion,(Col,Lin),Va,Vb) :- ColA is Col+1,defenseur((ColA,Lin),ListePion,0,V2),
												 ColB is Col-1,defenseur((ColB,Lin),ListePion,V2,V3),
												 LinA is Lin+1,defenseur((Col,LinA),ListePion,V3,V4),
												 LinB is Lin-1,defenseur((Col,LinB),ListePion,V4,V5),
												 calculDefenseKalistaAlliee(Coeff,Va,Vb,V5).
												 
defenseKalistaEnnemie(Coeff,ListePion,(Col,Lin),Va,Vb) :- ColA is Col+1,defenseur((ColA,Lin),ListePion,0,V2),
												 ColB is Col-1,defenseur((ColB,Lin),ListePion,V2,V3),
												 LinA is Lin+1,defenseur((Col,LinA),ListePion,V3,V4),
												 LinB is Lin-1,defenseur((Col,LinB),ListePion,V4,V5),
												 calculDefenseKalistaEnnemie(Coeff,Va,Vb,V5).
												 
defenseur((Col,Lin),ListePion,Va,Vb) :- element((Col,Lin,_),ListePion), Vb is Va+1,!.
defenseur(_,_,V,V).

distanceSbiresKalista(Coeff,(ColK,LinK),Lequipe,Va,Vb):- findall((Col,Lin),distanceDeuxCases(Lequipe,Col,Lin,ColK,LinK),ListePionsACote),
														 longueur(L,ListePionsACote),
														 calculDistanceSbireKalista(Coeff,Va,Vb,L).
														 
distanceDeuxCases(Lequipe,Col,Lin,ColK,LinK):- element((Col,Lin,_),Lequipe),Col=<ColK+2,Col>=ColK-2,
												Lin>=LinK-2,Lin=<LinK+2,!.
/*Listing des calculs d'heuristiques*/

calculDefenseKalistaAlliee(Coeff,Va,Vb,NbDefenseurs):- Vb is Va+Coeff*NbDefenseurs*100*0.25.
														 
calculDefenseKalistaEnnemie(Coeff,Va,Vb,NbDefenseurs):-Vb is Va+Coeff*(4-NbDefenseurs)*100*0.25.

calculDistanceSbireKalista(Coeff,Va,Vb,L):- Vb is Va+Coeff*L*100/6.

calculNbSbiresEnnemis(Coeff,Va,Vb,1):- Vb is Va+Coeff*(0),!.
calculNbSbiresEnnemis(Coeff,Va,Vb,2):- Vb is Va+Coeff*(33),!.
calculNbSbiresEnnemis(Coeff,Va,Vb,3):- Vb is Va+Coeff*(66),!.
calculNbSbiresEnnemis(Coeff,Va,Vb,4):- Vb is Va+Coeff*(100),!.
calculNbSbiresEnnemis(Coeff,Va,Vb,5):- Vb is Va+Coeff*(50),!.
calculNbSbiresEnnemis(Coeff,Va,Vb,6):- Vb is Va+Coeff*(0),!.

calculNbSbiresAllies(Coeff,Va,Vb,V):- Vb is Va+Coeff*V.

calculNbPositionAttaque(Coeff,Va,Vb,L) :- Vb is Va+Coeff*L*100/15,Vb < Va+Coeff*100,!.
calculNbPositionAttaque(Coeff,Va,Vb,_) :- Vb is Va+Coeff*100.

calculNbPositionVictime(Coeff,Va,Vb,L) :-Vb is Va+Coeff*(15-L)*100/15,Vb>Va+Coeff*100,!.
calculNbPositionVictime(Coeff,Va,Vb,_) :- Vb is Va+Coeff*100.